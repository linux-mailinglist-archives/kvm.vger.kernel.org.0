Return-Path: <kvm+bounces-54092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F13CB1C164
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C7173BC080
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DF721ABB0;
	Wed,  6 Aug 2025 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWB9qolV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3609F1E1E0B;
	Wed,  6 Aug 2025 07:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465748; cv=none; b=J1+yK3/TnRKvmWYBSVem6ynMXEf8SikYu8DGbSxgjN001bt5OO1ETiaHAnmJteGUr2EAoBtz+I+nWXGy3SLpuYGwZFNYZMMqf/G0G4mhadQH5W84cLyVuQTnVx8zNjrtKH19o++ic05S32MHjfhKdnDfF0C/RF4xH/pKXZpK2i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465748; c=relaxed/simple;
	bh=zuHhM0hm0TAVoCSt1vMrFnNsUyF+Cy+CLekCiHSBTv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dlqkqlXrzOS7GLbk6tWiZdoGw9+SdFmoH0yu7hp4nbNf053dNi+KuJjEmPL2oleiu27MJvrj7dj0hp+pbl8v3V/sdFMIvoTiwW3xWDwFez29gl1ozrUGAE5a0QV4slf482WriYoWnG2GvCTZV3wSkUqsi9tqavOUi2/Ntmn3vJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWB9qolV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465747; x=1786001747;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zuHhM0hm0TAVoCSt1vMrFnNsUyF+Cy+CLekCiHSBTv0=;
  b=PWB9qolVyT/lw72zjf0oQZmzdXbMJf61m01RvqTFMOMcHBoleWLGVeB2
   7IzJ7m8vEjIVNLcL7imA/Q112dogGec4hITU6TCdEoF8TpE3eRY2LaG1m
   SGUaty/oEBfA45H23MKwqrFxoKqi6dBnagmKYjwb/0i/HZE6nOR19/wQv
   /FMHGS9jD1rse8y5gL4X7CfEPJlNGlLYclfWDXsodhbLEzWllZYdEWEkh
   76exPdGS0QeeYON5VQo5FDGRWlmXZCMqGMkzSrNHBjLVFHLNxLn7fo8Lv
   h6sllbHO4NhYINJ0IfWbct1JCUE0b9g98M+AIHNqKyR4qsJMMTutfZF6L
   w==;
X-CSE-ConnectionGUID: G2uGS0EYQdygQN58C8zXVg==
X-CSE-MsgGUID: cGt/0tj/RcqEqv8xFUFs3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="55986542"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="55986542"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:35:46 -0700
X-CSE-ConnectionGUID: 1xNxjE1FR/qnk7eN+922LA==
X-CSE-MsgGUID: 50cGG+yVQX2uEWyFyLt4YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="163956251"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:35:45 -0700
Message-ID: <d97c42ad-79ee-4eb0-ba89-85efdfd2c8f7@linux.intel.com>
Date: Wed, 6 Aug 2025 15:35:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/18] KVM: x86/pmu: Rename check_pmu_event_filter() to
 pmc_is_event_allowed()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-17-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Rename check_pmu_event_filter() to make its polarity more obvious, and to
> connect the dots to is_gp_event_allowed() and is_fixed_event_allowed().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 422af7734846..e75671b6e88c 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -476,7 +476,7 @@ static bool is_fixed_event_allowed(struct kvm_x86_pmu_event_filter *filter,
>  	return true;
>  }
>  
> -static bool check_pmu_event_filter(struct kvm_pmc *pmc)
> +static bool pmc_is_event_allowed(struct kvm_pmc *pmc)
>  {
>  	struct kvm_x86_pmu_event_filter *filter;
>  	struct kvm *kvm = pmc->vcpu->kvm;
> @@ -502,7 +502,7 @@ static int reprogram_counter(struct kvm_pmc *pmc)
>  	emulate_overflow = pmc_pause_counter(pmc);
>  
>  	if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
> -	    !check_pmu_event_filter(pmc))
> +	    !pmc_is_event_allowed(pmc))
>  		return 0;
>  
>  	if (emulate_overflow)
> @@ -969,7 +969,7 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  		return;
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> -		if (!check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
> +		if (!pmc_is_event_allowed(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  
>  		kvm_pmu_incr_counter(pmc);

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



