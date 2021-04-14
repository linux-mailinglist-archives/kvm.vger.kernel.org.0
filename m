Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE66035FDFE
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 00:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhDNWq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 18:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbhDNWq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 18:46:57 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3D5C061574
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:46:34 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id h141so13903658iof.2
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 15:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tD31o03cwWU2/UEkF/mBgAJtCepUfts3vL4bqT0X5lA=;
        b=uKdPZ/IThFmw7R+mG1RV1UVUXEvH4bzxByzfuoOy1bnO4JZztN49MKhEjF41UuAXIw
         aDJekHldA3vXOYgav6uR6diW8o8G3yZAHNH+Dq/hbkwVwvMaihJQSM5fICBSlCfQ5Hz9
         oHAU0Bfw/WvZJsYf/oqCRoyuLgh061BnM9tzE/AYPEvvX/5tAvSJY2FNkBz4kxFt017X
         d+lQgt1l1WQT+MnaW1UI8Sb1cJFYYlO/cPIoA/fW2YzL8aFhynJruicIcfnIFWpiHaeE
         YcYFh/dHuHNqQ09EsAtgr9vtQpLdroJcQVuzBYaaknfgt9U4y4is6iTLPpibSd5tAwZx
         8ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tD31o03cwWU2/UEkF/mBgAJtCepUfts3vL4bqT0X5lA=;
        b=AwtoknWql23oArHYs3UjeUWwLKkDxeqdX0jB7TaubANJCV+A4/ZG89gBwcEpT7iKvq
         TTnCDXkU08GOZjARSj97q+/UkT0ZaES3z2HeNqmPLwu5ypmC9b06VyyI1X9Trrbr1V4V
         joO6mqOth/uRbCRg/mA1JNtKbFBMgRChjf0DRbfVLM7qB+3Z5jvJDk7Go4EssaFeFVRe
         PxZKSG7MhAskR6uNVBkaRA8LMQvEGBv+HsruFvLQVNgbNEx76RyvviSpxepm9p1vbx5S
         0k0vijD5+4A4MESNWcs4zOHwgiUbnkllVSnoFQnMo3sUe7fm02dI87fAaGLF56eg93zd
         iLrA==
X-Gm-Message-State: AOAM530SvIw5foezGUZT/6cFrUQEWTJVOME3YewdnQVGGktZ6kPeruFt
        sMrgwhmS7x+Nd//jUyE3xr3Qc8GmxvPLvtQPVPJtQogymg9dB5n0
X-Google-Smtp-Source: ABdhPJyPkwX8w60HMCIVLkOx1pGysb2sABms6XxME3eWDjxdh8gBwAa0StYXVahp2/0GWlMHQ5JKweUj7CBbzyVoqd4=
X-Received: by 2002:a6b:7808:: with SMTP id j8mr302634iom.118.1618440393777;
 Wed, 14 Apr 2021 15:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210412065246.1853-1-jiangyifei@huawei.com> <20210412065246.1853-6-jiangyifei@huawei.com>
In-Reply-To: <20210412065246.1853-6-jiangyifei@huawei.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Thu, 15 Apr 2021 08:46:07 +1000
Message-ID: <CAKmqyKMgh0uTSoUrJW8O73i37rpwFoz7s1QZNgNf+8HKBfXRnA@mail.gmail.com>
Subject: Re: [PATCH RFC v5 05/12] target/riscv: Implement kvm_arch_put_registers
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Bin Meng <bin.meng@windriver.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        fanliang@huawei.com, "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 4:56 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Put GPR CSR and FP registers to kvm by KVM_SET_ONE_REG ioctl
>
> Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
> Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
> ---
>  target/riscv/kvm.c | 142 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 141 insertions(+), 1 deletion(-)
>
> diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
> index 63485d7b65..9d1441952a 100644
> --- a/target/riscv/kvm.c
> +++ b/target/riscv/kvm.c
> @@ -85,6 +85,31 @@ static int kvm_riscv_get_regs_core(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_core(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    target_ulong reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    reg = env->pc;
> +    ret = kvm_set_one_reg(cs, RISCV_CORE_REG(env, regs.pc), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    for (i = 1; i < 32; i++) {
> +        __u64 id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);

Can you use uint64_t for the entire series instead?

> +        reg = env->gpr[i];
> +        ret = kvm_set_one_reg(cs, id, &reg);
> +        if (ret) {
> +            return ret;
> +        }
> +    }
> +
> +    return ret;
> +}
> +
>  static int kvm_riscv_get_regs_csr(CPUState *cs)
>  {
>      int ret = 0;
> @@ -148,6 +173,70 @@ static int kvm_riscv_get_regs_csr(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_csr(CPUState *cs)
> +{
> +    int ret = 0;
> +    target_ulong reg;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    reg = env->mstatus;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sstatus), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->mie;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sie), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->stvec;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, stvec), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->sscratch;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sscratch), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->sepc;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sepc), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->scause;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, scause), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->sbadaddr;

This will change soon-ish as my next PR converts this to stval.

> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, stval), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->mip;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, sip), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    reg = env->satp;
> +    ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, satp), &reg);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    return ret;
> +}
> +
> +

Double line here.

Otherwise:

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

>  static int kvm_riscv_get_regs_fp(CPUState *cs)
>  {
>      int ret = 0;
> @@ -181,6 +270,40 @@ static int kvm_riscv_get_regs_fp(CPUState *cs)
>      return ret;
>  }
>
> +static int kvm_riscv_put_regs_fp(CPUState *cs)
> +{
> +    int ret = 0;
> +    int i;
> +    CPURISCVState *env = &RISCV_CPU(cs)->env;
> +
> +    if (riscv_has_ext(env, RVD)) {
> +        uint64_t reg;
> +        for (i = 0; i < 32; i++) {
> +            reg = env->fpr[i];
> +            ret = kvm_set_one_reg(cs, RISCV_FP_D_REG(env, i), &reg);
> +            if (ret) {
> +                return ret;
> +            }
> +        }
> +        return ret;
> +    }
> +
> +    if (riscv_has_ext(env, RVF)) {
> +        uint32_t reg;
> +        for (i = 0; i < 32; i++) {
> +            reg = env->fpr[i];
> +            ret = kvm_set_one_reg(cs, RISCV_FP_F_REG(env, i), &reg);
> +            if (ret) {
> +                return ret;
> +            }
> +        }
> +        return ret;
> +    }
> +
> +    return ret;
> +}
> +
> +
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
>  };
> @@ -209,7 +332,24 @@ int kvm_arch_get_registers(CPUState *cs)
>
>  int kvm_arch_put_registers(CPUState *cs, int level)
>  {
> -    return 0;
> +    int ret = 0;
> +
> +    ret = kvm_riscv_put_regs_core(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = kvm_riscv_put_regs_csr(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    ret = kvm_riscv_put_regs_fp(cs);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    return ret;
>  }
>
>  int kvm_arch_release_virq_post(int virq)
> --
> 2.19.1
>
>
