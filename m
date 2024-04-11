Return-Path: <kvm+bounces-14312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 194918A1EF3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 342891C233ED
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603E21427E;
	Thu, 11 Apr 2024 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AukPD8e6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E66EEB5;
	Thu, 11 Apr 2024 18:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712861701; cv=none; b=dfRkrA7vobELDPpUAbqXqBxqzZXOxhlHYmVv6flvm+hOTnM8OFcpqEUOpEu6BzqcXD8KuPGyFjxWC2NUsKFHvaoTEzV0Hjp6t25o1j0XFPZxOCzLQpSb8tFPWT5pIARUfYTD7s3qczam3XP0s6osQsgPqxdS4JC1lDiQccYqKjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712861701; c=relaxed/simple;
	bh=5qP8l0+mW39Glyl2G8xkXhZdK8fVn2AWA1IKf9RJTZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAPJteF3saaJ+5KFQM24JkGCuIbZbG07vWtIaneaYG9Ny4zh/tNdEIdDHz7g2BZ8bvwnCtfl4wb6KkoYCEb/MIWaBwRNX7Q3g6TmKxayP8ATG4Eq7/a16OgP3IW+xCQEbJKw1AEVDgqhmKobKiribKZcFudzjNs6NY5Gc529LCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AukPD8e6; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712861701; x=1744397701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5qP8l0+mW39Glyl2G8xkXhZdK8fVn2AWA1IKf9RJTZo=;
  b=AukPD8e6OTW4hcDUzXWJV9dmtI6GdMOgQWiWQ5b9YXAunSQYo+dpLbV6
   vHWq6koQZuVgCJlgsy/+pPWo7wZiL4AcPKpewoAQSBX/fFEZp+pm/yCic
   P2gCxuMWvfkdS4WVu/8IsxWJExEJCZlHkt/xnI/ao4DKrWFqXMVSGYvPd
   rGdSJK+hxWhtEpQMBG8ZHssUQF/xzme55zTXw8LOvT+t8SMTWM3lwh1eo
   zJpLlv59vnzHGy7rdLzWLOQ3EmqDathqac3v8Yf3V1bfIJK05KQn8dt06
   iZAsEZZVge10EK/JVXelgGpITo6CGmG7v3BLhvILY1F2ihNaG6H7wtnVD
   w==;
X-CSE-ConnectionGUID: 1hZWUkabTGiwpRI775TTyg==
X-CSE-MsgGUID: ZL3Jhn72RnC+j7vJ+g6jpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8520098"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8520098"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 11:55:00 -0700
X-CSE-ConnectionGUID: eK3XVo2vSey1O7rwnqOZTA==
X-CSE-MsgGUID: P9A6tH+TSGKBy6b6UIs1Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25540715"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 11:54:59 -0700
Date: Thu, 11 Apr 2024 11:54:58 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240411185458.GD3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <4c64bdac-f1fb-4f29-b753-46ee82a68dc0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4c64bdac-f1fb-4f29-b753-46ee82a68dc0@intel.com>

On Thu, Apr 04, 2024 at 12:59:45PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires additional parameters for TDX VM for confidential execution to
> > protect the confidentiality of its memory contents and CPU state from any
> > other software, including VMM.
> 
> Hmm.. not only "confidentiality" but also "integrity".  And the "per-VM" TDX
> initializaiton here actually has nothing to do with "crypto-protection",
> because the establishment of the key has already been done before reaching
> here.
> 
> I would just say:
> 
> After the crypto-protection key has been configured, TDX requires a VM-scope
> initialization as a step of creating the TDX guest.  This "per-VM" TDX
> initialization does the global configurations/features that the TDX guest
> can support, such as guest's CPUIDs (emulated by the TDX module), the
> maximum number of vcpus etc.
> 
> 
> 
> 
> When creating a guest TD VM before creating
> > vcpu, the number of vcpu, TSC frequency (the values are the same among
> > vcpus, and it can't change.)  CPUIDs which the TDX module emulates.
> 
> I cannot parse this sentence.  It doesn't look like a sentence to me.
> 
> Guest
> > TDs can trust those CPUIDs and sha384 values for measurement.
> 
> Trustness is not about the "guest can trust", but the "people using the
> guest can trust".
> 
> Just remove it.
> 
> If you want to emphasize the attestation, you can add something like:
> 
> "
> It also passes the VM's measurement and hash of the signer etc and the
> hardware only allows to initialize the TDX guest when that match.
> "
> 
> > 
> > Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
> > guest.
> 
> [...]
> 
> It assigns an encryption key to the TDX guest for memory
> > encryption.  TDX encrypts memory per guest basis.
> 
> No it doesn't.  The key has been programmed already in your previous patch.
> 
> The device model, say
> > qemu, passes per-VM parameters for the TDX guest.
> 
> This is implied by your first sentence of this paragraph.
> 
> The maximum number of
> > vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
> > vcpu.  The TDX guest can not change it.), attributes (production or debug),
> > available extended features (which configure guest XCR0, IA32_XSS MSR),
> > CPUIDs, sha384 measurements, etc.
> 
> This is not a sentence.
> 
> > 
> > Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
> > configurations aren't available yet.
> 
> "
> This "per-VM" TDX initialization must be done before any "vcpu-scope" TDX
> initialization.  To match this better, require the KVM_TDX_INIT_VM IOCTL()
> to be done before KVM creates any vcpus.
> 
> Note KVM configures the VM's CPUIDs in KVM_SET_CPUID2 via vcpu.  The
> downside of this approach is KVM will need to do some enforcement later to
> make sure the consisntency between the CPUIDs passed here and the CPUIDs
> done in KVM_SET_CPUID2.
> "

Thanks for the draft.  Let me update it.

> So CPUIDs configuration values need
> > to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
> > to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
> 
> And I would leave how to handle KVM_SET_CPUID2 to the patch that actually
> enforces the consisntency.

Yes, that's a different discussion.


> > +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
> > +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> > +{
> > +	return cpuid_entry2_find(entries, nent, function, index);
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
> 
> Not sure whether we can export cpuid_entry2_find() directly?
> 
> No strong opinion of course.
> 
> But if we want to expose the wrapper, looks ...


Almost all KVM exported symbols have kvm_ prefix. I'm afraid that cpuid is too
common.  We can rename the function directly without wrapper.


> > +
> >   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> >   						    u32 function, u32 index)
> >   {
> > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > index 856e3037e74f..215d1c68c6d1 100644
> > --- a/arch/x86/kvm/cpuid.h
> > +++ b/arch/x86/kvm/cpuid.h
> > @@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
> >   void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
> >   void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
> > +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
> > +					       int nent, u32 function, u64 index);
> >   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> >   						    u32 function, u32 index); >   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> 
> ... __kvm_find_cpuid_entry() would fit better?

Ok, let's rename it.


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 1cf2b15da257..b11f105db3cd 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -8,7 +8,6 @@
> >   #include "mmu.h"
> >   #include "tdx_arch.h"
> >   #include "tdx.h"
> > -#include "tdx_ops.h"
> 
> ??
> 
> If it isn't needed, then it shouldn't be included in some previous patch.

Will fix.


> >   #include "x86.h"
> >   #undef pr_fmt
> > @@ -350,18 +349,21 @@ static int tdx_do_tdh_mng_key_config(void *param)
> >   	return 0;
> >   }
> > -static int __tdx_td_init(struct kvm *kvm);
> > -
> >   int tdx_vm_init(struct kvm *kvm)
> >   {
> > +	/*
> > +	 * This function initializes only KVM software construct.  It doesn't
> > +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> > +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> > +	 */
> > +
> >   	/*
> >   	 * TDX has its own limit of the number of vcpus in addition to
> >   	 * KVM_MAX_VCPUS.
> >   	 */
> >   	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
> > -	/* Place holder for TDX specific logic. */
> > -	return __tdx_td_init(kvm);
> > +	return 0;
> 
> ??
> 
> I don't quite understand.  What's wrong of still calling __tdx_td_init() in
> tdx_vm_init()?
> 
> If there's anything preventing doing __tdx_td_init() from tdx_vm_init(),
> then it's wrong to implement that in your previous patch.

Yes. As discussed the previous patch is too big, we need to break the previous
patch and this patch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

