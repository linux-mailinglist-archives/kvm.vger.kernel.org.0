Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221CD338A6A
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 11:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhCLKmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 05:42:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232999AbhCLKmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 05:42:02 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CAWmGh121304
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=wL4T/mFkbnpYrcVA8WWmuvgbSBeTrjZC+aZCIy8vfzI=;
 b=qxlqo3Ss90ndm7O56NK1mpbHLltndjUYzG6zCvSUG7XsiGslmxB5snCvqNp3AwdZ7z+B
 mzQVnZATg7tEiPzkINr/BntM2bSt7yOfRAH9lKuRx7MITvaXVMlfOFhGUkcYtg3tyVhT
 f2oEgnYnO26648zpD4MN0SQEBkDPNY+XxXIrDL5HgTj161SAXPE5DN3w7Tbp3eT79X5x
 /bMbam1po4ypAWFRJEskuxYSqvUmIOvac7p5q3AJLZ7HKbAR3P42ZCdjws5yozFpjR+y
 wzLWFhK+BSPlLIO27DJmiPMyjuICKHAHhLP2KOXRLlkXcWwqWFIOAPLVuopvqV2eqAG7 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774mf61vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:02 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CAX4tE121894
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:01 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774mf61uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 05:42:01 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CAfkTf010302;
        Fri, 12 Mar 2021 10:41:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 376agr1dvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 10:41:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CAfuCq33489232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 10:41:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FAE2AE04D;
        Fri, 12 Mar 2021 10:41:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28BBCAE051;
        Fri, 12 Mar 2021 10:41:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.32.251])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 10:41:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 2/6] s390x: css: simplifications of the tests
Date:   Fri, 12 Mar 2021 11:41:50 +0100
Message-Id: <1615545714-13747-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120072
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
 lib/s390x/css_lib.c | 41 ++++++++++++++++++++++++++---------------
 s390x/css.c         | 15 +++++----------
 3 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 3dc2f31..b9e4c08 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -278,6 +278,7 @@ int css_enumerate(void);
 
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
+bool css_enabled(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 3c1acbf..a97d61e 100644
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
@@ -250,10 +265,6 @@ void css_irq_io(void)
 		       lowcore_ptr->io_int_param, sid);
 		goto pop;
 	}
-	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
-			lowcore_ptr->subsys_id_word,
-			lowcore_ptr->io_int_param,
-			lowcore_ptr->io_int_word);
 	report_prefix_pop();
 
 	report_prefix_push("tsch");
diff --git a/s390x/css.c b/s390x/css.c
index 12036b3..a477833 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -25,6 +25,7 @@ static unsigned long cu_type = DEFAULT_CU_TYPE;
 
 static int test_device_sid;
 static struct senseid *senseid;
+struct ccw1 *ccw;
 
 static void test_enumerate(void)
 {
@@ -58,7 +59,6 @@ static void test_enable(void)
  */
 static void test_sense(void)
 {
-	struct ccw1 *ccw;
 	int ret;
 	int len;
 
@@ -74,18 +74,12 @@ static void test_sense(void)
 		return;
 	}
 
-	ret = register_io_int_func(css_irq_io);
-	if (ret) {
-		report(0, "Could not register IRQ handler");
-		return;
-	}
-
 	lowcore_ptr->io_int_param = 0;
 
 	senseid = alloc_io_mem(sizeof(*senseid), 0);
 	if (!senseid) {
 		report(0, "Allocation of senseid");
-		goto error_senseid;
+		return;
 	}
 
 	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
@@ -137,12 +131,13 @@ error:
 	free_io_mem(ccw, sizeof(*ccw));
 error_ccw:
 	free_io_mem(senseid, sizeof(*senseid));
-error_senseid:
-	unregister_io_int_func(css_irq_io);
 }
 
 static void css_init(void)
 {
+	assert(register_io_int_func(css_irq_io) == 0);
+	lowcore_ptr->io_int_param = 0;
+
 	report(get_chsc_scsc(), "Store Channel Characteristics");
 }
 
-- 
2.17.1

