Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBC8467154
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 06:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhLCFM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 00:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhLCFM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 00:12:28 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A924C06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 21:09:05 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so3806586wmi.1
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 21:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvpxU/zQgmVYk8jRqwwlAfgA2DGPBBA6ycytwfg8N1I=;
        b=yUaFY+XkamNidvrqtpCeifrVdN5izEHR53kkFATjIn8mX9uNlLYIkwoH1ukHrO/DFJ
         Nuzvr7x0gY0E6rUerCR5IOJUhKAkjGIOE+jYBChcegUho+mIPH4BQKzafxc2f6QE3w1q
         fYEX1lyCFc8V0PkJW4Fh5iloNMZ8qROSBnDydKI67QNL1TBGvYqx2uKubj7Fm2O+YsBH
         efpCcs0/NPGB/KmEehAAwLKHYub1m0PQ3EvWwXFqSkKtKpsyMf0az868t9IErCPjmNwa
         cIcnV/zHwsPI0ruxF+51c26pZTyFJnCUjyZPUlNeyyz3cTLrkzaJQzeWGuEoVN4Sds7V
         tCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvpxU/zQgmVYk8jRqwwlAfgA2DGPBBA6ycytwfg8N1I=;
        b=r/yBQFi6BrPgNEyh1RG+3mt844MZXJ9g66QrRXnWXkvwAB/7VJieZxzz2FyvLCI3tY
         KfCYEtb1gfY9NqNL2RDNC5I2wL6PV/Jiu301uRdpPUHChpKX/QgKNeNq3AeFZpgPziwQ
         y5n0ENO6C+g7cq4Em48b/VvC//K0WXJFWONAGW7lYdyqPbDRjBNRnn2dyuDn3v19GPE6
         39Q8Q0OblP5fh0lVoKN2XvM5JcYrZMykpPTXy0A5A4EzmxoKlT+NO54UYy4PBTICyYhq
         evdiJI/BnOiLX342NuNZ/dyAG1nY73NFe2zkxS31DNabB/jo6h5uNB1b8zzwJSxLeBVX
         K2HA==
X-Gm-Message-State: AOAM531gSJ0jdEat6co9mVvrZvyfgQeRWY8mRSW+q1DNORQ+G1EvFKxD
        Sxq7UzMPJFAYIpLc7r9j5TW/umjxRAGgIt/FqkrDXw==
X-Google-Smtp-Source: ABdhPJx0KrVLLCYNaSL9ehBnr/VTigADR+Z3z+3pOLuXixW2HUYdUfDlqoy+DAox+u3hvsnJ95XJ+Xys9loPA6x63Pg=
X-Received: by 2002:a7b:c194:: with SMTP id y20mr12506581wmi.61.1638508143606;
 Thu, 02 Dec 2021 21:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-3-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-3-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 10:38:51 +0530
Message-ID: <CAAhSdy27SRFxGU-vs-1SXZ8bw6-G+73XThHJkP66MB+zY4TrQg@mail.gmail.com>
Subject: Re: [PATCH v1 02/12] target/riscv: Add target/riscv/kvm.c to place
 the public kvm interface
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>,
        libvir-list@redhat.com, Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>, wanghaibin.wang@huawei.com,
        wanbo13@huawei.com, Mingwang Li <limingwang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 1:17 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add target/riscv/kvm.c to place kvm_arch_* function needed by
> kvm/kvm-all.c. Meanwhile, add kvm support in meson.build file.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

> ---
>  meson.build              |   2 +
>  target/riscv/kvm.c       | 133 +++++++++++++++++++++++++++++++++++++++
>  target/riscv/meson.build |   1 +
>  3 files changed, 136 insertions(+)
>  create mode 100644 target/riscv/kvm.c
>
> diff --git a/meson.build b/meson.build
> index 96de1a6ef9..ae35e76ea4 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -77,6 +77,8 @@ elif cpu in ['ppc', 'ppc64']
>    kvm_targets = ['ppc-softmmu', 'ppc64-softmmu']
>  elif cpu in ['mips', 'mips64']
>    kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
> +elif cpu in ['riscv']
> +  kvm_targets = ['riscv32-softmmu', 'riscv64-softmmu']
>  else
>    kvm_targets = []
>  endif
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> new file mode 100644
> index 0000000000..687dd4b621
> --- /dev/null
> +++ b/target/riscv/kvm.c
> @@ -0,0 +1,133 @@
> +/*
> + * RISC-V implementation of KVM hooks
> + *
> + * Copyright (c) 2020 Huawei Technologies Co., Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include <sys/ioctl.h>
> +
> +#include <linux/kvm.h>
> +
> +#include "qemu-common.h"
> +#include "qemu/timer.h"
> +#include "qemu/error-report.h"
> +#include "qemu/main-loop.h"
> +#include "sysemu/sysemu.h"
> +#include "sysemu/kvm.h"
> +#include "sysemu/kvm_int.h"
> +#include "cpu.h"
> +#include "trace.h"
> +#include "hw/pci/pci.h"
> +#include "exec/memattrs.h"
> +#include "exec/address-spaces.h"
> +#include "hw/boards.h"
> +#include "hw/irq.h"
> +#include "qemu/log.h"
> +#include "hw/loader.h"
> +
> +const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
> +    KVM_CAP_LAST_INFO
> +};
> +
> +int kvm_arch_get_registers(CPUState *cs)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_put_registers(CPUState *cs, int level)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_release_virq_post(int virq)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
> +                             uint64_t address, uint32_t data, PCIDevice *dev)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +    return 0;
> +}
> +
> +unsigned long kvm_arch_vcpu_id(CPUState *cpu)
> +{
> +    return cpu->cpu_index;
> +}
> +
> +void kvm_arch_init_irq_routing(KVMState *s)
> +{
> +}
> +
> +int kvm_arch_init_vcpu(CPUState *cs)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_msi_data_to_gsi(uint32_t data)
> +{
> +    abort();
> +}
> +
> +int kvm_arch_add_msi_route_post(struct kvm_irq_routing_entry *route,
> +                                int vector, PCIDevice *dev)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_init(MachineState *ms, KVMState *s)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_irqchip_create(KVMState *s)
> +{
> +    return 0;
> +}
> +
> +int kvm_arch_process_async_events(CPUState *cs)
> +{
> +    return 0;
> +}
> +
> +void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
> +{
> +}
> +
> +MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
> +{
> +    return MEMTXATTRS_UNSPECIFIED;
> +}
> +
> +bool kvm_arch_stop_on_emulation_error(CPUState *cs)
> +{
> +    return true;
> +}
> +
> +int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
> +{
> +    return 0;
> +}
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index d5e0bc93ea..2faf08a941 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -19,6 +19,7 @@ riscv_ss.add(files(
>    'bitmanip_helper.c',
>    'translate.c',
>  ))
> +riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
>
>  riscv_softmmu_ss = ss.source_set()
>  riscv_softmmu_ss.add(files(
> --
> 2.19.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
