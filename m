Return-Path: <kvm+bounces-66293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F54CCE5CF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:26:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D0613038F56
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA342BF3DF;
	Fri, 19 Dec 2025 03:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="AySTbkGJ"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C4286416;
	Fri, 19 Dec 2025 03:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766114766; cv=none; b=LqsyrU3goKcaE0cTHHpAVUFn/7IX2A5o7xPmn7Zi4NcBW/zAZf8pacoXYeje/pnM1tGE1GfCxdA2RFYjvjEuKKuEI5+a2Cka/Td9npX4Ywe7TljgLiZtpMFXzeDBdCepNIcGV8nj5a+4p+yf0k0PdnPvcI2nn4hRdAbeFBmVNYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766114766; c=relaxed/simple;
	bh=kYmtpufhJKhAKeX0q5dQjGDQPr7GQvGMR+Gtv3xNNi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrvbO9AoBDRLPrFlZI9A41VAqgjFjhpvP0pSkq7IunLx3JmGu/LnzO4RXHVAKkpwz8xFe6C0qJy5RAVICLv2QL3hhCJj+cOJZP4HG/Pp/yjgq1aCVJ+XW+Wb+scE6TGYnol7fEemiY84ApxXbJdc3O2ciMa9tLV5MPTQwK/pnu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=AySTbkGJ; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1766114441; bh=kYmtpufhJKhAKeX0q5dQjGDQPr7GQvGMR+Gtv3xNNi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AySTbkGJ8FAHK9KJO9inCKRb58MLnb+gpKR0jsK4hwPa0eT99YxZybm5jsKyUR54p
	 I1AYRpJ7iSFMPYKpyQamrpm1coGevg4AVRPWL/+ZB40TCwnmcmbJD6S7Ss9c7nnm1T
	 g281XYQ0DK2q81hRn2iBXf/tbOLa20jampTj5sIY=
Received: from [IPV6:240e:b8f:939d:bb00::8c0] (unknown [IPv6:240e:b8f:939d:bb00::8c0])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id EE5EE600F4;
	Fri, 19 Dec 2025 11:20:40 +0800 (CST)
Message-ID: <af2d9f9c-1931-484f-ab67-849093c3a760@xen0n.name>
Date: Fri, 19 Dec 2025 11:20:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] LongArch: KVM: Add DMSINTC device support
To: Song Gao <gaosong@loongson.cn>, maobibo@loongson.cn, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251218111822.975455-1-gaosong@loongson.cn>
 <20251218111822.975455-2-gaosong@loongson.cn>
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20251218111822.975455-2-gaosong@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/25 19:18, Song Gao wrote:
> Add device model for DMSINTC interrupt controller, implement basic
> create/destroy/set_attr interfaces, and register device model to kvm
> device table.
> 
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_dmsintc.h |  21 +++++
>   arch/loongarch/include/asm/kvm_host.h    |   3 +
>   arch/loongarch/include/uapi/asm/kvm.h    |   4 +
>   arch/loongarch/kvm/Makefile              |   1 +
>   arch/loongarch/kvm/intc/dmsintc.c        | 110 +++++++++++++++++++++++
>   arch/loongarch/kvm/main.c                |   5 ++
>   include/uapi/linux/kvm.h                 |   2 +
>   7 files changed, 146 insertions(+)
>   create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
>   create mode 100644 arch/loongarch/kvm/intc/dmsintc.c
> 
> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
> new file mode 100644
> index 000000000000..1d4f66996f3c
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_DMSINTC_H
> +#define __ASM_KVM_DMSINTC_H
> +
> +
> +struct loongarch_dmsintc  {
> +	struct kvm *kvm;
> +	uint64_t msg_addr_base;
> +	uint64_t msg_addr_size;
> +};
> +
> +struct dmsintc_state {
> +	atomic64_t  vector_map[4];
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void);
> +#endif
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index e4fe5b8e8149..5e9e2af7312f 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -22,6 +22,7 @@
>   #include <asm/kvm_ipi.h>
>   #include <asm/kvm_eiointc.h>
>   #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_dmsintc.h>
>   #include <asm/loongarch.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -134,6 +135,7 @@ struct kvm_arch {
>   	struct loongarch_ipi *ipi;
>   	struct loongarch_eiointc *eiointc;
>   	struct loongarch_pch_pic *pch_pic;
> +	struct loongarch_dmsintc *dmsintc;
>   };
>   
>   #define CSR_MAX_NUMS		0x800
> @@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
>   	struct kvm_mp_state mp_state;
>   	/* ipi state */
>   	struct ipi_state ipi_state;
> +	struct dmsintc_state dmsintc_state;
>   	/* cpucfg */
>   	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>   
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index de6c3f18e40a..0a370d018b08 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>   #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
>   #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
>   
> +#define KVM_DEV_LOONGARCH_DMSINTC_CTRL			0x40000007
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE		0x0
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE		0x1
> +
>   #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..6e184e24443c 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,6 +19,7 @@ kvm-y += vm.o
>   kvm-y += intc/ipi.o
>   kvm-y += intc/eiointc.o
>   kvm-y += intc/pch_pic.o
> +kvm-y += intc/dmsintc.o
>   kvm-y += irqfd.o
>   
>   CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
> new file mode 100644
> index 000000000000..3fdea81a08c8
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/dmsintc.c
> @@ -0,0 +1,110 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_dmsintc.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
> +				struct kvm_device_attr *attr,
> +				bool is_write)
> +{
> +	int addr = attr->attr;
> +	void __user *data;
> +	struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
> +	u64 tmp;
> +
> +	data = (void __user *)attr->addr;
> +	switch (addr) {
> +	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE:
> +		if (is_write) {
> +			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_base)))
> +				return -EFAULT;
> +			if (s->msg_addr_base) {
> +				/* Duplicate setting are not allowed. */
> +				return -EFAULT;
> +			}
> +			if ((tmp & (BIT(AVEC_CPU_SHIFT) - 1)) == 0)
> +				s->msg_addr_base = tmp;
> +			else
> +				return  -EFAULT;
> +		}
> +		break;
> +	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
> +		if (is_write) {
> +			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_size)))
> +				return -EFAULT;
> +			if (s->msg_addr_size) {
> +				/*Duplicate setting are not allowed. */
> +				return -EFAULT;
> +			}
> +			s->msg_addr_size = tmp;
> +		}
> +		break;
> +	default:
> +		kvm_err("%s: unknown dmsintc register, addr = %d\n", __func__, addr);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_dmsintc_set_attr(struct kvm_device *dev,
> +			struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_LOONGARCH_DMSINTC_CTRL:
> +		return kvm_dmsintc_ctrl_access(dev, attr, true);
> +	default:
> +		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
> +		return -EINVAL;
> +	}
> +}
> +
> +static int kvm_dmsintc_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_dmsintc *s;
> +
> +	if (!dev) {
> +		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	kvm = dev->kvm;
> +	if (kvm->arch.dmsintc) {
> +		kvm_err("%s: LoongArch DMSINTC has already been created!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	s = kzalloc(sizeof(struct loongarch_dmsintc), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	s->kvm = kvm;
> +	kvm->arch.dmsintc = s;
> +	return 0;
> +}
> +
> +static void kvm_dmsintc_destroy(struct kvm_device *dev)
> +{
> +
> +	if (!dev || !dev->kvm || !dev->kvm->arch.dmsintc)
> +		return;
> +
> +	kfree(dev->kvm->arch.dmsintc);
> +}
> +
> +static struct kvm_device_ops kvm_dmsintc_dev_ops = {
> +	.name = "kvm-loongarch-dmsintc",
> +	.create = kvm_dmsintc_create,
> +	.destroy = kvm_dmsintc_destroy,
> +	.set_attr = kvm_dmsintc_set_attr,
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DMSINTC);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..2e26d4fd9000 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -408,6 +408,11 @@ static int kvm_loongarch_env_init(void)
>   
>   	/* Register LoongArch PCH-PIC interrupt controller interface. */
>   	ret = kvm_loongarch_register_pch_pic_device();
> +	if (ret)
> +		return ret;
> +
> +	/* Register LoongArch DMSINTC interrupt contrroller interface */
> +	ret = kvm_loongarch_register_dmsintc_device();
>   
>   	return ret;
>   }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..7c56e7e36265 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1209,6 +1209,8 @@ enum kvm_device_type {
>   #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
>   	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>   #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
> +	KVM_DEV_TYPE_LOONGARCH_DMSINTC,
> +#define KVM_DEV_TYPE_LOONGARCH_DMSINTC   KVM_DEV_TYPE_LOONGARCH_DMSINTC
>   
>   	KVM_DEV_TYPE_MAX,
>   

Not a single line explaining what "DMSINTC" is? I checked v1, v2, and 
v3, no documentation regarding DINTC or DMSINTC at all. We can see (and 
Huacai explained in v3 review comment) "MSINTC" means "message-signaled 
interrupt controller", but what does "D" mean? You may want to update 
Documentation/arch/loongarch/irq-chip-model.rst for that.

-- 
Regards,
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

