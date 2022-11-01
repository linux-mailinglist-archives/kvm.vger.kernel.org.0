Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD924614CB4
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiKAOgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKAOf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:35:58 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6891C909
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:35:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id d26so37455833eje.10
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 07:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYPB288t3Efstem95rPO+YdVhZEmDwnMRaqEEG/LRfc=;
        b=FgSzhWqwYbV9oo9K4oYeSnfnR7vD9i3Bo6sxoGhp7IiYzoxbuNbloOaeVKhvQJCE+3
         kHax4jT2UFvyhLC5+y6ryWuXzsHClK3qwxclxrQhf8+ZT1vGO5RrHuYXU559b8TRm8qe
         2TT3oKvGXJw/eJZJlMqU6SCjJqhbYc96FmXPS1IAEUhl3DoCWVRVar6K8XKqVqOfB5W3
         dy4Tz/5JfyrSTIHu39fZM4Nk8ZsAsBM3pAQ8V8lAPbkefW7YWb+Z2FW9Zg62ZRRX3yl+
         iJWWDYSxeK0rp0UQkkY02SCudm3McNPWuJ6is8xEC3WLwDwkfttRdIaB+Rt/6XPkcnZf
         KVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYPB288t3Efstem95rPO+YdVhZEmDwnMRaqEEG/LRfc=;
        b=saF16y/Mk648V7utK4+tSTdxo6jSxqzIsBZIWOi91B1+p2F0f5WS31+ZKmrKubGWiQ
         PxNMheTXAnX1DVdstyTI3FAFWSO8J9O+xYw8difHsP1y3FnKAiwEOz8ex2d7XQnO7x6e
         DLSYtOoAjyeeBi+XZWfYPznChuSr2XgOmz08l4Ik4qHzEhVOVFRUJ24voVWYt8TZ/q6a
         9b9DTy/p4KSjbvWZcnMWQ8OO+D1JVIGK91DMgsi0D6YqeC043oUHVPhUIg3oiZa7uW/L
         gK4fBv64TA/K0w64iE/T2PbhYBMkiu/P1k1pWanjyzOzaxopNxBqmaaEYRlZXTUPMe3W
         Kl9g==
X-Gm-Message-State: ACrzQf0qPj7+vvj0Rx8ksqNPUHgU5ams+n2ZJLaO2oOtSb4ziM6nmSj/
        +S/rTUrYxas8+6TTDIVHiBk99Q9SxXUTXg==
X-Google-Smtp-Source: AMsMyM7EX+j90ZoHRKgqfXGs78hwQNNbX8fumBaOW8R2gLNs5oMsANxHEyyD3k64b09MuAf//jzV1g==
X-Received: by 2002:a17:906:dc8c:b0:7ad:a030:c305 with SMTP id cs12-20020a170906dc8c00b007ada030c305mr18221724ejc.132.1667313350061;
        Tue, 01 Nov 2022 07:35:50 -0700 (PDT)
Received: from localhost (cst2-173-61.cust.vodafone.cz. [31.30.173.61])
        by smtp.gmail.com with ESMTPSA id eh22-20020a0564020f9600b00461bacee867sm4584688edb.25.2022.11.01.07.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 07:35:49 -0700 (PDT)
Date:   Tue, 1 Nov 2022 15:35:48 +0100
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
Subject: Re: [RFC  7/9] RISC-V: KVM: Implement trap & emulate for hpmcounters
Message-ID: <20221101143548.plvlhedzt3oifa3u@kamzik>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
 <20220718170205.2972215-8-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718170205.2972215-8-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 10:02:03AM -0700, Atish Patra wrote:
> As the KVM guests only see the virtual PMU counters, all hpmcounter
> access should trap and KVM emulates the read access on behalf of guests.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 +++++++++
>  arch/riscv/kvm/vcpu_insn.c            |  1 +
>  arch/riscv/kvm/vcpu_pmu.c             | 47 +++++++++++++++++++++++----
>  3 files changed, 57 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index bffee052f2ae..5410236b62a8 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -39,6 +39,19 @@ struct kvm_pmu {
>  #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
>  #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
>  
> +#if defined(CONFIG_32BIT)
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = CSR_CYCLEH,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm }, \
> +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> +#else
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
> +#endif
> +
> +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +				unsigned long *val, unsigned long new_val,
> +				unsigned long wr_mask);
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, unsigned long *out_val);
>  int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
>  				unsigned long *ctr_info);
> @@ -59,6 +72,9 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>  #else
>  struct kvm_pmu {
>  };
> +#define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
> +{ .base = 0,      .count = 0, .func = NULL },
> +
>  
>  static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index 0aa334f853c8..7c2a4b1a69f7 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -215,6 +215,7 @@ struct csr_func {
>  };
>  
>  static const struct csr_func csr_funcs[] = {
> +	KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS
>  };
>  
>  /**
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 3168ed740bdd..5434051f495d 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -14,6 +14,46 @@
>  #include <asm/kvm_vcpu_pmu.h>
>  #include <linux/kvm_host.h>
>  
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				unsigned long *out_val)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	u64 enabled, running;
> +
> +	if (!kvpmu)
> +		return -EINVAL;
> +
> +	pmc = &kvpmu->pmc[cidx];
> +	if (!pmc->perf_event)
> +		return -EINVAL;
> +
> +	pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> +	*out_val = pmc->counter_val;
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
> +				unsigned long *val, unsigned long new_val,
> +				unsigned long wr_mask)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	int cidx, ret = KVM_INSN_CONTINUE_NEXT_SEPC;
> +
> +	if (!kvpmu)
> +		return KVM_INSN_EXIT_TO_USER_SPACE;
> +	//TODO: Should we check if vcpu pmu is initialized or not!

I guess it depends on the path to this call. It'd be best to keep the
checks to the minimum, so if this isn't a top level call then I'd say
no, but we need to check in the top level.

> +	if (wr_mask)
> +		return KVM_INSN_ILLEGAL_TRAP;
> +	cidx = csr_num - CSR_CYCLE;
> +
> +	if (kvm_riscv_vcpu_pmu_ctr_read(vcpu, cidx, val) < 0)
> +		return KVM_INSN_EXIT_TO_USER_SPACE;
> +
> +	return ret;
> +}
> +
>  int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, unsigned long *out_val)
>  {
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> @@ -60,13 +100,6 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  	return 0;
>  }
>  
> -int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> -				unsigned long *out_val)
> -{
> -	/* TODO */
> -	return 0;
> -}
> -
>  int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  {
>  	int i = 0, num_hw_ctrs, num_fw_ctrs, hpm_width;
> -- 
> 2.25.1
>

Thanks,
drew
