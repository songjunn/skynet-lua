#!/usr/bin/python
# -*- coding: UTF-8 -*-

import xlrd, re, json, os, codecs, sys
from collections import OrderedDict

sourcePath = os.path.abspath(os.path.join(os.path.dirname(__file__), "../config"))
jsonPath = os.path.abspath(os.path.join(os.path.dirname(__file__),"../data"))

print (sourcePath)

typeIdx = 0
nameIdx = 1
commentIdx = 2
dataIdx = 3

def XlsToTxt( filePath, savePath ):
	print( 'filePath: ' + filePath + ' savePath: ' + savePath )
	data = xlrd.open_workbook( filePath )
	table = data.sheet_by_index( 0 )

	text = ''
	for i in range( table.ncols ):
		value = table.cell(typeIdx, i).value
		if isinstance(value, unicode):
			text += value.encode('unicode-escape').decode('string_escape')
		else:
			text += str(int(value))
		text += '\t'
	text += '\r\n'

	for i in range( table.ncols ):
		value = table.cell(nameIdx, i).value
		if isinstance(value, unicode):
			text += value.encode('unicode-escape').decode('string_escape')
		else:
			text += str(int(value))
		text += '\t'
	text += '\r\n'

	for r in range( dataIdx, table.nrows ):
		#print('curr row:'+str(r))
		line = ''
		for i in range( table.ncols ):
			#print('curr col:'+str(i))
			value = table.cell(r, i).value
			if isinstance(value, unicode) or value == '':
				line += value.encode('unicode-escape').decode('string_escape')
				#line += value.encode('unicode-escape')
				#line += value.encode('utf-8')
			else:
				line += str(int(value))
			line += '\t'
		line += '\r\n'
		#print(line)
		text += line
	#print('text:', text)

	outFile = codecs.open( savePath, 'w', 'utf-8' )
	outFile.write(text.decode('unicode-escape'))

def XlsToJson(filePath):
	wb = xlrd.open_workbook(filePath)

	convert_list = {}
	sh = wb.sheet_by_index(0)
	title = sh.row_values(nameIdx)
	for rownum in range(dataIdx, sh.nrows):
		rowvalue = sh.row_values(rownum)
		single = OrderedDict()

		if isinstance(rowvalue[0], float):
			id = int(rowvalue[0])
		else:
			id = rowvalue[0]
			
		for colnum in range(0, len(rowvalue)):
			if (title[colnum] == ''): continue
			value = rowvalue[colnum]
			
			if isinstance(value, float):
				if int(value) == value:
					single[title[colnum]] = int(value)
				else:
					single[title[colnum]] = float(value)
			else:
				single[title[colnum]] = value

		convert_list[id] = single

	return convert_list;

def saveToJson( filePath, savePath ):
	print( 'filePath: ' + filePath + ' savePath: ' + savePath )
	outFile = codecs.open( savePath, 'w', 'utf-8' )
	xlsInfo = XlsToJson(filePath)
	json.dump( xlsInfo, outFile, ensure_ascii=False, indent = 4, sort_keys = True)
	outFile.write('\n')

def saveToJs(filePath, savePath):
	print(filePath)
	xlsInfo = XlsToJson(filePath)

	content = 'module.exports = ';
	content += json.dumps(xlsInfo, ensure_ascii=False, indent = 4, sort_keys = True)
	content += ';\n';

	outFile = codecs.open( savePath, 'w', 'utf-8' )
	outFile.write(content)


for root, dirs, files in os.walk( sourcePath ):
	for file in files:
		if file.startswith( '~$' ):
			continue
		if file.endswith('.xls'):
			saveToJson( os.path.join( root, file ), os.path.join( jsonPath, os.path.basename( file ).replace( '.xls', '.json' ) ) )
		elif file.endswith('.xlsx'):
			saveToJson( os.path.join( root, file ), os.path.join( jsonPath, os.path.basename( file ).replace( '.xlsx', '.json' ) ) )
