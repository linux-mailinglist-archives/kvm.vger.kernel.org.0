Return-Path: <kvm+bounces-38431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8558DA39A33
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 12:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62F5F7A4A18
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 11:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8817D23F29F;
	Tue, 18 Feb 2025 11:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UkVwqjM0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CB23C8BA;
	Tue, 18 Feb 2025 11:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739877247; cv=none; b=ReNC53FAEvsrbosmeXZlUrTXQrNJnIBR4nHhzsd9qj1AsEuL152VIF0Il7mCL/Hgu5AjW0tzDWkw5kpM04/H2doC4tsI8Mx5k+870FsIwC0se34/C0B1bqYDGD4NMNr9+PnMbtzODDObthdZNMj9R1yvjHDyMIxpP2nOJUp68hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739877247; c=relaxed/simple;
	bh=SBgqh1S+d4YuKVooe5x3vvlFDW8JM5ydaS03W8f52rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IntnA9FyO75OOGCPloLBVcKB8GH64706XQtmWKlJ7KMtuYp/oAEzYm8LabMKsq0W4eX09IO+xNUU12kFIBIGaPKuTdMxQUyIa1juQPMJ0HzgWC9OqKmL/n3Xd/AIJP/bn2XTn5JptwqCw76LJN/9lBDzlUi2mFL5ZYOIEJLV4fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UkVwqjM0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4023240E01A1;
	Tue, 18 Feb 2025 11:13:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FG4xQVYabji7; Tue, 18 Feb 2025 11:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739877231; bh=PFnEiVQz7NmG9EVizWO+mR0rF2XsnHacw8mlzRX7yHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkVwqjM0lsaESFcESTTOZ+wHAhtHqXAgERmIRNxwDD3cle3ZJ47pQpi8FZ5p+GAOl
	 uN3ub2wg/NuIJCGAk74zDLI6SgwFqnsxethyo0pA4p3cSbTCinGw2pyVw/SXwI5/ku
	 8+QsSG4a/2gDawmYgcxNyIMXq3pjZrHiTPWNfbGnBnWAigWvI5bkHeWEusjpzSSTAo
	 RExNNy/uh2sK4I1Cty3lqx/p3eY0sTT0V2/Wd+1QcLEAnj+MMzTq8spnHkPK0p1FdE
	 whryStcU9Myt0IC+p+Djym7hRrFRyZSQ6cLgpOTEz/1ucbIuu194M9Eyyg11QABK9d
	 q1I3RDSlnjIC+bsxiETbpQ3Rlpxyh+D6QRb+ofUBNoya4vMmVhs5ZrmqFLdwV/DLOx
	 pBizeQDaUJFNVjUKQKTNUV1ioR9XhDxlAyZtVUYaikDAONGBWIZhUd7YLtrgXbOT5V
	 gW8kQO/OVbUUNxGdFpzp4tMm7qe11f/CT7QC7sxog6NwXju+kOL5cfvcDqz2Lj3E/F
	 y/krz1WRMmoCpiObeIVvyfa25UfdPwt7ZPPno8SuT+adRgCw2t4THq1Nwui+Dt7ioV
	 NYDvFQA8uQiV/eFuIHq2JtnGD0GudR5tK0tMfs7BlRXNpSWjejHcBZy6QhZbdIzZ9b
	 9S9Yj6465XNLadT2TUkuLX8U=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2AB4640E020E;
	Tue, 18 Feb 2025 11:13:39 +0000 (UTC)
Date: Tue, 18 Feb 2025 12:13:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>
Subject: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>

So,

in the interest of finally making some progress here I'd like to commit this
below (will test it one more time just in case but it should work :-P). It is
simple and straight-forward and doesn't need an IBPB when the bit gets
cleared.

A potential future improvement is David's suggestion that there could be a way
for tracking when the first guest gets started, we set the bit then, we make
sure the bit gets set on each logical CPU when the guests migrate across the
machine and when the *last* guest exists, that bit gets cleared again.

It all depends on how much machinery is additionally needed and how much ugly
it becomes and how much noticeable the perf impact even is from simply setting
that bit blindly on every CPU...

But something we can chase later, once *some* fix is there first.

Thx.

---

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

Enable BpSpecReduce to mitigate SRSO across guest/host boundaries.

Switch back to enabling the bit when virtualization is enabled and to
clear the bit when virtualization is disabled because using a MSR slot
would clear the bit when the guest is exited and any training the guest
has done, would potentially influence the host kernel when execution
enters the kernel and hasn't VMRUN the guest yet.

More detail on the public thread in Link.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241202120416.6054-1-bp@kernel.org
---
 Documentation/admin-guide/hw-vuln/srso.rst | 13 ++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  4 ++++
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 24 ++++++++++++++++++----
 arch/x86/kvm/svm/svm.c                     |  6 ++++++
 arch/x86/lib/msr.c                         |  2 ++
 6 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/srso.rst b/Documentation/admin-guide/hw-vuln/srso.rst
index 2ad1c05b8c88..66af95251a3d 100644
--- a/Documentation/admin-guide/hw-vuln/srso.rst
+++ b/Documentation/admin-guide/hw-vuln/srso.rst
@@ -104,7 +104,20 @@ The possible values in this file are:
 
    (spec_rstack_overflow=ibpb-vmexit)
 
+ * 'Mitigation: Reduced Speculation':
 
+   This mitigation gets automatically enabled when the above one "IBPB on
+   VMEXIT" has been selected and the CPU supports the BpSpecReduce bit.
+
+   It gets automatically enabled on machines which have the
+   SRSO_USER_KERNEL_NO=1 CPUID bit. In that case, the code logic is to switch
+   to the above =ibpb-vmexit mitigation because the user/kernel boundary is
+   not affected anymore and thus "safe RET" is not needed.
+
+   After enabling the IBPB on VMEXIT mitigation option, the BpSpecReduce bit
+   is detected (functionality present on all such machines) and that
+   practically overrides IBPB on VMEXIT as it has a lot less performance
+   impact and takes care of the guest->host attack vector too.
 
 In order to exploit vulnerability, an attacker needs to:
 
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116b..43653f2704c9 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -468,6 +468,10 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_BP_SPEC_REDUCE	(20*32+31) /*
+						    * BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs.
+						    * (SRSO_MSR_FIX in the official doc).
+						    */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 72765b2fe0d8..d35519b337ba 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -721,6 +721,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a5d0998d7604..1d7afc40f227 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2522,6 +2522,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2539,7 +2540,8 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2578,7 +2580,7 @@ static void __init srso_select_mitigation(void)
 	    srso_cmd == SRSO_CMD_OFF) {
 		if (boot_cpu_has(X86_FEATURE_SBPB))
 			x86_pred_cmd = PRED_CMD_SBPB;
-		return;
+		goto out;
 	}
 
 	if (has_microcode) {
@@ -2590,7 +2592,7 @@ static void __init srso_select_mitigation(void)
 		 */
 		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
-			return;
+			goto out;
 		}
 
 		if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
@@ -2670,6 +2672,12 @@ static void __init srso_select_mitigation(void)
 
 ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
+		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
@@ -2691,7 +2699,15 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
-	pr_info("%s\n", srso_strings[srso_mitigation]);
+	/*
+	 * Clear the feature flag if this mitigation is not selected as that
+	 * feature flag controls the BpSpecReduce MSR bit toggling in KVM.
+	 */
+	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
+	if (srso_mitigation != SRSO_MITIGATION_NONE)
+		pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
 #undef pr_fmt
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a713c803a3a3..77ab66c5bb96 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -607,6 +607,9 @@ static void svm_disable_virtualization_cpu(void)
 	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
+
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 }
 
 static int svm_enable_virtualization_cpu(void)
@@ -684,6 +687,9 @@ static int svm_enable_virtualization_cpu(void)
 		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
+
 	return 0;
 }
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 4bf4fad5b148..5a18ecc04a6c 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -103,6 +103,7 @@ int msr_set_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, true);
 }
+EXPORT_SYMBOL_GPL(msr_set_bit);
 
 /**
  * msr_clear_bit - Clear @bit in a MSR @msr.
@@ -118,6 +119,7 @@ int msr_clear_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, false);
 }
+EXPORT_SYMBOL_GPL(msr_clear_bit);
 
 #ifdef CONFIG_TRACEPOINTS
 void do_trace_write_msr(unsigned int msr, u64 val, int failed)
-- 
2.43.0


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

