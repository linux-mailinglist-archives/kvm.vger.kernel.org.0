Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58806A230C
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 21:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjBXUIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 15:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBXUIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 15:08:37 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127AD40F2
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:08:36 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536c039f859so5259177b3.21
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zvip+H3V2JK4a6T6lWLLfD2yd7PzeIZaRznMmxk8jK0=;
        b=bCh5ZQg6T9e20DbTrhJwsAfaPTagnHbFzj+L6WeaNBTSze0MWGbH1TP+VUw9ZnaNGx
         hHk/gYVrfnWJV0fP3894RY82TYjItAWdFCGLwymZLPUB6QNWT7U53MPI97rD1NjIFM1J
         jKZAhNdgriBZRXQsTvJzo/Jn7ClxKaVYcpm3nOL7nyymKNCG+8G971MEKjZak1XHGt7j
         gKiKyTtSeqOaGcVwhaA0CyVOWjC7FJ1fHnbNo7283XAAVklWYCjeSZXtjA2sKF4w6xfq
         Yc0YnCxTcTCEwXfjADifDca9riaTgG3PAZxWfkZDuiz73k1HokoAsPuOAkij4iL+bif5
         9c+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zvip+H3V2JK4a6T6lWLLfD2yd7PzeIZaRznMmxk8jK0=;
        b=LzV35OX8foKRCX5CWLI85MtTOHy/XFJhKQfS0cjcv9ytrkZsDQEfGT2iVIesp94Gcg
         iGdBypjOPIL+1IEi+iJ1giB0zKrsaPhTzjMeoqzGcLBv2QI1FhyNVoH9m4ab5n7CQjYx
         tTcEb3ZfMlqK0IsBn9lkHXvnVerX/EZ45xIfOVWq9qJd9Gy/GdKQZg7mIC24tCtd6kHF
         B8AAR3uXJRW8dVzWJuAzf9/QxNIrvqqYuRX3YBtiVIv3N20L0E8q4eA7YYfgcBfPU3So
         mhvy3CaLTDqFdx1SpQyU7txNQ1fTaxwCO7pXJpjjgpIzxM+fAu4F19rAgH2lDYMrJkob
         2jjQ==
X-Gm-Message-State: AO0yUKV7nsJmg2mZTYIUWRSOvaerVkZm9sOjk9AfT0NjdNbbUnHoEUWb
        w+COw0+9yqe5+xbr0b5O8QprDfIV6e3OhwDKBA==
X-Google-Smtp-Source: AK7set9HE/402KRg5HCQAcC3VqCLfRR0grEiXHk+VWeT+/d90TLGL9IcEhCT3cJ1raaaJTlh2nl5FNcfi71/BrkqDQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5b:605:0:b0:a4d:7b9b:415f with SMTP
 id d5-20020a5b0605000000b00a4d7b9b415fmr1718113ybq.4.1677269315297; Fri, 24
 Feb 2023 12:08:35 -0800 (PST)
Date:   Fri, 24 Feb 2023 20:08:34 +0000
In-Reply-To: <Y/XJTGydjLCGKqRz@linux.dev> (message from Oliver Upton on Wed,
 22 Feb 2023 07:50:36 +0000)
Mime-Version: 1.0
Message-ID: <gsnth6va967x.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, seanjc@google.com, vipinsh@google.com,
        dmatlack@google.com, andrew.jones@linux.dev, ricarkol@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oliver Upton <oliver.upton@linux.dev> writes:

>> These functions were originally part of my patch to introduce latency
>> measurements into dirty_log_perf_test. [1] Sean Christopherson
>> suggested lifting these functions into their own patch in generic code
>> so they can be used by any test. [2] Ricardo Koller suggested the
>> addition of the MEASURE macro to more easily time individual
>> statements. [3]

>> [1]  
>> https://lore.kernel.org/kvm/20221115173258.2530923-1-coltonlewis@google.com/
>> [2] https://lore.kernel.org/kvm/Y8gfOP5CMXK60AtH@google.com/
>> [3] https://lore.kernel.org/kvm/Y8cIdxp5k8HivVAe@google.com/

> This patch doesn't make a great deal of sense outside of [1]. Can you
> send this as part of your larger series next time around?

I copied the wrong email link where Sean suggested this should be
generic code in a separate patch. I may have been mistaken in thinking
he meant to upstream it separately.

https://lore.kernel.org/kvm/Y8gjG6gG5UR6T3Yg@google.com/

But yes, I would prefer to keep this as part of the larger series.

>>   #include <linux/mman.h>
>>   #include "linux/kernel.h"

>> +#if defined(__aarch64__)
>> +#include "aarch64/arch_timer.h"
>> +#elif defined(__x86_64__)
>> +#include "x86_64/processor.h"
>> +#endif

> I believe we place 'include/$(ARCH)/' on the include path, so the
> 'x86_64' can be dropped.

Good to know.

>>   #include "test_util.h"

>>   /*
>> @@ -34,6 +39,38 @@ uint32_t guest_random_u32(struct guest_random_state  
>> *state)
>>   	return state->seed;
>>   }

>> +uint64_t guest_cycles_read(void)

> Do we need the 'guest_' prefix in here? At least for x86 and arm64 the
> same instructions can be used in host userspace and guest kernel for
> accessing the counter.

It's intended for guest space, but I take your point it isn't necessary.

>> +{
>> +#if defined(__aarch64__)
>> +	return timer_get_cntct(VIRTUAL);
>> +#elif defined(__x86_64__)
>> +	return rdtsc();
>> +#else
>> +#warn __func__ " is not implemented for this architecture, will return  
>> 0"
>> +	return 0;
>> +#endif
>> +}

> I think it would be cleaner if each architecture just provided its own
> implementation of this function instead of ifdeffery here.

> If an arch doesn't implement the requisite helper then it will become
> painfully obvious at compile time.

Good point. That will be more clear.

>> +double guest_cycles_to_ns(double cycles)
>> +{
>> +#if defined(__aarch64__)
>> +	return cycles * (1e9 / timer_get_cntfrq());
>> +#elif defined(__x86_64__)
>> +	return cycles * (1e9 / (KVM_GET_TSC_KHZ * 1000));

> The x86 implementation is wrong. KVM_GET_TSC_KHZ is the ioctl needed
> to get at the guest's TSC frequency (from the perpsective of host
> userspace).

Oops. Absent minded on that one. Forgot it wasn't just a value I could use.

> So at the very least this needs to do an ioctl on the VM fd to work out
> the frequency. This is expected to be called in host userspace, right?

That's the plan yes.

>> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c  
>> b/tools/testing/selftests/kvm/system_counter_offset_test.c
>> index 7f5b330b6a1b..39b1249c7404 100644
>> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
>> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
>> @@ -39,14 +39,9 @@ static void setup_system_counter(struct kvm_vcpu  
>> *vcpu, struct test_case *test)
>>   			     &test->tsc_offset);
>>   }

>> -static uint64_t guest_read_system_counter(struct test_case *test)
>> -{
>> -	return rdtsc();
>> -}
>> -
>>   static uint64_t host_read_guest_system_counter(struct test_case *test)
>>   {
>> -	return rdtsc() + test->tsc_offset;
>> +	return guest_cycles_read() + test->tsc_offset;

> The 'guest_' part is rather confusing here. What this function is really
> trying to do is read the counter from host userspace and apply an offset
> to construct the expected value for the test.

> It all compiles down to the same thing, but as written is seemingly
> wrong.

I'll eliminate the guest_prefix.
