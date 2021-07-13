Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76153C6E4A
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhGMKTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhGMKTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 06:19:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9864EC0613DD;
        Tue, 13 Jul 2021 03:16:16 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a127so19108828pfa.10;
        Tue, 13 Jul 2021 03:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pZ+kJIZpqwPna83byG9/WJMMnZqY/UkbffT9YAmCx5Y=;
        b=FggyFQ1hdkSBHPNsyxE7wgkRDUf+2lrqhQYPR+9om9qKy71AO7QUa2bAULnsN7CFD2
         hjV4k+E1rbfgUMW/6LiVe1tFlOpp5sbigFNT9rb8Zg1ImEugjwMLr7AhEWfm4+3xGr7C
         U5eyOLNgIOWiRTKXZQT5c1pN1uMKTLnZhd7hnYFof7o5MQw2eDVVbshIw9kkLiqmbtnQ
         3AAJ71AYWh/oYG8spKS435N19+ChT3/QAK7C9GBSaJPwGT8YXSWifElDljPREMv+Yhca
         tVBwwS131a4tZ7KfuaNEB1TXq8HKKL2pdRMMT3TMQzoJ9cQ6Mc4ehR39xL6Jc1FkdJpO
         ekBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZ+kJIZpqwPna83byG9/WJMMnZqY/UkbffT9YAmCx5Y=;
        b=DybDQU0hB4R8zZDC6CtpR2Imtcsid6FgWJRn4qfQdfF8BNHVC1ZPzQ98mzF99SvFdg
         QpbzWux5uP4LPGJg0Yz1PUSNrFo9gDLFqLK0OaCEeQ1+n2IjcuS96BAC2Z6hK3f1y2CX
         rW+RgXlJ0K/dHtKq11Crc6PXhnvThHxidAt4AGztHOF1weUwxokL1RJgIp/NGRgxKWmu
         Uf6XAoLk4TwYCnWqsfrNdLUmCo7HkjCGmn8YyOdUiMpVTgeQEiQ1+gbR+fTcjvjDRpCY
         t0Ods9fmruyC69owB0hbQh/80cgFGzVYwEBIgCOurxSEiZm69EB41hVQnk2QeEBgc9Qt
         I/ag==
X-Gm-Message-State: AOAM531Cc0g7Lpd8vl++hZu8llGM3sVFwZJrYAWicmoy34n7Uy+IDusI
        y8jzrxjHkdnD0UaQ2u4Lcpc2SnWw1dtQOowJ
X-Google-Smtp-Source: ABdhPJzzwC6RpHs3l+fl6fcP04Rduib3eXMpIf9Z3Z5X9sYmQ+cWiYU4vvptjSzzgwNWOeBlPoiI5g==
X-Received: by 2002:a65:5086:: with SMTP id r6mr3566071pgp.237.1626171375987;
        Tue, 13 Jul 2021 03:16:15 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x10sm14944114pfr.150.2021.07.13.03.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 03:16:15 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <20210712095034.GD12162@intel.com>
 <CALMp9eQLHfXQwPCfqtc_y34sKGkZsCxEFL+BGx8wHgz7A8cOPA@mail.gmail.com>
 <20210713094713.GB13824@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL
 state
Message-ID: <1be1fde6-37c5-4697-cff0-b15af419975e@gmail.com>
Date:   Tue, 13 Jul 2021 18:16:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713094713.GB13824@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/7/2021 5:47 pm, Yang Weijiang wrote:
> On Mon, Jul 12, 2021 at 10:23:02AM -0700, Jim Mattson wrote:
>> On Mon, Jul 12, 2021 at 2:36 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>
>>> On Fri, Jul 09, 2021 at 03:54:53PM -0700, Jim Mattson wrote:
>>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>>>
>>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
>>>>> and reload it after vm-exit.
>>>>
>>>> I don't see anything being done here "before VM-entry" or "after
>>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
>>>>
>>>> In any case, I don't see why this one MSR is special. It seems that if
>>>> the host is using the architectural LBR MSRs, then *all* of the host
>>>> architectural LBR MSRs have to be saved on vcpu_load and restored on
>>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
>>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
>>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
>>> I looked back on the discussion thread:
>>> https://patchwork.kernel.org/project/kvm/patch/20210303135756.1546253-8-like.xu@linux.intel.com/
>>> not sure why this code is added, but IMO, although fpu save/restore in outer loop
>>> covers this LBR MSR, but the operation points are far away from vm-entry/exit
>>> point, i.e., the guest MSR setting could leak to host side for a signicant
>>> long of time, it may cause host side profiling accuracy. if we save/restore it
>>> manually, it'll mitigate the issue signifcantly.
>>
>> I'll be interested to see how you distinguish the intermingled branch
>> streams, if you allow the host to record LBRs while the LBR MSRs
>> contain guest values!

The guest is pretty fine that the real LBR MSRs contain the guest values
even after vm-exit if there is no other LBR user in the current thread.

(The perf subsystem makes this data visible only to the current thread)

Except for MSR_ARCH_LBR_CTL, we don't want to add msr switch overhead to
the vmx transaction (just think about {from, to, info} * 32 entries).

If we have other LBR user (such as a "perf kvm") in the current thread,
the host/guest LBR user will create separate LBR events to compete for
who can use the LBR in the the current thread.

The final arbiter is the host perf scheduler. The host perf will
save/restore the contents of the LBR when switching between two
LBR events.

Indeed, if the LBR hardware is assigned to the host LBR event before
vm-entry, then the guest LBR feature will be broken and a warning
will be triggered on the host.

LBR is the kind of exclusive hardware resource and cannot be shared
by different host/guest lbr_select configurations.

> I'll check if an inner simplified xsave/restore to guest/host LBR MSRs is meaningful,
> the worst case is to drop this patch since it's not correct to only enable host lbr ctl
> while still leaves guest LBR data in the MSRs. Thanks for the reminder!
> 
