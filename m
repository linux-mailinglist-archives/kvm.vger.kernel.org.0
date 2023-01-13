Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158E86696BF
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 13:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbjAMMP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 07:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240903AbjAMMOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 07:14:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB3C4A966
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 04:08:57 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id l22so22136387eja.12
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 04:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jnbUZGGjL+rosRj+FSC8wsQWV+EEXeilOT9itEbMEWE=;
        b=BvJXi8Qpby+D938MbsoRzB2EHFyJ3Owc54EUv/bxRgNJ2pEx2RjeaF/L0Q+lsSG3e9
         of8RVAl6/uxfAcz9PUr4+dGABno9LKIsQRRrn2fdy6Eg358j9CkevxZ2r3E+fyzIF1Ge
         9ijj/76wN7R5xOrR1L2FhbVSaaCNMZDQ9DviauZJnTUV7HFJRnT0QX/CdNnx8xT2E9qr
         HtK/NoZ6SmaCrUr6KKMnAybbGOSqoiwHysQ3KFp5C1jzmbUQWVbGL5q9Xz4hYdYTBU1q
         MAzlC8UWXpeDuD+LGQ5lXV+heeTqPw5oYvjHq9Aj5id4z+MUGaoWDsWtWaJJf7uDj6gc
         NnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnbUZGGjL+rosRj+FSC8wsQWV+EEXeilOT9itEbMEWE=;
        b=DddfiYGceOmLdgoVrt2inJ2XIys950aFIUzzF0P+4uZDKT2wYQz2hgndLXgPUqSA4i
         MgowzsJwh416lMDE5llKf2TC/e4lbeQenW9spIsSk5ZPoqxiynp/gtbbgjCovy8ytPag
         Yru/aWPwKig+nJ73oV+OYmBjECPEmXnTj4q7jcsETG9aFLHaEWK3a09uqWD7VN352Sa+
         EZbQrdp0CCRz0Vb6DFSTR4yYk/nmOh5pAAmMIBUPPFlAkX61Z4KGZvYNYfqmhoJl8kGp
         1CaAlii1W8Z5hwiPZBVVG/R/Z8j0ARdAw+/DBHpsTUvL7Dwc1QKnfD/AhyLacFT2Iu9D
         hbFw==
X-Gm-Message-State: AFqh2kq+pTIbD4f9oQV1n+t+NlRbG3ir7ay/UxOhI9Xcn17QeSJiIH5C
        61x5vkaECaN5zZ2bkI1bu/Y4WA==
X-Google-Smtp-Source: AMrXdXtRVGMIRJFmZmUw7xkS2/KVfGjjVF/1fxcSqBrDTOFXY530Ov+d7L0aSTTjLcfa6BSWVUB7Qg==
X-Received: by 2002:a17:907:cb84:b0:836:e8a6:f6f5 with SMTP id un4-20020a170907cb8400b00836e8a6f6f5mr70796735ejc.66.1673611736063;
        Fri, 13 Jan 2023 04:08:56 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709061da100b0086b7ffb3b92sm211550ejh.205.2023.01.13.04.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:08:55 -0800 (PST)
Date:   Fri, 13 Jan 2023 13:08:54 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 11/11] RISC-V: KVM: Implement firmware events
Message-ID: <20230113120854.axtnxmykmwh2ixeb@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-12-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-12-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:00:46AM -0800, Atish Patra wrote:
> SBI PMU extension defines a set of firmware events which can provide
> useful information to guests about number of SBI calls. As hypervisor
> implements the SBI PMU extension, these firmware events corresponds
> to ecall invocations between VS->HS mode. All other firmware events
> will always report zero if monitored as KVM doesn't implement them.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  16 ++++
>  arch/riscv/include/asm/sbi.h          |   2 +-
>  arch/riscv/kvm/tlb.c                  |   6 +-
>  arch/riscv/kvm/vcpu_pmu.c             | 105 ++++++++++++++++++++++----
>  arch/riscv/kvm/vcpu_sbi_replace.c     |   7 ++
>  5 files changed, 119 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 7a9a8e6..cccc6182 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -17,6 +17,14 @@
>  #define RISCV_KVM_MAX_FW_CTRS 32
>  #define RISCV_MAX_COUNTERS      64
>  
> +struct kvm_fw_event {
> +	/* Current value of the event */
> +	unsigned long value;
> +
> +	/* Event monitoring status */
> +	bool started;
> +};
> +
>  /* Per virtual pmu counter data */
>  struct kvm_pmc {
>  	u8 idx;
> @@ -25,11 +33,14 @@ struct kvm_pmc {
>  	union sbi_pmu_ctr_info cinfo;
>  	/* Event monitoring status */
>  	bool started;
> +	/* Monitoring event ID */
> +	unsigned long event_idx;
>  };
>  
>  /* PMU data structure per vcpu */
>  struct kvm_pmu {
>  	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
> +	struct kvm_fw_event fw_event[RISCV_KVM_MAX_FW_CTRS];
>  	/* Number of the virtual firmware counters available */
>  	int num_fw_ctrs;
>  	/* Number of the virtual hardware counters available */
> @@ -52,6 +63,7 @@ struct kvm_pmu {
>  { .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
>  #endif
>  
> +int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid);
>  int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
>  				unsigned long *val, unsigned long new_val,
>  				unsigned long wr_mask);
> @@ -81,6 +93,10 @@ struct kvm_pmu {
>  #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
>  { .base = 0,      .count = 0, .func = NULL },
>  
> +static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
> +{
> +	return 0;
> +}
>  
>  static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 2a0ef738..a192a95a 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -171,7 +171,7 @@ enum sbi_pmu_fw_generic_events_t {
>  	SBI_PMU_FW_IPI_SENT		= 6,
>  	SBI_PMU_FW_IPI_RECVD		= 7,
>  	SBI_PMU_FW_FENCE_I_SENT		= 8,
> -	SBI_PMU_FW_FENCE_I_RECVD	= 9,
> +	SBI_PMU_FW_FENCE_I_RCVD		= 9,

This should probably be in its own patch.

>  	SBI_PMU_FW_SFENCE_VMA_SENT	= 10,
>  	SBI_PMU_FW_SFENCE_VMA_RCVD	= 11,
>  	SBI_PMU_FW_SFENCE_VMA_ASID_SENT	= 12,
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index 309d79b..de81920 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -181,6 +181,7 @@ void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
>  
>  void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
>  {
> +	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
>  	local_flush_icache_all();
>  }
>  
> @@ -264,15 +265,18 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
>  						d.addr, d.size, d.order);
>  			break;
>  		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
> +			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
>  			kvm_riscv_local_hfence_vvma_asid_gva(
>  						READ_ONCE(v->vmid), d.asid,
>  						d.addr, d.size, d.order);
>  			break;
>  		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
> +			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
>  			kvm_riscv_local_hfence_vvma_asid_all(
>  						READ_ONCE(v->vmid), d.asid);
>  			break;
>  		case KVM_RISCV_HFENCE_VVMA_GVA:
> +			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
>  			kvm_riscv_local_hfence_vvma_gva(
>  						READ_ONCE(v->vmid),
>  						d.addr, d.size, d.order);
> @@ -323,7 +327,7 @@ void kvm_riscv_fence_i(struct kvm *kvm,
>  		       unsigned long hbase, unsigned long hmask)
>  {
>  	make_xfence_request(kvm, hbase, hmask, KVM_REQ_FENCE_I,
> -			    KVM_REQ_FENCE_I, NULL);
> +		    KVM_REQ_FENCE_I, NULL);

stray change, and whitespace was correct before

>  }
>  
>  void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 21c1f0f..a64a7ae 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -170,18 +170,36 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
>  	return pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
>  }
>  
> +int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_fw_event *fevent;
> +
> +	if (!kvpmu || fid >= SBI_PMU_FW_MAX)
> +		return -EINVAL;
> +
> +	fevent = &kvpmu->fw_event[fid];
> +	if (fevent->started)
> +		fevent->value++;
> +
> +	return 0;
> +}
> +
>  static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  			unsigned long *out_val)
>  {
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
>  	u64 enabled, running;
> +	int fevent_code;
>  
>  	pmc = &kvpmu->pmc[cidx];
> -	if (!pmc->perf_event)
> -		return -EINVAL;
>  
> -	pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> +	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> +		fevent_code = get_event_code(pmc->event_idx);
> +		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
> +	} else if (pmc->perf_event)
> +		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
>  	*out_val = pmc->counter_val;
>  
>  	return 0;
> @@ -238,6 +256,7 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>  	int i, num_ctrs, pmc_index, sbiret = 0;
>  	struct kvm_pmc *pmc;
> +	int fevent_code;
>  
>  	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
>  	if (ctr_base + __fls(ctr_mask) >= num_ctrs) {
> @@ -253,7 +272,22 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  		pmc = &kvpmu->pmc[pmc_index];
>  		if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
>  			pmc->counter_val = ival;
> -		if (pmc->perf_event) {
> +		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> +			fevent_code = get_event_code(pmc->event_idx);
> +			if (fevent_code >= SBI_PMU_FW_MAX) {
> +				sbiret = SBI_ERR_INVALID_PARAM;
> +				goto out;
> +			}
> +
> +			/* Check if the counter was already started for some reason */
> +			if (kvpmu->fw_event[fevent_code].started) {
> +				sbiret = SBI_ERR_ALREADY_STARTED;
> +				continue;
> +			}
> +
> +			kvpmu->fw_event[fevent_code].started = true;
> +			kvpmu->fw_event[fevent_code].value = pmc->counter_val;
> +		} else if (pmc->perf_event) {
>  			if (unlikely(pmc->started)) {
>  				sbiret = SBI_ERR_ALREADY_STARTED;
>  				continue;
> @@ -281,6 +315,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  	int i, num_ctrs, pmc_index, sbiret = 0;
>  	u64 enabled, running;
>  	struct kvm_pmc *pmc;
> +	int fevent_code;
>  
>  	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
>  	if ((ctr_base + __fls(ctr_mask)) >= num_ctrs) {
> @@ -294,7 +329,18 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
>  			continue;
>  		pmc = &kvpmu->pmc[pmc_index];
> -		if (pmc->perf_event) {
> +		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> +			fevent_code = get_event_code(pmc->event_idx);
> +			if (fevent_code >= SBI_PMU_FW_MAX) {
> +				sbiret = SBI_ERR_INVALID_PARAM;
> +				goto out;
> +			}
> +
> +			if (!kvpmu->fw_event[fevent_code].started)
> +				sbiret = SBI_ERR_ALREADY_STOPPED;
> +
> +			kvpmu->fw_event[fevent_code].started = false;
> +		} else if (pmc->perf_event) {
>  			if (pmc->started) {
>  				/* Stop counting the counter */
>  				perf_event_disable(pmc->perf_event);
> @@ -307,12 +353,15 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  				pmc->counter_val += perf_event_read_value(pmc->perf_event,
>  									  &enabled, &running);
>  				pmu_release_perf_event(pmc);
> -				clear_bit(pmc_index, kvpmu->pmc_in_use);
>  			}
>  		} else {
>  			kvm_debug("Can not stop counter due to invalid confiugartion\n");
>  			sbiret = SBI_ERR_INVALID_PARAM;
>  		}
> +		if (flag & SBI_PMU_STOP_FLAG_RESET) {
> +			pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
> +			clear_bit(pmc_index, kvpmu->pmc_in_use);

nit: I'd probably just leave clear_bit where it was and add

if (flag & SBI_PMU_STOP_FLAG_RESET)
   pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;

to the firmware arm.

> +		}
>  	}
>  
>  out:
> @@ -329,12 +378,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>  	struct perf_event *event;
>  	struct perf_event_attr attr;
> -	int num_ctrs, ctr_idx;
> +	int num_ctrs, ctr_idx, sbiret = 0;
>  	u32 etype = pmu_get_perf_event_type(eidx);
>  	u64 config;
> -	struct kvm_pmc *pmc;
> -	int sbiret = 0;
> -
> +	struct kvm_pmc *pmc = NULL;
> +	bool is_fevent;
> +	unsigned long event_code;
>  
>  	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
>  	if (etype == PERF_TYPE_MAX || (ctr_base + __fls(ctr_mask) >= num_ctrs)) {
> @@ -342,7 +391,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  		goto out;
>  	}
>  
> -	if (pmu_is_fw_event(eidx)) {
> +	event_code = get_event_code(eidx);
> +	is_fevent = pmu_is_fw_event(eidx);
> +	if (is_fevent && event_code >= SBI_PMU_FW_MAX) {
>  		sbiret = SBI_ERR_NOT_SUPPORTED;
>  		goto out;
>  	}
> @@ -357,7 +408,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  			goto out;
>  		}
>  		ctr_idx = ctr_base;
> -		goto match_done;
> +		if (is_fevent)
> +			goto perf_event_done;
> +		else
> +			goto match_done;
>  	}
>  
>  	ctr_idx = pmu_get_pmc_index(kvpmu, eidx, ctr_base, ctr_mask);
> @@ -366,6 +420,13 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  		goto out;
>  	}
>  
> +	/*
> +	 * No need to create perf events for firmware events as the firmware counter
> +	 * is supposed to return the measurement of VS->HS mode invocations.
> +	 */
> +	if (is_fevent)
> +		goto perf_event_done;
> +
>  match_done:
>  	pmc = &kvpmu->pmc[ctr_idx];
>  	pmu_release_perf_event(pmc);
> @@ -404,10 +465,19 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  		return -EOPNOTSUPP;
>  	}
>  
> -	set_bit(ctr_idx, kvpmu->pmc_in_use);
>  	pmc->perf_event = event;
> -	if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> -		perf_event_enable(pmc->perf_event);

Maybe we can move the perf setup stuff into a helper function and
then guard it with an if-statement rather than have the gotos?

> +perf_event_done:
> +	if (flag & SBI_PMU_CFG_FLAG_AUTO_START) {
> +		if (is_fevent)
> +			kvpmu->fw_event[event_code].started = true;
> +		else
> +			perf_event_enable(pmc->perf_event);
> +	}
> +	/* This should be only true for firmware events */
> +	if (!pmc)
> +		pmc = &kvpmu->pmc[ctr_idx];
> +	pmc->event_idx = eidx;
> +	set_bit(ctr_idx, kvpmu->pmc_in_use);
>  
>  	ext_data->out_val = ctr_idx;
>  out:
> @@ -451,6 +521,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
>  	kvpmu->num_hw_ctrs = num_hw_ctrs;
>  	kvpmu->num_fw_ctrs = num_fw_ctrs;
> +	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));

I'm wondering if we need this array. We already have an underused pmc for
the fw events which has counter_val and started. Can't we just used those?

>  	/*
>  	 * There is no corelation betwen the logical hardware counter and virtual counters.
>  	 * However, we need to encode a hpmcounter CSR in the counter info field so that
> @@ -464,6 +535,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  		pmc = &kvpmu->pmc[i];
>  		pmc->idx = i;
>  		pmc->counter_val = 0;
> +		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>  		if (i < kvpmu->num_hw_ctrs) {
>  			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
>  			if (i < 3)
> @@ -501,7 +573,10 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
>  	for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
>  		pmc = &kvpmu->pmc[i];
>  		pmu_release_perf_event(pmc);
> +		pmc->counter_val = 0;
> +		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>  	}
> +	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
>  }
>  
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> index d029136..3f39711 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -11,6 +11,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_pmu.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  
>  static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> @@ -26,6 +27,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		return 0;
>  	}
>  
> +	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_SET_TIMER);
>  #if __riscv_xlen == 32
>  	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
>  #else
> @@ -58,6 +60,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		return 0;
>  	}
>  
> +	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_IPI_SENT);
>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
>  		if (hbase != -1UL) {
>  			if (tmp->vcpu_id < hbase)
> @@ -68,6 +71,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
>  		if (ret < 0)
>  			break;
> +		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RECVD);
>  	}
>  
>  	return ret;
> @@ -91,6 +95,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>  	switch (funcid) {
>  	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
>  		kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
> +		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
>  		break;
>  	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
>  		if (cp->a2 == 0 && cp->a3 == 0)
> @@ -98,6 +103,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>  		else
>  			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
>  						  cp->a2, cp->a3, PAGE_SHIFT);
> +		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
>  		break;
>  	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
>  		if (cp->a2 == 0 && cp->a3 == 0)
> @@ -108,6 +114,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
>  						       hbase, hmask,
>  						       cp->a2, cp->a3,
>  						       PAGE_SHIFT, cp->a4);
> +		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
>  		break;
>  	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
>  	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
> -- 
> 2.25.1
>

It think it'd be nice to break the application of
kvm_riscv_vcpu_pmu_incr_fw() out of this patch. I.e. introduce
kvm_riscv_vcpu_pmu_incr_fw() in this patch and then a second patch
applies it to all the ecalls.

Thanks,
drew
