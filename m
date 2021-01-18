Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384352FA818
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 18:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407290AbhARR4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:56:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436805AbhARR4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610992488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1k4Cz2LyXVL6E5kHdyp8ktuw+VYKYc6Qk8s5uLSdvQ=;
        b=SgEU9k92ppxLxRtATGgqRTha13/9sxZt4yEVJPVrEU6PGNRlqE5clF9aBsCy/IPDspGrQm
        94ZhccbkXxti/gqSrbSnXgtIpybtq3entnxQ9p7yDCLVA8YtqFexbMBAuShLtdqo9wtKTO
        P/g9kkn70BqudwRb5xzV9vXJNroBOBE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-m06P3bcuMP-aoi4m1BXZUA-1; Mon, 18 Jan 2021 12:54:45 -0500
X-MC-Unique: m06P3bcuMP-aoi4m1BXZUA-1
Received: by mail-ed1-f70.google.com with SMTP id o19so1506358edq.9
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:54:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1k4Cz2LyXVL6E5kHdyp8ktuw+VYKYc6Qk8s5uLSdvQ=;
        b=Rg+rrDCbT8zc4wTPcbrVcACVgaqdLoFAHaulkTfh88lYlh3RbZip6o/aw4NP+s5Phk
         Y2dPFoApXFY9S9mr4kDxgFZga8O8ThDNOwEhbC2VDroP26JQaVWoiwjRsMSIVCpFvHn1
         +IeXSSn72ZVBWMhKpe733CrBRzEHrFswLxYm7AuaPEdpt1m45mxtCzkZCQe07CFGBKLG
         SlHpE51Usey7E+EuMYRaGL55DR5zzf+o9qUMfqf+Fl+68r8SwPGyWjGijut0ov1b+anE
         xvEe+FYbbMHqI21YjmJvz97mrQov0bXBP51MX9Jsd+Lh0hmaTrWa7NsZlyhmGQTclcmR
         JtrA==
X-Gm-Message-State: AOAM532WNYaJZcUMs0dxALkwtnu5dv7l4fJ9b7+dfo6ScP7Y2qF2kgTZ
        CPvBpaMMJuEGVKRZoDyqgxUmQHO1AmggAGUebA5rQa+Q/kX/CHk597Re+vg9QTByMFFfvlrsLT2
        3zI9o1DQnWyF5
X-Received: by 2002:a05:6402:22d6:: with SMTP id dm22mr457938edb.255.1610992484368;
        Mon, 18 Jan 2021 09:54:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPsGoxtawWh7RwBscPUJmNg8armBmIl2xUJtwY1tuv/7RjVSZQ2+36GwzANkOwPMCTetf7VA==
X-Received: by 2002:a05:6402:22d6:: with SMTP id dm22mr457926edb.255.1610992484196;
        Mon, 18 Jan 2021 09:54:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p15sm7939907ejd.121.2021.01.18.09.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:54:43 -0800 (PST)
Subject: Re: [kvm-unit-tests][RFC PATCH] x86: Add a new test case for ret/iret
 with a nullified segment
To:     Bin Meng <bmeng.cn@gmail.com>
Cc:     kvm@vger.kernel.org, Bin Meng <bin.meng@windriver.com>
References: <1606206780-80123-1-git-send-email-bmeng.cn@gmail.com>
 <be7005bb-94f8-4a3f-8e51-de1e21499683@redhat.com>
 <CAEUhbmUVBCNh8DiPusqSm20vRsvMRBDj2Rqu+QOyg3shTSPAug@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <246dcfb6-cfcc-8213-eae8-634efbee159c@redhat.com>
Date:   Mon, 18 Jan 2021 18:54:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAEUhbmUVBCNh8DiPusqSm20vRsvMRBDj2Rqu+QOyg3shTSPAug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/21 15:16, Bin Meng wrote:
> Hi Paolo,
> 
> On Tue, Nov 24, 2020 at 5:12 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 24/11/20 09:33, Bin Meng wrote:
>>> From: Bin Meng <bin.meng@windriver.com>
>>>
>>> This makes up the test case for the following QEMU patch:
>>> http://patchwork.ozlabs.org/project/qemu-devel/patch/1605261378-77971-1-git-send-email-bmeng.cn@gmail.com/
>>>
>>> Note the test case only fails on an unpatched QEMU with "accel=tcg".
>>>
>>> Signed-off-by: Bin Meng <bin.meng@windriver.com>
>>> ---
>>> Sending this as RFC since I am new to kvm-unit-tests
>>>
>>>    x86/emulator.c | 38 ++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 38 insertions(+)
>>>
>>> diff --git a/x86/emulator.c b/x86/emulator.c
>>> index e46d97e..6100b6d 100644
>>> --- a/x86/emulator.c
>>> +++ b/x86/emulator.c
>>> @@ -6,10 +6,14 @@
>>>    #include "processor.h"
>>>    #include "vmalloc.h"
>>>    #include "alloc_page.h"
>>> +#include "usermode.h"
>>>
>>>    #define memset __builtin_memset
>>>    #define TESTDEV_IO_PORT 0xe0
>>>
>>> +#define MAGIC_NUM 0xdeadbeefdeadbeefUL
>>> +#define GS_BASE 0x400000
>>> +
>>>    static int exceptions;
>>>
>>>    /* Forced emulation prefix, used to invoke the emulator unconditionally.  */
>>> @@ -925,6 +929,39 @@ static void test_sreg(volatile uint16_t *mem)
>>>        write_ss(ss);
>>>    }
>>>
>>> +static uint64_t usr_gs_mov(void)
>>> +{
>>> +    static uint64_t dummy = MAGIC_NUM;
>>> +    uint64_t dummy_ptr = (uint64_t)&dummy;
>>> +    uint64_t ret;
>>> +
>>> +    dummy_ptr -= GS_BASE;
>>> +    asm volatile("mov %%gs:(%%rcx), %%rax" : "=a"(ret): "c"(dummy_ptr) :);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static void test_iret(void)
>>> +{
>>> +    uint64_t val;
>>> +    bool raised_vector;
>>> +
>>> +    /* Update GS base to 4MiB */
>>> +    wrmsr(MSR_GS_BASE, GS_BASE);
>>> +
>>> +    /*
>>> +     * Per the SDM, jumping to user mode via `iret`, which is returning to
>>> +     * outer privilege level, for segment registers (ES, FS, GS, and DS)
>>> +     * if the check fails, the segment selector becomes null.
>>> +     *
>>> +     * In our test case, GS becomes null.
>>> +     */
>>> +    val = run_in_user((usermode_func)usr_gs_mov, GP_VECTOR,
>>> +                      0, 0, 0, 0, &raised_vector);
>>> +
>>> +    report(val == MAGIC_NUM, "Test ret/iret with a nullified segment");
>>> +}
>>> +
>>>    /* Broken emulation causes triple fault, which skips the other tests. */
>>>    #if 0
>>>    static void test_lldt(volatile uint16_t *mem)
>>> @@ -1074,6 +1111,7 @@ int main(void)
>>>        test_shld_shrd(mem);
>>>        //test_lgdt_lidt(mem);
>>>        test_sreg(mem);
>>> +     test_iret();
>>>        //test_lldt(mem);
>>>        test_ltr(mem);
>>>        test_cmov(mem);
>>>
>>
>> Thanks, the patch is good.
> 
> Is this patch applied?
> 
> Regards,
> Bin
> 

Yes, it is.

Paolo

