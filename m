Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17054B421
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356176AbiFNPBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244722AbiFNPBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:01:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C99D3F327
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EEsknK015615
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GJVsHlUIY26F8yz64cxaMTAF61m17Q68tdTGQOOweSo=;
 b=cwosYmvnEPu62m0XZo7ZP+Hvexm+nKXGh0ZWEftpKn5l5wVCJQuYzb2Jzea4bjXErGjg
 AsZH08KtajvfzGYUskAH0IEf+swonlNTDbBaD1ComrPnxsQa09LTQAK2pA8IIqBfIhMx
 I5O5+XLHiZzAkL5Ye0ajY41FSGhhoQVe4d8r3rcZfYuJMvlBb2WniHdbeO7etXXlACA0
 rBPxIdKsFGyF0Vb/Z8xxdP/YSyeTTDLXLEFOQW8orZwInIyfO1c94XS1hBqA5O8mwk+Q
 DKM11ZuH/JgsS1hQlSCzMHl85hIEN43j1/jCjEeEfAoMq846h/yzJVQLmPaPSlSF/7Fo 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpqnb9dy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EEsrSQ016516
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpqnb9dwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EEotsd027257;
        Tue, 14 Jun 2022 15:00:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3gmjp9chm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EF0NMa16908798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 15:00:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5207842049;
        Tue, 14 Jun 2022 15:00:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCF8F42042;
        Tue, 14 Jun 2022 15:00:52 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 15:00:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 4/5] s390x: Fix gcc 12 warning about array bounds
Date:   Tue, 14 Jun 2022 17:00:48 +0200
Message-Id: <20220614150049.55787-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614150049.55787-1-imbrenda@linux.ibm.com>
References: <20220614150049.55787-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5qfhzsop2TFGA7DDsMpSnJPOs_uCGbtG
X-Proofpoint-GUID: qEfWa4T_XDfy0-BHu_v2uEYYs6l-FAhY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_05,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=729 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206140059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

gcc 12 warns about pointer constant <4k dereference.
Silence the warning by using the extern lowcore symbol to derive the
pointers. This way gcc cannot conclude that the pointer is <4k.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Message-Id: <20220608122953.1051952-3-scgl@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/mem.h | 4 ++++
 s390x/emulator.c    | 5 +++--
 s390x/skey.c        | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 845c00cc..64ef59b5 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -7,6 +7,10 @@
  */
 #ifndef _ASMS390X_MEM_H_
 #define _ASMS390X_MEM_H_
+#include <asm/arch_def.h>
+
+/* create pointer while avoiding compiler warnings */
+#define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
 
 #define SKEY_ACC	0xf0
 #define SKEY_FP		0x08
diff --git a/s390x/emulator.c b/s390x/emulator.c
index c9182ea4..2c42f96f 100644
--- a/s390x/emulator.c
+++ b/s390x/emulator.c
@@ -12,6 +12,7 @@
 #include <asm/cpacf.h>
 #include <asm/interrupt.h>
 #include <asm/float.h>
+#include <asm/mem.h>
 #include <linux/compiler.h>
 
 static inline void __test_spm_ipm(uint8_t cc, uint8_t key)
@@ -138,7 +139,7 @@ static __always_inline void __test_cpacf_invalid_parm(unsigned int opcode)
 {
 	report_prefix_push("invalid parm address");
 	expect_pgm_int();
-	__cpacf_query(opcode, (void *) -1);
+	__cpacf_query(opcode, OPAQUE_PTR(-1));
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 	report_prefix_pop();
 }
@@ -148,7 +149,7 @@ static __always_inline void __test_cpacf_protected_parm(unsigned int opcode)
 	report_prefix_push("protected parm address");
 	expect_pgm_int();
 	low_prot_enable();
-	__cpacf_query(opcode, (void *) 8);
+	__cpacf_query(opcode, OPAQUE_PTR(8));
 	low_prot_disable();
 	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
 	report_prefix_pop();
diff --git a/s390x/skey.c b/s390x/skey.c
index 32bf1070..445476a0 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -349,7 +349,7 @@ static void test_set_prefix(void)
 	set_storage_key(pagebuf, 0x28, 0);
 	expect_pgm_int();
 	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
-	set_prefix_key_1((uint32_t *)2048);
+	set_prefix_key_1(OPAQUE_PTR(2048));
 	install_page(root, 0, 0);
 	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
 	report(get_prefix() == old_prefix, "did not set prefix");
-- 
2.36.1

