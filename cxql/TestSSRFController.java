package com.ssrf.querystring;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api")
@Configuration
public class TestSSRFController {


    @Autowired
    HttpClientAdapter httpClientAdapter;

    @Value("${app.vidmagic.aliwood.url}")
    String aliwoodDomain;

    //fasle positive
    @RequestMapping(value = "/gentemplate")
    public BaseResult<Object> genTemplate(@RequestParam( value = "id" ) String id) {
        BaseResult<Object> result = new BaseResult<Object>();
        try {
            String uri = httpClientAdapter.getIpUrl(aliwoodDomain)+"/api/gentemplate?id="+id;
            logger.info(JSON.toJSONString(uri));
            HttpResult ret =  httpClientAdapter.doGet(uri);
            result = ResultUtil.genBaseResult(ret);
        } catch (Exception e) {
            logger.error("get template error:",e);
            result.setCode(400);
            result.setErrmsg(e.getMessage());
        }
        return result;
    }

    //fasle positive
    @RequestMapping(value = "/syncmusic",method = POST)
    public BaseResult<Object>  syncMusic(HttpServletRequest request) {
            String data = request.getParameter("data");

        BaseResult<Object> result = new BaseResult<>();

        BaseResult<String> ret =  TaskHelper.getActionApiAdapter(SyncMusicAdapter.class.getName()).call("",data);
        result.setCode(ret.getCode());
        if(ret.getData()!=null) {
            result.setData(JSON.parseObject(ret.getData()));
        }
        result.setErrmsg(ret.getErrmsg());

        Map<String, String> param = new HashMap<String,String> ();
        param.put("data", data);
        String uri = httpClientAdapter.getIpUrl(aliwoodDomain)+"/api/updatestyle";
        HttpResult ret =  httpClientAdapter.doGet(uri,param,null);
        result = ResultUtil.genBaseResult(ret);

        return result;

    }

    @Override
    public BaseResult<String> call(String actionKey,String input) {
        BaseResult result = new BaseResult();
        try {

            if(!AppConstants.PROFILE_ALI.equalsIgnoreCase(profile) && !AppConstants.ENV_DAILY.equalsIgnoreCase(env) ){
                String uri =  httpClientAdapter.getIpUrl(aliwoodDomain)+"/service";
                logger.info("url:"+JSON.toJSONString(uri)+" input:"+input);
                Map<String, String> param = JSON.parseObject(input,Map.class);
                param.put("action","update_style");
                HttpResult ret =  httpClientAdapter.doGet(uri,param);
                result = ResultUtil.genBaseResult(ret);
            } else {
                String uri = httpClientAdapter.getIpUrl(aliwoodDomain)+"/api/updatestyle";
                logger.info("url:"+JSON.toJSONString(uri)+" input:"+input);
                Map<String, String> param = JSON.parseObject(input,Map.class);
                HttpResult ret =  httpClientAdapter.doGet(uri,param);
                result = ResultUtil.genBaseResult(ret);
            }
        } catch (Exception e) {
            result.setCode(ResultCode.UNKNOWN_ERROR.getCode());
            result.setErrmsg(e.getMessage());
        }

        if(!result.getSuccess()){
            logger.error("ERROR: " + JSON.toJSONString(result));
        } else {
            logger.info("result: " + JSON.toJSONString(result));
        }

        return result;
    }

    @RequestMapping(value = "/ssrf")
    public BaseResult<Object> genTemplate(@RequestParam( value = "url" ) String url) {
        BaseResult<Object> result = new BaseResult<Object>();
        try {
            String uri = url;
            logger.info(JSON.toJSONString(uri));
            HttpResult ret =  httpClientAdapter.doGet(uri);
            result = ResultUtil.genBaseResult(ret);
        } catch (Exception e) {
            logger.error("get template error:",e);
            result.setCode(400);
            result.setErrmsg(e.getMessage());
        }
        return result;
    }


}
