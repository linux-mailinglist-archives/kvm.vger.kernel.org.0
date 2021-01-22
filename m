Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C568A300435
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 14:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbhAVN3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 08:29:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727820AbhAVN2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 08:28:46 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MD3n4B013952;
        Fri, 22 Jan 2021 08:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=qSBd3yc0B8T/cdxB3IJUXQDib3wdg3X1Fd1lbKhndh4=;
 b=hcUcNYibrkkzOzSpIhFfX5Ai1opuOMQ/2F7vrGbyjA/V5Vr2/19xln+vxUPzjnp0ETAF
 151dlqM+3x657gQmCcico0zCZuM+Vp0BuSXePiLJKdD6O6mRuxofQ50+ND0bpTjsikSg
 LKybmxcaBzVJshjzJy19YcSQm986SB+cpcDnNni+koPf31iOTlPSXkfIBxS1u6e/t+jm
 KU0qWCF5O9fDW8sugNF8/dQZlK0AT3dGwtYVqRAMVOxGte4IdLAk5v8a8ei8tnFuoyiJ
 E4lcE6piHkZ0gj2JmeEsRsDXj4VR52HDE+CKhJWHiOBX4FNm/PncxVBs1NH380Fd/c0l Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367wm73srk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:27:49 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MD4LgD020479;
        Fri, 22 Jan 2021 08:27:49 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367wm73sqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:27:49 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MDJp7E015192;
        Fri, 22 Jan 2021 13:27:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 367k1c0aae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 13:27:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MDRiOE36372940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 13:27:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6639DA404D;
        Fri, 22 Jan 2021 13:27:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF499A4040;
        Fri, 22 Jan 2021 13:27:43 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.82.252])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 13:27:43 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v5 3/3] s390x: css: pv: css test adaptation for PV
Date:   Fri, 22 Jan 2021 14:27:40 +0100
Message-Id: <1611322060-1972-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want the tests to automatically work with or without protected
virtualisation.
To do this we need to share the I/O memory with the host.

Let's replace all static allocations with dynamic allocations
to clearly separate shared and private memory.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@de.ibm.com>
---
 lib/s390x/css.h     |  3 +--
 lib/s390x/css_lib.c | 28 ++++++++--------------------
 s390x/css.c         | 43 +++++++++++++++++++++++++++++++------------
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index d10d265..3e57445 100644
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
index 5af6f77..3c24480 100644
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
index 23a7b7c..1a61a5c 100644
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
2.17.1

