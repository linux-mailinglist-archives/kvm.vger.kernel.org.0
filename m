Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A1D234398
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732395AbgGaJqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:46:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732376AbgGaJqa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:46:30 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V9csd8137782;
        Fri, 31 Jul 2020 05:46:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32maeb9ayk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:28 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V9fZ8l143012;
        Fri, 31 Jul 2020 05:46:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32maeb9ay0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V9kBA5001657;
        Fri, 31 Jul 2020 09:46:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 32gcpx740r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 09:46:26 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V9kNIj29491482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 09:46:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6277FAE051;
        Fri, 31 Jul 2020 09:46:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E543CAE045;
        Fri, 31 Jul 2020 09:46:22 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.62.184])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 09:46:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 07/11] s390x: Library resources for CSS tests
Date:   Fri, 31 Jul 2020 11:46:03 +0200
Message-Id: <20200731094607.15204-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200731094607.15204-1-frankja@linux.ibm.com>
References: <20200731094607.15204-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_03:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

Provide some definitions and library routines that can be used by
tests targeting the channel subsystem.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@de.ibm.com>
Message-Id: <1594904550-32273-1-git-send-email-pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c | 152 +++++++++++++++++++++++++
 s390x/Makefile       |   1 +
 3 files changed, 409 insertions(+)
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
new file mode 100644
index 0000000..0ddceb1
--- /dev/null
+++ b/lib/s390x/css.h
@@ -0,0 +1,256 @@
+/*
+ * CSS definitions
+ *
+ * Copyright IBM, Corp. 2020
+ * Author: Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+
+#ifndef CSS_H
+#define CSS_H
+
+/* subchannel ID bit 16 must always be one */
+#define SCHID_ONE	0x00010000
+
+#define CCW_F_CD	0x80
+#define CCW_F_CC	0x40
+#define CCW_F_SLI	0x20
+#define CCW_F_SKP	0x10
+#define CCW_F_PCI	0x08
+#define CCW_F_IDA	0x04
+#define CCW_F_S		0x02
+#define CCW_F_MIDA	0x01
+
+#define CCW_C_NOP	0x03
+#define CCW_C_TIC	0x08
+
+struct ccw1 {
+	uint8_t code;
+	uint8_t flags;
+	uint16_t count;
+	uint32_t data_address;
+} __attribute__ ((aligned(8)));
+
+#define ORB_CTRL_KEY	0xf0000000
+#define ORB_CTRL_SPND	0x08000000
+#define ORB_CTRL_STR	0x04000000
+#define ORB_CTRL_MOD	0x02000000
+#define ORB_CTRL_SYNC	0x01000000
+#define ORB_CTRL_FMT	0x00800000
+#define ORB_CTRL_PFCH	0x00400000
+#define ORB_CTRL_ISIC	0x00200000
+#define ORB_CTRL_ALCC	0x00100000
+#define ORB_CTRL_SSIC	0x00080000
+#define ORB_CTRL_CPTC	0x00040000
+#define ORB_CTRL_C64	0x00020000
+#define ORB_CTRL_I2K	0x00010000
+#define ORB_CTRL_LPM	0x0000ff00
+#define ORB_CTRL_ILS	0x00000080
+#define ORB_CTRL_MIDAW	0x00000040
+#define ORB_CTRL_ORBX	0x00000001
+
+#define ORB_LPM_DFLT	0x00008000
+
+struct orb {
+	uint32_t intparm;
+	uint32_t ctrl;
+	uint32_t cpa;
+	uint32_t prio;
+	uint32_t reserved[4];
+} __attribute__ ((aligned(4)));
+
+struct scsw {
+	uint32_t ctrl;
+	uint32_t ccw_addr;
+	uint8_t  dev_stat;
+	uint8_t  sch_stat;
+	uint16_t count;
+};
+
+struct pmcw {
+	uint32_t intparm;
+#define PMCW_DNV        0x0001
+#define PMCW_ENABLE     0x0080
+	uint16_t flags;
+	uint16_t devnum;
+	uint8_t  lpm;
+	uint8_t  pnom;
+	uint8_t  lpum;
+	uint8_t  pim;
+	uint16_t mbi;
+	uint8_t  pom;
+	uint8_t  pam;
+	uint8_t  chpid[8];
+	uint32_t flags2;
+};
+#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
+
+struct schib {
+	struct pmcw pmcw;
+	struct scsw scsw;
+	uint8_t  md[12];
+} __attribute__ ((aligned(4)));
+
+struct irb {
+	struct scsw scsw;
+	uint32_t esw[5];
+	uint32_t ecw[8];
+	uint32_t emw[8];
+} __attribute__ ((aligned(4)));
+
+/* CSS low level access functions */
+
+static inline int ssch(unsigned long schid, struct orb *addr)
+{
+	register long long reg1 asm("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	ssch	0(%2)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28\n"
+		: "=d" (cc)
+		: "d" (reg1), "a" (addr), "m" (*addr)
+		: "cc", "memory");
+	return cc;
+}
+
+static inline int stsch(unsigned long schid, struct schib *addr)
+{
+	register unsigned long reg1 asm ("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	stsch	0(%3)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc), "=m" (*addr)
+		: "d" (reg1), "a" (addr)
+		: "cc");
+	return cc;
+}
+
+static inline int msch(unsigned long schid, struct schib *addr)
+{
+	register unsigned long reg1 asm ("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	msch	0(%3)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc)
+		: "d" (reg1), "m" (*addr), "a" (addr)
+		: "cc");
+	return cc;
+}
+
+static inline int tsch(unsigned long schid, struct irb *addr)
+{
+	register unsigned long reg1 asm ("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	tsch	0(%3)\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc), "=m" (*addr)
+		: "d" (reg1), "a" (addr)
+		: "cc");
+	return cc;
+}
+
+static inline int hsch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	hsch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc)
+		: "d" (reg1)
+		: "cc");
+	return cc;
+}
+
+static inline int xsch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	xsch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc)
+		: "d" (reg1)
+		: "cc");
+	return cc;
+}
+
+static inline int csch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	csch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc)
+		: "d" (reg1)
+		: "cc");
+	return cc;
+}
+
+static inline int rsch(unsigned long schid)
+{
+	register unsigned long reg1 asm("1") = schid;
+	int cc;
+
+	asm volatile(
+		"	rsch\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc)
+		: "d" (reg1)
+		: "cc");
+	return cc;
+}
+
+static inline int rchp(unsigned long chpid)
+{
+	register unsigned long reg1 asm("1") = chpid;
+	int cc;
+
+	asm volatile(
+		"	rchp\n"
+		"	ipm	%0\n"
+		"	srl	%0,28"
+		: "=d" (cc)
+		: "d" (reg1)
+		: "cc");
+	return cc;
+}
+
+/* Debug functions */
+char *dump_pmcw_flags(uint16_t f);
+char *dump_scsw_flags(uint32_t f);
+
+void dump_scsw(struct scsw *scsw);
+void dump_irb(struct irb *irbp);
+void dump_schib(struct schib *sch);
+struct ccw1 *dump_ccw(struct ccw1 *cp);
+void dump_irb(struct irb *irbp);
+void dump_pmcw(struct pmcw *p);
+void dump_orb(struct orb *op);
+
+int css_enumerate(void);
+#define MAX_ENABLE_RETRIES      5
+int css_enable(int schid);
+
+#endif
diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
new file mode 100644
index 0000000..1266f04
--- /dev/null
+++ b/lib/s390x/css_dump.c
@@ -0,0 +1,152 @@
+/*
+ * Channel subsystem structures dumping
+ *
+ * Copyright (c) 2020 IBM Corp.
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ *
+ * Description:
+ * Provides the dumping functions for various structures used by subchannels:
+ * - ORB  : Operation request block, describes the I/O operation and points to
+ *          a CCW chain
+ * - CCW  : Channel Command Word, describes the command, data and flow control
+ * - IRB  : Interuption response Block, describes the result of an operation;
+ *          holds a SCSW and model-dependent data.
+ * - SCHIB: SubCHannel Information Block composed of:
+ *   - SCSW: SubChannel Status Word, status of the channel.
+ *   - PMCW: Path Management Control Word
+ * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
+ */
+
+#include <libcflat.h>
+#include <stdint.h>
+#include <string.h>
+
+#include <css.h>
+
+/*
+ * Try to have a more human representation of the SCSW flags:
+ * each letter in the two strings represents the first
+ * letter of the associated bit in the flag fields.
+ */
+static const char *scsw_str = "kkkkslccfpixuzen";
+static const char *scsw_str2 = "1SHCrshcsdsAIPSs";
+static char scsw_line[64] = {};
+
+char *dump_scsw_flags(uint32_t f)
+{
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		if ((f << i) & 0x80000000)
+			scsw_line[i] = scsw_str[i];
+		else
+			scsw_line[i] = '_';
+	}
+	scsw_line[i] = ' ';
+	for (; i < 32; i++) {
+		if ((f << i) & 0x80000000)
+			scsw_line[i + 1] = scsw_str2[i - 16];
+		else
+			scsw_line[i + 1] = '_';
+	}
+	return scsw_line;
+}
+
+/*
+ * Try to have a more human representation of the PMCW flags
+ * each letter in the string represents the first
+ * letter of the associated bit in the flag fields.
+ */
+static const char *pmcw_str = "11iii111ellmmdtv";
+static char pcmw_line[32] = {};
+char *dump_pmcw_flags(uint16_t f)
+{
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		if ((f << i) & 0x8000)
+			pcmw_line[i] = pmcw_str[i];
+		else
+			pcmw_line[i] = '_';
+	}
+	return pcmw_line;
+}
+
+void dump_scsw(struct scsw *s)
+{
+	dump_scsw_flags(s->ctrl);
+	printf("scsw->flags: %s\n", scsw_line);
+	printf("scsw->addr : %08x\n", s->ccw_addr);
+	printf("scsw->devs : %02x\n", s->dev_stat);
+	printf("scsw->schs : %02x\n", s->sch_stat);
+	printf("scsw->count: %04x\n", s->count);
+}
+
+void dump_irb(struct irb *irbp)
+{
+	int i;
+	uint32_t *p = (uint32_t *)irbp;
+
+	dump_scsw(&irbp->scsw);
+	for (i = 0; i < sizeof(*irbp)/sizeof(*p); i++, p++)
+		printf("irb[%02x] : %08x\n", i, *p);
+}
+
+void dump_pmcw(struct pmcw *p)
+{
+	int i;
+
+	printf("pmcw->intparm  : %08x\n", p->intparm);
+	printf("pmcw->flags    : %04x\n", p->flags);
+	dump_pmcw_flags(p->flags);
+	printf("pmcw->devnum   : %04x\n", p->devnum);
+	printf("pmcw->lpm      : %02x\n", p->lpm);
+	printf("pmcw->pnom     : %02x\n", p->pnom);
+	printf("pmcw->lpum     : %02x\n", p->lpum);
+	printf("pmcw->pim      : %02x\n", p->pim);
+	printf("pmcw->mbi      : %04x\n", p->mbi);
+	printf("pmcw->pom      : %02x\n", p->pom);
+	printf("pmcw->pam      : %02x\n", p->pam);
+	printf("pmcw->mbi      : %04x\n", p->mbi);
+	for (i = 0; i < 8; i++)
+		printf("pmcw->chpid[%d]: %02x\n", i, p->chpid[i]);
+	printf("pmcw->flags2  : %08x\n", p->flags2);
+}
+
+void dump_schib(struct schib *sch)
+{
+	struct pmcw *p = &sch->pmcw;
+	struct scsw *s = &sch->scsw;
+
+	printf("--SCHIB--\n");
+	dump_pmcw(p);
+	dump_scsw(s);
+}
+
+struct ccw1 *dump_ccw(struct ccw1 *cp)
+{
+	printf("CCW: code: %02x flags: %02x count: %04x data: %08x\n", cp->code,
+	    cp->flags, cp->count, cp->data_address);
+
+	if (cp->code == CCW_C_TIC)
+		return (struct ccw1 *)(long)cp->data_address;
+
+	return (cp->flags & CCW_F_CC) ? cp + 1 : NULL;
+}
+
+void dump_orb(struct orb *op)
+{
+	struct ccw1 *cp;
+
+	printf("ORB: intparm : %08x\n", op->intparm);
+	printf("ORB: ctrl    : %08x\n", op->ctrl);
+	printf("ORB: prio    : %08x\n", op->prio);
+	cp = (struct ccw1 *)(long) (op->cpa);
+	while (cp)
+		cp = dump_ccw(cp);
+}
diff --git a/s390x/Makefile b/s390x/Makefile
index 98ac29e..07d3c4b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -52,6 +52,7 @@ cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
+cflatobjs += lib/s390x/css_dump.o
 
 OBJDIRS += lib/s390x
 
-- 
2.25.4

