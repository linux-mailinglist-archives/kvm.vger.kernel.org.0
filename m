Return-Path: <kvm+bounces-60114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 797A0BE1119
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 02:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED05E19C1EA5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 00:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B03C7464;
	Thu, 16 Oct 2025 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYHa8a4h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317E125B2;
	Thu, 16 Oct 2025 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760573079; cv=none; b=kpyOT06pIxHgADwmU/S56GtP+6HMk5nhccXUcOoHEFux8Y9WcDs5xwfxWcXb7V+ya0Dw31ZEYYnyRWum8BE/+kX3U5LG8RO9hP7gspXlEzPJmh86x4XitATJByt6vpWvvEPCN76eq51NwM9kxpFmNeSYa4YKFZlI9I+dsCDmMoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760573079; c=relaxed/simple;
	bh=+JrivgWyUgg+pmx0+52mYBdTXkR4tEzcKUO0ehqXf7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ll0WhjdSOOIWRbyi+NR15letG9q3wO+fSVd21aodkzUkzYf5lRRNnjz0nJ5xoQVyIOf6nkyU7SDcuYq9sAxmWgswMfUVVNRySqpw6vf8dBIEIEUnqY009jclmTiNzgJSjirMknXhMlBIdCqGS1G5nH9vuNMeRLFbLEgLTdpsfEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eYHa8a4h; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760573077; x=1792109077;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+JrivgWyUgg+pmx0+52mYBdTXkR4tEzcKUO0ehqXf7s=;
  b=eYHa8a4htV2IfciglOX1GGDkSh5aNpu6St+uGz1QietzV5WXdnoVaIUS
   Bgls4I8moOFTABQbdwfBVcFROJzoW7rrRVzw89Dga6MwVjYh7LNRgD6V5
   2OeW0H5kJP8NyeSbMT6k2B2hl5fe1gR2tX4tCl6fvaY9yskk7Bj+UNCHB
   LseQtlIMMwB6zJel08KclgnLqAO7JYykuJFxwWznXdccLSHhdYMx2Gsec
   XFBIZPVTJ29bZ5Jpyl724QLErwYaBlM1K3V3QID0fVsfcn7MJSVI6sZ7T
   yOsQDd7w/wNHaJAG0mPaiGDIMHquzrtcYIKPRp35aTW5TT7Pf3ESu9ATt
   g==;
X-CSE-ConnectionGUID: OXGn3SAXRJ6Oib8I33VlHw==
X-CSE-MsgGUID: kInTMiSGREObQR01YggpgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="85377181"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="85377181"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 17:04:36 -0700
X-CSE-ConnectionGUID: R752COMtRQqyVd5oHvt9WQ==
X-CSE-MsgGUID: 3PO6qZFiQTmjq3l7JbpGAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="182097810"
Received: from unknown (HELO [10.238.2.75]) ([10.238.2.75])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 17:04:29 -0700
Message-ID: <ea123839-80fd-4555-8da2-adbd060a2082@linux.intel.com>
Date: Thu, 16 Oct 2025 08:04:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
To: Sean Christopherson <seanjc@google.com>
Cc: Sandipan Das <sandidas@amd.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-33-seanjc@google.com>
 <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com> <aN1vfykNs8Dmv_g0@google.com>
 <0276af52-c697-46c3-9db8-9284adb6beee@linux.intel.com>
 <aO_slNn8X1A84sI-@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aO_slNn8X1A84sI-@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 10/16/2025 2:48 AM, Sean Christopherson wrote:
> On Thu, Oct 09, 2025, Dapeng Mi wrote:
>> On 10/2/2025 2:14 AM, Sean Christopherson wrote:
>>> On Fri, Sep 26, 2025, Sandipan Das wrote:
>>>> On 8/7/2025 1:26 AM, Sean Christopherson wrote:
>>>>> +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
>>>>>  	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
>>>>>  	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
>>>>>  }
>>>> There is a case for AMD processors where the global MSRs are absent in the guest
>>>> but the guest still uses the same number of counters as what is advertised by the
>>>> host capabilities. So RDPMC interception is not necessary for all cases where
>>>> global control is unavailable.o
>>> Hmm, I think Intel would be the same?  Ah, no, because the host will have fixed
>>> counters, but the guest will not.  However, that's not directly related to
>>> kvm_pmu_has_perf_global_ctrl(), so I think this would be correct?
>>>
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>> index 4414d070c4f9..4c5b2712ee4c 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -744,16 +744,13 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>>         return 0;
>>>  }
>>>  
>>> -bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
>>> +static bool kvm_need_pmc_intercept(struct kvm_vcpu *vcpu)
>> The function name kvm_need_pmc_intercept() seems a little bit misleading
>> and make users think this function is used to check if a certain PMC is
>> intercepted. Maybe we can rename the function to kvm_need_global_intercept().
> Yeah, I don't love kvm_need_pmc_intercept() either.  But kvm_need_global_intercept()
> feels too close to kvm_need_perf_global_ctrl_intercept().
>
> Maybe something like kvm_need_any_pmc_intercept()?

It sounds good to me. Thanks.



