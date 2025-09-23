Return-Path: <kvm+bounces-58509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19EF3B9492C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77CE83B772C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB40330F938;
	Tue, 23 Sep 2025 06:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jq6Lpw6z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2CF30F547;
	Tue, 23 Sep 2025 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758609432; cv=none; b=X21kZ20OqfmySkwqyS4iHsaKAk23h0zxtQoJKFehwBLdPrdhErW7D4y80/WAySpZ8aEbT+guPKer7a6XZS27ZRKX3nRtWVJZCQVebWILiz2ri1tXLSdbEQFsDcKcMpSjEwvNLdxgz5wIPcLqm0WxsSxq7psCwY9Xo1Zky/euMhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758609432; c=relaxed/simple;
	bh=yMx+HKkOr1zY7jL1zo5NXhkqit1gRXWnFxT0cshm0dY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LloK6wFTMIJDFH9St5UsQ4P/x/H3eRHhlA9bbB/IDrRiw1aMBZNOcUoH1XZhpIZXQq3kbExS4/Rc9H/h7Ci6TcLFZwysLIKsYBCdRv6o7j/2sXdWtZx4Tm4UsAQRQivrD6DXckzODax5/w9gor6BEJztr4+f9A0WmPvSWDcKCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jq6Lpw6z; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758609431; x=1790145431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yMx+HKkOr1zY7jL1zo5NXhkqit1gRXWnFxT0cshm0dY=;
  b=Jq6Lpw6zHsId/mSW2CTyEamIqk3AILVzMb5FphndvKFZLylxTpisu8yF
   ekw5bhdAtyp6rpI9CAWNlFdnfdZl/cZVts6lkfIAoNDX64KqEJb+zAU5a
   rTHrFPFFkNtFmQK+QQjHSJfD3+wSoX8lMamAK4rWKPiohJzGQFIJF9Umm
   XS8OJff1gKXqQzErax5Z9V+EpRqvYC9jK+QC1KHTWVNDbsRC0rQCmxdeP
   U13U04TnPWtrl8vrOtiA8GNDjjFvQx95In6hefxRsGX0cLizGBg6DuXhd
   MKZLb4+9B34wO/pbcU5v0TnMhuEnAPZ3HDL0kgcUKN0tLI2rvC4NgrZwO
   Q==;
X-CSE-ConnectionGUID: kL+DopvrS1KbErbNNg2jlQ==
X-CSE-MsgGUID: 7PWGsNouSI2SIyQr6L+2EQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71555699"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="71555699"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:37:10 -0700
X-CSE-ConnectionGUID: +YOBYbDST0W0Z+bzLzB91Q==
X-CSE-MsgGUID: vAtSfzC+SH6F7CqTr3wCHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="181948151"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 23:37:06 -0700
Message-ID: <cbeaa101-b0fd-49e1-9319-f6070b799214@intel.com>
Date: Tue, 23 Sep 2025 14:37:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH (CET v16 26.5)] KVM: x86: Initialize
 allow_smaller_maxphyaddr earlier in setup
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250922184743.1745778-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250922184743.1745778-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/2025 2:47 AM, Sean Christopherson wrote:
> Initialize allow_smaller_maxphyaddr during hardware setup as soon as KVM
> knows whether or not TDP will be utilized.  To avoid having to teach KVM's
> emulator all about CET, KVM's upcoming CET virtualization support will be
> mutually exclusive with allow_smaller_maxphyaddr, i.e. will disable SHSTK
> and IBT if allow_smaller_maxphyaddr is enabled.
> 
> In general, allow_smaller_maxphyaddr should be initialized as soon as
> possible since it's globally visible while its only input is whether or
> not EPT/NPT is enabled.  I.e. there's effectively zero risk of setting
> allow_smaller_maxphyaddr too early, and substantial risk of setting it
> too late.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> 
> As the subject suggests, I'm going to slot this in when applying the CET
> series as this is a dependency for disabling SHSTK and IBT if
> allow_smaller_maxphyaddr.  Without this, SVM will incorrectly clear (or not)
> SHSTK.  VMX isn't affected because !enable_ept disables unrestricted guest,
> which also clears SHSTK and IBT, but as the changelog calls out, there's no
> reason to wait to initialize allow_smaller_maxphyaddr.
> 
> https://lore.kernel.org/all/20250919223258.1604852-28-seanjc@google.com
> 
>   arch/x86/kvm/svm/svm.c | 30 +++++++++++++++---------------
>   arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
>   2 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 54ca0ec5ea57..74a6e3868517 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5413,6 +5413,21 @@ static __init int svm_hardware_setup(void)
>   			  get_npt_level(), PG_LEVEL_1G);
>   	pr_info("Nested Paging %s\n", str_enabled_disabled(npt_enabled));
>   
> +	/*
> +	 * It seems that on AMD processors PTE's accessed bit is
> +	 * being set by the CPU hardware before the NPF vmexit.
> +	 * This is not expected behaviour and our tests fail because
> +	 * of it.
> +	 * A workaround here is to disable support for
> +	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
> +	 * In this case userspace can know if there is support using
> +	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
> +	 * it
> +	 * If future AMD CPU models change the behaviour described above,
> +	 * this variable can be changed accordingly
> +	 */
> +	allow_smaller_maxphyaddr = !npt_enabled;
> +
>   	/* Setup shadow_me_value and shadow_me_mask */
>   	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
>   
> @@ -5492,21 +5507,6 @@ static __init int svm_hardware_setup(void)
>   
>   	svm_set_cpu_caps();
>   
> -	/*
> -	 * It seems that on AMD processors PTE's accessed bit is
> -	 * being set by the CPU hardware before the NPF vmexit.
> -	 * This is not expected behaviour and our tests fail because
> -	 * of it.
> -	 * A workaround here is to disable support for
> -	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
> -	 * In this case userspace can know if there is support using
> -	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
> -	 * it
> -	 * If future AMD CPU models change the behaviour described above,
> -	 * this variable can be changed accordingly
> -	 */
> -	allow_smaller_maxphyaddr = !npt_enabled;
> -
>   	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_CD_NW_CLEARED;
>   	return 0;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 509487a1f04a..ace8208fc1be 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8479,6 +8479,14 @@ __init int vmx_hardware_setup(void)
>   		return -EOPNOTSUPP;
>   	}
>   
> +	/*
> +	 * Shadow paging doesn't have a (further) performance penalty
> +	 * from GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable it
> +	 * by default
> +	 */
> +	if (!enable_ept)
> +		allow_smaller_maxphyaddr = true;
> +
>   	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
>   		enable_ept_ad_bits = 0;
>   
> @@ -8715,14 +8723,6 @@ int __init vmx_init(void)
>   
>   	vmx_check_vmcs12_offsets();
>   
> -	/*
> -	 * Shadow paging doesn't have a (further) performance penalty
> -	 * from GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable it
> -	 * by default
> -	 */
> -	if (!enable_ept)
> -		allow_smaller_maxphyaddr = true;
> -
>   	return 0;
>   
>   err_l1d_flush:
> 
> base-commit: d44fa096b63659f2398a28f24d99e48c23857c82


