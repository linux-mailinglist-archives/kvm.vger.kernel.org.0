Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FFF459C32
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 07:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhKWGQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 01:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbhKWGQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 01:16:48 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB02C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 22:13:40 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id s14so20577797ilv.10
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 22:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ICvJr/Ty24DYgDYk0CxUnaAyHgf9SddVPyUjiGsDf6Q=;
        b=Ns4Fcq92C6RuV+K9c00//GLTY1wuqwR0vERCKSzTcWOup5+Ljt11ddPlD3Z0B/EXna
         oONIuEKRxQlJ+GJ8yhwgrtxv7nC7+zJPf72ho0QusAGDddaKBUxgREKHSQQ3O9PvVWN3
         H2b7G8aNOm+3Z3cXkiH2YxZJBr37EoEzcAScAJwx55RuNyPCH5Sv8I0k6T4x4xNUhoqq
         d2KdLQzudah/XOmxMF2sQzkERbiz6ilDer58NCxgcsbKZxh7kylQeiG/fqhEIPsAZUuJ
         fpCil4m4cOoCIkLBzKE9k+YSe35AL/mhkbSuOkKiw42Exig9FJ1hIwgTb+qBvNavh1Ky
         2aIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ICvJr/Ty24DYgDYk0CxUnaAyHgf9SddVPyUjiGsDf6Q=;
        b=MozHKuroGNBLYz5jB3qUDbeSzMiNrQ8P6wggjtsKTKE+0iCaTEFNA7TvYGopk1Qk7X
         8X9i9Eiuc/vjWXyD9AK9hMDCP7tjP73wFXUCLhQuw7h1KXzMtTxrrWk6umRwQxf+c7n5
         +kTmSxdGbLQ6J9KMB0H1pbj7DBNuuT6idj05ebVNHiINC2VQLsJIsM0J18BjZ7r95qvK
         WZ2O8MdbHKJbRlZEhVCfoUK8Ri7lgAYYYsB+tfS8NUubGZxs79fN9ppVeScawRChnQAj
         jt0VBXLYzK6yJQBJEao/Kh8zkFfqjtcddlZulWbXkEgTyRxzWtbPkdqtL1GaQGA8HtKU
         Q/CQ==
X-Gm-Message-State: AOAM532jgykuHeq8PK36YlnSTIszL8iPqudwrxQPoam5OPepoAoXYR5e
        IQC+AN5TYsDVS6Epab0oa+6Ea7PZtL3b+dTWHjM=
X-Google-Smtp-Source: ABdhPJyDVDZbXrGw2pXKWm5k6R+WYP/06EvwS9KjZQ1EudndPMOIuMJeNBYRO9wug85FUzduE3Au6NyocyP+1WNs6x0=
X-Received: by 2002:a05:6e02:1e02:: with SMTP id g2mr3337001ila.290.1637648020123;
 Mon, 22 Nov 2021 22:13:40 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-2-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-2-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 23 Nov 2021 16:13:13 +1000
Message-ID: <CAKmqyKNXcJ_3Fkzc+WDzUSQ2tXp4H-vs4wi6NiBMP+o42qpo8A@mail.gmail.com>
Subject: Re: [PATCH v1 01/12] update-linux-headers: Add asm-riscv/kvm.h
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Bin Meng <bin.meng@windriver.com>,
        Mingwang Li <limingwang@huawei.com>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Anup Patel <anup.patel@wdc.com>, wanbo13@huawei.com,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, wanghaibin.wang@huawei.com,
        Palmer Dabbelt <palmer@dabbelt.com>, fanliang@huawei.com,
        "Wubin (H)" <wu.wubin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 5:51 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Add asm-riscv/kvm.h for RISC-V KVM, and update linux/kvm.h
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Acked-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  linux-headers/asm-riscv/kvm.h | 128 ++++++++++++++++++++++++++++++++++
>  linux-headers/linux/kvm.h     |   8 +++
>  2 files changed, 136 insertions(+)
>  create mode 100644 linux-headers/asm-riscv/kvm.h
>
> diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
> new file mode 100644
> index 0000000000..f808ad1ce5
> --- /dev/null
> +++ b/linux-headers/asm-riscv/kvm.h
> @@ -0,0 +1,128 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
> + *
> + * Authors:
> + *     Anup Patel <anup.patel@wdc.com>
> + */
> +
> +#ifndef __LINUX_KVM_RISCV_H
> +#define __LINUX_KVM_RISCV_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/types.h>
> +#include <asm/ptrace.h>
> +
> +#define __KVM_HAVE_READONLY_MEM
> +
> +#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> +
> +#define KVM_INTERRUPT_SET      -1U
> +#define KVM_INTERRUPT_UNSET    -2U
> +
> +/* for KVM_GET_REGS and KVM_SET_REGS */
> +struct kvm_regs {
> +};
> +
> +/* for KVM_GET_FPU and KVM_SET_FPU */
> +struct kvm_fpu {
> +};
> +
> +/* KVM Debug exit structure */
> +struct kvm_debug_exit_arch {
> +};
> +
> +/* for KVM_SET_GUEST_DEBUG */
> +struct kvm_guest_debug_arch {
> +};
> +
> +/* definition of registers in kvm_run */
> +struct kvm_sync_regs {
> +};
> +
> +/* for KVM_GET_SREGS and KVM_SET_SREGS */
> +struct kvm_sregs {
> +};
> +
> +/* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_config {
> +       unsigned long isa;
> +};
> +
> +/* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_core {
> +       struct user_regs_struct regs;
> +       unsigned long mode;
> +};
> +
> +/* Possible privilege modes for kvm_riscv_core */
> +#define KVM_RISCV_MODE_S       1
> +#define KVM_RISCV_MODE_U       0
> +
> +/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_csr {
> +       unsigned long sstatus;
> +       unsigned long sie;
> +       unsigned long stvec;
> +       unsigned long sscratch;
> +       unsigned long sepc;
> +       unsigned long scause;
> +       unsigned long stval;
> +       unsigned long sip;
> +       unsigned long satp;
> +       unsigned long scounteren;
> +};
> +
> +/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> +struct kvm_riscv_timer {
> +       __u64 frequency;
> +       __u64 time;
> +       __u64 compare;
> +       __u64 state;
> +};
> +
> +/* Possible states for kvm_riscv_timer */
> +#define KVM_RISCV_TIMER_STATE_OFF      0
> +#define KVM_RISCV_TIMER_STATE_ON       1
> +
> +#define KVM_REG_SIZE(id)               \
> +       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> +
> +/* If you need to interpret the index values, here is the key: */
> +#define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
> +#define KVM_REG_RISCV_TYPE_SHIFT       24
> +
> +/* Config registers are mapped as type 1 */
> +#define KVM_REG_RISCV_CONFIG           (0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CONFIG_REG(name) \
> +       (offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
> +
> +/* Core registers are mapped as type 2 */
> +#define KVM_REG_RISCV_CORE             (0x02 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CORE_REG(name)   \
> +               (offsetof(struct kvm_riscv_core, name) / sizeof(unsigned long))
> +
> +/* Control and status registers are mapped as type 3 */
> +#define KVM_REG_RISCV_CSR              (0x03 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_CSR_REG(name)    \
> +               (offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
> +
> +/* Timer registers are mapped as type 4 */
> +#define KVM_REG_RISCV_TIMER            (0x04 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_TIMER_REG(name)  \
> +               (offsetof(struct kvm_riscv_timer, name) / sizeof(__u64))
> +
> +/* F extension registers are mapped as type 5 */
> +#define KVM_REG_RISCV_FP_F             (0x05 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_FP_F_REG(name)   \
> +               (offsetof(struct __riscv_f_ext_state, name) / sizeof(__u32))
> +
> +/* D extension registers are mapped as type 6 */
> +#define KVM_REG_RISCV_FP_D             (0x06 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_FP_D_REG(name)   \
> +               (offsetof(struct __riscv_d_ext_state, name) / sizeof(__u64))
> +
> +#endif
> +
> +#endif /* __LINUX_KVM_RISCV_H */
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index bcaf66cc4d..5e290c3c3e 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -269,6 +269,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_AP_RESET_HOLD    32
>  #define KVM_EXIT_X86_BUS_LOCK     33
>  #define KVM_EXIT_XEN              34
> +#define KVM_EXIT_RISCV_SBI        35
>
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -469,6 +470,13 @@ struct kvm_run {
>                 } msr;
>                 /* KVM_EXIT_XEN */
>                 struct kvm_xen_exit xen;
> +               /* KVM_EXIT_RISCV_SBI */
> +               struct {
> +                       unsigned long extension_id;
> +                       unsigned long function_id;
> +                       unsigned long args[6];
> +                       unsigned long ret[2];
> +               } riscv_sbi;
>                 /* Fix the size of the union. */
>                 char padding[256];
>         };
> --
> 2.19.1
>
>
