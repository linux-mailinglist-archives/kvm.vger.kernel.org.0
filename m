Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5E4354E05
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbhDFHlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235371AbhDFHlI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:08 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367Xn7T060651
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=F/E0Lol3oE0vyXaaKVcHWp+H0qjNkRNBGzpkt+iBzmA=;
 b=AGMMOCJiRwa0lCaWSYt53l2ykXnqzMi1wA6pCyw/7DtVNfHICLsfOh/cYljAyi3mBghF
 BJLsT6cuInJM+b/uKZ2uc3a0gsYyxf6Ap843Xgfq0BlmoZQeiIKbW00Ea6l5N7NLDt40
 hgpFKG5ZXlPcHkAf9S2IB+EzqLSTZqI5PoUXQGzKgS2n4A5DlOt9QN0A6YQ2YqmrcM+l
 JAzWmD924luUlnjdTs37eJZ90Pit/DB/16jymq7yCpbsUjwgLckcCJGgeBJNFML3LuZZ
 NvCGN6XVePLy0AyowcibCBQHBXtroU8CLLdtmGm1Yj9KfTe1v9OAlcmdB1t6t7aU3YBz bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5bys1m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:01 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367euK6086779
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:00 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5bys1kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:00 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wm3x026067;
        Tue, 6 Apr 2021 07:40:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37q2q5hwxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:40:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367etMQ32964958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 575904C040;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2C74C044;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:54 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 01/16] s390x: lib: css: disabling a subchannel
Date:   Tue,  6 Apr 2021 09:40:38 +0200
Message-Id: <1617694853-6881-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zv0kPxqqPypSp-oIKEzkFN0NONL3C7Gv
X-Proofpoint-ORIG-GUID: l-UEWGU4iqbkeSrLg28CJWoa9UQnh2vF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests require to disable a subchannel.
Let's implement the css_disable() function.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 lib/s390x/css_lib.c | 63 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7e3d261..b0de3a3 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -284,6 +284,7 @@ int css_enumerate(void);
 #define IO_SCH_ISC      3
 int css_enable(int schid, int isc);
 bool css_enabled(int schid);
+int css_disable(int schid);
 
 /* Library functions */
 int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index efc7057..9711b0b 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -186,6 +186,69 @@ bool css_enabled(int schid)
 	}
 	return true;
 }
+
+/*
+ * css_disable: disable the subchannel
+ * @schid: Subchannel Identifier
+ * Return value:
+ *   On success: 0
+ *   On error the CC of the faulty instruction
+ *      or -1 if the retry count is exceeded.
+ */
+int css_disable(int schid)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int retries = 0;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
+		return cc;
+	}
+
+	if (!(pmcw->flags & PMCW_ENABLE)) {
+		report_info("stsch: sch %08x already disabled", schid);
+		return 0;
+	}
+
+	for (retries = 0; retries < MAX_ENABLE_RETRIES; retries++) {
+		/* Update the SCHIB to disable the subchannel */
+		pmcw->flags &= ~PMCW_ENABLE;
+
+		/* Tell the CSS we want to modify the subchannel */
+		cc = msch(schid, &schib);
+		/*
+		 * If the subchannel is status pending or if a function is in progress,
+		 * we consider both cases as errors.
+		 */
+		if (cc) {
+			report_info("msch: sch %08x failed with cc=%d", schid, cc);
+			return cc;
+		}
+
+		/* Read the SCHIB again to verify the disablement */
+		cc = stsch(schid, &schib);
+		if (cc) {
+			report_info("stsch: updating sch %08x failed with cc=%d", schid, cc);
+			return cc;
+		}
+
+		if (!(pmcw->flags & PMCW_ENABLE)) {
+			if (retries)
+				report_info("stsch: sch %08x successfully disabled after %d retries", schid, retries);
+			return 0;
+		}
+
+		/* the hardware was not ready, give it some time */
+		mdelay(10);
+	}
+
+	report_info("msch: modifying sch %08x failed after %d retries. pmcw flags: %04x",
+		    schid, retries, pmcw->flags);
+	return -1;
+}
 /*
  * css_enable: enable the subchannel with the specified ISC
  * @schid: Subchannel Identifier
-- 
2.17.1

