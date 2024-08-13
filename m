Return-Path: <kvm+bounces-24048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F02950B53
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93D5A1C20C33
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E7E1A2C08;
	Tue, 13 Aug 2024 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VD2k6eBS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9C6170A18;
	Tue, 13 Aug 2024 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723569673; cv=none; b=UpZaLlQ1ZhfZUV9GTmjFM+Mu5XsABRgcgpcu/+uf4eZDLJYjdx1VdFdWOP7hE/Qst5JgX43ZLAoSZLKm7PVLCIcBZ9fizqXHPysLni4lPqQOPiWDPnD81QSqMLbF8VxQJrjLGigsO0g+Xk8vFXufBPApIGIix8jhCRyBpnlyIWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723569673; c=relaxed/simple;
	bh=EJ3zddtN4dHsXAIsUca3NlyAITki0vkXaggYKAmVHmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+fPYjRztqRKHfyjZ9Wc1jFTU5VJGBVfwPWczx6Gmoz0Jy5HoKBO0AjIvZLXnPwoSebs9pWTKGbXG80yHS2Hyc+KBJF3oMhbeuIgyLPfVq7RWkdiKIwGlj0BF7CZ+tb+662bflv4+WCEn870Ev4J9B7wX+K7WsmBMChVYnzc8iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VD2k6eBS; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723569672; x=1755105672;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EJ3zddtN4dHsXAIsUca3NlyAITki0vkXaggYKAmVHmo=;
  b=VD2k6eBSxE+0SvIfsqdmrcv/Xni5HMpRiipmtqQKuT94nzc/MKPNAv4L
   wtzsFS5NIrPRc/jgXHoWXbWNrN4BjtHxFJnFHB7ODSotSZ/cKHJREAih5
   dxCfMVSg2++4lGHHelO4iYyQNzhckwSeniaUyNl2kbYuHyPfKfKbxwIv5
   wSdDJVHqOa2jAWMfNHFBvcAn4mygru7lFDg2mIeO6xITml+f9g5CgRHQS
   2aoKy1v0jCuAop7qHuIORz1425md3nSLHiesc3MwiKKfwBq8qiWZWBSJ6
   VL+2SErwjbbm/d25vRrPbay76NMtY+0qHd+wsBz/G4EwJu+7xPijHIIcu
   Q==;
X-CSE-ConnectionGUID: XiuI+sqkRquwu3DQfVMyBg==
X-CSE-MsgGUID: aVn2UqGCSiG+KV96Fn/uug==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21883718"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="21883718"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 10:21:10 -0700
X-CSE-ConnectionGUID: Y/cVAO4QTlmfVXabz4w3kg==
X-CSE-MsgGUID: rerKu6oTRuuzDX2C4q5b4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="62890101"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 10:21:09 -0700
Date: Tue, 13 Aug 2024 10:21:08 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <ZruWBHdNwIAwm7QE@ls.amr.corp.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240813080009.zowu3woyffwlyazu@yy-desk-7060>

On Tue, Aug 13, 2024 at 04:00:09PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> > +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > +{
> > +	const struct tdx_sysinfo_module_info *modinfo = &tdx_sysinfo->module_info;
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	unsigned long va;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	if (is_td_vcpu_created(tdx))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * vcpu_free method frees allocated pages.  Avoid partial setup so
> > +	 * that the method can't handle it.
> > +	 */
> 
> This looks not that clear, why vcpu_free can't handle it is not explained.
> 
> Looking the whole function, page already added into TD by
> SEAMCALL should be cleared before free back to kernel,
> tdx_vcpu_free() can handle them. Other pages can be freed
> directly and can't be handled by tdx_vcpu_free() because
> they're not added into TD. Is this right understanding ?

Yes.  If we result in error in the middle of TDX vCPU initialization,
TDH.MEM.PAGE.RECLAIM() result in error due to TDX module state check.
TDX module seems to assume that we don't fail in the middle of TDX vCPU
initialization.  Maybe we can add WARN_ON_ONCE() for such cases.


> > +		ret = -EIO;
> > +		pr_tdx_error(TDH_VP_CREATE, err);
> > +		goto free_tdvpx;
> > +	}
> > +
> > +	for (i = 0; i < tdx_sysinfo_nr_tdcx_pages(); i++) {
> > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +		if (!va) {
> > +			ret = -ENOMEM;
> > +			goto free_tdvpx;
> 
> It's possible that some pages already added into TD by
> tdh_vp_addcx() below and they won't be handled by
> tdx_vcpu_free() if goto free_tdvpx here;

Due to TDX TD state check, we can't free partially assigned TDCS pages.
TDX module seems to assume that TDH.VP.ADDCX() won't fail in the middle.


> > +	else
> > +		err = tdh_vp_init(tdx, vcpu_rcx);
> > +
> > +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> > +		pr_tdx_error(TDH_VP_INIT, err);
> > +		return -EIO;
> > +	}
> > +
> > +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > +	tdx->td_vcpu_created = true;
> > +
> > +	return 0;
> > +
> > +free_tdvpx:
> 
> How about s/free_tdvpx/free_tdcx
> 
> In 1.5 TDX spec these pages are all called TDCX pages, and
> the function context already indicates that we're talking about
> vcpu's TDCX pages.

Oops, this is left over when tdvpx was converted to tdcs.


> > +static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> > +{
> > +	struct msr_data apic_base_msr;
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	int ret;
> > +
> > +	if (cmd->flags)
> > +		return -EINVAL;
> > +	if (tdx->initialized)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
> > +	 * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
> > +	 * KVM_SET_CPUID2.  Otherwise kvm_set_apic_base() will fail.
> > +	 */
> > +	apic_base_msr = (struct msr_data) {
> > +		.host_initiated = true,
> > +		.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
> > +		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0),
> > +	};
> > +	if (kvm_set_apic_base(vcpu, &apic_base_msr))
> > +		return -EINVAL;
> > +
> > +	ret = tdx_td_vcpu_init(vcpu, (u64)cmd->data);

Because we set guest rcx only, we use cmd->data.  Can we add reserved area for
future use similar to struct kvm_tdx_init_vm?
i.e. introduce something like
struct kvm_tdx_init_vcpu {u64 rcx; u64 reserved[]; }
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

