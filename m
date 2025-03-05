Return-Path: <kvm+bounces-40141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0450FA4F80F
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B7053A9FB0
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAF11F3D30;
	Wed,  5 Mar 2025 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KmFUW7Z7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895C81EEA33
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 07:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741160452; cv=none; b=mMrSvLS568+IyfUxjxh3EM/t9d9ws+Svp6CaWi9qGnIIOG9XOW++FDccjcjwNtAsHGFBUduAE0KAyXPbegx+TEa/IEeYb9+iG+elJHzvnLhmaIoZbc6I2JEWWkB1B29YsVIjzB1x0rgajNTpgEb5YGQavbh6ly4mwx4LWW44jBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741160452; c=relaxed/simple;
	bh=tQn0UJdEVPQPAmtED9qfjKDrEArx0CGf8L8FI8pp5fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TywjAwxeSFXhMgd84XVubIsLy8DJIh2cAe8T2Ub8L4lBiiW+AeuFlotIBqQykCJodjHodNHcz/VG8uqWlNQ79gU/LoMKVY0uxM0UNIWEbFrhIwP8mKhZlsNpd8b9NKKmEr2AnXMeZ5pOIIyUCTzVY9tFctajhpC1chKMq4WxYqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KmFUW7Z7; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741160451; x=1772696451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tQn0UJdEVPQPAmtED9qfjKDrEArx0CGf8L8FI8pp5fQ=;
  b=KmFUW7Z7FHbkukLyPcumXS1gs6EKD4qk+yvvBYh5fLacbnolNOgPmdLp
   Kdi7qmtj/sX/h15Xy2K90B3jt0kX4IRPqVcKjw5XbC7UxC5k52LVFRMgW
   ZNEyrQc8CE0pR25uKjHTATZKDM4reKzMlXssxU0XvjuBATWhbh6IK3U+Z
   DX7Ex9OB6Jeaa4bU45+hnFK6TcC5tjgpIOvT8Sf0juyP0xmZp3nT6Qh2J
   YwI68Wmtg+PDUQCcYyaFWqmYwCQG3THIfN8LnmafX20wGnXdowKYD8un+
   5dk36AHaRfubCWrb2ysPupuEA/MLAfLoX0gDxza91EWMh6MdUNwxv5iK/
   A==;
X-CSE-ConnectionGUID: 3fnPYir/QP+XP7clVY9jvA==
X-CSE-MsgGUID: nOqce3hZRQiPK6Hd9dyrow==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="45882615"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="45882615"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:35:11 -0800
X-CSE-ConnectionGUID: IiraRj1GR8q/NJTCULxwwA==
X-CSE-MsgGUID: SXYI5W78S2yQVy+/8PczZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="122753370"
Received: from unknown (HELO [10.238.2.135]) ([10.238.2.135])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 23:35:06 -0800
Message-ID: <5f76ce8f-5f69-4a95-8c27-011a7d713fc3@linux.intel.com>
Date: Wed, 5 Mar 2025 15:35:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] target/i386/kvm: don't stop Intel PMU counters
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-11-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250302220112.17653-11-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/3/2025 6:00 AM, Dongli Zhang wrote:
> The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM processes
> these MSRs one by one in a loop, only saving the config and triggering the
> KVM_REQ_PMU request. This approach does not immediately stop the event
> before updating PMC.
>
> In additional, PMU MSRs are set only at levels >= KVM_PUT_RESET_STATE,
> excluding runtime. Therefore, updating these MSRs without stopping events
> should be acceptable.

Suppose this works for upcoming mediated vPMU as well? If so, please
mention it here. Thanks.


>
> Finally, KVM creates kernel perf events with host mode excluded
> (exclude_host = 1). While the events remain active, they don't increment
> the counter during QEMU vCPU userspace mode.
>
> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
> migrate vPMU state"), because this isn't a bugfix.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  target/i386/kvm/kvm.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index c5911baef0..4902694129 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4160,13 +4160,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>          }
>  
>          if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
> -            if (has_pmu_version > 1) {
> -                /* Stop the counter.  */
> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> -            }
> -
> -            /* Set the counter values.  */
>              for (i = 0; i < num_pmu_fixed_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>                                    env->msr_fixed_counters[i]);
> @@ -4182,8 +4175,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                    env->msr_global_status);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>                                    env->msr_global_ovf_ctrl);
> -
> -                /* Now start the PMU.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
>                                    env->msr_fixed_ctr_ctrl);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,

