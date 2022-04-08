package dev.mikoto2000.che.cheexternalregistry;

 import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
 import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
 import static org.springframework.test.web.servlet.setup.MockMvcBuilders.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@SpringBootTest
class DevfileControllerTests {

	private MockMvc mockMvc;

	@Autowired
	private DevfileController devfileController;

	@BeforeEach
	public void setup() {
		this.mockMvc = MockMvcBuilders.standaloneSetup(devfileController).build();
	}

	@Test
	public void getPostDevFile() throws Exception {
		this.mockMvc.perform(post("/KEY")
					.contentType(MediaType.TEXT_PLAIN)
					.content("Hello, World!"))
				.andExpect(status().isOk())
				.andExpect(content().string("KEY"))
				.andReturn();

		this.mockMvc.perform(get("/KEY"))
				.andExpect(status().isOk())
				.andExpect(content().string("Hello, World!"))
				.andReturn();

		Thread.sleep(10000);

		// 10 秒たったらもう存在しない
		this.mockMvc.perform(get("/KEY"))
				.andExpect(status().isOk())
				.andExpect(content().string("devfile not found."))
				.andReturn();
	}

}

