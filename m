Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355583C85AE
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 15:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhGNN6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 09:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhGNN6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 09:58:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B03C06175F;
        Wed, 14 Jul 2021 06:55:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so1759862pjh.4;
        Wed, 14 Jul 2021 06:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jfy61O7CnDZNspxZoTcalOMZyVFtDPv1pHCSKpnr/nc=;
        b=M0vB7EnMeBINOscW5gE5EicXZ9oyveJbxRreO935F51AHtwQRFr/LeTQDgP740oiqV
         6ULACPR2EdL8Ua8ZZxUgMeMf5x7wzJ51ySEAXuRj5tzFw5xR7+TsvrX5YIyLBHva+BIK
         vpo2bUrENOBcXzhDRSG7qtU6A8iLHrWaRJY4F5hicGVwLz99QDd04f2oDWQ7o6OSnzyT
         CHObp7RH54KpLgUwExfwAloIbXt5bhS7XLmJOM/TWNnCVIbfWb7Jzmmx8TCLOz2b1HS1
         /BFb8XNTYlMr9+XRE6Pm5ZWzMlOPNCI/K77ZxIgFkA1XDQfM01d8CEwiEAkm4dZdP6hA
         f3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jfy61O7CnDZNspxZoTcalOMZyVFtDPv1pHCSKpnr/nc=;
        b=Tf6YiDwyvFgQavzTg5+YC4LAixVeqadOd5o/JdhU5a4vEARiasXz+YSampJLBK2vZV
         20h97ZU3dDHu47meB7znqV6/u0cW+uolXfzgfUo83+d4v8f9vykLDdLA6MXEZH5P3IDq
         eePZMpuOm8G8n2+m4sOJvEsNmwJd3eG2RV/LQ4dGHa8fDGdwsIPCiXHJz9hh5Fsq4UNf
         7mrt2SpJ60MaeKRB0PjCRGB9jXBm71ZbSxg6glLGNmso8r+i22AVBsdK/qLqdWLMa/FX
         luoQqib6SYpl5zi54eAA4gPWKtd7c8xcyqcY50qqWKdj5Q1WhFw0YQY8Rkh4rlurMh2q
         +chw==
X-Gm-Message-State: AOAM530IRqFDfZYI832IjXeq5+XzizILygn558TGSqEkWnAQjbcxZuOj
        /OT4tRD63Oii3uSldYehIj7ZWgaJhQosycM6
X-Google-Smtp-Source: ABdhPJwZPT5zHcdJyUPaMPNhlETDs49nfkW8iah1iH01Q+tqfBXppQgME5Yuq+ddnLKQbxACw/0QeA==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr3918725pjs.235.1626270952355;
        Wed, 14 Jul 2021 06:55:52 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a13sm3194347pfl.92.2021.07.14.06.55.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 06:55:51 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <20210712095034.GD12162@intel.com>
 <CALMp9eQLHfXQwPCfqtc_y34sKGkZsCxEFL+BGx8wHgz7A8cOPA@mail.gmail.com>
 <20210713094713.GB13824@intel.com>
 <1be1fde6-37c5-4697-cff0-b15af419975e@gmail.com>
 <CALMp9eSTVVH1fZ361o0Zpf8A3AG24efqGhM6tnYAbv0M5xyhZw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL
 state
Message-ID: <caa48772-0ac1-091b-7125-e30acfe7a107@gmail.com>
Date:   Wed, 14 Jul 2021 21:55:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSTVVH1fZ361o0Zpf8A3AG24efqGhM6tnYAbv0M5xyhZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/7/2021 1:12 am, Jim Mattson wrote:
> On Tue, Jul 13, 2021 at 3:16 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 13/7/2021 5:47 pm, Yang Weijiang wrote:
>>> On Mon, Jul 12, 2021 at 10:23:02AM -0700, Jim Mattson wrote:
>>>> On Mon, Jul 12, 2021 at 2:36 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>>>
>>>>> On Fri, Jul 09, 2021 at 03:54:53PM -0700, Jim Mattson wrote:
>>>>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>>>>>
>>>>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
>>>>>>> and reload it after vm-exit.
>>>>>>
>>>>>> I don't see anything being done here "before VM-entry" or "after
>>>>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
>>>>>>
>>>>>> In any case, I don't see why this one MSR is special. It seems that if
>>>>>> the host is using the architectural LBR MSRs, then *all* of the host
>>>>>> architectural LBR MSRs have to be saved on vcpu_load and restored on
>>>>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
>>>>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
>>>>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
>>>>> I looked back on the discussion thread:
>>>>> https://patchwork.kernel.org/project/kvm/patch/20210303135756.1546253-8-like.xu@linux.intel.com/
>>>>> not sure why this code is added, but IMO, although fpu save/restore in outer loop
>>>>> covers this LBR MSR, but the operation points are far away from vm-entry/exit
>>>>> point, i.e., the guest MSR setting could leak to host side for a signicant
>>>>> long of time, it may cause host side profiling accuracy. if we save/restore it
>>>>> manually, it'll mitigate the issue signifcantly.
>>>>
>>>> I'll be interested to see how you distinguish the intermingled branch
>>>> streams, if you allow the host to record LBRs while the LBR MSRs
>>>> contain guest values!
>>
>> The guest is pretty fine that the real LBR MSRs contain the guest values
>> even after vm-exit if there is no other LBR user in the current thread.
>>
>> (The perf subsystem makes this data visible only to the current thread)
>>
>> Except for MSR_ARCH_LBR_CTL, we don't want to add msr switch overhead to
>> the vmx transaction (just think about {from, to, info} * 32 entries).
>>
>> If we have other LBR user (such as a "perf kvm") in the current thread,
>> the host/guest LBR user will create separate LBR events to compete for
>> who can use the LBR in the the current thread.
>>
>> The final arbiter is the host perf scheduler. The host perf will
>> save/restore the contents of the LBR when switching between two
>> LBR events.
>>
>> Indeed, if the LBR hardware is assigned to the host LBR event before
>> vm-entry, then the guest LBR feature will be broken and a warning
>> will be triggered on the host.
> 
> Are you saying that the guest LBR feature only works some of the time?

If other LBR events preempt KVM-owned LBR events on the current CPU,
we lose the guest LBR feature in the next vm-entry time slice.

> How are failures communicated to the guest? If this feature doesn't
> follow the architectural specification, perhaps you should consider
> offering a paravirtual feature instead.

The failure notification *didn't* bring anything meaningful because
the guest lost the hardware support and the LBR data it captured.

> 
> Warnings on the host, by the way, are almost completely useless. How
> do I surface such a warning to a customer who has a misbehaving VM? At
> the very least, user space should be notified of KVM emulation errors,
> so I can get an appropriate message to the customer.

We have recommended in previous legacy LBR enabling commits
that CSP administrators would be better off not using LBR to
interfere with guest that has its own LBR enabled.

> 
>> LBR is the kind of exclusive hardware resource and cannot be shared
>> by different host/guest lbr_select configurations.
> 
> In that case, it definitely sounds like guest architectural LBRs
> should be a paravirtual feature, since you can't actually virtualize
> the hardware.

My earlier plan is to enable vmx-switch to handle the switching of
LBR msrs when we have another LBR event competing (maybe w/ XSAVES
help a lot on the overhead) and we expect that this competitive time
will be very short-lived. Or forcing the host perf to always make the
guest demand to be the first priority user in every situation, which
is even harder to get PeterZ to buy in.

> 
>>> I'll check if an inner simplified xsave/restore to guest/host LBR MSRs is meaningful,
>>> the worst case is to drop this patch since it's not correct to only enable host lbr ctl
>>> while still leaves guest LBR data in the MSRs. Thanks for the reminder!
>>>
> 
