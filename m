Return-Path: <kvm+bounces-7334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9781840520
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 13:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 437FF1F221C8
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91422612F4;
	Mon, 29 Jan 2024 12:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruHWALRW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB29260EED;
	Mon, 29 Jan 2024 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706531947; cv=none; b=dHvTJzsBhTb38PJt01GnejpxHYYtazSGBO0utyrJYtnwBOQtvcAztc+MGaooIQi8/9cZF3otnBVaypcg9S6N/QDmiqz2WzPzLm2GR4Wj7CEXuSGAhlX0qD0TAk8Oq06IdMlNFB8OPt5+mvxQpB8vKK4AIKqD54+jOZT5sjCsIDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706531947; c=relaxed/simple;
	bh=/XzKBfVseUd8Pb5Zd9tKnmSCcUIJlYaGFrxY8DxUInI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HaAfu5hx5aDcQZnpw9fh8c1QFKLgwTZQRv2vxVEuJoxs4NwrnSZuArufX4nCkvG6PT/IBO52k0/9RJRSGhS+nrZuBqmUMdCv20hv6wqaTNS7rThsiIBdDQozYn/IEwEE2snUVFjlikthzR68ZR+bRudV9hApsOJP0cP6FSQgozI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruHWALRW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0AEC43394;
	Mon, 29 Jan 2024 12:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706531947;
	bh=/XzKBfVseUd8Pb5Zd9tKnmSCcUIJlYaGFrxY8DxUInI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ruHWALRWiSMDmod3M6h3B9hWnhxOffcA/PmTofm1pXrvNZUswsPwqiBKTJBskt/IU
	 CyK1cLaP1jXkNaiXGgLtU5r68coBMY/8INbN70/THuEo8uSNQ5/PZV5lcOIKJpg2AK
	 TS58r8iveRm9tftkBlsTZne1zbE4gKJfPNK6qDOAfjyF5RcKZaRNea1G8ZTlJb39va
	 rAlSaOM2wuv2F3WvDLxnrvd6HAw6CQdXDUDYAQlNjtJBsnRS3iLKkTD6s47Ptm5Nvd
	 j0NhjFEI8O/1ekwKXbRRELpM5hYZlsSq9LAWg8PXn8P18FpPN0R+x0J/j+/fOzsv0s
	 5v/SxHregcLsQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-55eb1f9d1f0so3302275a12.0;
        Mon, 29 Jan 2024 04:39:07 -0800 (PST)
X-Gm-Message-State: AOJu0YzCrDIOdaWFGnjxBQ5UyEmcGRsJ0t+jb++N2CBeH8OZQG/Xuggu
	TUzuQvcIhNBWT11/nvgwc1EwZCLjqWPuGLtKoyBEiaUgUq/4KGRNJE9wgioNuEaGEIvBvy8lJ5B
	/rLNM1EwWrdzVMs09AE2KEy6EXMU=
X-Google-Smtp-Source: AGHT+IH2+Hqul+rGlR6WvXavfhDDwsl05gG/JWObkXjRKt7+OP5ABhiNwhLljGERzXzK/HVB1ZU2lG2h1QPc6LiSuOI=
X-Received: by 2002:a05:6402:3418:b0:55f:20f0:546b with SMTP id
 k24-20020a056402341800b0055f20f0546bmr507069edc.1.1706531945606; Mon, 29 Jan
 2024 04:39:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122100313.1589372-1-maobibo@loongson.cn> <20240122100313.1589372-2-maobibo@loongson.cn>
In-Reply-To: <20240122100313.1589372-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 29 Jan 2024 20:38:56 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6JnfdD1D0rMgDAk7gBWeYZn3ngFsE07_76Sk0Rv7Tksg@mail.gmail.com>
Message-ID: <CAAhV-H6JnfdD1D0rMgDAk7gBWeYZn3ngFsE07_76Sk0Rv7Tksg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] LoongArch/smp: Refine ipi ops on LoongArch platform
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Mon, Jan 22, 2024 at 6:03=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> This patch refines ipi handling on LoongArch platform, there are
> three changes with this patch.
> 1. Add generic get_percpu_irq api, replace some percpu irq function
> such as get_ipi_irq/get_pmc_irq/get_timer_irq with get_percpu_irq.
>
> 2. Change parameter action definition with function
> loongson_send_ipi_single and loongson_send_ipi_mask. Code encoding is use=
d
> here rather than bitmap encoding for ipi action, ipi hw sender uses actio=
n
> code, and ipi receiver will get action bitmap encoding, the ipi hw will
> convert it into bitmap in ipi message buffer.
>
> 3. Add smp_ops on LoongArch platform so that pv ipi can be used later.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/hardirq.h |  4 ++
>  arch/loongarch/include/asm/irq.h     | 10 ++++-
>  arch/loongarch/include/asm/smp.h     | 31 +++++++--------
>  arch/loongarch/kernel/irq.c          | 22 +----------
>  arch/loongarch/kernel/perf_event.c   | 14 +------
>  arch/loongarch/kernel/smp.c          | 58 +++++++++++++++++++---------
>  arch/loongarch/kernel/time.c         | 12 +-----
>  7 files changed, 71 insertions(+), 80 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/includ=
e/asm/hardirq.h
> index 0ef3b18f8980..9f0038e19c7f 100644
> --- a/arch/loongarch/include/asm/hardirq.h
> +++ b/arch/loongarch/include/asm/hardirq.h
> @@ -12,6 +12,10 @@
>  extern void ack_bad_irq(unsigned int irq);
>  #define ack_bad_irq ack_bad_irq
>
> +enum ipi_msg_type {
> +       IPI_RESCHEDULE,
> +       IPI_CALL_FUNCTION,
> +};
>  #define NR_IPI 2
>
>  typedef struct {
> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/as=
m/irq.h
> index 218b4da0ea90..00101b6d601e 100644
> --- a/arch/loongarch/include/asm/irq.h
> +++ b/arch/loongarch/include/asm/irq.h
> @@ -117,8 +117,16 @@ extern struct fwnode_handle *liointc_handle;
>  extern struct fwnode_handle *pch_lpc_handle;
>  extern struct fwnode_handle *pch_pic_handle[MAX_IO_PICS];
>
> -extern irqreturn_t loongson_ipi_interrupt(int irq, void *dev);
> +static inline int get_percpu_irq(int vector)
> +{
> +       struct irq_domain *d;
> +
> +       d =3D irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
> +       if (d)
> +               return irq_create_mapping(d, vector);
>
> +       return -EINVAL;
> +}
>  #include <asm-generic/irq.h>
>
>  #endif /* _ASM_IRQ_H */
> diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include/as=
m/smp.h
> index f81e5f01d619..330f1cb3741c 100644
> --- a/arch/loongarch/include/asm/smp.h
> +++ b/arch/loongarch/include/asm/smp.h
> @@ -12,6 +12,13 @@
>  #include <linux/threads.h>
>  #include <linux/cpumask.h>
>
> +struct smp_ops {
> +       void (*call_func_ipi)(const struct cpumask *mask, unsigned int ac=
tion);
> +       void (*call_func_single_ipi)(int cpu, unsigned int action);
To keep consistency, it is better to use call_func_ipi_single and
call_func_ipi_mask.

> +       void (*ipi_init)(void);
> +};
> +
> +extern struct smp_ops smp_ops;
>  extern int smp_num_siblings;
>  extern int num_processors;
>  extern int disabled_cpus;
> @@ -24,8 +31,6 @@ void loongson_prepare_cpus(unsigned int max_cpus);
>  void loongson_boot_secondary(int cpu, struct task_struct *idle);
>  void loongson_init_secondary(void);
>  void loongson_smp_finish(void);
> -void loongson_send_ipi_single(int cpu, unsigned int action);
> -void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int act=
ion);
>  #ifdef CONFIG_HOTPLUG_CPU
>  int loongson_cpu_disable(void);
>  void loongson_cpu_die(unsigned int cpu);
> @@ -59,9 +64,12 @@ extern int __cpu_logical_map[NR_CPUS];
>
>  #define cpu_physical_id(cpu)   cpu_logical_map(cpu)
>
> -#define SMP_BOOT_CPU           0x1
> -#define SMP_RESCHEDULE         0x2
> -#define SMP_CALL_FUNCTION      0x4
> +#define ACTTION_BOOT_CPU       0
> +#define ACTTION_RESCHEDULE     1
> +#define ACTTION_CALL_FUNCTION  2
> +#define SMP_BOOT_CPU           BIT(ACTTION_BOOT_CPU)
> +#define SMP_RESCHEDULE         BIT(ACTTION_RESCHEDULE)
> +#define SMP_CALL_FUNCTION      BIT(ACTTION_CALL_FUNCTION)
>
>  struct secondary_data {
>         unsigned long stack;
> @@ -71,7 +79,8 @@ extern struct secondary_data cpuboot_data;
>
>  extern asmlinkage void smpboot_entry(void);
>  extern asmlinkage void start_secondary(void);
> -
> +extern void arch_send_call_function_single_ipi(int cpu);
> +extern void arch_send_call_function_ipi_mask(const struct cpumask *mask)=
;
Similarly, to keep consistency, it is better to use
arch_send_function_ipi_single and arch_send_function_ipi_mask.

Huacai

>  extern void calculate_cpu_foreign_map(void);
>
>  /*
> @@ -79,16 +88,6 @@ extern void calculate_cpu_foreign_map(void);
>   */
>  extern void show_ipi_list(struct seq_file *p, int prec);
>
> -static inline void arch_send_call_function_single_ipi(int cpu)
> -{
> -       loongson_send_ipi_single(cpu, SMP_CALL_FUNCTION);
> -}
> -
> -static inline void arch_send_call_function_ipi_mask(const struct cpumask=
 *mask)
> -{
> -       loongson_send_ipi_mask(mask, SMP_CALL_FUNCTION);
> -}
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  static inline int __cpu_disable(void)
>  {
> diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
> index 883e5066ae44..1b58f7c3eed9 100644
> --- a/arch/loongarch/kernel/irq.c
> +++ b/arch/loongarch/kernel/irq.c
> @@ -87,23 +87,9 @@ static void __init init_vec_parent_group(void)
>         acpi_table_parse(ACPI_SIG_MCFG, early_pci_mcfg_parse);
>  }
>
> -static int __init get_ipi_irq(void)
> -{
> -       struct irq_domain *d =3D irq_find_matching_fwnode(cpuintc_handle,=
 DOMAIN_BUS_ANY);
> -
> -       if (d)
> -               return irq_create_mapping(d, INT_IPI);
> -
> -       return -EINVAL;
> -}
> -
>  void __init init_IRQ(void)
>  {
>         int i;
> -#ifdef CONFIG_SMP
> -       int r, ipi_irq;
> -       static int ipi_dummy_dev;
> -#endif
>         unsigned int order =3D get_order(IRQ_STACK_SIZE);
>         struct page *page;
>
> @@ -113,13 +99,7 @@ void __init init_IRQ(void)
>         init_vec_parent_group();
>         irqchip_init();
>  #ifdef CONFIG_SMP
> -       ipi_irq =3D get_ipi_irq();
> -       if (ipi_irq < 0)
> -               panic("IPI IRQ mapping failed\n");
> -       irq_set_percpu_devid(ipi_irq);
> -       r =3D request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", =
&ipi_dummy_dev);
> -       if (r < 0)
> -               panic("IPI IRQ request failed\n");
> +       smp_ops.ipi_init();
>  #endif
>
>         for (i =3D 0; i < NR_IRQS; i++)
> diff --git a/arch/loongarch/kernel/perf_event.c b/arch/loongarch/kernel/p=
erf_event.c
> index 0491bf453cd4..3265c8f33223 100644
> --- a/arch/loongarch/kernel/perf_event.c
> +++ b/arch/loongarch/kernel/perf_event.c
> @@ -456,16 +456,6 @@ static void loongarch_pmu_disable(struct pmu *pmu)
>  static DEFINE_MUTEX(pmu_reserve_mutex);
>  static atomic_t active_events =3D ATOMIC_INIT(0);
>
> -static int get_pmc_irq(void)
> -{
> -       struct irq_domain *d =3D irq_find_matching_fwnode(cpuintc_handle,=
 DOMAIN_BUS_ANY);
> -
> -       if (d)
> -               return irq_create_mapping(d, INT_PCOV);
> -
> -       return -EINVAL;
> -}
> -
>  static void reset_counters(void *arg);
>  static int __hw_perf_event_init(struct perf_event *event);
>
> @@ -473,7 +463,7 @@ static void hw_perf_event_destroy(struct perf_event *=
event)
>  {
>         if (atomic_dec_and_mutex_lock(&active_events, &pmu_reserve_mutex)=
) {
>                 on_each_cpu(reset_counters, NULL, 1);
> -               free_irq(get_pmc_irq(), &loongarch_pmu);
> +               free_irq(get_percpu_irq(INT_PCOV), &loongarch_pmu);
>                 mutex_unlock(&pmu_reserve_mutex);
>         }
>  }
> @@ -562,7 +552,7 @@ static int loongarch_pmu_event_init(struct perf_event=
 *event)
>         if (event->cpu >=3D 0 && !cpu_online(event->cpu))
>                 return -ENODEV;
>
> -       irq =3D get_pmc_irq();
> +       irq =3D get_percpu_irq(INT_PCOV);
>         flags =3D IRQF_PERCPU | IRQF_NOBALANCING | IRQF_NO_THREAD | IRQF_=
NO_SUSPEND | IRQF_SHARED;
>         if (!atomic_inc_not_zero(&active_events)) {
>                 mutex_lock(&pmu_reserve_mutex);
> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> index a16e3dbe9f09..46735ba49815 100644
> --- a/arch/loongarch/kernel/smp.c
> +++ b/arch/loongarch/kernel/smp.c
> @@ -66,11 +66,6 @@ static cpumask_t cpu_core_setup_map;
>  struct secondary_data cpuboot_data;
>  static DEFINE_PER_CPU(int, cpu_state);
>
> -enum ipi_msg_type {
> -       IPI_RESCHEDULE,
> -       IPI_CALL_FUNCTION,
> -};
> -
>  static const char *ipi_types[NR_IPI] __tracepoint_string =3D {
>         [IPI_RESCHEDULE] =3D "Rescheduling interrupts",
>         [IPI_CALL_FUNCTION] =3D "Function call interrupts",
> @@ -123,24 +118,19 @@ static u32 ipi_read_clear(int cpu)
>
>  static void ipi_write_action(int cpu, u32 action)
>  {
> -       unsigned int irq =3D 0;
> -
> -       while ((irq =3D ffs(action))) {
> -               uint32_t val =3D IOCSR_IPI_SEND_BLOCKING;
> +       uint32_t val;
>
> -               val |=3D (irq - 1);
> -               val |=3D (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
> -               iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
> -               action &=3D ~BIT(irq - 1);
> -       }
> +       val =3D IOCSR_IPI_SEND_BLOCKING | action;
> +       val |=3D (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
> +       iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
>  }
>
> -void loongson_send_ipi_single(int cpu, unsigned int action)
> +static void loongson_send_ipi_single(int cpu, unsigned int action)
>  {
>         ipi_write_action(cpu_logical_map(cpu), (u32)action);
>  }
>
> -void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int act=
ion)
> +static void loongson_send_ipi_mask(const struct cpumask *mask, unsigned =
int action)
>  {
>         unsigned int i;
>
> @@ -148,6 +138,16 @@ void loongson_send_ipi_mask(const struct cpumask *ma=
sk, unsigned int action)
>                 ipi_write_action(cpu_logical_map(i), (u32)action);
>  }
>
> +void arch_send_call_function_single_ipi(int cpu)
> +{
> +       smp_ops.call_func_single_ipi(cpu, ACTTION_CALL_FUNCTION);
> +}
> +
> +void arch_send_call_function_ipi_mask(const struct cpumask *mask)
> +{
> +       smp_ops.call_func_ipi(mask, ACTTION_CALL_FUNCTION);
> +}
> +
>  /*
>   * This function sends a 'reschedule' IPI to another CPU.
>   * it goes straight through and wastes no time serializing
> @@ -155,11 +155,11 @@ void loongson_send_ipi_mask(const struct cpumask *m=
ask, unsigned int action)
>   */
>  void arch_smp_send_reschedule(int cpu)
>  {
> -       loongson_send_ipi_single(cpu, SMP_RESCHEDULE);
> +       smp_ops.call_func_single_ipi(cpu, ACTTION_RESCHEDULE);
>  }
>  EXPORT_SYMBOL_GPL(arch_smp_send_reschedule);
>
> -irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
> +static irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
>  {
>         unsigned int action;
>         unsigned int cpu =3D smp_processor_id();
> @@ -179,6 +179,26 @@ irqreturn_t loongson_ipi_interrupt(int irq, void *de=
v)
>         return IRQ_HANDLED;
>  }
>
> +static void loongson_ipi_init(void)
> +{
> +       int r, ipi_irq;
> +
> +       ipi_irq =3D get_percpu_irq(INT_IPI);
> +       if (ipi_irq < 0)
> +               panic("IPI IRQ mapping failed\n");
> +
> +       irq_set_percpu_devid(ipi_irq);
> +       r =3D request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", =
&irq_stat);
> +       if (r < 0)
> +               panic("IPI IRQ request failed\n");
> +}
> +
> +struct smp_ops smp_ops =3D {
> +       .call_func_single_ipi   =3D loongson_send_ipi_single,
> +       .call_func_ipi          =3D loongson_send_ipi_mask,
> +       .ipi_init               =3D loongson_ipi_init,
> +};
> +
>  static void __init fdt_smp_setup(void)
>  {
>  #ifdef CONFIG_OF
> @@ -256,7 +276,7 @@ void loongson_boot_secondary(int cpu, struct task_str=
uct *idle)
>
>         csr_mail_send(entry, cpu_logical_map(cpu), 0);
>
> -       loongson_send_ipi_single(cpu, SMP_BOOT_CPU);
> +       loongson_send_ipi_single(cpu, ACTTION_BOOT_CPU);
>  }
>
>  /*
> diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
> index e7015f7b70e3..fd5354f9be7c 100644
> --- a/arch/loongarch/kernel/time.c
> +++ b/arch/loongarch/kernel/time.c
> @@ -123,16 +123,6 @@ void sync_counter(void)
>         csr_write64(init_offset, LOONGARCH_CSR_CNTC);
>  }
>
> -static int get_timer_irq(void)
> -{
> -       struct irq_domain *d =3D irq_find_matching_fwnode(cpuintc_handle,=
 DOMAIN_BUS_ANY);
> -
> -       if (d)
> -               return irq_create_mapping(d, INT_TI);
> -
> -       return -EINVAL;
> -}
> -
>  int constant_clockevent_init(void)
>  {
>         unsigned int cpu =3D smp_processor_id();
> @@ -142,7 +132,7 @@ int constant_clockevent_init(void)
>         static int irq =3D 0, timer_irq_installed =3D 0;
>
>         if (!timer_irq_installed) {
> -               irq =3D get_timer_irq();
> +               irq =3D get_percpu_irq(INT_TI);
>                 if (irq < 0)
>                         pr_err("Failed to map irq %d (timer)\n", irq);
>         }
> --
> 2.39.3
>

