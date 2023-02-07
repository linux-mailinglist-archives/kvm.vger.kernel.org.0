Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFBF68D47B
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjBGKiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbjBGKiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:38:03 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E613867D
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:37:30 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id mc11so41955712ejb.10
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 02:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnpykC9OMn5+FOQw3Ft9zbugwWLplrL12mc+TPKFVjA=;
        b=NsvgcJYOCzuCxf0XwS/RJ3GZy2iLuM9XJRlXt8cu+kjHTsiwYzA42r9v5/MjYYipOE
         CUwuMbJ6Cq/6Py62scGR292a8pVIkWTfIFA35uWzOuen2dT9cL5qlmdfsjQ/Wl39p+sB
         AvpZo7JhM2JfS0Ztx3oe9MbqqFuMuvqpbUlYEwT8YHjhxXXj+GMunEKZs5iqfsoWLH5x
         rre0P+bOrV5uvR2gEo8YCHjNyTgbAG2j7cGqYe9Ui0dz754W7DV/uZC5BopmEH6pRlP1
         QCCU/no55soAjuGM/YaWE/QjkIQ59SCN9bfnS3xO0rMbdkOf1DSajg059Bj41rpwcFf3
         HAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnpykC9OMn5+FOQw3Ft9zbugwWLplrL12mc+TPKFVjA=;
        b=ts7weUOtjYYSDjc764XqjpIugi6a8xmmxhluXsZWzez6aC+oOjREfKggjc4GvjTgsa
         88Kchbs6q7GtVyqX814AS2ptrSp14n2LeZ9hEJ00QJDkQIEhbRc62fGhAIg+bls/thDj
         D5CeWJmzD25VWOH7e/MgzzVdw/c7LhUDvOSst6GWH91TURPzCDYR4bQRFWeIp44JAHTb
         8FusTKVmL6dClMY/ePvD/dh14I3pEuHcyNdeyhEtaj1cP9njdkNVKlM5uLNyTd3nZcfw
         GqPAOYrWYUo7xzwzKNq5hU+qQkWzHqh2YVFQzxnt0dC4p9b3+inDW39zcT8mvXuASL7D
         bqRQ==
X-Gm-Message-State: AO0yUKWfK18OzXlR1EvBzxSxNNEJxCrmvLXjghEbvgub7qgS/sbPOHR9
        QnwK0/bZMBb5GX05LDjsUnvnTw==
X-Google-Smtp-Source: AK7set+qgk+/M3O0bE1uN4phV5fkrTsB+Dyy4OVItYHgNq169XEkFil4UHMyi46tjic5CN8xQUc49w==
X-Received: by 2002:a17:906:d28b:b0:878:60da:1f63 with SMTP id ay11-20020a170906d28b00b0087860da1f63mr3005655ejb.43.1675766248807;
        Tue, 07 Feb 2023 02:37:28 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id bn18-20020a170906c0d200b0087f68a2681bsm6746772ejb.96.2023.02.07.02.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 02:37:28 -0800 (PST)
Date:   Tue, 7 Feb 2023 11:37:27 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: Re: [PATCH v6 1/8] RISC-V: KVM: Add skeleton support for perf
Message-ID: <20230207103727.jqgkyugsufgmsjrt@orel>
References: <20230207095529.1787260-1-atishp@rivosinc.com>
 <20230207095529.1787260-2-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207095529.1787260-2-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 01:55:22AM -0800, Atish Patra wrote:
> This patch only adds barebone structure of perf implementation. Most of
> the function returns zero at this point and will be implemented
> fully in the future.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |   4 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  75 ++++++++++++++
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu.c                 |   7 ++
>  arch/riscv/kvm/vcpu_pmu.c             | 138 ++++++++++++++++++++++++++
>  5 files changed, 225 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
>  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 93f43a3..b90be9a 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -18,6 +18,7 @@
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_pmu.h>
>  
>  #define KVM_MAX_VCPUS			1024
>  
> @@ -228,6 +229,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Don't run the VCPU (blocked) */
>  	bool pause;
> +
> +	/* Performance monitoring context */
> +	struct kvm_pmu pmu_context;
>  };
>  
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> new file mode 100644
> index 0000000..0b86a47
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -0,0 +1,75 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_PMU_H
> +#define __KVM_VCPU_RISCV_PMU_H
> +
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/sbi.h>
> +
> +#ifdef CONFIG_RISCV_PMU_SBI
> +#define RISCV_KVM_MAX_FW_CTRS	32
> +#define RISCV_KVM_MAX_HW_CTRS	32
> +#define RISCV_KVM_MAX_COUNTERS	(RISCV_KVM_MAX_HW_CTRS + RISCV_KVM_MAX_FW_CTRS)
> +static_assert(RISCV_KVM_MAX_COUNTERS <= 64);
> +
> +/* Per virtual pmu counter data */
> +struct kvm_pmc {
> +	u8 idx;
> +	struct perf_event *perf_event;
> +	u64 counter_val;
> +	union sbi_pmu_ctr_info cinfo;
> +	/* Event monitoring status */
> +	bool started;
> +};
> +
> +/* PMU data structure per vcpu */
> +struct kvm_pmu {
> +	struct kvm_pmc pmc[RISCV_KVM_MAX_COUNTERS];
> +	/* Number of the virtual firmware counters available */
> +	int num_fw_ctrs;
> +	/* Number of the virtual hardware counters available */
> +	int num_hw_ctrs;
> +	/* A flag to indicate that pmu initialization is done */
> +	bool init_done;
> +	/* Bit map of all the virtual counter used */
> +	DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
> +};
> +
> +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
> +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu_context))
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				 unsigned long ctr_mask, unsigned long flags, u64 ival,
> +				 struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				unsigned long ctr_mask, unsigned long flags,
> +				struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				     unsigned long ctr_mask, unsigned long flags,
> +				     unsigned long eidx, u64 evtdata,
> +				     struct kvm_vcpu_sbi_return *retdata);
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_return *retdata);
> +void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> +
> +#else
> +struct kvm_pmu {
> +};
> +
> +static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
> +#endif /* CONFIG_RISCV_PMU_SBI */
> +#endif /* !__KVM_VCPU_RISCV_PMU_H */
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 019df920..5de1053 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7c08567..7d010b0 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -138,6 +138,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>  	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>  
> +	kvm_riscv_vcpu_pmu_reset(vcpu);
> +
>  	vcpu->arch.hfence_head = 0;
>  	vcpu->arch.hfence_tail = 0;
>  	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
> @@ -194,6 +196,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	/* Setup VCPU timer */
>  	kvm_riscv_vcpu_timer_init(vcpu);
>  
> +	/* setup performance monitoring */
> +	kvm_riscv_vcpu_pmu_init(vcpu);
> +
>  	/* Reset VCPU */
>  	kvm_riscv_reset_vcpu(vcpu);
>  
> @@ -216,6 +221,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	/* Cleanup VCPU timer */
>  	kvm_riscv_vcpu_timer_deinit(vcpu);
>  
> +	kvm_riscv_vcpu_pmu_deinit(vcpu);
> +
>  	/* Free unused pages pre-allocated for G-stage page table mappings */
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> new file mode 100644
> index 0000000..e79721b
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -0,0 +1,138 @@
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
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/csr.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/kvm_vcpu_pmu.h>
> +#include <linux/kvm_host.h>
> +
> +#define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_return *retdata)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	retdata->out_val = kvm_pmu_num_counters(kvpmu);
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_return *retdata)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	if (cidx > RISCV_KVM_MAX_COUNTERS || cidx == 1) {
> +		retdata->err_val = SBI_ERR_INVALID_PARAM;
> +		return 0;
> +	}
> +
> +	retdata->out_val = kvpmu->pmc[cidx].cinfo.value;
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				 unsigned long ctr_mask, unsigned long flags, u64 ival,
> +				 struct kvm_vcpu_sbi_return *retdata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				unsigned long ctr_mask, unsigned long flags,
> +				struct kvm_vcpu_sbi_return *retdata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				     unsigned long ctr_mask, unsigned long flags,
> +				     unsigned long eidx, u64 evtdata,
> +				     struct kvm_vcpu_sbi_return *retdata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_return *retdata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +	int i = 0, ret, num_hw_ctrs = 0, hpm_width = 0;
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +
> +	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
> +	if (ret < 0 || !hpm_width || !num_hw_ctrs)
> +		return;

need blank line here

> +	/*
> +	 * Increase the number of hardware counters to offset the time counter.
> +	 */
> +	kvpmu->num_hw_ctrs = num_hw_ctrs + 1;
> +	kvpmu->num_fw_ctrs = SBI_PMU_FW_MAX;
> +
> +	if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
> +		pr_warn("Limiting the hardware counters to 32 as specified by the ISA");

pr_warn_once() and we need to set the prefix.

> +		kvpmu->num_hw_ctrs = RISCV_KVM_MAX_HW_CTRS;
> +	}

need blank line here

> +	/*
> +	 * There is no correlation between the logical hardware counter and virtual counters.
> +	 * However, we need to encode a hpmcounter CSR in the counter info field so that
> +	 * KVM can trap n emulate the read. This works well in the migration use case as
> +	 * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
> +	 */
> +	for (i = 0; i < kvm_pmu_num_counters(kvpmu); i++) {
> +		/* TIME CSR shouldn't be read from perf interface */
> +		if (i == 1)
> +			continue;
> +		pmc = &kvpmu->pmc[i];
> +		pmc->idx = i;
> +		if (i < kvpmu->num_hw_ctrs) {
> +			pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
> +			if (i < 3)
> +				/* CY, IR counters */
> +				pmc->cinfo.width = 63;
> +			else
> +				pmc->cinfo.width = hpm_width;
> +			/*
> +			 * The CSR number doesn't have any relation with the logical
> +			 * hardware counters. The CSR numbers are encoded sequentially
> +			 * to avoid maintaining a map between the virtual counter
> +			 * and CSR number.
> +			 */
> +			pmc->cinfo.csr = CSR_CYCLE + i;
> +		} else {
> +			pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> +			pmc->cinfo.width = BITS_PER_LONG - 1;
> +		}
> +	}
> +
> +	kvpmu->init_done = true;
> +}
> +
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> +{
> +	/* TODO */
> +}
> +
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> +{
> +	kvm_riscv_vcpu_pmu_deinit(vcpu);
> +}
> -- 
> 2.25.1
>

Thanks,
drew
