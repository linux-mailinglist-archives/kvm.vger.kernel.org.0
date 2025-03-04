Return-Path: <kvm+bounces-39990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4EBA4D58D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0A5D1894ED4
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 08:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2AF1F8EFE;
	Tue,  4 Mar 2025 07:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jtsa2FkQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD3D1FBCB3
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741075177; cv=none; b=hjZ/cFRLRqhSsghDIc1VLRdPgmhP55WQyZhHZskF0VTSaCV8TeTLAKvKw6hulWYs/qu9x224dDZ1vqZNw+7mN4bDdJH4n2Ouyu7JFuu0UrRTX5NEDCHO5u0fMKG+LWvCPyRuYu9nC6RTj6Zq1zPzMDsgt28Awi5m++b6ZjJYDes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741075177; c=relaxed/simple;
	bh=fStzAgDO0dDP/vwo04uzV8D13FdB8wbm/NHcgdjt3ZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X45f5TvcdZ9eKkYJo/Pv3dowp9qLv3nWO6GwqQ642OtQ9zNyOJlDh1dQIJJnjkkFrwpxRxmOZXlS+1sd6jZXoS+OlrrzFTym83HtBQIdUiknEUQ5BeHMeSVq79FpZfEC0jWvnjXIP1vNrxS7XYvKgwLOQuggmZV2o4hg1XuRzDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jtsa2FkQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741075175; x=1772611175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fStzAgDO0dDP/vwo04uzV8D13FdB8wbm/NHcgdjt3ZQ=;
  b=Jtsa2FkQTHgm5cv/mGjM+PY3j1n+fPIy5ajbVQAAv6ClNUbvaES12xPD
   5mkFeXljz2f/d781CLBdCQzy0eJxJLrd7HTwqn4D6Zw0YQYpNGUiBanSH
   KYNqotYgNh7BK+sDpWtrvFReZbtCqKjIF6JaopHYytrWdiQunAN0qjn6N
   JpmGTHwksKaca8+7sNGjcf442NkecSMZVCRoPoK+Hd2RdVZM38E40LMKM
   5IDSrSvNwb7FPIYihVDgeN3EIszAESW45fUvect5u72dOpg5Xd/4PXEqe
   x0+BlhmBLhjNEPhZ7smqUYtpp2zMlZpfvTd84uz7UpELSAzVsk2NdQNIE
   g==;
X-CSE-ConnectionGUID: JBrwfX8QRK+ZVn4kUyWyGQ==
X-CSE-MsgGUID: oPIPQ+noSwqWSZMcdn2XEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41888627"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41888627"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 23:59:34 -0800
X-CSE-ConnectionGUID: L6ZQuwHCQYydl+Zxmm56sA==
X-CSE-MsgGUID: kmL3LGcoQi+OvI0u7sXtwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118087272"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 23:59:29 -0800
Message-ID: <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com>
Date: Tue, 4 Mar 2025 15:59:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
 "-pmu" is configured
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-5-dongli.zhang@oracle.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250302220112.17653-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
> there is no way to fully disable KVM AMD PMU virtualization. Neither
> "-cpu host,-pmu" nor "-cpu EPYC" achieves this.

This looks like a KVM bug.

Anyway, since QEMU can achieve its goal with KVM_PMU_CAP_DISABLE with 
current KVM, I'm fine with it.

I have one nit below, otherwise

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> As a result, the following message still appears in the VM dmesg:
> 
> [    0.263615] Performance Events: AMD PMU driver.
> 
> However, the expected output should be:
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> This occurs because AMD does not use any CPUID bit to indicate PMU
> availability.
> 
> To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
> when "-pmu" is configured.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>    - Switch back to the initial implementation with "-pmu".
> https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com
>    - Mention that "KVM_PMU_CAP_DISABLE doesn't change the PMU behavior on
>      Intel platform because current "pmu" property works as expected."
> 
>   target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f41e190fb8..5c8a852dbd 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -176,6 +176,8 @@ static int has_triple_fault_event;
>   
>   static bool has_msr_mcg_ext_ctl;
>   
> +static int has_pmu_cap;
> +
>   static struct kvm_cpuid2 *cpuid_cache;
>   static struct kvm_cpuid2 *hv_cpuid_cache;
>   static struct kvm_msr_list *kvm_feature_msrs;
> @@ -2053,6 +2055,33 @@ full:
>   
>   int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>   {
> +    static bool first = true;
> +    int ret;
> +
> +    if (first) {
> +        first = false;
> +
> +        /*
> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
> +         * disable PMUs; however, QEMU has been providing PMU property per
> +         * CPU since v1.6. In order to accommodate both, have to configure
> +         * the VM-level capability here.
> +         *
> +         * KVM_PMU_CAP_DISABLE doesn't change the PMU
> +         * behavior on Intel platform because current "pmu" property works
> +         * as expected.
> +         */
> +        if (has_pmu_cap && !X86_CPU(cpu)->enable_pmu) {

One nit, it's safer to use

	(has_pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu

Maybe we can rename has_pmu_cap to pmu_cap as well.

> +            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                    KVM_PMU_CAP_DISABLE);
> +            if (ret < 0) {
> +                error_setg_errno(errp, -ret,
> +                                 "Failed to set KVM_PMU_CAP_DISABLE");
> +                return ret;
> +            }
> +        }
> +    }
> +
>       return 0;
>   }
>   
> @@ -3351,6 +3380,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
> +
>       return 0;
>   }
>   


