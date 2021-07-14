Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434DA3C855C
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhGNNgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhGNNgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 09:36:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFA0C06175F;
        Wed, 14 Jul 2021 06:33:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id u14so2399764pga.11;
        Wed, 14 Jul 2021 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zXeJ5upciacjDJ+R0O8tajIDexHBhtbchVhzFOMwTgk=;
        b=VBBHOC5rZLUn9BjaxpBV2az1ka/YY2mtcfGvyhJkoWBW4C6p08XBCwkPGMaLOrQd8U
         2q8ao+bF3Gr6NVqQZA3UCC/9mO3P8y6MIsGux0lDxbIPYWQF/xIuL/CdrhTrBdqQL5fE
         joZsunPXTNt7nws1LOfgVvgkoJlKYhzSSlPUtDZGUl9OAC8XHydtEtk9EOn4ycrFmzFX
         cuSqod6mHioeTh6zfKHZ0afNXiZChdCVJuwbSFLX+KmMRFnhgntvzgfKHtWqsRyYKAcX
         YwxY13BrVRrMhMv24CKR9ZuFzbaGDADvwKIn5dFYuDNMBH/snOjLubpl0Sblln8SCjJP
         i5EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zXeJ5upciacjDJ+R0O8tajIDexHBhtbchVhzFOMwTgk=;
        b=PScIR/Ibbg4YQ7umEVrMv4JVARXeQKluvjW7eK+lJIisVF/BUvQJ0c22NWFtHXwbKK
         dyMssIs0AZe+94juWJ5FLXfsu6vVXE4kzvpkc/VNM3sTTtNYTRPJb7FC0rXi2av4liig
         QHar6BXINeIwA5AaB0WZuzJN3TUi3D8tAWXzp+iTMvjxtU2A8rrGbnjnOF+zaxYVxF76
         Kj2JROVWLWfjonobzCV2EYxZiq+OO0/nR2aVfjnZDr4L/Q2DuP5f5VAH6pLacZ2BNFay
         e+EYpt/+bJ8zW4PrWTZhYAcxXoZauzAJKtbMullntU3MUd57yznsaaFYlxoaS5jOoUQI
         mJ+g==
X-Gm-Message-State: AOAM533saLuHMqFgWgRTF1+5JsNnIi4BZlCajwT6CSHex1veUEfSMZ2c
        XLYOLW2xGIIdLPt77u9j+Ng=
X-Google-Smtp-Source: ABdhPJzD0xh+BNL1MmJj8lN/oi8ZHi5fuiKMhAxbWe7f70VJbnvlqatZV4uFTACZA2B4pRf/AVMbjQ==
X-Received: by 2002:a65:5648:: with SMTP id m8mr9812707pgs.93.1626269633846;
        Wed, 14 Jul 2021 06:33:53 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i8sm2796525pfo.154.2021.07.14.06.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 06:33:53 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
 <20210712095305.GE12162@intel.com>
 <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
 <CALMp9eQmK+asv7fXeUpF2UiRKL7VmZx44HMGj67aSqm0k9nKVg@mail.gmail.com>
 <CALMp9eSWDmWerj5CaxRyMiNqnBf1akHHaWV2Cfq_66Xjg-0MEw@mail.gmail.com>
 <12a3e8e4-3183-9917-c9d5-59ab257b8fd3@gmail.com>
 <CALMp9eROgWVBe1NuqD46xbgXHedgAFW1EMFX5zW-_Ee5enHmnw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL
 state
Message-ID: <cb4c1daa-f7a3-4f9c-fcdd-6a91e0dbcab4@gmail.com>
Date:   Wed, 14 Jul 2021 21:33:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eROgWVBe1NuqD46xbgXHedgAFW1EMFX5zW-_Ee5enHmnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/7/2021 1:00 am, Jim Mattson wrote:
> On Tue, Jul 13, 2021 at 2:49 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 13/7/2021 1:45 am, Jim Mattson wrote:
>>> On Mon, Jul 12, 2021 at 10:20 AM Jim Mattson <jmattson@google.com> wrote:
>>>>
>>>> On Mon, Jul 12, 2021 at 3:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>>
>>>>> On 12/7/2021 5:53 pm, Yang Weijiang wrote:
>>>>>> On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
>>>>>>> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wrote:
>>>>>>>>
>>>>>>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>>>>>>>
>>>>>>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
>>>>>>>>> and reload it after vm-exit.
>>>>>>>>
>>>>>>>> I don't see anything being done here "before VM-entry" or "after
>>>>>>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
>>>>>>>>
>>>>>>>> In any case, I don't see why this one MSR is special. It seems that if
>>>>>>>> the host is using the architectural LBR MSRs, then *all* of the host
>>>>>>>> architectural LBR MSRs have to be saved on vcpu_load and restored on
>>>>>>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
>>>>>>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
>>>>>>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
>>>>>>>
>>>>>>> It does seem like there is something special about IA32_LBR_DEPTH, though...
>>>>>>>
>>>>>>> Section 7.3.1 of the Intel® Architecture Instruction Set Extensions
>>>>>>> and Future Features Programming Reference
>>>>>>> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
>>>>>>> XRSTORS in any circumstance." It seems like that would require some
>>>>>>> special handling if the host depth and the guest depth do not match.
>>>>>> In our vPMU design, guest depth is alway kept the same as that of host,
>>>>>> so this won't be a problem. But I'll double check the code again, thanks!
>>>>>
>>>>> KVM only exposes the host's depth value to the user space
>>>>> so the guest can only use the same depth as the host.
>>>>
>>>> The allowed depth supplied by KVM_GET_SUPPORTED_CPUID isn't enforced,
>>>> though, is it?
>>
>> Like other hardware dependent features, the functionality will not
>> promise to work properly if the guest uses the unsupported CPUID.
> 
> It's fine if it doesn't work in the guest, but can't a guest with the
> wrong depth prevent the host LBRs from being reloaded when switching
> back to the host state? It's definitely not okay for an ill-configured
> guest to break host functionality.

If the ownership of LBR changes, there must be two (or more) LBR events
for perf event scheduling switch for current task, and the perf
subsystem callback will save the previous LBR state and restore
the state of the next LBR event considering different depths.

> 
>>>
>>> Also, doesn't this end up being a major constraint on future
>>> platforms? Every host that this vCPU will ever run on will have to use
>>> the same LBR depth as the host on which it was started.
>>>
>>
>> As a first step, we made the guest LBR feature only available for the
>> "migratable=off" user space, which is why we intentionally did not add
>> MSR_ARCH_LBR_* stuff to msrs_to_save_all[] in earlier versions.
> 
> We have no such concept in our user space. Features that are not
> migratable should clearly be identified as such by an appropriate KVM
> API. At present, I don't believe there is such an API.

I couldn't agree with you more on this point.

We do have a code gap to make Arch LBR migratable for any KVM user.

> 
>> But hopefully, we may make it at least migratable for Arch LBR.
>>
>> I'm personally curious about the cost of using XSAVES to swicth
>> guest lbr msrs during vmx transaction, and if the cost is unacceptable,
>> we may ask the perf host to adjust different depths for threads.
>>
>>
> 
