Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE76DB8DB
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjDHEaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDHEaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:30:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC52FCA22
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:30:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c3so769240pjg.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680928202;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQs4SC5lYlKd/34OSFcaA0sSEu14qWxU3jsCupypxlU=;
        b=kUaGPTveG0lxEI28vTpDb9Jw7OfLi4TPDm7kQSZcLfBmpgcZpWdfC+nC/VxxkU8g0D
         uhY6ay8Ow6fqnxgPs2ScCkFW1hcpY7bHeEG4IdUb84QinAnoHlZ/bD+jiGDDXNMAb7wl
         Npca4GkUEsp31W/9wZ0nnBKCzHIqzQFY5qH9Qc0eEflC/0q10hpGTG2fpyWmuFAX5HvI
         oK64dK+t86fzN0Fs16v9ZDiZm2LWdeyflbaMdQKGIXyrAgXu103KIOcVnM9mWpipo5OX
         Nh6sD6s0cr0WvBlYzRNzJAi8pxf7y2zmuhnUcQx+8qbwYEnNCaHWH/aUzB2Bef22N40d
         KNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680928202;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wQs4SC5lYlKd/34OSFcaA0sSEu14qWxU3jsCupypxlU=;
        b=Ab5OE/zWaomWR+GVZsWMQ+HQMaiuuuYpSdETIeSoczFDmEwZjdsgDqSYxglLcr3nAx
         d4tPw5438srtV21dCBscbwSKZY1sY+OpLMGTvBCR6GWL4o+HGmswLao2rgE+hyjw+spa
         Q3WQoRggYds3Kw+LjHWRGsTmzDB9GfjgDWvXGRd0wkbmywo/cxXyU4EdJbXIbFM/hjvD
         iAEqDHtlira/oL2z3WQUjBaMSDW/Ryop8b5bQfwK60EjqfweFEopyW5CTG90xdbcLtWR
         e3OAPPG09Pmv5vAZx3N3r+Ww9NjDOaFChV/R5ucWf7SzsoZbCTH0BHUVCEODVA3hIlty
         DnUA==
X-Gm-Message-State: AAQBX9cjeQXN6eAo8JxWb6tgP7rxPBsFG5K9hkz6cvW/lD1KjspOdNMQ
        Gt8qZBgYMPXPuubwO7rr5HWUAw==
X-Google-Smtp-Source: AKy350bSf+NJer4y36s5JHSJa51+w0WLdRxuVnS+TxQLWRCkIT+ZrofzrzsIKVKZztNYWN9UFvABiw==
X-Received: by 2002:a05:6a20:ce1f:b0:d8:bed9:33cf with SMTP id ic31-20020a056a20ce1f00b000d8bed933cfmr4258225pzb.17.1680928202146;
        Fri, 07 Apr 2023 21:30:02 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id j10-20020a62e90a000000b005a7f8a326a3sm3781655pfh.50.2023.04.07.21.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:30:01 -0700 (PDT)
Message-ID: <73bb88d3-7218-6ecf-2feb-2ad340d5e61c@linaro.org>
Date:   Fri, 7 Apr 2023 21:29:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 09/10] target/riscv: Restrict KVM-specific fields from
 ArchCPU
Content-Language: en-US
From:   Richard Henderson <richard.henderson@linaro.org>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-10-philmd@linaro.org>
 <ef63cacd-ea5a-16bb-994c-bf7a0ea3ac6a@linaro.org>
In-Reply-To: <ef63cacd-ea5a-16bb-994c-bf7a0ea3ac6a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/23 21:28, Richard Henderson wrote:
> On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
>> These fields shouldn't be accessed when KVM is not available.
>>
>> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
>> ---
>> RFC: The migration part is likely invalid...
>>
>> kvmtimer_needed() is defined in target/riscv/machine.c as
>>
>>    static bool kvmtimer_needed(void *opaque)
>>    {
>>        return kvm_enabled();
>>    }
>>
>> which depends on a host feature.
>> ---
>>   target/riscv/cpu.h     | 2 ++
>>   target/riscv/machine.c | 4 ++++
>>   2 files changed, 6 insertions(+)
> 
> Yeah, the kvm parts need to be extracted to their own subsection.

Oh, but they are.  Ho hum, it's getting late.


r~

