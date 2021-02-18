Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B8C31EE55
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhBRSbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:31:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234224AbhBRR1w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:27:52 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNVMs153363
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rgG0ABIMIv1EdWFSyrwrQbYbjJpBSY9orQc/Jgh8uvE=;
 b=ahxZGWPUNkfQqkqyl28r3Bbi8/JeaIdQ1Eqyp97bXrQJ9gDBoUgEA/ydR4yruJm3RNnr
 pcmcIcojIVni7VkX2xLpfhW3+clwVHI7jGruRq487+jzzukpvdI+9fgPnSXGH83coswG
 DONbtKtHC6U6Hht5MyRhVXsOiTc71nqcJoL/nwpUwYSpObrOQviZKnB7RUbbhcdysLbl
 E9UtOKk6mu+b8aUvEZWCmTWVIdIEoNPgAC/Q4CypTc6CSpAmA4kJ4F9JbgqRzFZ9yphp
 jQeMLygEww5DgaTu28hA0J83FMqi/ig20Mh8w3VnTRG3GNBjkEYk0QriK6LtZrFTVjGn Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36sttu3y3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:51 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHNqXO153677
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:51 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36sttu3y2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:26:51 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNoPG011314;
        Thu, 18 Feb 2021 17:26:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d8cvks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:26:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHQlWe62718266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:26:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E53FEA4051;
        Thu, 18 Feb 2021 17:26:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C7C7A404D;
        Thu, 18 Feb 2021 17:26:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:26:46 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 2/5] s390x: css: simplifications of the tests
Date:   Thu, 18 Feb 2021 18:26:41 +0100
Message-Id: <1613669204-6464-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_07:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 impostorscore=0
 phishscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102180141
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
 lib/s390x/css_lib.c | 37 ++++++++++++++++++++++----------
 s390x/css.c         | 51 ++++++++++++++++++++++++++-------------------
 3 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 49daecd..794321d 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -278,6 +278,7 @@ int css_enumerate(void);
 
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
+bool css_enabled(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 64560a2..65b58ff 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -178,6 +178,31 @@ out:
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
@@ -227,18 +252,8 @@ retry:
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
2.25.1

