RM			= rm -rf
CXXFLAGS	+= -std=c++17 -O3 -Wall -Wextra

sources			:= main.cpp
objects			:= $(subst .cpp,.o,$(sources))
dependencies	:= $(subst .o,.d,$(objects))
libraries 		:= -Lmyrlib/target/debug/deps -lmyrlib

.PHONY: all
all: $(objects)
	$(MAKE) --directory myrlib
	$(LINK.cpp) $(libraries) $^
	./a.out

.PHONY: clean
clean:
	$(RM) a.out $(objects) $(dependencies)

ifneq "$(MAKECMDGOALS)" "clean"
  -include $(dependencies)
endif

# $(call make-depend,source-file,object-file,depend-file)
define make-depend
  $(CXX) -MM -MF $3 \
		 -MP -MT $2 \
		 $(CXXFLAGS) \
		 $(CPPFLAGS) \
		 $(TARGET_ARCH) \
		 $1
endef

%.o: %.cpp
	$(call make-depend,$<,$@,$(subst .o,.d,$@))
	$(COMPILE.cpp) $<