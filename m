Return-Path: <kvm+bounces-66061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A441CC1804
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 09:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 12764300D3C5
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 08:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CF0342509;
	Tue, 16 Dec 2025 08:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bTS2P2Km"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4182E342505
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872071; cv=none; b=YH2dgW7qDaI+SPzK/mwoaxZmjQktfS0uzlvIb4ynfAj9Q+E64E4X0gsPPRsD9emhxVbMn0CGz41/lXa+sLGGzF1KzNMYoNB6iKojoZtpV+fqYv8Qn4hntDrDvbjsesxVDyDMlWgYr/XN2T2AAWjC17DqPHqZ4gYNkhXVQddgspM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872071; c=relaxed/simple;
	bh=Ly+Ud2bhZKSB8OQ2caS0r8J18OBDXNWaCjHdBlKKK5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBuVtjyc8ovflPSod1oJVVTO5gYszl08Qm58bBLKlgXpVvwH/+sowCof0H8HcpKcmYxEtzGaeQ7psL9gnqJt0l+vwUZjrByW6tQlCk3q2SvZ1hNQeZL6Eh0xu7b1XIthnmncV2jjv265fRYdoRFkmz7c6MXuOoXMtYAzQ2NZUbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bTS2P2Km; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765872069; x=1797408069;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ly+Ud2bhZKSB8OQ2caS0r8J18OBDXNWaCjHdBlKKK5g=;
  b=bTS2P2KmnTOVedU+lvlKtRXVqdYqLjk76TCss1aCGy20kSyv4hEi9P/l
   Kx5krT1pxW2I9JD7LWkD+Fz8cNhUm19/gKn9zacCXVMV975swKWYh22q1
   l4OErxtcW6IFcegQ25oFSLQsgMm9uqVUIhWGYof9Ee3rVLEoSVVhCYdD/
   oEHsvyK5bCL3+Q6DhHt0vJWXDznf8TdbwWBLTsxWJ3jh/5x37Hk/OS8iJ
   ds+3WC+MK+Yk2GLiIdmNZ2fmZJ6hQ3n/Fr2EwTPlbKKT4hg11WmE74bX0
   OIerGEujVYxjLf3Z7sYiTokutIv+uiCCmCXe890NNpTOEixix+dmu1ULs
   A==;
X-CSE-ConnectionGUID: T6hbpR6eQh+E6iX5n19qiQ==
X-CSE-MsgGUID: Ny6zsfU6RlSkLv36P00o1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="71413802"
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="71413802"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 00:01:08 -0800
X-CSE-ConnectionGUID: hyFoc6uNT9qO7FWsvZGdyQ==
X-CSE-MsgGUID: 6oF8idddSeyPf7qt61RKHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,152,1763452800"; 
   d="scan'208";a="197845265"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 16 Dec 2025 00:01:04 -0800
Date: Tue, 16 Dec 2025 16:25:52 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
	khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
	den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com,
	ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
Subject: Re: [PATCH v7 0/9] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
 Cleanup
Message-ID: <aUEXkDDOba+oZ4v+@intel.com>
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111061532.36702-1-dongli.zhang@oracle.com>

On Mon, Nov 10, 2025 at 10:14:49PM -0800, Dongli Zhang wrote:
> Date: Mon, 10 Nov 2025 22:14:49 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v7 0/9] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
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
 
Hi Dongli,

Except for Patch 1 & 2 which need compatibility options (if you think
it's okay, I could help take these 2 and fix them when v11.0's compat
array is ready).

The other patches still LGTM. Maybe it's better to have a v8 excluding
patch 1 & 2?

Regards,
Zhao


