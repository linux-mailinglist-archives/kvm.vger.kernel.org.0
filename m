Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7032B258B4A
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 11:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIAJSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 05:18:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726078AbgIAJSq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 05:18:46 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08192i3g134143;
        Tue, 1 Sep 2020 05:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CqXi/pRGX45oChttP9Cn6y0ly/KAQjYTzK3jg957vuQ=;
 b=lf0eD7Ze7EojcJOduEphN/UH+qibnfckD+f6SAvl8+mB1y4C8wwDthmCXSzlEc2XTn+G
 PvksdyB/P51YUStD5g0fNMGRDjFsAL2pLIgSnFoUGu9AxQ0/La4HePrKrCj/P7u6GTlM
 V/nRy2AMheBedkJSMZJ7T4RJ8XkvsIGzFvMJ0vIVZyctXy81w3IWtjGBjqygV2kqf5UZ
 Q/1Z8cDnBexlFivsSCWxWEAuWWq8ig/9WLzzuxa5/YYU0bsBQpp7YhgdfZMn053/+rQd
 KDKoGNyRMp51tgJ7l12DgYwaZKzzShF29G8RhorAjoKNpmFBQEKI7HV/STyYkbz9FH/r eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 339jpahu4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:18:44 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 081936IG135998;
        Tue, 1 Sep 2020 05:18:43 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 339jpahu3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:18:43 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0819BmBR021235;
        Tue, 1 Sep 2020 09:18:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 337en89y31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 09:18:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0819H7IM64684342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Sep 2020 09:17:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12D3C4C052;
        Tue,  1 Sep 2020 09:18:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A4C34C044;
        Tue,  1 Sep 2020 09:18:38 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.37.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Sep 2020 09:18:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 3/3] s390x: Ultravisor guest API test
Date:   Tue,  1 Sep 2020 11:18:23 +0200
Message-Id: <20200901091823.14477-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200901091823.14477-1-frankja@linux.ibm.com>
References: <20200901091823.14477-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_04:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=3
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the error conditions of guest 2 Ultravisor calls, namely:
     * Query Ultravisor information
     * Set shared access
     * Remove shared access

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200810154541.32974-1-frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h  |  74 ++++++++++++++++++++++
 s390x/Makefile      |   1 +
 s390x/unittests.cfg |   3 +
 s390x/uv-guest.c    | 150 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+)
 create mode 100644 lib/s390x/asm/uv.h
 create mode 100644 s390x/uv-guest.c

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
new file mode 100644
index 0000000..4c2fc48
--- /dev/null
+++ b/lib/s390x/asm/uv.h
@@ -0,0 +1,74 @@
+/*
+ * s390x Ultravisor related definitions
+ *
+ * Copyright (c) 2020 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef UV_H
+#define UV_H
+
+#define UVC_RC_EXECUTED		0x0001
+#define UVC_RC_INV_CMD		0x0002
+#define UVC_RC_INV_STATE	0x0003
+#define UVC_RC_INV_LEN		0x0005
+#define UVC_RC_NO_RESUME	0x0007
+
+#define UVC_CMD_QUI			0x0001
+#define UVC_CMD_SET_SHARED_ACCESS	0x1000
+#define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
+
+/* Bits in installed uv calls */
+enum uv_cmds_inst {
+	BIT_UVC_CMD_QUI = 0,
+	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
+	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
+};
+
+struct uv_cb_header {
+	u16 len;
+	u16 cmd;	/* Command Code */
+	u16 rc;		/* Response Code */
+	u16 rrc;	/* Return Reason Code */
+} __attribute__((packed))  __attribute__((aligned(8)));
+
+struct uv_cb_qui {
+	struct uv_cb_header header;
+	u64 reserved08;
+	u64 inst_calls_list[4];
+	u64 reserved30[15];
+} __attribute__((packed))  __attribute__((aligned(8)));
+
+struct uv_cb_share {
+	struct uv_cb_header header;
+	u64 reserved08[3];
+	u64 paddr;
+	u64 reserved28;
+} __attribute__((packed))  __attribute__((aligned(8)));
+
+static inline int uv_call(unsigned long r1, unsigned long r2)
+{
+	int cc;
+
+	/*
+	 * The brc instruction will take care of the cc 2/3 case where
+	 * we need to continue the execution because we were
+	 * interrupted. The inline assembly will only return on
+	 * success/error i.e. cc 0/1.
+	*/
+	asm volatile(
+		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
+		"		brc	3,0b\n"
+		"		ipm	%[cc]\n"
+		"		srl	%[cc],28\n"
+		: [cc] "=d" (cc)
+		: [r1] "a" (r1), [r2] "a" (r2)
+		: "memory", "cc");
+	return cc;
+}
+
+#endif
diff --git a/s390x/Makefile b/s390x/Makefile
index 0f54bf4..c2213ad 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -18,6 +18,7 @@ tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
+tests += $(TEST_DIR)/uv-guest.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b35269b..6d50c63 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -92,3 +92,6 @@ extra_params = -device virtio-net-ccw
 [skrf]
 file = skrf.elf
 smp = 2
+
+[uv-guest]
+file = uv-guest.elf
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
new file mode 100644
index 0000000..d47333e
--- /dev/null
+++ b/s390x/uv-guest.c
@@ -0,0 +1,150 @@
+/*
+ * Guest Ultravisor Call tests
+ *
+ * Copyright (c) 2020 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+#include <asm/uv.h>
+
+static unsigned long page;
+
+static void test_priv(void)
+{
+	struct uv_cb_header uvcb = {};
+
+	report_prefix_push("privileged");
+
+	report_prefix_push("query");
+	uvcb.cmd = UVC_CMD_QUI;
+	uvcb.len = sizeof(struct uv_cb_qui);
+	expect_pgm_int();
+	enter_pstate();
+	uv_call(0, (u64)&uvcb);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("share");
+	uvcb.cmd = UVC_CMD_SET_SHARED_ACCESS;
+	uvcb.len = sizeof(struct uv_cb_share);
+	expect_pgm_int();
+	enter_pstate();
+	uv_call(0, (u64)&uvcb);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_push("unshare");
+	uvcb.cmd = UVC_CMD_REMOVE_SHARED_ACCESS;
+	uvcb.len = sizeof(struct uv_cb_share);
+	expect_pgm_int();
+	enter_pstate();
+	uv_call(0, (u64)&uvcb);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
+static void test_query(void)
+{
+	struct uv_cb_qui uvcb = {
+		.header.cmd = UVC_CMD_QUI,
+		.header.len = sizeof(uvcb) - 8,
+	};
+	int cc;
+
+	report_prefix_push("query");
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
+
+	uvcb.header.len = sizeof(uvcb);
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
+
+	/*
+	 * These bits have been introduced with the very first
+	 * Ultravisor version and are expected to always be available
+	 * because they are basic building blocks.
+	 */
+	report(uvcb.inst_calls_list[0] & (1UL << (63 - BIT_UVC_CMD_QUI)),
+	       "query indicated");
+	report(uvcb.inst_calls_list[0] & (1UL << (63 - BIT_UVC_CMD_SET_SHARED_ACCESS)),
+	       "share indicated");
+	report(uvcb.inst_calls_list[0] & (1UL << (63 - BIT_UVC_CMD_REMOVE_SHARED_ACCESS)),
+	       "unshare indicated");
+	report_prefix_pop();
+}
+
+static void test_sharing(void)
+{
+	struct uv_cb_share uvcb = {
+		.header.cmd = UVC_CMD_SET_SHARED_ACCESS,
+		.header.len = sizeof(uvcb) - 8,
+		.paddr = page,
+	};
+	int cc;
+
+	report_prefix_push("share");
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
+	uvcb.header.len = sizeof(uvcb);
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
+	report_prefix_pop();
+
+	report_prefix_push("unshare");
+	uvcb.header.cmd = UVC_CMD_REMOVE_SHARED_ACCESS;
+	uvcb.header.len -= 8;
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
+	uvcb.header.len = sizeof(uvcb);
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
+static void test_invalid(void)
+{
+	struct uv_cb_header uvcb = {
+		.len = 16,
+		.cmd = 0x4242,
+	};
+	int cc;
+
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.rc == UVC_RC_INV_CMD, "invalid command");
+}
+
+int main(void)
+{
+	bool has_uvc = test_facility(158);
+
+	report_prefix_push("uvc");
+	if (!has_uvc) {
+		report_skip("Ultravisor call facility is not available");
+		goto done;
+	}
+
+	page = (unsigned long)alloc_page();
+	test_priv();
+	test_invalid();
+	test_query();
+	test_sharing();
+	free_page((void *)page);
+done:
+	report_prefix_pop();
+	return report_summary();
+}
-- 
2.25.4

