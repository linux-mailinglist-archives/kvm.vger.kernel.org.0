Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674754529DF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhKPFlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbhKPFlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:41:10 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45908C0EC8DE
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 18:58:35 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x64so16787932pfd.6
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 18:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xMverpPQHd2aXy11wGVhC6qipjbjdcnBqS5cqjuisVU=;
        b=Jjz7X7nH6VliHviVpHU2kZanI4d+egfmAeVExFNVO2dAD4F/7297W0pyxkC0zDK3pi
         t+JeHO0ULvLrWogTa5TSdr6j9r2ri4qe8OYbWIF3MfXckfgyGFPQ0+H+Pkif+dNgWWI5
         3tJaz0VCAcvniDalXM/Y/IYrvwFGmRi0S8WagX3S/K0FBDSlv1Z8jIIiqE1pobcqR4B8
         RZ/3zlIoonxPjAw/bW2RAmqtVVjgm8bu8IXVcQWVuJJcQIUHw5KzFz66fcKgE2PBPusp
         +jD7TyE12hx43fNODKCq2OMGcMh7a3OW2CfibGH3nC3uRWAlRQM1cvY7DCmad5KEvuC9
         iR5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xMverpPQHd2aXy11wGVhC6qipjbjdcnBqS5cqjuisVU=;
        b=ubbChPPvyO8ACgzclgNBUAOOccwunKwe+0GBrGjbG0leJQizjZ4CJs7APZTiExXGsN
         +w6tizOBoUIJQR4+NXiYCpfyTX6s+fgcE0hpZG7CwIKMNpGF77EjA7/JfauV55cuVJVY
         0nDiRL3m7ylT2WjvXuPDbgNcmxXftfCpdz2wAfolwf00jpmAmxpA5lBHPoiaBzSVh2CK
         xT1noZfjAooqoJE44glNfZNWC2AnX8qkIFd3fn0eSii3hpOGmx4nb4lJLXEzkHd7N728
         c4Whps3Xo+/PUdJ9BO4z+fXUpgJiY6NvHwxJAiGicXyInbMosDvZOizoYkNFRoChb65y
         2CXw==
X-Gm-Message-State: AOAM5331GMxS8gWTMdg5EeVrTkLrezGhkegvPjzsTp/KGDkBQO7CISir
        GgaSS/jzaKlrQY7aDXkXG7UUDexGP98Ncm5u
X-Google-Smtp-Source: ABdhPJxmi8iVxOneNs9XgnuxTHQkUqaQNzRBGtQIA9aNF51QGjVhn6SrO9CDbUYwQ+ovjRUZEqvjmg==
X-Received: by 2002:a65:4889:: with SMTP id n9mr2602236pgs.303.1637031514834;
        Mon, 15 Nov 2021 18:58:34 -0800 (PST)
Received: from [10.2.24.177] ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id lt5sm592438pjb.43.2021.11.15.18.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 18:58:34 -0800 (PST)
Subject: Re: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with
 AVIC
To:     Wanpeng Li <kernellwp@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Kele Huang <huangkele@bytedance.com>, chaiwen.cc@bytedance.com,
        xieyongji@bytedance.com, dengliang.1214@bytedance.com,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
 <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
 <CANRm+Cze_b0PJzOGB4-tPdrz-iHcJj-o7QL1t1Pf1083nJDQKQ@mail.gmail.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <d65fbd73-7612-8348-2fd8-8da0f5e2a3c0@bytedance.com>
Date:   Tue, 16 Nov 2021 10:56:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cze_b0PJzOGB4-tPdrz-iHcJj-o7QL1t1Pf1083nJDQKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/16/21 10:48 AM, Wanpeng Li wrote:
> On Mon, 8 Nov 2021 at 22:09, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>>
>> On Mon, 2021-11-08 at 11:30 +0100, Paolo Bonzini wrote:
>>> On 11/8/21 10:59, Kele Huang wrote:
>>>> Currently, AVIC is disabled if x2apic feature is exposed to guest
>>>> or in-kernel PIT is in re-injection mode.
>>>>
>>>> We can enable AVIC with options:
>>>>
>>>>     Kmod args:
>>>>     modprobe kvm_amd avic=1 nested=0 npt=1
>>>>     QEMU args:
>>>>     ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
>>>>
>>>> When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
>>>> can accelerate IPI operations for guest. However, the relationship
>>>> between AVIC and PV_SEND_IPI feature is not sorted out.
>>>>
>>>> In logical, AVIC accelerates most of frequently IPI operations
>>>> without VMM intervention, while the re-hooking of apic->send_IPI_xxx
>>>> from PV_SEND_IPI feature masks out it. People can get confused
>>>> if AVIC is enabled while getting lots of hypercall kvm_exits
>>>> from IPI.
>>>>
>>>> In performance, benchmark tool
>>>> https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
>>>> shows below results:
>>>>
>>>>     Test env:
>>>>     CPU: AMD EPYC 7742 64-Core Processor
>>>>     2 vCPUs pinned 1:1
>>>>     idle=poll
>>>>
>>>>     Test result (average ns per IPI of lots of running):
>>>>     PV_SEND_IPI      : 1860
>>>>     AVIC             : 1390
>>>>
>>>> Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
>>>> do have some solid performance test results to this.
>>>>
>>>> This patch fixes this by masking out PV_SEND_IPI feature when
>>>> AVIC is enabled in setting up of guest vCPUs' CPUID.
>>>>
>>>> Signed-off-by: Kele Huang <huangkele@bytedance.com>
>>>
>>> AVIC can change across migration.  I think we should instead use a new
>>> KVM_HINTS_* bit (KVM_HINTS_ACCELERATED_LAPIC or something like that).
>>> The KVM_HINTS_* bits are intended to be changeable across migration,
>>> even though we don't have for now anything equivalent to the Hyper-V
>>> reenlightenment interrupt.
>>
>> Note that the same issue exists with HyperV. It also has PV APIC,
>> which is harmful when AVIC is enabled (that is guest uses it instead
>> of using AVIC, negating AVIC benefits).
>>
>> Also note that Intel recently posted IPI virtualizaion, which
>> will make this issue relevant to APICv too soon.
> 
> The recently posted Intel IPI virtualization will accelerate unicast
> ipi but not broadcast ipis, AMD AVIC accelerates unicast ipi well but
> accelerates broadcast ipis worse than pv ipis. Could we just handle
> unicast ipi here?
> 
>      Wanpeng
> 
Depend on the number of target vCPUs, broadcast IPIs gets unstable 
performance on AVIC, and usually worse than PV Send IPI.
So agree with Wanpeng's point, is it possible to separate single IPI and 
broadcast IPI on a hardware acceleration platform?

-- 
zhenwei pi
