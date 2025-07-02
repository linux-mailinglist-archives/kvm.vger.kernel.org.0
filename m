Return-Path: <kvm+bounces-51254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9323CAF0A30
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 07:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 979D21882769
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050B91F30B2;
	Wed,  2 Jul 2025 05:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W/rQNoI5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E041EF38E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 05:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751433048; cv=none; b=t5DqpEsfj8GAIxQ+A+GIOY9nTsvJFUq0tRrudf+Kq5YDD1IpmoA6VTNJ/+QmYibzYQq0CyTPJTxHNFYQgsi78jCuZF5qmflnFS5M6YVw4WJCKpCg7wqc4LauW8MGNv5Pciu/6uyUT+GSTjpFun1mCd2+BqyfsYXHkdKFNSDUsfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751433048; c=relaxed/simple;
	bh=vnDsnqkZVkFQ6WP3qoK7mtMNaceCb9TRU+GdjkvdOaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JbnrTn3qPD2QzS5L6sNF9yvkf+0PdOb3soA239742nMIDRC7yhB5gw6HM2TAXnZ/imYGOI+toUMCGUJlfK4dbNpEARqkGBRN4MCSz9Gvg4zjRBLqpIud8LN9CKlJR9SgN479ka8s4tIU8Obtr2VsMqZYcsM3I6sHgZ8pjd8Dzg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W/rQNoI5; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751433046; x=1782969046;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vnDsnqkZVkFQ6WP3qoK7mtMNaceCb9TRU+GdjkvdOaQ=;
  b=W/rQNoI5sH1kN29UnV9J6pbOBUZauLgcktrBsQccXqY126IyaEr1keia
   qlzmqm9oRSZi19LdBAIns+Bj5YMG62x4ygB4t8KkhCn90vh6yHXY9/fZ9
   YQyGJgpdtaAyvGE1/OUtpnUjZGg4WKgMQt1n+3XDftePPwpt02naemi5h
   hOcCv3Bo4LHHvN3yLwuapa7oM5UCS7ug3XNVzizoYnNNGWaIhAWfHh2sR
   VjXXzrZ7EwgBCri0Y0jVKc3p6Dw1DrTYEMlQ6s3QhVtP0I/V1+vZFIBxB
   TRxaExqjUy1+3x82cgeR032ALH4CIIfN0nkTqvEloTeqwBLJPMgN4X2jR
   A==;
X-CSE-ConnectionGUID: bZ1Y/c0tQmavv2h9l576GA==
X-CSE-MsgGUID: n1TY4vjhSN+UO/yOVmhQNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="52833049"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="52833049"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:10:44 -0700
X-CSE-ConnectionGUID: yCyyxUsaTWi2NZOmBgoTAw==
X-CSE-MsgGUID: T9URMdmrTSCvmP35sRIXjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153432671"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:10:40 -0700
Message-ID: <fb562fe3-285a-44a1-a323-d49b014eab0b@linux.intel.com>
Date: Wed, 2 Jul 2025 13:10:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/9] target/i386/kvm: query kvm.enable_pmu parameter
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
 <20250624074421.40429-7-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250624074421.40429-7-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/24/2025 3:43 PM, Dongli Zhang wrote:
> When PMU is enabled in QEMU, there is a chance that PMU virtualization is
> completely disabled by the KVM module parameter kvm.enable_pmu=N.
>
> The kvm.enable_pmu parameter is introduced since Linux v5.17.
> Its permission is 0444. It does not change until a reload of the KVM
> module.
>
> Read the kvm.enable_pmu value from the module sysfs to give a chance to
> provide more information about vPMU enablement.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v2:
>   - Rework the code flow following Zhao's suggestion.
>   - Return error when:
>     (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu)
> Changed since v3:
>   - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
>     suggestion.
>   - Rework the commit messages.
>   - Bring back global static variable 'kvm_pmu_disabled' from v2.
> Changed since v4:
>   - Add Reviewed-by from Zhao.
> Changed since v5:
>   - Rebase on top of most recent QEMU.
>
>  target/i386/kvm/kvm.c | 61 +++++++++++++++++++++++++++++++------------
>  1 file changed, 44 insertions(+), 17 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 824148688d..d191dd1da3 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -186,6 +186,10 @@ static int has_triple_fault_event;
>  static bool has_msr_mcg_ext_ctl;
>  
>  static int pmu_cap;
> +/*
> + * Read from /sys/module/kvm/parameters/enable_pmu.
> + */
> +static bool kvm_pmu_disabled;
>  
>  static struct kvm_cpuid2 *cpuid_cache;
>  static struct kvm_cpuid2 *hv_cpuid_cache;
> @@ -2050,23 +2054,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      if (first) {
>          first = false;
>  
> -        /*
> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
> -         * disable PMUs; however, QEMU has been providing PMU property per
> -         * CPU since v1.6. In order to accommodate both, have to configure
> -         * the VM-level capability here.
> -         *
> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
> -         * behavior on Intel platform because current "pmu" property works
> -         * as expected.
> -         */
> -        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> -                                    KVM_PMU_CAP_DISABLE);
> -            if (ret < 0) {
> -                error_setg_errno(errp, -ret,
> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
> -                return ret;
> +        if (X86_CPU(cpu)->enable_pmu) {
> +            if (kvm_pmu_disabled) {
> +                warn_report("Failed to enable PMU since "
> +                            "KVM's enable_pmu parameter is disabled");
> +            }
> +        } else {
> +            /*
> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
> +             * disable PMUs; however, QEMU has been providing PMU property per
> +             * CPU since v1.6. In order to accommodate both, have to configure
> +             * the VM-level capability here.
> +             *
> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
> +             * behavior on Intel platform because current "pmu" property works
> +             * as expected.
> +             */
> +            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                        KVM_PMU_CAP_DISABLE);
> +                if (ret < 0) {
> +                    error_setg_errno(errp, -ret,
> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
> +                    return ret;
> +                }
>              }
>          }
>      }
> @@ -3273,6 +3284,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      int ret;
>      struct utsname utsname;
>      Error *local_err = NULL;
> +    g_autofree char *kvm_enable_pmu;
>  
>      /*
>       * Initialize confidential guest (SEV/TDX) context, if required
> @@ -3409,6 +3421,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>      pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>  
> +    /*
> +     * The enable_pmu parameter is introduced since Linux v5.17,
> +     * give a chance to provide more information about vPMU
> +     * enablement.
> +     *
> +     * The kvm.enable_pmu's permission is 0444. It does not change
> +     * until a reload of the KVM module.
> +     */
> +    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
> +                            &kvm_enable_pmu, NULL, NULL)) {
> +        if (*kvm_enable_pmu == 'N') {
> +            kvm_pmu_disabled = true;
> +        }
> +    }
> +
>      return 0;
>  }
>  
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

