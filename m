Return-Path: <kvm+bounces-68461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4305DD39D98
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED12D3008EA3
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 05:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61831285C8D;
	Mon, 19 Jan 2026 05:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E78/5IqE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765F42836E
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 05:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768799308; cv=none; b=aMHv9KnHs2HfzyJF7yjbniTF26Hd/tutFnAClbJuZD9JzTsj4EZZE67Bu1gaH1016OclZAWQmZOkKS8SjFz7G3AQxF2IBxPmYacg45qqR/otkebLJ4pCZop6Ta5thvdSetVIUuNwc2stuS7X2JDXd57DglZwrJQDO890rUiuRjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768799308; c=relaxed/simple;
	bh=nLwTrY9kl6J1cUA3P/OV/Bk7pXQW0CRc9S0pVw4lGtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boYam4/7xqyC+azEcE4GOymVEFVKpAEAz0LYodF55npWHdB38bONksdmoym4BuCIzwKoDs/cZHKbvV3efRqr3+R9uBzOGMFVGLkO7r8hhGXpppwhbOwn6nHmFqGgWnW3slgRiY1y8LAP8sysPA0UgWX5aOIqOYwmyuRmIqk6ON8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E78/5IqE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768799306; x=1800335306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nLwTrY9kl6J1cUA3P/OV/Bk7pXQW0CRc9S0pVw4lGtM=;
  b=E78/5IqEDxNTYG+yWSH0Y2pBZLmfrBVJPMWrfl2DWM7biENlRkqlUwZu
   a3fL6lJVEnJKRDeLfj/wc1BY6HikS5uBRDWU4kH2ymarVet8XNKbPmjsz
   jmiGRqJQ17hXBNwnaGNyM8FFQ8TPLtQoIgORqzFvdtxI2du4iCrIlk6mB
   V83454lo4IynPplhNdI/U07KWIHhJYWIb2aVwhG0KGZ3W8BtSw0vRs2SL
   4/avOLZ8tTjXBb43ImuUHPij6k8AOd4Y1fzcDQPmLwXPXSY2+U/qIBluc
   DW3LwzD7bcDBCdo9MAd8E2tcuQtKT/KgU37Ako1Bh6Cvi4K0mWsD/KFNn
   w==;
X-CSE-ConnectionGUID: nDQ4ckNLSOaaNrHAJ1t8jA==
X-CSE-MsgGUID: Hk54OSoWSzqXgzZlJDWp7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69207407"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69207407"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 21:08:26 -0800
X-CSE-ConnectionGUID: B7cEtOlzSgWNWOXkrxB2ww==
X-CSE-MsgGUID: lr3SEjnqTiGBV+MDr9H41w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="228704859"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 18 Jan 2026 21:08:21 -0800
Date: Mon, 19 Jan 2026 13:33:52 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com, zide.chen@intel.com
Subject: Re: [PATCH v9 4/5] target/i386/kvm: reset AMD PMU registers during
 VM reset
Message-ID: <aW3CQIHgv5nP85gd@intel.com>
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
 <20260109075508.113097-5-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109075508.113097-5-dongli.zhang@oracle.com>

On Thu, Jan 08, 2026 at 11:53:59PM -0800, Dongli Zhang wrote:
> Date: Thu,  8 Jan 2026 23:53:59 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v9 4/5] target/i386/kvm: reset AMD PMU registers during VM
>  reset
> X-Mailer: git-send-email 2.43.5
> 
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
> 
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
> 
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> 4. After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
> Changed since v2:
>   - Remove 'static' from host_cpuid_vendorX.
>   - Change has_pmu_version to pmu_version.
>   - Use object_property_get_int() to get CPU family.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Send error log when host and guest are from different vendors.
>   - Move "if (!cpu->enable_pmu)" to begin of function. Add comments to
>     reminder developers.
>   - Add support to Zhaoxin. Change is_same_vendor() to
>     is_host_compat_vendor().
>   - Didn't add Reviewed-by from Sandipan because the change isn't minor.
> Changed since v3:
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Check AMD directly makes the "compat" rule clear.
>   - Add comment to MAX_GP_COUNTERS.
>   - Skip PMU info initialization if !kvm_pmu_disabled.
> Changed since v4:
>   - Add Reviewed-by from Zhao and Sandipan.
> Changed since v6:
>   - Add Reviewed-by from Dapeng Mi.
> Changed since v8:
>   - Remove the usage of 'kvm_pmu_disabled' as sussged by Zide Chen.
>   - Remove Reviewed-by from Zhao Liu, Sandipan Das and Dapeng Mi, as the
>     usage of 'kvm_pmu_disabled' is removed.
> 
>  target/i386/cpu.h     |  12 +++
>  target/i386/kvm/kvm.c | 168 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 176 insertions(+), 4 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


