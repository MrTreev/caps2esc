EXE			=	caps2esc
CC			=	gcc
CFLAGS		=	-I"/usr/include/libevdev-1.0" -levdev -ludev
PREFIX		=	/usr/local

SRV			=	${EXE}.service
PREFIX_SRV	=	/etc/systemd/system
PREFIX_BIN	=	${PREFIX}/bin
INST_BIN	=	${PREFIX_BIN}/${EXE}
INST_SRV	=	${PREFIX_SRV}/${SRV}

${EXE}: caps2esc.c

.PHONY: clean
clean:
	rm -f ${EXE}

.PHONY: install
install: ${EXE}
	mkdir -p ${PREFIX_BIN} ${PREFIX_SRV}
	cp -f -t ${PREFIX_BIN} ${EXE}
	sed "s|XXXXXXXX|${INST_BIN}|" ${SRV} > ${INST_SRV}
	systemctl daemon-reload

.PHONY: uninstall
uninstall:
	rm -f ${INST_BIN} ${INST_SRV}
	systemctl daemon-reload

.PHONY: enable
enable: ${INST_BIN} ${INST_SRV}
	systemctl enable ${EXE}
	systemctl start ${EXE}

.PHONY: disable
disable:
	systemctl stop ${EXE}
	systemctl disable ${EXE}
