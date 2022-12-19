Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A126509C0
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 11:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiLSKDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 05:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiLSKDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 05:03:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D40721A9
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 02:03:07 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w26so5851610pfj.6
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 02:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o8qF45gRt+DDxbPoBOwLq5gI0X9GK8K9lK2FeNB4ZbI=;
        b=OVsC/JqVnQqD2ewslQrO0vlgWZhCwX5M37sHjSEjc71UAVeYQwNo+LyywiBSEO/Bvg
         rlWG5IUTJPQbDSBklwnNZEPH/nC2LxDFBvfrzuAQi9ErT0FagSHXXv/kdzDE8qarmMak
         sTrK9sSuOTj6A8VX7kCHOTC+J4czpT38kAEaynHppEH5XsQgF5LD5gVrm6OhNso79wtw
         IUbBBSPAr8zncSXBX9cI1W5iBdGLl0szzUS4vPq/hV18ZiPQg+ZpVTzgRNzuhaUY7xd5
         sqzh0uy/3CGVTq6FQpEVyKwyG2E74hLHAk1pS8YBenY2TQCijB1dhwKh2x1J8d+PJkNB
         79ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o8qF45gRt+DDxbPoBOwLq5gI0X9GK8K9lK2FeNB4ZbI=;
        b=thfg4fwiMYXsezjwxfNfs5HKVXjOO0Hocz8Es6jXy1miHdl8GhnwF0M39u/BbPObVw
         549H7b05MnLT5W2V9XIn9QlN/tKlFQWv57+fy7QOWqTP/1S2T5CfPXaE7ICjvQ/n09oO
         avhCayaZ4V8/rCuTQnGLlYa0hrA6WYq990Xzv173saG2cSBbZQNqBmQbG3Z+br6WWyTW
         GdA7m6R+gDgcbEdPuDotbwoT5XlcrZkxW4iVzu6UNErDqWXDyqDbhUtqP0vfh3d5b5uB
         NLMEAJxuZR2Wd66eDM3/SNXzRKvD5giAnIUDpvQv+TSAcmJ5qARz5+be8UwG9FdXJTBt
         0znQ==
X-Gm-Message-State: AFqh2kpi4Ia1XAgIcB0y2ZiDGjeo4tB4YwbsDh8KuUXc+3hazL7hOoL5
        Qpk/ac3xemTEh/MKqj5n/x0=
X-Google-Smtp-Source: AMrXdXsohDxCKKuvOxSq/WEQXAbCVwnxNNPwjt9DArMCb/NpSb/KYdoCi+LsUvALlzIEHbtYKqV/TQ==
X-Received: by 2002:a62:38cf:0:b0:57e:866d:c090 with SMTP id f198-20020a6238cf000000b0057e866dc090mr7088497pfa.19.1671444186789;
        Mon, 19 Dec 2022 02:03:06 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v6-20020aa799c6000000b0056b4c5dde61sm6364036pfi.98.2022.12.19.02.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 02:03:06 -0800 (PST)
Message-ID: <8348d759-2ff5-724d-7808-b205be246573@gmail.com>
Date:   Mon, 19 Dec 2022 18:02:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v6 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <20221021205105.1621014-5-aaronlewis@google.com>
 <3f0a7487-476c-071c-ece9-49a401982e40@gmail.com>
 <Y5yxIcc4g8EuhtZE@google.com>
 <CAAAPnDHvvCXo8qYpPFK=a7Ghtdf-Z-7sX5RmsgbRCjf_QmoYgA@mail.gmail.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CAAAPnDHvvCXo8qYpPFK=a7Ghtdf-Z-7sX5RmsgbRCjf_QmoYgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/2022 2:31 am, Aaron Lewis wrote:
> On Fri, Dec 16, 2022 at 9:55 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Thu, Dec 15, 2022, Like Xu wrote:
>>> On 22/10/2022 4:51 am, Aaron Lewis wrote:
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
>>>>    #define KVM_CAP_S390_ZPCI_OP 221
>>>>    #define KVM_CAP_S390_CPU_TOPOLOGY 222
>>>>    #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>>>> +#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 224
>>>
>>> I presume that the linux/tools code in google's internal tree
>>> can directly refer to the various definitions in the kernel headers.
>>>
>>> Otherwise, how did the newly added selftest get even compiled ?
>>
>> Magic fairy dust, a.k.a. `make headers_install`.  KVM selftests don't actually
>> get anything from tools/include/uapi/ or tools/arch/<arch>/include/uapi/, the
>> only reason the KVM headers are copied there are for perf usage.  And if it weren't
>> for perf, I'd delete them from tools/, because keeping them in sync is a pain.

LoL, how ignorant I am and thank you. Please review the below fix to see if it 
helps.
https://lore.kernel.org/kvm/20221219095540.52208-1-likexu@tencent.com/

>>
>> To get tools' uapi copies, KVM selftests would need to change its include paths
>> or change a bunch of #includes to do <uapi/...>.
>>
>>> Similar errors include "union cpuid10_eax" from perf_event.h
>>
>> I don't follow this one.  Commit bef9a701f3eb ("selftests: kvm/x86: Add test for
>> KVM_SET_PMU_EVENT_FILTER") added the union definition in pmu_event_filter_test.c
> 
> That's been replaced since posting.  The function num_gp_counters()
> needs to be placed with
> kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS).  I can update and
> repost.
> 

Yeah, please squeeze out a little time to spin a rebased version.
