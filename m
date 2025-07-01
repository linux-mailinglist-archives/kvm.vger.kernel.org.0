Return-Path: <kvm+bounces-51173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 458D6AEF484
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 293CB3A18B6
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAB3271A9D;
	Tue,  1 Jul 2025 10:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QXjEFzEG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9A27147F
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364286; cv=none; b=QzqG8i18VRK61h1Dm6uzJskmVjL3DBxRH7rm2uO6XK1b/OEhrfWxS+t5hegDp/2rAZBt9UHijFU35ZIYdUVUIDgIV4R34bXNOEKPNP+B2SuruPwKsgjzUa4nPjnWeBt6vQlSr33+JcEzUWg3qDu3vJfBfII76NSoM6PIpce296k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364286; c=relaxed/simple;
	bh=qa/gTL1PQFxXSd62WV3+sQtGyHAeVwwkiNFkufFufVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSMFrtcc39NKsXq2ZzCXAbI+IP979BHnar9paVjr8xMASpTYuLjNoUVPmosQxjRzRtUp92A56gKxsomIXv7JQuBAcdmHPqn9U+0HsQbUj7Ai8snjjuTO9NaTB8+9MCHnfduiafxXxv4EYwfFS4KJhIben80zC/9LPDFM8YRgDqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QXjEFzEG; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751364284; x=1782900284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qa/gTL1PQFxXSd62WV3+sQtGyHAeVwwkiNFkufFufVY=;
  b=QXjEFzEGZPLYz9e2+msZ4NnHk5b7+/RBzOtORArTx9hrg2jLulJnCExB
   zwl4Z2wxR8Sf0k+jt2V7Mf0IY4BZQGhTCHZG2UTfN4D+s6rdEZuN81hQV
   EqfWJSyJz8iI+bTys+XxBVJov+K0yVjBrwvn7T5C1LndVgOckvngnJx0A
   Th/on0ZQwKq9INtPzSAygMYulJrEra4i5gLu8ffCkoNs4DlXTZrDLNZ/O
   Xj+gHi1g16dBYPW4K5l2a7kCBnMnvhUhF5kv9bDH1/5RNI0DwnlPi5skf
   EgcAIvBdfseRu865rPYbX/uBr78t1Upnm5HmAO3EqzjK2TAkqYZF/G9of
   Q==;
X-CSE-ConnectionGUID: PI4xWwJcQqmQjuS+1Qn6aA==
X-CSE-MsgGUID: sKOXhEKTS2mzCtoB5IvQkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="52853445"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="52853445"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 03:04:42 -0700
X-CSE-ConnectionGUID: AHLNij5AT6m7xTsFjx/rXg==
X-CSE-MsgGUID: lw37YHnxS7qnP7Mv7ZXzrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="153505377"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa009.jf.intel.com with ESMTP; 01 Jul 2025 03:04:40 -0700
Date: Tue, 1 Jul 2025 18:26:04 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: qemu-devel@nongnu.org, pbonzini@redhat.com, xiaoyao.li@intel.com,
	qemu-stable@nongnu.org, konrad.wilk@oracle.com,
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGO3vOfHUfjgvBQ9@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630133025.4189544-1-alexandre.chartre@oracle.com>

(I'd like to CC Sean again to discuss the possibility of user space
 removing arch-capabilities completely for AMD)

On Mon, Jun 30, 2025 at 03:30:25PM +0200, Alexandre Chartre wrote:
> Date: Mon, 30 Jun 2025 15:30:25 +0200
> From: Alexandre Chartre <alexandre.chartre@oracle.com>
> Subject: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on AMD
> X-Mailer: git-send-email 2.43.5
> 
> KVM emulates the ARCH_CAPABILITIES on x86 for both Intel and AMD
> cpus, although the IA32_ARCH_CAPABILITIES MSR is an Intel-specific
> MSR and it makes no sense to emulate it on AMD.
> 
> As a consequence, VMs created on AMD with qemu -cpu host and using
> KVM will advertise the ARCH_CAPABILITIES feature and provide the
> IA32_ARCH_CAPABILITIES MSR. This can cause issues (like Windows BSOD)
> as the guest OS might not expect this MSR to exist on such cpus (the
> AMD documentation specifies that ARCH_CAPABILITIES feature and MSR
> are not defined on the AMD architecture).

This issue looks very similar to this one that others in the community
reported:

https://gitlab.com/qemu-project/qemu/-/issues/3001

But there's a little difference, pls see the below comment...

> A fix was proposed in KVM code, however KVM maintainers don't want to
> change this behavior that exists for 6+ years and suggest changes to be
> done in qemu instead.
>
> So this commit changes the behavior in qemu so that ARCH_CAPABILITIES
> is not provided by default on AMD cpus when the hypervisor emulates it,
> but it can still be provided by explicitly setting arch-capabilities=on.
> 
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
>  target/i386/cpu.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0d35e95430..7e136c48df 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8324,6 +8324,20 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>          }
>      }
>  
> +    /*
> +     * For years, KVM has inadvertently emulated the ARCH_CAPABILITIES
> +     * MSR on AMD although this is an Intel-specific MSR; and KVM will
> +     * continue doing so to not change its ABI for existing setups.
> +     *
> +     * So ensure that the ARCH_CAPABILITIES MSR is disabled on AMD cpus
> +     * to prevent providing a cpu with an MSR which is not supposed to
> +     * be there,

Yes, disabling this feature bit makes sense on AMD platform. It's fine
for -cpu host.

> unless it was explicitly requested by the user.

But this could still break Windows, just like issue #3001, which enables
arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
value would even break something.

So even for named CPUs, arch-capabilities=on doesn't reflect the fact
that it is purely emulated, and is (maybe?) harmful.

> +     */
> +    if (IS_AMD_CPU(env) &&
> +        !(env->user_features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES)) {
> +        env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_CAPABILITIES;
> +    }
> +

I was considering whether we should tweak it in kvm_arch_get_supported_cpuid()
until I saw this:

else if (function == 7 && index == 0 && reg == R_EDX) {
        /* Not new instructions, just an optimization.  */
        uint32_t edx;
        host_cpuid(7, 0, &unused, &unused, &unused, &edx);
        ret |= edx & CPUID_7_0_EDX_FSRM;

        /*
         * Linux v4.17-v4.20 incorrectly return ARCH_CAPABILITIES on SVM hosts.
         * We can detect the bug by checking if MSR_IA32_ARCH_CAPABILITIES is
         * returned by KVM_GET_MSR_INDEX_LIST.
         */
        if (!has_msr_arch_capabs) {
            ret &= ~CPUID_7_0_EDX_ARCH_CAPABILITIES;
        }
}

What a pity! QEMU had previously workedaround CPUID_7_0_EDX_ARCH_CAPABILITIES
correctly, but since then kvm's commit 0cf9135b773b("KVM: x86: Emulate
MSR_IA32_ARCH_CAPABILITIES on AMD hosts") breaks the balance once again. 
I understand the commit, and it makes up for the mismatch between the
emulated feature bit and the MSR. Now the Windows exposes the problem of
such emulation.

So, to avoid endless workaround thereafter, I think it's time to just
disable arch-capabilities for AMD Guest (after all, closer to the real
hardware environment is better).

Further, it helps to eliminate kernel/kvm concerns when user space resolves
the legacy issues first. At least, IMO, pushing ABI changes in kernel/kvm
needs to show that there is no destruction of pre-existing user space, so
I believe a complete cleanup of QEMU is the appropriate approach.

The attached code is just some simple example to show what I think:
Starting with QEMU v10.1 for AMD Guest, to disable arch-capabilties
feature bit and MSR.

I don't have an AMD CPU, so it's untested. You can feel free to squash
it in your patch. If so, it's better to add a "Resolves" tag in your
commit message:

Resolves: https://gitlab.com/qemu-project/qemu/-/issues/3001

Thanks,
Zhao
---
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index b2116335752d..c175e7d9e7b8 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -81,7 +81,9 @@
     { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
     { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },

-GlobalProperty pc_compat_10_0[] = {};
+GlobalProperty pc_compat_10_0[] = {
+    { TYPE_X86_CPU, "x-amd-disable-arch-capabs", "false" },
+};
 const size_t pc_compat_10_0_len = G_N_ELEMENTS(pc_compat_10_0);

 GlobalProperty pc_compat_9_2[] = {};
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9aa0ea447860..a8e83efd83f6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8336,10 +8336,12 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
      *
      * So ensure that the ARCH_CAPABILITIES MSR is disabled on AMD cpus
      * to prevent providing a cpu with an MSR which is not supposed to
-     * be there, unless it was explicitly requested by the user.
+     * be there.
      */
-    if (IS_AMD_CPU(env) &&
-        !(env->user_features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES)) {
+    if (cpu->amd_disable_arch_capabs && IS_AMD_CPU(env)) {
+        mark_unavailable_features(cpu, FEAT_7_0_EDX,
+            env->user_features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES,
+            "This feature is not available for AMD Guest");
         env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_CAPABILITIES;
     }

@@ -9414,6 +9416,8 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
     DEFINE_PROP_BOOL("x-l1-cache-per-thread", X86CPU, l1_cache_per_core, true),
+    DEFINE_PROP_BOOL("x-amd-disable-arch-capabs", X86CPU, amd_disable_arch_capabs,
+                     true),
 };

 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 51e10139dfdf..a3fc80de3a75 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2306,6 +2306,13 @@ struct ArchCPU {
      */
     uint32_t guest_phys_bits;

+    /*
+     * Compatibility bits for old machine types.
+     * If true disable CPUID_7_0_EDX_ARCH_CAPABILITIES and
+     * MSR_IA32_ARCH_CAPABILITIES for AMD Guest.
+     */
+    bool amd_disable_arch_capabs;
+
     /* in order to simplify APIC support, we leave this pointer to the
        user */
     struct DeviceState *apic_state;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 234878c613f6..40a50ae193c7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2368,6 +2368,11 @@ int kvm_arch_init_vcpu(CPUState *cs)

     cpu->kvm_msr_buf = g_malloc0(MSR_BUF_SIZE);

+    if (cpu->amd_disable_arch_capabs &&
+        !(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES)) {
+        has_msr_arch_capabs = false;
+    }
+
     if (!(env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_RDTSCP)) {
         has_msr_tsc_aux = false;
     }





