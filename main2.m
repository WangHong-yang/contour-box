function [] = main2(proposalNum,bbs)
% �������ã�main(proposalNum,bbs)
% �������ܣ����û�����
% �������룺proposal�����кţ�bbsΪ���е�ͼ��proposal��cell
% ������ʷ�� v0.0 @2016-01-09 created by HongyangWang
% clc;
% clear;
% close all;
imgDir = '/Users/Mr-why/Documents/ScienceResearch/edges-master-evaluation/VOCtest_06-Nov-2007/VOCdevkit/VOC2007/JPEGImages/fold/';
data = imread([imgDir '000001.jpg']); % Change 000001.jpg to show different pic
picbbs = bbs{1,:};% Change 1 to show different pic
bb = picbbs(proposalNum,:); % Change 1 to show different proposal ��21��28��
pointAll = [bb(2),bb(1)];
windSize = [bb(3),bb(4)];

[state,results]=draw_rect(data,pointAll,windSize);
return;