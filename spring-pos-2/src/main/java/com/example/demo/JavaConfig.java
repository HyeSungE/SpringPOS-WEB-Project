package com.example.demo;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

import com.example.demo.DAO.CategoryDAO;
import com.example.demo.DAO.ProductDAO;
import com.example.demo.DAO.ReceivingDAO;
import com.example.demo.DAO.SaleDAO;
import com.example.demo.DAO.UserDAO;
import com.example.demo.Manager.CategoryManger;
import com.example.demo.Manager.ProductManager;
import com.example.demo.Manager.ReceivingManager;
import com.example.demo.Manager.SaleManager;
import com.example.demo.Manager.UserManager;

@Configuration
@EnableAspectJAutoProxy
public class JavaConfig {
	@Bean(destroyMethod = "close")
	public DataSource dataSource() {
		DataSource ds = new DataSource();
		ds.setDriverClassName("com.mysql.jdbc.Driver");
		ds.setUrl("jdbc:mysql://localhost/spring_pos?characterEncoding=UTF-8&serverTimezone=UTC");
		ds.setUsername("root");
		ds.setPassword("1234");
		ds.setInitialSize(2);
		ds.setMaxActive(10);
		ds.setTestWhileIdle(true);
		ds.setMinEvictableIdleTimeMillis(60000 * 3);
		ds.setTimeBetweenEvictionRunsMillis(10 * 1000);
		return ds;
	}
	
	@Bean
	public UserManager userManager(UserDAO userDAO) {
		return new UserManager(userDAO);
	}

	@Bean
	public CategoryManger categoryManger(CategoryDAO categoryDAO,ProductDAO productDAO) {
		return new CategoryManger(categoryDAO,productDAO);
	}

	@Bean
	public ProductManager salesManager(ProductDAO productDAO) {
		return new ProductManager(productDAO);
	}

	@Bean
	public ReceivingManager receivingManager(ReceivingDAO receivingDAO) {
		return new ReceivingManager(receivingDAO);
	}
	
	@Bean
	public SaleManager saleManager(SaleDAO saleDAO) {
		return new SaleManager(saleDAO);
	}


	@Bean
	public UserDAO userDAO() {
		return new UserDAO(dataSource());
	}

	@Bean
	public CategoryDAO categoryDAO() {
		return new CategoryDAO(dataSource());
	}

	@Bean
	public ProductDAO productDAO() {
		return new ProductDAO(dataSource(), categoryDAO());
	}

	@Bean
	public ReceivingDAO receivingDAO() {
		return new ReceivingDAO(dataSource(), productDAO(), categoryDAO());
	}
	
	@Bean
	public SaleDAO saleDAO() {
		return new SaleDAO(dataSource());
	}

}
