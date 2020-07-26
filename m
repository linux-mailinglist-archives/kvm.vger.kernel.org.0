Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DAC22DF2C
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgGZMsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 08:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgGZMsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 08:48:52 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F7BC0619D2
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 05:48:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so12150291wml.3
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 05:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rCLczGQIxWKiTkxHU6NiarIhxc9Z+JmjQxED80qEJss=;
        b=gwsElXHX2E2bUDww3ab3IoZnn76R5AZW2fLMad++U/SfNz2BQysjn9tmQWLc68si09
         vjvfu12vgyKudVHKrUiZ5jfldqlKc8Wj28ZbK0upIQvgG5/tXeW3EpZimmGZGW2ExcKJ
         qP553zFfDrJdUvHw8f0LhdqsapqLZD7UtlzRre2tgNZMRe2O+1x8zy1B8/0hCRv1kHxv
         YPkUSzFVgMQNOnLyjSHr+G4o/H9zQ9UtallmpbnPciV2SfNw8hqZ5/VHB4SBaosZh/vD
         01OTENe/iN0DPo/jtmvNS4QD/YrdszGynX1Fb+bIQnmFxhzWGbsV1U1nzbekl4PX/7Qr
         NIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rCLczGQIxWKiTkxHU6NiarIhxc9Z+JmjQxED80qEJss=;
        b=lPADxVFvVmnxskBtIV3A8Xz2algEPkjMYmH2D6j706bdSaZWSbAnSTziv9Cb+7zeBE
         3uaE0yaPXckrsXhaGN7I6dRrr/6WvAtKE4Bz/NeMgMbIfqxqZL+UfkDPZeFb1bXVf3PJ
         uvwdC8GuN6mH8/hGvmAD0B8RZ8P3+XSSZrkJ5tggE33g+FgIQWbOeQF8qKKuXR36T6Ra
         dfR4uA7VuGDxtNyL+AmJSWg4WJhMyO3aRJ4wocmvPk7oQM0X7MNM4tXXsp4iA9m6v/GI
         olcAP7mdM9GNFBiItXw4CstOKoruUmknXJAwhMA7PdeB8iCNQwCbyBs/JCRpA/3vPI5/
         bAWw==
X-Gm-Message-State: AOAM532r3VEjBIt1VA2mL1cdtZEiUd6/HRCWpNNDZWGhhHFSISCzvZY4
        HdyTmw49IFehee3SZTVLdpogFI5OSOpLRcIvMwndCTE4N0I=
X-Google-Smtp-Source: ABdhPJwhqkhQturWmZRFMqSZv9GNE6rrK3X7LahzNQkb0Zo4Tkad6SpMIBWX4YYc/OAmqOhmFgHIsVezEkmX8Si7Pes=
X-Received: by 2002:a1c:6689:: with SMTP id a131mr5266820wmc.157.1595767730427;
 Sun, 26 Jul 2020 05:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200724085441.1514-1-jiangyifei@huawei.com> <20200724085441.1514-2-jiangyifei@huawei.com>
In-Reply-To: <20200724085441.1514-2-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 26 Jul 2020 18:18:38 +0530
Message-ID: <CAAhSdy08NEMR2jjJ-FVixyWMOpQ4+V-P9k2xuyO+Xu5OWKrmFQ@mail.gmail.com>
Subject: Re: [RFC 1/2] RISC-V: KVM: enable ioeventfd capability and compile
 for risc-v
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        wu.wubin@huawei.com,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>, limingwang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please change subject to:
"RISC-V: KVM: enable ioeventfd capability"

Also add 1-2 sentences of commit description.

On Fri, Jul 24, 2020 at 2:25 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> ---
>  arch/riscv/kvm/Kconfig  | 2 ++
>  arch/riscv/kvm/Makefile | 2 +-
>  arch/riscv/kvm/vm.c     | 1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 2356dc52ebb3..95d85d893ab6 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -4,6 +4,7 @@
>  #
>
>  source "virt/kvm/Kconfig"
> +source "drivers/vhost/Kconfig"
>
>  menuconfig VIRTUALIZATION
>         bool "Virtualization"
> @@ -26,6 +27,7 @@ config KVM
>         select KVM_MMIO
>         select HAVE_KVM_VCPU_ASYNC_IOCTL
>         select SRCU
> +       select HAVE_KVM_EVENTFD
>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index b56dc1650d2c..3ad46fe44900 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for RISC-V KVM support
>  #
>
> -common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
> +common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o eventfd.o)
>
>  ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
>
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 4f2498198cb5..473299e71f68 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -52,6 +52,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         int r;
>
>         switch (ext) {
> +       case KVM_CAP_IOEVENTFD:
>         case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_USER_MEMORY:
>         case KVM_CAP_SYNC_MMU:
> --
> 2.19.1
>
>

Regards,
Anup
