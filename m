Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA90C680749
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 09:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbjA3ISr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 03:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjA3ISn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 03:18:43 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5597D4C0D
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 00:18:39 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-4b718cab0e4so149177467b3.9
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 00:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UUp/6YID92JFAcveT6p4E2dADeEO7Fk2qJDYnyhDUuM=;
        b=LCl/0LT+oiQFk2TDeIP0mhJLimuvr2KYhCX+kKriLEOd231afvJevzELvXaP6E152L
         7k5xWJjg51U/ggIHE8YzxrXzuCkljXtK66I8nSG30nX3Toml+cq/8M8vtA7EoI57rQAj
         GHZiSQOlEuLpXmrwY4e8UcaEcU8oajg8QsVBTcRj6aZbGLIePJximGxKu3WT/Cbi6woV
         2kDdLGZRJyK4nQOoxyWPv/r1L8l2ukp/c56raw3vbuecSYbQKhiHrbX5v8QNTM+g/pjr
         LjOjWM8vtrhZNMtu8wIE4jr/93U/wrb4rSqy0CYHvjxk2+7vAn1tIsw1vNx6ZOjBv9nY
         OY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUp/6YID92JFAcveT6p4E2dADeEO7Fk2qJDYnyhDUuM=;
        b=H7nqSfBt5D8mEBlk4Es+CWVAGCM8uuPEbGzrNSK2GFC7You8HmKTi4MeMOtW23yu1X
         OpaWXFTs6hwYQJvOzt/5j+aVE91fqQ29T1lrQ+uLzGzSU7EFD4XR+dMfz8y7sl9H9cO1
         gwvdea3PxD8bP9yEc6AyK3P/0Gtqcn9qe5eizdvEruSE6CpyU2VNNiF4CzSFZrSRpqF4
         XBpGT/0H4PXvlCMBeGrnPfBe+VI9mdHDj7FUQW13HYjWnxAx1ecVMkwJtQPfANnrBVUy
         hVmZ29mzzcbVfX5LKzZXBUdrRX7C40J4b+wUFCtnxeCXTBbSiZZQ5bbOMid5OFxThESf
         UBcA==
X-Gm-Message-State: AFqh2kqrGvM0Gzjg+hVshYpQdKDaENRJ8rOQ2UOEB1k8CzurPjSrYRzk
        hf9D8XoIZFfXoBqiDzp5EwpJRiJmoks/gV6cgjbv3w==
X-Google-Smtp-Source: AMrXdXuiEugqB5vsz67q2rlzfCL6FLkh6p+M/+KuuutF0CGZJOSsBFbARe7b0EMunhesbUho6cQRttFrf2ydGcl2NsU=
X-Received: by 2002:a81:7307:0:b0:464:4ea1:3baa with SMTP id
 o7-20020a817307000000b004644ea13baamr5078631ywc.302.1675066718489; Mon, 30
 Jan 2023 00:18:38 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-19-andy.chiu@sifive.com>
 <CAK9=C2UWJ1qDfyfsKiznfFTVDHbjJm89m_6ymM=jpvYs7-qNcQ@mail.gmail.com>
In-Reply-To: <CAK9=C2UWJ1qDfyfsKiznfFTVDHbjJm89m_6ymM=jpvYs7-qNcQ@mail.gmail.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 30 Jan 2023 16:18:27 +0800
Message-ID: <CABgGipUPwnu1p14sc6GT+Agh-zx=cbwHanTsTRweR1ErtsX0kA@mail.gmail.com>
Subject: Re: [PATCH -next v13 18/19] riscv: kvm: redirect illegal instruction
 traps to guests
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 7:28 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> On Wed, Jan 25, 2023 at 7:53 PM Andy Chiu <andy.chiu@sifive.com> wrote:
> >
> > Running below m-mode, an illegal instruction trap where m-mode could not
> > handle would be redirected back to s-mode. However, kvm running in hs-mode
> > terminates the vs-mode software when it receive such exception code.
> > Instead, it should redirect the trap back to vs-mode, and let vs-mode trap
> > handler decide the next step.
> >
> > Besides, hs-mode should run transparently to vs-mode. So terminating
> > guest OS breaks assumption for the kernel running in vs-mode.
> >
> > We use first-use trap to enable Vector for user space processes. This
> > means that the user process running in u- or vu- mode will take an
> > illegal instruction trap for the first time using V. Then the s- or vs-
> > mode kernel would allocate V for the process. Thus, we must redirect the
> > trap back to vs-mode in order to get the first-use trap working for guest
> > OSes here.
>
> In general, it is a good strategy to always redirect illegal instruction
> traps to VS-mode.
>
> >
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > ---
> >  arch/riscv/kvm/vcpu_exit.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> > index c9f741ab26f5..2a02cb750892 100644
> > --- a/arch/riscv/kvm/vcpu_exit.c
> > +++ b/arch/riscv/kvm/vcpu_exit.c
> > @@ -162,6 +162,16 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
> >         vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
> >  }
> >
> > +static int vcpu_trap_redirect_vs(struct kvm_vcpu *vcpu,
> > +                                struct kvm_cpu_trap *trap)
> > +{
> > +       /* set up trap handler and trap info when it gets back to vs */
> > +       kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> > +       /* return to s-mode by setting vcpu's SPP */
> > +       vcpu->arch.guest_context.sstatus |= SR_SPP;
>
> Setting sstatus.SPP needs to be done in kvm_riscv_vcpu_trap_redirect()
> because for guest all traps are always taken by VS-mode.
NIce. Sorry that I didn't dig much into the kvm part so I thought it
was left to VU-mode on purpose.
>
> > +       return 1;
> > +}
> > +
> >  /*
> >   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
> >   * proper exit to userspace.
> > @@ -179,6 +189,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >         ret = -EFAULT;
> >         run->exit_reason = KVM_EXIT_UNKNOWN;
> >         switch (trap->scause) {
> > +       case EXC_INST_ILLEGAL:
> > +               if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> > +                       ret = vcpu_trap_redirect_vs(vcpu, trap);
> > +               break;
> >         case EXC_VIRTUAL_INST_FAULT:
> >                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> >                         ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
> > @@ -206,6 +220,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                         vcpu->arch.guest_context.hstatus);
> >                 kvm_err("SCAUSE=0x%lx STVAL=0x%lx HTVAL=0x%lx HTINST=0x%lx\n",
> >                         trap->scause, trap->stval, trap->htval, trap->htinst);
> > +               asm volatile ("ebreak\n\t");
>
> This is not a related change.
>
Oops, that was a mistake.
> >         }
> >
> >         return ret;
> > --
> > 2.17.1
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> Overall, this patch can be accepted independent of this series due
> to its usefulness.
>
> I send a v2 of this patch separately.
Thank you Anup. I will leave this patch there for the following
revision of the vector patches.

Cheers,
Andy
