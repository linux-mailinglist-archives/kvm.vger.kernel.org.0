Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CC4728A51
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 23:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbjFHViI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 17:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbjFHViH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 17:38:07 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29C12D7B
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 14:38:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f619c2ba18so1338784e87.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 14:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1686260284; x=1688852284;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jptUUroiLQfnhvX6xuvSOB6GWKC0IUevkabzP7688Xw=;
        b=ki/0goVXuxBLZwZqhEP2LNlL+ZfMUqYKfpyedOsYjIKx1EealYljoV/T3mBfp4F/zC
         OtG4j/fDIEwFqdKxTMVw1j7gkFg23S3PjO2Zk8wpRXlnTU97g9K9jdk/ksrx/f+5xoRF
         GpWJYjc+l0uNzkwz77gG0uUl6Amq8IB9QAB0Ibs42kT65gqymyICD62FApqx4giZxUHp
         S9WbmiyonPJnsS8YNv0PlEAEeA7XYO/f/pmmewv7DzgPN2kGLBbwRwwfs0tnwB+4mrXC
         8AMnw9NwjZlyWNS84XOpcrlm0Are9r+kMqaEz3pQ9tUQH1v4K9MrcA472Y/5onSOM8Pj
         2gAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686260284; x=1688852284;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jptUUroiLQfnhvX6xuvSOB6GWKC0IUevkabzP7688Xw=;
        b=BusZjLGbnlxP8Xu1hUQe6l2Bf6SQ763JFmc/VE0q7bm4OWkpgXS8HlXh090SWqnFxb
         iKkpNlPgrybyujReqtvG0dmWNvH/bivRmb7TiNjsCT2AjuoqOSZWm5Gz9mNjiPn64r6U
         LYFF9FyONNjtk3LEOMne/EFKxdY6cYlMdlJLOMYOha/Gl77z3EoALHbA0vf/jvWz1ISB
         nZk8akH/WvBVAD5aKYZbME0hGnwQEoy1lvdss9VQ5MRidJAYv+pd83qOMUkKggPwdRXR
         yMwrNTatPgwRNuRH7v5kaTCoW9BVlelZrJ33zpDE4Jg2rtvs4xmFhXMipE5N8MlDoggs
         kdjA==
X-Gm-Message-State: AC+VfDy+yPTxjpp3J6BBU3Qn706p/R2BKG6vWtd+fzlWxzvz5pQ2YsA0
        XO/dwzGpp6QZp9JpDb+ISSKmOQ==
X-Google-Smtp-Source: ACHHUZ5XQ6R3FGG7WoFwU/xErS0wYzuU2dRsvrSZ4zP2pB1fiUHfH7POydtDgGF61atpnqiQjQhHVQ==
X-Received: by 2002:a19:e307:0:b0:4f6:4f9a:706e with SMTP id a7-20020a19e307000000b004f64f9a706emr157792lfh.15.1686260283911;
        Thu, 08 Jun 2023 14:38:03 -0700 (PDT)
Received: from [10.43.1.253] ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id w11-20020ac2598b000000b004f252f48e5fsm312307lfn.40.2023.06.08.14.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 14:38:03 -0700 (PDT)
Message-ID: <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
Date:   Thu, 8 Jun 2023 23:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
To:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, android-kvm@google.com,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
Content-Language: en-US
From:   Dmytro Maluka <dmy@semihalf.com>
In-Reply-To: <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/23 17:29, Jason Chen CJ wrote:
> On Mon, Mar 13, 2023 at 09:58:27AM -0700, Sean Christopherson wrote:
>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>> This patch set is part-5 of this RFC patches. It introduces VMX
>>> emulation for pKVM on Intel platform.
>>>
>>> Host VM wants the capability to run its guest, it needs VMX support.
>>
>> No, the host VM only needs a way to request pKVM to run a VM.  If we go down the
>> rabbit hole of pKVM on x86, I think we should take the red pill[*] and go all the
>> way down said rabbit hole by heavily paravirtualizing the KVM=>pKVM interface.
> 
> hi, Sean,
> 
> Like I mentioned in the reply for "[RFC PATCH part-1 0/5] pKVM on Intel
> Platform Introduction", we hope VMX emulation can be there at least for
> normal VM support.
> 
>>
>> Except for VMCALL vs. VMMCALL, it should be possible to eliminate all traces of
>> VMX and SVM from the interface.  That means no VMCS emulation, no EPT shadowing,
>> etc.  As a bonus, any paravirt stuff we do for pKVM x86 would also be usable for
>> KVM-on-KVM nested virtualization.
>>
>> E.g. an idea floating around my head is to add a paravirt paging interface for
>> KVM-on-KVM so that L1's (KVM-high in this RFC) doesn't need to maintain its own
>> TDP page tables.  I haven't pursued that idea in any real capacity since most
>> nested virtualization use cases for KVM involve running an older L1 kernel and/or
>> a non-KVM L1 hypervisor, i.e. there's no concrete use case to justify the development
>> and maintenance cost.  But if the PV code is "needed" by pKVM anyways...
> 
> Yes, I agree, we could have performance & mem cost benefit by using
> paravirt stuff for KVM-on-KVM nested virtualization. May I know do I
> miss other benefit you saw?

As I see it, the advantages of a PV design for pKVM are:

- performance
- memory cost
- code simplicity (of the pKVM hypervisor, first of all)
- better alignment with the pKVM on ARM

Regarding performance, I actually suspect it may even be the least significant
of the above. I guess with a PV design we'd have roughly as many extra vmexits
as we have now (just due to hypercalls instead of traps on emulated VMX
instructions etc), so perhaps the performance improvement would be not as big
as we might expect (am I wrong?).

But the memory cost advantage seems to be very attractive. With the emulated
design pKVM needs to maintain shadow page tables (and other shadow structures
too, but page tables are the most memory demanding). Moreover, the number of
shadow page tables is obviously proportional to the number of VMs running, and
since pKVM reserves all its memory upfront preparing for the worst case, we
have pretty restrictive limits on the maximum number of VMs [*] (and if we run
fewer VMs than this limit, we waste memory).

To give some numbers, on a machine with 8GB of RAM, on ChromeOS with this
pKVM-on-x86 PoC currently we have pKVM memory cost of 229MB (and it only allows
up to 10 VMs running simultaneously), while on Android (ARM) it is afaik only
44MB. According to my analysis, if we get rid of all the shadow tables in pKVM,
we should have 44MB on x86 too (regardless of the maximum number of VMs).

[*] And some other limits too, e.g. on the maximum number of DMA-capable
devices, since pKVM also needs shadow IOMMU page tables if we have only 1-stage
IOMMU.

> 
>>
>> [*] You take the blue pill, the story ends, you wake up in your bed and believe
>>     whatever you want to believe. You take the red pill, you stay in wonderland,
>>     and I show you how deep the rabbit hole goes.
>>
>>     -Morpheus
> 
