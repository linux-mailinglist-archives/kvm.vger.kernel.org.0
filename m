Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F3B210FF2
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgGAQAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 12:00:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728534AbgGAQAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 12:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593619208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJlCDVz4BNthnJ1K64dOijcsJqHEUA8U3GXuwRStVyU=;
        b=fD4+tBnz19qoK80CYfXaAPht67MddgBrR1QmqudKQCXaeT8R+liqqEaqG9jlmAfHMR1fm1
        TKMI8dGYopvRj9Ayc2EiJt3pNB/rr1mUWKdVRegpvFBeq10UZtSQbnT9XwhmdtPF/z0QBW
        3bMyUOOvPeD0NWAXUXZ8Y3W4Dyq3GsI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-0lIFHuQpPhu3fSJtxW3nCg-1; Wed, 01 Jul 2020 12:00:04 -0400
X-MC-Unique: 0lIFHuQpPhu3fSJtxW3nCg-1
Received: by mail-wm1-f69.google.com with SMTP id t145so24103650wmt.2
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 09:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJlCDVz4BNthnJ1K64dOijcsJqHEUA8U3GXuwRStVyU=;
        b=jj5nbBtxnK60EG3AtE99pGhn5ehR41r+SF7E33ipIbt45s7Q2PXBMLp1Q7jnzFeKZA
         MzMkKsc8EI8mxI1KffyUkeLulog2Dv2NrhG6q7VQNlLb7ji+MhjhgzcDQIBVhm2WqxAs
         2c+j2Rwr25uSgLkffOTwNrmnNUONp8+xwRa/qrCLY6uZFSf4hslOeIjf4sIc63seLsLd
         Bticnr3fBegdeh9fUKthybqc8kr+a7NW/oWnRsiFczVhtCxQHhZ3GgKLujhWTzNfYPZ5
         tMzcecebXZ2O7y5dkuwR/Lnwr4L5a9PRg2tO9KfxtE08jD6cFD5r9d81jME+yhoar613
         wXvQ==
X-Gm-Message-State: AOAM532cdKzZ63hF9RTddNUKaMAEd7RQTrbRkL6LJswmttEwcAOVu9tK
        xcpPSlHBnVOFfDH25Ub+e6Od17SoT60xLbmHeB/9wnYI67ScGoG3mXDU5u+BOnP5b+BWe97AQkO
        fpiq0KxXoB9kl
X-Received: by 2002:a5d:5647:: with SMTP id j7mr26379423wrw.242.1593619202928;
        Wed, 01 Jul 2020 09:00:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYYbld5GIitz312TmZjWLr1aHJ//Cqa9XW0DxvWDaPFRw8BYjgQ4L8klNdzhoOKXb2ncc90g==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr26379406wrw.242.1593619202668;
        Wed, 01 Jul 2020 09:00:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9d66:2ca3:22cf:9fa9? ([2001:b07:6468:f312:9d66:2ca3:22cf:9fa9])
        by smtp.gmail.com with ESMTPSA id 59sm8212297wrj.37.2020.07.01.09.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 09:00:02 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Print more (accurate) info if
 RDTSC diff test fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>
References: <20200124234608.10754-1-sean.j.christopherson@intel.com>
 <705151e0-6a8b-1e15-934d-dd96f419dcd8@oracle.com>
 <CAAAPnDEA4u0YRLtW7OsWtL-Uy=5paDmrxx7EScDFsH5aqG6QJA@mail.gmail.com>
 <20200630193540.GH7733@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <94e46dcc-de1c-5701-8f9c-fc51e72a35a9@redhat.com>
Date:   Wed, 1 Jul 2020 18:00:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200630193540.GH7733@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/20 21:35, Sean Christopherson wrote:
> Ping.
> 
> On Mon, Jan 27, 2020 at 06:30:11AM -0800, Aaron Lewis wrote:
>> On Sat, Jan 25, 2020 at 11:16 PM Krish Sadhukhan
>> <krish.sadhukhan@oracle.com> wrote:
>>>
>>>
>>> On 1/24/20 3:46 PM, Sean Christopherson wrote:
>>>> Snapshot the delta of the last run and display it in the report if the
>>>> test fails.  Abort the run loop as soon as the threshold is reached so
>>>> that the displayed delta is guaranteed to a failed delta.  Displaying
>>>> the delta helps triage failures, e.g. is my system completely broken or
>>>> did I get unlucky, and aborting the loop early saves 99900 runs when
>>>> the system is indeed broken.
>>>>
>>>> Cc: Nadav Amit <nadav.amit@gmail.com>
>>>> Cc: Aaron Lewis <aaronlewis@google.com>
>>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>>> ---
>>>>   x86/vmx_tests.c | 11 ++++++-----
>>>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>>> index b31c360..4049dec 100644
>>>> --- a/x86/vmx_tests.c
>>>> +++ b/x86/vmx_tests.c
>>>> @@ -9204,6 +9204,7 @@ static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
>>>>
>>>>   static void rdtsc_vmexit_diff_test(void)
>>>>   {
>>>> +     unsigned long long delta;
>>>>       int fail = 0;
>>>>       int i;
>>>>
>>>> @@ -9226,17 +9227,17 @@ static void rdtsc_vmexit_diff_test(void)
>>>>       vmcs_write(EXI_MSR_ST_CNT, 1);
>>>>       vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
>>>>
>>>> -     for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
>>>> -             if (rdtsc_vmexit_diff_test_iteration() >=
>>>> -                 HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
>>>> +     for (i = 0; i < RDTSC_DIFF_ITERS && fail < RDTSC_DIFF_FAILS; i++) {
>>>> +             delta = rdtsc_vmexit_diff_test_iteration();
>>>> +             if (delta >= HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
>>>>                       fail++;
>>>>       }
>>>>
>>>>       enter_guest();
>>>>
>>>>       report(fail < RDTSC_DIFF_FAILS,
>>>> -            "RDTSC to VM-exit delta too high in %d of %d iterations",
>>>> -            fail, RDTSC_DIFF_ITERS);
>>>> +            "RDTSC to VM-exit delta too high in %d of %d iterations, last = %llu",
>>>> +            fail, i, delta);
>>>>   }
>>>>
>>>>   static int invalid_msr_init(struct vmcs *vmcs)
>>> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>
>> Reviewed-by: Aaron Lewis <aaronlewis@google.com>
> 

Queued, thanks.

Paolo

