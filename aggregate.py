import gluon.contrib.simplejson as json

from geo import enum
from geo.tree import QuadTree 
from geo.func import get
from geo.utils import keygen
from savage.graphics.color import ColorMap, red, blue, green
 
cargs = [('boundry', 'Boundry Map', 'poly_map'),
         ('sort', 'Sort Field', 'attr', 'boundry'),
         ('points', 'Point Map', 'point_map'),
         ('agg', 'Aggregation', 'agg', 'points'),
         ('title', 'Title', 'text'),
         ('xlabel', 'X Label', 'text'),
         ('ylabel', 'Y Label', 'text')]

#rType = 'image/svg+xml'
#rType = 'text/html'

def keymap (keys, data):
    mapping = []
    for d in data:
        pair = (d[0], d[1])
        if keys.has_key (pair):
            mapping.append (keys[pair]) 
        else:
            mapping.append (d[1])
    return mapping

def ctool (**attr):
    polygons = attr['boundry']
    points = attr['points']

    pointTree = QuadTree ()
    for p in points:
        pointTree.append (p)

    for poly in polygons:
        poly.insert (poly.contains (pointTree))

    keys = {}
    output = []

    aggSource = attr['agg']['map']
    dataSource = attr['agg']['data']
    for inst in dataSource:
        dst = keygen (inst['name'])
        if inst['output']:
            output.append (dst)
        for poly in polygons:
            keys[(None, inst['name'])] = dst
            src = keymap (keys, inst['data'])
            func = get (str (inst ['method']), attr['points'])
            if inst['dir'] == 'extern':
                mode = enum.MANY_TO_ONE
            else:
                mode = enum.ONE_TO_ONE
            poly.compute (mode, func, dst, *src)

    file1 = request_new_buffer ("Bar Graph")     
    polygons.bar_graph (file1, attr['sort'], output, title = attr['title'], xlabel = attr['xlabel'], ylabel = attr['ylabel'])
    file1.MIME (mime.SVG)
    file1.close ()


    file2 = request_new_buffer ("HTML Table")     
    polygons.html_table (file2)
    file2.MIME (mime.HTML)
    file2.close ()

    file3 = request_new_buffer ("SVG Map")
    polygons.reduce (output[0])
    cm = ColorMap (blue, red, len (polygons))
    polygons.sort (output[0])
    for i, p in enumerate (polygons):
        p.color (cm.index (i))
    polygons.svg (file3)
    file3.MIME (mime.SVG)
    file3.close ()
