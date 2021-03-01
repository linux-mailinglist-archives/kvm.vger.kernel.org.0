Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99734327D82
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhCALsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:48:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61532 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234185AbhCALr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 06:47:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121BXgB6099386
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UuaM3bqmOVYkKvf5PYh8XQQOHIstM7b9SFYJpuY1/rk=;
 b=oIVFQEslUn2z4siUAFrjxBOBGCu72Eh8WNbYBbWivV/UF2Ql+sNP8SqTBDYjEP42qDrh
 Pd7Bzq8t5+T1eaXpaxTvMYXptwuPXhIsu8XldY9aTylS2XT8/3d/25kTxP7v9TVY0uHo
 EyvQJeQLT3L8ioWzOg51ujWfGia5tM69jt9bVaodi1w+924/mXC/F7O9UzFnCDQzF1oc
 DUPqeCTKUewGZy1YdbKnMBzmEKNVhROjFJlgUMuCt4O1HzHAIuhKL5hAPG2yGNtE9mU+
 JACydFfvLxi5LZ8SoTi72o9PTqBZtmCqapqXep4NHPToXkzrFVVJndMFtqbczdMCqVbu 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370yau8myu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 06:47:12 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121BY5u8100753
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:12 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370yau8my5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 06:47:12 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121Bhxuu016183;
        Mon, 1 Mar 2021 11:47:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 370atn0eyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 11:47:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121Bl7ku18219488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 11:47:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1179AE04D;
        Mon,  1 Mar 2021 11:47:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B895AE051;
        Mon,  1 Mar 2021 11:47:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.52.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 11:47:07 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the tests
Date:   Mon,  1 Mar 2021 12:47:01 +0100
Message-Id: <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_06:2021-02-26,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103010098
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
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 37 ++++++++++++++++++++++++++-----------
 s390x/css.c         | 44 ++++++++++++++++++++++++--------------------
 3 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 4210472..fbfa034 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -278,6 +278,7 @@ int css_enumerate(void);
 
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
+bool css_enabled(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index f46e871..41134dc 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -161,6 +161,31 @@ out:
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
@@ -210,18 +235,8 @@ retry:
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
index 09703c1..c9e4903 100644
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
+	if (!css_enabled(test_device_sid)) {
+		report(0, "enabling subchannel %08x", test_device_sid);
+		return success;
 	}
 
-	ret = register_io_int_func(css_irq_io);
-	if (ret) {
-		report(0, "Could not register IRQ handler");
-		return;
-	}
-
-	lowcore_ptr->io_int_param = 0;
-
 	senseid = alloc_io_mem(sizeof(*senseid), 0);
 	if (!senseid) {
 		report(0, "Allocation of senseid");
-		goto error_senseid;
+		return success;
 	}
 
 	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
@@ -129,21 +120,34 @@ static void test_sense(void)
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
 {
 	report(!!get_chsc_scsc(), "Store Channel Characteristics");
+
+	if (register_io_int_func(css_irq_io)) {
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

