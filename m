Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094D868D4AA
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjBGKoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjBGKoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:44:02 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852A74697
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:43:53 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u21so14882006edv.3
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 02:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aysR5vD4/WnLwTb4+d5w/oRG3WV5hUhyo3zqkAwzu/U=;
        b=Lbh2pe2SjToYlM3eMWJzUh53QzYoufwjh4CPTc/bjLCazyH+ncXK+eer8vWsFvqy4E
         dS63E6+w9nNEBD+WLw3dAxs9pMNUbXbhfU7rPZLSsujniXj/GGkBcauI2iWuItF6gycI
         54wrnIJleIOeetLJkVAHWaAKW/+guFzRZzDq2SlUFBbH4ykFuv7WM9mx2m9HJx6Qui6v
         HnStCnysWCThx8A3pEBFvhUB1VNQ377RlR00ZfTtuZhw7G6lOd3HSsAGRTwq8JUyjVTj
         DO/HPV/rDEHORpSWE1RpZa1oz8aagS1ahu+617UvHXppuCC3Qq1XOCicpafrgYKMYOVD
         Fcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aysR5vD4/WnLwTb4+d5w/oRG3WV5hUhyo3zqkAwzu/U=;
        b=alQSzbI3RDteFnPGqRDCqaCxNxbqZj6yBxx7sLMGkw6uNTdt2QHDaCokQdX85b131C
         rqWuSJshsRcoFQuLxKTAYWEEU5xaPu6glqmuO6r/Kkeei2kq04GRLLLhd+peLN8fH6M8
         MgrcgO1RYmaRuXBMK+HiWQRMpJuieTUth5zTZX/0mjRDHff0rhQw5MW7cmaNUuw7VhT9
         ItUvCQnErYapYue7AnsCNCGggoOT6kzRblC9////KczFFeKmy6AxaGiuWdsUcG5IaVS0
         Dgi5hki+WJI1lGyHhDqdhwTBAv2WihDgv9sD0torDFRYBszW3pIMANmprguC1xwKj8jq
         RNwQ==
X-Gm-Message-State: AO0yUKX6GpYJcLzDjDvSVg1eOY/MA1ijKq6LWpuMyEU0yUedb6ppEMv6
        3jFe4Zxs0K34aZ3GY+Uf5kuIgw==
X-Google-Smtp-Source: AK7set/IowiI/By7ir9R0s0h5oXXHYPZkzjtB8Jz1q4EjqzQQMbwWh0Q2t9/YwfqtXE+WnydpjC5ug==
X-Received: by 2002:a50:bac4:0:b0:497:948b:e8 with SMTP id x62-20020a50bac4000000b00497948b00e8mr3104398ede.6.1675766632126;
        Tue, 07 Feb 2023 02:43:52 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id o11-20020a056402444b00b00495f4535a33sm6262099edb.74.2023.02.07.02.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 02:43:51 -0800 (PST)
Date:   Tue, 7 Feb 2023 11:43:50 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: Re: [PATCH v6 2/8] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20230207104350.ekjklgxehrc7qtil@orel>
References: <20230207095529.1787260-1-atishp@rivosinc.com>
 <20230207095529.1787260-3-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207095529.1787260-3-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 01:55:23AM -0800, Atish Patra wrote:
> SBI PMU extension allows KVM guests to configure/start/stop/query about
> the PMU counters in virtualized enviornment as well.
> 
> In order to allow that, KVM implements the entire SBI PMU extension.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/Makefile       |  2 +-
>  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c | 86 +++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
> 
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 5de1053..278e97c 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,4 +25,4 @@ kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> -kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index fe2897e..15fde15 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -20,6 +20,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>  };
>  #endif
>  
> +#ifdef CONFIG_RISCV_PMU_SBI
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> +#else
> +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> +	.extid_start = -1UL,
> +	.extid_end = -1UL,
> +	.handler = NULL,
> +};
> +#endif
> +
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>  	&vcpu_sbi_ext_v01,
>  	&vcpu_sbi_ext_base,
> @@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>  	&vcpu_sbi_ext_rfence,
>  	&vcpu_sbi_ext_srst,
>  	&vcpu_sbi_ext_hsm,
> +	&vcpu_sbi_ext_pmu,
>  	&vcpu_sbi_ext_experimental,
>  	&vcpu_sbi_ext_vendor,
>  };
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> new file mode 100644
> index 0000000..38efadb
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +				   struct kvm_vcpu_sbi_return *retdata)
> +{
> +	int ret = 0;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	unsigned long funcid = cp->a6;
> +	u64 temp;
> +
> +	if (!kvpmu->init_done) {
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> +		return 0;
> +	}
> +
> +	switch (funcid) {
> +	case SBI_EXT_PMU_NUM_COUNTERS:
> +		ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_GET_INFO:
> +		ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> +#else
> +		temp = cp->a4;
> +#endif
> +		/*
> +		 * This can fail if perf core framework fails to create an event.
> +		 * Forward the error to userspace which is an error happened

"Forward the error to userspace because it's an error which happened..."

(Can probably be fixed up on merge.)

> +		 * within the host kernel. The other option would be to convert
> +		 * to an SBI error and forward to the guest.
> +		 */
> +		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> +						       cp->a2, cp->a3, temp, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_START:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> +#else
> +		temp = cp->a3;
> +#endif
> +		ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> +						   temp, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_STOP:
> +		ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_FW_READ:
> +		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
> +		break;
> +	default:
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> +	}
> +
> +	return ret;
> +}
> +
> +static unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	return kvpmu->init_done;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> +	.extid_start = SBI_EXT_PMU,
> +	.extid_end = SBI_EXT_PMU,
> +	.handler = kvm_sbi_ext_pmu_handler,
> +	.probe = kvm_sbi_ext_pmu_probe,
> +};
> -- 
> 2.25.1
>

Thanks,
drew
