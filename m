Return-Path: <kvm+bounces-26607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF62975FA8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 05:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E8F41F238A7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 03:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB5B13A40F;
	Thu, 12 Sep 2024 03:26:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B39524D7
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 03:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726111575; cv=none; b=X0s0+QCqZcAYtaGEl0daaKwwM1MQ7Rw/eSQV4hENFbh28qtn+xus7oYhofQqMxtTP3mkzQmRQnGzzFb+V2r1oitGGmjbeI85Q3/4CNXzcxOBOEDJ5jd/4eJnSRvrudlxUO/IfUiIOz+Eg/Ez9GzmxtKLuA+s9Z6rBjiyxU4OBgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726111575; c=relaxed/simple;
	bh=fKVuG+uiI2l4gBm+OxuG8N39xSOHy++rw0ouRvy1Jyw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VInlMDiMCR6T9iJz+9CN1etJnnWvAWj/XXMuK925Y6KQJJHLtXt2oIUElncESE+lDqRc6J7OMJbZFzNivk9jDx63pWj2Y0ciF205MXUdZ3OHT5b4aqi3zxzwWi/CqZcECfqr+TWQcDZPbwqoR5G5etlko4ISh9iUWl7dfdn1Tvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxC+pKX+JmhWwFAA--.12720S3;
	Thu, 12 Sep 2024 11:26:02 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front2 (Coremail) with SMTP id qciowMAxa8ZFX+JmJkgFAA--.24414S3;
	Thu, 12 Sep 2024 11:25:59 +0800 (CST)
Subject: Re: [RFC PATCH V2 3/5] hw/loongarch: Add KVM extioi device support
To: Xianglai Li <lixianglai@loongson.cn>, qemu-devel@nongnu.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1725969898.git.lixianglai@loongson.cn>
 <f359346bb865fcc4d52552c8c0fc27123c858aad.1725969898.git.lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <9abdad1a-4a23-00b6-f3ef-51ba4ea6bebb@loongson.cn>
Date: Thu, 12 Sep 2024 11:25:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f359346bb865fcc4d52552c8c0fc27123c858aad.1725969898.git.lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMAxa8ZFX+JmJkgFAA--.24414S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3Cw18ArW3Kr18AF15ZrWUGFX_yoW8GFWxuo
	WUJFsFvr4rJr97ZrZ5JwsrtF43tr409FW5AFW7Zw43uF47tFW5Ja1DK3WFkryxWFs8KryD
	GasIgFs7Ja42yw1rl-sFpf9Il3svdjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUO17kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8JVW8Jr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8HKZJUUUU
	U==



On 2024/9/10 下午8:18, Xianglai Li wrote:
> Added extioi interrupt controller for kvm emulation.
> The main process is to send the command word for
> creating an extioi device to the kernel.
> When the VM is saved, the ioctl obtains the related
> data of the extioi interrupt controller in the kernel
> and saves it. When the VM is recovered, the saved data
> is sent to the kernel.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Song Gao <gaosong@loongson.cn>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> 
>   hw/intc/Kconfig                |   3 +
>   hw/intc/loongarch_extioi_kvm.c | 250 +++++++++++++++++++++++++++++++++
>   hw/intc/meson.build            |   1 +
>   hw/loongarch/Kconfig           |   1 +
>   hw/loongarch/virt.c            |  51 ++++---
>   5 files changed, 285 insertions(+), 21 deletions(-)
>   create mode 100644 hw/intc/loongarch_extioi_kvm.c
> 
> diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
> index 5201505f23..df9352d41d 100644
> --- a/hw/intc/Kconfig
> +++ b/hw/intc/Kconfig
> @@ -112,3 +112,6 @@ config LOONGARCH_PCH_MSI
>   
>   config LOONGARCH_EXTIOI
>       bool
> +
> +config LOONGARCH_EXTIOI_KVM
> +    bool
> diff --git a/hw/intc/loongarch_extioi_kvm.c b/hw/intc/loongarch_extioi_kvm.c
> new file mode 100644
> index 0000000000..139a00ac2a
> --- /dev/null
> +++ b/hw/intc/loongarch_extioi_kvm.c
> @@ -0,0 +1,250 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * LoongArch kvm extioi interrupt support
> + *
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/qdev-properties.h"
> +#include "qemu/typedefs.h"
> +#include "hw/intc/loongarch_extioi.h"
> +#include "hw/sysbus.h"
> +#include "linux/kvm.h"
> +#include "migration/vmstate.h"
> +#include "qapi/error.h"
> +#include "sysemu/kvm.h"
> +
> +static void kvm_extioi_access_regs(int fd, uint64_t addr,
> +                                       void *val, bool is_write)
> +{
> +        kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS,
> +                          addr, val, is_write, &error_abort);
> +}
> +
> +static void kvm_extioi_access_sw_status(int fd, uint64_t addr,
> +                                       void *val, bool is_write)
> +{
> +        kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS,
> +                          addr, val, is_write, &error_abort);
> +}
> +
> +static void kvm_extioi_save_load_sw_status(void *opaque, bool is_write)
> +{
> +    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
> +    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
> +    int fd = class->dev_fd;
> +    int addr;
> +
> +    addr = KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU;
> +    kvm_extioi_access_sw_status(fd, addr, (void *)&s->num_cpu, is_write);
> +
> +    addr = KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE;
> +    kvm_extioi_access_sw_status(fd, addr, (void *)&s->features, is_write);
> +
> +    addr = KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE;
> +    kvm_extioi_access_sw_status(fd, addr, (void *)&s->status, is_write);
> +}
> +
> +static void kvm_extioi_save_load_regs(void *opaque, bool is_write)
> +{
> +    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
> +    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
> +    int fd = class->dev_fd;
> +    int addr, offset, cpuid;
> +
> +    for (addr = EXTIOI_NODETYPE_START; addr < EXTIOI_NODETYPE_END; addr += 4) {
> +        offset = (addr - EXTIOI_NODETYPE_START) / 4;
> +        kvm_extioi_access_regs(fd, addr,
> +                               (void *)&s->nodetype[offset], is_write);
> +    }
> +
> +    for (addr = EXTIOI_IPMAP_START; addr < EXTIOI_IPMAP_END; addr += 4) {
> +        offset = (addr - EXTIOI_IPMAP_START) / 4;
> +        kvm_extioi_access_regs(fd, addr, (void *)&s->ipmap[offset], is_write);
> +    }
> +
> +    for (addr = EXTIOI_ENABLE_START; addr < EXTIOI_ENABLE_END; addr += 4) {
> +        offset = (addr - EXTIOI_ENABLE_START) / 4;
> +        kvm_extioi_access_regs(fd, addr,
> +                               (void *)&s->enable[offset], is_write);
> +    }
> +
> +    for (addr = EXTIOI_BOUNCE_START; addr < EXTIOI_BOUNCE_END; addr += 4) {
> +        offset = (addr - EXTIOI_BOUNCE_START) / 4;
> +        kvm_extioi_access_regs(fd, addr,
> +                               (void *)&s->bounce[offset], is_write);
> +    }
> +
> +    for (addr = EXTIOI_ISR_START; addr < EXTIOI_ISR_END; addr += 4) {
> +        offset = (addr - EXTIOI_ISR_START) / 4;
> +        kvm_extioi_access_regs(fd, addr,
> +                               (void *)&s->isr[offset], is_write);
> +    }
> +
> +    for (addr = EXTIOI_COREMAP_START; addr < EXTIOI_COREMAP_END; addr += 4) {
> +        offset = (addr - EXTIOI_COREMAP_START) / 4;
> +        kvm_extioi_access_regs(fd, addr,
> +                               (void *)&s->coremap[offset], is_write);
> +    }
> +
> +    for (cpuid = 0; cpuid < s->num_cpu; cpuid++) {
> +        for (addr = EXTIOI_COREISR_START;
> +             addr < EXTIOI_COREISR_END; addr += 4) {
> +            offset = (addr - EXTIOI_COREISR_START) / 4;
> +            addr = (cpuid << 16) | addr;
> +            kvm_extioi_access_regs(fd, addr,
> +                              (void *)&s->coreisr[cpuid][offset], is_write);
> +        }
> +    }
> +}
> +
> +static int kvm_loongarch_extioi_pre_save(void *opaque)
> +{
> +    kvm_extioi_save_load_regs(opaque, false);
> +    kvm_extioi_save_load_sw_status(opaque, false);
> +    return 0;
> +}
> +
> +static int kvm_loongarch_extioi_post_load(void *opaque, int version_id)
> +{
> +    KVMLoongArchExtIOI *s = (KVMLoongArchExtIOI *)opaque;
> +    KVMLoongArchExtIOIClass *class = KVM_LOONGARCH_EXTIOI_GET_CLASS(s);
> +    int fd = class->dev_fd;
> +
> +    kvm_extioi_save_load_regs(opaque, true);
> +    kvm_extioi_save_load_sw_status(opaque, true);
> +
> +    kvm_device_access(fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL,
> +                      KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED,
> +                      NULL, true, &error_abort);
> +    return 0;
> +}
> +
> +static void kvm_loongarch_extioi_realize(DeviceState *dev, Error **errp)
> +{
> +    KVMLoongArchExtIOIClass *extioi_class = KVM_LOONGARCH_EXTIOI_GET_CLASS(dev);
> +    KVMLoongArchExtIOI *s = KVM_LOONGARCH_EXTIOI(dev);
> +    struct kvm_create_device cd = {0};
> +    Error *err = NULL;
> +    int ret, i;
> +
> +    extioi_class->parent_realize(dev, &err);
> +    if (err) {
> +        error_propagate(errp, err);
> +        return;
> +    }
> +
> +    if (s->num_cpu == 0) {
> +        error_setg(errp, "num-cpu must be at least 1");
> +        return;
> +    }
> +
> +
> +    if (extioi_class->is_created) {
> +        error_setg(errp, "extioi had be created");
> +        return;
> +    }
> +
> +    if (s->features & BIT(EXTIOI_HAS_VIRT_EXTENSION)) {
> +        s->features |= EXTIOI_VIRT_HAS_FEATURES;
> +    }
> +
> +    cd.type = KVM_DEV_TYPE_LOONGARCH_EXTIOI;
> +    ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_DEVICE, &cd);
> +    if (ret < 0) {
> +        error_setg_errno(errp, errno,
> +                         "Creating the KVM extioi device failed");
> +        return;
> +    }
> +    extioi_class->is_created = true;
> +    extioi_class->dev_fd = cd.fd;
> +
> +    ret = kvm_device_access(cd.fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL,
> +                            KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU,
> +                            &s->num_cpu, true, NULL);
> +    if (ret < 0) {
> +        error_setg_errno(errp, errno,
> +                         "KVM EXTIOI: failed to set the num-cpu of EXTIOI");
> +        exit(1);
> +    }
> +
> +    ret = kvm_device_access(cd.fd, KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL,
> +                            KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE,
> +                            &s->features, true, NULL);
> +    if (ret < 0) {
> +        error_setg_errno(errp, errno,
> +                         "KVM EXTIOI: failed to set the feature of EXTIOI");
> +        exit(1);
> +    }
> +
> +    fprintf(stdout, "Create LoongArch extioi irqchip in KVM done!\n");
> +
> +    kvm_async_interrupts_allowed = true;
> +    kvm_msi_via_irqfd_allowed = kvm_irqfds_enabled();
> +    if (kvm_has_gsi_routing()) {
> +        for (i = 0; i < 64; ++i) {
> +            kvm_irqchip_add_irq_route(kvm_state, i, 0, i);
> +        }
> +        kvm_gsi_routing_allowed = true;
> +    }
Does memory region need be created to extioi with irqchip_in_kernel mode?

> +}
> +
> +static const VMStateDescription vmstate_kvm_extioi_core = {
> +    .name = "kvm-extioi-single",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .pre_save = kvm_loongarch_extioi_pre_save,
> +    .post_load = kvm_loongarch_extioi_post_load,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT32_ARRAY(nodetype, KVMLoongArchExtIOI,
> +                             EXTIOI_IRQS_NODETYPE_COUNT / 2),
> +        VMSTATE_UINT32_ARRAY(bounce, KVMLoongArchExtIOI,
> +                             EXTIOI_IRQS_GROUP_COUNT),
> +        VMSTATE_UINT32_ARRAY(isr, KVMLoongArchExtIOI, EXTIOI_IRQS / 32),
> +        VMSTATE_UINT32_2DARRAY(coreisr, KVMLoongArchExtIOI, EXTIOI_CPUS,
> +                               EXTIOI_IRQS_GROUP_COUNT),
> +        VMSTATE_UINT32_ARRAY(enable, KVMLoongArchExtIOI, EXTIOI_IRQS / 32),
> +        VMSTATE_UINT32_ARRAY(ipmap, KVMLoongArchExtIOI,
> +                             EXTIOI_IRQS_IPMAP_SIZE / 4),
> +        VMSTATE_UINT32_ARRAY(coremap, KVMLoongArchExtIOI, EXTIOI_IRQS / 4),
> +        VMSTATE_UINT8_ARRAY(sw_coremap, KVMLoongArchExtIOI, EXTIOI_IRQS),
> +        VMSTATE_UINT32(features, KVMLoongArchExtIOI),
> +        VMSTATE_UINT32(status, KVMLoongArchExtIOI),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
It is duplicated with structure vmstate_loongarch_extioi in file
hw/intc/loongarch_extioi.c

> +
> +static Property extioi_properties[] = {
> +    DEFINE_PROP_UINT32("num-cpu", KVMLoongArchExtIOI, num_cpu, 1),
> +    DEFINE_PROP_BIT("has-virtualization-extension", KVMLoongArchExtIOI,
> +                    features, EXTIOI_HAS_VIRT_EXTENSION, 0),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
Ditto, it is duplicated.

> +
> +static void kvm_loongarch_extioi_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +    KVMLoongArchExtIOIClass *extioi_class = KVM_LOONGARCH_EXTIOI_CLASS(oc);
> +
> +    extioi_class->parent_realize = dc->realize;
> +    dc->realize = kvm_loongarch_extioi_realize;
> +    extioi_class->is_created = false;
> +    device_class_set_props(dc, extioi_properties);
> +    dc->vmsd = &vmstate_kvm_extioi_core;
Do we need reset interface for irqchip_in_kernel mode?

Regards
Bibo Mao

> +}
> +
> +static const TypeInfo kvm_loongarch_extioi_info = {
> +    .name = TYPE_KVM_LOONGARCH_EXTIOI,
> +    .parent = TYPE_SYS_BUS_DEVICE,
> +    .instance_size = sizeof(KVMLoongArchExtIOI),
> +    .class_size = sizeof(KVMLoongArchExtIOIClass),
> +    .class_init = kvm_loongarch_extioi_class_init,
> +};
> +
> +static void kvm_loongarch_extioi_register_types(void)
> +{
> +    type_register_static(&kvm_loongarch_extioi_info);
> +}
> +
> +type_init(kvm_loongarch_extioi_register_types)
> diff --git a/hw/intc/meson.build b/hw/intc/meson.build
> index f55eb1b80b..85174d1af1 100644
> --- a/hw/intc/meson.build
> +++ b/hw/intc/meson.build
> @@ -76,3 +76,4 @@ specific_ss.add(when: 'CONFIG_LOONGARCH_IPI_KVM', if_true: files('loongarch_ipi_
>   specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC', if_true: files('loongarch_pch_pic.c'))
>   specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_MSI', if_true: files('loongarch_pch_msi.c'))
>   specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI', if_true: files('loongarch_extioi.c'))
> +specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI_KVM', if_true: files('loongarch_extioi_kvm.c'))
> diff --git a/hw/loongarch/Kconfig b/hw/loongarch/Kconfig
> index f8fcac3e7b..99a523171f 100644
> --- a/hw/loongarch/Kconfig
> +++ b/hw/loongarch/Kconfig
> @@ -17,6 +17,7 @@ config LOONGARCH_VIRT
>       select LOONGARCH_PCH_MSI
>       select LOONGARCH_EXTIOI
>       select LOONGARCH_IPI_KVM if KVM
> +    select LOONGARCH_EXTIOI_KVM if KVM
>       select LS7A_RTC
>       select SMBIOS
>       select ACPI_PCI
> diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
> index 3b28e8e671..8ca7c09016 100644
> --- a/hw/loongarch/virt.c
> +++ b/hw/loongarch/virt.c
> @@ -828,28 +828,37 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
>       }
>   
>       /* Create EXTIOI device */
> -    extioi = qdev_new(TYPE_LOONGARCH_EXTIOI);
> -    qdev_prop_set_uint32(extioi, "num-cpu", ms->smp.cpus);
> -    if (virt_is_veiointc_enabled(lvms)) {
> -        qdev_prop_set_bit(extioi, "has-virtualization-extension", true);
> -    }
> -    sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
> -    memory_region_add_subregion(&lvms->system_iocsr, APIC_BASE,
> -                    sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 0));
> -    if (virt_is_veiointc_enabled(lvms)) {
> -        memory_region_add_subregion(&lvms->system_iocsr, EXTIOI_VIRT_BASE,
> -                    sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 1));
> -    }
> +    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
> +        extioi = qdev_new(TYPE_KVM_LOONGARCH_EXTIOI);
> +        qdev_prop_set_uint32(extioi, "num-cpu", ms->smp.cpus);
> +        if (virt_is_veiointc_enabled(lvms)) {
> +            qdev_prop_set_bit(extioi, "has-virtualization-extension", true);
> +        }
> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
> +    } else {
> +        extioi = qdev_new(TYPE_LOONGARCH_EXTIOI);
> +        qdev_prop_set_uint32(extioi, "num-cpu", ms->smp.cpus);
> +        if (virt_is_veiointc_enabled(lvms)) {
> +            qdev_prop_set_bit(extioi, "has-virtualization-extension", true);
> +        }
> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(extioi), &error_fatal);
> +        memory_region_add_subregion(&lvms->system_iocsr, APIC_BASE,
> +                       sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 0));
> +        if (virt_is_veiointc_enabled(lvms)) {
> +            memory_region_add_subregion(&lvms->system_iocsr, EXTIOI_VIRT_BASE,
> +                        sysbus_mmio_get_region(SYS_BUS_DEVICE(extioi), 1));
> +        }
>   
> -    /*
> -     * connect ext irq to the cpu irq
> -     * cpu_pin[9:2] <= intc_pin[7:0]
> -     */
> -    for (cpu = 0; cpu < ms->smp.cpus; cpu++) {
> -        cpudev = DEVICE(qemu_get_cpu(cpu));
> -        for (pin = 0; pin < LS3A_INTC_IP; pin++) {
> -            qdev_connect_gpio_out(extioi, (cpu * 8 + pin),
> -                                  qdev_get_gpio_in(cpudev, pin + 2));
> +        /*
> +         * connect ext irq to the cpu irq
> +         * cpu_pin[9:2] <= intc_pin[7:0]
> +         */
> +        for (cpu = 0; cpu < ms->smp.cpus; cpu++) {
> +            cpudev = DEVICE(qemu_get_cpu(cpu));
> +            for (pin = 0; pin < LS3A_INTC_IP; pin++) {
> +                qdev_connect_gpio_out(extioi, (cpu * 8 + pin),
> +                                      qdev_get_gpio_in(cpudev, pin + 2));
> +            }
>           }
>       }
>   
> 


