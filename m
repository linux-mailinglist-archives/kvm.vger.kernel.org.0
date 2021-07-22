Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357CF3D1F10
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 09:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhGVGwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 02:52:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230100AbhGVGwn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 02:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626939198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUQfBRYvpFMtW0v+U77M8R0BJXxFR56ll5egnHL77Lg=;
        b=QHdpRzHet2vEMUy9R849OZOM+dJwG92Bz4TLxImP9r3huqasCgxcD6w1A+1QuSX0SfX6Hk
        qyotCZknCFLavo7sGTsZ+eiBhQZehPsNaH3ZSHiBF3E6lD7IZInJoFB/Prbeg7vAQIcXVn
        tW6T7S1lQSQ/mxY1frTwSkRdNdmhdwY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-N5cubnYtM76xvvsE7cgmMg-1; Thu, 22 Jul 2021 03:33:17 -0400
X-MC-Unique: N5cubnYtM76xvvsE7cgmMg-1
Received: by mail-wr1-f70.google.com with SMTP id a4-20020adffb840000b02901304c660e75so2084347wrr.19
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 00:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iUQfBRYvpFMtW0v+U77M8R0BJXxFR56ll5egnHL77Lg=;
        b=KsS5/rycsugI06xtD0lmMWeAwFutQzuDqxTtlsNIoe21BWoPbSZoFZuLOeJGrRUaHL
         +yePiorPj69G+9pV4oY1wYc0agK+XJIpNPCWlMuVn/ceu4t+m00XGcGQfpjtEes1CEu8
         pqx7UMQWQTdjwCPiObItiC3Tc4msxSlF5eiSnD9XP+GQagJ0MOnHjttM1fp1y7eWRUJK
         JGfU6raQbQaJ2bAxcMKqwhBoFuft8VpabOvO9CD8c9HczawITKbyVQwlGV8ADla6j0IH
         UYB5rK+uSBFIJTT6uoF7JHrIwS3YvNBEo/9yYnSVssDdtsoNEI//yOHm92EWAhpSYdQE
         L98g==
X-Gm-Message-State: AOAM531Udsy/hxCTxwtdaKXTVlWBfqWR8u8PiOS0LtHxmCgamQUzSPS5
        wS5O5HYbm4hEYCW43MzwJRK4hADQPwu15ZAH6sRBOfsnofpJme/YW9Vo84zE+4YyOJC9dxC98D0
        y91P7wjPasV1G
X-Received: by 2002:a05:600c:4c96:: with SMTP id g22mr7504316wmp.70.1626939196123;
        Thu, 22 Jul 2021 00:33:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsogsTiFg/8QnartLbcf+gQldgIKHTGCWGBb1qyVqEA3t1NcO+0KaRJgLVSV2J5ysK99KmlA==
X-Received: by 2002:a05:600c:4c96:: with SMTP id g22mr7504291wmp.70.1626939195878;
        Thu, 22 Jul 2021 00:33:15 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83f5d.dip0.t-ipconnect.de. [217.232.63.93])
        by smtp.gmail.com with ESMTPSA id r17sm1795916wmq.13.2021.07.22.00.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 00:33:15 -0700 (PDT)
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115459.372749-1-scgl@linux.ibm.com>
 <18803632-6a9c-5999-2a8a-d4501a0a77d8@redhat.com>
 <9bf3313e-0d96-1312-550a-0d1662d50130@linux.vnet.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception test
Message-ID: <4e589450-fa63-d755-5e4c-7082b899bdf5@redhat.com>
Date:   Thu, 22 Jul 2021 09:33:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9bf3313e-0d96-1312-550a-0d1662d50130@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/2021 17.44, Janis Schoetterl-Glausch wrote:
> On 7/21/21 3:26 PM, Thomas Huth wrote:
>> On 06/07/2021 13.54, Janis Schoetterl-Glausch wrote:
>>> Generate specification exceptions and check that they occur.
>>> Also generate specification exceptions during a transaction,
>>> which results in another interruption code.
>>> With the iterations argument one can check if specification
>>> exception interpretation occurs, e.g. by using a high value and
>>> checking that the debugfs counters are substantially lower.
>>> The argument is also useful for estimating the performance benefit
>>> of interpretation.
>>>
>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>> ---
>>>    s390x/Makefile           |   1 +
>>>    lib/s390x/asm/arch_def.h |   1 +
>>>    s390x/spec_ex.c          | 344 +++++++++++++++++++++++++++++++++++++++
>>>    s390x/unittests.cfg      |   3 +
>>>    4 files changed, 349 insertions(+)
>>>    create mode 100644 s390x/spec_ex.c
>>>
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index 8820e99..be100d3 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>>>    tests += $(TEST_DIR)/mvpg.elf
>>>    tests += $(TEST_DIR)/uv-host.elf
>>>    tests += $(TEST_DIR)/edat.elf
>>> +tests += $(TEST_DIR)/spec_ex.elf
>>>      tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>>    ifneq ($(HOST_KEY_DOCUMENT),)
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index 15cf7d4..7cb0b92 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -229,6 +229,7 @@ static inline uint64_t stctg(int cr)
>>>        return value;
>>>    }
>>>    +#define CTL0_TRANSACT_EX_CTL    (63 -  8)
>>>    #define CTL0_LOW_ADDR_PROT    (63 - 35)
>>>    #define CTL0_EDAT        (63 - 40)
>>>    #define CTL0_IEP        (63 - 43)
>>> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
>>> new file mode 100644
>>> index 0000000..2e05bfb
>>> --- /dev/null
>>> +++ b/s390x/spec_ex.c
>>> @@ -0,0 +1,344 @@
>>
>> Please add a short comment header at the top of the file with some information on what it is all about, and license information (e.g. a SPDX-License-Identifier)
>>
>>> +#include <stdlib.h>
>>> +#include <htmintrin.h>
>>> +#include <libcflat.h>
>>> +#include <asm/barrier.h>
>>> +#include <asm/interrupt.h>
>>> +#include <asm/facility.h>
>>> +
>>> +struct lowcore *lc = (struct lowcore *) 0;
>>> +
>>> +static bool expect_early;
>>> +static struct psw expected_early_pgm_psw;
>>> +static struct psw fixup_early_pgm_psw;
>>> +
>>> +static void fixup_early_pgm_ex(void)
>>
>> Could you please add a comment in front of this function with a description why this is required / good for?
> 
> Sure, how about:
> 
> /* The standard program exception handler cannot deal with invalid old PSWs,
>   * especially not invalid instruction addresses, as in that case one cannot
>   * find the instruction following the faulting one from the old PSW.
>   */
> 
> I'll also change some names since something like this is necessary for all
> exceptions caused by invalid PSWs, not just the early ones:
> 
> static void fixup_invalid_psw(void)
>>
>>> +{
>>> +    if (expect_early) {
>>> +        report(expected_early_pgm_psw.mask == lc->pgm_old_psw.mask
>>> +               && expected_early_pgm_psw.addr == lc->pgm_old_psw.addr,
>>> +               "Early program new PSW as expected");
>>> +        expect_early = false;
>>> +    }
>>> +    lc->pgm_old_psw = fixup_early_pgm_psw;
>>> +}
>>> +
>>> +static void lpsw(uint64_t psw)
>>> +{
>>> +    uint32_t *high, *low;
>>> +    uint64_t r0 = 0, r1 = 0;
>>> +
>>> +    high = (uint32_t *) &fixup_early_pgm_psw.mask;
>>> +    low = high + 1;
>>> +
>>> +    asm volatile (
>>> +        "    epsw    %0,%1\n"
>>> +        "    st    %0,%[high]\n"
>>> +        "    st    %1,%[low]\n"
>>
>> What's all this magic with high and low good for? Looks like high and low are not used afterwards anymore?
> 
> Seems like the easiest way to store both halves of the current mask into the global fixup PSW.

Ok, thanks, now I got it. But I think it would be easier to understand if 
you'd only pass the address of fixup_early_pgm_psw.mask to the assembly code 
and then do e.g. a "st %1,4(%[mask])" instead.

>>> +        "    larl    %0,nop%=\n"
>>> +        "    stg    %0,%[addr]\n"
>>> +        "    lpsw    %[psw]\n"
>>> +        "nop%=:    nop\n"
>>> +        : "+&r"(r0), "+&a"(r1), [high] "=&R"(*high), [low] "=&R"(*low)
>>
>> ... also not sure why you need the "&" modifiers here?
> 
> r0, r1 are stored into before reading psw, also there are implied input registers for the
> memory output operands. To be honest, I didn't care to figure out the minimal '&' usage,
> it's just test code after all.

Ok, fair point, makes sense now, too.

>>> +        , [addr] "=&R"(fixup_early_pgm_psw.addr)
>>> +        : [psw] "Q"(psw)
>>> +        : "cc", "memory"
>>> +    );
>>> +}
>>> +
>>> +static void psw_bit_31_32_are_1_0(void)
>>> +{
>>> +    uint64_t bad_psw = 0x000800015eadbeef;
>>> +
>>> +    //bit 12 gets inverted when extending to 128-bit PSW
>>
>> I'd prefer a space after the "//"
>>
>>> +    expected_early_pgm_psw.mask = 0x0000000100000000;
>>> +    expected_early_pgm_psw.addr = 0x000000005eadbeef;
>>> +    expect_early = true;
>>> +    lpsw(bad_psw);
>>> +}
>>> +
>>> +static void bad_alignment(void)
>>> +{
>>> +    uint32_t words[5] = {0, 0, 0};
>>> +    uint32_t (*bad_aligned)[4];
>>> +
>>> +    register uint64_t r1 asm("6");
>>> +    register uint64_t r2 asm("7");
>>> +    if (((uintptr_t)&words[0]) & 0xf) {
>>> +        bad_aligned = (uint32_t (*)[4])&words[0];
>>> +    } else {
>>> +        bad_aligned = (uint32_t (*)[4])&words[1];
>>> +    }
>>> +    asm volatile ("lpq %0,%2"
>>> +              : "=r"(r1), "=r"(r2)
>>> +              : "T"(*bad_aligned)
>>> +    );
>>> +}
>>> +
>>> +static void not_even(void)
>>> +{
>>> +    uint64_t quad[2];
>>> +
>>> +    register uint64_t r1 asm("7");
>>> +    register uint64_t r2 asm("8");
>>> +    asm volatile (".insn    rxy,0xe3000000008f,%0,%2" //lpq %0,%2
>>> +              : "=r"(r1), "=r"(r2)
>>> +              : "T"(quad)
>>> +    );
>>> +}
>>> +
>>> +struct spec_ex_trigger {
>>> +    const char *name;
>>> +    void (*func)(void);
>>> +    bool transactable;
>>> +    void (*fixup)(void);
>>> +};
>>> +
>>> +static const struct spec_ex_trigger spec_ex_triggers[] = {
>>> +    { "psw_bit_31_32_are_1_0", &psw_bit_31_32_are_1_0, false, &fixup_early_pgm_ex},
>>> +    { "bad_alignment", &bad_alignment, true, NULL},
>>> +    { "not_even", &not_even, true, NULL},
>>> +    { NULL, NULL, true, NULL},
>>> +};
>>> +
>>> +struct args {
>>> +    uint64_t iterations;
>>> +    uint64_t max_retries;
>>> +    uint64_t suppress_info;
>>> +    uint64_t max_failures;
>>> +    bool diagnose;
>>> +};
>>> +
>>> +static void test_spec_ex(struct args *args,
>>> +             const struct spec_ex_trigger *trigger)
>>> +{
>>> +    uint16_t expected_pgm = PGM_INT_CODE_SPECIFICATION;
>>> +    uint16_t pgm;
>>> +    unsigned int i;
>>> +
>>> +    register_pgm_cleanup_func(trigger->fixup);
>>> +    for (i = 0; i < args->iterations; i++) {
>>> +        expect_pgm_int();
>>> +        trigger->func();
>>> +        pgm = clear_pgm_int();
>>> +        if (pgm != expected_pgm) {
>>> +            report(0,
>>> +            "Program interrupt: expected(%d) == received(%d)",
>>> +            expected_pgm,
>>> +            pgm);
>>> +            return;
>>> +        }
>>> +    }
>>
>> Maybe it would be nice to "unregister" the cleanup function at the end with register_pgm_cleanup_func(NULL) ?
> 
> Yeah, I think I'll also move them just before and after the trigger->func().
>>
>>> +    report(1,
>>> +    "Program interrupt: always expected(%d) == received(%d)",
>>> +    expected_pgm,
>>> +    expected_pgm);
>>> +}
>>> +
>>> +#define TRANSACTION_COMPLETED 4
>>> +#define TRANSACTION_MAX_RETRIES 5
>>> +
>>> +static int __attribute__((nonnull))
>>
>> Not sure whether that attribute makes much sense with a static function? ... the compiler has information about the implementation details here, so it should be able to see that e.g. trigger must be non-NULL anyway?
> 
> One isn't supposed to pass NULL to __builtin_tbegin via a variable, only via a constant.
> I didn't want to deal with that constraint, so that's what the nonnull is there for.
> Maybe I should add a comment?

Yes, that would be helpful.

  Thomas

