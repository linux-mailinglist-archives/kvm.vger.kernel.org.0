Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46EC6DB8D8
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjDHE2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjDHE2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:28:50 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F39B76C
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:28:48 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e13so161942plc.12
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680928128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RaLAuZfWT0INTWTTqSFBpSgDjWfPXH5Dgagb/vUcbfw=;
        b=MdRZm8Ro/NBK+ZlaFLYbQrUYN2G7NnUNCrSk6j3pIm6L3C9s8B9o+imxGmSGFO1rzP
         d0pypolwEj738cVK0dj/1jXeZovZByoSbF65Z8A1frLqrKBbvElXtXUO7UfpZcDEggnu
         Zj780LkQ6RFUEe06TUknN0z7I5YfStsmtefdpa4kylquOHBOyqQeAcnC5sdxXuxfzQfn
         NJ8fbdVCvkTfNgSjuv1y5Q5e2Jee5wZZK4zRajG36MHRr/ISn6kdjjqxtj7avpV06FuJ
         iEhbplpqT2ppeP+DGNa1BTj/fCHzGdZkc24DOYiRoEG45lApg3iyZ+by2C6hsI5BaGk1
         yiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680928128;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RaLAuZfWT0INTWTTqSFBpSgDjWfPXH5Dgagb/vUcbfw=;
        b=t7AU83tQ4cFDGZf7eyzF/BwSRYNg3suTEuQtoab6KL6yA9CpLFvNrK66UTR8LIxBrz
         9CsT+oktbQdMFAytLnks3bovmhbMZ1KhqdEjBA2IjbSCdRpQisuzgvhRUxFVmD12Ygru
         U558Sx07o70ZiuEF6m/2zqVB/7jzIyt6OwO0xMnP0W0DmkSir30oXpYWdwnu2GZi0AiH
         JYwWxtgecQKsZEKQb1UjMaVSMzzRIaIPthdPAZPHP3ttJv3Opkd8vPd4ktE3gJIBDXwr
         MMsBCm7S2M0+8RqavMDwY0bX87xMuDa5HKJzjTuL4rTlVf/ZlSjUqrGEIYkxVwgUroy4
         y/cg==
X-Gm-Message-State: AAQBX9cRZi24zlyMMivfLN/RvuG7KjRNtlJlsViTjhFTcDj5y/u2RC8M
        vv/iTHfw0YKyPsGIOyLHRuN8tA==
X-Google-Smtp-Source: AKy350Y373tHXEam4gJ7xdNJNam89DOSgLnH6QSib2qEnCN3lWhcYsVBGDQfhPVQZwXOZVmZepfL4g==
X-Received: by 2002:a05:6a20:6055:b0:dd:ff4f:b856 with SMTP id s21-20020a056a20605500b000ddff4fb856mr4347826pza.26.1680928128276;
        Fri, 07 Apr 2023 21:28:48 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id n7-20020a654cc7000000b0050c08fcff4asm3446234pgt.8.2023.04.07.21.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:28:47 -0700 (PDT)
Message-ID: <ef63cacd-ea5a-16bb-994c-bf7a0ea3ac6a@linaro.org>
Date:   Fri, 7 Apr 2023 21:28:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 09/10] target/riscv: Restrict KVM-specific fields from
 ArchCPU
Content-Language: en-US
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
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-10-philmd@linaro.org>
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

On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
> These fields shouldn't be accessed when KVM is not available.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
> RFC: The migration part is likely invalid...
> 
> kvmtimer_needed() is defined in target/riscv/machine.c as
> 
>    static bool kvmtimer_needed(void *opaque)
>    {
>        return kvm_enabled();
>    }
> 
> which depends on a host feature.
> ---
>   target/riscv/cpu.h     | 2 ++
>   target/riscv/machine.c | 4 ++++
>   2 files changed, 6 insertions(+)

Yeah, the kvm parts need to be extracted to their own subsection.


r~
