Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290B146E3D8
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 09:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhLIIPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 03:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhLIIPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 03:15:35 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F44C061746;
        Thu,  9 Dec 2021 00:12:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b13so3325092plg.2;
        Thu, 09 Dec 2021 00:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=shon4B3GPYk/OMPNgIaNwAz2MaNPqs42MLZnKkqBnqI=;
        b=VTj7cHHDE6OwAZn3p3IB1b8XJnLjwmNQcRSPyNjBJ7A8ZcXyX6m/LmbKSuSAG36q1x
         vm7Tbue2Gga9dh/O1VMFpbRS655lBuA3/4Q10RXz74lj7ddUKi2LzmoAS2sfaSAoM2dB
         8Up5dC64FIKXIBTwsRPrJTcuFwANBb+c3DL/elxt9n5+Cxjzx036xs3MKAmpHk00JOxw
         jIv//cvWI92BHhw3hBaH6uNSabm+t+URyHvRzmv8pPJ9/BHldr9WjCHGpG9dTK9qe2uD
         CZUTqpddbnITAV88k2ToV06K75FvKrntWHG/rzca5frrlH6uJARwezF+C5KlI/Fa8dTs
         YCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=shon4B3GPYk/OMPNgIaNwAz2MaNPqs42MLZnKkqBnqI=;
        b=In6qp1+LIeo2rTV2XuwTXT6hLTldaUIUbLhYQS0SsCzSGe6wHW7pCvMZJ4szqarxR8
         QeHfZ0KHgKvAnS8KY2UCHKHE4py+J7fx4y4jtmqrwg6AhGEjJujeNv7BO33L0oiEFuoV
         UPFPa+uKhzCK7ERJBM6oJ06zD5uyCjltxc5v1fFM9vtPtL9cvrnIbGBI4r9KgPISRaIM
         kCDo69LX83nuZwEHjoUODPGdNT+6Js4XEKnVMx9vibsJf2+HD0jQpmLsZ64UbMBEq1HT
         NeBYJTJWz4Xq6cYYsBWUOke1GWfIPmdfniT60Q+KJPuLVZpt6bLTwcpLt9rX+NSYd2Br
         o5Sw==
X-Gm-Message-State: AOAM5320Q8VfZVkL/XKRGjUbFS2QWsQ3GmHkj1HbNae9DBYMDslB2Cvb
        U5SxNgcijYm7OkRWB/tIFGDp20xCPs8=
X-Google-Smtp-Source: ABdhPJwEoDbhEc1H6pUjnkE8ozSIqJB+lBnxm7PNL0ItTujo5wCL5staxYaoR0IXVR6wtphZaNS4OQ==
X-Received: by 2002:a17:902:c086:b0:142:7169:1573 with SMTP id j6-20020a170902c08600b0014271691573mr65256158pld.13.1639037521795;
        Thu, 09 Dec 2021 00:12:01 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i67sm5996686pfg.189.2021.12.09.00.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 00:12:01 -0800 (PST)
Message-ID: <ebfac3c7-fbc6-78a5-50c5-005ea11cc6ca@gmail.com>
Date:   Thu, 9 Dec 2021 16:11:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        "Peter Zijlstra (Intel OTC, Netherlander)" <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eRaZBftkaFsmfH8V519QdSGKTORp0OAZ2WaNi3f9X=tng@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
In-Reply-To: <CALMp9eRaZBftkaFsmfH8V519QdSGKTORp0OAZ2WaNi3f9X=tng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/12/2021 11:52 am, Jim Mattson wrote:
> On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The find_arch_event() returns a "unsigned int" value,
>> which is used by the pmc_reprogram_counter() to
>> program a PERF_TYPE_HARDWARE type perf_event.
>>
>> The returned value is actually the kernel defined generic
> 
> Typo: generic.
> 
>> perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
>> incoming parameters for better self-explanation.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.c           | 8 +-------
>>   arch/x86/kvm/pmu.h           | 3 +--
>>   arch/x86/kvm/svm/pmu.c       | 8 ++++----
>>   arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
>>   4 files changed, 11 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 09873f6488f7..3b3ccf5b1106 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -174,7 +174,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>>   void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>>   {
>>          unsigned config, type = PERF_TYPE_RAW;
>> -       u8 event_select, unit_mask;
>>          struct kvm *kvm = pmc->vcpu->kvm;
>>          struct kvm_pmu_event_filter *filter;
>>          int i;
>> @@ -206,17 +205,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>>          if (!allow_event)
>>                  return;
>>
>> -       event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
>> -       unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>> -
>>          if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
>>                            ARCH_PERFMON_EVENTSEL_INV |
>>                            ARCH_PERFMON_EVENTSEL_CMASK |
>>                            HSW_IN_TX |
>>                            HSW_IN_TX_CHECKPOINTED))) {
> 
> The mechanics of the change look fine, but I do have some questions,
> for my own understanding.
> 
> Why don't we just use PERF_TYPE_RAW for guest counters all of the
> time? What is the advantage of matching entries in a table so that we
> can use PERF_TYPE_HARDWARE?

The first reason is we need PERF_TYPE_HARDWARE for fixed counters.

And then we might wonder whether we can create perf-event faster
using PERF_TYPE_HARDWARE compared to PERF_TYPE_HARDWARE.

But the (current) answer is no, and probably the opposite:

# The cost (nanosecond) of calling perf_event_create_kernel_counter()
PERF_TYPE_RAW
Max= 1072211
Min= 11122
Avg= 41681.7

PERF_TYPE_HARDWARE
Max= 46184215
Min= 16194
Avg= 250650

So why don't we just use PERF_TYPE_RAW for just all gp counters ?

Hi Peter, do you have any comments to invalidate this proposal ?

> 
> Why do the HSW_IN_TX* bits result in bypassing this clause, when these
> bits are extracted as arguments to pmc_reprogram_counter below?

Once upon the time, the "PERF_TYPE_RAW" was introduced in the
perf with comment "available TYPE space, raw is the max value",
which means, per my understanding, it's our final type choice
for creating a valid perf_event when HSW_IN_TX* bits are set
and KVM needs to hack other perf_event_attr stuff for this
HSW_IN_TX feature with the help of extracted arguments.

> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 
