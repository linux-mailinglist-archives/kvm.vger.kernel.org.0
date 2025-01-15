Return-Path: <kvm+bounces-35494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C1EA11772
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DD181888E24
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28ACF22DC5D;
	Wed, 15 Jan 2025 02:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScIeAvKc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B619E22F381
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 02:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736909090; cv=none; b=Mu5v3xpS3w0DAZ2YHo7jJHN6k73Gl4bpTLS/3lqFLi2o+A64np4ld4Ltdy77NAa+iYAUv9eC+gyHoI7mg1i42B0gLSQ/VgurxcpgGBEOssugHurSsyQEctLystG13jFhlT75reB2KiYKxIckcIEDeORTjIHmA6QP85H90SNSxQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736909090; c=relaxed/simple;
	bh=H7qF+/lU+dtOtS7odrwO4z2FInLKcr+oGLDhjs1VwjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fed1KBENz+ts5HxnjYpms7xKbtA+uFb817tcIGvfCa+RsNDnoqZ6suKl6S8lYdWYRN94SDnaSGsUGf/tbIsGs/o1QXEg1QoXzh6RqtoXhmMlld0AJDxnT6wsTIKZD9JJ0epI1McEY+myeN8nB7kAkoGrADpX29O294LuU9swSwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScIeAvKc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736909088; x=1768445088;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H7qF+/lU+dtOtS7odrwO4z2FInLKcr+oGLDhjs1VwjQ=;
  b=ScIeAvKcsF6t0nU2Vkvn+m1dGAHl5nQ42Kz3/Od3rqWhKaufnWlMBynq
   j5mzqmf6D/gA4qgj5CdHVlLmBBFv9a6AYoNmSms+z4ionqpkrw5At7r2Z
   Ei/tsekDK09jWKht0mWsji8doxIwvTvFFwKJEVVAcqBJTkxF13UaWgnkV
   qsno5hTBy9VVZaAsrvmyWaer/TEL6yz/Hx9pR3SMZv1oaaGIJfaUa79A2
   d1ZDPxq/F6yQYcpa6mVhyVi1ZMphZBCSfl7sHo+aVQ334cM9Pd76yfiXY
   u6nzHK7qGVPmw+ynzBQvbwqt1N6pFnM836eqTCKGygrk1fNQq0tUplHIM
   w==;
X-CSE-ConnectionGUID: OEaizcHFT+O1LUp1RSSpMQ==
X-CSE-MsgGUID: sbqroB3/TcaYdxtpay9WsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="47720060"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="47720060"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 18:44:48 -0800
X-CSE-ConnectionGUID: IN9icGHiSa2H0bcutdtsdw==
X-CSE-MsgGUID: fH7bTWZ5SR6GfaawKxe9Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="109055814"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 18:44:46 -0800
Message-ID: <a2adf1b8-c394-4741-a42b-32288657b07e@linux.intel.com>
Date: Wed, 15 Jan 2025 10:44:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [KVM] 7803339fa9:
 kernel-selftests.kvm.pmu_counters_test.fail
To: Sean Christopherson <seanjc@google.com>,
 kernel test robot <oliver.sang@intel.com>, g@google.com
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
 xudong.hao@intel.com
References: <202501141009.30c629b4-lkp@intel.com>
 <Z4a_PmUVVmUtOd4p@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z4a_PmUVVmUtOd4p@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/15/2025 3:47 AM, Sean Christopherson wrote:
> +Dapeng
>
> On Tue, Jan 14, 2025, kernel test robot wrote:
>> we fould the test failed on a Cooper Lake, not sure if this is expected.
>> below full report FYI.
>>
>>
>> kernel test robot noticed "kernel-selftests.kvm.pmu_counters_test.fail" on:
>>
>> commit: 7803339fa929387bbc66479532afbaf8cbebb41b ("KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU")
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>>
>> [test failed on linux-next/master 37136bf5c3a6f6b686d74f41837a6406bec6b7bc]
>>
>> in testcase: kernel-selftests
>> version: kernel-selftests-x86_64-7503345ac5f5-1_20241208
>> with following parameters:
>>
>> 	group: kvm
>>
>> config: x86_64-rhel-9.4-kselftests
>> compiler: gcc-12
>> test machine: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory
> *sigh*
>
> This fails on our Skylake and Cascade Lake systems, but I only tested an Emerald
> Rapids.
>
>> # Testing fixed counters, PMU version 0, perf_caps = 2000
>> # Testing arch events, PMU version 1, perf_caps = 0
>> # ==== Test Assertion Failure ====
>> #   x86/pmu_counters_test.c:129: count >= (10 * 4 + 5)
>> #   pid=6278 tid=6278 errno=4 - Interrupted system call
>> #      1	0x0000000000411281: assert_on_unhandled_exception at processor.c:625
>> #      2	0x00000000004075d4: _vcpu_run at kvm_util.c:1652
>> #      3	 (inlined by) vcpu_run at kvm_util.c:1663
>> #      4	0x0000000000402c5e: run_vcpu at pmu_counters_test.c:62
>> #      5	0x0000000000402e4d: test_arch_events at pmu_counters_test.c:315
>> #      6	0x0000000000402663: test_arch_events at pmu_counters_test.c:304
>> #      7	 (inlined by) test_intel_counters at pmu_counters_test.c:609
>> #      8	 (inlined by) main at pmu_counters_test.c:642
>> #      9	0x00007f3b134f9249: ?? ??:0
>> #     10	0x00007f3b134f9304: ?? ??:0
>> #     11	0x0000000000402900: _start at ??:?
>> #   count >= NUM_INSNS_RETIRED
> The failure is on top-down slots.  I modified the assert to actually print the
> count (I'll make sure to post a patch regardless of where this goes), and based
> on the count for failing vs. passing, I'm pretty sure the issue is not the extra
> instruction, but instead is due to changing the target of the CLFUSH from the
> address of the code to the address of kvm_pmu_version.
>
> However, I think the blame lies with the assertion itself, i.e. with commit
> 4a447b135e45 ("KVM: selftests: Test top-down slots event in x86's pmu_counters_test").
> Either that or top-down slots is broken on the Lakes.
>
> By my rudimentary measurements, tying the number of available slots to the number
> of instructions *retired* is fundamentally flawed.  E.g. on the Lakes (SKX is more
> or less identical to CLX), omitting the CLFLUSHOPT entirely results in *more*
> slots being available throughout the lifetime of the measured section.
>
> My best guess is that flushing the cache line use for the data load causes the
> backend to saturate its slots with prefetching data, and as a result the number
> of slots that are available goes down.
>
>         CLFLUSHOPT .    | CLFLUSHOPT [%m]       | NOP
> CLX     350-100         | 20-60[*]              | 135-150  
> SPR     49000-57000     | 32500-41000           | 6760-6830
>
> [*] CLX had a few outliers in the 200-400 range, but the majority of runs were
>     in the 20-60 range.
>
> Reading through more (and more and more) of the TMA documentation, I don't think
> we can assume anything about the number of available slots, beyond a very basic
> assertion that it's practically impossible for there to never be an available
> slot.  IIUC, retiring an instruction does NOT require an available slot, rather
> it requires the opposite: an occupied slot for the uop(s).

I'm not quite sure about this. IIUC, retiring an instruction may not need a
cycle, but it needs a slot at least except the instruction is macro-fused.
Anyway, let me double check with our micro-architecture and perf experts.


>
> I'm mildly curious as to why the counts for SPR are orders of magnitude higher
> that CLX (simple accounting differences?), but I don't think it changes anything
> in the test itself.
>
> Unless someone has a better idea, my plan is to post a patch to assert that the
> top-down slots count is non-zero, not that it's >= instructions retired.  E.g.
>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index accd7ecd3e5f..21acedcd46cd 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -123,10 +123,8 @@ static void guest_assert_event_count(uint8_t idx,
>                 fallthrough;
>         case INTEL_ARCH_CPU_CYCLES_INDEX:
>         case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
> -               GUEST_ASSERT_NE(count, 0);
> -               break;
>         case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
> -               GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
> +               GUEST_ASSERT_NE(count, 0);
>                 break;
>         default:
>                 break;
>

