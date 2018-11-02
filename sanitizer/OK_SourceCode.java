package com.checkmarx.test.cors;

/**
 * Issue: Whitelist is a proprietary sanitization function
 *
 **/

public class OK_CodeSource {

	static {
		URLWhiteList urlWhiteList = new URLWhiteList();
	    urlWhiteList.setWhiteList("http://www.baidu.com");
	}

	@RequestMapping("/testCors.do")
	    public @ResponseBody  String CORSTest(HttpServletRequest request,HttpServletResponse response) {
	        String map = "no_pass";
	        String origin = request.getHeader("Origin");
	        System.out.println(origin);

	        if(urlWhiteList.indexOf(origin) != -1){
	            map = "pass";
	            ((HttpServletResponse) res).setHeader("Access-Control-Allow-Origin", origin);
				((HttpServletResponse) res).setContentType("application/json;charset=UTF-8");
				((HttpServletResponse) res).setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
				((HttpServletResponse) res).setHeader("Access-Control-Max-Age", "3600");
				((HttpServletResponse) res).setHeader("Access-Control-Allow-Headers", "Origin, No-Cache, X-Requested-With, If-Modified-Since, Pragma, Last-Modified, Cache-Control, Expires, Content-Type, X-E4M-With,userId,token");//����������֧�ֵ�����ͷ��Ϣ�ֶ�
				((HttpServletResponse) res).setHeader("Access-Control-Allow-Credentials", "true"); //���Ҫ��Cookie��������������Ҫָ��Access-Control-Allow-Credentials�ֶ�Ϊtrue;
				((HttpServletResponse) res).setHeader("XDomainRequestAllowed","1");
	        }
	        else{
	            map = "checked_no_pass";
	        }
	        return map;
	    }

}
