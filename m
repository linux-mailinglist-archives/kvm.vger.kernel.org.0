Return-Path: <kvm+bounces-26917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2223978F4A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 10:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C63C7B2461D
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 08:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E2D19E7FC;
	Sat, 14 Sep 2024 08:56:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90A310E9;
	Sat, 14 Sep 2024 08:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726304210; cv=none; b=pH8V8Vd3ykJLXA5aEZa3KweJQH8JOXJ6EYjn1KXMVZ2D7j85w/Z7KmPgvgUjHDgWon83J4/7ws2UVuTm6+BHo0sytFGvuCOvjL/VPdkPzTaK/aBufsvf9Q4att3Tqteqh1RUEe2Rd8u7aZSI1I0EbjvOfdIkg02VAaYZQ515JqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726304210; c=relaxed/simple;
	bh=g3Fk1Psf82pq5xnjzHbT39MQdtOMJLff6D6Cc6nuZDc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OKpUz/RdrPOttIuU7CCB/cVJA54vekogzZNkxkURTxqaKE32vBB1ksIa5a3+GVC8+ClA9ec0jEykxu19K4XI0KhG38bZLr0epJOLCuwcreIgH1cODNBpsp2pbjXWjGFyVXtkWhYJ3Y3UVMwH2j9TsVr3oybfXinG97p9pBOgdfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bx++nKT+Vms9oHAA--.18060S3;
	Sat, 14 Sep 2024 16:56:42 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxrtfJT+VmMbUGAA--.37972S3;
	Sat, 14 Sep 2024 16:56:41 +0800 (CST)
Subject: Re: [PATCH v3 3/4] LoongArch: Extract IOCSR definitions to standalone
 header
To: Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Thomas Gleixner
 <tglx@linutronix.de>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-mips@vger.kernel.org, kvm@vger.kernel.org
References: <20240913-iocsr-v3-0-81a57f60350d@flygoat.com>
 <20240913-iocsr-v3-3-81a57f60350d@flygoat.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <147e72c9-8177-9c03-8baf-df7362143cd6@loongson.cn>
Date: Sat, 14 Sep 2024 16:56:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240913-iocsr-v3-3-81a57f60350d@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxrtfJT+VmMbUGAA--.37972S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoWfXw4UZFy5ZFyUuFWkCFykZwc_yoW8ZF1kCo
	W0qayftr48Aw47Zw1Yq3yqvFWUJrykArs8AanxAa97JrW7JF1DKFW5ta42vry3tayYvrZr
	Ca9FgFWkJa9avas8l-sFpf9Il3svdjkaLaAFLSUrUUUU0b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUOn7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8uc_3
	UUUUU==

Hi jiaxun,

On 2024/9/14 上午4:32, Jiaxun Yang wrote:
> As IOCSR is not a part of architecture specification, it is not
> really appropriate to define those stuff in loongarch.h.
IOCSR address is somewhat strange compared with generic mmio bus,
neither fdt nor acpi does not support IOCSR address space. I do not know 
the future about IOCSR, since I do not know the advantage of it compared 
to MMIO address space, except it can only  be accessed in supervisor mode.

Sharing the same code with multiple architecture is welcome.
> 
> Extract those definitions to include/linux/loongson/iocsr.h, so
> that they can be shared with MIPS based Loongson systems as well.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>   MAINTAINERS                             |   1 +
>   arch/loongarch/include/asm/loongarch.h  |  90 --------------------------
>   arch/loongarch/kernel/cpu-probe.c       |   7 +-
>   arch/loongarch/kernel/relocate_kernel.S |   5 +-
>   arch/loongarch/kernel/smp.c             |  23 +++----
>   drivers/cpufreq/loongson3_cpufreq.c     |  11 ++--
>   drivers/irqchip/irq-loongarch-avec.c    |   5 +-
>   drivers/irqchip/irq-loongson-eiointc.c  |   5 +-
>   include/linux/loongson/iocsr.h          | 110 ++++++++++++++++++++++++++++++++
>   9 files changed, 142 insertions(+), 115 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0a3d9e17295a..f0f4c427e9a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13305,6 +13305,7 @@ F:	Documentation/translations/zh_CN/arch/loongarch/
>   F:	arch/loongarch/
>   F:	drivers/*/*loongarch*
>   F:	drivers/cpufreq/loongson3_cpufreq.c
> +F:	include/linux/loongson
>   
>   LOONGSON GPIO DRIVER
>   M:	Yinbo Zhu <zhuyinbo@loongson.cn>
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
> index 23af28f00c3c..4ac228230720 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -1048,84 +1048,6 @@
>   
>   #define ESTATF_IP		0x00003fff
>   
> -#define LOONGARCH_IOCSR_FEATURES	0x8
> -#define  IOCSRF_TEMP			BIT_ULL(0)
> -#define  IOCSRF_NODECNT			BIT_ULL(1)
> -#define  IOCSRF_MSI			BIT_ULL(2)
> -#define  IOCSRF_EXTIOI			BIT_ULL(3)
> -#define  IOCSRF_CSRIPI			BIT_ULL(4)
> -#define  IOCSRF_FREQCSR			BIT_ULL(5)
> -#define  IOCSRF_FREQSCALE		BIT_ULL(6)
> -#define  IOCSRF_DVFSV1			BIT_ULL(7)
> -#define  IOCSRF_EIODECODE		BIT_ULL(9)
> -#define  IOCSRF_FLATMODE		BIT_ULL(10)
> -#define  IOCSRF_VM			BIT_ULL(11)
> -#define  IOCSRF_AVEC			BIT_ULL(15)
> -
> -#define LOONGARCH_IOCSR_VENDOR		0x10
> -
> -#define LOONGARCH_IOCSR_CPUNAME		0x20
> -
> -#define LOONGARCH_IOCSR_NODECNT		0x408
> -
> -#define LOONGARCH_IOCSR_MISC_FUNC	0x420
> -#define  IOCSR_MISC_FUNC_SOFT_INT	BIT_ULL(10)
> -#define  IOCSR_MISC_FUNC_TIMER_RESET	BIT_ULL(21)
> -#define  IOCSR_MISC_FUNC_EXT_IOI_EN	BIT_ULL(48)
> -#define  IOCSR_MISC_FUNC_AVEC_EN	BIT_ULL(51)
> -
> -#define LOONGARCH_IOCSR_CPUTEMP		0x428
> -
> -#define LOONGARCH_IOCSR_SMCMBX		0x51c
> -
> -/* PerCore CSR, only accessible by local cores */
> -#define LOONGARCH_IOCSR_IPI_STATUS	0x1000
> -#define LOONGARCH_IOCSR_IPI_EN		0x1004
> -#define LOONGARCH_IOCSR_IPI_SET		0x1008
> -#define LOONGARCH_IOCSR_IPI_CLEAR	0x100c
> -#define LOONGARCH_IOCSR_MBUF0		0x1020
> -#define LOONGARCH_IOCSR_MBUF1		0x1028
> -#define LOONGARCH_IOCSR_MBUF2		0x1030
> -#define LOONGARCH_IOCSR_MBUF3		0x1038
> -
> -#define LOONGARCH_IOCSR_IPI_SEND	0x1040
> -#define  IOCSR_IPI_SEND_IP_SHIFT	0
> -#define  IOCSR_IPI_SEND_CPU_SHIFT	16
> -#define  IOCSR_IPI_SEND_BLOCKING	BIT(31)
> -
> -#define LOONGARCH_IOCSR_MBUF_SEND	0x1048
> -#define  IOCSR_MBUF_SEND_BLOCKING	BIT_ULL(31)
> -#define  IOCSR_MBUF_SEND_BOX_SHIFT	2
> -#define  IOCSR_MBUF_SEND_BOX_LO(box)	(box << 1)
> -#define  IOCSR_MBUF_SEND_BOX_HI(box)	((box << 1) + 1)
> -#define  IOCSR_MBUF_SEND_CPU_SHIFT	16
> -#define  IOCSR_MBUF_SEND_BUF_SHIFT	32
> -#define  IOCSR_MBUF_SEND_H32_MASK	0xFFFFFFFF00000000ULL
> -
> -#define LOONGARCH_IOCSR_ANY_SEND	0x1158
> -#define  IOCSR_ANY_SEND_BLOCKING	BIT_ULL(31)
> -#define  IOCSR_ANY_SEND_CPU_SHIFT	16
> -#define  IOCSR_ANY_SEND_MASK_SHIFT	27
> -#define  IOCSR_ANY_SEND_BUF_SHIFT	32
> -#define  IOCSR_ANY_SEND_H32_MASK	0xFFFFFFFF00000000ULL
> -
> -/* Register offset and bit definition for CSR access */
> -#define LOONGARCH_IOCSR_TIMER_CFG       0x1060
> -#define LOONGARCH_IOCSR_TIMER_TICK      0x1070
> -#define  IOCSR_TIMER_CFG_RESERVED       (_ULCAST_(1) << 63)
> -#define  IOCSR_TIMER_CFG_PERIODIC       (_ULCAST_(1) << 62)
> -#define  IOCSR_TIMER_CFG_EN             (_ULCAST_(1) << 61)
> -#define  IOCSR_TIMER_MASK		0x0ffffffffffffULL
> -#define  IOCSR_TIMER_INITVAL_RST        (_ULCAST_(0xffff) << 48)
> -
> -#define LOONGARCH_IOCSR_EXTIOI_NODEMAP_BASE	0x14a0
> -#define LOONGARCH_IOCSR_EXTIOI_IPMAP_BASE	0x14c0
> -#define LOONGARCH_IOCSR_EXTIOI_EN_BASE		0x1600
> -#define LOONGARCH_IOCSR_EXTIOI_BOUNCE_BASE	0x1680
> -#define LOONGARCH_IOCSR_EXTIOI_ISR_BASE		0x1800
> -#define LOONGARCH_IOCSR_EXTIOI_ROUTE_BASE	0x1c00
> -#define IOCSR_EXTIOI_VECTOR_NUM			256
> -
>   #ifndef __ASSEMBLY__
>   
>   static __always_inline u64 drdtime(void)
> @@ -1145,18 +1067,6 @@ static inline unsigned int get_csr_cpuid(void)
>   	return csr_read32(LOONGARCH_CSR_CPUID);
>   }
>   
> -static inline void csr_any_send(unsigned int addr, unsigned int data,
> -				unsigned int data_mask, unsigned int cpu)
> -{
> -	uint64_t val = 0;
> -
> -	val = IOCSR_ANY_SEND_BLOCKING | addr;
> -	val |= (cpu << IOCSR_ANY_SEND_CPU_SHIFT);
> -	val |= (data_mask << IOCSR_ANY_SEND_MASK_SHIFT);
> -	val |= ((uint64_t)data << IOCSR_ANY_SEND_BUF_SHIFT);
> -	iocsr_write64(val, LOONGARCH_IOCSR_ANY_SEND);
> -}
> -
>   static inline unsigned int read_csr_excode(void)
>   {
>   	return (csr_read32(LOONGARCH_CSR_ESTAT) & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
> diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cpu-probe.c
> index 8a868a10df9c..07b68f93ccdc 100644
> --- a/arch/loongarch/kernel/cpu-probe.c
> +++ b/arch/loongarch/kernel/cpu-probe.c
> @@ -6,6 +6,7 @@
>    */
>   #include <linux/init.h>
>   #include <linux/kernel.h>
> +#include <linux/loongson/iocsr.h>
>   #include <linux/ptrace.h>
>   #include <linux/smp.h>
>   #include <linux/stddef.h>
> @@ -267,13 +268,13 @@ static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsigned int
>   	if (!(c->options & LOONGARCH_CPU_IOCSR))
>   		return;
>   
> -	*vendor = iocsr_read64(LOONGARCH_IOCSR_VENDOR);
> -	*cpuname = iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
> +	*vendor = iocsr_read64(LOONGSON_IOCSR_VENDOR);
> +	*cpuname = iocsr_read64(LOONGSON_IOCSR_CPUNAME);
>   
>   	if (!__cpu_full_name[cpu])
>   		__cpu_full_name[cpu] = cpu_full_name;
>   
> -	config = iocsr_read32(LOONGARCH_IOCSR_FEATURES);
> +	config = iocsr_read32(LOONGSON_IOCSR_FEATURES);
>   	if (config & IOCSRF_CSRIPI)
>   		c->options |= LOONGARCH_CPU_CSRIPI;
>   	if (config & IOCSRF_EXTIOI)
> diff --git a/arch/loongarch/kernel/relocate_kernel.S b/arch/loongarch/kernel/relocate_kernel.S
> index 84e6de2fd973..ce40ba6b5975 100644
> --- a/arch/loongarch/kernel/relocate_kernel.S
> +++ b/arch/loongarch/kernel/relocate_kernel.S
> @@ -5,6 +5,7 @@
>    * Copyright (C) 2022 Loongson Technology Corporation Limited
>    */
>   
> +#include <linux/loongson/iocsr.h>
>   #include <linux/kexec.h>
>   
>   #include <asm/asm.h>
> @@ -88,14 +89,14 @@ SYM_CODE_END(relocate_new_kernel)
>   #ifdef CONFIG_SMP
>   /*
>    * Other CPUs should wait until code is relocated and
> - * then start at the entry point from LOONGARCH_IOCSR_MBUF0.
> + * then start at the entry point from LOONGSON_IOCSR_MBUF0.
>    */
>   SYM_CODE_START(kexec_smp_wait)
>   	UNWIND_HINT_UNDEFINED
>   1:	li.w		t0, 0x100			/* wait for init loop */
>   2:	addi.w		t0, t0, -1			/* limit mailbox access */
>   	bnez		t0, 2b
> -	li.w		t1, LOONGARCH_IOCSR_MBUF0
> +	li.w		t1, LOONGSON_IOCSR_MBUF0
>   	iocsrrd.w	s0, t1				/* check PC as an indicator */
>   	beqz		s0, 1b
>   	iocsrrd.d	s0, t1				/* get PC via mailbox */
> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
> index 4adbbef3450a..120865985376 100644
> --- a/arch/loongarch/kernel/smp.c
> +++ b/arch/loongarch/kernel/smp.c
> @@ -14,6 +14,7 @@
>   #include <linux/init.h>
>   #include <linux/interrupt.h>
>   #include <linux/irq_work.h>
> +#include <linux/loongson/iocsr.h>
>   #include <linux/profile.h>
>   #include <linux/seq_file.h>
>   #include <linux/smp.h>
> @@ -164,14 +165,14 @@ static void csr_mail_send(uint64_t data, int cpu, int mailbox)
>   	val |= (IOCSR_MBUF_SEND_BOX_HI(mailbox) << IOCSR_MBUF_SEND_BOX_SHIFT);
>   	val |= (cpu << IOCSR_MBUF_SEND_CPU_SHIFT);
>   	val |= (data & IOCSR_MBUF_SEND_H32_MASK);
> -	iocsr_write64(val, LOONGARCH_IOCSR_MBUF_SEND);
> +	iocsr_write64(val, LOONGSON_IOCSR_MBUF_SEND);
>   
>   	/* Send low 32 bits */
>   	val = IOCSR_MBUF_SEND_BLOCKING;
>   	val |= (IOCSR_MBUF_SEND_BOX_LO(mailbox) << IOCSR_MBUF_SEND_BOX_SHIFT);
>   	val |= (cpu << IOCSR_MBUF_SEND_CPU_SHIFT);
>   	val |= (data << IOCSR_MBUF_SEND_BUF_SHIFT);
> -	iocsr_write64(val, LOONGARCH_IOCSR_MBUF_SEND);
> +	iocsr_write64(val, LOONGSON_IOCSR_MBUF_SEND);
>   };
>   
>   static u32 ipi_read_clear(int cpu)
> @@ -179,9 +180,9 @@ static u32 ipi_read_clear(int cpu)
>   	u32 action;
>   
>   	/* Load the ipi register to figure out what we're supposed to do */
> -	action = iocsr_read32(LOONGARCH_IOCSR_IPI_STATUS);
> +	action = iocsr_read32(LOONGSON_IOCSR_IPI_STATUS);
>   	/* Clear the ipi register to clear the interrupt */
> -	iocsr_write32(action, LOONGARCH_IOCSR_IPI_CLEAR);
> +	iocsr_write32(action, LOONGSON_IOCSR_IPI_CLEAR);
>   	wbflush();
>   
>   	return action;
> @@ -193,7 +194,7 @@ static void ipi_write_action(int cpu, u32 action)
>   
>   	val = IOCSR_IPI_SEND_BLOCKING | action;
>   	val |= (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
> -	iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
> +	iocsr_write32(val, LOONGSON_IOCSR_IPI_SEND);
>   }
>   
>   static void loongson_send_ipi_single(int cpu, unsigned int action)
> @@ -322,7 +323,7 @@ void __init loongson_smp_setup(void)
>   	cpu_data[0].package = cpu_logical_map(0) / loongson_sysconf.cores_per_package;
>   
>   	pv_ipi_init();
> -	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_EN);
> +	iocsr_write32(0xffffffff, LOONGSON_IOCSR_IPI_EN);
>   	pr_info("Detected %i available CPU(s)\n", loongson_sysconf.nr_cpus);
>   }
>   
> @@ -370,7 +371,7 @@ void loongson_init_secondary(void)
>   
>   	change_csr_ecfg(ECFG0_IM, imask);
>   
> -	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_EN);
> +	iocsr_write32(0xffffffff, LOONGSON_IOCSR_IPI_EN);
>   
>   #ifdef CONFIG_NUMA
>   	numa_add_cpu(cpu);
> @@ -385,7 +386,7 @@ void loongson_init_secondary(void)
>   void loongson_smp_finish(void)
>   {
>   	local_irq_enable();
> -	iocsr_write64(0, LOONGARCH_IOCSR_MBUF0);
> +	iocsr_write64(0, LOONGSON_IOCSR_MBUF0);
>   	pr_info("CPU#%d finished\n", smp_processor_id());
>   }
>   
> @@ -435,12 +436,12 @@ void __noreturn arch_cpu_idle_dead(void)
>   	__smp_mb();
>   	do {
>   		__asm__ __volatile__("idle 0\n\t");
> -		addr = iocsr_read64(LOONGARCH_IOCSR_MBUF0);
> +		addr = iocsr_read64(LOONGSON_IOCSR_MBUF0);
>   	} while (addr == 0);
>   
>   	local_irq_disable();
>   	init_fn = (void *)TO_CACHE(addr);
> -	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_CLEAR);
> +	iocsr_write32(0xffffffff, LOONGSON_IOCSR_IPI_CLEAR);
>   
>   	init_fn();
>   	BUG();
> @@ -460,7 +461,7 @@ static int loongson_ipi_suspend(void)
>   
>   static void loongson_ipi_resume(void)
>   {
> -	iocsr_write32(0xffffffff, LOONGARCH_IOCSR_IPI_EN);
> +	iocsr_write32(0xffffffff, LOONGSON_IOCSR_IPI_EN);
>   }
>   
>   static struct syscore_ops loongson_ipi_syscore_ops = {
> diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
> index 6b5e6798d9a2..11d5f1ba3040 100644
> --- a/drivers/cpufreq/loongson3_cpufreq.c
> +++ b/drivers/cpufreq/loongson3_cpufreq.c
> @@ -10,6 +10,7 @@
>   #include <linux/cpufreq.h>
>   #include <linux/delay.h>
>   #include <linux/module.h>
> +#include <linux/loongson/iocsr.h>
>   #include <linux/platform_device.h>
>   #include <linux/units.h>
>   
> @@ -182,7 +183,7 @@ static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 ext
>   
>   	mutex_lock(&cpufreq_mutex[package]);
>   
> -	last.value = iocsr_read32(LOONGARCH_IOCSR_SMCMBX);
> +	last.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
>   	if (!last.complete) {
>   		mutex_unlock(&cpufreq_mutex[package]);
>   		return -EPERM;
> @@ -195,12 +196,12 @@ static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 ext
>   	msg.extra	= extra;
>   	msg.complete	= 0;
>   
> -	iocsr_write32(msg.value, LOONGARCH_IOCSR_SMCMBX);
> -	iocsr_write32(iocsr_read32(LOONGARCH_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
> -		      LOONGARCH_IOCSR_MISC_FUNC);
> +	iocsr_write32(msg.value, LOONGSON_IOCSR_SMCMBX);
> +	iocsr_write32(iocsr_read32(LOONGSON_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
> +		      LOONGSON_IOCSR_MISC_FUNC);
>   
>   	for (retries = 0; retries < 10000; retries++) {
> -		msg.value = iocsr_read32(LOONGARCH_IOCSR_SMCMBX);
> +		msg.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
>   		if (msg.complete)
>   			break;
>   
> diff --git a/drivers/irqchip/irq-loongarch-avec.c b/drivers/irqchip/irq-loongarch-avec.c
> index 0f6e465dd309..2452c6cc0aa1 100644
> --- a/drivers/irqchip/irq-loongarch-avec.c
> +++ b/drivers/irqchip/irq-loongarch-avec.c
> @@ -10,6 +10,7 @@
>   #include <linux/irqchip.h>
>   #include <linux/irqchip/chained_irq.h>
>   #include <linux/irqdomain.h>
> +#include <linux/loongson/iocsr.h>
>   #include <linux/kernel.h>
>   #include <linux/msi.h>
>   #include <linux/radix-tree.h>
> @@ -378,9 +379,9 @@ static int __init avecintc_init(struct irq_domain *parent)
>   				  "irqchip/loongarch/avecintc:starting",
>   				  avecintc_cpu_online, avecintc_cpu_offline);
>   #endif
> -	value = iocsr_read64(LOONGARCH_IOCSR_MISC_FUNC);
> +	value = iocsr_read64(LOONGSON_IOCSR_MISC_FUNC);
>   	value |= IOCSR_MISC_FUNC_AVEC_EN;
> -	iocsr_write64(value, LOONGARCH_IOCSR_MISC_FUNC);
> +	iocsr_write64(value, LOONGSON_IOCSR_MISC_FUNC);
>   
>   	return ret;
>   
> diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
> index e24db71a8783..6e81bf27914f 100644
> --- a/drivers/irqchip/irq-loongson-eiointc.c
> +++ b/drivers/irqchip/irq-loongson-eiointc.c
> @@ -13,6 +13,7 @@
>   #include <linux/irqchip.h>
>   #include <linux/irqdomain.h>
>   #include <linux/irqchip/chained_irq.h>
> +#include <linux/loongson/iocsr.h>
>   #include <linux/kernel.h>
>   #include <linux/syscore_ops.h>
>   #include <asm/numa.h>
> @@ -52,9 +53,9 @@ static void eiointc_enable(void)
>   {
>   	uint64_t misc;
>   
> -	misc = iocsr_read64(LOONGARCH_IOCSR_MISC_FUNC);
> +	misc = iocsr_read64(LOONGSON_IOCSR_MISC_FUNC);
>   	misc |= IOCSR_MISC_FUNC_EXT_IOI_EN;
> -	iocsr_write64(misc, LOONGARCH_IOCSR_MISC_FUNC);
> +	iocsr_write64(misc, LOONGSON_IOCSR_MISC_FUNC);
>   }
>   
>   static int cpu_to_eio_node(int cpu)
> diff --git a/include/linux/loongson/iocsr.h b/include/linux/loongson/iocsr.h
> new file mode 100644
> index 000000000000..6654a904bcbe
> --- /dev/null
> +++ b/include/linux/loongson/iocsr.h
> @@ -0,0 +1,110 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
> + * Copyright (C) 2024, Jiaxun Yang <jiaxun.yang@flygoat.com>
> + */
> +
> +#ifndef _LOONGSON_IOCSR_H
> +#define _LOONGSON_IOCSR_H
> +
> +#include <linux/bits.h>
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_LOONGARCH
> +#include <asm/loongarch.h>
> +#endif
> +
> +#define LOONGSON_IOCSR_FEATURES	0x8
> +#define  IOCSRF_TEMP			BIT_ULL(0)
> +#define  IOCSRF_NODECNT			BIT_ULL(1)
> +#define  IOCSRF_MSI			BIT_ULL(2)
> +#define  IOCSRF_EXTIOI			BIT_ULL(3)
> +#define  IOCSRF_CSRIPI			BIT_ULL(4)
> +#define  IOCSRF_FREQCSR			BIT_ULL(5)
> +#define  IOCSRF_FREQSCALE		BIT_ULL(6)
> +#define  IOCSRF_DVFSV1			BIT_ULL(7)
> +#define  IOCSRF_EIODECODE		BIT_ULL(9)
> +#define  IOCSRF_FLATMODE		BIT_ULL(10)
> +#define  IOCSRF_VM			BIT_ULL(11)
> +#define  IOCSRF_AVEC			BIT_ULL(15)
Is these definiton the same between Loongson3 mips and LoongArch machine 
such as IOCSRF_FLATMODE/IOCSRF_AVEC?

> +
> +#define LOONGSON_IOCSR_VENDOR		0x10
> +
> +#define LOONGSON_IOCSR_CPUNAME		0x20
> +
> +#define LOONGSON_IOCSR_NODECNT		0x408
> +
> +#define LOONGSON_IOCSR_MISC_FUNC	0x420
> +#define  IOCSR_MISC_FUNC_SOFT_INT	BIT_ULL(10)
> +#define  IOCSR_MISC_FUNC_TIMER_RESET	BIT_ULL(21)
> +#define  IOCSR_MISC_FUNC_EXT_IOI_EN	BIT_ULL(48)
> +#define  IOCSR_MISC_FUNC_AVEC_EN	BIT_ULL(51)
> +
> +#define LOONGSON_IOCSR_CPUTEMP		0x428
> +
> +#define LOONGSON_IOCSR_SMCMBX		0x51c
> +
> +/* PerCore CSR, only accessible by local cores */
> +#define LOONGSON_IOCSR_IPI_STATUS	0x1000
> +#define LOONGSON_IOCSR_IPI_EN		0x1004
> +#define LOONGSON_IOCSR_IPI_SET		0x1008
> +#define LOONGSON_IOCSR_IPI_CLEAR	0x100c
> +#define LOONGSON_IOCSR_MBUF0		0x1020
> +#define LOONGSON_IOCSR_MBUF1		0x1028
> +#define LOONGSON_IOCSR_MBUF2		0x1030
> +#define LOONGSON_IOCSR_MBUF3		0x1038
It seems that it is only used with arch/loongarch/kernel/smp.c,
and file smp.c is arch specific. No generic driver uses this.

> +
> +#define LOONGSON_IOCSR_IPI_SEND	0x1040
> +#define  IOCSR_IPI_SEND_IP_SHIFT	0
> +#define  IOCSR_IPI_SEND_CPU_SHIFT	16
> +#define  IOCSR_IPI_SEND_BLOCKING	BIT(31)
> +
> +#define LOONGSON_IOCSR_MBUF_SEND	0x1048
> +#define  IOCSR_MBUF_SEND_BLOCKING	BIT_ULL(31)
> +#define  IOCSR_MBUF_SEND_BOX_SHIFT	2
> +#define  IOCSR_MBUF_SEND_BOX_LO(box)	(box << 1)
> +#define  IOCSR_MBUF_SEND_BOX_HI(box)	((box << 1) + 1)
> +#define  IOCSR_MBUF_SEND_CPU_SHIFT	16
> +#define  IOCSR_MBUF_SEND_BUF_SHIFT	32
> +#define  IOCSR_MBUF_SEND_H32_MASK	0xFFFFFFFF00000000ULL
> +
> +#define LOONGSON_IOCSR_ANY_SEND	0x1158
> +#define  IOCSR_ANY_SEND_BLOCKING	BIT_ULL(31)
> +#define  IOCSR_ANY_SEND_CPU_SHIFT	16
> +#define  IOCSR_ANY_SEND_MASK_SHIFT	27
> +#define  IOCSR_ANY_SEND_BUF_SHIFT	32
> +#define  IOCSR_ANY_SEND_H32_MASK	0xFFFFFFFF00000000ULL
> +
> +/* Register offset and bit definition for CSR access */
> +#define LOONGSON_IOCSR_TIMER_CFG       0x1060
> +#define LOONGSON_IOCSR_TIMER_TICK      0x1070
> +#define  IOCSR_TIMER_CFG_RESERVED       (_ULCAST_(1) << 63)
> +#define  IOCSR_TIMER_CFG_PERIODIC       (_ULCAST_(1) << 62)
> +#define  IOCSR_TIMER_CFG_EN             (_ULCAST_(1) << 61)
> +#define  IOCSR_TIMER_MASK		0x0ffffffffffffULL
> +#define  IOCSR_TIMER_INITVAL_RST        (_ULCAST_(0xffff) << 48)
I do not find any use about IOCSR_TIMER macro, which does ip driver use 
this?

> +
> +#define LOONGSON_IOCSR_EXTIOI_NODEMAP_BASE	0x14a0
> +#define LOONGSON_IOCSR_EXTIOI_IPMAP_BASE	0x14c0
> +#define LOONGSON_IOCSR_EXTIOI_EN_BASE		0x1600
> +#define LOONGSON_IOCSR_EXTIOI_BOUNCE_BASE	0x1680
> +#define LOONGSON_IOCSR_EXTIOI_ISR_BASE		0x1800
> +#define LOONGSON_IOCSR_EXTIOI_ROUTE_BASE	0x1c00
> +#define IOCSR_EXTIOI_VECTOR_NUM			256
Is it better to define these macro in common header file or in extioi 
driver?  It seems that only extioi use it.

Regards
Bibo Mao

> +
> +#ifndef __ASSEMBLY__
> +static inline void csr_any_send(unsigned int addr, unsigned int data,
> +				unsigned int data_mask, unsigned int cpu)
> +{
> +	uint64_t val = 0;
> +
> +	val = IOCSR_ANY_SEND_BLOCKING | addr;
> +	val |= (cpu << IOCSR_ANY_SEND_CPU_SHIFT);
> +	val |= (data_mask << IOCSR_ANY_SEND_MASK_SHIFT);
> +	val |= ((uint64_t)data << IOCSR_ANY_SEND_BUF_SHIFT);
> +	iocsr_write64(val, LOONGSON_IOCSR_ANY_SEND);
> +}
> +#endif
> +
> +#endif
> +
> 


