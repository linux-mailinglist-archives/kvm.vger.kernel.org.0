Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34A2D3649
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgLHWay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbgLHWay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:30:54 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57C6C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:30:13 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i18so166956ioa.1
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29eBtDtyvwAuueSeF0oAu/txUr+9Ao/9LQHUlVU+2fc=;
        b=TlDD6aUalTYuTfenNQAJ3zERjK6Q4H8256n1j7bQnm2m971BN4p1XB8JDCwAWfJBf+
         2ejwqZ+KDc0ShxbVivY+Yt1aOz2GBbGNfiE69BdzG/ZGu8C1zL3XpzxhERfeqCuoSXe3
         c3cvYwq9Y6Q6eoLLvyYl4zxrsf9yXyqItjWUkqeYN2UPHukd45hxYRLw1IY6PTEz0/x3
         qshEjy0GXYWL1L553lcudUwAIMbDL8aU/Sr+MyHeirorCDuR1Qga4GCYKs7V6u8EFtZM
         If9Bt5Yq/P7dLFox6eXHEAEMco6zV/K3JO0W4aFKRyrkuo8YwQQVyskYq1sWdymu//EI
         PbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29eBtDtyvwAuueSeF0oAu/txUr+9Ao/9LQHUlVU+2fc=;
        b=XezDJZKDkrhOATINFfPQEtUE9jyUZFFTmHH8tjmVJlaKjPI0Klj4FADGJnnUPC+byX
         NcLa+GLgHa6D49KYO3Zx4NpUyLwDhhMAYcLAaW76wnx1tBxwbXj1A+q6mTDp6+MNXJix
         KZUDlbcWMWMITmKUi1cC1A8/+W0np4YhTC6CNCSS/4H3MQRhglCNoqShP8x1VZdY+9Fu
         qYxdav1i0J/4S98HymOPIuzIjLevZFM1NdpGpWffmIDrwfRRi/Vt6MJOMPHqfEOeATRN
         leQOZlBbF5s9rojM6w8uB1d2jHyW4kHAfNfc+b1hsBYIWE+I6ZMCWyYRmpnKJgbk8R/h
         zYFw==
X-Gm-Message-State: AOAM531vvcQHWm2++mUegCiuKNnAeZH1aT/UNde3+vylbjELl/b/Wmxd
        YnV6+VmQsQDVcpDJ3HPMPjk5e6ydvxrSLiBWofk=
X-Google-Smtp-Source: ABdhPJydZr404HaRvsRmgbtUATpJcCUZ8/SGlgfkBg22Seph0XiRiwRnnc4GJRJOJCjBUjk7r9govf33CuCi98jG7+8=
X-Received: by 2002:a02:6c09:: with SMTP id w9mr28541514jab.135.1607466613268;
 Tue, 08 Dec 2020 14:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20201203124703.168-1-jiangyifei@huawei.com> <20201203124703.168-8-jiangyifei@huawei.com>
In-Reply-To: <20201203124703.168-8-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 8 Dec 2020 14:29:47 -0800
Message-ID: <CAKmqyKMXmCPyMmo_OHdeVZCjN1k_Lv9n_FVFe9pvbnoHhVSL1g@mail.gmail.com>
Subject: Re: [PATCH RFC v4 07/15] hw/riscv: PLIC update external interrupt by
 KVM when kvm enabled
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 3, 2020 at 4:47 AM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Only support supervisor external interrupt currently.
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  hw/intc/sifive_plic.c    | 31 ++++++++++++++++++++++---------
>  target/riscv/kvm.c       | 19 +++++++++++++++++++
>  target/riscv/kvm_riscv.h |  1 +
>  3 files changed, 42 insertions(+), 9 deletions(-)
>
> diff --git a/hw/intc/sifive_plic.c b/hw/intc/sifive_plic.c
> index 97a1a27a9a..a419ca3a3c 100644
> --- a/hw/intc/sifive_plic.c
> +++ b/hw/intc/sifive_plic.c
> @@ -31,6 +31,8 @@
>  #include "target/riscv/cpu.h"
>  #include "sysemu/sysemu.h"
>  #include "migration/vmstate.h"
> +#include "sysemu/kvm.h"
> +#include "kvm_riscv.h"
>
>  #define RISCV_DEBUG_PLIC 0
>
> @@ -147,15 +149,26 @@ static void sifive_plic_update(SiFivePLICState *plic)
>              continue;
>          }
>          int level = sifive_plic_irqs_pending(plic, addrid);
> -        switch (mode) {
> -        case PLICMode_M:
> -            riscv_cpu_update_mip(RISCV_CPU(cpu), MIP_MEIP, BOOL_TO_MASK(level));
> -            break;
> -        case PLICMode_S:
> -            riscv_cpu_update_mip(RISCV_CPU(cpu), MIP_SEIP, BOOL_TO_MASK(level));
> -            break;
> -        default:
> -            break;
> +        if (kvm_enabled()) {
> +            if (mode == PLICMode_M) {
> +                continue;
> +            }
> +#ifdef CONFIG_KVM
> +            kvm_riscv_set_irq(RISCV_CPU(cpu), IRQ_S_EXT, level);
> +#endif

What if kvm_enalbed() is true, but CONFIG_KVM isn't defined?

Alistair

> +        } else {
> +            switch (mode) {
> +            case PLICMode_M:
> +                riscv_cpu_update_mip(RISCV_CPU(cpu),
> +                                     MIP_MEIP, BOOL_TO_MASK(level));
> +                break;
> +            case PLICMode_S:
> +                riscv_cpu_update_mip(RISCV_CPU(cpu),
> +                                     MIP_SEIP, BOOL_TO_MASK(level));
> +                break;
> +            default:
> +                break;
> +            }
>          }
>      }
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 6250ca0c7d..b01ff0754c 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -454,3 +454,22 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
>      env->satp = 0;
>  }
>
> +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
> +{
> +    int ret;
> +    unsigned virq = level ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
> +
> +    if (irq != IRQ_S_EXT) {
> +        return;
> +    }
> +
> +    if (!kvm_enabled()) {
> +        return;
> +    }
> +
> +    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_INTERRUPT, &virq);
> +    if (ret < 0) {
> +        perror("Set irq failed");
> +        abort();
> +    }
> +}
> diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
> index f38c82bf59..ed281bdce0 100644
> --- a/target/riscv/kvm_riscv.h
> +++ b/target/riscv/kvm_riscv.h
> @@ -20,5 +20,6 @@
>  #define QEMU_KVM_RISCV_H
>
>  void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
> +void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
>
>  #endif
> --
> 2.19.1
>
>
