Return-Path: <kvm+bounces-4643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B248815D0E
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 02:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 052CB1F22506
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 01:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D3E10E7;
	Sun, 17 Dec 2023 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="J88tHZMV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A39A29
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50e1112b95cso1987282e87.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 17:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702777163; x=1703381963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87VgtLrsVnBC/vXeu/dX+n3QcvONDyrYH/eal0ksfI8=;
        b=J88tHZMVbYmbKaFK6jl+D6a5aGVmMadJ9+qlUvkzklarJr6ZIZl1j5ubL17uHgbaQ1
         jDsC+PBcxbO3NeyV6+aajsSmhkqVNiYNmzIY4xVsVcJMZcBktBJ5tJH7r1cv68Nggtik
         UJd6c4/zRZadgUUgbyPeKo+ZKkXoPcT8ynIh65WDJuHKmEdbrgAfyBG/6CpBJqYujXWL
         jE1VRfGylUmFlBE7I4AnjhhbQZN3iGMsaDmF4giruKgfsHCZwQPMxk+ZGrIHzTuDXfLX
         N+pqVVhL9TZG0Un5SqdknkzyW9VVHqErb1EovhiURfI+YxMV4MEB+Xb9QEa+9sX7Tt73
         aCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702777163; x=1703381963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87VgtLrsVnBC/vXeu/dX+n3QcvONDyrYH/eal0ksfI8=;
        b=avmVJeCMyMFgD9WHxQayFWcxEetCTj8fSYzbvp3zdIV+ZLzVmr3KXXaILSE9Sxl1+B
         umkp+YpWC0Y7I7o6XInsO967D84wl0k/7HnAZnsVeiUoTIyR0BFp0rVyQ5ck1p8ra3BV
         gahAs8iUpqmm4r973jXvomhiIZfNTMAWBrEiwEIxbI/xnR/B5ClTg9mQGI69xprlqTbb
         piTm1siI3bouP+9DCUGUt+/sVPEhhlatqCZr8o+xpDxSXzd6KaJmdSXLuJ4uW5yOnbJZ
         yb13kA92A6RjkOKla088r4VWImO8gy6JjXSCtBm9/Cq8gfVLiO5kBOf7KTa1oSCDUrmw
         uzoQ==
X-Gm-Message-State: AOJu0Yx+kqqnAT7MkHSXPKh8wKs6qQwnB475ON88Tsm8+vIyGa8PN7JC
	ZpUktMbx7gU4FzoSMaN8Afy4MF2TZwGiTydF477zMQ==
X-Google-Smtp-Source: AGHT+IHYyxZJFvn+TAi0VN0akPaVdmG8sWj49tXaetRZvdi6UsQ0wk8vPWdJdjl8UAtGRJ2cBJONswScFwNeo7Kc4tw=
X-Received: by 2002:a05:6512:138d:b0:50d:1552:1d92 with SMTP id
 fc13-20020a056512138d00b0050d15521d92mr5907752lfb.130.1702777163377; Sat, 16
 Dec 2023 17:39:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-7-atishp@rivosinc.com>
 <20231207-daycare-manager-2f4817171422@wendy>
In-Reply-To: <20231207-daycare-manager-2f4817171422@wendy>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Sat, 16 Dec 2023 17:39:12 -0800
Message-ID: <CAHBxVyE3xAAj=Z_Cu33tEKjXEAcnOV_=Jpkpn-+j5MoLj1FPWw@mail.gmail.com>
Subject: Re: [RFC 6/9] drivers/perf: riscv: Implement SBI PMU snapshot function
To: Conor Dooley <conor.dooley@microchip.com>
Cc: linux-kernel@vger.kernel.org, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 7, 2023 at 5:06=E2=80=AFAM Conor Dooley <conor.dooley@microchip=
.com> wrote:
>
> Hey Atish,
>
> On Mon, Dec 04, 2023 at 06:43:07PM -0800, Atish Patra wrote:
> > SBI v2.0 SBI introduced PMU snapshot feature which adds the following
> > features.
> >
> > 1. Read counter values directly from the shared memory instead of
> > csr read.
> > 2. Start multiple counters with initial values with one SBI call.
> >
> > These functionalities optimizes the number of traps to the higher
> > privilege mode. If the kernel is in VS mode while the hypervisor
> > deploy trap & emulate method, this would minimize all the hpmcounter
> > CSR read traps. If the kernel is running in S-mode, the benfits
> > reduced to CSR latency vs DRAM/cache latency as there is no trap
> > involved while accessing the hpmcounter CSRs.
> >
> > In both modes, it does saves the number of ecalls while starting
> > multiple counter together with an initial values. This is a likely
> > scenario if multiple counters overflow at the same time.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  drivers/perf/riscv_pmu.c       |   1 +
> >  drivers/perf/riscv_pmu_sbi.c   | 203 ++++++++++++++++++++++++++++++---
> >  include/linux/perf/riscv_pmu.h |   6 +
> >  3 files changed, 197 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
> > index 0dda70e1ef90..5b57acb770d3 100644
> > --- a/drivers/perf/riscv_pmu.c
> > +++ b/drivers/perf/riscv_pmu.c
> > @@ -412,6 +412,7 @@ struct riscv_pmu *riscv_pmu_alloc(void)
> >               cpuc->n_events =3D 0;
> >               for (i =3D 0; i < RISCV_MAX_COUNTERS; i++)
> >                       cpuc->events[i] =3D NULL;
> > +             cpuc->snapshot_addr =3D NULL;
> >       }
> >       pmu->pmu =3D (struct pmu) {
> >               .event_init     =3D riscv_pmu_event_init,
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.=
c
> > index 1c9049e6b574..1b8b6de63b69 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -36,6 +36,9 @@ PMU_FORMAT_ATTR(event, "config:0-47");
> >  PMU_FORMAT_ATTR(firmware, "config:63");
> >
> >  static bool sbi_v2_available;
> > +static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
> > +#define sbi_pmu_snapshot_available() \
> > +     static_branch_unlikely(&sbi_pmu_snapshot_available)
> >
> >  static struct attribute *riscv_arch_formats_attr[] =3D {
> >       &format_attr_event.attr,
> > @@ -485,14 +488,101 @@ static int pmu_sbi_event_map(struct perf_event *=
event, u64 *econfig)
> >       return ret;
> >  }
> >
> > +static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
> > +{
> > +     int cpu;
>
> > +     struct cpu_hw_events *cpu_hw_evt;
>
> This is only used inside the scope of the for loop.
>

Do you intend to suggest using mixed declarations ? Personally, I
prefer all the declarations upfront for readability.
Let me know if you think that's an issue or violates coding style.

> > +
> > +     for_each_possible_cpu(cpu) {
> > +             cpu_hw_evt =3D per_cpu_ptr(pmu->hw_events, cpu);
> > +             if (!cpu_hw_evt->snapshot_addr)
> > +                     continue;
>
> Could you add a blank line here please?

Done.

>
> > +             free_page((unsigned long)cpu_hw_evt->snapshot_addr);
> > +             cpu_hw_evt->snapshot_addr =3D NULL;
> > +             cpu_hw_evt->snapshot_addr_phys =3D 0;
>
> Why do these need to be explicitly zeroed?
>

We may get an allocation failure while allocating for all cpus. That's why,
we need to free the page and zero out the pointers for all the
possible cpus in that case.

> > +     }
> > +}
> > +
> > +static int pmu_sbi_snapshot_alloc(struct riscv_pmu *pmu)
> > +{
> > +     int cpu;
>
> > +     struct page *snapshot_page;
> > +     struct cpu_hw_events *cpu_hw_evt;
>
> Same here re scope
>

same reply as above.

> > +
> > +     for_each_possible_cpu(cpu) {
> > +             cpu_hw_evt =3D per_cpu_ptr(pmu->hw_events, cpu);
> > +             if (cpu_hw_evt->snapshot_addr)
> > +                     continue;
>
> Same here re blank line
>

Done.

> > +             snapshot_page =3D alloc_page(GFP_ATOMIC | __GFP_ZERO);
> > +             if (!snapshot_page) {
> > +                     pmu_sbi_snapshot_free(pmu);
> > +                     return -ENOMEM;
> > +             }
> > +             cpu_hw_evt->snapshot_addr =3D page_to_virt(snapshot_page)=
;
> > +             cpu_hw_evt->snapshot_addr_phys =3D page_to_phys(snapshot_=
page);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void pmu_sbi_snapshot_disable(void)
> > +{
> > +     sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, -1,
> > +               -1, 0, 0, 0, 0);
> > +}
> > +
> > +static int pmu_sbi_snapshot_setup(struct riscv_pmu *pmu, int cpu)
> > +{
> > +     struct cpu_hw_events *cpu_hw_evt;
> > +     struct sbiret ret =3D {0};
> > +     int rc;
> > +
> > +     cpu_hw_evt =3D per_cpu_ptr(pmu->hw_events, cpu);
> > +     if (!cpu_hw_evt->snapshot_addr_phys)
> > +             return -EINVAL;
> > +
> > +     if (cpu_hw_evt->snapshot_set_done)
> > +             return 0;
> > +
> > +#if defined(CONFIG_32BIT)
>
> Why does this need to be an `#if defined()`? Does the code not compile
> if you use IS_ENABLED()?
>

changed it to IS_ENABLED.

> > +     ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, cp=
u_hw_evt->snapshot_addr_phys,
> > +                    (u64)(cpu_hw_evt->snapshot_addr_phys) >> 32, 0, 0,=
 0, 0);
> > +#else
> > +     ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, cp=
u_hw_evt->snapshot_addr_phys,
> > +                     0, 0, 0, 0, 0);
> > +#endif
>
> > +     /* Free up the snapshot area memory and fall back to default SBI =
*/
>
> What does "fall back to the default SBI mean"? SBI is an interface so I
> don't understand what it means in this context. Secondly,

In absence of SBI PMU snapshot, the driver would try to read the
counters directly and end up traps.
Also, it would not use the SBI PMU snapshot flags in the SBI start/stop cal=
ls.
Snapshot is an alternative mechanism to minimize the traps. I just
wanted to highlight that.

How about this ?
"Free up the snapshot area memory and fall back to default SBI PMU
calls without snapshot */


> > +     if (ret.error) {
> > +             if (ret.error !=3D SBI_ERR_NOT_SUPPORTED)
> > +                     pr_warn("%s: pmu snapshot setup failed with error=
 %ld\n", __func__,
> > +                             ret.error);
>
> Why is the function relevant here? Is the error message in-and-of-itself
> not sufficient here? Where else would one be setting up the snapshots
> other than the setup function?
>

The SBI implementation (i.e OpenSBI) may or may not provide a snapshot
feature. This error message indicates
that SBI implementation supports PMU snapshot but setup failed for
some other error.

> > +             rc =3D sbi_err_map_linux_errno(ret.error);
>
> > +             if (rc)
> > +                     return rc;
>
> Is it even possible for !rc at this point? You've already checked that
> ret.error is non zero, so this just becomes
> `return sbi_err_map_linux_errno(ret.error);`?
>

Good catch. Thanks. Fixed it.

> > +     }
> > +
> > +     cpu_hw_evt->snapshot_set_done =3D true;
> > +
> > +     return 0;
> > +}
> > +
> >  static u64 pmu_sbi_ctr_read(struct perf_event *event)
> >  {
> >       struct hw_perf_event *hwc =3D &event->hw;
> >       int idx =3D hwc->idx;
> >       struct sbiret ret;
> >       u64 val =3D 0;
> > +     struct riscv_pmu *pmu =3D to_riscv_pmu(event->pmu);
> > +     struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> > +     struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
> >       union sbi_pmu_ctr_info info =3D pmu_ctr_list[idx];
> >
> > +     /* Read the value from the shared memory directly */
>
> Statement of the obvious, no?
>

Probably. Just wanted to be explicit for the reader who didn't read
the spec to understand how snapshot works.

> > +     if (sbi_pmu_snapshot_available()) {
> > +             val =3D sdata->ctr_values[idx];
> > +             goto done;
>
> s/goto done/return val/
> There's no cleanup to be done here, what purpose does the goto serve?
>

Sure. Done.

> > +     }
> > +
> >       if (pmu_sbi_is_fw_event(event)) {
> >               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_REA=
D,
> >                               hwc->idx, 0, 0, 0, 0, 0);
> > @@ -512,6 +602,7 @@ static u64 pmu_sbi_ctr_read(struct perf_event *even=
t)
> >                       val =3D ((u64)riscv_pmu_ctr_read_csr(info.csr + 0=
x80)) << 31 | val;
> >       }
> >
> > +done:
> >       return val;
> >  }
> >
> > @@ -539,6 +630,7 @@ static void pmu_sbi_ctr_start(struct perf_event *ev=
ent, u64 ival)
> >       struct hw_perf_event *hwc =3D &event->hw;
> >       unsigned long flag =3D SBI_PMU_START_FLAG_SET_INIT_VALUE;
> >
> > +     /* There is no benefit setting SNAPSHOT FLAG for a single counter=
 */
> >  #if defined(CONFIG_32BIT)
> >       ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, hwc->id=
x,
> >                       1, flag, ival, ival >> 32, 0);
> > @@ -559,16 +651,29 @@ static void pmu_sbi_ctr_stop(struct perf_event *e=
vent, unsigned long flag)
> >  {
> >       struct sbiret ret;
> >       struct hw_perf_event *hwc =3D &event->hw;
> > +     struct riscv_pmu *pmu =3D to_riscv_pmu(event->pmu);
> > +     struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> > +     struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
> >
> >       if ((hwc->flags & PERF_EVENT_FLAG_USER_ACCESS) &&
> >           (hwc->flags & PERF_EVENT_FLAG_USER_READ_CNT))
> >               pmu_sbi_reset_scounteren((void *)event);
> >
> > +     if (sbi_pmu_snapshot_available())
> > +             flag |=3D SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
> > +
> >       ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, hwc->idx=
, 1, flag, 0, 0, 0);
> > -     if (ret.error && (ret.error !=3D SBI_ERR_ALREADY_STOPPED) &&
> > -             flag !=3D SBI_PMU_STOP_FLAG_RESET)
> > +     if (!ret.error && sbi_pmu_snapshot_available()) {
>
> > +             /* Snapshot is taken relative to the counter idx base. Ap=
ply a fixup. */
> > +             if (hwc->idx > 0) {
> > +                     sdata->ctr_values[hwc->idx] =3D sdata->ctr_values=
[0];
> > +                     sdata->ctr_values[0] =3D 0;
>
> Why is this being zeroed in this manner? Why is zeroing it not required
> if hwc->idx =3D=3D 0? You've got a comment there that could probably do w=
ith
> elaboration.
>

hwc->idx is the counter_idx_base here. If it is zero, that means the
counter0 value is updated
in the shared memory. However, if the base > 0, we need to update the
relative counter value
from the shared memory. Does it make sense ?

> > +             }
> > +     } else if (ret.error && (ret.error !=3D SBI_ERR_ALREADY_STOPPED) =
&&
> > +             flag !=3D SBI_PMU_STOP_FLAG_RESET) {
> >               pr_err("Stopping counter idx %d failed with error %d\n",
> >                       hwc->idx, sbi_err_map_linux_errno(ret.error));
> > +     }
> >  }
> >
> >  static int pmu_sbi_find_num_ctrs(void)
> > @@ -626,10 +731,14 @@ static inline void pmu_sbi_stop_all(struct riscv_=
pmu *pmu)
> >  static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
> >  {
> >       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> > +     unsigned long flag =3D 0;
> > +
> > +     if (sbi_pmu_snapshot_available())
> > +             flag =3D SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
> >
> >       /* No need to check the error here as we can't do anything about =
the error */
> >       sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, 0,
> > -               cpu_hw_evt->used_hw_ctrs[0], 0, 0, 0, 0);
> > +               cpu_hw_evt->used_hw_ctrs[0], flag, 0, 0, 0);
> >  }
> >
> >  /*
> > @@ -638,11 +747,10 @@ static inline void pmu_sbi_stop_hw_ctrs(struct ri=
scv_pmu *pmu)
> >   * while the overflowed counters need to be started with updated initi=
alization
> >   * value.
> >   */
> > -static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> > -                                            unsigned long ctr_ovf_mask=
)
> > +static noinline void pmu_sbi_start_ovf_ctrs_sbi(struct cpu_hw_events *=
cpu_hw_evt,
> > +                                                unsigned long ctr_ovf_=
mask)
> >  {
> >       int idx =3D 0;
> > -     struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> >       struct perf_event *event;
> >       unsigned long flag =3D SBI_PMU_START_FLAG_SET_INIT_VALUE;
> >       unsigned long ctr_start_mask =3D 0;
> > @@ -677,6 +785,49 @@ static inline void pmu_sbi_start_overflow_mask(str=
uct riscv_pmu *pmu,
> >       }
> >  }
> >
> > +static noinline void pmu_sbi_start_ovf_ctrs_snapshot(struct cpu_hw_eve=
nts *cpu_hw_evt,
> > +                                                unsigned long ctr_ovf_=
mask)
> > +{
> > +     int idx =3D 0;
> > +     struct perf_event *event;
> > +     unsigned long flag =3D SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
> > +     uint64_t max_period;
> > +     struct hw_perf_event *hwc;
> > +     u64 init_val =3D 0;
> > +     unsigned long ctr_start_mask =3D 0;
> > +     struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
> > +
> > +     for_each_set_bit(idx, cpu_hw_evt->used_hw_ctrs, RISCV_MAX_COUNTER=
S) {
> > +             if (ctr_ovf_mask & (1 << idx)) {
> > +                     event =3D cpu_hw_evt->events[idx];
> > +                     hwc =3D &event->hw;
> > +                     max_period =3D riscv_pmu_ctr_get_width_mask(event=
);
> > +                     init_val =3D local64_read(&hwc->prev_count) & max=
_period;
> > +                     sdata->ctr_values[idx] =3D init_val;
> > +             }
> > +             /* We donot need to update the non-overflow counters the =
previous
>
>                 /*
>                  * We don't need to update the non-overflow counters as t=
he previous
>
>
> > +              * value should have been there already.
> > +              */
> > +     }
> > +
> > +     ctr_start_mask =3D cpu_hw_evt->used_hw_ctrs[0];
> > +
> > +     /* Start all the counters in a single shot */
> > +     sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_ma=
sk,
> > +               flag, 0, 0, 0);
> > +}
> > +
> > +static void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> > +                                     unsigned long ctr_ovf_mask)
> > +{
> > +     struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> > +
> > +     if (sbi_pmu_snapshot_available())
> > +             pmu_sbi_start_ovf_ctrs_snapshot(cpu_hw_evt, ctr_ovf_mask)=
;
> > +     else
> > +             pmu_sbi_start_ovf_ctrs_sbi(cpu_hw_evt, ctr_ovf_mask);
> > +}
> > +
> >  static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
> >  {
> >       struct perf_sample_data data;
> > @@ -690,6 +841,7 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, voi=
d *dev)
> >       unsigned long overflowed_ctrs =3D 0;
> >       struct cpu_hw_events *cpu_hw_evt =3D dev;
> >       u64 start_clock =3D sched_clock();
> > +     struct riscv_pmu_snapshot_data *sdata =3D cpu_hw_evt->snapshot_ad=
dr;
> >
> >       if (WARN_ON_ONCE(!cpu_hw_evt))
> >               return IRQ_NONE;
> > @@ -711,8 +863,10 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, vo=
id *dev)
> >       pmu_sbi_stop_hw_ctrs(pmu);
> >
> >       /* Overflow status register should only be read after counter are=
 stopped */
> > -     ALT_SBI_PMU_OVERFLOW(overflow);
> > -
> > +     if (sbi_pmu_snapshot_available())
> > +             overflow =3D sdata->ctr_overflow_mask;
> > +     else
> > +             ALT_SBI_PMU_OVERFLOW(overflow);
> >       /*
> >        * Overflow interrupt pending bit should only be cleared after st=
opping
> >        * all the counters to avoid any race condition.
> > @@ -774,6 +928,7 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, s=
truct hlist_node *node)
> >  {
> >       struct riscv_pmu *pmu =3D hlist_entry_safe(node, struct riscv_pmu=
, node);
> >       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> > +     int ret =3D 0;
> >
> >       /*
> >        * We keep enabling userspace access to CYCLE, TIME and INSTRET v=
ia the
> > @@ -794,7 +949,10 @@ static int pmu_sbi_starting_cpu(unsigned int cpu, =
struct hlist_node *node)
> >               enable_percpu_irq(riscv_pmu_irq, IRQ_TYPE_NONE);
> >       }
> >
> > -     return 0;
> > +     if (sbi_pmu_snapshot_available())
> > +             ret =3D pmu_sbi_snapshot_setup(pmu, cpu);
> > +
> > +     return ret;
>
> I'd just write this as
>
>         if (sbi_pmu_snapshot_available())
>                 return pmu_sbi_snapshot_setup(pmu, cpu);
>
>         return 0;
>
> and drop the newly added variable I think.
>

Sure. Just a preference thingy.

> >  }
> >
> >  static int pmu_sbi_dying_cpu(unsigned int cpu, struct hlist_node *node=
)
> > @@ -807,6 +965,9 @@ static int pmu_sbi_dying_cpu(unsigned int cpu, stru=
ct hlist_node *node)
> >       /* Disable all counters access for user mode now */
> >       csr_write(CSR_SCOUNTEREN, 0x0);
> >
> > +     if (sbi_pmu_snapshot_available())
> > +             pmu_sbi_snapshot_disable();
> > +
> >       return 0;
> >  }
> >
> > @@ -1076,10 +1237,6 @@ static int pmu_sbi_device_probe(struct platform_=
device *pdev)
> >       pmu->event_unmapped =3D pmu_sbi_event_unmapped;
> >       pmu->csr_index =3D pmu_sbi_csr_index;
> >
> > -     ret =3D cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &p=
mu->node);
> > -     if (ret)
> > -             return ret;
> > -
> >       ret =3D riscv_pm_pmu_register(pmu);
> >       if (ret)
> >               goto out_unregister;
> > @@ -1088,8 +1245,28 @@ static int pmu_sbi_device_probe(struct platform_=
device *pdev)
> >       if (ret)
> >               goto out_unregister;
> >
> > +     /* SBI PMU Snasphot is only available in SBI v2.0 */
>
> s/Snasphot/Snapshot/
>

Thanks. Fixed.

> > +     if (sbi_v2_available) {
> > +             ret =3D pmu_sbi_snapshot_alloc(pmu);
> > +             if (ret)
> > +                     goto out_unregister;
>
> A blank line here aids readability by breaking up the reuse of ret.

done.

>
> > +             ret =3D pmu_sbi_snapshot_setup(pmu, smp_processor_id());
> > +             if (!ret) {
> > +                     pr_info("SBI PMU snapshot is available to optimiz=
e the PMU traps\n");
>
> Why the verbose message? Could we standardise on one wording for the SBI
> function probing stuff? Most users seem to be "SBI FOO extension detected=
".
> Only IPI has additional wording and PMU differs slightly.

Additional information is for users to understand PMU functionality
uses less traps on this system.
We can just resort to and expect users to read upon the purpose of the
snapshot from the spec.
"SBI PMU snapshot available"

>
> > +                     /* We enable it once here for the boot cpu. If sn=
apshot shmem fails during
>
> Again, comment style here. What does "snapshot shmem" mean? I think
> there's a missing action here. Registration? Allocation?
>

Fixed it. It is supposed to be "snapshot shmem setup"

> > +                      * cpu hotplug on, it should bail out.
>
> Should or will? What action does "bail out" correspond to?
>

bail out the cpu hotplug process. We don't support heterogeneous pmus
for snapshot.
If the SBI implementation returns success for SBI_EXT_PMU_SNAPSHOT_SET_SHME=
M
boot cpu but fails for other cpus while bringing them up, it is
problematic to handle that.

> Thanks,
> Conor.
>
> > +                      */
> > +                     static_branch_enable(&sbi_pmu_snapshot_available)=
;
> > +             }
> > +             /* Snapshot is an optional feature. Continue if not avail=
able */
> > +     }
> > +
> >       register_sysctl("kernel", sbi_pmu_sysctl_table);
> >
> > +     ret =3D cpuhp_state_add_instance(CPUHP_AP_PERF_RISCV_STARTING, &p=
mu->node);
> > +     if (ret)
> > +             return ret;
> > +
> >       return 0;
> >
> >  out_unregister:
> > diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_=
pmu.h
> > index 43282e22ebe1..c3fa90970042 100644
> > --- a/include/linux/perf/riscv_pmu.h
> > +++ b/include/linux/perf/riscv_pmu.h
> > @@ -39,6 +39,12 @@ struct cpu_hw_events {
> >       DECLARE_BITMAP(used_hw_ctrs, RISCV_MAX_COUNTERS);
> >       /* currently enabled firmware counters */
> >       DECLARE_BITMAP(used_fw_ctrs, RISCV_MAX_COUNTERS);
> > +     /* The virtual address of the shared memory where counter snapsho=
t will be taken */
> > +     void *snapshot_addr;
> > +     /* The physical address of the shared memory where counter snapsh=
ot will be taken */
> > +     phys_addr_t snapshot_addr_phys;
> > +     /* Boolean flag to indicate setup is already done */
> > +     bool snapshot_set_done;
> >  };
> >
> >  struct riscv_pmu {
> > --
> > 2.34.1
> >

