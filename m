Return-Path: <kvm+bounces-35617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E84A13309
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 07:23:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D7FD3A4FCE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 06:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37C418FDD5;
	Thu, 16 Jan 2025 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OlTwmGpy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C95149C7B;
	Thu, 16 Jan 2025 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737008613; cv=none; b=aJvEPSKtnvmxOQYvQlafoWWCFtSRprrU3P4myDnMVumoqgBvv4fDXWtlgYRtoBoGCuBAmDc0bI5khVG7CtipWsg/WPmh2sNEBw6SEbqCa+/efee5eiIGXPIg4yITCXRWGaizr1eqc7bPvGLOwUU+Q2tPYvIjfhD/5aXsToMzciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737008613; c=relaxed/simple;
	bh=9ox4bJydFkld2HRPKW1i1cevtpfdmg7TgiM9Rw2RoJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AjaoE2NkL2b8fAwUvB4jUGqHvVvmt/pGH/ALir1UPUcF9J1iOFzyheDpIvbPcaqiCbSahY02AgQJGSBp1p7xytYveF7ar3MueEBBmmvcy6gXMuPRGQGxAktIqYyozEeBZi6DY434dHXT/5+hjmEyruNI5NVp/tzPUlWnOuDGmXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OlTwmGpy; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737008612; x=1768544612;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9ox4bJydFkld2HRPKW1i1cevtpfdmg7TgiM9Rw2RoJ8=;
  b=OlTwmGpyCU2fejEntsly+jMtJp4F/QjbrYzW/3OOUGWNZLdP09QIuqfg
   zKc183acNzGCMeiwB9AvZgSokux8or+1ZALoA6Lr6Fra3/CJLFDwd2ggx
   Kw0f5BgFDtrHlZMj9zndJHhDPTJosP26vIauKv13bH5PZJ5mRotn+2Cn3
   xzQvhdq+muLGauPL97IwCtmcSQchlqbPhuROm57gn1dlNeEQoPflGaUmB
   j3leBUK3RVuQmraUQln2G4V/NaD1G7FK+9fTdoZvz02o4o745uqLZP2hI
   KCIXwL24SMuhksJmFZAFadNU9ewpsDJNM5NGzQnE2NAxZAG63LzeGUeOH
   w==;
X-CSE-ConnectionGUID: lOklFTgwRv2WI9jHYdkfow==
X-CSE-MsgGUID: 2LUlzh20QT2PJSjxF8a2Lg==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="37070649"
X-IronPort-AV: E=Sophos;i="6.13,208,1732608000"; 
   d="scan'208";a="37070649"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:23:31 -0800
X-CSE-ConnectionGUID: Qso8WUIqRnOkPpBU2QTbuw==
X-CSE-MsgGUID: DO3tK1lhQ12vrvAoiDvOng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105842602"
Received: from dliang1-mobl.ccr.corp.intel.com (HELO [10.238.10.216]) ([10.238.10.216])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 22:23:27 -0800
Message-ID: <8f350bcc-c819-45cf-a1d5-7d72975912d9@linux.intel.com>
Date: Thu, 16 Jan 2025 14:23:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Kick off vCPUs when SEAMCALL is busy during
 TD page removal
To: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, seanjc@google.com,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, dmatlack@google.com,
 isaku.yamahata@intel.com, isaku.yamahata@gmail.com
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021250.18948-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250113021250.18948-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 1/13/2025 10:12 AM, Yan Zhao wrote:
[...]
> +
>   /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
>   static int __tdx_reclaim_page(hpa_t pa)
>   {
> @@ -979,6 +999,14 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   		return EXIT_FASTPATH_NONE;
>   	}
>   
> +	/*
> +	 * Wait until retry of SEPT-zap-related SEAMCALL completes before
> +	 * allowing vCPU entry to avoid contention with tdh_vp_enter() and
> +	 * TDCALLs.
> +	 */
> +	if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
> +		return EXIT_FASTPATH_EXIT_HANDLED;
> +
>   	trace_kvm_entry(vcpu, force_immediate_exit);
>   
>   	if (pi_test_on(&tdx->pi_desc)) {
> @@ -1647,15 +1675,23 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
>   		return -EINVAL;
>   
> -	do {
> +	/*
> +	 * When zapping private page, write lock is held. So no race condition
> +	 * with other vcpu sept operation.
> +	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
> +	 */
> +	err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
> +				  &level_state);
> +	if ((err & TDX_OPERAND_BUSY)) {

It is not safe to use "err & TDX_OPERAND_BUSY".
E.g., if the error is TDX_EPT_WALK_FAILED, "err & TDX_OPERAND_BUSY" will be true.

Maybe you can add a helper to check it.

staticinlinebooltdx_operand_busy(u64err)
{
return(err &TDX_SEAMCALL_STATUS_MASK) ==TDX_OPERAND_BUSY;
}


>   		/*
> -		 * When zapping private page, write lock is held. So no race
> -		 * condition with other vcpu sept operation.  Race only with
> -		 * TDH.VP.ENTER.
> +		 * The second retry is expected to succeed after kicking off all
> +		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
>   		 */
> +		tdx_no_vcpus_enter_start(kvm);
>   		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
>   					  &level_state);
> -	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
> +		tdx_no_vcpus_enter_stop(kvm);
> +	}
>   
>   	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
>   		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
> @@ -1726,8 +1762,12 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   	WARN_ON_ONCE(level != PG_LEVEL_4K);
>   
>   	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
> -	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> -		return -EAGAIN;
> +	if (unlikely(err & TDX_OPERAND_BUSY)) {
Ditto.

> +		/* After no vCPUs enter, the second retry is expected to succeed */
> +		tdx_no_vcpus_enter_start(kvm);
> +		err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
> +		tdx_no_vcpus_enter_stop(kvm);
> +	}
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
>   		return -EIO;
> @@ -1770,9 +1810,13 @@ static void tdx_track(struct kvm *kvm)
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
> -	do {
> +	err = tdh_mem_track(kvm_tdx->tdr_pa);
> +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY) {
> +		/* After no vCPUs enter, the second retry is expected to succeed */
> +		tdx_no_vcpus_enter_start(kvm);
>   		err = tdh_mem_track(kvm_tdx->tdr_pa);
> -	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
> +		tdx_no_vcpus_enter_stop(kvm);
> +	}
>   
>
[...]

