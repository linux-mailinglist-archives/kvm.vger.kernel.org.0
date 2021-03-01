Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144CC328B44
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 19:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhCASbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 13:31:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238569AbhCAS3T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 13:29:19 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121I9ALJ138763
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 13:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eVGH4vd8qOEiqJorQlkwwowiTEm15H8urLwpdIzX1/g=;
 b=kIJBAbs/5ikawehrBL8SR1y3EZqu4o9psoJCEJa8SGGqgLqOl50Y/bvekZi3UT7VXc+E
 iT0CV1F+G9t8E3I1LuQkkL0jDSfmdOY0MPGxRMFcAslYtUkRZq9w8crHABj1bhkJWRkO
 Hp9Ot5zmWIb4nWoUTr5JZOQgTU+vBDhUVyonyj/mA+EWrfbncqHCvqWxAx0s5e97AQsK
 26u3FYKSQVvrWv+XBF1saYTeZWIKoEkQJB1yIb/asbyzvVdejd65CzV1MOG+i2IfTDGt
 2LnIo71AyAazuQSB3sNUGEbD7Ocor6e7SiH0mzqlaJFprBVWQU7Tng9DQhsa6YtMa/Pe /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37147y2nex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 13:28:38 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121IRDsd063669
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 13:28:37 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37147y2nec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 13:28:37 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121IQwlj016156;
        Mon, 1 Mar 2021 18:28:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3712fmg4ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 18:28:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121ISWI219923302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 18:28:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8982F42041;
        Mon,  1 Mar 2021 18:28:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3013142045;
        Mon,  1 Mar 2021 18:28:32 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 18:28:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v3 3/3] s390x: mvpg: skip some tests when using TCG
Date:   Mon,  1 Mar 2021 19:28:30 +0100
Message-Id: <20210301182830.478145-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301182830.478145-1-imbrenda@linux.ibm.com>
References: <20210301182830.478145-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_12:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TCG is known to fail these tests, so add an explicit exception to skip them.

Once TCG has been fixed, it will be enough to revert this patch.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/mvpg.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 792052ad..148095e0 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -20,6 +20,7 @@
 #include <smp.h>
 #include <alloc_page.h>
 #include <bitops.h>
+#include <vm.h>
 
 /* Used to build the appropriate test values for register 0 */
 #define KFC(x) ((x) << 10)
@@ -224,20 +225,26 @@ static void test_mmu_prot(void)
 	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
 	fresh += PAGE_SIZE;
 
-	protect_page(fresh, PAGE_ENTRY_I);
-	cc = mvpg(CCO, fresh, source);
-	report(cc == 1, "destination invalid");
-	fresh += PAGE_SIZE;
+	if (vm_is_tcg()) {
+		report_skip("destination invalid");
+		report_skip("source invalid");
+		report_skip("source and destination invalid");
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

