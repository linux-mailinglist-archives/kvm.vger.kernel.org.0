Return-Path: <kvm+bounces-54835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE47B28E9A
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 16:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2721E1C84049
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 14:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAB72F5312;
	Sat, 16 Aug 2025 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cFUWTd1n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C222F39AA;
	Sat, 16 Aug 2025 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755355496; cv=none; b=HZeDOLA+NRcBui/7CV8rUTa5PYZjsEbDN53WGY7p8xdbYe76O9WADRY0QVkbv3Ct6D4aD9LPwwfCV2Brq0IAReMrt+2OOsVbYdfzMs74KCJPzHf35OUpZ59+1ot77CnDuh5EszttKVepunmdXCRgz/bn4iGka6gBHq1GDyLIN/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755355496; c=relaxed/simple;
	bh=d9vZHe8AoyJP7C1lV5eMglCs0wvH9fqicb+2EZIfbE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEju1jOKj6wXdXqIifITYt90IY/fgE1zfGMVlX5m0ATZjLlPEgAZUGmolAKytlqIjMIOxReX+PV6/XkhE45O4l51ztn8wwyqCSmBJszJL9OM/qQo0BEqx1hnyZTUOk/4uu2FV/+iCL1RPjYpCmTXs75vXobJLCJoZixU7oe60+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cFUWTd1n; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755355495; x=1786891495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d9vZHe8AoyJP7C1lV5eMglCs0wvH9fqicb+2EZIfbE0=;
  b=cFUWTd1neUwoMDb+Wx/2YSbNgo8qbtBwS1Vf855piUMJPADx1F24VEnI
   3VYTXXTKs23cIOOUzsLKG/KM+PZ5FuEd6Z1QnPeO1rNY3osaOa5XUOTVt
   9ZAnoe2OUaJZ8PN14gmH2bdPX+FVb6pira77BdTr4YSB3QMJDs9DyftN1
   bkW50ZEVphj3hfSEUnU8xtT31f9bSThEqYQlFGBTMgxn+PTOkaYcG1Ae+
   WUd3JSMwgQBzTwIUI7bXLCqwcy+i9/DNoceoF+KM5VDmF8y7+ctditVEA
   geg/Zc93wQg7y51V0WckcrTfGS/nd7iWT4kmlkxHpQcqc9q5RFd2MyFt9
   g==;
X-CSE-ConnectionGUID: XpRGlzJ4RLutc+Pn2V5pgg==
X-CSE-MsgGUID: pObFm2ObT92QIIcJ+9frrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57508495"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57508495"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 07:44:55 -0700
X-CSE-ConnectionGUID: QrronKmMS3OteQezcZm/Uw==
X-CSE-MsgGUID: it/HKvf+Sk+H5YSUeUiH0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="198220463"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.93])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 07:44:50 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	ira.weiny@intel.com
Subject: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in guest
Date: Sat, 16 Aug 2025 17:44:34 +0300
Message-ID: <20250816144436.83718-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250816144436.83718-1-adrian.hunter@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

TDX support for using the MWAIT instruction in a guest has issues, so
disable it for now.

Background

Like VMX, TDX can allow the MWAIT instruction to be executed in a guest.
Unlike VMX, TDX cannot necessarily provide for virtualization of MSRs that
a guest might reasonably expect to exist as well.

For example, in the case of a Linux guest, the default idle driver
intel_idle may access MSR_POWER_CTL or MSR_PKG_CST_CONFIG_CONTROL.  To
virtualize those, KVM would need the guest not to enable #VE reduction,
which is not something that KVM can control or even be aware of.  Note,
however, that the consequent unchecked MSR access errors might be harmless.

Without #VE reduction enabled, the TDX Module will inject #VE for MSRs that
it does not virtualize itself.  The guest can then hypercall the host VMM
for a resolution.

With #VE reduction enabled, accessing MSRs such as the 2 above, results in
the TDX Module injecting #GP.

Currently, Linux guest opts for #VE reduction unconditionally if it is
available, refer reduce_unnecessary_ve().  However, the #VE reduction
feature was not added to the TDX Module until versions 1.5.09 and 2.0.04.
Refer https://github.com/intel/tdx-module/releases

There is also a further issue experienced by a Linux guest.  Prior to
TDX Module versions 1.5.09 and 2.0.04, the Always-Running-APIC-Timer (ARAT)
feature (CPUID leaf 6: EAX bit 2) is not exposed.  That results in cpuidle
disabling the timer interrupt and invoking the Tick Broadcast framework
to provide a wake-up.  Currently, that falls back to the PIT timer which
does not work for TDX, resulting in the guest becoming stuck in the idle
loop.

Conclusion

User's may expect TDX support of MWAIT in a guest to be similar to VMX
support, but KVM cannot ensure that.  Consequently KVM should not expose
the capability.

Fixes: 0186dd29a2518 ("KVM: TDX: add ioctl to initialize VM with TDX specific parameters")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/tdx.c          | 22 +++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  8 +++++---
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f7af967aa16f..9c8617217adb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1398,6 +1398,8 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
+	u64 unsupported_disable_exits;
+
 	bool mwait_in_guest;
 	bool hlt_in_guest;
 	bool pause_in_guest;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9ad460ef97b0..cdf0dc6cf068 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -132,6 +132,17 @@ static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
 	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
 }
 
+static bool has_mwait(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 1 &&
+	       (entry->ecx & __feature_bit(X86_FEATURE_MWAIT));
+}
+
+static void clear_mwait(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ecx &= ~__feature_bit(X86_FEATURE_MWAIT);
+}
+
 static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	if (has_tsx(entry))
@@ -139,11 +150,15 @@ static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
 
 	if (has_waitpkg(entry))
 		clear_waitpkg(entry);
+
+	/* Also KVM_X86_DISABLE_EXITS_MWAIT is disallowed in tdx_vm_init() */
+	if (has_mwait(entry))
+		clear_mwait(entry);
 }
 
 static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
 {
-	return has_tsx(entry) || has_waitpkg(entry);
+	return has_tsx(entry) || has_waitpkg(entry) || has_mwait(entry);
 }
 
 #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
@@ -615,6 +630,11 @@ int tdx_vm_init(struct kvm *kvm)
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
 	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+	/*
+	 * TDX support for using the MWAIT instruction in a guest has issues,
+	 * so disable it for now. See also tdx_clear_unsupported_cpuid().
+	 */
+	kvm->arch.unsupported_disable_exits |= KVM_X86_DISABLE_EXITS_MWAIT;
 
 	/*
 	 * Because guest TD is protected, VMM can't parse the instruction in TD.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93636f77c42d..bfd4f52286b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4575,7 +4575,7 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
-static u64 kvm_get_allowed_disable_exits(void)
+static u64 kvm_get_allowed_disable_exits(struct kvm *kvm)
 {
 	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
 
@@ -4586,6 +4586,8 @@ static u64 kvm_get_allowed_disable_exits(void)
 		if (kvm_can_mwait_in_guest())
 			r |= KVM_X86_DISABLE_EXITS_MWAIT;
 	}
+	if (kvm)
+		r &= ~kvm->arch.unsupported_disable_exits;
 	return r;
 }
 
@@ -4736,7 +4738,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r = kvm_get_allowed_disable_exits();
+		r = kvm_get_allowed_disable_exits(kvm);
 		break;
 	case KVM_CAP_X86_SMM:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
@@ -6613,7 +6615,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r = -EINVAL;
-		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits(kvm))
 			break;
 
 		mutex_lock(&kvm->lock);
-- 
2.48.1


