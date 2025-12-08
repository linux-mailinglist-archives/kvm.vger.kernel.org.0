Return-Path: <kvm+bounces-65477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EECEFCABFB1
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 04:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0DBF030274CF
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 03:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7631E24DFF3;
	Mon,  8 Dec 2025 03:48:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF9C8C1F;
	Mon,  8 Dec 2025 03:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765165714; cv=none; b=FsqF+nBeHGnRYpSxmP+Zn1gkLLklWlpB8LDZl1vDu7IaF7B37LQdKHh0ulQ+WFZZbD6SyK1NamDc0BhAzGe2EPGSeo1fSNa7SJ14P9hmIR2gxszOr3D2eBmiykL6/MiuJ80IKGw2RBYZz1Ob2vVPdDpkNpeLJU+SzVMBoIgyMA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765165714; c=relaxed/simple;
	bh=nCRj2GBnUGFZOywSBOroAQamrdEwQ1IGFW62r5tyLvE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IM1Gn/j4Jt+Cs6G/z0LkPUhFBTfhJlShDSWgp7Wz4t2k54/TCGUDZmtMm7uc0T29H+nTiiX5KGQ3tYxtvOG24YRgBMlHGWY2dlEGvpQVLg5bEJeHNe80Phv9yreTfGPzRW+x8aoUBe2YRBVuM6KLk6xfTPjLlaySMXwxsTPFG5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dxb_CFSjZpricsAA--.30613S3;
	Mon, 08 Dec 2025 11:48:21 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxqcCDSjZpYuVGAQ--.34286S3;
	Mon, 08 Dec 2025 11:48:21 +0800 (CST)
Subject: Re: [PATCH v3 1/4] LongArch: KVM: Add some maccros for AVEC
To: Song Gao <gaosong@loongson.cn>, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org, lixianglai@loongson.cn
References: <20251206064658.714100-1-gaosong@loongson.cn>
 <20251206064658.714100-2-gaosong@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <894a4c72-af10-2662-1c31-f008a0d7d2f2@loongson.cn>
Date: Mon, 8 Dec 2025 11:45:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251206064658.714100-2-gaosong@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxqcCDSjZpYuVGAQ--.34286S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zr4xZFWDZw1DAw1kKF1kXrc_yoW8uF48pF
	ZrAFZYgr48KryxJw43tws0vr13Aws7Gr42ga4jgFyavr98Ww1kWr18K3s3ZFy0gan7Gaya
	qr1FqFy3Wan8twcCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUrNtx
	DUUUU



On 2025/12/6 下午2:46, Song Gao wrote:
> Add some maccros for AVEC interrupt controller, so the dintc can use
> those maccros.
> 
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>   arch/loongarch/include/asm/irq.h     | 8 ++++++++
>   drivers/irqchip/irq-loongarch-avec.c | 5 +++--
>   2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
> index 12bd15578c33..aaa022fcb9e3 100644
> --- a/arch/loongarch/include/asm/irq.h
> +++ b/arch/loongarch/include/asm/irq.h
> @@ -50,6 +50,14 @@ void spurious_interrupt(void);
>   #define NR_LEGACY_VECTORS	16
>   #define IRQ_MATRIX_BITS		NR_VECTORS
>   
> +#define AVEC_VIRQ_SHIFT		4
> +#define AVEC_VIRQ_BIT		8
> +#define AVEC_VIRQ_MASK		GENMASK(AVEC_VIRQ_BIT - 1, 0)
> +#define AVEC_CPU_SHIFT		12
(AVEC_VIRQ_SHIFT + AVEC_VIRQ_BIT) compared with hard coded 12 ?

> +#define AVEC_CPU_BIT		16
> +#define AVEC_CPU_MASK		GENMASK(AVEC_CPU_BIT - 1, 0)
> +
> +
one more unnecessary space line, otherwise it looks good to me.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>   #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
>   void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int exclude_cpu);
>   
> diff --git a/drivers/irqchip/irq-loongarch-avec.c b/drivers/irqchip/irq-loongarch-avec.c
> index bf52dc8345f5..f0118cfd4363 100644
> --- a/drivers/irqchip/irq-loongarch-avec.c
> +++ b/drivers/irqchip/irq-loongarch-avec.c
> @@ -209,8 +209,9 @@ static void avecintc_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
>   	struct avecintc_data *adata = irq_data_get_irq_chip_data(d);
>   
>   	msg->address_hi = 0x0;
> -	msg->address_lo = (loongarch_avec.msi_base_addr | (adata->vec & 0xff) << 4)
> -			  | ((cpu_logical_map(adata->cpu & 0xffff)) << 12);
> +	msg->address_lo = (loongarch_avec.msi_base_addr |
> +			(adata->vec & AVEC_VIRQ_MASK) << AVEC_VIRQ_SHIFT) |
> +			((cpu_logical_map(adata->cpu & AVEC_CPU_MASK)) << AVEC_CPU_SHIFT);
>   	msg->data = 0x0;
>   }
>   
> 


