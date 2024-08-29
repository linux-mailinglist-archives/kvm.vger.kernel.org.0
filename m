Return-Path: <kvm+bounces-25315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F7C9637F3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 03:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0DF1C21B69
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 01:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05A62B9CD;
	Thu, 29 Aug 2024 01:46:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1896B134B1;
	Thu, 29 Aug 2024 01:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724896003; cv=none; b=VBQCctrVkZkS3VYPfsSP+1DLxEewT8B1YgillDJDwjasW0006O5wPjGB56X3J2fAk8YYP7OayZQVQFgY23Zt7s2U0+ATGIgvc+WH/SubnLbCI+XEHb1WhQV9B2Ayd3tG/vUDEJEePSJ6EjmxMx/CV+OkLnNk3omLe1IxomHqGqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724896003; c=relaxed/simple;
	bh=5tXE1IB8XrXb9djQaDdkDHzizaaQ2e/cIchdZVsLffI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FZHG7IUB3sOFHbJhfNf62HUmoUmzZojfYuBawivQM7oqV2X1n6SIaDPxHY0nlhcdbUfzDpLUgPc3nSKKGW4OFAGdeADa+s8F8+pjIFEGqwuLQO3D+fGi69Rxy2c06J8Huh1jGRPf16r026g6xW4aHpisxiUDa5ccbMkWpit5Z6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dx+5r90s9mBF4jAA--.34602S3;
	Thu, 29 Aug 2024 09:46:37 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxC2f50s9myhMmAA--.63780S3;
	Thu, 29 Aug 2024 09:46:36 +0800 (CST)
Subject: Re: [PATCH v7 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Thomas Gleixner <tglx@linutronix.de>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 x86@kernel.org, Song Gao <gaosong@loongson.cn>
References: <20240823063943.2618675-1-maobibo@loongson.cn>
 <20240823063943.2618675-4-maobibo@loongson.cn>
 <CAAhV-H7t0Bn=iK7UygG6ym=hsCJqZAFVJHqDupm7mL9rVAm0GA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <b2722073-a74d-0540-18bb-ae6f450ef123@loongson.cn>
Date: Thu, 29 Aug 2024 09:46:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7t0Bn=iK7UygG6ym=hsCJqZAFVJHqDupm7mL9rVAm0GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxC2f50s9myhMmAA--.63780S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3urWDWrWfJw15Gr4fGr4xKrX_yoW8WF4xJo
	WfZF4a934fJw13ZayDG34xWry7Zw1j9rs7tw47Cw4fGr17t3WUKF47Kw1jgr4rCF45GF4f
	Aa4fWr1DJFWDJFn5l-sFpf9Il3svdjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYc7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7_Ma
	UUUUU

Huacai,

On 2024/8/28 下午10:27, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Fri, Aug 23, 2024 at 2:39 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Interrupts can be routed to maximal four virtual CPUs with one HW
>> EIOINTC interrupt controller model, since interrupt routing is encoded with
>> CPU bitmap and EIOINTC node combined method. Here add the EIOINTC virt
>> extension support so that interrupts can be routed to 256 vCPUs on
>> hypervisor mode. CPU bitmap is replaced with normal encoding and EIOINTC
>> node type is removed, so there are 8 bits for cpu selection, at most 256
>> vCPUs are supported for interrupt routing.
>>
>> Co-developed-by: Song Gao <gaosong@loongson.cn>
>> Signed-off-by: Song Gao <gaosong@loongson.cn>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   .../arch/loongarch/irq-chip-model.rst         |  64 +++++++++++
>>   .../zh_CN/arch/loongarch/irq-chip-model.rst   |  55 +++++++++
>>   arch/loongarch/include/asm/irq.h              |   1 +
>>   drivers/irqchip/irq-loongson-eiointc.c        | 106 ++++++++++++++----
>>   4 files changed, 205 insertions(+), 21 deletions(-)
>>
>> diff --git a/Documentation/arch/loongarch/irq-chip-model.rst b/Documentation/arch/loongarch/irq-chip-model.rst
>> index 7988f4192363..d2350780ad1d 100644
>> --- a/Documentation/arch/loongarch/irq-chip-model.rst
>> +++ b/Documentation/arch/loongarch/irq-chip-model.rst
>> @@ -85,6 +85,70 @@ to CPUINTC directly::
>>       | Devices |
>>       +---------+
>>
>> +Virtual extended IRQ model
>> +==========================
>> +
>> +In this model, IPI (Inter-Processor Interrupt) and CPU Local Timer interrupt
>> +go to CPUINTC directly, CPU UARTS interrupts go to PCH-PIC, while all other
>> +devices interrupts go to PCH-PIC/PCH-MSI and gathered by V-EIOINTC (Virtual
>> +Extended I/O Interrupt Controller), and then go to CPUINTC directly::
>> +
>> +       +-----+    +-------------------+     +-------+
>> +       | IPI |--> | CPUINTC(0-255vcpu)| <-- | Timer |
>> +       +-----+    +-------------------+     +-------+
>> +                            ^
>> +                            |
>> +                      +-----------+
>> +                      | V-EIOINTC |
>> +                      +-----------+
>> +                       ^         ^
>> +                       |         |
>> +                +---------+ +---------+
>> +                | PCH-PIC | | PCH-MSI |
>> +                +---------+ +---------+
>> +                  ^      ^          ^
>> +                  |      |          |
>> +           +--------+ +---------+ +---------+
>> +           | UARTs  | | Devices | | Devices |
>> +           +--------+ +---------+ +---------+
>> +
>> +
>> +Description
>> +-----------
>> +V-EIOINTC (Virtual Extended I/O Interrupt Controller) is an extension of
>> +EIOINTC, it only works in VM mode which runs in KVM hypervisor. Interrupts can
>> +be routed to up to four vCPUs via standard EIOINTC, however with V-EIOINTC
>> +interrupts can be routed to up to 256 virtual cpus.
>> +
>> +With standard EIOINTC, interrupt routing setting includes two parts: eight
>> +bits for CPU selection and four bits for CPU IP (Interrupt Pin) selection.
>> +For CPU selection there is four bits for EIOINTC node selection, four bits
>> +for EIOINTC CPU selection. Bitmap method is used for CPU selection and
>> +CPU IP selection, so interrupt can only route to CPU0 - CPU3 and IP0-IP3 in
>> +one EIOINTC node.
>> +
>> +With V-EIOINTC it supports to route more CPUs and CPU IP (Interrupt Pin),
>> +there are two newly added registers with V-EIOINTC.
>> +
>> +EXTIOI_VIRT_FEATURES
>> +--------------------
>> +This register is read-only register, which indicates supported features with
>> +V-EIOINTC. Feature EXTIOI_HAS_INT_ENCODE and EXTIOI_HAS_CPU_ENCODE is added.
>> +
>> +Feature EXTIOI_HAS_INT_ENCODE is part of standard EIOINTC. If it is 1, it
>> +indicates that CPU Interrupt Pin selection can be normal method rather than
>> +bitmap method, so interrupt can be routed to IP0 - IP15.
>> +
>> +Feature EXTIOI_HAS_CPU_ENCODE is entension of V-EIOINTC. If it is 1, it
>> +indicates that CPU selection can be normal method rather than bitmap method,
>> +so interrupt can be routed to CPU0 - CPU255.
>> +
>> +EXTIOI_VIRT_CONFIG
>> +------------------
>> +This register is read-write register, for compatibility intterupt routed uses
>> +the default method which is the same with standard EIOINTC. If the bit is set
>> +with 1, it indicated HW to use normal method rather than bitmap method.
>> +
>>   ACPI-related definitions
>>   ========================
>>
>> diff --git a/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst b/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
>> index f1e9ab18206c..d696bd394c02 100644
>> --- a/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
>> +++ b/Documentation/translations/zh_CN/arch/loongarch/irq-chip-model.rst
>> @@ -87,6 +87,61 @@ PCH-LPC/PCH-MSI，然后被EIOINTC统一收集，再直接到达CPUINTC::
>>       | Devices |
>>       +---------+
>>
>> +虚拟扩展IRQ模型
>> +===============
>> +
>> +在这种模型里面, IPI(Inter-Processor Interrupt) 和CPU本地时钟中断直接发送到CPUINTC,
>> +CPU串口 (UARTs) 中断发送到PCH-PIC, 而其他所有设备的中断则分别发送到所连接的PCH_PIC/
>> +PCH-MSI, 然后V-EIOINTC统一收集，再直接到达CPUINTC::
>> +
>> +        +-----+    +-------------------+     +-------+
>> +        | IPI |--> | CPUINTC(0-255vcpu)| <-- | Timer |
>> +        +-----+    +-------------------+     +-------+
>> +                             ^
>> +                             |
>> +                       +-----------+
>> +                       | V-EIOINTC |
>> +                       +-----------+
>> +                        ^         ^
>> +                        |         |
>> +                 +---------+ +---------+
>> +                 | PCH-PIC | | PCH-MSI |
>> +                 +---------+ +---------+
>> +                   ^      ^          ^
>> +                   |      |          |
>> +            +--------+ +---------+ +---------+
>> +            | UARTs  | | Devices | | Devices |
>> +            +--------+ +---------+ +---------+
>> +
>> +V-EIOINTC 是EIOINTC的扩展, 仅工作在hyperisor模式下, 中断经EIOINTC最多可个路由到４个
>> +虚拟cpu. 但中断经V-EIOINTC最多可个路由到256个虚拟cpu.
>> +
>> +传统的EIOINTC中断控制器，中断路由分为两个部分：8比特用于控制路由到哪个CPU，
>> +4比特用于控制路由到特定CPU的哪个中断管脚.控制CPU路由的8比特前4比特用于控制
>> +路由到哪个EIOINTC节点，后4比特用于控制此节点哪个CPU。中断路由在选择CPU路由
>> +和CPU中断管脚路由时，使用bitmap编码方式而不是正常编码方式，所以对于一个
>> +EIOINTC中断控制器节点，中断只能路由到CPU0 - CPU3，中断管教IP0-IP3。
>> +
>> +V-EIOINTC新增了两个寄存器，支持中断路由到更多CPU个和中断管脚。
>> +
>> +V-EIOINTC功能寄存器
>> +-------------------
>> +功能寄存器是只读寄存器，用于显示V-EIOINTC支持的特性，目前两个支持两个特性
>> +EXTIOI_HAS_INT_ENCODE 和 EXTIOI_HAS_CPU_ENCODE。
>> +
>> +特性EXTIOI_HAS_INT_ENCODE是传统EIOINTC中断控制器的一个特性，如果此比特为1，
>> +显示CPU中断管脚路由方式支持正常编码，而不是bitmap编码，所以中断可以路由到
>> +管脚IP0 - IP15。
>> +
>> +特性EXTIOI_HAS_CPU_ENCODE是V-EIOINTC新增特性，如果此比特为1，表示CPU路由
>> +方式支持正常编码，而不是bitmap编码，所以中断可以路由到CPU0 - CPU255。
>> +
>> +V-EIOINTC配置寄存器
>> +-------------------
>> +配置寄存器是可读写寄存器，为了兼容性考虑，如果不写此寄存器，中断路由采用
>> +和传统EIOINTC相同的路由设置。如果对应比特设置为1，表示采用正常路由方式而
>> +不是bitmap编码的路由方式。
>> +
>>   ACPI相关的定义
>>   ==============
>>
>> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
>> index 480418bc5071..ce85d4c7d225 100644
>> --- a/arch/loongarch/include/asm/irq.h
>> +++ b/arch/loongarch/include/asm/irq.h
>> @@ -54,6 +54,7 @@ extern struct acpi_vector_group pch_group[MAX_IO_PICS];
>>   extern struct acpi_vector_group msi_group[MAX_IO_PICS];
>>
>>   #define CORES_PER_EIO_NODE     4
>> +#define CORES_PER_VEIO_NODE    256
>>
>>   #define LOONGSON_CPU_UART0_VEC         10 /* CPU UART0 */
>>   #define LOONGSON_CPU_THSENS_VEC                14 /* CPU Thsens */
>> diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
>> index b1f2080be2be..bc54f81ec129 100644
>> --- a/drivers/irqchip/irq-loongson-eiointc.c
>> +++ b/drivers/irqchip/irq-loongson-eiointc.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/irqdomain.h>
>>   #include <linux/irqchip/chained_irq.h>
>>   #include <linux/kernel.h>
>> +#include <linux/kvm_para.h>
>>   #include <linux/syscore_ops.h>
>>   #include <asm/numa.h>
>>
>> @@ -24,15 +25,37 @@
>>   #define EIOINTC_REG_ISR                0x1800
>>   #define EIOINTC_REG_ROUTE      0x1c00
>>
>> +#define EXTIOI_VIRT_FEATURES           0x40000000
>> +#define  EXTIOI_HAS_VIRT_EXTENSION     BIT(0)
>> +#define  EXTIOI_HAS_ENABLE_OPTION      BIT(1)
>> +#define  EXTIOI_HAS_INT_ENCODE         BIT(2)
>> +#define  EXTIOI_HAS_CPU_ENCODE         BIT(3)
>> +#define EXTIOI_VIRT_CONFIG             0x40000004
>> +#define  EXTIOI_ENABLE                 BIT(1)
>> +#define  EXTIOI_ENABLE_INT_ENCODE      BIT(2)
>> +#define  EXTIOI_ENABLE_CPU_ENCODE      BIT(3)
> I think qemu hasn't release with v-eiointc? So we still have a chance
> to modify qemu and this driver to simplify registers:
It is already merged in qemu mainline, code is frozen and qemu 9.1 will 
release soon. Once it is merged in mainline and even if code is not 
frozen, I will modify it only if it is bug.
> 
> +#define EXTIOI_VIRT_FEATS             0x40000000
> +#define  EXTIOI_HAS_INT_ENCODE         BIT(0)
> +#define  EXTIOI_HAS_CPU_ENCODE         BIT(1)
> +#define EXTIOI_VIRT_CONFIG             0x40000004
> +#define  EXTIOI_ENABLE_INT_ENCODE      BIT(0)
> +#define  EXTIOI_ENABLE_CPU_ENCODE      BIT(1)
> 
>> +
>>   #define VEC_REG_COUNT          4
>>   #define VEC_COUNT_PER_REG      64
>>   #define VEC_COUNT              (VEC_REG_COUNT * VEC_COUNT_PER_REG)
>>   #define VEC_REG_IDX(irq_id)    ((irq_id) / VEC_COUNT_PER_REG)
>>   #define VEC_REG_BIT(irq_id)     ((irq_id) % VEC_COUNT_PER_REG)
>>   #define EIOINTC_ALL_ENABLE     0xffffffff
>> +#define EIOINTC_ALL_ENABLE_VEC_MASK(vector)    (EIOINTC_ALL_ENABLE & ~BIT(vector & 0x1F))
>> +#define EIOINTC_REG_ENABLE_VEC(vector)         (EIOINTC_REG_ENABLE + ((vector >> 5) << 2))
>> +#define EIOINTC_USE_CPU_ENCODE                 BIT(0)
>>
>>   #define MAX_EIO_NODES          (NR_CPUS / CORES_PER_EIO_NODE)
>>
>> +/*
>> + * Routing registers are 32bit, and there is 8-bit route setting for every
>> + * interrupt vector. So one Route register contains four vectors routing
>> + * information.
>> + */
>> +#define EIOINTC_REG_ROUTE_VEC(vector)          (EIOINTC_REG_ROUTE + (vector & ~0x03))
>> +#define EIOINTC_REG_ROUTE_VEC_SHIFT(vector)    ((vector & 0x03) << 3)
>> +#define EIOINTC_REG_ROUTE_VEC_MASK(vector)     (0xff << EIOINTC_REG_ROUTE_VEC_SHIFT(vector))
>> +
>>   static int nr_pics;
>>
>>   struct eiointc_priv {
>> @@ -42,6 +65,7 @@ struct eiointc_priv {
>>          cpumask_t               cpuspan_map;
>>          struct fwnode_handle    *domain_handle;
>>          struct irq_domain       *eiointc_domain;
>> +       int                     flags;
>>   };
>>
>>   static struct eiointc_priv *eiointc_priv[MAX_IO_PICS];
>> @@ -57,7 +81,13 @@ static void eiointc_enable(void)
>>
>>   static int cpu_to_eio_node(int cpu)
>>   {
>> -       return cpu_logical_map(cpu) / CORES_PER_EIO_NODE;
>> +       int cores;
>> +
>> +       if (kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))
>> +               cores = CORES_PER_VEIO_NODE;
>> +       else
>> +               cores = CORES_PER_EIO_NODE;
>> +       return cpu_logical_map(cpu) / cores;
>>   }
>>
>>   #ifdef CONFIG_SMP
>> @@ -89,6 +119,16 @@ static void eiointc_set_irq_route(int pos, unsigned int cpu, unsigned int mnode,
>>
>>   static DEFINE_RAW_SPINLOCK(affinity_lock);
>>
>> +static void virt_extioi_set_irq_route(unsigned int vector, unsigned int cpu)
> Use veiointc_set_irq_route() can keep consistency with real machines.
yes, veiointc_set_irq_route will be added here.

> 
>> +{
>> +       unsigned long reg = EIOINTC_REG_ROUTE_VEC(vector);
>> +       u32 data = iocsr_read32(reg);
>> +
>> +       data &= ~EIOINTC_REG_ROUTE_VEC_MASK(vector);
>> +       data |= cpu_logical_map(cpu) << EIOINTC_REG_ROUTE_VEC_SHIFT(vector);
>> +       iocsr_write32(data, reg);
>> +}
>> +
>>   static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpumask *affinity, bool force)
>>   {
>>          unsigned int cpu;
>> @@ -105,18 +145,24 @@ static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpumask *af
>>          }
>>
>>          vector = d->hwirq;
>> -       regaddr = EIOINTC_REG_ENABLE + ((vector >> 5) << 2);
>> -
>> -       /* Mask target vector */
>> -       csr_any_send(regaddr, EIOINTC_ALL_ENABLE & (~BIT(vector & 0x1F)),
>> -                       0x0, priv->node * CORES_PER_EIO_NODE);
>> -
>> -       /* Set route for target vector */
>> -       eiointc_set_irq_route(vector, cpu, priv->node, &priv->node_map);
>> -
>> -       /* Unmask target vector */
>> -       csr_any_send(regaddr, EIOINTC_ALL_ENABLE,
>> -                       0x0, priv->node * CORES_PER_EIO_NODE);
>> +       regaddr = EIOINTC_REG_ENABLE_VEC(vector);
>> +
>> +       if (priv->flags & EIOINTC_USE_CPU_ENCODE) {
>> +               iocsr_write32(EIOINTC_ALL_ENABLE_VEC_MASK(vector), regaddr);
>> +               virt_extioi_set_irq_route(vector, cpu);
>> +               iocsr_write32(EIOINTC_ALL_ENABLE, regaddr);
> We can add the same comments as real machines here.
Similar comments will be added, otherwise there will be duplicated comments.

Hope to this the last review comments about grammar and name -:), else I 
will think it is on deliberate. we know every architecture has multiple 
maintainers to prevent arbitrary except LoongArch.

Regards
Bibo Mao

> 
> Huacai
> 
>> +       } else {
>> +               /* Mask target vector */
>> +               csr_any_send(regaddr, EIOINTC_ALL_ENABLE_VEC_MASK(vector),
>> +                            0x0, priv->node * CORES_PER_EIO_NODE);
>> +
>> +               /* Set route for target vector */
>> +               eiointc_set_irq_route(vector, cpu, priv->node, &priv->node_map);
>> +
>> +               /* Unmask target vector */
>> +               csr_any_send(regaddr, EIOINTC_ALL_ENABLE,
>> +                            0x0, priv->node * CORES_PER_EIO_NODE);
>> +       }
>>
>>          irq_data_update_effective_affinity(d, cpumask_of(cpu));
>>
>> @@ -140,17 +186,23 @@ static int eiointc_index(int node)
>>
>>   static int eiointc_router_init(unsigned int cpu)
>>   {
>> -       int i, bit;
>> -       uint32_t data;
>> -       uint32_t node = cpu_to_eio_node(cpu);
>> -       int index = eiointc_index(node);
>> +       int i, bit, cores, index, node;
>> +       unsigned int data;
>> +
>> +       node = cpu_to_eio_node(cpu);
>> +       index = eiointc_index(node);
>>
>>          if (index < 0) {
>>                  pr_err("Error: invalid nodemap!\n");
>> -               return -1;
>> +               return -EINVAL;
>>          }
>>
>> -       if ((cpu_logical_map(cpu) % CORES_PER_EIO_NODE) == 0) {
>> +       if (eiointc_priv[index]->flags & EIOINTC_USE_CPU_ENCODE)
>> +               cores = CORES_PER_VEIO_NODE;
>> +       else
>> +               cores = CORES_PER_EIO_NODE;
>> +
>> +       if ((cpu_logical_map(cpu) % cores) == 0) {
>>                  eiointc_enable();
>>
>>                  for (i = 0; i < eiointc_priv[0]->vec_count / 32; i++) {
>> @@ -166,7 +218,9 @@ static int eiointc_router_init(unsigned int cpu)
>>
>>                  for (i = 0; i < eiointc_priv[0]->vec_count / 4; i++) {
>>                          /* Route to Node-0 Core-0 */
>> -                       if (index == 0)
>> +                       if (eiointc_priv[index]->flags & EIOINTC_USE_CPU_ENCODE)
>> +                               bit = cpu_logical_map(0);
>> +                       else if (index == 0)
>>                                  bit = BIT(cpu_logical_map(0));
>>                          else
>>                                  bit = (eiointc_priv[index]->node << 4) | 1;
>> @@ -370,7 +424,7 @@ static int __init acpi_cascade_irqdomain_init(void)
>>   static int __init eiointc_init(struct eiointc_priv *priv, int parent_irq,
>>                                 u64 node_map)
>>   {
>> -       int i;
>> +       int i, val;
>>
>>          node_map = node_map ? node_map : -1ULL;
>>          for_each_possible_cpu(i) {
>> @@ -390,6 +444,16 @@ static int __init eiointc_init(struct eiointc_priv *priv, int parent_irq,
>>                  return -ENOMEM;
>>          }
>>
>> +       if (kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI)) {
>> +               val = iocsr_read32(EXTIOI_VIRT_FEATURES);
>> +               if (val & EXTIOI_HAS_CPU_ENCODE) {
>> +                       val = iocsr_read32(EXTIOI_VIRT_CONFIG);
>> +                       val |= EXTIOI_ENABLE_CPU_ENCODE;
>> +                       iocsr_write32(val, EXTIOI_VIRT_CONFIG);
>> +                       priv->flags = EIOINTC_USE_CPU_ENCODE;
>> +               }
>> +       }
>> +
>>          eiointc_priv[nr_pics++] = priv;
>>          eiointc_router_init(0);
>>          irq_set_chained_handler_and_data(parent_irq, eiointc_irq_dispatch, priv);
>> --
>> 2.39.3
>>


