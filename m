Return-Path: <kvm+bounces-1287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2667E6122
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 00:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43601281310
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 23:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0DF38DE7;
	Wed,  8 Nov 2023 23:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZDPZYHN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A58374EB
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:41:15 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA6625B5;
	Wed,  8 Nov 2023 15:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699486875; x=1731022875;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dT4WQCUdQprCWd3G6FCRdYNt6S9bUj4wPnLHTTo5DBg=;
  b=NZDPZYHNKSiixvkINN75IMHf8xmGQSI9esmtK0wmdQGIQ0Tl8mXXG+RC
   8OorF60zIOD6NV/JKfu2a7kgvkEMBoEGSBIaI+KlBfyOJEGwECi/1/Svp
   eaeOjc0HvqjTZXKE+ITDSDLsaNYOSVo/z9+DHHkVzCZSezMJw0ZlNluhy
   aamfP9ejQTBG3zjWKtwCt6ye+ah0vWQbB2JDbMY4LXgYbtcOwLWgOUbgY
   lwm4/ybI7szptMC20Yo+EgW+xYKocTECe/Pd6VUX97ufI/uSwnUQjdhcu
   7iqqi/G+zjkGe2CvEUk7nqTZRAESqZ/Kt5h8LDOiD+E8h5+e7p62L5Rng
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="8533115"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="8533115"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 15:41:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="853907440"
X-IronPort-AV: E=Sophos;i="6.03,287,1694761200"; 
   d="scan'208";a="853907440"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 15:41:13 -0800
Date: Wed, 8 Nov 2023 15:41:13 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 2/2] KVM: X86: Add a capability to configure bus
 frequency for APIC timer
Message-ID: <20231108234113.GA1132821@ls.amr.corp.intel.com>
References: <cover.1699383993.git.isaku.yamahata@intel.com>
 <70c2a2277f57b804c715c5b4b4aa0b3561ed6a4f.1699383993.git.isaku.yamahata@intel.com>
 <CALMp9eTG8CbWZaDumKsBsr0qQgrre-_=Fn5jzs7GqHB+MZ-E_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eTG8CbWZaDumKsBsr0qQgrre-_=Fn5jzs7GqHB+MZ-E_A@mail.gmail.com>

On Tue, Nov 07, 2023 at 11:59:35AM -0800,
Jim Mattson <jmattson@google.com> wrote:

> On Tue, Nov 7, 2023 at 11:24 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
> > crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
> > KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
> Nit: FREQUENCY
> > frequency.  When using this capability, the user space VMM should configure
> > CPUID[0x15] to advertise the frequency.
> 
> Is it necessary to advertise the frequency in CPUID.15H? No hardware
> that I know of has a 1 GHz crystal clock, but the current
> implementation works fine without CPUID.15H.

It's not necessary. When the kernel can't determine the frequency based on
cpuid (or cpu model), it determines the frequency based on other known
frequency. e.g. TSC, cmos. I'll drop the sentence.


> > TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
> > x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatch
> Nit: frequency
> > causes the vAPIC timer to fire earlier than the guest expects. [1] The KVM
> > APIC timer emulation uses hrtimer, whose unit is nanosecond.  Make the
> > parameter configurable for conversion from the TMICT value to nanosecond.
> >
> > This patch doesn't affect the TSC deadline timer emulation.  The TSC
> > deadline emulation path records its expiring TSC value and calculates the
> > expiring time in nanoseconds.  The APIC timer emulation path calculates the
> > TSC value from the TMICT register value and uses the TSC deadline timer
> > path.  This patch touches the APIC timer-specific code but doesn't touch
> > common logic.
> >
> > [1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
> > Reported-by: Vishal Annapurve <vannapurve@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/x86.c       | 14 ++++++++++++++
> >  include/uapi/linux/kvm.h |  1 +
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a9f4991b3e2e..20849d2cd0e8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4625,6 +4625,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >         case KVM_CAP_ENABLE_CAP:
> >         case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> >         case KVM_CAP_IRQFD_RESAMPLE:
> > +       case KVM_CAP_X86_BUS_FREQUENCY_CONTROL:
> 
> This capability should be documented in Documentation/virtual/kvm/api.txt.
> 
> >                 r = 1;
> >                 break;
> >         case KVM_CAP_EXIT_HYPERCALL:
> > @@ -6616,6 +6617,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                 }
> >                 mutex_unlock(&kvm->lock);
> >                 break;
> > +       case KVM_CAP_X86_BUS_FREQUENCY_CONTROL: {
> > +               u64 bus_frequency = cap->args[0];
> > +               u64 bus_cycle_ns;
> > +
> 
> To avoid potentially bizarre behavior, perhaps we should disallow
> changing the APIC bus frequency once a vCPU has been created?
> 
> > +               if (!bus_frequency)
> > +                       return -EINVAL;
> > +               bus_cycle_ns = 1000000000UL / bus_frequency;
> > +               if (!bus_cycle_ns)
> > +                       return -EINVAL;
> > +               kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
> > +               kvm->arch.apic_bus_frequency = bus_frequency;
> > +               return 0;
> 
> Should this be disallowed if !lapic_in_kernel?

That makes sense. How about this?
It's difficult to check if vcpu has been created because vcpu may be destroyed.
Check if the vm has vcpus now instead.


diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..cc976df2651e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7858,6 +7858,20 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_X86_BUS_FREQUENCY_CONTROL
+--------------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is the value of apic bus clock frequency
+:Returns: 0 on success, -EINVAL if args[0] contains invalid value for the
+          frequency, or -ENXIO if virtual local APIC isn't enabled by
+          KVM_CREATE_IRQCHIP, or -EBUSY if any vcpu is created.
+
+This capability sets the APIC bus clock frequency (or core crystal clock
+frequency) for kvm to emulate APIC in the kernel.  The default value is 1000000
+(1GHz).
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20849d2cd0e8..388a9989ef7c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6626,9 +6626,25 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		bus_cycle_ns = 1000000000UL / bus_frequency;
 		if (!bus_cycle_ns)
 			return -EINVAL;
-		kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
-		kvm->arch.apic_bus_frequency = bus_frequency;
-		return 0;
+
+		r = 0;
+		mutex_lock(&kvm->lock);
+		/*
+		 * Don't allow to change the frequency dynamically during vcpu
+		 * running to avoid potentially bizarre behavior.
+		 */
+		if (kvm->created_vcpus)
+			r = -EBUSY;
+		/* This is for in-kernel vAPIC emulation. */
+		else if (!irqchip_in_kernel(kvm))
+			r = ENXIO;
+
+		if (!r) {
+			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
+			kvm->arch.apic_bus_frequency = bus_frequency;
+		}
+		mutex_unlock(&kvm->lock);
+		return r;
 	}
 	default:
 		r = -EINVAL;



-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

