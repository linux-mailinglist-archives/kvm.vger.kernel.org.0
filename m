Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14374761E9A
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 18:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjGYQfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 12:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjGYQf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 12:35:29 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A29C10C9
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 09:35:28 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b9b89627c3so4445239a34.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 09:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690302928; x=1690907728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j1zn/9mZBEEPMZ3SvwwpvL0Ph7iRqIpCjYP1QEBphQc=;
        b=e1twazjp0/qMRNnTvnB9YM13KEt7bqPJlbvxQjiAFAWo8WtYTAP3qF+BRKh7TD7iDk
         WKi802bE4cymQYCrxRB/j2qBqgHPbTna7eAIV8rfdx5Jpc6EBx9zl+zW/Ff1jqGmCSlX
         N/Pyfu8eIqER6jQqHklAvXCGtLY8gdC9ChUv5XGswA9jeLZWDAze4K0NE6u+4aaKEUA+
         vlMoVKirBJ6SU1x6mpvkN6olqUmVCLK8p8Z5ql3BEsLz03Iwe4wg9rlIVBtNMfzgB7Cz
         em3f/GRv5gosLnV3I8IBjQFqudfVQSqeRSkhb9Z1bhRYXEGmt3jaWmwRDq1YXYGWFUrl
         HcTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690302928; x=1690907728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j1zn/9mZBEEPMZ3SvwwpvL0Ph7iRqIpCjYP1QEBphQc=;
        b=bDFRcndhmmgpAVC+KPumPcbikI7fu50XqrVPCuwC3oy16eA/zgmPbL625NHCs9zXEx
         +Xs/IyMzSY/oUYkWw2y3vG41bFFsPX8EXN3SH8xIzcF6GzPxY+w4NfSBipoUgcw5ZCWu
         UZk1oXwYs0zeeDy59zvlXQxyTb5IFSNqkkkOjlwhrcuktuUOpqzxNE1lK4zej92Y38M+
         zl1Qo/7qnWezFg7FaCGR+h4hN7hgxDu2m20U4IKs9v7V1yBlSO4vcYQ7pKRLVtavPdt3
         6YQbFzbY/3Hw17RK7QTSNnJioMcRnEG3wABhT3dwyUAhwsp2/p/2n4VwjvTydm4NLZXs
         XIFw==
X-Gm-Message-State: ABy/qLbTz1vN1rZWshiE6hnOXbLjMckqysAtVO1jKwjnZGZRgUfDY6O5
        AEryZ7AcGvESsXyZRqYk1vHwJA==
X-Google-Smtp-Source: APBJJlF0yUUj57hWH9KFX50Gqin4qAY62eeDl7pzUszz6j9MJzFDJP5kc4Jnj86STldIIshcesvCzg==
X-Received: by 2002:a9d:66c1:0:b0:6b9:8feb:7f1e with SMTP id t1-20020a9d66c1000000b006b98feb7f1emr11464058otm.35.1690302927790;
        Tue, 25 Jul 2023 09:35:27 -0700 (PDT)
Received: from [192.168.68.108] (201-69-66-36.dial-up.telesp.net.br. [201.69.66.36])
        by smtp.gmail.com with ESMTPSA id k25-20020a0568301bf900b006b8a0c7e14asm5029381otb.55.2023.07.25.09.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 09:35:27 -0700 (PDT)
Message-ID: <d06e1004-adac-8c24-167c-c87978340baa@ventanamicro.com>
Date:   Tue, 25 Jul 2023 13:35:22 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, peter.maydell@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, thuth@redhat.com,
        kvm@vger.kernel.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org
References: <20230725122601.424738-2-ajones@ventanamicro.com>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230725122601.424738-2-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/25/23 09:26, Andrew Jones wrote:
> Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
> irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
> RISC-V platform has AIA. The cap indicates KVM supports at least one
> of the following ioctls:
> 
>    KVM_CREATE_IRQCHIP
>    KVM_IRQ_LINE
>    KVM_GET_IRQCHIP
>    KVM_SET_IRQCHIP
>    KVM_GET_LAPIC
>    KVM_SET_LAPIC
> 
> but the cap doesn't imply that KVM must support any of those ioctls
> in particular. However, QEMU was assuming the KVM_CREATE_IRQCHIP
> ioctl was supported. Stop making that assumption by introducing a
> KVM parameter that each architecture which supports KVM_CREATE_IRQCHIP
> sets. Adding parameters isn't awesome, but given how the
> KVM_CAP_IRQCHIP isn't very helpful on its own, we don't have a lot of
> options.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

> 
> While this fixes booting guests on riscv KVM with AIA it's unlikely
> to get merged before the QEMU support for KVM AIA[1] lands, which
> would also fix the issue. I think this patch is still worth considering
> though since QEMU's assumption is wrong.
> 
> [1] https://lore.kernel.org/all/20230714084429.22349-1-yongxuan.wang@sifive.com/
> 
> v2:
>    - Move the s390x code to an s390x file. [Thomas]
>    - Drop the KVM_CAP_IRQCHIP check from the top of kvm_irqchip_create(),
>      as it's no longer necessary.
> 
>   accel/kvm/kvm-all.c    | 16 ++++------------
>   include/sysemu/kvm.h   |  1 +
>   target/arm/kvm.c       |  3 +++
>   target/i386/kvm/kvm.c  |  2 ++
>   target/s390x/kvm/kvm.c | 11 +++++++++++
>   5 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 373d876c0580..cddcb6eca641 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -86,6 +86,7 @@ struct KVMParkedVcpu {
>   };
>   
>   KVMState *kvm_state;
> +bool kvm_has_create_irqchip;
>   bool kvm_kernel_irqchip;
>   bool kvm_split_irqchip;
>   bool kvm_async_interrupts_allowed;
> @@ -2358,17 +2359,6 @@ static void kvm_irqchip_create(KVMState *s)
>       int ret;
>   
>       assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
> -    if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
> -        ;
> -    } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
> -        ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
> -        if (ret < 0) {
> -            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
> -            exit(1);
> -        }
> -    } else {
> -        return;
> -    }
>   
>       /* First probe and see if there's a arch-specific hook to create the
>        * in-kernel irqchip for us */
> @@ -2377,8 +2367,10 @@ static void kvm_irqchip_create(KVMState *s)
>           if (s->kernel_irqchip_split == ON_OFF_AUTO_ON) {
>               error_report("Split IRQ chip mode not supported.");
>               exit(1);
> -        } else {
> +        } else if (kvm_has_create_irqchip) {
>               ret = kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP);
> +        } else {
> +            return;
>           }
>       }
>       if (ret < 0) {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 115f0cca79d1..84b1bb3dc91e 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -32,6 +32,7 @@
>   #ifdef CONFIG_KVM_IS_POSSIBLE
>   
>   extern bool kvm_allowed;
> +extern bool kvm_has_create_irqchip;
>   extern bool kvm_kernel_irqchip;
>   extern bool kvm_split_irqchip;
>   extern bool kvm_async_interrupts_allowed;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index b4c7654f4980..2fa87b495d68 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -250,6 +250,9 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
>       int ret = 0;
> +
> +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
> +
>       /* For ARM interrupt delivery is always asynchronous,
>        * whether we are using an in-kernel VGIC or not.
>        */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ebfaf3d24c79..6363e67f092d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2771,6 +2771,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
> +
>       return 0;
>   }
>   
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index a9e5880349d9..bcc735227f7d 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -391,6 +391,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>       }
>   
>       kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
> +
> +    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_S390_IRQCHIP);
> +    if (kvm_has_create_irqchip) {
> +        int ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
> +
> +        if (ret < 0) {
> +            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
> +            exit(1);
> +        }
> +    }
> +
>       return 0;
>   }
>   
