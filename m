Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABD5614C88
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiKAO0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKAO0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:26:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649FA1A83F
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:26:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n12so37335620eja.11
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 07:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oVIuibKW7Di+NHpw7iDbFjaRzUNbZHTAtJupVrKnN1I=;
        b=U4fWyAMhWOG3hCLCogEuTz5Hv9u9XUphFx5Vg3AFjaJhjIOkTLj50uF4LDfLtaRWNV
         dSKACqGdqSeCgbMkJ8qZo4G9p8MREV9xRGNvxRh824kyLcQ7tvDs0O5m7C6dfqxA7NW+
         cF2TzSFiTu4LJR4c3wrtB4SIr1YgjDhPS5JfWIm2L9Xqhqnhh1qcCCWPC3h21GExAVJB
         0e/I7GQioRkyW+J7cvewoz2ETTxr4fMvngnAbbS/B92SgCQDjfdqNQelxpM1FlejPe1d
         1NbkiAHccCZoRxsRBFLQSe8+wgkhcwXWicBfO8cg++wmVsBcQM1ZayDZCseaevANwze1
         j5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVIuibKW7Di+NHpw7iDbFjaRzUNbZHTAtJupVrKnN1I=;
        b=kIO95woahYLY6wpkbnmOQxk31xyvhezffgXRpSNjt7DEBedywkv1HsgZUjs6QkDAVo
         hbma3JZ9l0lkgzHBHJj+8AyV7/0va20Q0i2Hg2nFybbq4ya2vw6untgjPNOzsoLinapN
         G6TnGGaJybkBELEvYX5uY39Jweyl6RQqmxNhm8oKyNsWcSYoXvTFU9yI5KgCMqF+aSbW
         SQ2VruttsCWlQ1desGxsVcTYac/a3EJ4y/Olt8GvBvP3YGJFu3IhFZFthJWh4hNCcX5Y
         ATD7WCkwMu18C85ps1hOZrnyYBoDyjS2Uc2sePEZj0PmeE+A5XK0JoQ3cbtxakAdNV4y
         XD7A==
X-Gm-Message-State: ACrzQf3GuXT5xxHnUjxH8vcFoLzdM2cagfJb00LuCU0cv97rBImlvv/E
        9D1KV/Z10rtbrOgy2ierJSf0PQ==
X-Google-Smtp-Source: AMsMyM4lOOJRlCZ+7BLMeDTWBlE5tKftEVsKjQPh7j2g2sPc7AfFGdOsPLoeTfoJpR1uuJZ243VD1w==
X-Received: by 2002:a17:906:ee89:b0:73d:70c5:1a4e with SMTP id wt9-20020a170906ee8900b0073d70c51a4emr17976079ejb.683.1667312792806;
        Tue, 01 Nov 2022 07:26:32 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id oq13-20020a170906cc8d00b0073022b796a7sm4286691ejb.93.2022.11.01.07.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 07:26:32 -0700 (PDT)
Date:   Tue, 1 Nov 2022 15:26:31 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC  6/9] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20221101142631.du54p4kyhlgf54cr@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-7-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718170205.2972215-7-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 10:02:02AM -0700, Atish Patra wrote:
> SBI PMU extension allows KVM guests to configure/start/stop/query about
> the PMU counters in virtualized enviornment as well.
> 
> In order to allow that, KVM implements the entire SBI PMU extension.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c | 81 +++++++++++++++++++++++++++++++++++
>  2 files changed, 92 insertions(+)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
> 
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d45e7da3f0d3..da9f7959340e 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -50,6 +50,16 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
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
> @@ -58,6 +68,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>  	&vcpu_sbi_ext_rfence,
>  	&vcpu_sbi_ext_srst,
>  	&vcpu_sbi_ext_hsm,
> +	&vcpu_sbi_ext_pmu,
>  	&vcpu_sbi_ext_experimental,
>  	&vcpu_sbi_ext_vendor,
>  };
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> new file mode 100644
> index 000000000000..90c51a95d4f4
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Rivos Inc
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
> +				   unsigned long *out_val,
> +				   struct kvm_cpu_trap *utrap,
> +				   bool *exit)
> +{
> +	int ret = -EOPNOTSUPP;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	unsigned long funcid = cp->a6;
> +	uint64_t temp;

I think we need something like

   if (!vcpu_to_pmu(vcpu)->enabled)
      return -EOPNOTSUPP;

here. Where 'enabled' is only true when we successfully initialize
the pmu. And, successful initialization depends on 
IS_ENABLED(CONFIG_RISCV_PMU_SBI) and
riscv_isa_extension_available(NULL, SSCOFPMF) as well as not
failing other things. And, KVM userspace should be able to
disable the pmu, which keep enabled from being set as well.

> +
> +	switch (funcid) {
> +	case SBI_EXT_PMU_NUM_COUNTERS:
> +		ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, out_val);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_GET_INFO:
> +		ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, out_val);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> +#else
> +		temp = cp->a4;
> +#endif
> +		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1, cp->a2, cp->a3, temp);
> +		if (ret >= 0) {
> +			*out_val = ret;
> +			ret = 0;
> +		}
> +		break;
> +	case SBI_EXT_PMU_COUNTER_START:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> +#else
> +		temp = cp->a3;
> +#endif
> +		ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2, temp);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_STOP:
> +		ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_FW_READ:
> +		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, out_val);
> +		break;
> +	default:
> +		ret = -EOPNOTSUPP;
> +	}
> +
> +	return ret;
> +}
> +
> +unsigned long kvm_sbi_ext_pmu_probe(unsigned long extid)
> +{
> +	/*
> +	 * PMU Extension is only available to guests if privilege mode filtering
> +	 * is available. Otherwise, guest will always count events while the
> +	 * execution is in hypervisor mode.
> +	 */
> +	return riscv_isa_extension_available(NULL, SSCOFPMF);
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
