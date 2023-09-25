Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752157AD10D
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjIYHGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjIYHGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:06:53 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5156BC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 00:06:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-68fe2470d81so5259710b3a.1
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 00:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695625606; x=1696230406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ePW41v7AClbaVK0zUaFptDYfuUi3UdGhGNCID917aro=;
        b=Bb1ZRNjAKawdId7LW9khT1JnNgh/eAE81jwfxnJKUEUufFCAuzAcZvEfvygt9wfDba
         YgIOvFQiEl+WMGX3Xi31IocOkdTSRhTIa1shZ2GFkGqMmJD7yx7ul5QrIJlp8cjSUjuR
         vlJ5rVH9QYVof8uPo+OzJC7UDTw/5YPm/GxNRMnQGU3+MvhHXXi96mwVlD6C1SV2qfBR
         8mCNG81DcV4w6ZuhyBf4EzCdsYk+zL/XGu9fZ+KsAVI0Vuo+qCGwnaO9859ClO1Zm0/v
         k37L48po6SifyE9PaPYPxUg08uWBb1s7riNeTW1kmgIJIC0HGxQGTnx9vmuoIOvD3TYe
         GfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695625606; x=1696230406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ePW41v7AClbaVK0zUaFptDYfuUi3UdGhGNCID917aro=;
        b=PLqIc9ntwy5FYQnPG5snAsMqiZce9pchq9niRqofI0j4lLENoKVAIrRFL7YpNkvFOS
         sh6TKT/lHEglT0aw7f0mzwUH7Uv8pQ+dpIlO3uqniUHXdLv0Ty4f47zY6cbCOL5FYPV1
         6MfBhMYkbDABqPNQMfyLlxoDfnvSfaf/lIcO2CxaqvS7KV80fsG+6EbfmNTIlym9MVS2
         qLC1PORgD6LSR3jwBwyoS8UDc2ezvRvbArKfMKJQXOODZ2q5W++SugCPDtF980WCzzk7
         WTKvk9fgoFuf0/a1N/7psgt7C/IT3iu1dYYyq3lkr56xNKvYCBXObwbWepv9YKbjDSKW
         sBHA==
X-Gm-Message-State: AOJu0YxKaU/RiU1DrZIr/hyGyJ19Zc3GKith8wxx3Il36b436Drz1lCy
        IsFm0a13QU+FqY8dD5UGHZE=
X-Google-Smtp-Source: AGHT+IGlDaSKKI/+kUv9POTpOs+gTRdHkyX669OOfJo+hCUgsRkDBeow1WUT5o6PQT8T7sdeA/qaIA==
X-Received: by 2002:a05:6a20:5509:b0:15d:ddeb:4a7e with SMTP id ko9-20020a056a20550900b0015dddeb4a7emr5770165pzb.49.1695625606216;
        Mon, 25 Sep 2023 00:06:46 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902d35300b001bc6e6069a6sm8045980plk.122.2023.09.25.00.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 00:06:45 -0700 (PDT)
Message-ID: <d5edc5b2-fce7-8b59-f630-7da8ec1dda1a@gmail.com>
Date:   Mon, 25 Sep 2023 15:06:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
References: <20230901185646.2823254-1-jmattson@google.com>
 <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com>
 <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com>
 <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4BvCsFjLmnSxhd@google.com>
 <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/9/2023 6:42 am, Mingwei Zhang wrote:
> On Fri, Sep 22, 2023 at 2:06 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
>>> On Fri, Sep 22, 2023 at 1:34 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>
>>>> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
>>>>> Agree. Both patches are fixing the general potential buggy situation
>>>>> of multiple PMI injection on one vm entry: one software level defense
>>>>> (forcing the usage of KVM_REQ_PMI) and one hardware level defense
>>>>> (preventing PMI injection using mask).
>>>>>
>>>>> Although neither patch in this series is fixing the root cause of this
>>>>> specific double PMI injection bug, I don't see a reason why we cannot
>>>>> add a "fixes" tag to them, since we may fix it and create it again.
>>>>>
>>>>> I am currently working on it and testing my patch. Please give me some
>>>>> time, I think I could try sending out one version today. Once that is
>>>>> done, I will combine mine with the existing patch and send it out as a
>>>>> series.
>>>>
>>>> Me confused, what patch?  And what does this patch have to do with Jim's series?
>>>> Unless I've missed something, Jim's patches are good to go with my nits addressed.
>>>
>>> Let me step back.
>>>
>>> We have the following problem when we run perf inside guest:
>>>
>>> [ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
>>> [ 1437.487330] Dazed and confused, but trying to continue
>>>
>>> This means there are more NMIs that guest PMI could understand. So
>>> there are potentially two approaches to solve the problem: 1) fix the
>>> PMI injection issue: only one can be injected; 2) fix the code that
>>> causes the (incorrect) multiple PMI injection.
>>
>> No, because the LVTPC masking fix isn't optional, the current KVM behavior is a
>> clear violation of the SDM.  And I'm struggling to think of a sane way to fix the
>> IRQ work bug, e.g. KVM would have to busy on the work finishing before resuming
>> the guest, which is rather crazy.
>>
>> I'm not saying there isn't more work to be done, nor am I saying that we shouldn't
>> further harden KVM against double-injection.  I'm just truly confused as to what
>> that has to do with Jim's fixes.
>>
> hmm, I will take the "two approaches" back. You are right on that.
> "two directions" is what I mean.
> 
> Oh, I think I did not elaborate the full context to you maybe. That
> might cause confusion and sorry about that.
> 
> The context of Jim's patches is to fix the multiple PMI injections
> when using perf, starting from
> https://lore.kernel.org/all/ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com/
> 
> So, regarding the fix, there are multiple layers and they may or may
> not be logically connected closely, but we are solving the same
> problem. In fact, I was asking Jim to help me with this specific issue
> :)
> 
> So yes, they could be put together and they could be put separately.
> But I don't see why they _cannot_ be together or cause confusion. So,
> I would like to put them together in the same context with a cover
> letter fully describing the details.
> 
> FYI for reviewers: to reproduce the spurious PMI issue in the guest
> VM, you need to let KVM emulate some instructions during the runtime,
> so the function kvm_pmu_incr_counter() will be triggered more. One
> option is to add a kernel cmdline like "idle=nomwait" to your guest
> kernel. Regarding the workload in guest vm, please run the perf
> command specified in
> https://lore.kernel.org/all/ZKCD30QrE5g9XGIh@google.com/

Hi Mingwei,

I would encourage you to convert this perf use case into a sequence of MSRs
accesses so that it's easier to understand where the emulation fails on KVM.

> 
> Thanks.
> -Mingwei
> 
> 
> 
> -Mingwei
> 
