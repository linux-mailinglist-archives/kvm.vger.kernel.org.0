Return-Path: <kvm+bounces-54094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C8CB1C1E3
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 10:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BD5D186573
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F8222173F;
	Wed,  6 Aug 2025 08:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZs67FFi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D7220F3F;
	Wed,  6 Aug 2025 08:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754467911; cv=none; b=fF+UW+T72eKFWcl2O05CF02JO1x1Hvs9J00Zbiz1QJg2PIP9vcziH09Ko8ZIkhVEYIDnRTazaqr7K2Zi3j5cz6V1EIqJudLCMN+cmMZE26CzEe1FfA5pPrOml/IY+ekdCnvxjKf2iAcH39N5AhDYQdh3Tna1csuLUosgrN8uE/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754467911; c=relaxed/simple;
	bh=Y4O80rSSas60qvJ+XjKjIgVtJrI7oZDBYw1AZHMpnTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pO87MndkqSXP/skQY7qFLZ/er6ijoViu0X8klSsmL/v31EPpmeNJGbPkdhX+nuf8LTBLAAqbpNV9W2VrM9BScX34Tfn9HpHwqyMk/ZgYNlxwIw/JEkPmQ4FzWXjoh4hZ81yWmZrlQWvjQALeknC3BRCkqDbNsdO9FI/FPOBVjIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KZs67FFi; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754467909; x=1786003909;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y4O80rSSas60qvJ+XjKjIgVtJrI7oZDBYw1AZHMpnTc=;
  b=KZs67FFif4g47WjSHxBW+inyk3BrYmSe5BueW1b/jfqtNZXkj2/k6sz7
   a2GejPhyEtClWcM/is9Xql52ejau9R2G7JozS4U+NuepuWkkOo6bo6AFa
   S6wzVD5lMs4D2RAIuYKpX2usgAzIcyvjAwBtXXbO5O/EgL/xU0oerT4CE
   yfj1Ecpa1KNrmOf7BJilEXd98/2NMas1c6ykx+BfaZSkEQ9cq9p9lOmuf
   dXEY7kym1pf/gWHjGOzpoahalHSbi774w8BHqUZ2LGuOiI9aNmeTOGh82
   qnh0fJl8INqeX5DYornqamCHYudPum2lmf0d86SwpGRPNrmb1CZtt9Ihl
   A==;
X-CSE-ConnectionGUID: VMt/66sfQvmThV1YpyUA+A==
X-CSE-MsgGUID: ppFQaeHoTrGmcYNIQW1SnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56853231"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56853231"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:11:31 -0700
X-CSE-ConnectionGUID: hDevkkrcTeKc3/bKsyXNsw==
X-CSE-MsgGUID: ss0bFaQkT1SHyGzqDIBGsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="169167697"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.106]) ([10.124.240.106])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:11:29 -0700
Message-ID: <c516f0e7-4e34-411a-824e-54e8c2dbae5e@linux.intel.com>
Date: Wed, 6 Aug 2025 16:11:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] KVM: x86: Fastpath cleanups and PMU prep work
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
References: <20250805190526.1453366-1-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> This is a prep series for the mediated PMU, and for Xin's series to add
> support for the immediate forms of RDMSR and WRMSRNS (I'll post a v3 of
> that series on top of this).
>
> The first half cleans up a variety of warts and flaws in the VM-Exit fastpath
> handlers.  The second half cleans up the PMU code related to "triggering"
> instruction retired and branches retired events.  The end goal of the two
> halves (other than general cleanup) is to be able bail from the fastpath when
> using the mediated PMU and the guest is counting instructions retired, with
> minimal overhead, e.g. without having to acquire SRCU.
>
> Because the mediated PMU context switches PMU state _outside_ of the fastpath,
> the mediated PMU won't be able to increment PMCs in the fastpath, and so won't
> be able to skip emulated instructions in the fastpath if the vCPU is counting
> instructions retired.
>
> The last patch to handle INVD in the fastpath is a bit dubious.  It works just
> fine, but it's dangerously close to "just because we can, doesn't mean we
> should" territory.  I added INVD to the fastpath before I realized that
> MSR_IA32_TSC_DEADLINE could be handled in the fastpath irrespective of the
> VMX preemption timer, i.e. on AMD CPUs.  But being able to use INVD to test
> the fastpath is still super convenient, as there are no side effects (unless
> someone ran the test on bare metal :-D), no register constraints, and no
> vCPU model requirements.  So, I kept it, because I couldn't come up with a
> good reason not to.
>
> Sean Christopherson (18):
>   KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
>   KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
>   KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
>   KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
>   KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath
>     exits
>   KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be
>     skipped
>   KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
>   KVM: x86: Fold WRMSR fastpath helpers into the main handler
>   KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
>   KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
>   KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
>   KVM: x86/pmu: Rename pmc_speculative_in_use() to
>     pmc_is_locally_enabled()
>   KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
>   KVM: x86/pmu: Drop redundant check on PMC being globally enabled for
>     emulation
>   KVM: x86/pmu: Drop redundant check on PMC being locally enabled for
>     emulation
>   KVM: x86/pmu: Rename check_pmu_event_filter() to
>     pmc_is_event_allowed()
>   KVM: x86: Push acquisition of SRCU in fastpath into
>     kvm_pmu_trigger_event()
>   KVM: x86: Add a fastpath handler for INVD
>
>  arch/x86/include/asm/kvm_host.h |   3 +
>  arch/x86/kvm/lapic.c            |  59 ++++++++----
>  arch/x86/kvm/lapic.h            |   3 +-
>  arch/x86/kvm/pmu.c              | 155 +++++++++++++++++++++++++-------
>  arch/x86/kvm/pmu.h              |  60 ++-----------
>  arch/x86/kvm/svm/svm.c          |  14 ++-
>  arch/x86/kvm/vmx/nested.c       |   2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   2 +
>  arch/x86/kvm/x86.c              |  85 +++++-------------
>  arch/x86/kvm/x86.h              |   1 +
>  11 files changed, 218 insertions(+), 168 deletions(-)
>
>
> base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030

Run PMU kselftests
(pmu_counters_test/pmu_event_filter_test/vmx_pmu_caps_test) on Sapphire
Rapids, no issue is found. Thanks.



