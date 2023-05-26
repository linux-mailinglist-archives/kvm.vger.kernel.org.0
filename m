Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C779D712B44
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbjEZQ7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjEZQ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 12:59:36 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEA5125
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:59:32 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b2726f04cso64632785a.3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vultr.com; s=google; t=1685120371; x=1687712371;
        h=content-transfer-encoding:in-reply-to:references:reply-to:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gudBYOjxlMPzpMsv+R0jGezAuVHP8kRpvKozcaBPixo=;
        b=unAvSz+hA8R/gzNezutRomjGgLcLazKAsyWZk/MkZiCKSqhD4ok35jr3/+z4HOY0fb
         u30DFZ/V6tfi8YLKi8izesBv4LQMYZ66TzR9+HM4ZbB3ojn1AJjKnVo0jvDZ32CoaWfx
         V084DUhRDtJ7atOZ9IVsjted7mhpj6bZbXdJfc9r+VrOsoOH+GVEAjvwEEwhvDX/oBir
         gAhz97LDH/lEmaCj1YGE3ETP0UadQLDp7+18iddffF4poKdP5+r1myjIWPe0SxPoyXgH
         8hEJEowT8qbj1eBWjZ+4c+fYxOHNtJBqbaGYdU+LsgYS0tBoqEJB8hNeTjCsRxNIvzVT
         +Rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685120371; x=1687712371;
        h=content-transfer-encoding:in-reply-to:references:reply-to:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gudBYOjxlMPzpMsv+R0jGezAuVHP8kRpvKozcaBPixo=;
        b=H3fkXUejCXCjiYEOmKkwjd3bQ/qr1LBPrxtCUrVcWztfeJTlSVTN0BjkVYe5HZsF7B
         EP13pZKdWSjPRNcR8EybSF2wmLcSIIgS26oMP/sJakh1DCSS40cH8qA7Xh6sBU92H53U
         8RCqS6+AuwkSiRSgLtbFN7T8VJUidXd50Wb0K5U0dUrsRK06AcG5ERP/l/EmDBfUFFyq
         nDXewpHuR5i8+mfcXXffyNPpPeYveU/lA4i3H1e8B8+gWB5M3Obx/krwCmOkxiqJfUKx
         sNZ/lQ4X4PFpikZhba4LTv95H08WkF6AM0s4fEXj0nAnq7O6Os2TdIf1KP27jnJ8IgZT
         4sZA==
X-Gm-Message-State: AC+VfDxFcucCMyXTIvVtEuLLEwSlB51+h4+onULm1fFeK+xOLuY51fI5
        7Mbb9umA3d903ldm9XvfW7kgxw==
X-Google-Smtp-Source: ACHHUZ7gH6t86uy5F0u8qHEwwnOuKn/tAX7OnqL0hIhZJirHdHMj6I8hd/Db3j2k6JKPRakIEjas4g==
X-Received: by 2002:a05:620a:460a:b0:75b:23a1:8e75 with SMTP id br10-20020a05620a460a00b0075b23a18e75mr66597qkb.70.1685120371403;
        Fri, 26 May 2023 09:59:31 -0700 (PDT)
Received: from [10.7.103.58] ([208.167.225.114])
        by smtp.gmail.com with ESMTPSA id g3-20020ac870c3000000b003ef33e02eb9sm1384537qtp.83.2023.05.26.09.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 09:59:30 -0700 (PDT)
Message-ID: <bce4b387-638d-7f3c-ca9b-12ff6e020bad@vultr.com>
Date:   Fri, 26 May 2023 12:59:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: Deadlock due to EPT_VIOLATION
Content-Language: en-US
From:   Brian Rak <brak@vultr.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Reply-To: brak@gameservers.com
References: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
 <ZGzoUZLpPopkgvM0@google.com>
 <44ba516b-afe0-505d-1a87-90d489f9e03f@gameservers.com>
In-Reply-To: <44ba516b-afe0-505d-1a87-90d489f9e03f@gameservers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/24/2023 9:39 AM, Brian Rak wrote:
>
> On 5/23/2023 12:22 PM, Sean Christopherson wrote:
>> Nit, this isn't deadlock.  It may or may not even be a livelock 
>> AFAICT.  The vCPUs
>> are simply stuck and not making forward progress, _why_ they aren't 
>> making forward
>> progress is unknown at this point (obviously :-) ).
>>
>> On Tue, May 23, 2023, Brian Rak wrote:
>>> We've been hitting an issue lately where KVM guests (w/ qemu) have been
>>> getting stuck in a loop of EPT_VIOLATIONs, and end up requiring a guest
>>> reboot to fix.
>>>
>>> On Intel machines the trace ends up looking like:
>>>
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465404: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1, rip
>>> 0xffffffffc0771aa2
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465405: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason
>>> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465405: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1 rip
>>> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465406: 
>>> kvm_inj_virq:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ IRQ 0xec
>>> [reinjected]
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465406: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1, rip
>>> 0xffffffffc0771aa2
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465407: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason
>>> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465407: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1 rip
>>> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465408: 
>>> kvm_inj_virq:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ IRQ 0xec
>>> [reinjected]
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465408: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1, rip
>>> 0xffffffffc0771aa2
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465409: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason
>>> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465410: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1 rip
>>> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465410: 
>>> kvm_inj_virq:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ IRQ 0xec
>>> [reinjected]
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465410: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1, rip
>>> 0xffffffffc0771aa2
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465411: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason
>>> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465412: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1 rip
>>> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465413: 
>>> kvm_inj_virq:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ IRQ 0xec
>>> [reinjected]
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465413: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1, rip
>>> 0xffffffffc0771aa2
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465414: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason
>>> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465414: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1 rip
>>> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465415: 
>>> kvm_inj_virq:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ IRQ 0xec
>>> [reinjected]
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465415: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1, rip
>>> 0xffffffffc0771aa2
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465417: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason
>>> EPT_VIOLATION rip 0xffffffffc0771aa2 info 683 800000ec
>>> ï¿½ï¿½ ï¿½CPU-2386625 [094] 6598425.465417: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 1 rip
>>> 0xffffffffc0771aa2 address 0x0000000002594fe0 error_code 0x683
>>>
>>> on AMD machines, we end up with:
>>>
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055571: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0 rip
>>> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055571: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0, rip
>>> 0xffffffffb172ab2b
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055572: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason EXIT_NPF
>>> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055572: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0 rip
>>> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055573: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0, rip
>>> 0xffffffffb172ab2b
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055574: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason EXIT_NPF
>>> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055574: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0 rip
>>> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055575: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0, rip
>>> 0xffffffffb172ab2b
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055575: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason EXIT_NPF
>>> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055576: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0 rip
>>> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055576: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0, rip
>>> 0xffffffffb172ab2b
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055577: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason EXIT_NPF
>>> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055577: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0 rip
>>> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055578: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0, rip
>>> 0xffffffffb172ab2b
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055579: 
>>> kvm_exit:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ reason EXIT_NPF
>>> rip 0xffffffffb172ab2b info 200000006 f88eb2ff8
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055579: 
>>> kvm_page_fault:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0 rip
>>> 0xffffffffb172ab2b address 0x0000000f88eb2ff8 error_code 0x200000006
>>> ï¿½ï¿½ ï¿½CPU-14414 [063] 3039492.055580: 
>>> kvm_entry:ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ vcpu 0, rip
>>> 0xffffffffb172ab2b
>> In both cases, the TDP fault (EPT violation on Intel, #NPF on AMD) is 
>> occurring
>> when translating a guest paging structure.  I can't glean much from 
>> the AMD case,
>> but in the Intel trace, the fault occurs during delivery of the timer 
>> interrupt
>> (vector 0xec).  That may or may not be relevant to what's going on.
>>
>> It's definitely suspicious that both traces show that the guest is 
>> stuck faulting
>> on a guest paging structure.  Purely from a probability perspective, 
>> the odds of
>> that being a coincidence are low, though definitely not impossible.
>>
>>> The qemu process ends up looking like this once it happens:
>>>
>>> ï¿½ï¿½ ï¿½0x00007fdc6a51be26 in internal_fallocate64 (fd=-514841856, 
>>> offset=16,
>>> len=140729021657088) at ../sysdeps/posix/posix_fallocate64.c:36
>>> ï¿½ï¿½ ï¿½36ï¿½ï¿½ï¿½ï¿½ return EINVAL;
>>> ï¿½ï¿½ ï¿½(gdb) thread apply all bt
>>>
>>> ï¿½ï¿½ ï¿½Thread 6 (Thread 0x7fdbdefff700 (LWP 879746) "vnc_worker"):
>>> ï¿½ï¿½ ï¿½#0ï¿½ futex_wait_cancelable (private=0, expected=0,
>>> futex_word=0x7fdc688f66cc) at ../sysdeps/nptl/futex-internal.h:186
>>> ï¿½ï¿½ ï¿½#1ï¿½ __pthread_cond_wait_common (abstime=0x0, clockid=0,
>>> mutex=0x7fdc688f66d8, cond=0x7fdc688f66a0) at pthread_cond_wait.c:508
>>> ï¿½ï¿½ ï¿½#2ï¿½ __pthread_cond_wait (cond=cond@entry=0x7fdc688f66a0,
>>> mutex=mutex@entry=0x7fdc688f66d8) at pthread_cond_wait.c:638
>>> ï¿½ï¿½ ï¿½#3ï¿½ 0x0000563424cbd32b in qemu_cond_wait_impl 
>>> (cond=0x7fdc688f66a0,
>>> mutex=0x7fdc688f66d8, file=0x563424d302b4 "../../ui/vnc-jobs.c", 
>>> line=248)
>>> at ../../util/qemu-thread-posix.c:220
>>> ï¿½ï¿½ ï¿½#4ï¿½ 0x00005634247dac33 in vnc_worker_thread_loop 
>>> (queue=0x7fdc688f66a0)
>>> at ../../ui/vnc-jobs.c:248
>>> ï¿½ï¿½ ï¿½#5ï¿½ 0x00005634247db8f8 in vnc_worker_thread
>>> (arg=arg@entry=0x7fdc688f66a0) at ../../ui/vnc-jobs.c:361
>>> ï¿½ï¿½ ï¿½#6ï¿½ 0x0000563424cbc7e9 in qemu_thread_start 
>>> (args=0x7fdbdeffcf30) at
>>> ../../util/qemu-thread-posix.c:505
>>> ï¿½ï¿½ ï¿½#7ï¿½ 0x00007fdc6a8e1ea7 in start_thread (arg=<optimized 
>>> out>) at
>>> pthread_create.c:477
>>> ï¿½ï¿½ ï¿½#8ï¿½ 0x00007fdc6a527a2f in clone () at
>>> ../sysdeps/unix/sysv/linux/x86_64/clone.S:95
>>>
>>> ï¿½ï¿½ ï¿½Thread 5 (Thread 0x7fdbe5dff700 (LWP 879738) "CPU 1/KVM"):
>>> ï¿½ï¿½ ï¿½#0ï¿½ 0x00007fdc6a51d5f7 in preadv64v2 (fd=1756258112,
>>> vector=0x563424b5f007 <kvm_vcpu_ioctl+103>, count=0, offset=0, 
>>> flags=44672)
>>> at ../sysdeps/unix/sysv/linux/preadv64v2.c:31
>>> ï¿½ï¿½ ï¿½#1ï¿½ 0x0000000000000000 in ?? ()
>>>
>>> ï¿½ï¿½ ï¿½Thread 4 (Thread 0x7fdbe6fff700 (LWP 879737) "CPU 0/KVM"):
>>> ï¿½ï¿½ ï¿½#0ï¿½ 0x00007fdc6a51d5f7 in preadv64v2 (fd=1755834304,
>>> vector=0x563424b5f007 <kvm_vcpu_ioctl+103>, count=0, offset=0, 
>>> flags=44672)
>>> at ../sysdeps/unix/sysv/linux/preadv64v2.c:31
>>> ï¿½ï¿½ ï¿½#1ï¿½ 0x0000000000000000 in ?? ()
>>>
>>> ï¿½ï¿½ ï¿½Thread 3 (Thread 0x7fdbe83ff700 (LWP 879735) "IO 
>>> mon_iothread"):
>>> ï¿½ï¿½ ï¿½#0ï¿½ 0x00007fdc6a51bd2f in internal_fallocate64 
>>> (fd=-413102080, offset=3,
>>> len=4294967295) at ../sysdeps/posix/posix_fallocate64.c:32
>>> ï¿½ï¿½ ï¿½#1ï¿½ 0x000d5572b9bb0764 in ?? ()
>>> ï¿½ï¿½ ï¿½#2ï¿½ 0x000000016891db00 in ?? ()
>>> ï¿½ï¿½ ï¿½#3ï¿½ 0xffffffff7fffffff in ?? ()
>>> ï¿½ï¿½ ï¿½#4ï¿½ 0xf6b8254512850600 in ?? ()
>>> ï¿½ï¿½ ï¿½#5ï¿½ 0x0000000000000000 in ?? ()
>>>
>>> ï¿½ï¿½ ï¿½Thread 2 (Thread 0x7fdc693ff700 (LWP 879730) "qemu-kvm"):
>>> ï¿½ï¿½ ï¿½#0ï¿½ 0x00007fdc6a5212e9 in ?? () from
>>> target:/lib/x86_64-linux-gnu/libc.so.6
>>> ï¿½ï¿½ ï¿½#1ï¿½ 0x0000563424cbd9aa in qemu_futex_wait 
>>> (val=<optimized out>,
>>> f=<optimized out>) at ./include/qemu/futex.h:29
>>> ï¿½ï¿½ ï¿½#2ï¿½ qemu_event_wait (ev=ev@entry=0x5634254bd1a8 
>>> <rcu_call_ready_event>)
>>> at ../../util/qemu-thread-posix.c:430
>>> ï¿½ï¿½ ï¿½#3ï¿½ 0x0000563424cc6d80 in call_rcu_thread 
>>> (opaque=opaque@entry=0x0) at
>>> ../../util/rcu.c:261
>>> ï¿½ï¿½ ï¿½#4ï¿½ 0x0000563424cbc7e9 in qemu_thread_start 
>>> (args=0x7fdc693fcf30) at
>>> ../../util/qemu-thread-posix.c:505
>>> ï¿½ï¿½ ï¿½#5ï¿½ 0x00007fdc6a8e1ea7 in start_thread (arg=<optimized 
>>> out>) at
>>> pthread_create.c:477
>>> ï¿½ï¿½ ï¿½#6ï¿½ 0x00007fdc6a527a2f in clone () at
>>> ../sysdeps/unix/sysv/linux/x86_64/clone.S:95
>>>
>>> ï¿½ï¿½ ï¿½Thread 1 (Thread 0x7fdc69c3a680 (LWP 879712) "qemu-kvm"):
>>> ï¿½ï¿½ ï¿½#0ï¿½ 0x00007fdc6a51be26 in internal_fallocate64 
>>> (fd=-514841856,
>>> offset=16, len=140729021657088) at 
>>> ../sysdeps/posix/posix_fallocate64.c:36
>>> ï¿½ï¿½ ï¿½#1ï¿½ 0x0000000000000000 in ?? ()
>>>
>>> We first started seeing this back in 5.19, and we're still seeing it 
>>> as of
>>> 6.1.24 (likely later too, we don't have a ton of data for newer 
>>> versions).ï¿½
>>> We haven't been able to link this to any specific hardware.
>> Just to double check, this is the host kernel version, correct? When 
>> you upgraded
>> to kernel 5.19, did you change anything else in the stack?  E.g. did 
>> you upgrade
>> QEMU at the same time?  And what kernel were you upgrading from?
> Those are host kernel versions, correct.  We went from 5.15 -> 5.19.  
> That was the only change at the time.
>>
>>> It appears to happen more often on Intel, but our sample size is 
>>> much larger
>>> there.ï¿½ Guest operating system type/version doesn't appear to 
>>> matter.ï¿½ This
>>> usually happens to guests with a heavy network/disk workload, but it 
>>> can
>>> happen to even idle guests. This has happened on qemu 7.0 and 7.2 
>>> (upgrading
>>> to 7.2.2 is on our list to do).
>>>
>>> Where do we go from here?ï¿½ We haven't really made a lot of 
>>> progress in
>>> figuring out why this keeps happening, nor have we been able to come 
>>> up with
>>> a reliable way to reproduce it.
>> Is it possible to capture a failure with the trace_kvm_unmap_hva_range,
>> kvm_mmu_spte_requested and kvm_mmu_set_spte tracepoints enabled?  
>> That will hopefully
>> provide insight into why the vCPU keeps faulting, e.g. should show if 
>> KVM is
>> installing a "bad" SPTE, or if KVM is doing nothing and intentionally 
>> retrying
>> the fault because there are constant and/or unresolve mmu_notifier 
>> events.  My
>> guess is that it's the latter (KVM doing nothing) due to the 
>> fallocate() calls
>> in the stack, but that's really just a guess.
>
> In that trace, I had all the kvm/kvmmmu events enabled (trace-cmd 
> record -e kvm -e kvmmmu).  Just to be sure, I repeated this with 
> `trace-cmd record -e all`:
>
>              CPU-1365880 [038] 5559771.610941: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610941: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610942: write_msr:            
> 1d9, value 4000
>              CPU-1365880 [038] 5559771.610942: kvm_exit:             
> reason EPT_VIOLATION rip 0xffffffffb0e9bed0 info 83 0
>              CPU-1365880 [038] 5559771.610942: kvm_page_fault:       
> vcpu 0 rip 0xffffffffb0e9bed0 address 0x000000016e5b2ff8 error_code 0x83
>              CPU-1365880 [038] 5559771.610943: kvm_entry:            
> vcpu 0, rip 0xffffffffb0e9bed0
>              CPU-1365880 [038] 5559771.610943: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610943: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610944: write_msr:            
> 1d9, value 4000
>              CPU-1365880 [038] 5559771.610944: kvm_exit:             
> reason EPT_VIOLATION rip 0xffffffffb0e9bed0 info 83 0
>              CPU-1365880 [038] 5559771.610944: kvm_page_fault:       
> vcpu 0 rip 0xffffffffb0e9bed0 address 0x000000016e5b2ff8 error_code 0x83
>              CPU-1365880 [038] 5559771.610945: kvm_entry:            
> vcpu 0, rip 0xffffffffb0e9bed0
>              CPU-1365880 [038] 5559771.610945: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610945: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610946: write_msr:            
> 1d9, value 4000
>              CPU-1365880 [038] 5559771.610946: kvm_exit:             
> reason EPT_VIOLATION rip 0xffffffffb0e9bed0 info 83 0
>              CPU-1365880 [038] 5559771.610946: kvm_page_fault:       
> vcpu 0 rip 0xffffffffb0e9bed0 address 0x000000016e5b2ff8 error_code 0x83
>              CPU-1365880 [038] 5559771.610947: kvm_entry:            
> vcpu 0, rip 0xffffffffb0e9bed0
>              CPU-1365880 [038] 5559771.610947: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610947: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610948: write_msr:            
> 1d9, value 4000
>              CPU-1365880 [038] 5559771.610948: kvm_exit:             
> reason EPT_VIOLATION rip 0xffffffffb0e9bed0 info 83 0
>              CPU-1365880 [038] 5559771.610948: kvm_page_fault:       
> vcpu 0 rip 0xffffffffb0e9bed0 address 0x000000016e5b2ff8 error_code 0x83
>              CPU-1365880 [038] 5559771.610948: kvm_entry:            
> vcpu 0, rip 0xffffffffb0e9bed0
>              CPU-1365880 [038] 5559771.610949: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610949: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610949: write_msr:            
> 1d9, value 4000
>              CPU-1365880 [038] 5559771.610950: kvm_exit:             
> reason EPT_VIOLATION rip 0xffffffffb0e9bed0 info 83 0
>              CPU-1365880 [038] 5559771.610950: kvm_page_fault:       
> vcpu 0 rip 0xffffffffb0e9bed0 address 0x000000016e5b2ff8 error_code 0x83
>              CPU-1365880 [038] 5559771.610950: kvm_entry:            
> vcpu 0, rip 0xffffffffb0e9bed0
>              CPU-1365880 [038] 5559771.610950: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610951: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610951: write_msr:            
> 1d9, value 4000
>              CPU-1365880 [038] 5559771.610951: kvm_exit:             
> reason EPT_VIOLATION rip 0xffffffffb0e9bed0 info 83 0
>              CPU-1365880 [038] 5559771.610952: kvm_page_fault:       
> vcpu 0 rip 0xffffffffb0e9bed0 address 0x000000016e5b2ff8 error_code 0x83
>              CPU-1365880 [038] 5559771.610952: kvm_entry:            
> vcpu 0, rip 0xffffffffb0e9bed0
>              CPU-1365880 [038] 5559771.610952: rcu_utilization:      
> Start context switch
>              CPU-1365880 [038] 5559771.610952: rcu_utilization:      
> End context switch
>              CPU-1365880 [038] 5559771.610953: write_msr:            
> 1d9, value 4000
>
>> The other thing that would be helpful would be getting kernel stack 
>> traces of the
>> relevant tasks/threads.  The vCPU stack traces won't be interesting, 
>> but it'll
>> likely help to see what the fallocate() tasks are doing.
> I'll see what I can come up with here, I was running into some 
> difficulty getting useful stack traces out of the VM

I didn't have any luck gathering guest-level stack traces - kaslr makes 
it pretty difficult even if I have the guest kernel symbols.

Interestingly we've been seeing this on Windows guests as well, which 
would rule out a bug within the guest kernel.  This was from windows:

              CPU-5638  [034] 5446408.762619: rcu_utilization:      End 
context switch
              CPU-5638  [034] 5446408.762620: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762620: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762621: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762621: kvm_inj_virq: IRQ 0xd1 
[reinjected]
              CPU-5638  [034] 5446408.762622: kvm_entry: vcpu 0, rip 
0xfffff802057fee67
              CPU-5638  [034] 5446408.762622: rcu_utilization: Start 
context switch
              CPU-5638  [034] 5446408.762622: rcu_utilization: End 
context switch
              CPU-5638  [034] 5446408.762623: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762624: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762624: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762625: kvm_inj_virq: IRQ 0xd1 
[reinjected]
              CPU-5638  [034] 5446408.762625: kvm_entry: vcpu 0, rip 
0xfffff802057fee67
              CPU-5638  [034] 5446408.762625: rcu_utilization: Start 
context switch
              CPU-5638  [034] 5446408.762625: rcu_utilization: End 
context switch
              CPU-5638  [034] 5446408.762626: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762627: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762627: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762628: kvm_inj_virq: IRQ 0xd1 
[reinjected]
              CPU-5638  [034] 5446408.762628: kvm_entry: vcpu 0, rip 
0xfffff802057fee67
              CPU-5638  [034] 5446408.762628: rcu_utilization: Start 
context switch
              CPU-5638  [034] 5446408.762628: rcu_utilization: End 
context switch
              CPU-5638  [034] 5446408.762629: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762630: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762630: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762631: kvm_inj_virq: IRQ 0xd1 
[reinjected]
              CPU-5638  [034] 5446408.762631: kvm_entry: vcpu 0, rip 
0xfffff802057fee67
              CPU-5638  [034] 5446408.762631: rcu_utilization: Start 
context switch
              CPU-5638  [034] 5446408.762632: rcu_utilization: End 
context switch
              CPU-5638  [034] 5446408.762633: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762633: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762633: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762634: kvm_inj_virq: IRQ 0xd1 
[reinjected]
              CPU-5638  [034] 5446408.762634: kvm_entry: vcpu 0, rip 
0xfffff802057fee67
              CPU-5638  [034] 5446408.762635: rcu_utilization: Start 
context switch
              CPU-5638  [034] 5446408.762635: rcu_utilization: End 
context switch
              CPU-5638  [034] 5446408.762636: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762636: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762636: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762637: kvm_inj_virq: IRQ 0xd1 
[reinjected]
              CPU-5638  [034] 5446408.762638: kvm_entry: vcpu 0, rip 
0xfffff802057fee67
              CPU-5638  [034] 5446408.762638: rcu_utilization: Start 
context switch
              CPU-5638  [034] 5446408.762638: rcu_utilization: End 
context switch
              CPU-5638  [034] 5446408.762639: write_msr: 1d9, value 4000
              CPU-5638  [034] 5446408.762639: kvm_exit: reason 
EPT_VIOLATION rip 0xfffff802057fee67 info 683 800000d1
              CPU-5638  [034] 5446408.762640: kvm_page_fault: vcpu 0 rip 
0xfffff802057fee67 address 0x0000000054200f80 error_code 0x683
              CPU-5638  [034] 5446408.762640: kvm_inj_virq: IRQ 0xd1 
[reinjected]

