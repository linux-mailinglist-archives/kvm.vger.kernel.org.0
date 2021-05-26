Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF9391AED
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhEZO5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:57:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235216AbhEZO5c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:57:32 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QEhM7P145542;
        Wed, 26 May 2021 10:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x753QCuUtpfkDxdhBsKm6pABBw8Ei9O9gGCL8X1s0vw=;
 b=lhixkU2DDkEtSeIcx5dtF1gmxSWu2c6j2FGYp7bum4sV76dl9WdNj6UG7ykV92+0jJIq
 8O1LO4dgnFXLfF/Ogn+S6hUnlhaxp2TdiSz2/dY6ZZs9rNWxImDogx/JR62KqwAEyYf+
 ve3gqeBAfOlo/tBNsmvyyYVpqTyrqihmSyl94W/9dzrKSn2XeH/C5glbSHpGnPSP3FuP
 aqZdt3QbuGt5rfW+EgX0lizQzcdjqhzPl8i6yeEURxU+U0ZuaoMIkJ4svTPg3JkyR93K
 FQNudgAVp6JX2+ESd692ThOqLgPEl/Pi53rUZuvvhw6UVOoqyyL5Q77WGKdAsE1OpVuK IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38srbd0d1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:56:01 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QEhQBC145765;
        Wed, 26 May 2021 10:56:00 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38srbd0d0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:56:00 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QEqtYT019741;
        Wed, 26 May 2021 14:55:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 38s1r50be7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 14:55:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QEtPvB9830772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 14:55:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EF19A409B;
        Wed, 26 May 2021 14:55:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BF1A408C;
        Wed, 26 May 2021 14:55:53 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.174.11])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 14:55:53 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 9/9] s390x: cpumodel: FMT2 and FMT4 SCLP test
Date:   Wed, 26 May 2021 16:55:39 +0200
Message-Id: <20210526145539.52008-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526145539.52008-1-frankja@linux.ibm.com>
References: <20210526145539.52008-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4iMOAySniT1stY325jnyMU7e9e56kg7d
X-Proofpoint-GUID: s37yLRlZC76jvqe2W4JsADFDFJV5hIwC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SCLP is also part of the cpumodel, so we need to make sure that the
features indicated via read info / read cpu info are correct.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/cpumodel.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 4dd8b96f..67bb6543 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -2,14 +2,81 @@
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
+static void test_sclp_features_fmt2(void)
+{
+	if (sclp_facilities.has_sief2)
+		return;
+
+	report_prefix_push("!sief2 implies");
+	test_sclp_missing_sief2_implications();
+	report_prefix_pop();
+}
+
+static void test_sclp_features(void)
+{
+	report_prefix_push("sclp");
+
+	if (uv_os_is_guest())
+		test_sclp_features_fmt4();
+	else
+		test_sclp_features_fmt2();
+
+	report_prefix_pop();
+}
 
 static struct {
 	int facility;
@@ -60,6 +127,8 @@ int main(void)
 	}
 	report_prefix_pop();
 
+	test_sclp_features();
+
 	report_prefix_pop();
 	return report_summary();
 }
-- 
2.31.1

