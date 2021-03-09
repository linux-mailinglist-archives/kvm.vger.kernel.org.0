Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2EC3325D0
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCIMvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:51:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231265AbhCIMvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 07:51:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129CWuRt077292
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xCPSGl1tNO2kMMwukic+d4g8c7Iq3WaOy1lroRlL6OA=;
 b=Zueh5p9dtqda/rVdyU1TkzUcnKHFR+bRYcnGnXxYhOiy/dIL3N1pXoqocRl0zEIblQP7
 3R3y9Rgi9s5iR3fzeVrNIQb1siXNKoGaTsd10YkWrhUIOhXdXqOxlHZbopQ/Ehyh3baZ
 SuFARmmtsxgu+urZWZf1tMKBYfI9NdP2URri0UZfa9f9xd9Ap2iAJnnS/FkEEe7OQhqN
 qkzGX3rCAtTfHQKiHCuak9B5ILlWE8FLhtAIeB6n3B1eyq2Eu7KDVhACvFD5DQJ9xFqC
 tw9e5ejQV+ir4IKqflQTBEf6xryqPhfNVnj+JBbLldyYtkP8YCK5b4khdKcuohqdCyYI uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375whqt3un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 07:51:25 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129CXm2u083290
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:24 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375whqt3t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 07:51:24 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129CSjtN027496;
        Tue, 9 Mar 2021 12:51:22 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3768t4g12m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 12:51:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129CpJOn46203258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 12:51:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 913B852069;
        Tue,  9 Mar 2021 12:51:19 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 33B3752063;
        Tue,  9 Mar 2021 12:51:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 2/6] s390x: css: simplifications of the tests
Date:   Tue,  9 Mar 2021 13:51:13 +0100
Message-Id: <1615294277-7332-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090062
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
 s390x/css.c         |  3 +++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index fe68b7d..71d91f0 100644
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
index 12036b3..069c2be 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -143,6 +143,9 @@ error_senseid:
 
 static void css_init(void)
 {
+	assert(register_io_int_func(css_irq_io) == 0);
+	lowcore_ptr->io_int_param = 0;
+
 	report(get_chsc_scsc(), "Store Channel Characteristics");
 }
 
-- 
2.17.1

