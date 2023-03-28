Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421E66CBA4E
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjC1JQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC1JQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:16:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC04659B;
        Tue, 28 Mar 2023 02:16:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id dw14so7504118pfb.6;
        Tue, 28 Mar 2023 02:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679994978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x02YvopU+P3A01MCuaTfokQ4EXRCg7/JARgoT7FJkWc=;
        b=A7BJNvY0SW3tjJdruJBVA6zgpFZ2Z7pBFIjc5p2RQqOzQrw4iHqRL2iKcDQITCV6/S
         KaYiuneNP0YbuXcgcJyzsbzR/jQHIHVXoYbzjkFJw0h5smTHyjo3Y6I6aSd32nke5XXN
         Kw1Ud2POedp+osDED2kxejZTL/RAY2ZeNNHtY3xpuctaFy6Dw5VrXUA5DUquKfCOoCDN
         34jx6wpNbvOAvdvIZAiw3pMMa+tlyuk4yMjWe6Ub9KonwZ8F7Z/CAhVyOOpDppG02Xav
         krEhuJIYs3g1QwX3eYDo1slQf5/NdGIZFXcC1qSZ5aHbZsJbAnpc8mdeg+7FZSmFZdUP
         MuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679994978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x02YvopU+P3A01MCuaTfokQ4EXRCg7/JARgoT7FJkWc=;
        b=RTT3UOCiyJOWEVJ6O3MpzZYVGAGsS0cOGWpEJVCRI89CxBRa9OpgzLI5xcdZQNkSgB
         n/I5sSHLlA8qPJZueN/fUGZqP3JkC7Zx1+wYyLMW62KYQ+tvs0w+pBtn85Brzduee5at
         5Zf8LwJK5itI/vKCBdxR6b+H4F8Rd+2ZX2e4wDPs0quj6VR+rOmQrsKg09FQOUNvwWwT
         gqIzvOPTZzKNlQhwts1eN3vM7dzkheglRPXe4MPuiQ8zW9G6XOtEkukmB3E8M7UcK8Wj
         Npfg06Zri+Y2qwnbmnx0w/WPSTRCKgadIpwmLBpdadJF9DvHiKZUXEqe2a/6xDGm5qLQ
         mt/g==
X-Gm-Message-State: AAQBX9dcep6uplQkGVApWnXu3Y62c5KSOi9EIf72zUZDne+rbXlMswcJ
        ReszWiUnkIkRY+IBs/98nCo=
X-Google-Smtp-Source: AKy350YWWJJHiThjWVsesOY3xUtb8hkRkrmW35+BFynCcDga5VpyCWGhvrkGaA2v21buBZuIOHw/Hg==
X-Received: by 2002:aa7:950d:0:b0:625:e728:4c5f with SMTP id b13-20020aa7950d000000b00625e7284c5fmr13587242pfp.22.1679994977661;
        Tue, 28 Mar 2023 02:16:17 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k11-20020aa790cb000000b0062d79c41673sm4192244pfk.155.2023.03.28.02.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 02:16:16 -0700 (PDT)
Message-ID: <871434fe-ae80-bec6-9920-a6411f5842c0@gmail.com>
Date:   Tue, 28 Mar 2023 17:16:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v2] KVM: x86/pmu: Fix emulation on Intel counters' bit
 width
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230322093117.48335-1-likexu@tencent.com>
 <CABgObfYfiUDf4zY=izcg_32yGCbUxxVc+JAkHGHwiQ0VmGdOgA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CABgObfYfiUDf4zY=izcg_32yGCbUxxVc+JAkHGHwiQ0VmGdOgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/3/2023 10:30 pm, Paolo Bonzini wrote:
> On Wed, Mar 22, 2023 at 10:31 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> Per Intel SDM, the bit width of a PMU counter is specified via CPUID
>> only if the vCPU has FW_WRITE[bit 13] on IA32_PERF_CAPABILITIES.
>> When the FW_WRITE bit is not set, only EAX is valid and out-of-bounds
>> bits accesses do not generate #GP. Conversely when this bit is set, #GP
>> for out-of-bounds bits accesses will also appear on the fixed counters.
>> vPMU currently does not support emulation of bit widths lower than 32
>> bits or higher than its host capability.
> 
> Can you please point out the date and paragraph of the SDM?
> 
> Paolo
> 

25462-078US, December 2022
20.2.6 Full-Width Writes to Performance Counter Registers

The general-purpose performance counter registers IA32_PMCx are writable via 
WRMSR instruction.
However, the value written into IA32_PMCx by WRMSR is the signed extended 64-bit 
value of the
EAX[31:0] input of WRMSR.

A processor that supports full-width writes to the general-purpose performance 
counters enumerated by
CPUID.0AH:EAX[15:8] will set IA32_PERF_CAPABILITIES[13] to enumerate its 
full-width-write
capability See Figure 20-65.

If IA32_PERF_CAPABILITIES.FW_WRITE[bit 13] =1, each IA32_PMCi is accompanied by a
corresponding alias address starting at 4C1H for IA32_A_PMC0.

The bit width of the performance monitoring counters is specified in 
CPUID.0AH:EAX[23:16].
If IA32_A_PMCi is present, the 64-bit input value (EDX:EAX) of WRMSR to 
IA32_A_PMCi will cause
IA32_PMCi to be updated by:

	COUNTERWIDTH =
		CPUID.0AH:EAX[23:16] bit width of the performance monitoring counter 		
	IA32_PMCi[COUNTERWIDTH-1:32] := EDX[COUNTERWIDTH-33:0]);
	IA32_PMCi[31:0] := EAX[31:0];
	EDX[63:COUNTERWIDTH] are reserved

---

Some might argue that this is all talking about GP counters, not fixed counters.
In fact, the full-width write hw behaviour is presumed to do the same thing for 
all counters.

Commercial hardware will not use less than 32 bits or a bit width like 46 bits.
A KVM user space (such as selftests) may set a strange bit-width, for example 
using 33 bits,
and based on the current code, writing the reserved bits for #fixed counters 
doesn't cause #GP.

Also when the guest does not have the Full-Width feature, the fixed counters can 
be more than
32 bits wide via CPUID, while the #GP counter is only 32 bits wide, which is 
also monstrous.

The current KVM is also not capable of emulating counter overflow when KVM user 
space is set
to a bit width of less than 32 bits w/ FW_WRITE.

The above SDM-undefined behaviour led to this fix, which may lift some of the fog.
