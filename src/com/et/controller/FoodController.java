package com.et.controller;

import java.io.OutputStream;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.et.entity.Food;
import com.et.service.FoodService;

@Controller
public class FoodController {
	@Autowired
	FoodService fService;
	@ResponseBody
	@RequestMapping("/queryFood")
	public List<Food>queryFood(@Param("foodname")String foodname){
		System.out.println("-------------------"+foodname);
		if(foodname==null){
			foodname="";
		}
		
		return fService.queryFood(foodname);
	}
	@RequestMapping(value="/deleteFood/{foodid}",method={RequestMethod.DELETE})
	public String deleteFood(@PathVariable String foodid,OutputStream os) throws Exception {
		try {
			fService.deleteFood(foodid);
		
			os.write("1".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			os.write("0".getBytes("UTF-8"));
		}
		return null;
	}
	
	@RequestMapping(value="/saveFood",method={RequestMethod.POST})
	public String saveFood(String foodname,String price,OutputStream os) throws Exception {
		

		try {
			fService.addFood(foodname, Double.valueOf(price));
			os.write("1".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			os.write("0".getBytes("UTF-8"));
		}
		
		return null;
	}
	
	@RequestMapping(value="/updateFood/{foodid}",method={RequestMethod.PUT})
	public String updateFood(@PathVariable String foodid,String foodname,String price,OutputStream os) throws Exception{
		try {
			System.out.println(foodid);
			fService.updateFood(Integer.valueOf(foodid));
			os.write("1".getBytes("UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			os.write("0".getBytes("UTF-8"));
		}
		return null;
	}
}
