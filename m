Return-Path: <kvm+bounces-58448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93718B942B7
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B8A53ABC20
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D7C273D67;
	Tue, 23 Sep 2025 04:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m8gGLcDT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B97270568;
	Tue, 23 Sep 2025 04:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758600325; cv=none; b=g1w86nbhvPsVAQMLMkRXMXDRKnTWrhk0WM3NQnVJVYrEG2thCFximfd+5BlpqE0ZY8KQxSFOF8kBbriTkTRDk4Qm+o7zD8CDt+E3aj5N5jQw5XwXmvZ+CcRHO6gGPy84NioTDZPh/3u5YB+WqFPYVHUupX9rTsZnDg2QKMsr5GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758600325; c=relaxed/simple;
	bh=6PIwA7arR0o6d3GGOkq6Yfxpemnc+r61GEaPtuR1e0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UcVYxHCFzNx9JYHMrVd9HXRwBXkBDHNFNGZZMKRgYd+iP8TVcpelbBeZVD8yQVQcBjpSUdGTX1QAm5v2QrU9E1w8q/O39k7gpcx8ms9f9WI611JmDAyuuZiIdQfiOQNhxlD2qzrhICuKlhDqazNjXMqZCR/SdBiOTZPPuZKwqi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m8gGLcDT; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758600323; x=1790136323;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6PIwA7arR0o6d3GGOkq6Yfxpemnc+r61GEaPtuR1e0w=;
  b=m8gGLcDTQH06mVc/F0hYOlgyDYBfYAk/ccoOB6H0DjunbYz1zXB24Szm
   lWugtsPsw6UwB7BaCDmFcvKHdy+n5ucCPrn8SHhBMAr9DaopXh54YBSMI
   SPj7U/P37yXEGk/ntvQXOW6Xgrmg3eQhPbqKs+4dARrDuVN1C01FXXIbY
   h3KXT4F/+rY3LrcmiIE9e8xvikuZ/hMZLv3KNc/GeEyoXcrUg5EdL9taz
   +d6Q/t37r3gbRvO+xQClqHLB+DJrg52EiJ6obR3qpw3wgDjMbnMPgDfKg
   GpbtZjCl/qXzBW0xp/avj31FLXt+bwgFg6ch4E2RVnm3Hjk4LhWGDPBs2
   w==;
X-CSE-ConnectionGUID: APXyZATgSimtj7FUf8hD/A==
X-CSE-MsgGUID: ezHtjG3MRNq3HYdMfBXBDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71980327"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="71980327"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 21:05:22 -0700
X-CSE-ConnectionGUID: 1/vuUJf6S7aX/nDsE3yFBA==
X-CSE-MsgGUID: yp9wGNwrR4qtGSep6rARJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="177103530"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 21:05:21 -0700
Message-ID: <b9b4bb21-47db-4282-8d4c-eedb836fbfb9@intel.com>
Date: Tue, 23 Sep 2025 12:05:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: SVM: Re-load current, not host, TSC_AUX on
 #VMEXIT from SEV-ES guest
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>,
 Lai Jiangshan <jiangshan.ljs@antgroup.com>
References: <20250919213806.1582673-1-seanjc@google.com>
 <20250919213806.1582673-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919213806.1582673-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 5:38 AM, Sean Christopherson wrote:
> From: Hou Wenlong <houwenlong.hwl@antgroup.com>
> 
> Prior to running an SEV-ES guest, set TSC_AUX in the host save area to the
> current value in hardware, as tracked by the user return infrastructure,
> instead of always loading the host's desired value for the CPU.  If the
> pCPU is also running a non-SEV-ES vCPU, loading the host's value on #VMEXIT
> could clobber the other vCPU's value, e.g. if the SEV-ES vCPU preempted
> the non-SEV-ES vCPU, in which case KVM expects the other vCPU's TSC_AUX
> value to be resident in hardware.
> 
> Note, unlike TDX, which blindly _zeroes_ TSC_AUX on TD-Exit, SEV-ES CPUs
> can load an arbitrary value.  Stuff the current value in the host save
> area instead of refreshing the user return cache so that KVM doesn't need
> to track whether or not the vCPU actually enterred the guest and thus
> loaded TSC_AUX from the host save area.
> 
> Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
> Cc: stable@vger.kernel.org
> Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> [sean: handle the SEV-ES case in sev_es_prepare_switch_to_guest()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

one nit below,

> ---
>   arch/x86/kvm/svm/sev.c | 14 +++++++++++++-
>   arch/x86/kvm/svm/svm.c | 26 +++++++-------------------
>   arch/x86/kvm/svm/svm.h |  4 +++-
>   3 files changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index cce48fff2e6c..95767b9d0d55 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4664,7 +4664,9 @@ int sev_vcpu_create(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> -void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
> +void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm,
> +				    struct sev_es_save_area *hostsa,
> +				    int tsc_aux_uret_slot)

Passing the tsc_aux_uret_slot as paramter looks a bit ugly, how about 
externing it?

