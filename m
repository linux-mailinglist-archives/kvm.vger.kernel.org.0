Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4452668BA
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIKT2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:28:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49598 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgIKT14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:27:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJObPC175106;
        Fri, 11 Sep 2020 19:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=9Yu0+hVjg349shgtmGEHPIIhGF87WXKFZaup59ONGuE=;
 b=PxaToik1sSRid0lUYOQlHI5sZyx5JbdMRjbQIZZJGphKCd5YUvxnC5NA3U1UY4HPuTYj
 crld18ZhN/JEJrYqIMAjpzyVzQ3HD1e1Qznkfvhu4D+5EGv6o46QN3JLs3uOpd95iaqb
 5hbK0mIdLPKn9Fnv5m5qpovquPdntqNBu04JTRob4lg442m62GHcsddxHXuHJYylvyL+
 s43Ozh0Q9eIBFqHEFdreEDE3hMRrl17SZsrOl7D0N4YsfvZtgPWzgy18a1hRcxHm/AAi
 mdbFa7+ap0KzRiRxk0oE3xkm2SinDRyLR6rd1uY7nJsUj1I2MFosNQJPheyD9capjvfK Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mmg2vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 19:26:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJPDuf019612;
        Fri, 11 Sep 2020 19:26:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmkdu77n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 19:26:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BJQPJi009907;
        Fri, 11 Sep 2020 19:26:26 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 12:26:24 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 1/4 v3] x86: AMD: Replace numeric value for SME CPUID leaf with a #define
Date:   Fri, 11 Sep 2020 19:25:58 +0000
Message-Id: <20200911192601.9591-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/boot/compressed/mem_encrypt.S | 5 +++--
 arch/x86/include/asm/cpufeatures.h     | 5 +++++
 arch/x86/kernel/cpu/amd.c              | 2 +-
 arch/x86/kernel/cpu/scattered.c        | 4 ++--
 arch/x86/kvm/cpuid.c                   | 2 +-
 arch/x86/kvm/svm/svm.c                 | 4 ++--
 arch/x86/mm/mem_encrypt_identity.c     | 4 ++--
 7 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index dd07e7b41b11..22e30b0c0d19 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -12,6 +12,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
+#include <asm/cpufeatures.h>
 
 	.text
 	.code32
@@ -31,7 +32,7 @@ SYM_FUNC_START(get_sev_encryption_bit)
 
 	movl	$0x80000000, %eax	/* CPUID to check the highest leaf */
 	cpuid
-	cmpl	$0x8000001f, %eax	/* See if 0x8000001f is available */
+	cmpl	$CPUID_AMD_SME, %eax	/* See if 0x8000001f is available */
 	jb	.Lno_sev
 
 	/*
@@ -40,7 +41,7 @@ SYM_FUNC_START(get_sev_encryption_bit)
 	 *   CPUID Fn8000_001F[EBX] - Bits 5:0
 	 *     Pagetable bit position used to indicate encryption
 	 */
-	movl	$0x8000001f, %eax
+	movl	$CPUID_AMD_SME, %eax
 	cpuid
 	bt	$1, %eax		/* Check if SEV is available */
 	jnc	.Lno_sev
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2901d5df4366..81335e6fe47d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -10,6 +10,11 @@
 #include <asm/disabled-features.h>
 #endif
 
+/*
+ * AMD CPUID functions
+ */
+#define CPUID_AMD_SME  0x8000001f	/* Secure Memory Encryption */
+
 /*
  * Defines x86 CPU feature bits
  */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index dcc3d943c68f..4507ededb978 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -630,7 +630,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		 * will be a value above 32-bits this is still done for
 		 * CONFIG_X86_32 so that accurate values are reported.
 		 */
-		c->x86_phys_bits -= (cpuid_ebx(0x8000001f) >> 6) & 0x3f;
+		c->x86_phys_bits -= (cpuid_ebx(CPUID_AMD_SME) >> 6) & 0x3f;
 
 		if (IS_ENABLED(CONFIG_X86_32))
 			goto clear_all;
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 62b137c3c97a..033c112e03fc 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -39,8 +39,8 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
-	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
-	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
+	{ X86_FEATURE_SME,		CPUID_EAX,  0, CPUID_AMD_SME, 0 },
+	{ X86_FEATURE_SEV,		CPUID_EAX,  1, CPUID_AMD_SME, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec202d7..95863e767d3d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -756,7 +756,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x8000001f);
+		entry->eax = min(entry->eax, CPUID_AMD_SME);
 		break;
 	case 0x80000001:
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0194336b64a4..a4e92ae399b4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -749,7 +749,7 @@ static __init void svm_adjust_mmio_mask(void)
 	u64 msr, mask;
 
 	/* If there is no memory encryption support, use existing mask */
-	if (cpuid_eax(0x80000000) < 0x8000001f)
+	if (cpuid_eax(0x80000000) < CPUID_AMD_SME)
 		return;
 
 	/* If memory encryption is not enabled, use existing mask */
@@ -757,7 +757,7 @@ static __init void svm_adjust_mmio_mask(void)
 	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
 		return;
 
-	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
+	enc_bit = cpuid_ebx(CPUID_AMD_SME) & 0x3f;
 	mask_bit = boot_cpu_data.x86_phys_bits;
 
 	/* Increment the mask bit if it is the same as the encryption bit */
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index e2b0e2ac07bb..cbe600dd357b 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -498,7 +498,7 @@ void __init sme_enable(struct boot_params *bp)
 	eax = 0x80000000;
 	ecx = 0;
 	native_cpuid(&eax, &ebx, &ecx, &edx);
-	if (eax < 0x8000001f)
+	if (eax < CPUID_AMD_SME)
 		return;
 
 #define AMD_SME_BIT	BIT(0)
@@ -520,7 +520,7 @@ void __init sme_enable(struct boot_params *bp)
 	 *   CPUID Fn8000_001F[EBX]
 	 *   - Bits 5:0 - Pagetable bit position used to indicate encryption
 	 */
-	eax = 0x8000001f;
+	eax = CPUID_AMD_SME;
 	ecx = 0;
 	native_cpuid(&eax, &ebx, &ecx, &edx);
 	if (!(eax & feature_mask))
-- 
2.18.4

