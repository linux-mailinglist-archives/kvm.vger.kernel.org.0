Return-Path: <kvm+bounces-5311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C036A81FC6B
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 02:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA1881C21F1E
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 01:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC225C9D;
	Fri, 29 Dec 2023 01:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="lxqYziCP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EDF1FB6
	for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3600dc78bc0so11694405ab.2
        for <kvm@vger.kernel.org>; Thu, 28 Dec 2023 17:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1703814292; x=1704419092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M3T4Ksd03OeU/GnWZoXOjY2BomM5vMdeSw9vy4Fdn/4=;
        b=lxqYziCPixN6LabrIZm57cznoptnPzHP6Pmd1J30uI6pU9Sa2U8JsA3nc3r8IkRGfH
         dj7tOGhGodThM8wugfynC696BPOZf5Bvjm3zkFXK0ANiwCEoZDMZmEpEU3hmRdMxU7Tx
         JU1YrQuLI4gn69iTWZ2K2LvH+7sVlMyOVujs52t+/cQBsTPYMtU4Vi1VJgI2+wcWCDAb
         slgFZ8GSAnFtwTxaa4wOhzOK1rq0F0MX1Me1TDunIdsa1oI+u32KllTrex0IEoxeTEls
         qKMywSazBm6N+aC7uDXH/8cSwHDaQmhWNOunGYbsEW+CdZn44bpkFxzrN2OdI7g3LsN+
         TcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703814292; x=1704419092;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3T4Ksd03OeU/GnWZoXOjY2BomM5vMdeSw9vy4Fdn/4=;
        b=EkS9zOLGbr0R5i7PbYitH4FFetOL5K8U3oOZn6BBD2EU9LSIKb/PaHKIcxg0f39+kX
         bpwhOlYX7TbIbSn/zj6km5wl1+NutJSNm/EnpDdm5wmPpYkt+xainF//NGCeaETweBpT
         xjYqsWj2Ih6n82gfTbNJ481dnjNzpT/GWFWZGE0RcG7qqW46hLm/Kvg2vt5YchSBCGrl
         6FBK5Mv7L9OqJyxS9tOQLlSHNdU+R1Lf6KG4HMD/OYtbtHyEuj+9H99fVltVlM7J2oBG
         KAsMj1Pr3AdZm3407p0Tgz8MZAOmKyTVniHCDUCVoP70ncDf1qoRCWcmLeptESDcuaAV
         4aIQ==
X-Gm-Message-State: AOJu0Yz+ejGT7AzBiXTYQkR7CB16g8I/X/49dFM0YCATAZnCqlI9y234
	9btjO5HZlggmOSe+r1EgfgWjh6O6P+TKzA==
X-Google-Smtp-Source: AGHT+IEnOE+IJFw/5ZDHpBiEWW14/UF+xttX1/11SVGOrgQWVVk0JR7t4pq0gEqFQe442nq+Yo1JgA==
X-Received: by 2002:a92:c241:0:b0:35f:af09:23d1 with SMTP id k1-20020a92c241000000b0035faf0923d1mr15629500ilo.28.1703814292039;
        Thu, 28 Dec 2023 17:44:52 -0800 (PST)
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902b78c00b001cfca7b8ee7sm14485041pls.99.2023.12.28.17.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Dec 2023 17:44:51 -0800 (PST)
Date: Thu, 28 Dec 2023 17:44:51 -0800 (PST)
X-Google-Original-Date: Thu, 28 Dec 2023 17:44:40 PST (-0800)
Subject:     Re: [v1 05/10] drivers/perf: riscv: Implement SBI PMU snapshot function
In-Reply-To: <20231218104107.2976925-6-atishp@rivosinc.com>
CC: linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
  aou@eecs.berkeley.edu, alexghiti@rivosinc.com, ajones@ventanamicro.com, anup@brainfault.org,
  atishp@atishpatra.org, Conor Dooley <conor.dooley@microchip.com>, guoren@kernel.org, uwu@icenowy.me,
  kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
  Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, Will Deacon <will@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: Atish Patra <atishp@rivosinc.com>
Message-ID: <mhng-3ad08310-977e-4da5-8ef6-c9edeb0a606b@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 18 Dec 2023 02:41:02 PST (-0800), Atish Patra wrote:
> SBI v2.0 SBI introduced PMU snapshot feature which adds the following
> features.
>
> 1. Read counter values directly from the shared memory instead of
> csr read.
> 2. Start multiple counters with initial values with one SBI call.
>
> These functionalities optimizes the number of traps to the higher
> privilege mode. If the kernel is in VS mode while the hypervisor
> deploy trap & emulate method, this would minimize all the hpmcounter
> CSR read traps. If the kernel is running in S-mode, the benefits
> reduced to CSR latency vs DRAM/cache latency as there is no trap
> involved while accessing the hpmcounter CSRs.
>
> In both modes, it does saves the number of ecalls while starting
> multiple counter together with an initial values. This is a likely
> scenario if multiple counters overflow at the same time.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu.c       |   1 +
>  drivers/perf/riscv_pmu_sbi.c   | 210 +++++++++++++++++++++++++++++++--
>  include/linux/perf/riscv_pmu.h |   6 +
>  3 files changed, 205 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
> index 0dda70e1ef90..5b57acb770d3 100644
> --- a/drivers/perf/riscv_pmu.c
> +++ b/drivers/perf/riscv_pmu.c
> @@ -412,6 +412,7 @@ struct riscv_pmu *riscv_pmu_alloc(void)
>  		cpuc->n_events = 0;
>  		for (i = 0; i < RISCV_MAX_COUNTERS; i++)
>  			cpuc->events[i] = NULL;
> +		cpuc->snapshot_addr = NULL;
>  	}
>  	pmu->pmu = (struct pmu) {
>  		.event_init	= riscv_pmu_event_init,
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 646604f8c0a5..7def69707492 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -36,6 +36,9 @@ PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:63");
>
>  static bool sbi_v2_available;
> +static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
> +#define sbi_pmu_snapshot_available() \
> +	static_branch_unlikely(&sbi_pmu_snapshot_available)
>
>  static struct attribute *riscv_arch_formats_attr[] = {
>  	&format_attr_event.attr,
> @@ -485,14 +488,100 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>  	return ret;
>  }
>
> +static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct cpu_hw_events *cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
> +
> +		if (!cpu_hw_evt->snapshot_addr)
> +			continue;
> +
> +		free_page((unsigned long)cpu_hw_evt->snapshot_addr);
> +		cpu_hw_evt->snapshot_addr = NULL;
> +		cpu_hw_evt->snapshot_addr_phys = 0;
> +	}
> +}
> +
> +static int pmu_sbi_snapshot_alloc(struct riscv_pmu *pmu)
> +{
> +	int cpu;
> +	struct page *snapshot_page;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct cpu_hw_events *cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
> +
> +		if (cpu_hw_evt->snapshot_addr)
> +			continue;
> +
> +		snapshot_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +		if (!snapshot_page) {
> +			pmu_sbi_snapshot_free(pmu);
> +			return -ENOMEM;
> +		}
> +		cpu_hw_evt->snapshot_addr = page_to_virt(snapshot_page);
> +		cpu_hw_evt->snapshot_addr_phys = page_to_phys(snapshot_page);
> +	}
> +
> +	return 0;
> +}
> +
> +static void pmu_sbi_snapshot_disable(void)
> +{
> +	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, -1,
> +		  -1, 0, 0, 0, 0);
> +}
> +
> +static int pmu_sbi_snapshot_setup(struct riscv_pmu *pmu, int cpu)
> +{
> +	struct cpu_hw_events *cpu_hw_evt;
> +	struct sbiret ret = {0};
> +
> +	cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
> +	if (!cpu_hw_evt->snapshot_addr_phys)
> +		return -EINVAL;
> +
> +	if (cpu_hw_evt->snapshot_set_done)
> +		return 0;
> +
> +	if (IS_ENABLED(CONFIG_32BIT))
> +		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
> +				cpu_hw_evt->snapshot_addr_phys,
> +				(u64)(cpu_hw_evt->snapshot_addr_phys) >> 32, 0, 0, 0, 0);
> +	else
> +		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
> +				cpu_hw_evt->snapshot_addr_phys, 0, 0, 0, 0, 0);
> +
> +	/* Free up the snapshot area memory and fall back to SBI PMU calls without snapshot */
> +	if (ret.error) {
> +		if (ret.error != SBI_ERR_NOT_SUPPORTED)
> +			pr_warn("pmu snapshot setup failed with error %ld\n", ret.error);
> +		return sbi_err_map_linux_errno(ret.error);
> +	}
> +
> +	cpu_hw_evt->snapshot_set_done = true;
> +
> +	return 0;
> +}
> +
>  static u64 pmu_sbi_ctr_read(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
>  	struct sbiret ret;
>  	u64 val = 0;
> +	struct riscv_pmu *pmu = to_riscv_pmu(event->pmu);
> +	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
> +	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
>  	union sbi_pmu_ctr_info info = pmu_ctr_list[idx];
>
> +	/* Read the value from the shared memory directly */
> +	if (sbi_pmu_snapshot_available()) {
> +		val = sdata->ctr_values[idx];
> +		return val;
> +	}
> +
>  	if (pmu_sbi_is_fw_event(event)) {
>  		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
>  				hwc->idx, 0, 0, 0, 0, 0);
> @@ -512,6 +601,7 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
>  			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
>  	}
>
> +
>  	return val;
>  }
>
> @@ -539,6 +629,7 @@ static void pmu_sbi_ctr_start(struct perf_event *event, u64 ival)
>  	struct hw_perf_event *hwc = &event->hw;
>  	unsigned long flag = SBI_PMU_START_FLAG_SET_INIT_VALUE;
>
> +	/* There is no benefit setting SNAPSHOT FLAG for a single counter */
>  #if defined(CONFIG_32BIT)
>  	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, hwc->idx,
>  			1, flag, ival, ival >> 32, 0);
> @@ -559,16 +650,36 @@ static void pmu_sbi_ctr_stop(struct perf_event *event, unsigned long flag)
>  {
>  	struct sbiret ret;
>  	struct hw_perf_event *hwc = &event->hw;
> +	struct riscv_pmu *pmu = to_riscv_pmu(event->pmu);
> +	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
> +	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
>
>  	if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
>  	    (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
>  		pmu_sbi_reset_scounteren((void *)event);
>
> +	if (sbi_pmu_snapshot_available())
> +		flag |= SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
> +
>  	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, hwc->idx, 1, flag, 0, 0, 0);
> -	if (ret.error && (ret.error != SBI_ERR_ALREADY_STOPPED) &&
> -		flag != SBI_PMU_STOP_FLAG_RESET)
> +	if (!ret.error && sbi_pmu_snapshot_available()) {
> +		/*
> +		 * The counter snapshot is based on the index base specified by hwc->idx.
> +		 * The actual counter value is updated in shared memory at index 0 when counter
> +		 * mask is 0x01. To ensure accurate counter values, it's necessary to transfer
> +		 * the counter value to shared memory. However, if hwc->idx is zero, the counter
> +		 * value is already correctly updated in shared memory, requiring no further
> +		 * adjustment.
> +		 */
> +		if (hwc->idx > 0) {
> +			sdata->ctr_values[hwc->idx] = sdata->ctr_values[0];
> +			sdata->ctr_values[0] = 0;
> +		}
> +	} else if (ret.error && (ret.error != SBI_ERR_ALREADY_STOPPED) &&
> +		flag != SBI_PMU_STOP_FLAG_RESET) {
>  		pr_err("Stopping counter idx %d failed with error %d\n",
>  			hwc->idx, sbi_err_map_linux_errno(ret.error));
> +	}
>  }
>
>  static int pmu_sbi_find_num_ctrs(void)
> @@ -626,10 +737,14 @@ static inline void pmu_sbi_stop_all(struct riscv_pmu *pmu)
>  static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
>  {
>  	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
> +	unsigned long flag = 0;
> +
> +	if (sbi_pmu_snapshot_available())
> +		flag = SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
>
>  	/* No need to check the error here as we can't do anything about the error */
>  	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, 0,
> -		  cpu_hw_evt->used_hw_ctrs[0], 0, 0, 0, 0);
> +		  cpu_hw_evt->used_hw_ctrs[0], flag, 0, 0, 0);
>  }
>
>  /*
> @@ -638,11 +753,10 @@ static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
>   * while the overflowed counters need to be started with updated initialization
>   * value.
>   */
> -static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> -					       unsigned long ctr_ovf_mask)
> +static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cpu_hw_evt,
> +						   unsigned long ctr_ovf_mask)
>  {
>  	int idx = 0;
> -	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
>  	struct perf_event *event;
>  	unsigned long flag = SBI_PMU_START_FLAG_SET_INIT_VALUE;
>  	unsigned long ctr_start_mask = 0;
> @@ -677,6 +791,49 @@ static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
>  	}
>  }
>
> +static noinline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_events *cpu_hw_evt,
> +						   unsigned long ctr_ovf_mask)
> +{
> +	int idx = 0;
> +	struct perf_event *event;
> +	unsigned long flag = SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
> +	uint64_t max_period;
> +	struct hw_perf_event *hwc;
> +	u64 init_val = 0;
> +	unsigned long ctr_start_mask = 0;
> +	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
> +
> +	for_each_set_bit(idx, cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTERS) {
> +		if (ctr_ovf_mask & (1 << idx)) {
> +			event = cpu_hw_evt->events[idx];
> +			hwc = &event->hw;
> +			max_period = riscv_pmu_ctr_get_width_mask(event);
> +			init_val = local64_read(&hwc->prev_count) & max_period;
> +			sdata->ctr_values[idx] = init_val;
> +		}
> +		/* We donot need to update the non-overflow counters the previous
> +		 * value should have been there already.
> +		 */
> +	}
> +
> +	ctr_start_mask = cpu_hw_evt->used_hw_ctrs[0];
> +
> +	/* Start all the counters in a single shot */
> +	sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_mask,
> +		  flag, 0, 0, 0);
> +}
> +
> +static void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> +					unsigned long ctr_ovf_mask)
> +{
> +	struct cpu_hw_events *cpu_hw_evt = this_cpu_ptr(pmu->hw_events);
> +
> +	if (sbi_pmu_snapshot_available())
> +		pmu_sbi_start_ovf_ctrs_snapshot(cpu_hw_evt, ctr_ovf_mask);
> +	else
> +		pmu_sbi_start_ovf_ctrs_sbi(cpu_hw_evt, ctr_ovf_mask);
> +}
> +
>  static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
>  {
>  	struct perf_sample_data data;
> @@ -690,6 +847,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
>  	unsigned long overflowed_ctrs = 0;
>  	struct cpu_hw_events *cpu_hw_evt = dev;
>  	u64 start_clock = sched_clock();
> +	struct riscv_pmu_snapshot_data *sdata = cpu_hw_evt->snapshot_addr;
>
>  	if (WARN_ON_ONCE(!cpu_hw_evt))
>  		return IRQ_NONE;
> @@ -711,8 +869,10 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
>  	pmu_sbi_stop_hw_ctrs(pmu);
>
>  	/* Overflow status register should only be read after counter are stopped */
> -	ALT_SBI_PMU_OVERFLOW(overflow);
> -
> +	if (sbi_pmu_snapshot_available())
> +		overflow = sdata->ctr_overflow_mask;
> +	else
> +		ALT_SBI_PMU_OVERFLOW(overflow);
>  	/*
>  	 * Overflow interrupt pending bit should only be cleared after stopping
>  	 * all the counters to avoid any race condition.
> @@ -794,6 +954,9 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, struct hlist_node *node)
>  		enable_percpu_irq(riscv_pmu_irq, IRQ_TYPE_NONE);
>  	}
>
> +	if (sbi_pmu_snapshot_available())
> +		return pmu_sbi_snapshot_setup(pmu, cpu);
> +
>  	return 0;
>  }
>
> @@ -807,6 +970,9 @@ static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node)
>  	/* Disable all counters access for user mode now */
>  	csr_write(CSR_SCOUNTEREN, 0x0);
>
> +	if (sbi_pmu_snapshot_available())
> +		pmu_sbi_snapshot_disable();
> +
>  	return 0;
>  }
>
> @@ -1076,10 +1242,6 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
>  	pmu->event_unmapped = pmu_sbi_event_unmapped;
>  	pmu->csr_index = pmu_sbi_csr_index;
>
> -	ret = cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
> -	if (ret)
> -		return ret;
> -
>  	ret = riscv_pm_pmu_register(pmu);
>  	if (ret)
>  		goto out_unregister;
> @@ -1088,8 +1250,32 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_unregister;
>
> +	/* SBI PMU Snapsphot is only available in SBI v2.0 */
> +	if (sbi_v2_available) {
> +		ret = pmu_sbi_snapshot_alloc(pmu);
> +		if (ret)
> +			goto out_unregister;
> +
> +		ret = pmu_sbi_snapshot_setup(pmu, smp_processor_id());
> +		if (!ret) {
> +			pr_info("SBI PMU snapshot detected\n");
> +			/*
> +			 * We enable it once here for the boot cpu. If snapshot shmem setup
> +			 * fails during cpu hotplug process, it will fail to start the cpu
> +			 * as we can not handle hetergenous PMUs with different snapshot
> +			 * capability.
> +			 */
> +			static_branch_enable(&sbi_pmu_snapshot_available);
> +		}
> +		/* Snapshot is an optional feature. Continue if not available */
> +	}
> +
>  	register_sysctl("kernel", sbi_pmu_sysctl_table);
>
> +	ret = cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
> +	if (ret)
> +		return ret;
> +
>  	return 0;
>
>  out_unregister:
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
> index 43282e22ebe1..c3fa90970042 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -39,6 +39,12 @@ struct cpu_hw_events {
>  	DECLARE_BITMAP(used_hw_ctrs, RISCV_MAX_COUNTERS);
>  	/* currently enabled firmware counters */
>  	DECLARE_BITMAP(used_fw_ctrs, RISCV_MAX_COUNTERS);
> +	/* The virtual address of the shared memory where counter snapshot will be taken */
> +	void *snapshot_addr;
> +	/* The physical address of the shared memory where counter snapshot will be taken */
> +	phys_addr_t snapshot_addr_phys;
> +	/* Boolean flag to indicate setup is already done */
> +	bool snapshot_set_done;
>  };
>
>  struct riscv_pmu {

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

