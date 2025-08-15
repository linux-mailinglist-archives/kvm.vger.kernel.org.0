Return-Path: <kvm+bounces-54763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F21BB2766B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 04:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32AA5600974
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A06529E0F6;
	Fri, 15 Aug 2025 02:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D35Eohqg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C881A0BF1;
	Fri, 15 Aug 2025 02:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755226710; cv=none; b=XHWFbqwOYFCqruh7sWYxPwjDqPYoJ8xd5EPOw7Uj7Bx8fqXZqeKJ7+nh94EDih7qfERKhA4WAFVNjjBQB9YlDy/LOrBFV6JDeMsJe5fa7NgHP0GBqoNVHPnXSan94rdbv/wMTWfbV1+eksty8RZ3Eq7Q422fUaJlg+tZZi5B/90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755226710; c=relaxed/simple;
	bh=ZoHCRo69UbHgHx5mAQdVdvvPlidj+UaNVfMUMcDCleg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OwVenmE9IrnoE7HpEokJeT5XBHNXAHaCVMLRhujwNLGEbh7WxDzWfjg1W0+WQj7AqO+aehh7SYCqVnXGmn0ip8hmRhCZ4Lr4J9S4vrC9LUjeDW2pkaP0IooooB9MdJMcrwdVv6fhMnmeSnrAM9aiDqvywutxlRH0GPNw8rVrmPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D35Eohqg; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755226708; x=1786762708;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ZoHCRo69UbHgHx5mAQdVdvvPlidj+UaNVfMUMcDCleg=;
  b=D35EohqgYVXl13FX5gpH42JGNcrcu6jUDHfmyBV+yRTgZPVSNDcoshvX
   Su5R3lfVVP2f+PTcr6cFBpzoINSzXoUa5uj7CH/SYxM77phyj/+Nr2uYm
   HGu8+Sja6FHTB7dKYRjRTSLQ21d+ym1RjdeE06V3O7/20wbjTptB00mcK
   xgpCwHiobhD6mmnUfey3xvxBLWSsE5XkGSbOzV2CHx8Vy3PE2ffhROiZl
   VrdQGLSfducR9jkHMYGcmGODVimc0AhN3ERhXgOesBEVThgJ1m1KdauQS
   sJYmgTkcXbGnwGqyUlmEj9VQS96F0sG526Ay7ciOW4O+kQYxLdWHjvyDn
   Q==;
X-CSE-ConnectionGUID: D+BdQh7YScCzHybbncs/oA==
X-CSE-MsgGUID: 8ide1veTR2WjK5p6WXiwXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="80132903"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="80132903"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 19:58:27 -0700
X-CSE-ConnectionGUID: I56/f9bIRuyvq90j8cNzCA==
X-CSE-MsgGUID: 8pwU93maQr605Wmrss5oBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166827050"
Received: from hmao3-mobl1.ccr.corp.intel.com (HELO [10.238.0.213]) ([10.238.0.213])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 19:58:24 -0700
Message-ID: <aee6539f-528e-46c7-98c6-e740e4c30a5f@intel.com>
Date: Fri, 15 Aug 2025 10:58:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v2] x86/kvm: Prefer native qspinlock for dedicated vCPUs
 irrespective of PV_UNHALT
To: lirongqing <lirongqing@baidu.com>, seanjc@google.com,
 pbonzini@redhat.com, vkuznets@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250722110005.4988-1-lirongqing@baidu.com>
Content-Language: en-US
From: "Guo, Wangyang" <wangyang.guo@intel.com>
In-Reply-To: <20250722110005.4988-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/2025 7:00 PM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
> physical CPUs are available") states that when PV_DEDICATED=1
> (vCPU has dedicated pCPU), qspinlock should be preferred regardless of
> PV_UNHALT.  However, the current implementation doesn't reflect this: when
> PV_UNHALT=0, we still use virt_spin_lock() even with dedicated pCPUs.
> 
> This is suboptimal because:
> 1. Native qspinlocks should outperform virt_spin_lock() for dedicated
>     vCPUs irrespective of HALT exiting
> 2. virt_spin_lock() should only be preferred when vCPUs may be preempted
>     (non-dedicated case)
> 
> So reorder the PV spinlock checks to:
> 1. First handle dedicated pCPU case (disable virt_spin_lock_key)
> 2. Second check single CPU, and nopvspin configuration
> 3. Only then check PV_UNHALT support
> 
> This ensures we always use native qspinlock for dedicated vCPUs, delivering
> pretty performance gains at high contention levels.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> 
> diff with v1: rewrite the changelog
> 
>   arch/x86/kernel/kvm.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 921c1c7..9cda79f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1073,16 +1073,6 @@ static void kvm_wait(u8 *ptr, u8 val)
>   void __init kvm_spinlock_init(void)
>   {
>   	/*
> -	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> -	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> -	 * preferred over native qspinlock when vCPU is preempted.
> -	 */
> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> -		pr_info("PV spinlocks disabled, no host support\n");
> -		return;
> -	}
> -
> -	/*
>   	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
>   	 * are available.
>   	 */
> @@ -1101,6 +1091,16 @@ void __init kvm_spinlock_init(void)
>   		goto out;
>   	}
>   
> +	/*
> +	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> +	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> +	 * preferred over native qspinlock when vCPU is preempted.
> +	 */
> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> +		pr_info("PV spinlocks disabled, no host support\n");
> +		return;
> +	}
> +
>   	pr_info("PV spinlocks enabled\n");
>   
>   	__pv_init_lock_hash();

For non-overcommit VM, we may add `-overcommit cpu-pm=on` options to 
qemu-kvm and let guest to handle idle by itself and reduce the latency. 
Current kernel will fallback to virt_spin_lock, even kvm-hint-dedicated 
is provided. With this patch, it can fix this problem and use mcs queue 
spinlock for better performance.

Tested-by: Wangyang Guo <wangyang.guo@intel.com>

