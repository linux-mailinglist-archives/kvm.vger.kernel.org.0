Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71D722DF68
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 14:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGZM7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 08:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGZM7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 08:59:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20A8C0619D2
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 05:59:09 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z18so8689351wrm.12
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 05:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJ0QTk1kAr2FXG3tNKxMDTj3E6xC0tBqD5CEm/p3JFE=;
        b=e3qylBuPPyd36kYi09rS61kEhLJtEb/XiQOym4M3xymiMBeoHEsRYf7Cl7PEyEpyzg
         c6RjEdgiKjPRk80f99amxldvIWn8kAn2HrIK+4WB97VzHtKsfAq4IidLgJqkLaPb8vf2
         lgOrGq2sfuOHdd2NQeeywpEG7BhiYWAOtFlnHV9PhGwA855BfYE19uhn8Cud4Mvvd23l
         pKb4vFdCWBWOzwXwFnKBv/Wod/PlT0wyvHouPqYCoQQpUfqTUYylmYyoq5AYUZC3dbBp
         LxEonSSWb6BKqUxWs+cLg65BjTqzXH6n5wq0JqZqrEzIBxAzVyPpSfVirsjtlJylWK0p
         256A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJ0QTk1kAr2FXG3tNKxMDTj3E6xC0tBqD5CEm/p3JFE=;
        b=sEYWqelPu42OfEcT0RJ9/XH9Fgsc7vZ6/ODcZMwDHXP8BH5un/hTsbOe5RCRzJx71b
         PdP2CfZYUbFJFE1aEIMF5+GAm2IfaEq0qgdhBo21uC73oBSRBF2fp5QTU2z22xgXNAIR
         HX2KNWzBQYdiYOxgKRsJMVPnzQwD8C1K/onFi5T0LTNlgxEituQMGXfSVwGRR5mI+WHF
         w2p47YTigZWgn4/egz8tYMNIEQGjGfYcMxD3K79aMqKJWOQdrY+4WFHWe1EEIueeWURW
         GoTp2JXmKh9HFmtEqQtx1WIYmaVigSrb0+d6mWSuylfPKRMEXCaigLG+i0x4UUmHNZ7M
         GuNQ==
X-Gm-Message-State: AOAM53227Vs2QFUbvWDqYXK/SXCra2mOBlnugibJNex4zHMIZeVeEuvE
        ux7P57tzDj9e/ZwhWk9wR2LzwIq1bZwiyPmWVe7nvg==
X-Google-Smtp-Source: ABdhPJwkwpK6Km+ushc9A1CmJalY7YDxkaZpWvaeV6P1vmcPyklRXsQahQs5E1vm5UD0ctxrGufZWxwQaQTBXHNbh18=
X-Received: by 2002:adf:f186:: with SMTP id h6mr16468220wro.144.1595768348627;
 Sun, 26 Jul 2020 05:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200724085441.1514-1-jiangyifei@huawei.com> <20200724085441.1514-3-jiangyifei@huawei.com>
In-Reply-To: <20200724085441.1514-3-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 26 Jul 2020 18:28:57 +0530
Message-ID: <CAAhSdy18+3ub9Lw+2v0WEujYkFJ2yU0x=GqZ+PQGe2DrWCR8Bg@mail.gmail.com>
Subject: Re: [RFC 2/2] RISC-V: KVM: read\write kernel mmio device support
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

Change subject to:
RISC-V: KVM: kernel mmio read/write support

Also add 1-2 sentences of commit description.

On Fri, Jul 24, 2020 at 2:25 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Mingwang Li <limingwang@huawei.com>
> ---
>  arch/riscv/kvm/vcpu_exit.c | 38 ++++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index e97ba96cb0ae..448f11179fa8 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -191,6 +191,8 @@ static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                         unsigned long fault_addr, unsigned long htinst)
>  {
> +       int ret;
> +       u8 data_buf[8];
>         unsigned long insn;
>         int shift = 0, len = 0;
>         struct kvm_cpu_trap utrap = { 0 };
> @@ -272,19 +274,32 @@ static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
>         vcpu->arch.mmio_decode.len = len;
>         vcpu->arch.mmio_decode.return_handled = 0;
>
> -       /* Exit to userspace for MMIO emulation */
> -       vcpu->stat.mmio_exit_user++;
> -       run->exit_reason = KVM_EXIT_MMIO;
> +       ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len,
> +                                                 data_buf);
> +
>         run->mmio.is_write = false;
>         run->mmio.phys_addr = fault_addr;
>         run->mmio.len = len;
>
> +       if (!ret) {
> +               /* We handled the access successfully in the kernel. */
> +               memcpy(run->mmio.data, data_buf, len);
> +               vcpu->stat.mmio_exit_kernel++;
> +               kvm_riscv_vcpu_mmio_return(vcpu, run);
> +               return 1;
> +       }
> +
> +       /* Exit to userspace for MMIO emulation */
> +       vcpu->stat.mmio_exit_user++;
> +       run->exit_reason = KVM_EXIT_MMIO;
> +
>         return 0;
>  }
>
>  static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                          unsigned long fault_addr, unsigned long htinst)
>  {
> +       int ret;
>         u8 data8;
>         u16 data16;
>         u32 data32;
> @@ -378,13 +393,24 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                 return -ENOTSUPP;
>         };
>
> -       /* Exit to userspace for MMIO emulation */
> -       vcpu->stat.mmio_exit_user++;
> -       run->exit_reason = KVM_EXIT_MMIO;
> +       ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, fault_addr, len,
> +                                                  run->mmio.data);
> +
>         run->mmio.is_write = true;
>         run->mmio.phys_addr = fault_addr;
>         run->mmio.len = len;
>
> +       if (!ret) {
> +               /* We handled the access successfully in the kernel. */
> +               vcpu->stat.mmio_exit_kernel++;
> +               kvm_riscv_vcpu_mmio_return(vcpu, run);
> +               return 1;
> +       }
> +
> +       /* Exit to userspace for MMIO emulation */
> +       vcpu->stat.mmio_exit_user++;
> +       run->exit_reason = KVM_EXIT_MMIO;
> +
>         return 0;
>  }
>
> --
> 2.19.1
>
>

Regards,
Anup
