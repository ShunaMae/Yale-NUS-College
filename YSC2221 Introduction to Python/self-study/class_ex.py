
class Point: 
    # create a new Point, at coordinate x, y 

    def __init__(self, x = 0, y = 0):
        self.x = x 
        self.y = y
    
    def __str__(self):
        return "({0}, {1})".format(self.x, self.y)
    
    # rewrite the distance function so that it takes two Points as parameters 
    def dist(self, pt):
        return (abs(self.x - pt.x) ** 2 + abs(self.y - pt.y)) ** (0.5)
    
    # add a method reflect_x which returns a new Point, 
    # one which is the reflection of the point about the x-axis. 
    def reflect_x(self):
        return "({0}, {1})".format(self.x, self.y * (-1))
    
    # add a method which returns the slope of the line joining the origin to the point.
    def slope_from_origin(self):
        if self.x == 0: raise Exception("x-coordinate is 0.")
        return self.y / self.x 
    
    # write a method which compute the equation of the straght line joining the two points. 
    def get_line_to(self, pt):
        if self.x == pt.x: 
            raise Exception("the line is perpendicular to the x-axis.")
        a = (pt.y - self.y) / (pt.x - self.x)
        b = self.y - self.x * a 
        return "({0}, {1})".format(a, b)

# print(Point(1,2).reflect_x())
# print(Point(4, 10).slope_from_origin())
# print(Point(4,11).get_line_to(Point(6,15)))
# print(Point(0,11).get_line_to(Point(0,15)))

class SMS_store():

    def __init__(self):
        self.li = []
        
    # add a new message 
    def add_new_arrival(self, from_number, time_arrived, text_of_sms):
        has_been_viewed = False 
        self.li.append([has_been_viewed, from_number, time_arrived, text_of_sms])
    
    # count the number of messages 
    def message_count(self):
        return len(self.li)
    
    def get_unread_indexes(self):
        unread_list = []
        for i in range(len(self.li)):
            status = self.li[i][0]
            if not status:
                unread_list.append(i)
        return unread_list
    
        
    # to view all messages inside 
    def get_all_messages(self):
        list_to_print = []
        for i in self.li:
            to_print = i
            if i[0]:
                i[0] = "Read"
            else:
                i[0] = "Unread"
            list_to_print.append(to_print)
        if not len(list_to_print):
            return None
        return list_to_print
    
    def get_message(self, i):
        self.li[i][0] = True 
        num = self.li[i][1]
        t = self.li[i][2]
        m = self.li[i][3]
        return (num, t, m)
    
    def delete(self, i):
        del self.li[i]
    
    def clear(self):
        self.li.clear()
        
# my_inbox = SMS_store()
# my_inbox.add_new_arrival(100, 1020, "Hi")
# my_inbox.add_new_arrival(101, 1020, "Hi")
# my_inbox.add_new_arrival(102, 1020, "Hi")
# print(my_inbox.message_count())
# print(my_inbox.get_message(1))
# print(my_inbox.get_unread_indexes())
# print(my_inbox.get_all_messages())
# my_inbox.delete(2)
# my_inbox.clear()
# print(my_inbox.get_all_messages())


class Rectangle:

    def __init__(self, posn, w, h):
        self.corner = posn
        self.width = w 
        self.height = h
    
    def __str__(self):
        return "({0}, {1}, {2})".format(self.corner, self.width, self.height)
    
    def grow(self, delta_width, delta_height):
        self.width += delta_width 
        self.height += delta_height 
    
    def move(self, dx, dy):
        self.corner.x += dx 
        self.corner.y += dy 
    
    # Exercises 11.2.6
    # 1. Add a method area that returns the area of any instance 
    def area(self):
        return self.width * self.height 
    
    # 2. Write a parimeter method so that we can find the perimeter of any rectangle instance 
    def perimeter(self):
        return (self.width + self.height) * 2 
    
    # 3. Write a flip method that swaps the width and the height of any instance 
    def flip(self):
        w = self.width 
        h = self.height 
        self.width = h
        self.height = w 
    
    # 4. Write a method to test if a Point falls within the rectangle 
    def contains(self, pt):
        return self.corner.x < pt.x < self.corner.x + self.width \
            and self.corner.y < pt.y < self.corner.y + self.height
    
    # 5. Write a function to determine whether two rectangles collide 


    # where to import libraries? 
            
