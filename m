Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6008467153
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 06:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhLCFLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 00:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhLCFLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 00:11:19 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2BCC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 21:07:55 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so3968566wme.0
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 21:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1HzcrWAvGmTUX+Hm36O7mgiWvuIVCo+PL1FfOvYl0mA=;
        b=EwnvRrBzkJNKw/xZ/2L4eEYBkffrQKav8TNXTRoBBzxrWX1sMuNJmhgnikb2XWF6jD
         JugFWug/S/3qez2LN2+VlWDeP39awr9ioprv/ki40m4JZZm8OlqUbigSedR7VlNKOoJp
         kkw4iVLGs/OIEMCID6r1hmEcxRY9X6sppkjpU71CKpe7+3xBmG3stD2siN/ASd+vdC5h
         hKRBoEMm7UpvdzKGY4Da/XIQLqB+bzZGVu4lUIPGNz8rjCGT5+XcpLDyOJangr67LddX
         KfYKCWHC/aiqI2G87T6rbG8Gpx75BUcAvpqNSbjybDl2+DGaXxCcDNmwyn+WGy47FQHO
         C1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1HzcrWAvGmTUX+Hm36O7mgiWvuIVCo+PL1FfOvYl0mA=;
        b=s2EMo4sP/fN/Nxu+Na7zkmHdUkfXnY7GZnyF/QAGn6bXfZskPkOVeuUQtlNZL3+By1
         WdKSLHf6q7Iw1gAuuCX7iGE8EpcFE9OVOU7BFFsMuycxYHLswvR95dodwURUrjH3L3+y
         uyKl1LWVGJjoKdIaUZDrtpkGUhWOejrLaSqi8AaKeHnbrCsMnBmuPj9GUctTuAGMQUg6
         3w6eVS1CIa/pUfanJTt9/FYQOn0RZKXEwLRjwElesIM4OPlt+bhymx04/EkjQsXR2fig
         lbYDv6JV+aehOUNtQTLvlatx/xIi2vk0RAUZSSufDTxutcutTkXuKijYhAXqt1p2wQXk
         2zRg==
X-Gm-Message-State: AOAM532LIYsZi+RsQXhWX4chuEib8A57tuTnR5NRc4ihy68RYSMCkOu2
        rfDumHoyGEVNBlLdnRy4uZ9ZesV4g4Uc1y4GE/GNLQ==
X-Google-Smtp-Source: ABdhPJx/MYygLA1gO5zaf8vUfV+T1NqnKCxZSNk7TN7ZEb36ELOsMqUqfuDw+gBoZyYd5WzHTO4AAjO+RzWZRydTGTg=
X-Received: by 2002:a7b:c256:: with SMTP id b22mr12040192wmj.176.1638508073956;
 Thu, 02 Dec 2021 21:07:53 -0800 (PST)
MIME-Version: 1.0
References: <20211120074644.729-1-jiangyifei@huawei.com> <20211120074644.729-2-jiangyifei@huawei.com>
In-Reply-To: <20211120074644.729-2-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 3 Dec 2021 10:37:42 +0530
Message-ID: <CAAhSdy3kHbFX7bBCOn-m9BNtc_iHc-E+uE-GrPBWRj81DtAShQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/12] update-linux-headers: Add asm-riscv/kvm.h
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
> Add asm-riscv/kvm.h for RISC-V KVM, and update linux/kvm.h
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>

Looks good to me.

Reviewed-by: Anup Patel <anup.patel@wdc.com>

Regards,
Anup

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
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
