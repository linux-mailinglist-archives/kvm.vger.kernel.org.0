Return-Path: <kvm+bounces-21879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C099352E4
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31A43B20F8F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC3B1459F8;
	Thu, 18 Jul 2024 21:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0JJziY0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13A11EA8F
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337050; cv=none; b=eJkk1y3DXAT4xge6sAQOgsnnWvIo2SgSuSDuQ3aghPkidNmc14ZPu0kz9IaTmTHcXaMrsnWs9X9WYfHuJLQElKLGR5fR6Fbd2EvUn0TbsreXTH/GwuXoQ+trghjdUhPxlfY3TO5OIhkv/dNFMa+ZxmTI1duE5IQwBB4S3FfJCP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337050; c=relaxed/simple;
	bh=5Mi5TH0Ap7UxduGwfjOU7rsOfiTEruZX2i1me2cV3SQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hStHKe4nQkWhWrmHCwMcIrkc0p+7AsUpdZYodoihokc7OrZwgynCDGRNgDI72e4DTnjmwmDzRnT5iAdg8zraxvMd7jT3wMHdRYnq7MXQb9iOfL0EaM7vxP4dGiDCNdIsrykDLzFRQ9fOsdKwW4HyNkBsF5SlxgsxT0kMcYX8kv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y0JJziY0; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337049; x=1752873049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Mi5TH0Ap7UxduGwfjOU7rsOfiTEruZX2i1me2cV3SQ=;
  b=Y0JJziY07dYX9gHg+W7NjPv+mEYGaB9Lt937HM8H3wjNwNGdFY87/AI2
   Rd6OVTQSDLHSa9Sw6BSQo9l6Y4Jy7+GeNp857qscBWqg34Mh9bgf1h63X
   wGwbfWkCO4t7apDre9i7xlwj7v6lngwzj2mDpxyEL2W1ZFFSai3QkDOKP
   cKG/3ERq8xHsbCt4Hk81LFHU1M1HMqZkFNLB9IMmX6Un7w6gaTyqGUTIi
   2rRdW4ILA+JviieNbHabi0VsYj8oB8hgtyyJEAnnDqT6BL++pqqwUOp5h
   Efn3oqNc65DVWiVGfzJ6NL+eYf+A4KKSueZXvL0b6fwnDEbW7ZHgTbEHI
   A==;
X-CSE-ConnectionGUID: ZlLq+ZjsTfSPhFHJ2giaWw==
X-CSE-MsgGUID: jQBXa7wqSeq1mJ6C/j33Ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36370705"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="36370705"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:48 -0700
X-CSE-ConnectionGUID: VAr0j64QQPWS/v0wihZO+g==
X-CSE-MsgGUID: 2A9XI8++Sa6pFQYEUyvcqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="81935018"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:47 -0700
Message-ID: <797fb06e-ed14-4b56-969f-df73d3487e30@intel.com>
Date: Thu, 18 Jul 2024 14:10:47 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/9] target/i386/kvm: Clean up return values of MSR
 filter related functions
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-8-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> At present, the error code of MSR filter enablement attempts to print in
> error_report().
> 
> Unfortunately, this behavior doesn't work because the MSR filter-related
> functions return the boolean and current error_report() use the wrong
> return value.
> 
> So fix this by making MSR filter related functions return int type and
> printing such returned value in error_report().
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

 Reviewed-by: Zide Chen <zide.chen@intel.com>

> ---
> v4: Returned kvm_vm_ioctl() directly. (Zide)
> v3: new commit.
> ---
>  target/i386/kvm/kvm.c      | 34 ++++++++++++++--------------------
>  target/i386/kvm/kvm_i386.h |  4 ++--
>  2 files changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4aae4ffc9ccd..f68be68eb411 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2780,8 +2780,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>              }
>      }
>      if (kvm_vm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR)) {
> -        bool r;
> -
>          ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
>                                  KVM_MSR_EXIT_REASON_FILTER);
>          if (ret) {
> @@ -2790,9 +2788,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>              exit(1);
>          }
>  
> -        r = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
> -                           kvm_rdmsr_core_thread_count, NULL);
> -        if (!r) {
> +        ret = kvm_filter_msr(s, MSR_CORE_THREAD_COUNT,
> +                             kvm_rdmsr_core_thread_count, NULL);
> +        if (ret) {
>              error_report("Could not install MSR_CORE_THREAD_COUNT handler: %s",
>                           strerror(-ret));
>              exit(1);
> @@ -5274,13 +5272,13 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
>      }
>  }
>  
> -static bool kvm_install_msr_filters(KVMState *s)
> +static int kvm_install_msr_filters(KVMState *s)
>  {
>      uint64_t zero = 0;
>      struct kvm_msr_filter filter = {
>          .flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
>      };
> -    int r, i, j = 0;
> +    int i, j = 0;
>  
>      for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
>          KVMMSRHandlers *handler = &msr_handlers[i];
> @@ -5304,18 +5302,13 @@ static bool kvm_install_msr_filters(KVMState *s)
>          }
>      }
>  
> -    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
> -    if (r) {
> -        return false;
> -    }
> -
> -    return true;
> +    return kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
>  }
>  
> -bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
> -                    QEMUWRMSRHandler *wrmsr)
> +int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
> +                   QEMUWRMSRHandler *wrmsr)
>  {
> -    int i;
> +    int i, ret;
>  
>      for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
>          if (!msr_handlers[i].msr) {
> @@ -5325,16 +5318,17 @@ bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
>                  .wrmsr = wrmsr,
>              };
>  
> -            if (!kvm_install_msr_filters(s)) {
> +            ret = kvm_install_msr_filters(s);
> +            if (ret) {
>                  msr_handlers[i] = (KVMMSRHandlers) { };
> -                return false;
> +                return ret;
>              }
>  
> -            return true;
> +            return 0;
>          }
>      }
>  
> -    return false;
> +    return 0;
>  }
>  
>  static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 34fc60774b86..91c2d6e69163 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -74,8 +74,8 @@ typedef struct kvm_msr_handlers {
>      QEMUWRMSRHandler *wrmsr;
>  } KVMMSRHandlers;
>  
> -bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
> -                    QEMUWRMSRHandler *wrmsr);
> +int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
> +                   QEMUWRMSRHandler *wrmsr);
>  
>  #endif /* CONFIG_KVM */
>  

