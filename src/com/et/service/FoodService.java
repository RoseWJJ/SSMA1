package com.et.service;

import java.util.List;

import com.et.entity.Food;

public interface FoodService {

	public abstract List<Food> queryFood(String foodame);
	public void deleteFood(String foodid);
	public void updateFood(Integer foodid);
	public void addFood(String foodname,Double price);

}