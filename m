Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2298F10C8D1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 13:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfK1MqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 07:46:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbfK1MqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 07:46:17 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASCgwKC058355
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:17 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxrk0s3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:16 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 28 Nov 2019 12:46:15 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 12:46:12 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASCkBgB61997100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:46:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0916AE055;
        Thu, 28 Nov 2019 12:46:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86460AE045;
        Thu, 28 Nov 2019 12:46:11 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.185.119])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 12:46:11 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/9] s390x: Library resources for CSS tests
Date:   Thu, 28 Nov 2019 13:46:03 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19112812-0020-0000-0000-000003901E4D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112812-0021-0000-0000-000021E72C0C
Message-Id: <1574945167-29677-6-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_03:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=1
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are the include and library utilities for the css tests patch
series.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h      | 269 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/css_dump.c | 147 +++++++++++++++++++++++
 2 files changed, 416 insertions(+)
 create mode 100644 lib/s390x/css.h
 create mode 100644 lib/s390x/css_dump.c

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
new file mode 100644
index 0000000..95dec72
--- /dev/null
+++ b/lib/s390x/css.h
@@ -0,0 +1,269 @@
+/*
+ * CSS definitions
+ *
+ * Copyright IBM, Corp. 2019
+ * Author: Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef CSS_H
+#define CSS_H
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
+struct ccw {
+	unsigned char code;
+	unsigned char flags;
+	unsigned short count;
+	unsigned int data;
+} __attribute__ ((aligned(4)));
+
+#define ORB_M_KEY	0xf0000000
+#define ORB_F_SUSPEND	0x08000000
+#define ORB_F_STREAMING	0x04000000
+#define ORB_F_MODIFCTRL	0x02000000
+#define ORB_F_SYNC	0x01000000
+#define ORB_F_FORMAT	0x00800000
+#define ORB_F_PREFETCH	0x00400000
+#define ORB_F_INIT_IRQ	0x00200000
+#define ORB_F_ADDRLIMIT	0x00100000
+#define ORB_F_SUSP_IRQ	0x00080000
+#define ORB_F_TRANSPORT	0x00040000
+#define ORB_F_IDAW2	0x00020000
+#define ORB_F_IDAW_2K	0x00010000
+#define ORB_M_LPM	0x0000ff00
+#define ORB_F_LPM_DFLT	0x00008000
+#define ORB_F_ILSM	0x00000080
+#define ORB_F_CCW_IND	0x00000040
+#define ORB_F_ORB_EXT	0x00000001
+
+struct orb {
+	unsigned int	intparm;
+	unsigned int	ctrl;
+	unsigned int	cpa;
+	unsigned int	prio;
+	unsigned int	reserved[4];
+} __attribute__ ((aligned(4)));
+
+struct scsw {
+	uint32_t ctrl;
+	uint32_t addr;
+	uint8_t  devs;
+	uint8_t  schs;
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
+	struct {
+		uint8_t res0;
+		uint8_t st:3;
+		uint8_t :5;
+		uint16_t :13;
+		uint16_t f:1;
+		uint16_t x:1;
+		uint16_t s:1;
+	};
+};
+
+struct schib {
+	struct pmcw pmcw;
+	struct scsw scsw;
+	uint32_t  md0;
+	uint32_t  md1;
+	uint32_t  md2;
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
+	int cc = -1;
+
+	asm volatile(
+		"	   ssch	0(%2)\n"
+		"0:	 ipm	 %0\n"
+		"	   srl	 %0,28\n"
+		"1:\n"
+		: "+d" (cc)
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
+		"	   stsch	0(%3)\n"
+		"	   ipm	 %0\n"
+		"	   srl	 %0,28"
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
+		"	   msch	0(%3)\n"
+		"	   ipm	 %0\n"
+		"	   srl	 %0,28"
+		: "=d" (cc), "=m" (*addr)
+		: "d" (reg1), "a" (addr)
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
+		"	   tsch	0(%3)\n"
+		"	   ipm	 %0\n"
+		"	   srl	 %0,28"
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
+#undef DEBUG
+#ifdef DEBUG
+void dump_scsw(struct scsw *);
+void dump_irb(struct irb *irbp);
+void dump_schib(struct schib *sch);
+struct ccw *dump_ccw(struct ccw *cp);
+#else
+static inline void dump_scsw(struct scsw *scsw){}
+static inline void dump_irb(struct irb *irbp){}
+static inline void dump_pmcw(struct pmcw *p){}
+static inline void dump_schib(struct schib *sch){}
+static inline void dump_orb(struct orb *op){}
+static inline struct ccw *dump_ccw(struct ccw *cp)
+{
+	return NULL;
+}
+#endif
+
+extern unsigned long stacktop;
+#endif
diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
new file mode 100644
index 0000000..5356df2
--- /dev/null
+++ b/lib/s390x/css_dump.c
@@ -0,0 +1,147 @@
+/*
+ * Channel Sub-System structures dumping
+ *
+ * Copyright (c) 2019 IBM Corp.
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ *
+ * Description:
+ * Provides the dumping functions for various structures used by subchannels:
+ * - ORB  : Operation request block, describe the I/O operation and point to
+ *          a CCW chain
+ * - CCW  : Channel Command Word, describe the data and flow control
+ * - IRB  : Interuption response Block, describe the result of an operation
+ *          hold a SCSW and several channel type dependent fields.
+ * - SCHIB: SubChannel Information Block composed of:
+ *   - SCSW: SubChannel Status Word, status of the channel as a result of an
+ *           operation when in IRB.
+ *   - PMCW: Path Management Control Word
+ * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+
+#include <css.h>
+
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
+#ifdef DEBUG
+void dump_scsw(struct scsw *s)
+{
+	dump_scsw_flags(s->ctrl);
+	printf("scsw->flags: %s\n", line);
+	printf("scsw->addr : %08x\n", s->addr);
+	printf("scsw->devs : %02x\n", s->devs);
+	printf("scsw->schs : %02x\n", s->schs);
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
+	printf("pmcw->flags2  : %08x\n", p->flag2);
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
+struct ccw *dump_ccw(struct ccw *cp)
+{
+	printf("CCW: code: %02x flags: %02x count: %04x data: %08x\n", cp->code,
+	    cp->flags, cp->count, cp->data);
+
+	if (cp->code == CCW_C_TIC)
+		return (struct ccw *)(long)cp->data;
+
+	return (cp->flags & CCW_F_CC) ? cp + 1 : NULL;
+}
+
+void dump_orb(struct orb *op)
+{
+	struct ccw *cp;
+
+	printf("ORB: intparm : %08x\n", op->intparm);
+	printf("ORB: ctrl    : %08x\n", op->ctrl);
+	printf("ORB: prio    : %08x\n", op->prio);
+	cp = (struct ccw *)(long) (op->cpa);
+	while (cp)
+		cp = dump_ccw(cp);
+}
+
+#endif
-- 
2.17.0

