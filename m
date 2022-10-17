Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BF96007BD
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 09:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJQHaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 03:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJQHaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 03:30:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB423203
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:30:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 70so10203925pjo.4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 00:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5dVsPg1briYoU/F1ZZ7mOmHR7nLeB9Tu8pU8JWVFWdk=;
        b=qbDhZx/MhTEUwtgEnXL+us+0RTWXiSXjIZ/YpoSg1HSFJKb8/46xcWrrppH/YBObUj
         idto80pxChNnskTkE4AsED2q7/pg9xEVBHq9F22qRI0eJewlZEEfIZDPn1I55i2/9flB
         +S5j9Pe9dVoJgXuZBs+5QcXlgwXrnXjm9PRFYuC7/1rh8loC/pOtvOzI5CwanVJblGHV
         p6/4Oc9wQUlZ7T9VgpNhmNXaoqdIUa3kta0C5d3Ejqvru6dfzUYZb74IWBby8iMQZV2F
         0yvpS8z+pc96bAHQ/lYTUwllkxkP0IZUvxDvWcEeiCRB5eaqRCO/IL6QtoaOqsjrB0qM
         2e6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5dVsPg1briYoU/F1ZZ7mOmHR7nLeB9Tu8pU8JWVFWdk=;
        b=vInk553IzHzX0iErcDw/fxZjfxtYx7m1iC/uusQdLQZFx4yAdguNXSldRxr40B4jp8
         /I/ED41rhb0k2YS99U6qSW47BQWdHZGRnplgjAgIrtvzooT/sn2Vw1G+U/UD3B+IqRWa
         nJxPwGvQUAWtpxuw7ee3YxH4NtvJbU7mOAtomdbtftQ0KnS3ui8Uk8unfU2X0zGW57MK
         oT5pU2Brb+xsn7Eg3k31LTxv0HDJ2LgEdTjkmSL4a1S79LELry8gm8199Ff8/hX0PwsH
         feFj14qHcF0srl04LAKoDISSc2PuUf38IKwCBoLSCP+XFgXT7JrxVzK/hivI1jcVorBq
         6r1Q==
X-Gm-Message-State: ACrzQf2hvSKtVTF4So6fcjquHyLZa7iAPZxTHtyIbiy2TsMGVvFiui5b
        RqrvTpBB8AAbfeYi72sCwPs=
X-Google-Smtp-Source: AMsMyM63WiQbKpqzsg28MvpRGScAmUt/Wd92QQaY9H877hv1cWEI0583arGkK21ad3W4w0uSJHGhuw==
X-Received: by 2002:a17:903:2284:b0:185:3948:be7c with SMTP id b4-20020a170903228400b001853948be7cmr10778836plh.51.1665991817168;
        Mon, 17 Oct 2022 00:30:17 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902a50600b001767f6f04efsm5872961plq.242.2022.10.17.00.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 00:30:16 -0700 (PDT)
Message-ID: <2401d7da-9c71-4472-10b7-92f0a479ad50@gmail.com>
Date:   Mon, 17 Oct 2022 15:30:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH v3 03/13] x86/pmu: Reset the expected count
 of the fixed counter 0 when i386
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-4-likexu@tencent.com> <Yz4Ct/rxI2EZ+I7o@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yz4Ct/rxI2EZ+I7o@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/2022 6:18 am, Sean Christopherson wrote:
> On Fri, Aug 19, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> The pmu test check_counter_overflow() always fails with the "./configure
>> --arch=i386".
> 
> Explicitly state that the failures are with 32-bit binaries.  E.g. I can and do
> run KUT in 32-bit VMs, which doesn't require the explicit --arch=i386.

True and applied.

> 
>> The cnt.count obtained from the latter run of measure()
>> (based on fixed counter 0) is not equal to the expected value (based
>> on gp counter 0) and there is a positive error with a value of 2.
>>
>> The two extra instructions come from inline wrmsr() and inline rdmsr()
>> inside the global_disable() binary code block. Specifically, for each msr
>> access, the i386 code will have two assembly mov instructions before
>> rdmsr/wrmsr (mark it for fixed counter 0, bit 32), but only one assembly
>> mov is needed for x86_64 and gp counter 0 on i386.
>>
>> Fix the expected init cnt.count for fixed counter 0 overflow based on
>> the same fixed counter 0, not always using gp counter 0.
> 
> You lost me here.  I totally understand the problem, but I don't understand the
> fix.

The sequence of instructions to count events using the #GP and #Fixed counters 
is different.
Thus the fix is quite high level, to use the same counter (w/ same instruction 
sequences) to
set initial value for the same counter.

I may add this to the commit message.

> 
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   x86/pmu.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 45ca2c6..057fd4a 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -315,6 +315,9 @@ static void check_counter_overflow(void)
>>   
>>   		if (i == nr_gp_counters) {
>>   			cnt.ctr = fixed_events[0].unit_sel;
>> +			__measure(&cnt, 0);
>> +			count = cnt.count;
>> +			cnt.count = 1 - count;
> 
> This definitely needs a comment.
> 
> Dumb question time: if the count is off by 2, why can't we just subtract 2?

More low-level code (bringing in differences between the 32-bit and 64-bit runtimes)
being added would break this.

The test goal is simply to set the initial value of a counter to overflow, which 
is always
off by 1, regardless of the involved rd/wrmsr or other execution details.

> 
> #ifndef __x86_64__
> 			/* comment about extra MOV insns for RDMSR/WRMSR */
> 			cnt.count -= 2;
> #endif
> 
>>   			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
>>   		}
>>   
>> -- 
>> 2.37.2
>>
