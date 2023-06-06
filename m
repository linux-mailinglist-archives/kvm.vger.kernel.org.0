Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A387244BB
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbjFFNqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjFFNqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:46:02 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D567E7D
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:45:59 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-392116b8f31so3330991b6e.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686059158; x=1688651158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itnC8pZM051W8Bgsl1usZo+NiqwRO3BOc/xPpYs/5bw=;
        b=C7YBAI71ppiB9hMBLvm2ya79uVRgD+/a6AqrBpYxxwgjqeRoRPmIowZBciLY8NID5h
         YTn1qcbjXwMle45b05V5s5RUygBPnH1tMnAhs8tVfCbr9rK4rJUJFLQrsHPSI0Jn5ygB
         pKEGX9Lw/Mx3q7E3KqoeRWq1zD2kEUw2joHaCqZrgjKjvtI7MP0ZCXHGQ6/eIJHwGaeJ
         4Je4qlltwxPT8HXaRyNawJrfGJtibIhOnTTisKKLnp3dI+VO0IpEuUeIo3UNZ8OxMHlg
         JykUI3cnV7HfUBL9+I57cvKJJnblvJ1M7uAt47NFKL/fjmYSrv/ZDYSGrFVfJ6hkzybY
         nTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686059158; x=1688651158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itnC8pZM051W8Bgsl1usZo+NiqwRO3BOc/xPpYs/5bw=;
        b=hdlZ7f0cDfvCvYjv30Mb0LuJRiu7fPeHfP42FZAYk3lz8RWie3sDlD+Vrz4zdP0bgd
         3q5CJYqTue/F8cXiZJXvr+zKllhazDcBQrrt2iRNL9AkRQeGewBiYEdmRGHki8Xp/m1f
         3BHxcEHE1JVLo/thuCpyiT9kcQX8GFaqqwFN8UhpaZottwwZWSrwL7MQlK52quI6zWS0
         c2o3h04DvkkBIv+0ma+xx5PvcJEZAExYjrz5BZmCNjLF3eBcZPKMp7jbuglvYFkBcAIY
         7t0xmvcDrgFQ5qavBu66ZrcVPMQCq0uppo10fHoaOk+xym1yohX8j9VpMPdKPwb6xptY
         6PUQ==
X-Gm-Message-State: AC+VfDzHhb3s8Cv9wS+dHwi3MthSkNOqXN9OJXrRroA9ElpszCXqJ28F
        X8xHZmCBu2dL5eNzFU27iDORoA==
X-Google-Smtp-Source: ACHHUZ7BiSKxVxnyhl5fKgvFGlkIlTbVdAE3sGePptPLlhsY1EjYMTnAGdlAAR6r/OXqA3hqz/euEQ==
X-Received: by 2002:a54:4715:0:b0:398:4336:4342 with SMTP id k21-20020a544715000000b0039843364342mr1499735oik.33.1686059158697;
        Tue, 06 Jun 2023 06:45:58 -0700 (PDT)
Received: from [192.168.68.107] ([177.170.117.52])
        by smtp.gmail.com with ESMTPSA id y126-20020aca3284000000b0038cff7034c0sm4521181oiy.27.2023.06.06.06.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 06:45:58 -0700 (PDT)
Message-ID: <a715b6d1-d28a-1e04-34c5-5d6c1fb2696e@ventanamicro.com>
Date:   Tue, 6 Jun 2023 10:45:53 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 4/6] target/riscv: Create an KVM AIA irqchip
Content-Language: en-US
To:     Yong-Xuan Wang <yongxuan.wang@sifive.com>, qemu-devel@nongnu.org,
        qemu-riscv@nongnu.org, rkanwal@rivosinc.com, anup@brainfault.org,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com, jim.shu@sifive.com
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230526062509.31682-1-yongxuan.wang@sifive.com>
 <20230526062509.31682-5-yongxuan.wang@sifive.com>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230526062509.31682-5-yongxuan.wang@sifive.com>
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



On 5/26/23 03:25, Yong-Xuan Wang wrote:
> implement a function to create an KVM AIA chip
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Jim Shu <jim.shu@sifive.com>
> ---
>   target/riscv/kvm.c       | 83 ++++++++++++++++++++++++++++++++++++++++
>   target/riscv/kvm_riscv.h |  3 ++
>   2 files changed, 86 insertions(+)
> 
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index eb469e8ca5..ead121154f 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -34,6 +34,7 @@
>   #include "exec/address-spaces.h"
>   #include "hw/boards.h"
>   #include "hw/irq.h"
> +#include "hw/intc/riscv_imsic.h"
>   #include "qemu/log.h"
>   #include "hw/loader.h"
>   #include "kvm_riscv.h"
> @@ -548,3 +549,85 @@ bool kvm_arch_cpu_check_are_resettable(void)
>   void kvm_arch_accel_class_init(ObjectClass *oc)
>   {
>   }
> +
> +void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int socket,
> +                          uint64_t aia_irq_num, uint64_t hart_count,
> +                          uint64_t aplic_base, uint64_t imsic_base)
> +{
> +    int ret;
> +    int aia_fd = -1;
> +    uint64_t aia_mode;
> +    uint64_t aia_nr_ids;
> +    uint64_t aia_hart_bits = find_last_bit(&hart_count, BITS_PER_LONG) + 1;
> +
> +    if (!msimode) {
> +        error_report("Currently KVM AIA only supports aplic_imsic mode");
> +        exit(1);
> +    }
> +
> +    aia_fd = kvm_create_device(kvm_state, KVM_DEV_TYPE_RISCV_AIA, false);
> +
> +    if (aia_fd < 0) {
> +        error_report("Unable to create in-kernel irqchip");
> +        exit(1);
> +    }
> +
> +    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +                            KVM_DEV_RISCV_AIA_CONFIG_MODE,
> +                            &aia_mode, false, NULL);
> +
> +    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +                            KVM_DEV_RISCV_AIA_CONFIG_IDS,
> +                            &aia_nr_ids, false, NULL);
> +
> +    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +                            KVM_DEV_RISCV_AIA_CONFIG_SRCS,
> +                            &aia_irq_num, true, NULL);
> +    if (ret < 0) {
> +        error_report("KVM AIA: fail to set number input irq lines");
> +        exit(1);
> +    }

I see that you didn't check 'ret' for the first 2 calls of kvm_device_access().
Is it intentional?

Since you're setting customized error messages for every step I think it's worth
also handling the case where we fail to set aia_mode and aia_nr_ids.


Thanks,


Daniel


> +
> +    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CONFIG,
> +                            KVM_DEV_RISCV_AIA_CONFIG_HART_BITS,
> +                            &aia_hart_bits, true, NULL);
> +    if (ret < 0) {
> +        error_report("KVM AIA: fail to set number of harts");
> +        exit(1);
> +    }
> +
> +    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
> +                            KVM_DEV_RISCV_AIA_ADDR_APLIC,
> +                            &aplic_base, true, NULL);
> +    if (ret < 0) {
> +        error_report("KVM AIA: fail to set the base address of APLIC");
> +        exit(1);
> +    }
> +
> +    for (int i = 0; i < hart_count; i++) {
> +        uint64_t imsic_addr = imsic_base + i * IMSIC_HART_SIZE(0);
> +        ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_ADDR,
> +                                KVM_DEV_RISCV_AIA_ADDR_IMSIC(i),
> +                                &imsic_addr, true, NULL);
> +        if (ret < 0) {
> +            error_report("KVM AIA: fail to set the base address of IMSICs");
> +            exit(1);
> +        }
> +    }
> +
> +    if (kvm_has_gsi_routing()) {
> +        for (uint64_t idx = 0; idx < aia_irq_num + 1; ++idx) {
> +            kvm_irqchip_add_irq_route(kvm_state, idx, socket, idx);
> +        }
> +        kvm_gsi_routing_allowed = true;
> +        kvm_irqchip_commit_routes(kvm_state);
> +    }
> +
> +    ret = kvm_device_access(aia_fd, KVM_DEV_RISCV_AIA_GRP_CTRL,
> +                            KVM_DEV_RISCV_AIA_CTRL_INIT,
> +                            NULL, true, NULL);
> +    if (ret < 0) {
> +        error_report("KVM AIA: initialized fail");
> +        exit(1);
> +    }
> +}
> diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
> index 606968a4b7..6067adff51 100644
> --- a/target/riscv/kvm_riscv.h
> +++ b/target/riscv/kvm_riscv.h
> @@ -21,6 +21,9 @@
>   
>   void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
>   void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
> +void kvm_riscv_aia_create(DeviceState *aplic_s, bool msimode, int socket,
> +                          uint64_t aia_irq_num, uint64_t hart_count,
> +                          uint64_t aplic_base, uint64_t imsic_base);
>   
>   #define KVM_DEV_RISCV_AIA_GRP_CONFIG            0
>   #define KVM_DEV_RISCV_AIA_CONFIG_MODE           0
