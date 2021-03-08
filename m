Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16B23310F3
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHOgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:36:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhCHOf3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:35:29 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EYu4A103790;
        Mon, 8 Mar 2021 09:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UfgbS6YGkQ6Jyj5w5VUpIVuk3mgy1Iv9VNsg/1Y1jU0=;
 b=M7u/9MfPA7C2DoitjYtWcDmMsAHK7kZjzOCJ3e/SJxCFwNmaIyHGVeQdTpIRfQqTXlKh
 WMeFST5oYr/BFaTa63JXT9h+pxDnBFW7LK/OVNQuHDcIgfh0A5aw+x5wGkk7FuXPtTir
 tI/mXF694ftb6Kh8fzF/gEZYhN2Fk2C6Jwlv/1Nufv5GRg4esghd3mH2MpH3z/aHpjnH
 X5k9dSz5C2ZAbrgLj+j9vPZPTtKxRDCGWEic+xp/dZSlyjWUNLIPequLJWJRMCFRpqQi
 2pjzNK2sRjcmr79ktu+9Xib+NShnRFXkQb67ZCM0rYzeAQqqwqxmC/+1zN5bDE/AEsTk Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757wwmgrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:35:29 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EZSSt107371;
        Mon, 8 Mar 2021 09:35:28 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757wwmfk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:35:28 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EWar3027276;
        Mon, 8 Mar 2021 14:33:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3741c89wfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXO6635586466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BF09A4051;
        Mon,  8 Mar 2021 14:33:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 920F9A4040;
        Mon,  8 Mar 2021 14:33:38 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 04/16] s390x: css: pv: css test adaptation for PV
Date:   Mon,  8 Mar 2021 15:31:35 +0100
Message-Id: <20210308143147.64755-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We want the tests to automatically work with or without protected
virtualisation.
To do this we need to share the I/O memory with the host.

Let's replace all static allocations with dynamic allocations
to clearly separate shared and private memory.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@de.ibm.com>
Message-Id: <1611322060-1972-4-git-send-email-pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     |  3 +--
 lib/s390x/css_lib.c | 28 ++++++++--------------------
 s390x/css.c         | 43 +++++++++++++++++++++++++++++++------------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index d10d2655..3e574455 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -281,8 +281,7 @@ int css_enable(int schid, int isc);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
-int start_single_ccw(unsigned int sid, int code, void *data, int count,
-		     unsigned char flags);
+struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags);
 void css_irq_io(void);
 int css_residual_count(unsigned int schid);
 
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 5af6f776..3c244801 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -16,6 +16,7 @@
 #include <asm/time.h>
 #include <asm/arch_def.h>
 
+#include <malloc_io.h>
 #include <css.h>
 
 static struct schib schib;
@@ -200,33 +201,20 @@ int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw)
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
+	ccw = alloc_io_mem(sizeof(*ccw), 0);
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
index 23a7b7cb..1a61a5c2 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -15,13 +15,15 @@
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
@@ -55,6 +57,7 @@ static void test_enable(void)
  */
 static void test_sense(void)
 {
+	struct ccw1 *ccw;
 	int ret;
 	int len;
 
@@ -78,11 +81,23 @@ static void test_sense(void)
 
 	lowcore_ptr->io_int_param = 0;
 
-	memset(&senseid, 0, sizeof(senseid));
-	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
-			       &senseid, sizeof(senseid), CCW_F_SLI);
-	if (ret)
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	if (!senseid) {
+		report(0, "Allocation of senseid");
+		goto error_senseid;
+	}
+
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	if (!ccw) {
+		report(0, "Allocation of CCW");
+		goto error_ccw;
+	}
+
+	ret = start_ccw1_chain(test_device_sid, ccw);
+	if (ret) {
+		report(0, "Starting CCW chain");
 		goto error;
+	}
 
 	if (wait_and_check_io_completion(test_device_sid) < 0)
 		goto error;
@@ -95,7 +110,7 @@ static void test_sense(void)
 	if (ret < 0) {
 		report_info("no valid residual count");
 	} else if (ret != 0) {
-		len = sizeof(senseid) - ret;
+		len = sizeof(*senseid) - ret;
 		if (ret && len < CSS_SENSEID_COMMON_LEN) {
 			report(0, "transferred a too short length: %d", ret);
 			goto error;
@@ -103,21 +118,25 @@ static void test_sense(void)
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
+	       (uint16_t)cu_type, senseid->cu_type);
 
 error:
+	free_io_mem(ccw, sizeof(*ccw));
+error_ccw:
+	free_io_mem(senseid, sizeof(*senseid));
+error_senseid:
 	unregister_io_int_func(css_irq_io);
 }
 
-- 
2.29.2

