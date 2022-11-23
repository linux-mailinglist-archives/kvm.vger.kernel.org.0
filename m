Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6730636899
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbiKWSVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239694AbiKWSU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:20:56 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D3463BBF
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:20:55 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v1so30631026wrt.11
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KFzUmDVFH2qZWwlWdZ/9pVGVustz0qZhK3Q9IuAM1s0=;
        b=EXe1QtTPq3nl5RgC+Md2KERFeY1h8WmSlfutX5l2IGBddVFUumijQp7DkE8Hfgp9Ug
         9GhmB4o/ead4g66XKb/wMk1TGl6yRk/l3OEOcuL1da7D4DX79hSZTaeR5wi7PczKSJJo
         PS6jdof7T7C8lYDGb1hIoUvwJv1okZ2KRLWwgfdCzQibSQY/x+A+yVT/p8YLeSaQYUJV
         VXrD5/ttLvOL9kAv4nUI+aum3rI1RrCcR5t5H/bw7WfDYOVjhYgSJycbn8Gbeb4SEma/
         bH5V0V23IPERGxQoF4u+rS93moH3hy7PQEryBSN/eWjSr5lEypLM/M/3cfIiFvdTbwXL
         /d8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFzUmDVFH2qZWwlWdZ/9pVGVustz0qZhK3Q9IuAM1s0=;
        b=fTIUEgOPJd7Nvrm4FOjIekZxoJ4JNWdGvD4H6/bzuRKjO/PJLCMeyBcsfI/r90BjkK
         NcXvRy78RFuz6Hyuc+E7fDsUM95MW0K4AYQ+TQ/7WYOCWXYdS98avHK39EB0yqxCkGut
         LuLedwWIRd4kvVlRT8UKRSO3AO+NEJRdYvQbMhkm/v2B7vLJiIDpUOy8G0gbTSYflSDh
         o8FeRnCFIjl9OnYGJdYM+ATs9reGOjS0yWyhqlXcQKESBJC6UoIFCATgwoV2oguRguol
         FMYBIZB3nJcNVetHek2iYuNI0TETkMKbH0n7sXjcKav9RKUKmUR7jPruWuIwrOYkbUo2
         LXow==
X-Gm-Message-State: ANoB5pnrpMxlQdG8PZTYDPO/wUXOfcQOagsdFT44VZj1zyC0SkXBXC+w
        SJ/o9qDU5Zr1WqnJU0ZhFuh8aQ==
X-Google-Smtp-Source: AA0mqf5RhjHcVxal7i0s2AUD9bEMt8kxk9xAD//IQP/oYWZzlbF+2Z/l19uDYJ9uLilvLpZfVSWgJQ==
X-Received: by 2002:adf:d84c:0:b0:236:6f1a:955 with SMTP id k12-20020adfd84c000000b002366f1a0955mr17545989wrl.111.1669227653704;
        Wed, 23 Nov 2022 10:20:53 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c3-20020a5d4cc3000000b00241c4bd6c09sm14645553wrt.33.2022.11.23.10.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 10:20:53 -0800 (PST)
Message-ID: <af92080f-e708-f593-7ff5-81b7b264d587@linaro.org>
Date:   Wed, 23 Nov 2022 19:20:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH] gdbstub: move update guest debug to accel ops
Content-Language: en-US
To:     Mads Ynddal <mads@ynddal.dk>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yanan Wang <wangyanan55@huawei.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20221123121712.72817-1-mads@ynddal.dk>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221123121712.72817-1-mads@ynddal.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 23/11/22 13:17, Mads Ynddal wrote:
> From: Mads Ynddal <m.ynddal@samsung.com>
> 
> Continuing the refactor of a48e7d9e52 (gdbstub: move guest debug support
> check to ops) by removing hardcoded kvm_enabled() from generic cpu.c
> code, and replace it with a property of AccelOpsClass.
> 
> Signed-off-by: Mads Ynddal <m.ynddal@samsung.com>
> ---
>   accel/kvm/kvm-accel-ops.c  |  1 +
>   cpu.c                      | 10 +++++++---
>   include/sysemu/accel-ops.h |  1 +
>   3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
> index fbf4fe3497..6ebf9a644f 100644
> --- a/accel/kvm/kvm-accel-ops.c
> +++ b/accel/kvm/kvm-accel-ops.c
> @@ -99,6 +99,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
>       ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
>   
>   #ifdef KVM_CAP_SET_GUEST_DEBUG
> +    ops->update_guest_debug = kvm_update_guest_debug;
>       ops->supports_guest_debug = kvm_supports_guest_debug;
>       ops->insert_breakpoint = kvm_insert_breakpoint;
>       ops->remove_breakpoint = kvm_remove_breakpoint;
> diff --git a/cpu.c b/cpu.c
> index 2a09b05205..ef433a79e3 100644
> --- a/cpu.c
> +++ b/cpu.c
> @@ -31,8 +31,8 @@
>   #include "hw/core/sysemu-cpu-ops.h"
>   #include "exec/address-spaces.h"
>   #endif
> +#include "sysemu/cpus.h"
>   #include "sysemu/tcg.h"
> -#include "sysemu/kvm.h"
>   #include "sysemu/replay.h"
>   #include "exec/cpu-common.h"
>   #include "exec/exec-all.h"
> @@ -378,10 +378,14 @@ void cpu_breakpoint_remove_all(CPUState *cpu, int mask)
>   void cpu_single_step(CPUState *cpu, int enabled)
>   {
>       if (cpu->singlestep_enabled != enabled) {
> +        const AccelOpsClass *ops = cpus_get_accel();
> +
>           cpu->singlestep_enabled = enabled;
> -        if (kvm_enabled()) {
> -            kvm_update_guest_debug(cpu, 0);
> +
> +        if (ops->update_guest_debug) {
> +            ops->update_guest_debug(cpu, 0);

Isn't this '0' flag here accelerator-specific? ...

>           }
> +
>           trace_breakpoint_singlestep(cpu->cpu_index, enabled);
>       }
>   }
> diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
> index 8cc7996def..0a47a2f00c 100644
> --- a/include/sysemu/accel-ops.h
> +++ b/include/sysemu/accel-ops.h
> @@ -48,6 +48,7 @@ struct AccelOpsClass {
>   
>       /* gdbstub hooks */
>       bool (*supports_guest_debug)(void);
> +    int (*update_guest_debug)(CPUState *cpu, unsigned long flags);

... if so the prototype should be:

        int (*update_guest_debug)(CPUState *cpu);

and the '0' value set within kvm-accel-ops.c handler implementation.

>       int (*insert_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
>       int (*remove_breakpoint)(CPUState *cpu, int type, hwaddr addr, hwaddr len);
>       void (*remove_all_breakpoints)(CPUState *cpu);

Regards,

Phil.
