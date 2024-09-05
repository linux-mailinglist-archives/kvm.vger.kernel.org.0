Return-Path: <kvm+bounces-25929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBCD96D33D
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 11:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 434E21C2584F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EA5198E6D;
	Thu,  5 Sep 2024 09:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iny2K5Cm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A4197A9E;
	Thu,  5 Sep 2024 09:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528487; cv=none; b=SKSp71WiGqgCN5p54FjUTRw1qDoe4MirF+1GtA98BRJ7jv1Wcvqc7yGBzUBjJjkje/vUV+V6KNCQzT82qyT82jcetL9Tg2NEDqwQ52ZRlWVoWCNJXCHt8YyFZ0PfCRDI33yilH3nETdLWvR6TqDRGjgm+1sCQDF0g0tH534up/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528487; c=relaxed/simple;
	bh=WC+VXLzSBwluv2vPpjWrFh6Amvrc4jdoGupj0JdnJTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCWt/P7klphEyWe7xZQhr8IlCE+N1z7DBiwVIernl4c2V5HM/bzWLwcEp4yuEw/MNFWVeisr70M8cQuou4WE2uM715D1tJZnJCyH7X2i195pSJZQtkl7hNRK5XBIzmkCxZ+0aGdetN0LOSnGe24O4SJn4kbjahQiwoQSNJQhiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iny2K5Cm; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725528486; x=1757064486;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WC+VXLzSBwluv2vPpjWrFh6Amvrc4jdoGupj0JdnJTo=;
  b=iny2K5CmnGrHHCdsTTIJElB/jCuT1VtjSIpQQjYdimv0DCiXHUqE6s9A
   3iZI9sN1jgcuDPTJXeTeZiNy6Gl2o8UymbesgnHygrcaCB2JMWDOi+RaM
   xaMFv4voybLBcbglYKWRMjznfI8kM0hqq4JJIN/w1OKOG9e/3A5TbWqbz
   wgJbuoLKamnQNN79GwhAaDSdB28cd/CUMn9Wc5COtJ62V3fGcMTS9jjKZ
   YYk58NpDKX7y6blYdrBMKXGST8YcSPQKebpXf4ykL9DVUDAk4z+E4qYjJ
   mHtb+g+Y0HBnFFZu85htO5DXzGCl1PJDdkbqAWztUM/5BjBTusQTEqVI0
   g==;
X-CSE-ConnectionGUID: Z/f4YeeXT02/OacsghMd0A==
X-CSE-MsgGUID: 77dr74DVRRm4rviRGtKVXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="27986166"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="27986166"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 02:28:05 -0700
X-CSE-ConnectionGUID: AOegvW/lSgC4gU3ZGC1TlQ==
X-CSE-MsgGUID: c0Bg2dRhSWKoHRtJJjX1DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="70167636"
Received: from fdefranc-mobl3.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.103])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 02:28:00 -0700
Date: Thu, 5 Sep 2024 12:27:54 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <Ztl5muQNXr7eGLWU@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
 <ZtWUATuc5wim02rN@tlindgre-MOBL1>
 <ZtlWzUO+VGzt7Z89@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtlWzUO+VGzt7Z89@yzhao56-desk.sh.intel.com>

On Thu, Sep 05, 2024 at 02:59:25PM +0800, Yan Zhao wrote:
> On Mon, Sep 02, 2024 at 01:31:29PM +0300, Tony Lindgren wrote:
> > On Thu, Aug 29, 2024 at 02:27:56PM +0800, Yan Zhao wrote:
> > > On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > ...
> > > > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > > > +{
> > ...
> > 
> > > > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > > > +	kvm_tdx->attributes = td_params->attributes;
> > > > +	kvm_tdx->xfam = td_params->xfam;
> > > > +
> > > > +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> > > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> > > > +	else
> > > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> > > > +
> > > Could we introduce a initialized field in struct kvm_tdx and set it true
> > > here? e.g
> > > +       kvm_tdx->initialized = true;
> > > 
> > > Then reject vCPU creation in tdx_vcpu_create() before KVM_TDX_INIT_VM is
> > > executed successfully? e.g.
> > > 
> > > @@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > >         struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > 
> > > +       if (!kvm_tdx->initialized)
> > > +               return -EIO;
> > > +
> > >         /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > >         if (!vcpu->arch.apic)
> > >                 return -EINVAL;
> > > 
> > > Allowing vCPU creation only after TD is initialized can prevent unexpected
> > > userspace access to uninitialized TD primitives.
> > 
> > Makes sense to check for initialized TD before allowing other calls. Maybe
> > the check is needed in other places too in additoin to the tdx_vcpu_create().
> Do you mean in places checking is_hkid_assigned()?

Sounds like the state needs to be checked in multiple places to handle
out-of-order ioctls to that's not enough.

> > How about just a function to check for one or more of the already existing
> > initialized struct kvm_tdx values?
> Instead of checking multiple individual fields in kvm_tdx or vcpu_tdx, could we
> introduce a single state field in the two strutures and utilize a state machine
> for check (as Chao Gao pointed out at [1]) ?

OK

> e.g.
> Now TD can have 5 states: (1)created, (2)initialized, (3)finalized,
>                           (4)destroyed, (5)freed.
> Each vCPU has 3 states: (1) created, (2) initialized, (3)freed
> 
> All the states are updated by a user operation (e.g. KVM_TDX_INIT_VM,
> KVM_TDX_FINALIZE_VM, KVM_TDX_INIT_VCPU) or a x86 op (e.g. vm_init, vm_destroy,
> vm_free, vcpu_create, vcpu_free).
> 
> 
>      TD                                   vCPU
> (1) created(set in op vm_init)
> (2) initialized
> (indicate tdr_pa != 0 && HKID assigned)
> 
>                                           (1) created (set in op vcpu_create)
> 
>                                           (2) initialized
> 
>                                     (can call INIT_MEM_REGION, GET_CPUID here)
> 
> 
> (3) finalized
> 
>                                  (tdx_vcpu_run(), tdx_handle_exit() can be here)
> 
> 
> (4) destroyed (indicate HKID released)
> 
>                                          (3) freed
> 
> (5) freed

So an enum for the TD state, and also for the vCPU state?

Regards,

Tony
 
> [1] https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/#t

