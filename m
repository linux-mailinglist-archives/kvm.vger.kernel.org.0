Return-Path: <kvm+bounces-66675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEFECDC1FB
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 12:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 209BB302954D
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 11:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E5732720C;
	Wed, 24 Dec 2025 11:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iiqnucnl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2630B50B;
	Wed, 24 Dec 2025 11:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766575422; cv=none; b=Rp1v6anevYP3TOnjRxZbUhDmDbMhCn638WIxFr0LTT5rN1mpgSJxQvKdHavhqlbKDOM3E3b0H5ow4tRqXRdEmk3GqVI9bvL9EoclgCSWiLkh7cIeOPLTVFoK4fRtuPtliYKMvS7qMVN+/XB3tefQTnnkUGmTrnWY49cUgrus4+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766575422; c=relaxed/simple;
	bh=ElPfBnwFNKsK42q/al9tYmbunsR9seNZciRFUY9VIsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FylDd64uxQtY61VGork+LIqUGyruJfloAUlPGe9/ozqJR1jsyEE9TPF/yuOyL/dVjMW4Cwgampy1QttjWGIPC7Mn4Ym/kxH9pNn4J0FCLaPY72E8RQ5ZSJSjW7h0fq56mgvyPI4V8CtaEYkZWHyAlOo1eh0zW2sTqZORkGr+wt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iiqnucnl; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766575420; x=1798111420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ElPfBnwFNKsK42q/al9tYmbunsR9seNZciRFUY9VIsE=;
  b=iiqnucnlcMOndja8g4SXFPkrKu8YXnNSyUr/Y2D822AzEWPWLxeEacmS
   qOIcH7okOwbb1XSUagKOfEKBhIeAllhXvTeJ/6WryX72oaB/dXrNueQut
   rldp2L0TOn6GlDpoK/5q/eFjhNrIAktTSI7zkAC+H4MK1epGd62mHyveZ
   jB7ieAtvouAomUjcYePO7gXxVX29VdyHFSeIkO0/llJO1VACKZkWHQsix
   qQbA/HXmK5Q2XX1EaxX2nCbMI8gT6QqZvocUlYuSo2ZyiK6AaHZ7mY7+2
   qgY64s0ubbw1r2S2oJ8bx/8ArwYEC8CBfKcy0/vuNhB/tpnFUTUjW3wwS
   g==;
X-CSE-ConnectionGUID: yGD/A93eRYCOUMl23mmD2g==
X-CSE-MsgGUID: 1MgxGNdzRa2BjMqtLtkdfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11651"; a="79048340"
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="79048340"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 03:23:39 -0800
X-CSE-ConnectionGUID: CAQx4ui/SpC3DJZZQvDWuw==
X-CSE-MsgGUID: 5hb2sBB4TPG4ejLeEInPIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="200495851"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 24 Dec 2025 03:23:36 -0800
Date: Wed, 24 Dec 2025 19:07:06 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: dan.j.williams@intel.com, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Message-ID: <aUvJWmZP5wLpvhnw@yilunxu-OptiPlex-7050>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
 <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch>
 <aTiAKG4TlKcZnJnn@google.com>
 <6939242dcfff1_20cb5100c3@dwillia2-mobl4.notmuch>
 <aTmBobJJo_sFbre9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmBobJJo_sFbre9@google.com>

On Wed, Dec 10, 2025 at 06:20:17AM -0800, Sean Christopherson wrote:
> On Wed, Dec 10, 2025, dan.j.williams@intel.com wrote:
> > Sean Christopherson wrote:
> > > On Sat, Dec 06, 2025, dan.j.williams@intel.com wrote:
> > > I don't think we need anything at this time.  INTEL_TDX_HOST depends on KVM_INTEL,
> > > and so without a user that needs VMXON without KVM_INTEL, I think we're good as-is.
> > > 
> > >  config INTEL_TDX_HOST
> > > 	bool "Intel Trust Domain Extensions (TDX) host support"
> > > 	depends on CPU_SUP_INTEL
> > > 	depends on X86_64
> > > 	depends on KVM_INTEL
> > 
> > ...but INTEL_TDX_HOST, it turns out, does not have any functional
> > dependencies on KVM_INTEL. At least, not since I last checked. Yes, it
> > would be silly and result in dead code today to do a build with:
> > 
> > CONFIG_INTEL_TDX_HOST=y
> > CONFIG_KVM_INTEL=n
> > 
> > However, when the TDX Connect support arrives you could have:
> > 
> > CONFIG_INTEL_TDX_HOST=y
> > CONFIG_KVM_INTEL=n
> > CONFIG_TDX_HOST_SERVICES=y
> > 
> > Where "TDX Host Services" is a driver for PCIe Link Encryption and TDX
> > Module update. Whether such configuration freedom has any practical
> > value is a separate question.
> > 
> > I am ok if the answer is, "wait until someone shows up who really wants
> > PCIe Link Encryption without KVM".
> 
> Ya, that's my answer.  At the very least, wait until TDX_HOST_SERVICES comes
> along.

I've tested the PCIe Link Encryption without KVM, with the kernel
config:

  CONFIG_INTEL_TDX_HOST=y
  CONFIG_KVM_INTEL=n
  CONFIG_TDX_HOST_SERVICES=y

and

--- /dev/null
+++ b/drivers/virt/coco/tdx-host/Kconfig
@@ -0,0 +1,10 @@
+config TDX_HOST_SERVICES
+       tristate "TDX Host Services Driver"
+       depends on INTEL_TDX_HOST
+       default m

Finally I enabled the combination successfully with a patch below, do we
need the change when TDX_HOST_SERVICES comes?

------------8<----------------------

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80527299f859..e3e90d1fcad3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1898,7 +1898,6 @@ config INTEL_TDX_HOST
        bool "Intel Trust Domain Extensions (TDX) host support"
        depends on CPU_SUP_INTEL
        depends on X86_64
-       depends on KVM_INTEL
        depends on X86_X2APIC
        select ARCH_KEEP_MEMBLOCK
        depends on CONTIG_ALLOC
diff --git a/arch/x86/include/asm/virt.h b/arch/x86/include/asm/virt.h
index 77a366afd9f7..26bbf0f21575 100644
--- a/arch/x86/include/asm/virt.h
+++ b/arch/x86/include/asm/virt.h
@@ -6,7 +6,7 @@

 typedef void (cpu_emergency_virt_cb)(void);

-#if IS_ENABLED(CONFIG_KVM_X86)
+#if IS_ENABLED(CONFIG_KVM_X86) || IS_ENABLED(CONFIG_INTEL_TDX_HOST)
 extern bool virt_rebooting;

 void __init x86_virt_init(void);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 278f08194ec8..28fe309093ed 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -134,7 +134,7 @@ config X86_SGX_KVM
 config KVM_INTEL_TDX
        bool "Intel Trust Domain Extensions (TDX) support"
        default y
-       depends on INTEL_TDX_HOST
+       depends on INTEL_TDX_HOST && KVM_INTEL
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select HAVE_KVM_ARCH_GMEM_POPULATE
        help
diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
index 6e485751650c..85ed7a06ed88 100644
--- a/arch/x86/virt/Makefile
+++ b/arch/x86/virt/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y  += svm/ vmx/

-obj-$(subst m,y,$(CONFIG_KVM_X86)) += hw.o
\ No newline at end of file
+obj-$(CONFIG_INTEL_TDX_HOST) += hw.o
+obj-$(subst m,y,$(CONFIG_KVM_X86)) += hw.o
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index 986e780cf438..31ea89069a93 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -48,7 +48,7 @@ static void x86_virt_invoke_kvm_emergency_callback(void)
                kvm_callback();
 }

-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_INTEL_TDX_HOST)
 static DEFINE_PER_CPU(struct vmcs *, root_vmcs);

 static int x86_virt_cpu_vmxon(void)
@@ -257,7 +257,8 @@ static __init int x86_svm_init(void) { return -EOPNOTSUPP; }
 ({                                                     \
        int __r;                                        \
                                                        \
-       if (IS_ENABLED(CONFIG_KVM_INTEL) &&             \
+       if ((IS_ENABLED(CONFIG_KVM_INTEL) ||            \
+            IS_ENABLED(CONFIG_INTEL_TDX_HOST)) &&      \
            cpu_feature_enabled(X86_FEATURE_VMX))       \
                __r = x86_vmx_##fn();                   \
        else if (IS_ENABLED(CONFIG_KVM_AMD) &&          \

> 

