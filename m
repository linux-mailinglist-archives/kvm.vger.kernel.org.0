Return-Path: <kvm+bounces-54090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9558B1C159
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A49563AEB30
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 07:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6DA219A8A;
	Wed,  6 Aug 2025 07:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pjg5UgUd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F06165F16;
	Wed,  6 Aug 2025 07:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754465533; cv=none; b=lhieMnZu0ky6ruExXLX8gTqpGQFwqmi+fE2EZXZjLpiUusYbHRzb2bHYCGfpV7pL5HHTVRCnz95XffzOFxFIohkrCw7POfjOhm4KdaTkdsVnM2x2wqeAMdOj0eKWh3/rgaNcYnUyPaswFf0FNYRfygujNpLejh8bas0AbHP1Sfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754465533; c=relaxed/simple;
	bh=OzGX1jNGNH78XDlpJg4cSS2HNJTzluIxCDtu0Y5sqrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cEujNCCdOcaZ0F4j04e95YBAL0/JLwbBhM7PRN5x6HXaB/Pv+lYAYZGuOIURpD09sPyiRTMTTuxhliu49Sj4d9OIjEAvxJy+kyYheI9Q0LybfMkFfXVva4eHgHwRcVd7p+i9sOSnNOyWfOqDyvLHFlSZgnGTqXCrd5ijuEhJH5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pjg5UgUd; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754465531; x=1786001531;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OzGX1jNGNH78XDlpJg4cSS2HNJTzluIxCDtu0Y5sqrU=;
  b=Pjg5UgUdagQ5ov977YpBK1K5mqqqkl1Hj28tXxQlUP9al1xhDfCztwFE
   IIwAQO1fJMlYeM7LdANo5qWBSQImpbCwA+65sTHu8EIZe8M0Fg+1POvfQ
   awbYBKKwxnZGXBms7mTHu/bVML7TWOTqv39als4wPsGp87i8Hbe+cY/bh
   jbvK8ZPf8xeKY0zBTeYe5eUKmP9mPCFS6YxzzwU6PZjxf9v8n7hmqf/+7
   iD05ZWcXfCwOuC/OUuy+uapFvUpGDHWlg8sKWeFLa5Sj8uyIwqKtCQaJ4
   M2/yff4En4oIs6H9JPEe9iwDfHyXS4dIJWElq5Gvxou50Hm5f2rv0Qm+j
   A==;
X-CSE-ConnectionGUID: JT5qneIXTm+qFTKRpYPVSw==
X-CSE-MsgGUID: ClqzzD4URByFbYfYa6X2mA==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="44367327"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="44367327"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:32:11 -0700
X-CSE-ConnectionGUID: hNKTKr+dQ2+wLZOt9G/fYQ==
X-CSE-MsgGUID: kYfL1xXfRrSzGYuicnhehQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="163931396"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 00:32:09 -0700
Message-ID: <c92d0904-45de-424a-ad36-172e8e38d15b@linux.intel.com>
Date: Wed, 6 Aug 2025 15:32:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/18] KVM: x86/pmu: Drop redundant check on PMC being
 globally enabled for emulation
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
 <20250805190526.1453366-15-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> When triggering PMC events in response to emulation, drop the redundant
> checks on a PMC being globally and locally enabled, as the passed in bitmap
> contains only PMCs that are locally enabled (and counting the right event),
> and the local copy of the bitmap has already been masked with global_ctrl.
>
> No true functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index a495ab5d0556..bdcd9c6f0ec0 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -969,7 +969,7 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>  		return;
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> -		if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
> +		if (!pmc_is_locally_enabled(pmc) ||
>  		    !check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
>  			continue;
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



