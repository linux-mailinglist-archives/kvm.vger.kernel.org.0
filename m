Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E1D4529F4
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbhKPFrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhKPFrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:47:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC80C04A53A
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 19:22:42 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso1580089pjo.3
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 19:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=PhZPKoJfbVoRS8bFL10GXiWbSMVHmrDdqtwYLPzmlFU=;
        b=lhy8Qqkre/oDSSVt/DZwL+6QyPpFhsonCyFjggeLQyaYiTW+vz5de3jHqYBPGU6nqf
         x4aSzXEO0CISBfleoYzlH4m5WPcchgti5ul+9YD61bcBeXdRfTE7W/HjFM2WWYNJwktj
         c0TqGSZWbuXeaxuC8IVGZCIbEvLis+cfcgwZmqUKbkWSbsJMndP1JVTxh0iFKPEEngHq
         Ms+o/AlPtV5HFtHooaM2mId3KMbnBLqtsBVClNCx2MbF3IhIhfcv+KF6hk77PDXsva0n
         cIydg8VNDA/Cked9AxxHvcwGkQwkvxkLmzHVG5u9U77TzNhLFisoxoWrOUdc/3U/Pvo+
         Ptxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=PhZPKoJfbVoRS8bFL10GXiWbSMVHmrDdqtwYLPzmlFU=;
        b=8AaGj4cUE62vqoiT58g/0IGYd6TgOPwikWrtKjEBu7YWssld7zel4J9AyAoNU40kIo
         R2KLskJx6EGdrS1G8g4V71qxv+OZpO21peIcqc+0pq+VRG0hxwAAV6MJltf5EwUJlabl
         60A1uB3G1TndgyP825JDTY4jGcrZCjmQsRfJLH5CVN+eKBRlPTidUAPfMMrBoF8sTTzG
         YptRMn3NovfyStPrXvS/w68dCu7mGA7xcHX+cBTPYGGCwNsl1LhmHXBb/w9lfd4LlJOR
         yv8U+fjF2hI0R2baRzX5o3l7IgeDLP0Wyg0P69/FusyQh6QzS5BGbXd3OFJ1vST3Dzqw
         VWZg==
X-Gm-Message-State: AOAM531CL+qN39TXRuMCx6HV6a1jmA/rKs6c9U0KSLabGJfmZr3gifl/
        fFM9skxukWPQ4zGK4DdErHA=
X-Google-Smtp-Source: ABdhPJy2g72XCIFfUfr6x0IxtytRu1Wa0QUPp0jOcvEl2CS8pNPeNECeDVu6G8QNrTrijAPi5RXSrQ==
X-Received: by 2002:a17:902:8544:b0:142:66e7:afbb with SMTP id d4-20020a170902854400b0014266e7afbbmr41990186plo.62.1637032962203;
        Mon, 15 Nov 2021 19:22:42 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id oj11sm643764pjb.46.2021.11.15.19.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 19:22:41 -0800 (PST)
Message-ID: <96170437-1e00-7841-260e-39d181e7886d@gmail.com>
Date:   Tue, 16 Nov 2021 11:22:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org,
        "Inc. (kernel-recipes.org)" <pbonzini@redhat.com>
References: <20211112235235.1125060-1-jmattson@google.com>
 <d4f3b54a-3298-cec3-3193-da46ae9a1f09@gmail.com>
 <CALMp9eQ+dy4TmuNRDipN6XWb4Q0KoEMv6u+-E8b4ypbkpJxdXA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 0/2] kvm: x86: Fix PMU virtualization for some basic
 events
In-Reply-To: <CALMp9eQ+dy4TmuNRDipN6XWb4Q0KoEMv6u+-E8b4ypbkpJxdXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

On 16/11/2021 1:51 am, Jim Mattson wrote:
> On Sun, Nov 14, 2021 at 7:43 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 13/11/2021 7:52 am, Jim Mattson wrote:
>>> Google Cloud has a customer that needs accurate virtualization of two
>>> architected PMU events on Intel hardware: "instructions retired" and
>>> "branch instructions retired." The existing PMU virtualization code
>>> fails to account for instructions that are emulated by kvm.
>>
>> Does this customer need to set force_emulation_prefix=Y ?
> 
> No. That module parameter does make it easier to write the test, though.
> 
> It's possible that the L0 hypervisor will never emulate a branch
> instruction for this use case. However, since the code being
> instrumented is potential malware, one can't make the usual
> assumptions about "well-behaved" code. For example, it is quite
> possible that the code in question deliberately runs with the TLBs and
> in-memory page tables out of sync. Therefore, it's hard to prove that
> the "branch instructions retired" patch isn't needed.

Thanks for your input.

> 
>> Is this "accurate statistics" capability fatal to the use case ?
> 
> Yes, that is my understanding.

Uh, looks like it's right time to do this.

> 
>>>
>>> Accurately virtualizing all PMU events for all microarchitectures is a
>>> herculean task, but there are only 8 architected events, so maybe we
>>> can at least try to get those right.
>>
>> I assume you mean the architectural events "Instruction Retired"
>> and "Branch Instruction Retired" defined by the Intel CPUID
>> since it looks we don't have a similar concept on AMD.
> 
> Yes.
> 
>> This patch set opens Pandora's Box, especially when we have
>> the real accurate Guest PEBS facility, and things get even
>> more complicated for just some PMU corner use cases.
> 
> KVM's PMU virtualization is rife with bugs, but this patch set doesn't
> make that worse. It actually makes things better by fixing two of
> those bugs.

Yes, I can't agree more.

> 
>>>
>>> Eric Hankland wrote this code originally, but his plate is full, so
>>> I've volunteered to shepherd the changes through upstream acceptance.
>>
>> Does Eric have more code to implement
>> accurate virtualization on the following events ?
> 
> No. We only offer PMU virtualization to one customer, and that
> customer is only interested in the two events addressed by this patch
> set.

Fine to me and I'll start looking at the code.

> 
>> "UnHalted Core Cycles"
>> "UnHalted Reference Cycles"
>> "LLC Reference"
>> "LLC Misses"
>> "Branch Misses Retired"
>> "Topdown Slots" (unimplemented)
>>
>> Obviously, it's difficult, even absurd, to emulate these.
> 
> Sorry; I should not have mentioned the eight architected events. It's
> not entirely clear what some of these events mean in a virtual
> environment. Let's just stick to the two events covered by this patch
> set.

Thanks for the clarification.

> 
>>> Jim Mattson (2):
>>>     KVM: x86: Update vPMCs when retiring instructions
>>>     KVM: x86: Update vPMCs when retiring branch instructions
>>>
>>>    arch/x86/kvm/emulate.c     | 57 +++++++++++++++++++++-----------------
>>>    arch/x86/kvm/kvm_emulate.h |  1 +
>>>    arch/x86/kvm/pmu.c         | 31 +++++++++++++++++++++
>>>    arch/x86/kvm/pmu.h         |  1 +
>>>    arch/x86/kvm/vmx/nested.c  |  6 +++-
>>>    arch/x86/kvm/x86.c         |  5 ++++
>>>    6 files changed, 75 insertions(+), 26 deletions(-)
>>>
