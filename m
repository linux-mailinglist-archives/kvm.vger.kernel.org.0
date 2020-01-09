Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D07135F5A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgAIRaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:30:12 -0500
Received: from foss.arm.com ([217.140.110.172]:35028 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIRaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 12:30:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35477328;
        Thu,  9 Jan 2020 09:30:11 -0800 (PST)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF75D3F703;
        Thu,  9 Jan 2020 09:30:08 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm: pmu: Check Required Event
 Support
To:     Auger Eric <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
References: <20191216204757.4020-1-eric.auger@redhat.com>
 <20191216204757.4020-5-eric.auger@redhat.com>
 <20200103181251.72cfcae2@donnerap.cambridge.arm.com>
 <ce0ce49f-7e19-21d4-5eba-386dd2f96301@redhat.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <380b27cb-a762-0622-af9c-1d2afc3a4b5e@arm.com>
Date:   Thu, 9 Jan 2020 17:30:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <ce0ce49f-7e19-21d4-5eba-386dd2f96301@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/2020 16:54, Auger Eric wrote:

Hi Eric,

> On 1/3/20 7:12 PM, Andre Przywara wrote:
>> On Mon, 16 Dec 2019 21:47:51 +0100
>> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Hi Eric,
>>
>>> If event counters are implemented check the common events
>>> required by the PMUv3 are implemented.
>>>
>>> Some are unconditionally required (SW_INCR, CPU_CYCLES,
>>> either INST_RETIRED or INST_SPEC). Some others only are
>>> required if the implementation implements some other features.
>>>
>>> Check those wich are unconditionally required.
>>>
>>> This test currently fails on TCG as neither INST_RETIRED
>>> or INST_SPEC are supported.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>>
>>> v1 ->v2:
>>> - add a comment to explain the PMCEID0/1 splits
>>> ---
>>>  arm/pmu.c         | 71 +++++++++++++++++++++++++++++++++++++++++++++++
>>>  arm/unittests.cfg |  6 ++++
>>>  2 files changed, 77 insertions(+)
>>>
>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>> index d24857e..d88ef22 100644
>>> --- a/arm/pmu.c
>>> +++ b/arm/pmu.c
>>> @@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>>>  	: [pmcr] "r" (pmcr), [z] "r" (0)
>>>  	: "cc");
>>>  }
>>> +
>>> +/* event counter tests only implemented for aarch64 */
>>> +static void test_event_introspection(void) {}
>>> +
>>>  #elif defined(__aarch64__)
>>>  #define ID_AA64DFR0_PERFMON_SHIFT 8
>>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>> @@ -139,6 +143,70 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>>>  	: [pmcr] "r" (pmcr)
>>>  	: "cc");
>>>  }
>>> +
>>> +#define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
>>> +
>>> +static bool is_event_supported(uint32_t n, bool warn)
>>> +{
>>> +	uint64_t pmceid0 = read_sysreg(pmceid0_el0);
>>> +	uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
>>> +	bool supported;
>>> +	uint32_t reg;
>>> +
>>> +	/*
>>> +	 * The low 32-bits of PMCEID0/1 respectly describe
>>> +	 * event support for events 0-31/32-63. Their High
>>> +	 * 32-bits describe support for extended events
>>> +	 * starting at 0x4000, using the same split.
>>> +	 */
>>> +	if (n >= 0x0  && n <= 0x1F)
>>> +		reg = pmceid0 & 0xFFFFFFFF;
>>> +	else if  (n >= 0x4000 && n <= 0x401F)
>>> +		reg = pmceid0 >> 32;
>>> +	else if (n >= 0x20  && n <= 0x3F)
>>> +		reg = pmceid1 & 0xFFFFFFFF;
>>> +	else if (n >= 0x4020 && n <= 0x403F)
>>> +		reg = pmceid1 >> 32;
>>> +	else
>>> +		abort();
>>> +
>>> +	supported =  reg & (1 << n);
>>
>> Don't we need to mask off everything but the lowest 5 bits of "n"? Probably also using "1U" is better.
> I added an assert to check n is less or equal than 0x3F

But "n" will definitely be bigger than that in case of an extended
event, won't it? So you adjust "reg" accordingly, but miss to do
something similar to "n"?

>>
>>> +	if (!supported && warn)
>>> +		report_info("event %d is not supported", n);
>>> +	return supported;
>>> +}
>>> +
>>> +static void test_event_introspection(void)
>>
>> "introspection" sounds quite sophisticated. Are you planning to extend this? If not, could we maybe rename it to "test_available_events"?
> Yes this test is a placeholder for looking at the PMU characteristics
> and we may add some other queries there.
>>
>>> +{
>>> +	bool required_events;
>>> +
>>> +	if (!pmu.nb_implemented_counters) {
>>> +		report_skip("No event counter, skip ...");
>>> +		return;
>>> +	}
>>> +
>>> +	/* PMUv3 requires an implementation includes some common events */
>>> +	required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
>>> +			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
>>> +			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
>>> +			   is_event_supported(0x1B, true) /* INST_PREC */);
>>> +
>>> +	if (pmu.version == 0x4) {
>>> +		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
>>> +		required_events = required_events ||
>>> +				  is_event_supported(0x23, true) ||
>>
>> Shouldn't those two operators be '&&' instead?
> yes definitively
>>
>>> +				  is_event_supported(0x24, true);
>>> +	}
>>> +
>>> +	/*
>>> +	 * L1D_CACHE_REFILL(0x3) and L1D_CACHE(0x4) are only required if
>>> +	 * L1 data / unified cache. BR_MIS_PRED(0x10), BR_PRED(0x12) are only
>>> +	 * required if program-flow prediction is implemented.
>>> +	 */
>>
>> Is this a TODO?
> yes. Added TODO. I do not know how to check whether the conditions are
> satisfied? Do you have any idea?

Well, AFAICS KVM doesn't filter PMCEIDn, right? So some basic checks are
surely fine, but I wouldn't go crazy about checking every possible
aspect of it. After all you would just check the hardware, as we pass
this register on.

Cheers,
Andre.

> Thank you for the review!
> 
> Eric
>>
>> Cheers,
>> Andre
>>
>>
>>> +
>>> +	report(required_events, "Check required events are implemented");
>>> +}
>>> +
>>>  #endif
>>>  
>>>  /*
>>> @@ -326,6 +394,9 @@ int main(int argc, char *argv[])
>>>  		       "Monotonically increasing cycle count");
>>>  		report(check_cpi(cpi), "Cycle/instruction ratio");
>>>  		pmccntr64_test();
>>> +	} else if (strcmp(argv[1], "event-introspection") == 0) {
>>> +		report_prefix_push(argv[1]);
>>> +		test_event_introspection();
>>>  	} else {
>>>  		report_abort("Unknown sub-test '%s'", argv[1]);
>>>  	}
>>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>>> index 79f0d7a..4433ef3 100644
>>> --- a/arm/unittests.cfg
>>> +++ b/arm/unittests.cfg
>>> @@ -66,6 +66,12 @@ file = pmu.flat
>>>  groups = pmu
>>>  extra_params = -append 'cycle-counter 0'
>>>  
>>> +[pmu-event-introspection]
>>> +file = pmu.flat
>>> +groups = pmu
>>> +arch = arm64
>>> +extra_params = -append 'event-introspection'
>>> +
>>>  # Test PMU support (TCG) with -icount IPC=1
>>>  #[pmu-tcg-icount-1]
>>>  #file = pmu.flat
>>
> 

