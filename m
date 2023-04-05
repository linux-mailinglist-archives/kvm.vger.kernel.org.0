Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8EB6D88F3
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbjDEUpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbjDEUpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:45:05 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3F6659A
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:44:41 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id w13-20020a4aca0d000000b0053b8aa32089so5873599ooq.5
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680727480;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZqWfb2PPnDpc2PEqcd7YpJ7M16hWDtl2fWp2jjEorwo=;
        b=TNOuzQODBFw4w+EKPw8H+hz/E1aFLDuz22IVxMRnSrjb96aaHbwmAL33xIMmsa9gvT
         iQp4A+/cHZmTKQDilGfL91aI/DfMj/G4wqLu1ET9xijR7swBv3vTXJrJj8TmNGA7S2Wv
         I2JUjyx6LNQ0MuLEQqZ0rTJGi44n1a2kWz1l/eM7zNNXDxXZaolcM9jdrg2Wwwx0V3gq
         upJ4sQdYAzdREj76KzCbvrFdw4HQmzfe/DMlJEtP8AoCCIbKzxEHrOAI75X1/3Qrwetp
         UjBxAFpe4rHKutfCkfjc7G0Sil1Fd+40EFqphuSetm2R1vMJ7pYfF7Wi3XT1HhpMA8GJ
         DUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727480;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqWfb2PPnDpc2PEqcd7YpJ7M16hWDtl2fWp2jjEorwo=;
        b=Iol3hgpAiPJc5aoQHlWEtfCnraX/PPeTM/4X0zaQlwH65YzSt4TnepYREmyDshM9hp
         ERFL/RVd2vlCBxL/WO1gvzei64ir0V1vxOn0UNvqpCcZ6Buv+1Z2Fk8IX4/x1EPnphhz
         vJrJ115VsQy7hHrlgJ+Jqr5vdkpnObeJiAwzvGn7Gv5lrNDVjRG593RjAQY12xOiAmYm
         QwzLcbYLQ/J1SljTdP71MQol1s3MnX6QSlpxQ9NWhgEIj+0uAqLEbeOU61T3bdmOdypG
         lSjNeEdfPsBfFZ14EjHxt3I2a6CzfMJ+/IefmUhzmOHZ0RIbud0ibQRnSevDgxQ3cJy2
         d3Jw==
X-Gm-Message-State: AAQBX9dHqzVOedVUjIr3Pj2EdxlBhJrh04/0XbfmgjYRR7rHvd92G7xK
        eYvj+lO8ol0PKGtLL/YB53JNAg==
X-Google-Smtp-Source: AKy350Zpo5917s3wwJGg0D4GjQAAqZMwM4zNUds49ooFSWmxGSeohhLZSBKl2stDGqytkYYe+q1+OA==
X-Received: by 2002:a4a:5241:0:b0:537:b1ad:1c7c with SMTP id d62-20020a4a5241000000b00537b1ad1c7cmr3544290oob.0.1680727480668;
        Wed, 05 Apr 2023 13:44:40 -0700 (PDT)
Received: from [192.168.68.107] ([191.255.108.232])
        by smtp.gmail.com with ESMTPSA id u1-20020a056830118100b0069fb749271bsm7192106otq.15.2023.04.05.13.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 13:44:39 -0700 (PDT)
Message-ID: <984d3eda-1efd-f39d-8930-3a8ea5226ad5@ventanamicro.com>
Date:   Wed, 5 Apr 2023 17:44:34 -0300
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
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-10-philmd@linaro.org>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230405160454.97436-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/23 13:04, Philippe Mathieu-Daudé wrote:
> These fields shouldn't be accessed when KVM is not available.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


kvm_enabled() can be false even when CONFIG_KVM is true when a KVM capable host
is running a TCG guest, for example. In that case env->kvm_timer_* states exist
but aren't initialized, and shouldn't be migrated.

Thus it's not just a host feature, but a host feature + accel option. I think
this is fine.

> ---
>   target/riscv/cpu.h     | 2 ++
>   target/riscv/machine.c | 4 ++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 638e47c75a..82939235ab 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -377,12 +377,14 @@ struct CPUArchState {
>       hwaddr kernel_addr;
>       hwaddr fdt_addr;
>   
> +#ifdef CONFIG_KVM
>       /* kvm timer */
>       bool kvm_timer_dirty;
>       uint64_t kvm_timer_time;
>       uint64_t kvm_timer_compare;
>       uint64_t kvm_timer_state;
>       uint64_t kvm_timer_frequency;
> +#endif /* CONFIG_KVM */
>   };
>   
>   OBJECT_DECLARE_CPU_TYPE(RISCVCPU, RISCVCPUClass, RISCV_CPU)
> diff --git a/target/riscv/machine.c b/target/riscv/machine.c
> index 9c455931d8..e45d564ec3 100644
> --- a/target/riscv/machine.c
> +++ b/target/riscv/machine.c
> @@ -201,10 +201,12 @@ static bool kvmtimer_needed(void *opaque)
>   
>   static int cpu_post_load(void *opaque, int version_id)
>   {
> +#ifdef CONFIG_KVM
>       RISCVCPU *cpu = opaque;
>       CPURISCVState *env = &cpu->env;
>   
>       env->kvm_timer_dirty = true;
> +#endif
>       return 0;
>   }
>   
> @@ -215,9 +217,11 @@ static const VMStateDescription vmstate_kvmtimer = {
>       .needed = kvmtimer_needed,
>       .post_load = cpu_post_load,
>       .fields = (VMStateField[]) {
> +#ifdef CONFIG_KVM
>           VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
>           VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
>           VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
> +#endif

Here you're creating an empty 'cpu/kvmtimer' vmstate that won't be migrated anyway
because kvmtimer_needed (== kvm_enabled()) will be always false if CONFIG_KVM=n.

I'd say it's better to just get rid of the whole vmstate in this case, but I don't
like the precedence of having vmstates being gated by build flags.


Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>



>           VMSTATE_END_OF_LIST()
>       }
>   };
