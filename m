Return-Path: <kvm+bounces-48735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A779FAD1CD4
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 14:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59D44161BA0
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 12:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF22255F3B;
	Mon,  9 Jun 2025 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HL4QX6WU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0DF1E766F
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 12:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749470729; cv=none; b=j6UYadh+jHWFU5uvF4ZB0I/FR714AQmuFt3cNXhbo/1H2rGd4bQHQrbu0+9O+gjxkz5JikVC2F/7tsnQj0Wu+6Do+mU1wZXKSgbsumNrEVy8kFQQXly1S5S8+iZ438Rah3fhs7G7q+z27XE7/pSZ5C9YCvISD1L8oNLQX5BfXIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749470729; c=relaxed/simple;
	bh=Ot80FdygVaU40feRZ301n0PWrVBN6sbOj4IHwArYDLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwJsNBH7vQmiYCSu+xohncdw9rG9mHAvZmW3mYQQxiNN9+D5EA0UgmdslNSg8FnmocgD9wHqrCOOkbTuZGwm6SVMFGkC/Vh0O19VuXHiFc3bvyEB51mccNx6SaPtxzQlotxYy0jTodU5gdsqeH27KHASxQEln/+JK20WYOS7HTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HL4QX6WU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749470727; x=1781006727;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ot80FdygVaU40feRZ301n0PWrVBN6sbOj4IHwArYDLM=;
  b=HL4QX6WUNTVhb4nVlWU175ITEJjlKJQ2k2gv3V6LDxwEMzELjzQw9CZt
   YW0wZKuEHehC08QH93m8r32AfAVGOd37IZWUcQ/u31Fk393mFq2tGbhK3
   Zee1SP3GLtdeHbtEgtXMb5hNN3pZ2Jj6D8gdwt4fvEagrZYujILlnFI2h
   zHWps+Q2BBUNNC1bZ/Tsa/qmHFMxq2n5aC0/w/e/d0HkHrSVaCJGPVV1I
   tUmHr7FXt/Bj8uQbDY7SShe0ssEbPdHTI753AnCFIpHR1VD2/RqWEk/Yq
   9zWbP8Z2zyCV/YagxxI0CDKrKtiNlYDuyQzR93sfsPRf7tdwBzNXdagUo
   Q==;
X-CSE-ConnectionGUID: ZUn9naZcQqix/kBqMXOu/w==
X-CSE-MsgGUID: kP2K3lgNSCCTmR80ga4TFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="55207665"
X-IronPort-AV: E=Sophos;i="6.16,222,1744095600"; 
   d="scan'208";a="55207665"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 05:05:27 -0700
X-CSE-ConnectionGUID: neqNMhuqTByEfy8638EDwQ==
X-CSE-MsgGUID: Gb/B1zMdQ6GGp9Vb048ccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,222,1744095600"; 
   d="scan'208";a="169667573"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 09 Jun 2025 05:05:16 -0700
Date: Mon, 9 Jun 2025 20:26:31 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
	babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
	groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	peter.maydell@linaro.org, gaosong@loongson.cn,
	chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
	jiaxun.yang@flygoat.com, arikalo@gmail.com, npiggin@gmail.com,
	danielhb413@gmail.com, palmer@dabbelt.com, alistair.francis@wdc.com,
	liwei1518@gmail.com, zhiwei_liu@linux.alibaba.com,
	pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	thuth@redhat.com, flavra@baylibre.com, ewanhai-oc@zhaoxin.com,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
	liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
	kraxel@redhat.com, berrange@redhat.com
Subject: Re: [PATCH v5 00/10] target/i386/kvm/pmu: PMU Enhancement, Bugfix
 and Cleanup
Message-ID: <aEbS93r7YRcIadj0@intel.com>
References: <20250425213037.8137-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425213037.8137-1-dongli.zhang@oracle.com>

Hi Dongli,

Since the patch 3 was merged. I think you can rebase this series.

Thanks,
Zhao

On Fri, Apr 25, 2025 at 02:29:57PM -0700, Dongli Zhang wrote:
> Date: Fri, 25 Apr 2025 14:29:57 -0700
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v5 00/10] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
>  Cleanup
> X-Mailer: git-send-email 2.43.5
> 
> This patchset addresses four bugs related to AMD PMU virtualization.
> 
> 1. The PerfMonV2 is still available if PERCORE if disabled via
> "-cpu host,-perfctr-core".
> 
> 2. The VM 'cpuid' command still returns PERFCORE although "-pmu" is
> configured.
> 
> 3. The third issue is that using "-cpu host,-pmu" does not disable AMD PMU
> virtualization. When using "-cpu EPYC" or "-cpu host,-pmu", AMD PMU
> virtualization remains enabled. On the VM's Linux side, you might still
> see:
> 
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
> 
> instead of:
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
> when "-pmu" is configured.
> 
> 4. The fourth issue is that unreclaimed performance events (after a QEMU
> system_reset) in KVM may cause random, unwanted, or unknown NMIs to be
> injected into the VM.
> 
> The AMD PMU registers are not reset during QEMU system_reset.
> 
> (1) If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> (2) Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> (3) The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> (4) After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> (5) In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process
> 
> 
> Changed since v1:
>   - Use feature_dependencies for CPUID_EXT3_PERFCORE and
>     CPUID_8000_0022_EAX_PERFMON_V2.
>   - Remove CPUID_EXT3_PERFCORE when !cpu->enable_pmu.
>   - Pick kvm_arch_pre_create_vcpu() patch from Xiaoyao Li.
>   - Use "-pmu" but not a global "pmu-cap-disabled" for KVM_PMU_CAP_DISABLE.
>   - Also use sysfs kvm.enable_pmu=N to determine if PMU is supported.
>   - Some changes to PMU register limit calculation.
> Changed since v2:
>   - Change has_pmu_cap to pmu_cap.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Rework the code flow of PATCH 07 related to kvm.enable_pmu=N following
>     Zhao's suggestion.
>   - Use object_property_get_int() to get CPU family.
>   - Add support to Zhaoxin.
> Changed since v3:
>   - Re-base on top of Zhao's queued patch.
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Pick new version of kvm_arch_pre_create_vcpu() patch from Xiaoyao.
>   - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
>     suggestion.
>   - Check AMD directly makes the "compat" rule clear.
>   - Some changes on commit message and comment.
>   - Bring back global static variable 'kvm_pmu_disabled' read from
>     /sys/module/kvm/parameters/enable_pmu.
> Changed since v4:
>   - Re-base on top of most recent mainline QEMU.
>   - Add more Reviewed-by.
>   - All patches are reviewed.
> 
> 
> Xiaoyao Li (1):
>   kvm: Introduce kvm_arch_pre_create_vcpu()
> 
> Dongli Zhang (9):
>   target/i386: disable PerfMonV2 when PERFCORE unavailable
>   target/i386: disable PERFCORE when "-pmu" is configured
>   target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
>   target/i386/kvm: extract unrelated code out of kvm_x86_build_cpuid()
>   target/i386/kvm: rename architectural PMU variables
>   target/i386/kvm: query kvm.enable_pmu parameter
>   target/i386/kvm: reset AMD PMU registers during VM reset
>   target/i386/kvm: support perfmon-v2 for reset
>   target/i386/kvm: don't stop Intel PMU counters
> 
>  accel/kvm/kvm-all.c        |   5 +
>  include/system/kvm.h       |   1 +
>  target/arm/kvm.c           |   5 +
>  target/i386/cpu.c          |   8 +
>  target/i386/cpu.h          |  16 ++
>  target/i386/kvm/kvm.c      | 360 ++++++++++++++++++++++++++++++++++------
>  target/loongarch/kvm/kvm.c |   4 +
>  target/mips/kvm.c          |   5 +
>  target/ppc/kvm.c           |   5 +
>  target/riscv/kvm/kvm-cpu.c |   5 +
>  target/s390x/kvm/kvm.c     |   5 +
>  11 files changed, 372 insertions(+), 47 deletions(-)
> 
> base-commit: 019fbfa4bcd2d3a835c241295e22ab2b5b56129b
> 
> Thank you very much!
> 
> Dongli Zhang
> 

