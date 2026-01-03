Return-Path: <kvm+bounces-66961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 83364CEF8BD
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 01:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3892A3019BF7
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 00:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D0C223DD6;
	Sat,  3 Jan 2026 00:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/hpxgKG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B251E9B37
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 00:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767400044; cv=none; b=m1j1Q9nPZn+33zGdYXvGhS8GgsuGovIXTtdcWDpubSuMSuCAjzWHo/FDIdf4sCANwqXlQGgF58kczVc4ODLJCJtZU+AQmadb1VVC8YlZAo6pSDX0FYgxfhjw6jM+C846SV3neSpOOrGL2kaHEsAarVJBlwtHvURL6ODh1aJ8bA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767400044; c=relaxed/simple;
	bh=IAttkKUPdKV3jr6OHhRsvukqZBqhsMR4lNcX9qeUMRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t5YDLtW/LueyAiJoGPpvYCC9oFUqekvEUjpGv5bFqbt6ZpW4o8/6c8c06cTOkt27m4/jZQ+CK47p2ERVQJKzYiLZkhjSb8JuuhYM3vmCuIJQ4pXZxaNTQjS3473J9lkyMxzUJqVXSacwfX9qZm83mXRVTPFSlpKlE+CBLo7oqXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/hpxgKG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767400043; x=1798936043;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IAttkKUPdKV3jr6OHhRsvukqZBqhsMR4lNcX9qeUMRE=;
  b=D/hpxgKGj2t/Da8TSP7Xy/XZ4rCE1p/BSFtaFLFvwMbvuSRw2c2IEhBY
   9ZTJf784hRTFLvzEw5xeRhFMNzZWj/rOMD9Xt49XWHe+U9pLlqSXHuquF
   FcsaiRkJ5s0ZNCXXJ1qxRCixbeL440/FS/ip+7M8VXXZTP6GP/Wx/G+R2
   fd1A4cxz0nKQQommwVgC6ega7IipugowgdLcDfunVW2myxurI9wNePg0Y
   n+DlZzCsUOiRYCPwU8IsP89ZIlx8pwdOb/XChc7bK5tp7QxJFP4tKm/XN
   jbPd95xI21XWXyj0bEbQ6rRX1FkJlr8b/rxJCUIXDsl6w/NydEF8nH5QP
   g==;
X-CSE-ConnectionGUID: VO5aI8DwRhqZDjhnk0vMYA==
X-CSE-MsgGUID: rh18NoGvTEKg2IzJMnZvMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="91535742"
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="91535742"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 16:27:22 -0800
X-CSE-ConnectionGUID: vCR2KWO/StmyDAmprPanQQ==
X-CSE-MsgGUID: dHMzlpObSQWoeWYUhFs9EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="225411362"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.241.240.111]) ([10.241.240.111])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 16:27:21 -0800
Message-ID: <de20e04a-bfeb-4737-9e30-15d117e796e8@intel.com>
Date: Fri, 2 Jan 2026 16:27:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] target/i386/kvm: don't stop Intel PMU counters
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-8-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20251230074354.88958-8-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/29/2025 11:42 PM, Dongli Zhang wrote:
> PMU MSRs are set by QEMU only at levels >= KVM_PUT_RESET_STATE,
> excluding runtime. Therefore, updating these MSRs without stopping events
> should be acceptable.

It seems preferable to keep the existing logic. The sequence of
disabling -> setting new counters -> re-enabling is complete and
reasonable. Re-enabling the PMU implicitly tell KVM to do whatever
actions are needed to make the new counters take effect.

If the purpose of this patch to improve performance, given that this is
a non-critical path, trading this clear and robust logic for a minor
performance gain does not seem necessary.


> In addition, KVM creates kernel perf events with host mode excluded
> (exclude_host = 1). While the events remain active, they don't increment
> the counter during QEMU vCPU userspace mode.
> 
> Finally, The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM
> processes these MSRs one by one in a loop, only saving the config and
> triggering the KVM_REQ_PMU request. This approach does not immediately stop
> the event before updating PMC. This approach is true since Linux kernel
> commit 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to
> kvm_pmu_handle_event"), that is, v6.2.

This seems to assume KVM's internal behavior. While that is true today
(and possibly in the future), it’s not necessary for QEMU to  make such
assumptions, as that could unnecessarily limit KVM’s flexibility to
change its behavior later.


> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
> migrate vPMU state"), because this isn't a bugfix.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
> Changed since v3:
>   - Re-order reasons in commit messages.
>   - Mention KVM's commit 68fb4757e867 (v6.2).
>   - Keep Zhao's review as there isn't code change.
> Changed since v6:
>   - Add Reviewed-by from Dapeng Mi.
> 
>  target/i386/kvm/kvm.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 99837048b8..742dc6ac0d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4222,13 +4222,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>          }
>  
>          if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
> -            if (pmu_version > 1) {
> -                /* Stop the counter.  */
> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> -            }
> -
> -            /* Set the counter values.  */
>              for (i = 0; i < num_pmu_fixed_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>                                    env->msr_fixed_counters[i]);
> @@ -4244,8 +4237,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                                    env->msr_global_status);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>                                    env->msr_global_ovf_ctrl);
> -
> -                /* Now start the PMU.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
>                                    env->msr_fixed_ctr_ctrl);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,


