Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771FB3791FC
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbhEJPGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:06:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232146AbhEJPDQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:03:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AEcQhA060412;
        Mon, 10 May 2021 11:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XsUv/2HwzPakkhxVHIjDfFbSEmKCTHFzTgeoGj3ch4o=;
 b=BQhtJErwE3iG9wAtamSUZvUTR2BvB2Yjq56tQZLcy3T23j6ZJDkmc+ZnCp4A7Qnh4EHC
 BbRo9Afm4q8aTYUj6RpjSj9gG6yUDS9Enzt/gDxELU1zZteC3OTvX7VdHAzKW3KR2r01
 qr6GG1ezWHfdrneEtyZI78fVbAiZeL24Z+FBgNfGKIWZUkgi/SDoX68VFcV8rClnjHyY
 VywycFDZIZm7qf3OC1Hf3ryTdWj2ZTDPQZv216/snezJSsNodg17eSqfkIKDyq3wOC9v
 cxzwSxjBTcta6swdSg/6RuX/1pU348C3I7/qn+LDVCxTVL2DSgd6zSLrbRtPw/WwYvPt 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f21t9m8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:04 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AEceoc062447;
        Mon, 10 May 2021 11:02:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f21t9m7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AEqslZ006456;
        Mon, 10 May 2021 15:02:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38dj9891w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 15:02:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AF1w5e24051974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 15:01:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72E57AE057;
        Mon, 10 May 2021 15:01:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7F3CAE045;
        Mon, 10 May 2021 15:01:57 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 15:01:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH 3/4] s390x: cpumodel: FMT4 SCLP test
Date:   Mon, 10 May 2021 15:00:14 +0000
Message-Id: <20210510150015.11119-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510150015.11119-1-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ClxRzRAAAgcDWIfqSF8_QdcXqaB-9Qcr
X-Proofpoint-ORIG-GUID: I-Kn0gR8UAJf2NZQDSIATEoB1Bfn_fkD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SCLP is also part of the cpumodel, so we need to make sure that the
features indicated via read info / read cpu info are correct.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/cpumodel.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 4dd8b96f..619c3dc7 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -2,14 +2,69 @@
 /*
  * Test the known dependencies for facilities
  *
- * Copyright 2019 IBM Corp.
+ * Copyright 2019, 2021 IBM Corp.
  *
  * Authors:
  *    Christian Borntraeger <borntraeger@de.ibm.com>
+ *    Janosch Frank <frankja@linux.ibm.com>
  */
 
 #include <asm/facility.h>
 #include <vm.h>
+#include <sclp.h>
+#include <uv.h>
+#include <asm/uv.h>
+
+static void test_sclp_missing_sief2_implications(void)
+{
+	/* Virtualization related facilities */
+	report(!sclp_facilities.has_64bscao, "!64bscao");
+	report(!sclp_facilities.has_pfmfi, "!pfmfi");
+	report(!sclp_facilities.has_gsls, "!gsls");
+	report(!sclp_facilities.has_cmma, "!cmma");
+	report(!sclp_facilities.has_esca, "!esca");
+	report(!sclp_facilities.has_kss, "!kss");
+	report(!sclp_facilities.has_ibs, "!ibs");
+
+	/* Virtualization related facilities reported via CPU entries */
+	report(!sclp_facilities.has_sigpif, "!sigpif");
+	report(!sclp_facilities.has_sief2, "!sief2");
+	report(!sclp_facilities.has_skeyi, "!skeyi");
+	report(!sclp_facilities.has_siif, "!siif");
+	report(!sclp_facilities.has_cei, "!cei");
+	report(!sclp_facilities.has_ib, "!ib");
+}
+
+static void test_sclp_features_fmt4(void)
+{
+	/*
+	 * STFLE facilities are handled by the Ultravisor but SCLP
+	 * facilities are advertised by the hypervisor.
+	 */
+	report_prefix_push("PV guest implies");
+
+	/* General facilities */
+	report(!sclp_facilities.has_diag318, "!diag318");
+
+	/*
+	 * Virtualization related facilities, all of which are
+	 * unavailable because there's no virtualization support in a
+	 * protected guest.
+	 */
+	test_sclp_missing_sief2_implications();
+
+	report_prefix_pop();
+}
+
+static void test_sclp_features(void)
+{
+	report_prefix_push("sclp");
+
+	if (uv_os_is_guest())
+		test_sclp_features_fmt4();
+
+	report_prefix_pop();
+}
 
 static struct {
 	int facility;
@@ -60,6 +115,8 @@ int main(void)
 	}
 	report_prefix_pop();
 
+	test_sclp_features();
+
 	report_prefix_pop();
 	return report_summary();
 }
-- 
2.30.2

