Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6596407D45
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 14:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhILMcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 08:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhILMcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Sep 2021 08:32:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D21C061574
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 05:31:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g14so6264581pfm.1
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 05:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l2bSjNJqTwhQZphEwMAU513EeIhPI7Thg1lJpA7i8fs=;
        b=R66inDcAWt9GQlblcZebPLMwPlHlAnt0L3kyGlH8r3X6FsDI/N/vYwneGzy6f53yoC
         aJSbeJ2HVLZ5IETneJLglbqjOoAzPmPkvYhRyqU7w9yu4eGlZVUBvR4cBjWxsVNMWyQs
         qiLol3oXEuJFHpxM5XDG2HifDgtIlXc6Y+gNn2EVYS2UFBYwOF9tNaPzUqjb6c9xEMKD
         EpbKtmy5jQyQ9JwjSHSZdDyKcuXW75ONjIPM4WmszEr/HJrFRo+qRBybdHwe5FUddKSp
         VhyKUscbCxv1rziWUD7Bm32+mC15T8UjtL/0R3OkiO3/Lb77FRexMdrsOVYoCJhihCLc
         vdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l2bSjNJqTwhQZphEwMAU513EeIhPI7Thg1lJpA7i8fs=;
        b=nGq70sNAB4ZA8avnxemsQH+GPgEWqgcfF0aTBMbyw2kwgm6iNMcyjNVRKaVnaULSPU
         TS0jMhySXCB4neWN3/k7QMW2ONj8ZCQ0sQhx8sYwlFtcmMZbA76qGed6qhc8y/ks/GCY
         8HGFanJWoLq30vxhM9Y7bA41q4+sCvRSqaY6PvzwxjIMTz7xa+uKp/9O+vYQzjgkFdJn
         FKOgKK4W1IrMS/0EkupEydA8DT0GTy85BJGI44M/4fJnKWmFH5EPBrQV/08vxDolaJkt
         SNoj+VjXy2/93A12W6VslSx0W2uiMSeHyyIIZe9UKwsrEjthJEcI0HAolu913y742m/o
         PTPQ==
X-Gm-Message-State: AOAM532Xo6GBg9ZgFREVLvhIf2+cGQT5r1m/DSEmj0ezDzcTc/MmieSK
        VHK9HwjpuDGUCmp50TNz4mEixw==
X-Google-Smtp-Source: ABdhPJxYx4l/5Z0anqBV+G7Bghe5EKN+RrvdQIUDU4YrpZdFpP+VKFzDEwt6BtZ6HBag6jIPDdKEog==
X-Received: by 2002:a63:5413:: with SMTP id i19mr6469698pgb.297.1631449898733;
        Sun, 12 Sep 2021 05:31:38 -0700 (PDT)
Received: from [192.168.1.11] ([71.212.134.125])
        by smtp.gmail.com with ESMTPSA id z9sm3970376pfn.22.2021.09.12.05.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 05:31:38 -0700 (PDT)
Subject: Re: [PATCH v3 21/30] target/ppc: Introduce
 PowerPCCPUClass::has_work()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Chris Wulff <crwulff@gmail.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, haxm-team@intel.com,
        Colin Xu <colin.xu@intel.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Paul Durrant <paul@xen.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Claudio Fontana <cfontana@suse.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cameron Esfahani <dirty@apple.com>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, Michael Rolnik <mrolnik@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
        Stafford Horne <shorne@gmail.com>, qemu-riscv@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-22-f4bug@amsat.org> <YTFxZb1Vg5pWVW9p@yekko>
 <fd383a02-fb9f-8641-937f-ebe1d8bb065f@linaro.org>
 <fc98e293-f2ba-8ca0-99c8-f07758b79d73@amsat.org>
 <a49e0100-74d1-2974-990f-a05f9f796cc5@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <82c9e627-016a-e834-6ed0-4c5d49b554e6@linaro.org>
Date:   Sun, 12 Sep 2021 05:31:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a49e0100-74d1-2974-990f-a05f9f796cc5@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/21 3:31 PM, Philippe Mathieu-Daudé wrote:
> On 9/3/21 11:11 PM, Philippe Mathieu-Daudé wrote:
>> On 9/3/21 10:42 PM, Richard Henderson wrote:
>>> On 9/3/21 2:50 AM, David Gibson wrote:
>>>> On Thu, Sep 02, 2021 at 06:15:34PM +0200, Philippe Mathieu-Daudé wrote:
>>>>> Each POWER cpu has its own has_work() implementation. Instead of
>>>>> overloading CPUClass on each PowerPCCPUClass init, register the
>>>>> generic ppc_cpu_has_work() handler, and have it call the POWER
>>>>> specific has_work().
>>>>
>>>> I don't quite see the rationale for introducing a second layer of
>>>> indirection here.  What's wrong with switching the base has_work for
>>>> each cpu variant?
>>>
>>> We're moving the hook from CPUState to TCGCPUOps.
>>> Phil was trying to avoid creating N versions of
>>>
>>> static const struct TCGCPUOps ppc_tcg_ops = {
>>>      ...
>>> };
>>
>> Ah yes this is the reason! Too many context switching so
>> I forgot about it.
>>
>>> A plausible alternative is to remove the const from this struct and
>>> modify it, just as we do for CPUState, on the assumption that we cannot
>>> mix and match ppc cpu types in any one machine.
>>
>> I thought about this case and remembered how it works on the ARM arch,
>> i.e. ZynqMP machine uses both Cortex-R5F and Cortex-A53. Even if no
>> similar PPC machine exists, IMHO we should try to generally allow to
>> possibility to experiment machine with different CPUs. Restricting it
>> on PPC goes the other way around. Thoughts?
> 
> I'm running out of ideas to do avoid the indirection and multiple
> copies of TCGCPUOps. I'm not giving up, I suppose I'm simply not
> seeing it... David, any suggestions?

I think multiple copies of TCGCPUOps is the solution.  Macro-ized, perhaps, so that the 
amount of typing is minimal across the versions.


r~
