Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE735483DD
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiFMKAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 06:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiFMJ77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 05:59:59 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9281CB24
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 02:59:58 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c21so6455173wrb.1
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 02:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UmfLVMrsn0WGwubEU9B512VvZRZn5oxu7wSDZVtbht0=;
        b=LhZfBXrvzYqI3m+WOUh4DDqPjfPfwZPsqmNNJVMNh7XYs9heKwO/IPxsk57tFUWucd
         Zv6BaDUdcvpVMuRseJV823A6bUqwBLM/ErvVhMli9qCYvcMv3EDVok6Hw5zR/Lk1A7f7
         YDYDeqVLMVaT975XLHb3o0dDdbgbhPnfyk5U5SilxzCkVewvWxgU9ZYIV0tjRrFHEPqp
         UaPGF5flFUtToEIyyo3cB7DP2DXyluPY7ZBscQ/IgI0Y1AdUjbs69JrN6nUxHnRrX0Ys
         uJRq/GzfjN64AWitEhKqIRYtl3Wg2+qaFXED+ezHW03GsDZILI4lTcp8foIuTWyYnlg/
         ZmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UmfLVMrsn0WGwubEU9B512VvZRZn5oxu7wSDZVtbht0=;
        b=BB9oEGuDv4mXj9jaqkacJU8u0gbf3ZzLT9g/iOCq/ejbTruoV+o4grIibApRP9iPtk
         sM56zl89rk0Thc8EBwa11Za5clO4GHQzuek1olle97YA1ydkWY3Z2TFyLgPaSwvZ47vB
         4OVx7NL6ysZ5gOqFNWFFNq7BLLICJyOWwC1kWXF3UBG7RamwYwCTjs0GfUY0hcjj9LVk
         9mN0Y4jcIejm7xBcQukN7+hTi3ug2LhvjGg0RrtFiQeu+HQ96MQIAoAojKQowjN/8mDB
         iYzrLYR5uTxL3jojNg70/I1MixcoI06F3fI7Gqlc1sXxo+ESmYHMFbkUOvlx/bHoA4G8
         guDQ==
X-Gm-Message-State: AOAM532zPshpxI9LTgqhQRrk3xEvBv80jwlxa/G2sI8zV+JiZOM2Gvxr
        e3yy6tVtXXxtZ/gW2jl5JMO/xMZo3qqfiIZhejx8Fw==
X-Google-Smtp-Source: ABdhPJzxNuCEvmYzaj5KbxDO78aB8w+JhFuCEdlruGFDryxRsTs1bXjV4eGZNPl3H7NY9NxC4va02GY5gR3R6YabY7U=
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr57053464wrz.690.1655114396705; Mon, 13
 Jun 2022 02:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220610050555.288251-1-apatel@ventanamicro.com>
 <20220610050555.288251-3-apatel@ventanamicro.com> <20220612153113.GA52224@liuzhao-OptiPlex-7080>
In-Reply-To: <20220612153113.GA52224@liuzhao-OptiPlex-7080>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 13 Jun 2022 15:29:13 +0530
Message-ID: <CAAhSdy2GXCujSkJgrWC==nTbeT7soY57K_DKP-vs57E=iN-YkQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] RISC-V: KVM: Add extensible system instruction
 emulation framework
To:     Liu Zhao <zhao1.liu@linux.intel.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 12, 2022 at 8:57 PM Liu Zhao <zhao1.liu@linux.intel.com> wrote:
>
> On Fri, Jun 10, 2022 at 10:35:54AM +0530, Anup Patel wrote:
> > Date: Fri, 10 Jun 2022 10:35:54 +0530
> > From: Anup Patel <apatel@ventanamicro.com>
> > Subject: [PATCH 2/3] RISC-V: KVM: Add extensible system instruction
> >  emulation framework
> > X-Mailer: git-send-email 2.34.1
> >
> > We will be emulating more system instructions in near future with
> > upcoming AIA, PMU, Nested and other virtualization features.
> >
> > To accommodate above, we add an extensible system instruction emulation
> > framework in vcpu_insn.c.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_insn.h |  9 +++
> >  arch/riscv/kvm/vcpu_insn.c             | 82 +++++++++++++++++++++++---
> >  2 files changed, 82 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_insn.h b/arch/riscv/include/asm/kvm_vcpu_insn.h
> > index 4e3ba4e84d0f..3351eb61a251 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_insn.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_insn.h
> > @@ -18,6 +18,15 @@ struct kvm_mmio_decode {
> >       int return_handled;
> >  };
> >
> > +/* Return values used by function emulating a particular instruction */
> > +enum kvm_insn_return {
> > +     KVM_INSN_EXIT_TO_USER_SPACE = 0,
> > +     KVM_INSN_CONTINUE_NEXT_SEPC,
> > +     KVM_INSN_CONTINUE_SAME_SEPC,
> > +     KVM_INSN_ILLEGAL_TRAP,
> > +     KVM_INSN_VIRTUAL_TRAP
> > +};
> > +
> >  void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
> >  int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                               struct kvm_cpu_trap *trap);
> > diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> > index be756879c2ee..75ca62a7fba5 100644
> > --- a/arch/riscv/kvm/vcpu_insn.c
> > +++ b/arch/riscv/kvm/vcpu_insn.c
> > @@ -118,8 +118,24 @@
> >                                (s32)(((insn) >> 7) & 0x1f))
> >  #define MASK_FUNCT3          0x7000
> >
> > -static int truly_illegal_insn(struct kvm_vcpu *vcpu,
> > -                           struct kvm_run *run,
> > +struct insn_func {
> > +     unsigned long mask;
> > +     unsigned long match;
> > +     /*
> > +      * Possible return values are as follows:
> > +      * 1) Returns < 0 for error case
> > +      * 2) Returns 0 for exit to user-space
> > +      * 3) Returns 1 to continue with next sepc
> > +      * 4) Returns 2 to continue with same sepc
> > +      * 5) Returns 3 to inject illegal instruction trap and continue
> > +      * 6) Returns 4 to inject virtual instruction trap and continue
> > +      *
> > +      * Use enum kvm_insn_return for return values
> > +      */
> > +     int (*func)(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn);
> > +};
> > +
> > +static int truly_illegal_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                             ulong insn)
> >  {
> >       struct kvm_cpu_trap utrap = { 0 };
> > @@ -128,6 +144,24 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu,
> >       utrap.sepc = vcpu->arch.guest_context.sepc;
> >       utrap.scause = EXC_INST_ILLEGAL;
> >       utrap.stval = insn;
> > +     utrap.htval = 0;
> > +     utrap.htinst = 0;
> > +     kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> > +
> > +     return 1;
> > +}
> > +
> > +static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +                           ulong insn)
> > +{
> > +     struct kvm_cpu_trap utrap = { 0 };
> > +
> > +     /* Redirect trap to Guest VCPU */
> > +     utrap.sepc = vcpu->arch.guest_context.sepc;
> > +     utrap.scause = EXC_VIRTUAL_INST_FAULT;
> > +     utrap.stval = insn;
> > +     utrap.htval = 0;
> > +     utrap.htinst = 0;
> >       kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> >
> >       return 1;
> > @@ -148,18 +182,48 @@ void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
> >       }
> >  }
> >
> > -static int system_opcode_insn(struct kvm_vcpu *vcpu,
> > -                           struct kvm_run *run,
> > +static int wfi_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
> > +{
> > +     vcpu->stat.wfi_exit_stat++;
> > +     kvm_riscv_vcpu_wfi(vcpu);
> > +     return KVM_INSN_CONTINUE_NEXT_SEPC;
> > +}
> > +
> > +static const struct insn_func system_opcode_funcs[] = {
> > +     {
> > +             .mask  = INSN_MASK_WFI,
> > +             .match = INSN_MATCH_WFI,
> > +             .func  = wfi_insn,
> > +     },
> > +};
> > +
> > +static int system_opcode_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                             ulong insn)
> >  {
> > -     if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
> > -             vcpu->stat.wfi_exit_stat++;
> > -             kvm_riscv_vcpu_wfi(vcpu);
> > +     int i, rc = KVM_INSN_ILLEGAL_TRAP;
> > +     const struct insn_func *ifn;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(system_opcode_funcs); i++) {
> > +             ifn = &system_opcode_funcs[i];
> > +             if ((insn & ifn->mask) == ifn->match) {
> > +                     rc = ifn->func(vcpu, run, insn);
> > +                     break;
> > +             }
> > +     }
> > +
> > +     switch (rc) {
> > +     case KVM_INSN_ILLEGAL_TRAP:
> > +             return truly_illegal_insn(vcpu, run, insn);
> > +     case KVM_INSN_VIRTUAL_TRAP:
> > +             return truly_virtual_insn(vcpu, run, insn);
> > +     case KVM_INSN_CONTINUE_NEXT_SEPC:
> >               vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> > -             return 1;
> > +             break;
>
> Hi Anup,
> What about adding KVM_INSN_CONTINUE_SAME_SEPC and KVM_INSN_EXIT_TO_USER_SPACE
> cases here and set rc to 1?

For KVM_INSN_CONTINUE_SAME_SEPC (and any rc >= 1) we should return 1
whereas for KVM_INSN_EXIT_TO_USER_SPACE we should return 0.

> This is the explicit indication that both cases are handled.

The KVM_INSN_EXIT_TO_USER_SPACE is always 0 whereas
KVM_INSN_CONTINUE_SAME_SEPC is always 1 so the statement
"return (rc <= 0) ? rc : 1;" handles both these cases.

Regards,
Anup

>
> > +     default:
> > +             break;
> >       }
> >
> > -     return truly_illegal_insn(vcpu, run, insn);
> > +     return (rc <= 0) ? rc : 1;
> >  }
> >
> >  /**
> > --
> > 2.34.1
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv
