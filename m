Return-Path: <kvm+bounces-72721-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBTvCLB6qGmHuwAAu9opvQ
	(envelope-from <kvm+bounces-72721-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:32:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B595F206640
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B124931822B5
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D633D564C;
	Wed,  4 Mar 2026 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hosd1Y52"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C5349AE6
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648112; cv=none; b=dmSXcCeaN9vLM7gLa8ERZBir9h2WaJSNlBmzwdcC4lDh5P5o+XNjkE0hexwBwU0d8o8JwcoD8McsdjFrLWrZb9slqeZjCUhxaJ3XFtYqRgZT0PwBjQveL0JmMItXuyXbmF3Q9nvPsSepJmAZP7cpbcRdOcilW/hKRn3pNgY2EUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648112; c=relaxed/simple;
	bh=G+6wuOIAslBmGP2VHNPLDcT/YnyVPtn5n6sa0myOq+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuGIo+XmVlbeZyE7RxJSqmmH+4jzfmXmy49UbK5zR9A6Gj1eUXRqf2TaOjQEaeEk0tVUdan67epRHPetU1aRCdoNbwVOsx++C5LeIQlbAMdMIprRK7SdVik/3EfNL840FovjejmIaj6Es/o45zeWN1j9/xYRIykcCBJDMDoh9fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hosd1Y52; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648112; x=1804184112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G+6wuOIAslBmGP2VHNPLDcT/YnyVPtn5n6sa0myOq+o=;
  b=Hosd1Y52tx/uhc2PdP4fTXcx1riQCNuh8QM6LnsDo64gjToQ66dSrqF5
   bj/875Geai8dm7fIbL5ik1sH7kqSC8J4EZgcCtyZ4vinPlG1QXfJgDIvg
   mQDAQkNAUXYeXDfxMigt1PtYC3So9ZkshKtX/T+WUtxdiZZexw1zy3DIQ
   KoYO4DLVB3NgU1zpik62J9hlrJWlxbmJJx3dAGwPETTtGBaxnfW4E8J+p
   6hr82GKqduL4aSQf5+EgGwDLf045N96+u0EFpA8O30Nlkx/OiwKm7DY66
   roc9/HnWsB4bD/R+cBM1KnbfWuOWOHnwsbC744wJ3TZsXLY+3pz5sNCdL
   A==;
X-CSE-ConnectionGUID: tM9JePUkS3iS2IGX5lRRfg==
X-CSE-MsgGUID: fWfgPQCPQqy+0vvTPWF3yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909302"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909302"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:11 -0800
X-CSE-ConnectionGUID: mC2OaaPJSnmC5rsDc7JRiA==
X-CSE-MsgGUID: /ZP5qbglRt+apVyzw0uYKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542792"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:10 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V3 03/13] target/i386: Gate enable_pmu on kvm_enabled()
Date: Wed,  4 Mar 2026 10:07:02 -0800
Message-ID: <20260304180713.360471-4-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304180713.360471-1-zide.chen@intel.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B595F206640
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72721-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

Guest PMU support requires KVM.  Clear cpu->enable_pmu when KVM is not
enabled, so PMU-related code can rely solely on cpu->enable_pmu.

This reduces duplication and avoids bugs where one of the checks is
missed.  For example, cpu_x86_cpuid() enables CPUID.0AH when
cpu->enable_pmu is set but does not check kvm_enabled(). This is
implicitly fixed by this patch:

if (cpu->enable_pmu) {
	x86_cpu_get_supported_cpuid(0xA, count, eax, ebx, ecx, edx);
}

Also fix two places that check kvm_enabled() but not cpu->enable_pmu.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2:
- Replace a tab with spaces.
---
 target/i386/cpu.c     | 9 ++++++---
 target/i386/kvm/kvm.c | 4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9b9ed2d1e38e..a69c3108f64b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8661,7 +8661,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *ecx = 0;
         *edx = 0;
         if (!(env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) ||
-            !kvm_enabled()) {
+            !cpu->enable_pmu) {
             break;
         }
 
@@ -9008,7 +9008,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     case 0x80000022:
         *eax = *ebx = *ecx = *edx = 0;
         /* AMD Extended Performance Monitoring and Debug */
-        if (kvm_enabled() && cpu->enable_pmu &&
+        if (cpu->enable_pmu &&
             (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
             *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
             *ebx |= kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
@@ -9630,7 +9630,7 @@ static bool x86_cpu_filter_features(X86CPU *cpu, bool verbose)
      * are advertised by cpu_x86_cpuid().  Keep these two in sync.
      */
     if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
-        kvm_enabled()) {
+        cpu->enable_pmu) {
         x86_cpu_get_supported_cpuid(0x14, 0,
                                     &eax_0, &ebx_0, &ecx_0, &edx_0);
         x86_cpu_get_supported_cpuid(0x14, 1,
@@ -9778,6 +9778,9 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     Error *local_err = NULL;
     unsigned requested_lbr_fmt;
 
+    if (!kvm_enabled())
+        cpu->enable_pmu = false;
+
 #if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
     /* Use pc-relative instructions in system-mode */
     tcg_cflags_set(cs, CF_PCREL);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 1131c350d352..144585df5ba6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4400,7 +4400,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                               env->msr_xfd_err);
         }
 
-        if (kvm_enabled() && cpu->enable_pmu &&
+        if (cpu->enable_pmu &&
             (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
             uint64_t depth;
             int ret;
@@ -4912,7 +4912,7 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_XFD_ERR, 0);
     }
 
-    if (kvm_enabled() && cpu->enable_pmu &&
+    if (cpu->enable_pmu &&
         (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
         uint64_t depth;
 
-- 
2.53.0


