package com.library.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.library.dto.BookDto;
import com.library.mapper.MainMapper;


@Service
public class MainServiceImpl implements MainService {

	@Autowired
	MainMapper mainMapper;
	
	List<BookDto> list;
	Map<String, Object> map;
	List<BookDto> newBooklist;
	
	List<BookDto> list0 = new ArrayList<BookDto>();
	List<BookDto> list1 = new ArrayList<BookDto>();
	List<BookDto> list2 = new ArrayList<BookDto>();
	List<BookDto> list3 = new ArrayList<BookDto>();
	List<BookDto> list4 = new ArrayList<BookDto>();
	List<BookDto> list5 = new ArrayList<BookDto>();
	List<BookDto> pickresult = new ArrayList<BookDto>();
	
	int[] rs1 = new int[5];
	int[] rs2 = new int[10];
	int[] rs3 = new int[15];
	int[] rs4 = new int[20];
	int[] rs5 = new int[25];
	int[] rs6 = new int[30];
	int[] favorbooks = new int[5];
	int temp;
	int k;
	
	int id0,id1,id2,id3,id4;
	BookDto bookDto;
	String onebyone;
	int pick;
	
	//베스트셀러 5개 리스트
	@Override
	public Map<String, Object> BestSellerList() {
		Map map = new HashMap<String, Object>();
		list = new ArrayList<BookDto>();
		list = mainMapper.selectBestSeller();
		map.put("list", list);
	return map;
	}
	
	//신작도서 5개
	@Override
	public Map<String, Object> NewBookList() {
		Map map = new HashMap<String, Object>();
		newBooklist = new ArrayList<BookDto>();
		newBooklist = mainMapper.selectNewBookList();
		map.put("newBooklist", newBooklist);
		return map;
	}
	
	//유저 맞춤도서 5개 출력
		@Override
		public Map<String, Object> favorbooks(String lm_user) {
			Map map = new HashMap<String, Object>();
			String rs="";
			//회원의 취향(lm_favor)를 가져온다.
			rs = mainMapper.selectFavorBooks(lm_user);
			//관심도서가 존재하는지 없는지 비교
			if(rs==null ||rs.equals("") ) {
				list = new ArrayList<BookDto>();
				//없으면 베스트셀러를 출력한다.
				list = mainMapper.selectBestSeller();
				map.put("pickresult", list);
			}else {
				//매칭되는 도서들 뽑아와서, 저장된 취향을 split함수로 자른다.
				String[] favors = new String[rs.split(",").length];
				favors = rs.split(",");
				//취향 선택 개수에 따라서 Switch문으로 구분
				switch(favors.length) {
				//1개일 경우 2,3,4,5 이하 동문.
				case 1:
					for(int i=0;i<favors.length;i++) {
						//자른 취향을 onebyone이라는 String 변수에 넣는다.
						onebyone = favors[i];
						if(i==0) {
							//취향과 매칭되는 책을 불러와서 취향 1개일때의 ArrayList에 담는다.
							list0 = mainMapper.selectMatchingBook(onebyone);
							//각 책들의 primaryKey를 list에 담는다.
							for(int j=0;j<list0.size();j++) {
								rs1[j] = list0.get(j).getBk_id();
							}
						}
					}
					//5권 랜덤으로 섞기 rs1[0] -> temp, temp->rs1[k], rs1[k]-> rs1[0]
					for(int c=0;c<50;c++) {
						temp = rs1[0];
						k=(int)(Math.random()*5);
						rs1[0] = rs1[k];
						rs1[k] = temp;
					}
					//5개만 뽑기
					for(int c=0;c<favorbooks.length;c++) {
						//섞인 책의 책번호를 맞춤도서 배열에 넣는다.
						favorbooks[c] = rs1[c];
					}
					//배열의 모든 책 번호를 id에 집에 넣는다.
					id0= favorbooks[0]; id1=favorbooks[1]; id2=favorbooks[2]; id3=favorbooks[3];id4=favorbooks[4];
					//매칭되는 5권 select로 검색해오기
					pickresult = mainMapper.selectShowBook(id0,id1,id2,id3,id4);
					map.put("pickresult", pickresult);
					break;
					
					
					
					
					
					
					
					
					
					
					
				case 2:
					for(int i=0;i<favors.length;i++) {
						onebyone =favors[i];
						if(i==0) {
							list0 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list0.size();j++) {
								rs2[j] = list0.get(j).getBk_id();
							}
						}else if(i==1) {
							list1 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list1.size();j++) {
								rs2[j+5] = list1.get(j).getBk_id();
							}
						}
					}//매칭되는 도서들 뽑아와서, bk_id만 배열에 담기

					for(int c=0;c<50;c++) {
						temp= rs2[0];
						k=(int)(Math.random()*10);
						rs2[0] = rs2[k];
						rs2[k]=temp;
					}//10권 랜덤으로 섞기
					
					for(int c=0;c<favorbooks.length;c++) {
						favorbooks[c]=rs2[c];
					}//5개만 뽑기
					id0= favorbooks[0]; id1=favorbooks[1]; id2=favorbooks[2]; id3=favorbooks[3];id4=favorbooks[4];
					
					pickresult = mainMapper.selectShowBook(id0,id1,id2,id3,id4);
					//매칭되는 5권 리스트에 담기
					
					map.put("pickresult", pickresult);
					break;
				case 3:
					for(int i=0;i<favors.length;i++) {
						onebyone =favors[i];
						if(i==0) {
							list0 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list0.size();j++) {
								rs3[j] = list0.get(j).getBk_id();
							}
						}else if(i==1) {
							list1 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list1.size();j++) {
								rs3[j+5] = list1.get(j).getBk_id();
							}
						}else if(i==2) {
							list2 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list2.size();j++) {
								rs3[j+10] = list2.get(j).getBk_id();
							}
						}
					}//매칭되는 도서들 뽑아와서, bk_id만 배열에 담기

					for(int c=0;c<50;c++) {
						temp= rs3[0];
						k=(int)(Math.random()*15);
						rs3[0] = rs3[k];
						rs3[k]=temp;
					}//15권 랜덤으로 섞기
					
					for(int c=0;c<favorbooks.length;c++) {
						favorbooks[c]=rs3[c];
					}//5개만 뽑기
					id0= favorbooks[0]; id1=favorbooks[1]; id2=favorbooks[2]; id3=favorbooks[3];id4=favorbooks[4];
					
					pickresult = mainMapper.selectShowBook(id0,id1,id2,id3,id4);
					//매칭되는 5권 리스트에 담기
					
					map.put("pickresult", pickresult);
					break;
					
				case 4: //관심도서 4개선택 했을 때
					for(int i=0;i<favors.length;i++) {
						onebyone =favors[i];
						if(i==0) {
							list0 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list0.size();j++) {
								rs4[j] = list0.get(j).getBk_id();
							}
						}else if(i==1) {
							list1 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list1.size();j++) {
								rs4[j+5] = list1.get(j).getBk_id();
							}
						}else if(i==2) {
							list2 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list2.size();j++) {
								rs4[j+10] = list2.get(j).getBk_id();
							}
						}else if(i==3) {
							list3 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list3.size();j++) {
								rs4[j+15] = list3.get(j).getBk_id();
							}
						}
					}//매칭되는 도서들 뽑아와서, bk_id만 배열에 담기

					for(int c=0;c<50;c++) {
						temp= rs4[0];
						k=(int)(Math.random()*20);
						rs4[0] = rs4[k];
						rs4[k]=temp;
					}//20권 랜덤으로 섞기
					
					for(int c=0;c<favorbooks.length;c++) {
						favorbooks[c]=rs4[c];
					}//5개만 뽑기
					id0= favorbooks[0]; id1=favorbooks[1]; id2=favorbooks[2]; id3=favorbooks[3];id4=favorbooks[4];
					
					pickresult = mainMapper.selectShowBook(id0,id1,id2,id3,id4);
					//매칭되는 5권 리스트에 담기
					
					map.put("pickresult", pickresult);
					break;
					
					
				case 5:
					for(int i=0;i<favors.length;i++) {
						onebyone =favors[i];
						if(i==0) {
							list0 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list0.size();j++) {
								rs5[j] = list0.get(j).getBk_id();
							}
						}else if(i==1) {
							list1 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list1.size();j++) {
								rs5[j+5] = list1.get(j).getBk_id();
							}
						}else if(i==2) {
							list2 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list2.size();j++) {
								rs5[j+10] = list2.get(j).getBk_id();
							}
						}else if(i==3) {
							list3 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list3.size();j++) {
								rs5[j+15] = list3.get(j).getBk_id();
							}
						}else if(i==4) {
							list4 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list4.size();j++) {
								rs5[j+20] = list4.get(j).getBk_id();
							}
						}
					}//매칭되는 도서들 뽑아와서, bk_id만 배열에 담기

					for(int c=0;c<50;c++) {
						temp= rs5[0];
						k=(int)(Math.random()*25);
						rs5[0] = rs5[k];
						rs5[k]=temp;
					}//25권 랜덤으로 섞기
					
					for(int c=0;c<favorbooks.length;c++) {
						favorbooks[c]=rs5[c];
					}//5개만 뽑기
					id0= favorbooks[0]; id1=favorbooks[1]; id2=favorbooks[2]; id3=favorbooks[3];id4=favorbooks[4];
					
					pickresult = mainMapper.selectShowBook(id0,id1,id2,id3,id4);
					//매칭되는 5권 리스트에 담기
					
					map.put("pickresult", pickresult);
					break;
				case 6:
					for(int i=0;i<favors.length;i++) {
						onebyone =favors[i];
						if(i==0) {
							list0 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list0.size();j++) {
								rs6[j] = list0.get(j).getBk_id();
							}
						}else if(i==1) {
							list1 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list1.size();j++) {
								rs6[j+5] = list1.get(j).getBk_id();
							}
						}else if(i==2) {
							list2 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list2.size();j++) {
								rs6[j+10] = list2.get(j).getBk_id();
							}
						}else if(i==3) {
							list3 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list3.size();j++) {
								rs6[j+15] = list3.get(j).getBk_id();
							}
						}else if(i==4) {
							list4 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list4.size();j++) {
								rs6[j+20] = list4.get(j).getBk_id();
							}
						}else if(i==5) {
							list5 = mainMapper.selectMatchingBook(onebyone);
							for(int j=0;j<list5.size();j++) {
								rs6[j+25] = list5.get(j).getBk_id();
							}
						}
					}//매칭되는 도서들 뽑아와서, bk_id만 배열에 담기

					for(int c=0;c<50;c++) {
						temp= rs6[0];
						k=(int)(Math.random()*30);
						rs6[0] = rs6[k];
						rs6[k]=temp;
					}//25권 랜덤으로 섞기
					
					for(int c=0;c<favorbooks.length;c++) {
						favorbooks[c]=rs6[c];
					}//5개만 뽑기
					id0= favorbooks[0]; id1=favorbooks[1]; id2=favorbooks[2]; id3=favorbooks[3];id4=favorbooks[4];
					
					pickresult = mainMapper.selectShowBook(id0,id1,id2,id3,id4);
					//매칭되는 5권 리스트에 담기
					
					map.put("pickresult", pickresult);
					break;
				}//case
				
			}//if,else
			return map;
		}//favorbooks

}
