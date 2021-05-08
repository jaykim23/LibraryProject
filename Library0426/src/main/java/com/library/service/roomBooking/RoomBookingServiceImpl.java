package com.library.service.roomBooking;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.library.dto.RoomBookingDto;
import com.library.mapper.RoomBookingMapper;
import com.library.service.page.PageNumber;

@Service
public class RoomBookingServiceImpl implements RoomBookingService {
	
	@Autowired
	RoomBookingMapper roomBookingMapper;
	@Autowired
	PageNumber pageNumber2;
	Map<String, Object> map;
	Map<String, Object> time;
	List<RoomBookingDto> list;
	RoomBookingDto roomBookingDto;
	
	//룸대여 전체 목록페이지
	 Calendar c=Calendar.getInstance();
     int hour=c.get(Calendar.HOUR_OF_DAY);
	
     
     
     
     
     
     
     
     
     
     
   //[연장] 주 5시간 확인 >>> 일 2시간확인 >>> 앞 시간 예약자 확인 >>> 연장승인
	@Override
  	public Map<String, Object> nextroombooking(RoomBookingDto roombookingDto,String lm_id,String sr_id,String rb_date,String rb_time) {
  		Map map = new HashMap<String, Object>();
  		Date d= new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String today = sdf.format(d);
		//주간 대여 초기화 변수
  		int weekCount=0;
  		//1주간 대여하는 횟수를 불러온다. 당일부터 1주일을 의미한다.
  		weekCount=roomBookingMapper.weekcheck(roombookingDto,lm_id);
  		//일간 대여 초기화 변수
  		int dayCount=0;
  		//당일 예약 이전 예약을 카운트하는 변수
  		int frontCount=0;
  		//당일 대여횟수 체크
  		dayCount=roomBookingMapper.daycheck(roombookingDto,lm_id);
  		//다른 사람 이전시간대 대여여부 체크
  		frontCount=roomBookingMapper.nextroomcheck(roombookingDto);
  		//alert로 보낼 구문을 비교문으로 선택해서 보낸다.
  		if(weekCount>=5) {
  			map.put("rs","주간 총 5시간을 모두 사용하셨습니다." );
  		}else if(dayCount>=2) {
  			map.put("rs","당일 2시간을 모두 사용하셨습니다." );
  		}else if(frontCount==1) {  
  		map.put("rs","예약자가 있어 연장하실수없습니다." );
  		}
  		else {
  			roomBookingMapper.nextroomBooking(roombookingDto,lm_id,sr_id,rb_date,rb_time);
  			map.put("rs","연장이 완료되었습니다.");
  		}
		return map;
  	}
	
 //	예약자 정보 불러오기 (전체/날짜/개인/연장)
	@Override
	public Map<String, Object> RbookingAll(String listPage, String category, String search,String lm_id) {
		list = new ArrayList<RoomBookingDto>();
		int page = 1;
		int limit = 10;
		int time = hour;
		if (listPage != null && listPage != "") {
			page = Integer.parseInt(listPage);
		}
		int startrow = (page - 1) * limit + 1; // 시작 게시글번호 1,11,21...
		int endrow = startrow + limit - 1; // 마지막 게시글번호 10,20,30...
		
		// 리스트 가져오기
				if (category == null || category.equals("")) {
					System.out.println("카테고리가 인식이 없나요?");
					list = roomBookingMapper.RBookingAll(startrow, endrow);
				}else if (category.equals("Date")) {
					list = roomBookingMapper.RbookingDate(startrow, endrow, search);
					System.out.println("날짜데이터가 들어왔나요?"+list);
				}else if (category.equals("User")) {
					list = roomBookingMapper.RbookingUser(startrow, endrow, lm_id);
					System.out.println("유저데이터가 들어왔나요?"+list);
				}else if (category.equals("today")) {
					
					list = roomBookingMapper.Rbookingtoday(startrow, endrow, lm_id);
			
					System.out.println("연장데이터가 들어왔나요?"+list);
				}
		map = pageNumber2.roompage(page, limit, category, search);
		map.put("time", time);
		map.put("list", list);
		
		
		return map;
	}
	@Override
	public void RoomBooking_Delete(String rb_id) {
		roomBookingMapper.RoomBooking_Delete(rb_id);
	}



}
