Return-Path: <kvm+bounces-21876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4879352DE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35376B20DA7
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F621459F8;
	Thu, 18 Jul 2024 21:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PS5oyCGn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB141EA8F
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337006; cv=none; b=q6wVM3IQbUsn0Pznbk4ZFDG4rlP0caU79iKP8lkP3UGt81wHAaPYP+TNfzZOnR+ufbY9TxDy5dYI/xSDhSIgo5qevtZLVNHsaUhME1oqdTmwHsod4DvfgIGuLgnx6hcs8EkMr9dOKb6OgUp9+IKHnn8Dep0f3d1/pdzT5MVUiEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337006; c=relaxed/simple;
	bh=lP4GxxkF/SjGcy24DAmJFjrxoGFi/IJ2iaI63uiNFtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C63Kps52//7S4COGQJu+Ka2hxeIBXASVccgs+86f/5cO9+olEZYInv7a1jf89FVy6aqQ3HfrEkWttjXQpk7mfBUP/3AVoM0rgqxVBXRSIC05IpKN9CGOShcGoZtoIcvmdOqqeCgJG3Yw3dyhykHvnXK2PaQPomycNNa5bbjZp6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PS5oyCGn; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337005; x=1752873005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lP4GxxkF/SjGcy24DAmJFjrxoGFi/IJ2iaI63uiNFtI=;
  b=PS5oyCGn84kYWOgSS4wc8u0/E04uWYtC7p/fXWnB/1SxZq7ZvMyafjh/
   hQFv9Q/TQRAT8J7bkZKoIh3KdkEOVUq+Yi845aDvuC4EWzYZ+lbsoodu8
   Y2FZ37LghwM7eiF/z6ci82gx5tXuzscWT3tmlluT8fxE8Bg/GBNiIbl3z
   lqai1NFQmf86g1N2ZYmtxUybcvOGrFGtJbWXYi5uuWTxOd9eHy4RNfLSB
   aNw2dPLhG41mjZbsr9eiugm1u8Wl5BEGJYDeQMzsttjketa8HtvwcBfyn
   ZQUVVRC8DQp0OXo1EDp3VhS153h7UBLFx1FX+X6QV7EgRyeyoayGMM6pX
   w==;
X-CSE-ConnectionGUID: lDzPEH4oRmWqLGA9H16eMA==
X-CSE-MsgGUID: f9nTomhxTg29eTSKU8sTlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="21831675"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="21831675"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:04 -0700
X-CSE-ConnectionGUID: 6UCt2pXZQkmkUPbzUyLDKg==
X-CSE-MsgGUID: 1tSgln86RBOP8GmMhUTd2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55179092"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:04 -0700
Message-ID: <bc4daffc-0fcc-4e24-9472-0b18f6189f83@intel.com>
Date: Thu, 18 Jul 2024 14:10:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] target/i386/kvm: Only save/load kvmclock MSRs when
 kvmclock enabled
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-4-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-4-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> MSR_KVM_SYSTEM_TIME and MSR_KVM_WALL_CLOCK are attached with the (old)
> kvmclock feature (KVM_FEATURE_CLOCKSOURCE).
> 
> So, just save/load them only when kvmclock (KVM_FEATURE_CLOCKSOURCE) is
> enabled.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

 Reviewed-by: Zide Chen <zide.chen@intel.com>


> ---
>  target/i386/kvm/kvm.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 6ad5a7dbf1fd..ac434e83b64c 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3419,8 +3419,10 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>       */
>      if (level >= KVM_PUT_RESET_STATE) {
>          kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
> -        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
> -        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
> +        if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK) {
> +            kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
> +            kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
> +        }
>          if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
>              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
>          }
> @@ -3895,8 +3897,10 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  #endif
> -    kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
> -    kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
> +    if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK) {
> +        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
> +        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
> +    }
>      if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
>          kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
>      }

