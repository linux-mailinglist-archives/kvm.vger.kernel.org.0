Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F554CD00
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 13:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbfFTLis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 07:38:48 -0400
Received: from terminus.zytor.com ([198.137.202.136]:50419 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfFTLis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 07:38:48 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x5KBbvCE946199
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 20 Jun 2019 04:37:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5KBbvCE946199
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019061801; t=1561030678;
        bh=ZYc0uBa8ZNBgwsdBYLKbYrHpNA6zUOpAOKbGYfv/XGA=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=FvObwE+DdLjWkNPwjt/c+fNRAB23hFkKIB7VGA7yklPd1cb9q5tgKsJSHlt4xXqql
         69GB9CSU5Cr5G63Xx3WUHMQ1tJVUk9e3AfUY+Ar1IX2+UstIwGZMxVsbmDj0icoicR
         PMzHuKnUErX5/EMa+HgmXEmSyNtMfEv9Fne/JbDzdLcIuvTljEDxbtGIaPm14E9Rao
         YMywyMtDzZYvsH7bQd0LjDbN/tPMUi+H1EDjg8OJ8L5eje/uegc+pBVFFM8OGth3Aw
         WKKstysvmtdj8KyKtmJ+E+TBPmZBr92CHd+SLDn51xUsbICVyb6P7bSdTxuAtEmmM2
         HYkQulaEu5Flg==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x5KBbtmA946192;
        Thu, 20 Jun 2019 04:37:55 -0700
Date:   Thu, 20 Jun 2019 04:37:55 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-acec0ce081de0c36459eea91647faf99296445a3@git.kernel.org>
Cc:     pfeiner@google.com, mingo@redhat.com, ravi.v.shankar@intel.com,
        Thomas.Lendacky@amd.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, sean.j.christopherson@intel.com, luto@kernel.org,
        rafael.j.wysocki@intel.com, mhiramat@kernel.org, jgross@suse.com,
        yamada.masahiro@socionext.com, fenghua.yu@intel.com,
        chang.seok.bae@intel.com, peterz@infradead.org,
        pasha.tatashin@oracle.com, kvm@vger.kernel.org,
        frederic@kernel.org, babu.moger@amd.com, aaronlewis@google.com,
        bp@suse.de, konrad.wilk@oracle.com, x86@kernel.org,
        sherry.hurwitz@amd.com, pbonzini@redhat.com, jannh@google.com,
        namit@vmware.com, mingo@kernel.org, tglx@linutronix.de,
        rkrcmar@redhat.com
Reply-To: tglx@linutronix.de, rkrcmar@redhat.com, sherry.hurwitz@amd.com,
          pbonzini@redhat.com, jannh@google.com, namit@vmware.com,
          mingo@kernel.org, aaronlewis@google.com, bp@suse.de,
          konrad.wilk@oracle.com, x86@kernel.org, frederic@kernel.org,
          babu.moger@amd.com, chang.seok.bae@intel.com,
          peterz@infradead.org, pasha.tatashin@oracle.com,
          kvm@vger.kernel.org, mhiramat@kernel.org, jgross@suse.com,
          yamada.masahiro@socionext.com, fenghua.yu@intel.com,
          sean.j.christopherson@intel.com, luto@kernel.org,
          rafael.j.wysocki@intel.com, pfeiner@google.com, mingo@redhat.com,
          Thomas.Lendacky@amd.com, ravi.v.shankar@intel.com,
          linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <1560794416-217638-2-git-send-email-fenghua.yu@intel.com>
References: <1560794416-217638-2-git-send-email-fenghua.yu@intel.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cpufeatures: Combine word 11 and 12 into a new
 scattered features word
Git-Commit-ID: acec0ce081de0c36459eea91647faf99296445a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
        DKIM_VALID_EF autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit-ID:  acec0ce081de0c36459eea91647faf99296445a3
Gitweb:     https://git.kernel.org/tip/acec0ce081de0c36459eea91647faf99296445a3
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Wed, 19 Jun 2019 18:51:09 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 20 Jun 2019 12:38:44 +0200

x86/cpufeatures: Combine word 11 and 12 into a new scattered features word

It's a waste for the four X86_FEATURE_CQM_* feature bits to occupy two
whole feature bits words. To better utilize feature words, re-define
word 11 to host scattered features and move the four X86_FEATURE_CQM_*
features into Linux defined word 11. More scattered features can be
added in word 11 in the future.

Rename leaf 11 in cpuid_leafs to CPUID_LNX_4 to reflect it's a
Linux-defined leaf.

Rename leaf 12 as CPUID_DUMMY which will be replaced by a meaningful
name in the next patch when CPUID.7.1:EAX occupies world 12.

Maximum number of RMID and cache occupancy scale are retrieved from
CPUID.0xf.1 after scattered CQM features are enumerated. Carve out the
code into a separate function.

KVM doesn't support resctrl now. So it's safe to move the
X86_FEATURE_CQM_* features to scattered features word 11 for KVM.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Babu Moger <babu.moger@amd.com>
Cc: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: "Sean J Christopherson" <sean.j.christopherson@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kvm ML <kvm@vger.kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Ravi V Shankar <ravi.v.shankar@intel.com>
Cc: Sherry Hurwitz <sherry.hurwitz@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: x86 <x86@kernel.org>
Link: https://lkml.kernel.org/r/1560794416-217638-2-git-send-email-fenghua.yu@intel.com
---
 arch/x86/include/asm/cpufeature.h  |  4 ++--
 arch/x86/include/asm/cpufeatures.h | 17 ++++++++++-------
 arch/x86/kernel/cpu/common.c       | 38 +++++++++++++++-----------------------
 arch/x86/kernel/cpu/cpuid-deps.c   |  3 +++
 arch/x86/kernel/cpu/scattered.c    |  4 ++++
 arch/x86/kvm/cpuid.h               |  2 --
 6 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1d337c51f7e6..403f70c2e431 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -22,8 +22,8 @@ enum cpuid_leafs
 	CPUID_LNX_3,
 	CPUID_7_0_EBX,
 	CPUID_D_1_EAX,
-	CPUID_F_0_EDX,
-	CPUID_F_1_EDX,
+	CPUID_LNX_4,
+	CPUID_DUMMY,
 	CPUID_8000_0008_EBX,
 	CPUID_6_EAX,
 	CPUID_8000_000A_EDX,
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1017b9c7dfe0..be858b86023a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -271,13 +271,16 @@
 #define X86_FEATURE_XGETBV1		(10*32+ 2) /* XGETBV with ECX = 1 instruction */
 #define X86_FEATURE_XSAVES		(10*32+ 3) /* XSAVES/XRSTORS instructions */
 
-/* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:0 (EDX), word 11 */
-#define X86_FEATURE_CQM_LLC		(11*32+ 1) /* LLC QoS if 1 */
-
-/* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:1 (EDX), word 12 */
-#define X86_FEATURE_CQM_OCCUP_LLC	(12*32+ 0) /* LLC occupancy monitoring */
-#define X86_FEATURE_CQM_MBM_TOTAL	(12*32+ 1) /* LLC Total MBM monitoring */
-#define X86_FEATURE_CQM_MBM_LOCAL	(12*32+ 2) /* LLC Local MBM monitoring */
+/*
+ * Extended auxiliary flags: Linux defined - for features scattered in various
+ * CPUID levels like 0xf, etc.
+ *
+ * Reuse free bits when adding new feature flags!
+ */
+#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* LLC QoS if 1 */
+#define X86_FEATURE_CQM_OCCUP_LLC	(11*32+ 1) /* LLC occupancy monitoring */
+#define X86_FEATURE_CQM_MBM_TOTAL	(11*32+ 2) /* LLC Total MBM monitoring */
+#define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index fe6ed9696467..efb114298cfb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -803,33 +803,25 @@ static void init_speculation_control(struct cpuinfo_x86 *c)
 
 static void init_cqm(struct cpuinfo_x86 *c)
 {
-	u32 eax, ebx, ecx, edx;
-
-	/* Additional Intel-defined flags: level 0x0000000F */
-	if (c->cpuid_level >= 0x0000000F) {
+	if (!cpu_has(c, X86_FEATURE_CQM_LLC)) {
+		c->x86_cache_max_rmid  = -1;
+		c->x86_cache_occ_scale = -1;
+		return;
+	}
 
-		/* QoS sub-leaf, EAX=0Fh, ECX=0 */
-		cpuid_count(0x0000000F, 0, &eax, &ebx, &ecx, &edx);
-		c->x86_capability[CPUID_F_0_EDX] = edx;
+	/* will be overridden if occupancy monitoring exists */
+	c->x86_cache_max_rmid = cpuid_ebx(0xf);
 
-		if (cpu_has(c, X86_FEATURE_CQM_LLC)) {
-			/* will be overridden if occupancy monitoring exists */
-			c->x86_cache_max_rmid = ebx;
+	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
+	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
+	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL)) {
+		u32 eax, ebx, ecx, edx;
 
-			/* QoS sub-leaf, EAX=0Fh, ECX=1 */
-			cpuid_count(0x0000000F, 1, &eax, &ebx, &ecx, &edx);
-			c->x86_capability[CPUID_F_1_EDX] = edx;
+		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
+		cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
 
-			if ((cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC)) ||
-			      ((cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL)) ||
-			       (cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL)))) {
-				c->x86_cache_max_rmid = ecx;
-				c->x86_cache_occ_scale = ebx;
-			}
-		} else {
-			c->x86_cache_max_rmid = -1;
-			c->x86_cache_occ_scale = -1;
-		}
+		c->x86_cache_max_rmid  = ecx;
+		c->x86_cache_occ_scale = ebx;
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 2c0bd38a44ab..fa07a224e7b9 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -59,6 +59,9 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_4VNNIW,	X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_4FMAPS,	X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_VPOPCNTDQ, X86_FEATURE_AVX512F   },
+	{ X86_FEATURE_CQM_OCCUP_LLC,	X86_FEATURE_CQM_LLC   },
+	{ X86_FEATURE_CQM_MBM_TOTAL,	X86_FEATURE_CQM_LLC   },
+	{ X86_FEATURE_CQM_MBM_LOCAL,	X86_FEATURE_CQM_LLC   },
 	{}
 };
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 94aa1c72ca98..adf9b71386ef 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -26,6 +26,10 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
+	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
+	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },
+	{ X86_FEATURE_CQM_MBM_LOCAL,	CPUID_EDX,  2, 0x0000000f, 1 },
 	{ X86_FEATURE_CAT_L3,		CPUID_EBX,  1, 0x00000010, 0 },
 	{ X86_FEATURE_CAT_L2,		CPUID_EBX,  2, 0x00000010, 0 },
 	{ X86_FEATURE_CDP_L3,		CPUID_ECX,  2, 0x00000010, 1 },
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 9a327d5b6d1f..d78a61408243 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -47,8 +47,6 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0001_ECX] = {0x80000001, 0, CPUID_ECX},
 	[CPUID_7_0_EBX]       = {         7, 0, CPUID_EBX},
 	[CPUID_D_1_EAX]       = {       0xd, 1, CPUID_EAX},
-	[CPUID_F_0_EDX]       = {       0xf, 0, CPUID_EDX},
-	[CPUID_F_1_EDX]       = {       0xf, 1, CPUID_EDX},
 	[CPUID_8000_0008_EBX] = {0x80000008, 0, CPUID_EBX},
 	[CPUID_6_EAX]         = {         6, 0, CPUID_EAX},
 	[CPUID_8000_000A_EDX] = {0x8000000a, 0, CPUID_EDX},
