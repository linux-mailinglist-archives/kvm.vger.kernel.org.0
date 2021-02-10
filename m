Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FD43167E5
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBJNVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:21:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231865AbhBJNVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 08:21:13 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AD2Xwb152926;
        Wed, 10 Feb 2021 08:20:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=9wHg7THNyebN4vwwx8EoOuILYbk2bcaEDUYnfyp2CWA=;
 b=ZJZnxfqjyJAdR2EBKXG9HjRofJ4K3NB5OiptKdWiVYd9Qf8KYil8eNGRbcnzeSl6/hiO
 2rplAcALrKCWd0W2bI+AziL4XuOpF5XaBw42PmchyvByWz/zI1uW7olr3pSQ+bEKiwGu
 hwS2AFLEQfL05/fK5pRMDjg0HevUMhE6BcZqWW99Zj9my8lD8rt7dnNERmhdnWDTEyry
 vi90Jqewtfbo2TRGhY/1FcGJh+oD4GJgMqbw/zLMeEs4bJJQAISwfaA2LgzpVT3l7p1N
 lZs0Q3Y5RJLEXiTq/crhjrHjlUw90ML3O/4XbT0HrcpEfDby8RlmSOpUXlNoYVlwOlXv Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfes9p95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AD2Zaf153167;
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfes9p84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ADHok9014330;
        Wed, 10 Feb 2021 13:20:19 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 36hjr8agea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 13:20:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ADKGJS36962574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 13:20:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 942A54C044;
        Wed, 10 Feb 2021 13:20:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C3DC4C040;
        Wed, 10 Feb 2021 13:20:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.174.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 13:20:16 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/5] s390x: css: simplifications of the tests
Date:   Wed, 10 Feb 2021 14:20:11 +0100
Message-Id: <1612963214-30397-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to ease the writing of tests based on:
- interrupt
- enabling a subchannel
- using multiple I/O on a channel without disabling it

We do the following simplifications:
- the I/O interrupt handler is registered on CSS initialization
- We do not enable again a subchannel in senseid if it is already
  enabled
- we add a css_enabled() function to test if a subchannel is enabled

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 37 ++++++++++++++++++++++----------
 s390x/css.c         | 51 ++++++++++++++++++++++++++-------------------
 3 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 1e317d1..fa8775f 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -278,6 +278,7 @@ int css_enumerate(void);
 
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
+bool css_enabled(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 88aa7a1..5426a6b 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -180,6 +180,31 @@ out:
 	return schid;
 }
 
+/*
+ * css_enabled: report if the subchannel is enabled
+ * @schid: Subchannel Identifier
+ * Return value:
+ *   true if the subchannel is enabled
+ *   false otherwise
+ */
+bool css_enabled(int schid)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: updating sch %08x failed with cc=%d",
+			    schid, cc);
+		return false;
+	}
+
+	if (!(pmcw->flags & PMCW_ENABLE)) {
+		report_info("stsch: sch %08x not enabled", schid);
+		return false;
+	}
+	return true;
+}
 /*
  * css_enable: enable the subchannel with the specified ISC
  * @schid: Subchannel Identifier
@@ -229,18 +254,8 @@ retry:
 	/*
 	 * Read the SCHIB again to verify the enablement
 	 */
-	cc = stsch(schid, &schib);
-	if (cc) {
-		report_info("stsch: updating sch %08x failed with cc=%d",
-			    schid, cc);
-		return cc;
-	}
-
-	if ((pmcw->flags & flags) == flags) {
-		report_info("stsch: sch %08x successfully modified after %d retries",
-			    schid, retry_count);
+	if (css_enabled(schid))
 		return 0;
-	}
 
 	if (retry_count++ < MAX_ENABLE_RETRIES) {
 		mdelay(10); /* the hardware was not ready, give it some time */
diff --git a/s390x/css.c b/s390x/css.c
index 18dbf01..d4b3cc8 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -56,36 +56,27 @@ static void test_enable(void)
  * - We need the test device as the first recognized
  *   device by the enumeration.
  */
-static void test_sense(void)
+static bool do_test_sense(void)
 {
 	struct ccw1 *ccw;
+	bool success = false;
 	int ret;
 	int len;
 
 	if (!test_device_sid) {
 		report_skip("No device");
-		return;
+		return success;
 	}
 
-	ret = css_enable(test_device_sid, IO_SCH_ISC);
-	if (ret) {
-		report(0, "Could not enable the subchannel: %08x",
-		       test_device_sid);
-		return;
-	}
-
-	ret = register_io_int_func(css_irq_io);
-	if (ret) {
-		report(0, "Could not register IRQ handler");
-		return;
+	if (!css_enabled(test_device_sid)) {
+		report(0, "enabling subchannel %08x", test_device_sid);
+		return success;
 	}
 
-	lowcore_ptr->io_int_param = 0;
-
 	senseid = alloc_io_mem(sizeof(*senseid), 0);
 	if (!senseid) {
 		report(0, "Allocation of senseid");
-		goto error_senseid;
+		return success;
 	}
 
 	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
@@ -129,16 +120,21 @@ static void test_sense(void)
 	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
 		    senseid->reserved, senseid->cu_type, senseid->cu_model,
 		    senseid->dev_type, senseid->dev_model);
+	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
+		    senseid->cu_type);
 
-	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
-	       (uint16_t)cu_type, senseid->cu_type);
+	success = senseid->cu_type == cu_type;
 
 error:
 	free_io_mem(ccw, sizeof(*ccw));
 error_ccw:
 	free_io_mem(senseid, sizeof(*senseid));
-error_senseid:
-	unregister_io_int_func(css_irq_io);
+	return success;
+}
+
+static void test_sense(void)
+{
+	report(do_test_sense(), "Got CU type expected");
 }
 
 static void css_init(void)
@@ -146,8 +142,19 @@ static void css_init(void)
 	int ret;
 
 	ret = get_chsc_scsc();
-	if (!ret)
-		report(1, " ");
+	if (ret) {
+		report(0, "Could not get CHSC Characteristics");
+		return;
+	}
+
+	ret = register_io_int_func(css_irq_io);
+	if (ret) {
+		report(0, "Could not register IRQ handler");
+		return;
+	}
+	lowcore_ptr->io_int_param = 0;
+
+	report(1, "CSS initialized");
 }
 
 static struct {
-- 
2.17.1

