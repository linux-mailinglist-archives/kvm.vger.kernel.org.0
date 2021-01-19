Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0C2FC068
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 20:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbhASTx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 14:53:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392074AbhASTxY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 14:53:24 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JJW8w1190112;
        Tue, 19 Jan 2021 14:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=MbFOPjX7APzijhAifwN8gTGQ4+/y6UaXufsco1nF+LU=;
 b=fRAnmUZJQetUZmChmB7Q2YIm5dzf94gDWfvYsJX6KqUYOhyLuf4RX7lFpPfnGKHUygxz
 chUbSX+60VDzOfpsoxQExvaN/LYZ9D+WJPRZ+vxG6uSqMbSd25ENEdqOh4uQIlrnOJi3
 C2kP2Re/kFO/FSpBfHdOJU9CYoEiLJO7WNxH/juLtrUwHKDy2D24PJ+SPkYt9M0K0Qy4
 i1LZdgoOWi8KGbbhXG5Lr6V9PeqtRBfkrTjNOhMB/IE2Fsyjnn7kADb28JsQ2FR3ypqD
 YyhEfyZOQO/TLRG82mcDru9HH7pBp2VHuQONlJJOEY270h27S2vogoqg2GzQ/pwQelAr Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36653s1eb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:34 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JJWM9L191080;
        Tue, 19 Jan 2021 14:52:33 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36653s1e9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:33 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJlT1o030352;
        Tue, 19 Jan 2021 19:52:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 363qs7kdkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 19:52:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JJqRuU34734520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 19:52:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A4CB42045;
        Tue, 19 Jan 2021 19:52:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E91294203F;
        Tue, 19 Jan 2021 19:52:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.38.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 19:52:26 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/3] s390x: css: pv: css test adaptation for PV
Date:   Tue, 19 Jan 2021 20:52:24 +0100
Message-Id: <1611085944-21609-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_07:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want the tests to automatically work with or without protected
virtualisation.
To do this we need to share the I/O memory with the host.

Let's replace all static allocations with dynamic allocations
to clearly separate shared and private memory.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  3 +--
 lib/s390x/css_lib.c | 28 ++++++++--------------------
 s390x/css.c         | 35 ++++++++++++++++++++++++-----------
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 221b67c..e3dee9f 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -283,8 +283,7 @@ int css_enable(int schid, int isc);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
-int start_single_ccw(unsigned int sid, int code, void *data, int count,
-		     unsigned char flags);
+struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags);
 void css_irq_io(void);
 int css_residual_count(unsigned int schid);
 
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 8e02371..6a0a0ec 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -18,6 +18,7 @@
 #include <asm/time.h>
 #include <asm/arch_def.h>
 
+#include <malloc_io.h>
 #include <css.h>
 
 static struct schib schib;
@@ -202,33 +203,20 @@ int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
 	return ssch(sid, &orb);
 }
 
-/*
- * In the future, we want to implement support for CCW chains;
- * for that, we will need to work with ccw1 pointers.
- */
-static struct ccw1 unique_ccw;
-
-int start_single_ccw(unsigned int sid, int code, void *data, int count,
-		     unsigned char flags)
+struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
 {
-	int cc;
-	struct ccw1 *ccw = &unique_ccw;
+	struct ccw1 *ccw;
+
+	ccw = alloc_io_page(sizeof(*ccw));
+	if (!ccw)
+		return NULL;
 
-	report_prefix_push("start_subchannel");
-	/* Build the CCW chain with a single CCW */
 	ccw->code = code;
 	ccw->flags = flags;
 	ccw->count = count;
 	ccw->data_address = (int)(unsigned long)data;
 
-	cc = start_ccw1_chain(sid, ccw);
-	if (cc) {
-		report(0, "cc = %d", cc);
-		report_prefix_pop();
-		return cc;
-	}
-	report_prefix_pop();
-	return 0;
+	return ccw;
 }
 
 /* wait_and_check_io_completion:
diff --git a/s390x/css.c b/s390x/css.c
index ee3bc83..4b0b6b1 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -17,13 +17,15 @@
 #include <interrupt.h>
 #include <asm/arch_def.h>
 
+#include <malloc_io.h>
 #include <css.h>
+#include <asm/barrier.h>
 
 #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
 static unsigned long cu_type = DEFAULT_CU_TYPE;
 
 static int test_device_sid;
-static struct senseid senseid;
+static struct senseid *senseid;
 
 static void test_enumerate(void)
 {
@@ -57,6 +59,7 @@ static void test_enable(void)
  */
 static void test_sense(void)
 {
+	struct ccw1 *ccw;
 	int ret;
 	int len;
 
@@ -80,9 +83,15 @@ static void test_sense(void)
 
 	lowcore_ptr->io_int_param = 0;
 
-	memset(&senseid, 0, sizeof(senseid));
-	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
-			       &senseid, sizeof(senseid), CCW_F_SLI);
+	senseid = alloc_io_page(sizeof(*senseid));
+	if (!senseid)
+		goto error_senseid;
+
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	if (!ccw)
+		goto error_ccw;
+
+	ret = start_ccw1_chain(test_device_sid, ccw);
 	if (ret)
 		goto error;
 
@@ -97,7 +106,7 @@ static void test_sense(void)
 	if (ret < 0) {
 		report_info("no valid residual count");
 	} else if (ret != 0) {
-		len = sizeof(senseid) - ret;
+		len = sizeof(*senseid) - ret;
 		if (ret && len < CSS_SENSEID_COMMON_LEN) {
 			report(0, "transferred a too short length: %d", ret);
 			goto error;
@@ -105,21 +114,25 @@ static void test_sense(void)
 			report_info("transferred a shorter length: %d", len);
 	}
 
-	if (senseid.reserved != 0xff) {
-		report(0, "transferred garbage: 0x%02x", senseid.reserved);
+	if (senseid->reserved != 0xff) {
+		report(0, "transferred garbage: 0x%02x", senseid->reserved);
 		goto error;
 	}
 
 	report_prefix_pop();
 
 	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
-		    senseid.reserved, senseid.cu_type, senseid.cu_model,
-		    senseid.dev_type, senseid.dev_model);
+		    senseid->reserved, senseid->cu_type, senseid->cu_model,
+		    senseid->dev_type, senseid->dev_model);
 
-	report(senseid.cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
-	       (uint16_t) cu_type, senseid.cu_type);
+	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
+	       (uint16_t) cu_type, senseid->cu_type);
 
 error:
+	free_io_page(ccw);
+error_ccw:
+	free_io_page(senseid);
+error_senseid:
 	unregister_io_int_func(css_irq_io);
 }
 
-- 
2.17.1

