Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF452563D9
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 03:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH2BBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 21:01:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgH2BBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 21:01:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0wuWd132059;
        Sat, 29 Aug 2020 01:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=8Yu4qoaim9wRU4mKIq4d2rfXeWhJwg+RqYzZbfrqzgk=;
 b=ZPSzMHwjVko//1HfVm8iqN8AlriGVlJ2kUevwWcuwHFsOxr0AQV+0VSdmWuD9m7GCbrT
 DElVAUhHPBioI8A1lMRJWrlnS+f0Nk9u9kJ9rroI8HteRmLz5/DWciMpvpJpqKphgoWf
 hE2tHkNQgKBiqT3kcCp5lycOv404880HkcnuHnXf/rOlD/LeInMFG0yK98dMa+anIi5n
 EqyoF3Y5VxRT/lM6yoBPj+ZVFcAyjnMoybzMAGtsRtzvo06+r9wrcNbLuoE2WcOkA/BO
 VNcYexu6rDFSAEzrQoNfRRCStZLwVQHgzJuslQyHf4Ac2R3ylIOCKHg7ovRQ2IW5DFNp wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 336ht3pqty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 01:01:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0oNaI050688;
        Sat, 29 Aug 2020 00:59:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 333ruh4fya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 00:59:33 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07T0xWNi005713;
        Sat, 29 Aug 2020 00:59:32 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 17:59:32 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2] SVM: Replace numeric value for SME CPUID leaf with a #define
Date:   Sat, 29 Aug 2020 00:59:25 +0000
Message-Id: <20200829005926.5477-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=1 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=1 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/svm.c     | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 8a1f5382a4ea..9eea127563fb 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -216,6 +216,7 @@ struct __attribute__ ((__packed__)) vmcb {
 };
 
 #define SVM_CPUID_FUNC 0x8000000a
+#define SVM_SME_CPUID_FUNC 0x8000001f
 
 #define SVM_VM_CR_SVM_DISABLE 4
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 03dd7bac8034..97333b4ece5a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -749,7 +749,7 @@ static __init void svm_adjust_mmio_mask(void)
 	u64 msr, mask;
 
 	/* If there is no memory encryption support, use existing mask */
-	if (cpuid_eax(0x80000000) < 0x8000001f)
+	if (cpuid_eax(0x80000000) < SVM_SME_CPUID_FUNC)
 		return;
 
 	/* If memory encryption is not enabled, use existing mask */
@@ -757,7 +757,7 @@ static __init void svm_adjust_mmio_mask(void)
 	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
 		return;
 
-	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
+	enc_bit = cpuid_ebx(SVM_SME_CPUID_FUNC) & 0x3f;
 	mask_bit = boot_cpu_data.x86_phys_bits;
 
 	/* Increment the mask bit if it is the same as the encryption bit */
-- 
2.18.4

