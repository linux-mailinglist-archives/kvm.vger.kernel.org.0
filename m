Return-Path: <kvm+bounces-16355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6298B8D82
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D54741F22136
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 15:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5655D12FB29;
	Wed,  1 May 2024 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CzjFCQLp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FB64F898;
	Wed,  1 May 2024 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714578984; cv=none; b=pzCLTIfiAcmk6ncC6kA3yp2jomK73Acfm1CNO4DFPQA62DyKwhKOMr6vin2VU1l2K1s82KXvOgBPUM0PrUmpoFcWC/6lHuHqHknNQzN1hAsgQ+4eMHkkMH7Z4lghs85OgnaNNRoC/ZoZEU+la5fvDhDFnr7LsO699bdHcOTW3Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714578984; c=relaxed/simple;
	bh=Ul+Jpm9d6lTEfAqkG8TmFAbQb3enioJbvf95sNAE7uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=earuoNLHONCfe+cGTmd3sCAkKS0RtPDA/61Nmf2Gi0mxLptzA6GvFxpC/LsWqmT2RkhpAXdTlpf+kNVUTItlZ4huPaFCOzz7RA1bt53aNZvRBqM8uXm/ttd/2H5kH/g0NbwgshiGQbUy8wYm/DPSOIeFuORhPqoBEtoTcVzfR80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CzjFCQLp; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714578982; x=1746114982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ul+Jpm9d6lTEfAqkG8TmFAbQb3enioJbvf95sNAE7uI=;
  b=CzjFCQLpLwupMzj5xygPoiVPYh1bSkw8WUs1ba/+nDWTzFihRb92ylBs
   fwhKpyEwU02mJj5WgcFuRYhkOM3slVBZBvbDkf76VLZLFKkkG1HcNeKnB
   pbtazssEBmVkxYz76J2URZI7OViP17I9uN2FzzRwU9Pr/mzu2vVP+b3n5
   sQ1MDzwuIfJB3037q1xyrlzX+ygtBHACo+C9guZU5XJyUAYmVO2THVYux
   wMPiX8UsHoJQ4MLoQYAojMHeWNAWv1204ajH+IsAxqnzVWLJr9urv/BVT
   KHOW3QF8jZExuOvSca+JmOLr39qUb45hYlShHcz75SCDtaAv/7OvCn/wk
   g==;
X-CSE-ConnectionGUID: urGOcVmJSWSAmmN2HnO3zg==
X-CSE-MsgGUID: DqWBf76QRQ2YvtT7Vw49nQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="35700423"
X-IronPort-AV: E=Sophos;i="6.07,245,1708416000"; 
   d="scan'208";a="35700423"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 08:56:21 -0700
X-CSE-ConnectionGUID: MxDtOalKSem0hZXTLSBVEA==
X-CSE-MsgGUID: SnI2oLpSQtCt6AEYlAPvEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,245,1708416000"; 
   d="scan'208";a="57709782"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 08:56:22 -0700
Date: Wed, 1 May 2024 08:56:20 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Message-ID: <20240501155620.GA13783@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
 <20240403184216.GJ2444378@ls.amr.corp.intel.com>
 <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>

On Tue, Apr 30, 2024 at 01:47:07PM -0700,
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Isaku,
> 
> On 4/3/2024 11:42 AM, Isaku Yamahata wrote:
> > On Mon, Apr 01, 2024 at 12:10:58PM +0800,
> > Chao Gao <chao.gao@intel.com> wrote:
> > 
> >>> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	unsigned long exit_qual;
> >>> +
> >>> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
> >>> +		/*
> >>> +		 * Always treat SEPT violations as write faults.  Ignore the
> >>> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
> >>> +		 * TD private pages are always RWX in the SEPT tables,
> >>> +		 * i.e. they're always mapped writable.  Just as importantly,
> >>> +		 * treating SEPT violations as write faults is necessary to
> >>> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
> >>> +		 * due to aliasing a single HPA to multiple GPAs.
> >>> +		 */
> >>> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
> >>> +		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
> >>> +	} else {
> >>> +		exit_qual = tdexit_exit_qual(vcpu);
> >>> +		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
> >>
> >> Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
> >> #PF. I think you can add a comment for this.
> > 
> > Yes.
> > 
> > 
> >> Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.
> > 
> > Bug of what component? CPU. If so, I think KVM_EXIT_INTERNAL_ERROR +
> > KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON is more appropriate.
> > 
> 
> Is below what you have in mind?

Yes. data[0] should be the raw value of exit reason if possible.
data[2] should be exit_qual.  Hmm, I don't find document on data[] for
KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON.
Qemu doesn't assumt ndata = 2. Just report all data within ndata.


> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 499c6cd9633f..bd30b4c4d710 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1305,11 +1305,18 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>  	} else {
>  		exit_qual = tdexit_exit_qual(vcpu);
>  		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
> +			/*
> +			 * Instruction fetch in TD from shared memory
> +			 * causes a #PF.
> +			 */
>  			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
>  				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
> -			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
> -			vcpu->run->ex.exception = PF_VECTOR;
> -			vcpu->run->ex.error_code = exit_qual;
> +			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +			vcpu->run->internal.suberror =
> +				KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +			vcpu->run->internal.ndata = 2;
> +			vcpu->run->internal.data[0] = EXIT_REASON_EPT_VIOLATION;
> +			vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
>  			return 0;
>  		}
>  	}
> 
> Thank you
> 
> Reinette
> 
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

