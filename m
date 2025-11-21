Return-Path: <kvm+bounces-64051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D60A3C772A6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 04:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id CF4D724194
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 03:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70411A9B46;
	Fri, 21 Nov 2025 03:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N8rHppXY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1624936D4EE
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 03:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763695966; cv=none; b=ZsdovI3IlnO62dQuzEtBoNG4goio8pUKEKef2ohwpi1IofQfydDcZJan+JbnYf3RDUsYAvidW+mVRAJrDYke8uLYQPFXWH5/fG2Q6MFHWBITsyNxqW5QwuGyUPnDiYMv+irBkSOsGBIpLOu+e6DwBnExGjcdzgc8gaDbrsIoN7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763695966; c=relaxed/simple;
	bh=i9kx5o4swsjYdmf1Hlv51bPGFRmUbFKBWsx0Va8pWjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qdr+H/oriKR/hRiJXRzfifulqCCHWGxCu26SOHGy9yz11XCQFutv41d3Lzba26NJm9QQluP/XoCYpcHsd1UAYqz59XUWZfkW1YHpTmbRuIf8fSr2RUhVmOC8nYeIyZPZNAeKMvhLaMeeoY4/FhwmS1mLJiTMaf8CrZ2JQozERbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N8rHppXY; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763695965; x=1795231965;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i9kx5o4swsjYdmf1Hlv51bPGFRmUbFKBWsx0Va8pWjM=;
  b=N8rHppXYHY+qfg/Mel8UIoACNdnDF5R/lBY7j3HDy/wFIBBv3TYeU7J6
   fT75Asg32Y4S4QcSMfDehPGsYGuhB8XLdf3QJpnkE7qjCjPzxSAltK4AC
   oeM4OKGZ8dpBWLVjK9Zm93b5idmUXsMK1CTcgljGjw8N0nbJz4qbThnb4
   MjgWkj5juLiziTHxPuRzdikUh2UaD3Yo27C4xmLQ2/f4SglIlU/ypYnAJ
   HjG6twQbCxf+lDZJ4D+vLSg0W6NJiROFVgz0DVviFnjDqrNgNZFnybwi4
   vPO95gKgTR8/3IV1GyLAw9pGudUTruuqeAi/nljDrb3cJSbCeluo6r7QU
   w==;
X-CSE-ConnectionGUID: hGlJ5LakRo+FwhrZ7T2qjg==
X-CSE-MsgGUID: nB5Cp41lT5mHOkWfzIbnRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="69641366"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="69641366"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 19:32:44 -0800
X-CSE-ConnectionGUID: ryxBJXD2QCSrfhNJjHmN6Q==
X-CSE-MsgGUID: uPD6aSI+QgegLBmKVk8IuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="222507624"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.213]) ([10.124.240.213])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 19:32:42 -0800
Message-ID: <7f7f97c6-8cf2-42fe-a7be-5d7810a2c9d7@linux.intel.com>
Date: Fri, 21 Nov 2025 11:32:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 0/8] x86/pmu: Fix test errors on
 GNR/SRF/CWF
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Yi Lai <yi1.lai@intel.com>
References: <20251120233149.143657-1-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Test this patch-set on SPR/SRF/CWF for both legacy vPMU and mediated vPMU,
no issue is found. Thanks.


On 11/21/2025 7:31 AM, Sean Christopherson wrote:
> Refreshed version of Dapeng's series to address minor flaws in v3.
>
> This patchset fixes the pmu test errors on Granite Rapids (GNR), Sierra
> Forest (SRF) and Clearwater Forest (CWF).
>
> GNR and SRF start to support the timed PEBS. Timed PEBS adds a new
> "retired latency" field in basic info group to show the timing info and
> the PERF_CAPABILITIES[17] called "PEBS_TIMING_INFO" bit is added
> to indicated whether timed PEBS is supported. KVM module doesn't need to
> do any specific change to support timed PEBS except a perf change adding
> PERF_CAP_PEBS_TIMING_INFO flag into PERF_CAP_PEBS_MASK[1]. The patch 7/7
> supports timed PEBS validation in pmu_pebs test.
>
> On Intel Atom platforms, the PMU events "Instruction Retired" or
> "Branch Instruction Retired" may be overcounted for some certain
> instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
> and complex SGX/SMX/CSTATE instructions/flows[2].
>
> In details, for the Atom platforms before Sierra Forest (including
> Sierra Forest), Both 2 events "Instruction Retired" and
> "Branch Instruction Retired" would be overcounted on these certain
> instructions, but for Clearwater Forest only "Instruction Retired" event
> is overcounted on these instructions.
>
> As the overcount issue, pmu test would fail to validate the precise
> count for these 2 events on SRF and CWF. Patches 1-4/7 detects if the
> platform has this overcount issue, if so relax the precise count
> validation for these 2 events.
>
> Besides it looks more LLC references are needed on SRF/CWF, so adjust
> the "LLC references" event count range.
>
> Tests:
>   * pmu tests passed on SPR/GNR/SRF/CWF.
>   * pmu_lbr tests is skiped on SPR/GNR/SRF/CWF since mediated vPMU based
>     arch-LBR support is not upstreamed yet.
>   * pmu_pebs test passed on SPR/GNR/SRF and skiped on CWF since CWF
>     introduces architectural PEBS and mediated vPMU based arch-PEBS
>     support is not upstreamed yet.
>
> v4:
>  - Track the errata in pmu_caps so that the information is available to all
>    tests (even though non-PMU tests are unlikely to care).
>  - Keep the measure_for_overflow() call for fixed counters.
>  - Handle errata independently for precise checks.
>
> v3:
>  - https://lore.kernel.org/all/20250903064601.32131-1-dapeng1.mi@linux.intel.com
>  - Fix the emulated instruction validation error on SRF/CWF. (Patch 5/8)
>
> v2:
>  - Fix the flaws on x86_model() helper (Xiaoyao).
>  - Fix the pmu_pebs error on GNR/SRF.
>
> Dapeng Mi (3):
>   x86/pmu: Relax precise count check for emulated instructions tests
>   x86: pmu_pebs: Remove abundant data_cfg_match calculation
>   x86: pmu_pebs: Support to validate timed PEBS record on GNR/SRF
>
> dongsheng (5):
>   x86/pmu: Add helper to detect Intel overcount issues
>   x86/pmu: Relax precise count validation for Intel overcounted
>     platforms
>   x86/pmu: Fix incorrect masking of fixed counters
>   x86/pmu: Handle instruction overcount issue in overflow test
>   x86/pmu: Expand "llc references" upper limit for broader compatibility
>
>  lib/x86/pmu.c       | 39 ++++++++++++++++++++++++
>  lib/x86/pmu.h       | 11 +++++++
>  lib/x86/processor.h | 26 ++++++++++++++++
>  x86/pmu.c           | 72 ++++++++++++++++++++++++++++++---------------
>  x86/pmu_pebs.c      |  9 +++---
>  5 files changed, 129 insertions(+), 28 deletions(-)
>
>
> base-commit: de952a4bf26cb2e93c634445034645523f65d28b

