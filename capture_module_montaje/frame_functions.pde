public void init()
{
if(frame!=null)
{
frame.removeNotify();//make the frame not displayable
frame.setResizable(false);
frame.setUndecorated(true);
frame.addNotify();
}
super.init();
}
