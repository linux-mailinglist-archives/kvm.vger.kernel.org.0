Return-Path: <kvm+bounces-5334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F488203F3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 08:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8550E1F21755
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 07:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD90C3C3D;
	Sat, 30 Dec 2023 07:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="aeOAEKeT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B64D1FC5
	for <kvm@vger.kernel.org>; Sat, 30 Dec 2023 07:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-35fe47edd2eso14515255ab.0
        for <kvm@vger.kernel.org>; Fri, 29 Dec 2023 23:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1703923143; x=1704527943; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+pyesnG0hEtXm1mjuJhWgnlEryAoU5upJynSRlaf82o=;
        b=aeOAEKeT666KsQchqtEDEDsLFMAaoc82T+dJI7s+gzs0Libwq2oKY0sKenHsyfQhwU
         zbiZnMelpXRTAWYg9twIzFMH6Np3CVRSP986PmPjA3c+qZhDHi+JgxbSZtXyYxrkm4oQ
         rgV+/CpfKQKl3m3VrA1E4zY60SQ/SWByHDaO1bVpIhp5N+EZ0eIOudFHtVJNcO0KmUAA
         1LId5cKQ6PfZ5RoEm+3k51X2JnhZReGiYtTdqKxIOuqEBYZ08kt/YlxXSWvIlFgCAFi0
         j5vi8JnfpT0fno64QvD4pna6h8NyxWiWlew/I2FCI4uD/LA682hVVVrgFuN/yKKdzFPa
         ZcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703923143; x=1704527943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+pyesnG0hEtXm1mjuJhWgnlEryAoU5upJynSRlaf82o=;
        b=Xi4OjwCgEtjUPSeA9ZmKLCBVA3Ugk0Es23fsr2M3ARYRTevqqga4wx9TGJ9vTtsT3V
         MtYHb+mxE1sJvDvFsxkEVIufkGOiAsiJPn6NWxMR45EqVZVV019LUsIyAVfDEH0cn4rC
         VtJXQ6shXrLpksC6smx8bDRSy8A7J4H8UxOFjzlMmIqKh25/xcJlmmgOd3IPs/b9W8IH
         wectF93cjuAWnFlnTWxOdlQA4NEH1b2LIvYaoMfanBMqTP67fsrmJygywf8tTZw1lret
         7BF7rYVUnY+LGD2TWPyuHU0BhH2WOze+Xmr2AAgGgx7F0tA47QAh04wgytQK5wXjG7N+
         /d7Q==
X-Gm-Message-State: AOJu0YwjVUmBDURsaMyWPCFe6UmIadyjM9C8h7QLJw3slr7Ctex6PFem
	8HRIaojEfpgrqtgH8Wr0yfyLh5+cc4k+fuBaPz00Xt2olZP7VA==
X-Google-Smtp-Source: AGHT+IFenfSUSo14x32rCYf1B7U/96x+7f407nvc7sgM2Fz2jbKGvCuwE6srEsb9FpG8+dFJtiQPXKCSQ/XF4DuTWyk=
X-Received: by 2002:a05:6e02:1947:b0:35f:b61f:a8a0 with SMTP id
 x7-20020a056e02194700b0035fb61fa8a0mr9480676ilu.13.1703923143259; Fri, 29 Dec
 2023 23:59:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229214950.4061381-1-atishp@rivosinc.com> <20231229214950.4061381-6-atishp@rivosinc.com>
In-Reply-To: <20231229214950.4061381-6-atishp@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Sat, 30 Dec 2023 13:28:53 +0530
Message-ID: <CAAhSdy2Ehif8MmVKg72y6qSyzD_4_48LP9dNLU6ULev458FbYw@mail.gmail.com>
Subject: Re: [v2 05/10] drivers/perf: riscv: Implement SBI PMU snapshot function
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Guo Ren <guoren@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 3:20=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
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
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  drivers/perf/riscv_pmu.c       |   1 +
>  drivers/perf/riscv_pmu_sbi.c   | 208 +++++++++++++++++++++++++++++++--
>  include/linux/perf/riscv_pmu.h |   6 +
>  3 files changed, 203 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
> index 0dda70e1ef90..5b57acb770d3 100644
> --- a/drivers/perf/riscv_pmu.c
> +++ b/drivers/perf/riscv_pmu.c
> @@ -412,6 +412,7 @@ struct riscv_pmu *riscv_pmu_alloc(void)
>                 cpuc->n_events =3D 0;
>                 for (i =3D 0; i < RISCV_MAX_COUNTERS; i++)
>                         cpuc->events[i] =3D NULL;
> +               cpuc->snapshot_addr =3D NULL;
>         }
>         pmu->pmu =3D (struct pmu) {
>                 .event_init     =3D riscv_pmu_event_init,
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 646604f8c0a5..1aeb8c59e78f 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -36,6 +36,9 @@ PMU_FORMAT_ATTR(event, "config:0-47");
>  PMU_FORMAT_ATTR(firmware, "config:63");
>
>  static bool sbi_v2_available;
> +static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
> +#define sbi_pmu_snapshot_available() \
> +       static_branch_unlikely(&sbi_pmu_snapshot_available)
>
>  static struct attribute *riscv_arch_formats_attr[] =3D {
>         &format_attr_event.attr,
> @@ -485,14 +488,100 @@ static int pmu_sbi_event_map(struct perf_event *ev=
ent, u64 *econfig)
>         return ret;
>  }
>
> +static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
> +{
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu) {
> +               struct cpu_hw_events *cpu_hw_evt =3D per_cpu_ptr(pmu->hw_=
events, cpu);
> +
> +               if (!cpu_hw_evt->snapshot_addr)
> +                       continue;
> +
> +               free_page((unsigned long)cpu_hw_evt->snapshot_addr);
> +               cpu_hw_evt->snapshot_addr =3D NULL;
> +               cpu_hw_evt->snapshot_addr_phys =3D 0;
> +       }
> +}
> +
> +static int pmu_sbi_snapshot_alloc(struct riscv_pmu *pmu)
> +{
> +       int cpu;
> +       struct page *snapshot_page;
> +
> +       for_each_possible_cpu(cpu) {
> +               struct cpu_hw_events *cpu_hw_evt =3D per_cpu_ptr(pmu->hw_=
events, cpu);
> +
> +               if (cpu_hw_evt->snapshot_addr)
> +                       continue;
> +
> +               snapshot_page =3D alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +               if (!snapshot_page) {
> +                       pmu_sbi_snapshot_free(pmu);
> +                       return -ENOMEM;
> +               }
> +               cpu_hw_evt->snapshot_addr =3D page_to_virt(snapshot_page)=
;
> +               cpu_hw_evt->snapshot_addr_phys =3D page_to_phys(snapshot_=
page);
> +       }
> +
> +       return 0;
> +}
> +
> +static void pmu_sbi_snapshot_disable(void)
> +{
> +       sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, -1,
> +                 -1, 0, 0, 0, 0);
> +}
> +
> +static int pmu_sbi_snapshot_setup(struct riscv_pmu *pmu, int cpu)
> +{
> +       struct cpu_hw_events *cpu_hw_evt;
> +       struct sbiret ret =3D {0};
> +
> +       cpu_hw_evt =3D per_cpu_ptr(pmu->hw_events, cpu);
> +       if (!cpu_hw_evt->snapshot_addr_phys)
> +               return -EINVAL;
> +
> +       if (cpu_hw_evt->snapshot_set_done)
> +               return 0;
> +
> +       if (IS_ENABLED(CONFIG_32BIT))
> +               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_S=
HMEM,
> +                               cpu_hw_evt->snapshot_addr_phys,
> +                               (u64)(cpu_hw_evt->snapshot_addr_phys) >> =
32, 0, 0, 0, 0);
> +       else
> +               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_S=
HMEM,
> +                               cpu_hw_evt->snapshot_addr_phys, 0, 0, 0, =
0, 0);
> +
> +       /* Free up the snapshot area memory and fall back to SBI PMU call=
s without snapshot */
> +       if (ret.error) {
> +               if (ret.error !=3D SBI_ERR_NOT_SUPPORTED)
> +                       pr_warn("pmu snapshot setup failed with error %ld=
\n", ret.error);
> +               return sbi_err_map_linux_errno(ret.error);
> +       }
> +
> +       cpu_hw_evt->snapshot_set_done =3D true;
> +
> +       return 0;
> +}
> +
>  static u64 pmu_sbi_ctr_read(struct perf_event *event)
>  {
>         struct hw_perf_event *hwc =3D &event->hw;
>         int idx =3D hwc->idx;
>         struct sbiret ret;
>         u64 val =3D 0;
> +       struct riscv_pmu *pmu =3D to_riscv_pmu(event->pmu);
> +       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> +       struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
>         union sbi_pmu_ctr_info info =3D pmu_ctr_list[idx];
>
> +       /* Read the value from the shared memory directly */
> +       if (sbi_pmu_snapshot_available()) {
> +               val =3D sdata->ctr_values[idx];
> +               return val;
> +       }
> +
>         if (pmu_sbi_is_fw_event(event)) {
>                 ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_REA=
D,
>                                 hwc->idx, 0, 0, 0, 0, 0);
> @@ -539,6 +628,7 @@ static void pmu_sbi_ctr_start(struct perf_event *even=
t, u64 ival)
>         struct hw_perf_event *hwc =3D &event->hw;
>         unsigned long flag =3D SBI_PMU_START_FLAG_SET_INIT_VALUE;
>
> +       /* There is no benefit setting SNAPSHOT FLAG for a single counter=
 */
>  #if defined(CONFIG_32BIT)
>         ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, hwc->id=
x,
>                         1, flag, ival, ival >> 32, 0);
> @@ -559,16 +649,36 @@ static void pmu_sbi_ctr_stop(struct perf_event *eve=
nt, unsigned long flag)
>  {
>         struct sbiret ret;
>         struct hw_perf_event *hwc =3D &event->hw;
> +       struct riscv_pmu *pmu =3D to_riscv_pmu(event->pmu);
> +       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> +       struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
>
>         if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
>             (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
>                 pmu_sbi_reset_scounteren((void *)event);
>
> +       if (sbi_pmu_snapshot_available())
> +               flag |=3D SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
> +
>         ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, hwc->idx=
, 1, flag, 0, 0, 0);
> -       if (ret.error && (ret.error !=3D SBI_ERR_ALREADY_STOPPED) &&
> -               flag !=3D SBI_PMU_STOP_FLAG_RESET)
> +       if (!ret.error && sbi_pmu_snapshot_available()) {
> +               /*
> +                * The counter snapshot is based on the index base specif=
ied by hwc->idx.
> +                * The actual counter value is updated in shared memory a=
t index 0 when counter
> +                * mask is 0x01. To ensure accurate counter values, it's =
necessary to transfer
> +                * the counter value to shared memory. However, if hwc->i=
dx is zero, the counter
> +                * value is already correctly updated in shared memory, r=
equiring no further
> +                * adjustment.
> +                */
> +               if (hwc->idx > 0) {
> +                       sdata->ctr_values[hwc->idx] =3D sdata->ctr_values=
[0];
> +                       sdata->ctr_values[0] =3D 0;
> +               }
> +       } else if (ret.error && (ret.error !=3D SBI_ERR_ALREADY_STOPPED) =
&&
> +               flag !=3D SBI_PMU_STOP_FLAG_RESET) {
>                 pr_err("Stopping counter idx %d failed with error %d\n",
>                         hwc->idx, sbi_err_map_linux_errno(ret.error));
> +       }
>  }
>
>  static int pmu_sbi_find_num_ctrs(void)
> @@ -626,10 +736,14 @@ static inline void pmu_sbi_stop_all(struct riscv_pm=
u *pmu)
>  static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
>  {
>         struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> +       unsigned long flag =3D 0;
> +
> +       if (sbi_pmu_snapshot_available())
> +               flag =3D SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
>
>         /* No need to check the error here as we can't do anything about =
the error */
>         sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, 0,
> -                 cpu_hw_evt->used_hw_ctrs[0], 0, 0, 0, 0);
> +                 cpu_hw_evt->used_hw_ctrs[0], flag, 0, 0, 0);
>  }
>
>  /*
> @@ -638,11 +752,10 @@ static inline void pmu_sbi_stop_hw_ctrs(struct risc=
v_pmu *pmu)
>   * while the overflowed counters need to be started with updated initial=
ization
>   * value.
>   */
> -static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> -                                              unsigned long ctr_ovf_mask=
)
> +static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *cp=
u_hw_evt,
> +                                               unsigned long ctr_ovf_mas=
k)
>  {
>         int idx =3D 0;
> -       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
>         struct perf_event *event;
>         unsigned long flag =3D SBI_PMU_START_FLAG_SET_INIT_VALUE;
>         unsigned long ctr_start_mask =3D 0;
> @@ -677,6 +790,48 @@ static inline void pmu_sbi_start_overflow_mask(struc=
t riscv_pmu *pmu,
>         }
>  }
>
> +static noinline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_event=
s *cpu_hw_evt,
> +                                                    unsigned long ctr_ov=
f_mask)
> +{
> +       int idx =3D 0;
> +       struct perf_event *event;
> +       unsigned long flag =3D SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
> +       u64 max_period, init_val =3D 0;
> +       struct hw_perf_event *hwc;
> +       unsigned long ctr_start_mask =3D 0;
> +       struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
> +
> +       for_each_set_bit(idx, cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTER=
S) {
> +               if (ctr_ovf_mask & (1 << idx)) {
> +                       event =3D cpu_hw_evt->events[idx];
> +                       hwc =3D &event->hw;
> +                       max_period =3D riscv_pmu_ctr_get_width_mask(event=
);
> +                       init_val =3D local64_read(&hwc->prev_count) & max=
_period;
> +                       sdata->ctr_values[idx] =3D init_val;
> +               }
> +               /* We donot need to update the non-overflow counters the =
previous
> +                * value should have been there already.
> +                */
> +       }
> +
> +       ctr_start_mask =3D cpu_hw_evt->used_hw_ctrs[0];
> +
> +       /* Start all the counters in a single shot */
> +       sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_ma=
sk,
> +                 flag, 0, 0, 0);
> +}
> +
> +static void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> +                                       unsigned long ctr_ovf_mask)
> +{
> +       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> +
> +       if (sbi_pmu_snapshot_available())
> +               pmu_sbi_start_ovf_ctrs_snapshot(cpu_hw_evt, ctr_ovf_mask)=
;
> +       else
> +               pmu_sbi_start_ovf_ctrs_sbi(cpu_hw_evt, ctr_ovf_mask);
> +}
> +
>  static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
>  {
>         struct perf_sample_data data;
> @@ -690,6 +845,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void =
*dev)
>         unsigned long overflowed_ctrs =3D 0;
>         struct cpu_hw_events *cpu_hw_evt =3D dev;
>         u64 start_clock =3D sched_clock();
> +       struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
>
>         if (WARN_ON_ONCE(!cpu_hw_evt))
>                 return IRQ_NONE;
> @@ -711,8 +867,10 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void=
 *dev)
>         pmu_sbi_stop_hw_ctrs(pmu);
>
>         /* Overflow status register should only be read after counter are=
 stopped */
> -       ALT_SBI_PMU_OVERFLOW(overflow);
> -
> +       if (sbi_pmu_snapshot_available())
> +               overflow =3D sdata->ctr_overflow_mask;
> +       else
> +               ALT_SBI_PMU_OVERFLOW(overflow);
>         /*
>          * Overflow interrupt pending bit should only be cleared after st=
opping
>          * all the counters to avoid any race condition.
> @@ -794,6 +952,9 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, str=
uct hlist_node *node)
>                 enable_percpu_irq(riscv_pmu_irq, IRQ_TYPE_NONE);
>         }
>
> +       if (sbi_pmu_snapshot_available())
> +               return pmu_sbi_snapshot_setup(pmu, cpu);
> +
>         return 0;
>  }
>
> @@ -807,6 +968,9 @@ static int pmu_sbi_dying_cpu(unsigned int cpu, struct=
 hlist_node *node)
>         /* Disable all counters access for user mode now */
>         csr_write(CSR_SCOUNTEREN, 0x0);
>
> +       if (sbi_pmu_snapshot_available())
> +               pmu_sbi_snapshot_disable();
> +
>         return 0;
>  }
>
> @@ -1076,10 +1240,6 @@ static int pmu_sbi_device_probe(struct platform_de=
vice *pdev)
>         pmu->event_unmapped =3D pmu_sbi_event_unmapped;
>         pmu->csr_index =3D pmu_sbi_csr_index;
>
> -       ret =3D cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &p=
mu->node);
> -       if (ret)
> -               return ret;
> -
>         ret =3D riscv_pm_pmu_register(pmu);
>         if (ret)
>                 goto out_unregister;
> @@ -1088,8 +1248,32 @@ static int pmu_sbi_device_probe(struct platform_de=
vice *pdev)
>         if (ret)
>                 goto out_unregister;
>
> +       /* SBI PMU Snapsphot is only available in SBI v2.0 */
> +       if (sbi_v2_available) {
> +               ret =3D pmu_sbi_snapshot_alloc(pmu);
> +               if (ret)
> +                       goto out_unregister;
> +
> +               ret =3D pmu_sbi_snapshot_setup(pmu, smp_processor_id());
> +               if (!ret) {
> +                       pr_info("SBI PMU snapshot detected\n");
> +                       /*
> +                        * We enable it once here for the boot cpu. If sn=
apshot shmem setup
> +                        * fails during cpu hotplug process, it will fail=
 to start the cpu
> +                        * as we can not handle hetergenous PMUs with dif=
ferent snapshot
> +                        * capability.
> +                        */
> +                       static_branch_enable(&sbi_pmu_snapshot_available)=
;
> +               }
> +               /* Snapshot is an optional feature. Continue if not avail=
able */
> +       }
> +
>         register_sysctl("kernel", sbi_pmu_sysctl_table);
>
> +       ret =3D cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &p=
mu->node);
> +       if (ret)
> +               return ret;
> +
>         return 0;
>
>  out_unregister:
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pm=
u.h
> index 43282e22ebe1..c3fa90970042 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -39,6 +39,12 @@ struct cpu_hw_events {
>         DECLARE_BITMAP(used_hw_ctrs, RISCV_MAX_COUNTERS);
>         /* currently enabled firmware counters */
>         DECLARE_BITMAP(used_fw_ctrs, RISCV_MAX_COUNTERS);
> +       /* The virtual address of the shared memory where counter snapsho=
t will be taken */
> +       void *snapshot_addr;
> +       /* The physical address of the shared memory where counter snapsh=
ot will be taken */
> +       phys_addr_t snapshot_addr_phys;
> +       /* Boolean flag to indicate setup is already done */
> +       bool snapshot_set_done;
>  };
>
>  struct riscv_pmu {
> --
> 2.34.1
>

