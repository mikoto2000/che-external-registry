package dev.mikoto2000.che.cheexternalregistry;

import java.util.concurrent.TimeUnit;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
/**
 * DevfileController
 */
@Controller
public class DevfileController {

    private static final int CONCURRENCY_LEVEL = 1;
    private static final int MAXIMUM_SIZE = 10;
    private static final int EXPIRE_AFTER_ACCESS = 10;

    private static final String MESSAGE_DEVFILE_NOT_FOUND = "devfile not found.";

    private Cache<String, String> map = CacheBuilder.newBuilder()
            .concurrencyLevel(CONCURRENCY_LEVEL)
            .maximumSize(MAXIMUM_SIZE)
            .expireAfterWrite(EXPIRE_AFTER_ACCESS, TimeUnit.SECONDS)
            .<String, String>build();

    @GetMapping(path = "/tempfiles/{key}", produces="text/plain")
    @ResponseBody
    public String getDevfile(@PathVariable String key) {
        String devfile = map.getIfPresent(key);

        if (devfile == null) {
            devfile = MESSAGE_DEVFILE_NOT_FOUND;
        }

        return devfile;
    }

    @PostMapping(path = "/tempfiles/{key}", produces="text/plain")
    @ResponseBody
    public String postDevfile(@PathVariable String key, @RequestBody String body) {
        map.put(key, body);

        return key;
    }
}

