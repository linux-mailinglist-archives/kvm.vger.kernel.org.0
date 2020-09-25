Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E8278DC5
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 18:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgIYQO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 12:14:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11958 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbgIYQO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 12:14:26 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PGEBTS064961;
        Fri, 25 Sep 2020 12:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=tZWG+2p/xlDOByL5lYGeOEc7ZMoYpuu8PiqCDJ6CaFM=;
 b=d03JTltoDn6YAY4sDSgm/Y1UlmGTlcSg2Kq5jhzRDWIkkZC95tCNQ0UyQA8Y7+1qq8SA
 k7Vr+0Cxk+JmmvNu3sGNHfByvyJ93Nd0IuJOgX9weePX32VPMOVzSwPSM9+9ja4eXbvK
 wrUx/GnTrli00ZJ0Ss8x+iojTG7qZxRQIXVEKBL+UUgUYVJJLHlfQPJyXAE6MkhnvNCd
 vS5UIFKS8UoikYgzdEjhyt4rHI+Iv04i/Xr0y0Bemsk7DoEQTf3hDf40IPZlodNxd5YS
 YUbUazI/oBtWQEVzFB73vwoo7V+Qdz9NBi5AXf7GdQLLScfQCkR6HY4GthV9JdbQfjGQ zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33skw10021-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 12:14:24 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08PFWZ2g143948;
        Fri, 25 Sep 2020 12:03:28 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33sj762nwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 12:03:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08PFdCFF024477;
        Fri, 25 Sep 2020 16:02:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8ef2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 16:02:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08PG2m3e34275698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 16:02:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25A62A405F;
        Fri, 25 Sep 2020 16:02:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5646A405C;
        Fri, 25 Sep 2020 16:02:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.49.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Sep 2020 16:02:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v1 4/4] s390x: css: pv: css test adaptation for PV
Date:   Fri, 25 Sep 2020 18:02:44 +0200
Message-Id: <1601049764-11784-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
References: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_14:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 suspectscore=3 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=698 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250109
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
2.25.1

