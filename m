Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A201CB983
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 23:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgEHVJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 17:09:59 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:35172
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728008AbgEHVJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 17:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMCmFovLDeveDYXuFuTgjswQJbgXuPgAOWpOMpYLzPJq6tk3tTxpbwHW9MPBmu9Icl+kmWrJPVzyNGbM8pDvpWaM/ojoYcwc9kjZKcZ5NwkpM430Sup68s1IHNJwItz2RrKc9NAVShu3BESAQAO+mQLRsmqxbPl4sUDYy2KacBlItx85bTUgp8Pv588sAFixnJm1lEOY1hI9UmhG+M8DCARGFeYCgmGWBOnOBIGejpc5ttA9NCi1ytTw0Tv5hDsTNaUa/a41SO4qeWMXwm7Vi7Kb86cxveEJ7NOiED0PShgpgqDpvVviZwYO5ZvKyN/y7DhVRJjPiUl8TnYIwvbE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6BM1Fj+9KNZqI86h1czJgGqCVjHllZBjPktMGOOYX8=;
 b=ocMVRXlJKsIlXthxG4sjn4RVFLkHcH1QVW3UhcWlRnrzZ63aohEHQn/yto1IG12SxQRnueiWfCvVcBhuL2Lnn1+tvDqe+hRnBSHNYyw2NmZsZKur+BBdE3229lwryKJi7qXaE47Hk3ggNDJJWDfkOPSUJ1cZI0XvIYcUo+7FUTZCj4MGUCCKwUxLhLw+37wK9sf6dNfsjaO/z3Ka9vbLDJM2Ubep9p2FFx6sVXV1zwpmP8Lz6kSC7vjQCaacxvvxdOwvZT/7Fv/5EXTao9D6E1R2TUm3qwVuUxw1VwBh8yWy7SwDjZ69dCNEcRyY7sTFRvGjMlcpqJQQhFYwLFMaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6BM1Fj+9KNZqI86h1czJgGqCVjHllZBjPktMGOOYX8=;
 b=p6a20qPH+tUmoVhvvUbCzYfdIB9VzpAPq7YuBqaS95G+hoR7HtocoqQok8xLenz/O9jTKf7jbPX8uGh7X7NLlLkPYTaLxEw0EHFLZhRkj7l+udaPRwCKXJiBkcuJ7gkAxHVua4hoIFZwtZBv7/rr3ObCogb31PZqJmEpf9aVQMM=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.33; Fri, 8 May
 2020 21:09:50 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 21:09:50 +0000
Subject: [PATCH v2 1/3] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 08 May 2020 16:09:48 -0500
Message-ID: <158897218827.22378.8098826900779101384.stgit@naples-babu.amd.com>
In-Reply-To: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:805:ca::14) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN6PR16CA0037.namprd16.prod.outlook.com (2603:10b6:805:ca::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Fri, 8 May 2020 21:09:48 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 209b255d-0eae-4266-9eb2-08d7f3942545
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:|SN1PR12MB2591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25918F18F792EE45FB119B7B95A20@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xZX39NnRRQJYxBygK1PNH8DgLd6ilvX2cDBJftALUz6n581habrolXpa83jBlpIgtyEILpJPJ3IrW/jK0XlOindSgQuQMZmCNBOcv8+gwlvIGybKJPcb0a5NCrJNl1kjyQErPYwqa/asG7mQ/djrP2GMlWUVfWSM/Pm9HLU+YeDxVIRsN0GpHTvt/ijNXNlvuXUiv6eZLT5WYNH7s2/jmzrUH+2KWCWAu5nUVHGLnoglZksUMq+G0xTEDzzu/HjX0gDFU8G5mCpCBObDTNkSd+zE6nQ0UGhZ+AQJAFwb2TIMDcJ58bGePoJkoagXzB1qXG9T9hohIQx0K3C/PIsBT9fqZ5CRRKlhHUv9vHbkkFPM23BrP6tFIdIHHqzm9JwoAJ7N7zVUUxs2BC0bnd8n4TcpDaHcNzKOyVOJM8YhctUPAwDAT1jcwAXm9L5tk+7hgmNr0f0eB3DwBbhTRhg34gX7GJpT4r3HVYZzGgCk0F92YQ7BGvZOsFLFsqdeDkUoaQo4D75qCLd8GQByg5cssah9i0dpQ2WlQrR7TlLZ4Po=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(33430700001)(7406005)(16526019)(4326008)(7696005)(7416002)(186003)(26005)(66556008)(8936002)(52116002)(316002)(66946007)(66476007)(33440700001)(2906002)(44832011)(956004)(478600001)(55016002)(5660300002)(8676002)(103116003)(86362001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aeuR8dD88RUIheAG81aL0rAkb5Rp6mEMtbORAoxFb4kOwS38lkzD4/fkyTebRPNdNA5PxStaO2yQnFVHjYWlNmkICj/xdCJyHnRZoo1NhwW0LMbDyrTPlH4cBz3vgHUXPBT6b2Np3LHaVK5JVELJq+HNU/aJf6WpmK0doohyCFfLiGe7CmC5ZHbCCrAIZeFVlcXn0YOch0pbfIexn1ktLDdrNX7Od+tdZEI3zHkYZs3ThD9VGaAkGDmD5ZHy/E04JheuEbGY603gQbdanPIVmiYjMXBq3tvVKpnBN+e2I4DlhUnZRrZi+soi1gFhoNia93jW6urVsykhhZifIY0EKUEPy3jV4hA5q5TbMTGpPHfSuOi0RSXossZCBb7/gjfR8c+JbYNnN18nNVFOnRZ/E9cZRFtLwUQXS8Cvr24vGJjTnTLCldz+5lgeAAo/jAID/jXcj2YgD9/PKRGg7jyTc4QieG8ES69PIkvo+aFm0ZI=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209b255d-0eae-4266-9eb2-08d7f3942545
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 21:09:50.4971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68gDKH6WBOcHxyDpiL4gK7RjRm/LE76X2AmX5yMLsnTVwU8nhoII8QzhRKFEK9IV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's next generation of EPYC processors support the MPK (Memory
Protection Keys) feature.

So, rename X86_INTEL_MEMORY_PROTECTION_KEYS to X86_MEMORY_PROTECTION_KEYS.

No functional changes.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/core-api/protection-keys.rst     |    3 ++-
 arch/x86/Kconfig                               |   11 +++++++++--
 arch/x86/include/asm/disabled-features.h       |    4 ++--
 arch/x86/include/asm/mmu.h                     |    2 +-
 arch/x86/include/asm/mmu_context.h             |    4 ++--
 arch/x86/include/asm/pgtable.h                 |    4 ++--
 arch/x86/include/asm/pgtable_types.h           |    2 +-
 arch/x86/include/asm/special_insns.h           |    2 +-
 arch/x86/include/uapi/asm/mman.h               |    2 +-
 arch/x86/kernel/cpu/common.c                   |    2 +-
 arch/x86/mm/Makefile                           |    2 +-
 arch/x86/mm/pkeys.c                            |    2 +-
 scripts/headers_install.sh                     |    2 +-
 tools/arch/x86/include/asm/disabled-features.h |    4 ++--
 14 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index 49d9833af871..d25e89e53c59 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -6,7 +6,8 @@ Memory Protection Keys
 
 Memory Protection Keys for Userspace (PKU aka PKEYs) is a feature
 which is found on Intel's Skylake "Scalable Processor" Server CPUs.
-It will be avalable in future non-server parts.
+It will be available in future non-server parts. Also, AMD64
+Architecture Programmer’s Manual defines PKU feature in AMD processors.
 
 For anyone wishing to test or use this feature, it is available in
 Amazon's EC2 C5 instances and is known to work there using an Ubuntu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1197b5596d5a..b6f1686526eb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1887,10 +1887,10 @@ config X86_UMIP
 	  results are dummy.
 
 config X86_INTEL_MEMORY_PROTECTION_KEYS
-	prompt "Intel Memory Protection Keys"
+	prompt "Memory Protection Keys"
 	def_bool y
 	# Note: only available in 64-bit mode
-	depends on CPU_SUP_INTEL && X86_64
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	---help---
@@ -1902,6 +1902,13 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_MEMORY_PROTECTION_KEYS
+	# Note: This is an intermediate change to avoid config prompt to
+	# the users. Eventually, the option X86_INTEL_MEMORY_PROTECTION_KEYS
+	# should be changed to X86_MEMORY_PROTECTION_KEYS permanently after
+	# few kernel revisions.
+	def_bool X86_INTEL_MEMORY_PROTECTION_KEYS
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 4ea8584682f9..52dbdfed8043 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -36,13 +36,13 @@
 # define DISABLE_PCID		(1<<(X86_FEATURE_PCID & 31))
 #endif /* CONFIG_X86_64 */
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 # define DISABLE_PKU		0
 # define DISABLE_OSPKE		0
 #else
 # define DISABLE_PKU		(1<<(X86_FEATURE_PKU & 31))
 # define DISABLE_OSPKE		(1<<(X86_FEATURE_OSPKE & 31))
-#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
+#endif /* CONFIG_X86_MEMORY_PROTECTION_KEYS */
 
 #ifdef CONFIG_X86_5LEVEL
 # define DISABLE_LA57	0
diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index bdeae9291e5c..351d22152709 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -42,7 +42,7 @@ typedef struct {
 	const struct vdso_image *vdso_image;	/* vdso image in use */
 
 	atomic_t perf_rdpmc_allowed;	/* nonzero if rdpmc is allowed */
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 	/*
 	 * One bit per protection key says whether userspace can
 	 * use it or not.  protected by mmap_sem.
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4e55370e48e8..33f4a7ccac5e 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -118,7 +118,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	mm->context.ctx_id = atomic64_inc_return(&last_mm_ctx_id);
 	atomic64_set(&mm->context.tlb_gen, 0);
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 	if (cpu_feature_enabled(X86_FEATURE_OSPKE)) {
 		/* pkey 0 is the default and allocated implicitly */
 		mm->context.pkey_allocation_map = 0x1;
@@ -163,7 +163,7 @@ do {						\
 static inline void arch_dup_pkeys(struct mm_struct *oldmm,
 				  struct mm_struct *mm)
 {
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 	if (!cpu_feature_enabled(X86_FEATURE_OSPKE))
 		return;
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 4d02e64af1b3..4265720d62c2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1451,7 +1451,7 @@ static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 #define PKRU_WD_BIT 0x2
 #define PKRU_BITS_PER_PKEY 2
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 extern u32 init_pkru_value;
 #else
 #define init_pkru_value	0
@@ -1475,7 +1475,7 @@ static inline bool __pkru_allows_write(u32 pkru, u16 pkey)
 
 static inline u16 pte_flags_pkey(unsigned long pte_flags)
 {
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 	/* ifdef to avoid doing 59-bit shift on 32-bit values */
 	return (pte_flags & _PAGE_PKEY_MASK) >> _PAGE_BIT_PKEY_BIT0;
 #else
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b6606fe6cfdf..c61a1ff71d53 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -56,7 +56,7 @@
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
 #define _PAGE_CPA_TEST	(_AT(pteval_t, 1) << _PAGE_BIT_CPA_TEST)
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 #define _PAGE_PKEY_BIT0	(_AT(pteval_t, 1) << _PAGE_BIT_PKEY_BIT0)
 #define _PAGE_PKEY_BIT1	(_AT(pteval_t, 1) << _PAGE_BIT_PKEY_BIT1)
 #define _PAGE_PKEY_BIT2	(_AT(pteval_t, 1) << _PAGE_BIT_PKEY_BIT2)
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 6d37b8fcfc77..70eaae7e8f04 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -73,7 +73,7 @@ static inline unsigned long native_read_cr4(void)
 
 void native_write_cr4(unsigned long val);
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 static inline u32 rdpkru(void)
 {
 	u32 ecx = 0;
diff --git a/arch/x86/include/uapi/asm/mman.h b/arch/x86/include/uapi/asm/mman.h
index d4a8d0424bfb..d4da414a9de2 100644
--- a/arch/x86/include/uapi/asm/mman.h
+++ b/arch/x86/include/uapi/asm/mman.h
@@ -4,7 +4,7 @@
 
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 /*
  * Take the 4 protection key bits out of the vma->vm_flags
  * value and turn them in to the bits that we can put in
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bed0cb83fe24..e5fb9955214c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -448,7 +448,7 @@ static __always_inline void setup_pku(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_OSPKE);
 }
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 static __init int setup_disable_pku(char *arg)
 {
 	/*
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 98f7c6fa2eaa..17ebf12ba8ff 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
-obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
+obj-$(CONFIG_X86_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
 
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 8873ed1438a9..a77497e8d58c 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Intel Memory Protection Keys management
+ * Memory Protection Keys management
  * Copyright (c) 2015, Intel Corporation.
  */
 #include <linux/debugfs.h>		/* debugfs_create_u32()		*/
diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index a07668a5c36b..6e60e5362d3e 100755
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -86,7 +86,7 @@ arch/sh/include/uapi/asm/sigcontext.h:CONFIG_CPU_SH5
 arch/sh/include/uapi/asm/stat.h:CONFIG_CPU_SH5
 arch/x86/include/uapi/asm/auxvec.h:CONFIG_IA32_EMULATION
 arch/x86/include/uapi/asm/auxvec.h:CONFIG_X86_64
-arch/x86/include/uapi/asm/mman.h:CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+arch/x86/include/uapi/asm/mman.h:CONFIG_X86_MEMORY_PROTECTION_KEYS
 include/uapi/asm-generic/fcntl.h:CONFIG_64BIT
 include/uapi/linux/atmdev.h:CONFIG_COMPAT
 include/uapi/linux/elfcore.h:CONFIG_BINFMT_ELF_FDPIC
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index 4ea8584682f9..52dbdfed8043 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -36,13 +36,13 @@
 # define DISABLE_PCID		(1<<(X86_FEATURE_PCID & 31))
 #endif /* CONFIG_X86_64 */
 
-#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+#ifdef CONFIG_X86_MEMORY_PROTECTION_KEYS
 # define DISABLE_PKU		0
 # define DISABLE_OSPKE		0
 #else
 # define DISABLE_PKU		(1<<(X86_FEATURE_PKU & 31))
 # define DISABLE_OSPKE		(1<<(X86_FEATURE_OSPKE & 31))
-#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
+#endif /* CONFIG_X86_MEMORY_PROTECTION_KEYS */
 
 #ifdef CONFIG_X86_5LEVEL
 # define DISABLE_LA57	0

