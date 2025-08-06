Return-Path: <kvm+bounces-54091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8161FB1C15E
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35BBD627C30
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0130121146C;
	Wed,  6 Aug 2025 07:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hqAkMt28"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED80205AA1;
	Wed,  6 Aug 2025 07:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465597; cv=none; b=KCIJ9X2F8LCPFgaYASVnP1FfbFO8JtvhJE/PovhCisNXAhiK9Qw0dvADntjXwSekBrGNjXSdWYHVI9Lbz61Af6MIWZTM0rsIBNwpZpm5XSr9x1BWmcNsqaKXLBDvgNSMPr59ydsE3WPvWzlHNRaDciI87hoORJXHS5ZwqNw+GLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465597; c=relaxed/simple;
	bh=o9PVVEoNYNKGJdh1oHu9pFfOJ12DLoQyXZyj5y5IlrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X/dU+wBXBjkrNAegC8h3n2x+ihueLCgULuDRF8MJ+hH8HuVRyZXcKfRfgn/qccyks3trYz3148CgKP+pKh3UtP7mf0V8ceavfRNURXSEHT/vzRhtgyfdJIy8XJAcjbvVmXzLyVP9TxfzgoLTEKJpwPAEZoORB/OomCyOCJcJHF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hqAkMt28; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465596; x=1786001596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o9PVVEoNYNKGJdh1oHu9pFfOJ12DLoQyXZyj5y5IlrY=;
  b=hqAkMt28tu2CRHUFhg+do1hmZABJ3cDxl+4zH1U6d1z8uLLnDoRo6i/l
   v2mYIUkmF/oppaLKdpL6zdt96M2fmtcv/ugTKPR3psrKe/taDSKP07B7+
   ndzktAJKTbgDQgKhkbkTtSUbsbCqPl1JS9QWzpFwz0c7xqjQXO8XVleEo
   LyZL8rXGdKYY83pxPIfVtCsjDcdgylxX48M7yL3GGcRZ7O+UAEveQqC5x
   ZxIS0T5lGTnog8HkrUzj9kbiUVV8+jgzPb18XEkEp91FQ0MOPpfsHEBc1
   HvtyBcHSOULbjie4i9Ddv9I5JzEAj2I/gfpdiSuHaumGOi/jtJOZkGdWQ
   A==;
X-CSE-ConnectionGUID: lnmLJ/nJQE6kQH3sbMXbJA==
X-CSE-MsgGUID: dveH+SWTTTaPxp8peEwhKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="44367442"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="44367442"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:33:15 -0700
X-CSE-ConnectionGUID: 5qjtSVW5RwyHOLbFt53LVA==
X-CSE-MsgGUID: LITql9msSVWQJedGN8jR5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="163931487"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:33:14 -0700
Message-ID: <f08123c8-710d-4dba-889f-c178df0ba4a1@linux.intel.com>
Date: Wed, 6 Aug 2025 15:33:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/18] KVM: x86/pmu: Drop redundant check on PMC being
 locally enabled for emulation
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-16-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> Drop the check on a PMC being locally enabled when triggering emulated
> events, as the bitmap of passed-in PMCs only contains locally enabled PMCs.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index bdcd9c6f0ec0..422af7734846 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -969,8 +969,7 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  		return;
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> -		if (!pmc_is_locally_enabled(pmc) ||
> -		    !check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
> +		if (!check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  
>  		kvm_pmu_incr_counter(pmc);

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



