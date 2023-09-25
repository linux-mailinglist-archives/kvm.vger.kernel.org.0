Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E94F7AD1CA
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbjIYHeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjIYHeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:34:05 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38337E3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 00:33:59 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c1ff5b741cso52762325ad.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 00:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695627238; x=1696232038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xoq9tonJDF7O8TjeJt+gs97EwKEgJk3CGCFSg15mnDg=;
        b=Y0UekZAb1L7fMJoQ6Tiv1sCbk/QvfX2nGIvPfLznKebV1WCoY45/A0rjQMQkNmshf0
         3LTm8TRnyoXVOVJ6zx9LmK9C9tlJ03Aa/wI7PMWuEtnfvOLKHNJ+JEHQoNPi+MENClOf
         iytpZBJ2kWdECufkmAbOA6lHr9dMFwqlq4zTqrubKRK94WRVOvpAdmPJoq3jqYNHoY8l
         mkaCJChXbHYyPdokBKqfx3PSmn3qvjXe3+Ho4yRBevqr3QaKnY9eKx5LhoEcDPPcVaZv
         IEG5yt1F0StPG4J8elofUNf7wM7EhfKh6Sg1dMIPfJ7wQM6kVmKET2ph+L8buMp03gUt
         fL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695627238; x=1696232038;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xoq9tonJDF7O8TjeJt+gs97EwKEgJk3CGCFSg15mnDg=;
        b=vL6nkrAdq//eW3tvNmJrHZMQd5I0+0XRN/VgmkOROfLhWV9pUCdyj0tYoAfLCKCJxX
         iD/gmxp5aMcSYc3RCmkRL6hwPdN90Whn8FKk6UjcODwROBWHWcZ2d4/3KKKTK725NQGT
         szb8yCO6X/1aR4WNWiQEerD8g5a+EF8gQqzUVVRR4IyBctoy5CMZ2TWRwd2n3H6ouHWM
         IZjv1DkqJ/J9qCwGkg3eWkQxJseTJoSDppmW+UhZ1WhlpwO/9qjOBdGYOx9n+OZ8gLZ2
         YJMfeIVVBO8bmXHFe4fStuoEUON2y8rPBSfhkJ5LEexYY8Fa8wihlLo45avS1G7uDMvq
         P71w==
X-Gm-Message-State: AOJu0Yzo8bSwonYNIvEuhhuUJvbLLgePYHrX48gAriWBbptOn3Qh4GoO
        XnKyIvYb/OfuFioi19DttQY=
X-Google-Smtp-Source: AGHT+IHzk/vqDuwR904ckgo3sge4s+85ATpkmiKMm2s9v1tdkrJTMUR51nik+ek3lgbYRQlnnc8cUw==
X-Received: by 2002:a17:902:e888:b0:1c5:ba50:2b28 with SMTP id w8-20020a170902e88800b001c5ba502b28mr8160737plg.25.1695627238632;
        Mon, 25 Sep 2023 00:33:58 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b001b53c8659fesm8036805plb.30.2023.09.25.00.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 00:33:57 -0700 (PDT)
Message-ID: <555b7c91-4fbb-b18d-d425-7f5259fce5db@gmail.com>
Date:   Mon, 25 Sep 2023 15:33:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
References: <20230901185646.2823254-1-jmattson@google.com>
 <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZQ3pQfu6Zw3MMvKx@google.com>
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

On 23/9/2023 3:21 am, Sean Christopherson wrote:
> On Fri, Sep 22, 2023, Jim Mattson wrote:
>> On Fri, Sep 22, 2023 at 11:46 AM Sean Christopherson <seanjc@google.com> wrote:
>>>
>>> On Fri, Sep 01, 2023, Jim Mattson wrote:
>>>> When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
>>>> VM-exit that also invokes __kvm_perf_overflow() as a result of
>>>> instruction emulation, kvm_pmu_deliver_pmi() will be called twice
>>>> before the next VM-entry.
>>>>
>>>> That shouldn't be a problem. The local APIC is supposed to
>>>> automatically set the mask flag in LVTPC when it handles a PMI, so the
>>>> second PMI should be inhibited. However, KVM's local APIC emulation
>>>> fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
>>>> are delivered via the local APIC. In the common case, where LVTPC is
>>>> configured to deliver an NMI, the first NMI is vectored through the
>>>> guest IDT, and the second one is held pending. When the NMI handler
>>>> returns, the second NMI is vectored through the IDT. For Linux guests,
>>>> this results in the "dazed and confused" spurious NMI message.
>>>>
>>>> Though the obvious fix is to set the mask flag in LVTPC when handling
>>>> a PMI, KVM's logic around synthesizing a PMI is unnecessarily
>>>> convoluted.
>>>
>>> To address Like's question about whether not this is necessary, I think we should
>>> rephrase this to explicitly state this is a bug irrespective of the whole LVTPC
>>> masking thing.
>>>
>>> And I think it makes sense to swap the order of the two patches.  The LVTPC masking
>>> fix is a clearcut architectural violation.  This is a bit more of a grey area,
>>> though still blatantly buggy.
>>
>> The reason I ordered the patches as I did is that when this patch
>> comes first, it actually fixes the problem that was introduced in
>> commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring
>> instructions"). If this patch comes second, it's less clear that it
>> fixes a bug, since the other patch renders this one essentially moot.
> 
> Yeah, but as Like pointed out, the way the changelog is worded just raises the
> question of why this change is necessary.
> 
> I think we should tag them both for stable.  They're both bug fixes, regardless
> of the ordering.
> 

In the semantics of "at most one PMI per VM exit", what if the PMI-caused
vm-exit itself triggers a guest counter overflow and triggers vPMI (for
example, at this time the L1 guest is counting the number of vm-exit events
from the L2 guest), will the latter interrupt be swallowed by L0 KVM ? What
is the correct expectation ? It may be different on Intel and AMD.
