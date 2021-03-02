Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75C932A718
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449053AbhCBQDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:03:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1443480AbhCBL55 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 06:57:57 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122BZCNO139215
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ugfY0Whd30EIeUTNSVFcLdYnAAqB+5AWjdKqivTiCG4=;
 b=D+eGHvbfivG+gU7gi0rAq+hpiPBx281MbIs34AuOQjeelcMZGsxMY7g3/LQpCwCrW4W3
 3MEA6Kuj09xHRPnT3xxsmOYq3O6kyseyN+txAy9PHh67f0PnRUr+ID9nUHbxlY9AYOIq
 RezENV5Vh7YSK1KwgZ4NCiMshBltyHbif8XubmXVRDPiQ3aEW5Rngg9hGkO5i+pCugZF
 Q14BU5sKC0/KAx7cdWEVWRqit29XchrTONgam+rmePJRZAAtpC5JC8QOIbz1yQpWorIB
 EfJUxrXm/X1GxTeN6mSHjP5RNwej75YVzT8mFeEfz5Y2qKSyDFfoQewjUcsfQBh7GwZO IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371gvar9u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:41:15 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122BZmVW142051
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 06:41:14 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371gvar9t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 06:41:14 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122BbBC2009192;
        Tue, 2 Mar 2021 11:41:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmgsqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 11:41:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122Bf9g421823882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 11:41:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7688BAE045;
        Tue,  2 Mar 2021 11:41:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E257AE053;
        Tue,  2 Mar 2021 11:41:09 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 11:41:09 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v4 3/3] s390x: mvpg: skip some tests when using TCG
Date:   Tue,  2 Mar 2021 12:41:07 +0100
Message-Id: <20210302114107.501837-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302114107.501837-1-imbrenda@linux.ibm.com>
References: <20210302114107.501837-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_03:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TCG is known to fail these tests, so add an explicit exception to skip them.

Once TCG has been fixed, it will be enough to revert this patch.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/mvpg.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 1776ec6e..5743d5b6 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -20,6 +20,7 @@
 #include <smp.h>
 #include <alloc_page.h>
 #include <bitops.h>
+#include <vm.h>
 
 /* Used to build the appropriate test values for register 0 */
 #define KFC(x) ((x) << 10)
@@ -225,20 +226,29 @@ static void test_mmu_prot(void)
 	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
 	fresh += PAGE_SIZE;
 
-	protect_page(fresh, PAGE_ENTRY_I);
-	cc = mvpg(CCO, fresh, source);
-	report(cc == 1, "destination invalid");
-	fresh += PAGE_SIZE;
+	/* Known issue in TCG: CCO flag is not honoured */
+	if (vm_is_tcg()) {
+		report_prefix_push("TCG");
+		report_skip("destination invalid");
+		report_skip("source invalid");
+		report_skip("source and destination invalid");
+		report_prefix_pop();
+	} else {
+		protect_page(fresh, PAGE_ENTRY_I);
+		cc = mvpg(CCO, fresh, source);
+		report(cc == 1, "destination invalid");
+		fresh += PAGE_SIZE;
 
-	protect_page(source, PAGE_ENTRY_I);
-	cc = mvpg(CCO, fresh, source);
-	report(cc == 2, "source invalid");
-	fresh += PAGE_SIZE;
+		protect_page(source, PAGE_ENTRY_I);
+		cc = mvpg(CCO, fresh, source);
+		report(cc == 2, "source invalid");
+		fresh += PAGE_SIZE;
 
-	protect_page(fresh, PAGE_ENTRY_I);
-	cc = mvpg(CCO, fresh, source);
-	report(cc == 2, "source and destination invalid");
-	fresh += PAGE_SIZE;
+		protect_page(fresh, PAGE_ENTRY_I);
+		cc = mvpg(CCO, fresh, source);
+		report(cc == 2, "source and destination invalid");
+		fresh += PAGE_SIZE;
+	}
 
 	unprotect_page(source, PAGE_ENTRY_I);
 	report_prefix_pop();
-- 
2.26.2

