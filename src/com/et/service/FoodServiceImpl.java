package com.et.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.et.dao.FoodMapper;
import com.et.entity.Food;
import com.et.entity.FoodExample;
import com.et.entity.FoodExample.Criteria;
import com.et.service.FoodService;

@Service
public class FoodServiceImpl implements FoodService {
	@Autowired
	FoodMapper fMapper;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.et.service.FoodService#queryFood(java.lang.String)
	 */
	public List<Food> queryFood(String foodame) {
		FoodExample example = new FoodExample();

		Criteria c = example.createCriteria();
		c.andFoodnameLike("%" + foodame + "%");
		return fMapper.selectByExample(example);
	}

	public void deleteFood(String foodid) {

		fMapper.deleteByPrimaryKey(Integer.valueOf(foodid));
	}

	public void updateFood(Integer foodid) {
		Food food = new Food();
		food.setFoodid(foodid);
		fMapper.updateByPrimaryKey(food);
	}
	public void addFood(String foodname,Double  price) {
		Food food = new Food();
		food.setFoodname(foodname);
		food.setPrice(price);
		fMapper.insert(food);
	}

	
}
