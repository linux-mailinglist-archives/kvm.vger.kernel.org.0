Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC103310E9
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhCHOe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:34:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41850 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229972AbhCHOdx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:53 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXN94080978;
        Mon, 8 Mar 2021 09:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tsFnGJlZheAVPAGvUDCQg46jch80FzS+hAxj7Kj0ARM=;
 b=Dhf7CxBLF+EGhN/nX2bLVe100Uka9GRS5MlDZJLVec2zokKUNBbwO4ls7g/KHGSM7TbA
 QkxMRiX9WZ0gC0JQ590R3htbJ0cTYc5lRGBUVGC7d5quYqU8Oy7oGW/QT6EwJVnEVxin
 hsW62+TaJew6xfNHTnQ7AL0d8wMwpGOfjQM5QHgm3BKDGXpSBdvouSg6ctQ9KLNnKJ/0
 iC+gwfSVgss31tdquk/LtamB2VP8U7vsRGcWw4h2hxJN12aQGUGuiUB0V9JDDU2Qhp+U
 4XYRcV+wh+dusoT+zWLxNK9FB5/grzMI8CTSzIuma6KoHY0ctLHBpLswXHtgxBSsF3OL Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375ns2r25c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:51 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXOYj081006;
        Mon, 8 Mar 2021 09:33:50 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375ns2r248-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:50 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXhxl017743;
        Mon, 8 Mar 2021 14:33:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3741c8102c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXUTF37224940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CBFBA4040;
        Mon,  8 Mar 2021 14:33:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E746BA4055;
        Mon,  8 Mar 2021 14:33:44 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:44 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 16/16] s390x: mvpg: skip some tests when using TCG
Date:   Mon,  8 Mar 2021 15:31:47 +0100
Message-Id: <20210308143147.64755-17-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

TCG is known to fail these tests, so add an explicit exception to skip them.

Once TCG has been fixed, it will be enough to revert this patch.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/kvm/20210302114107.501837-4-imbrenda@linux.ibm.com/
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.29.2

