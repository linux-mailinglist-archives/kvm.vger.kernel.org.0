Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523386EB7CA
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 09:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDVH1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 03:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVH1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 03:27:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F8A1BC3
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 00:27:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-94f7a7a3351so429793466b.2
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 00:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1682148456; x=1684740456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhkFmfxnytE5muWdXVkGlZ2Sbu4thV49OIL2hGsAGJ4=;
        b=v/jUOM468Q3Udb2zDHspkAZ0P75nb8w6TpDFxGk4rhImYmvSHJDBcxuyZcS3+ESER/
         THWgYBsYV0m1uuJmRjKPdF4G/wMZerD6J93QRiQ6R/Gveav2d2tLV40BYUvc/bIaPbVR
         VswSJpUlN5dOhoYVWK2QWid8uSgXxENQdAiyVIpCP2wYJRHqQQXk9JthJLhwMr9fmoHO
         91YXeS5yXkoNgQzg8drLIOaqMG6Uk6pNKOGerO83T5yek8vop1CQAed6zX1NUApHY1ZI
         vn1OQh0WsElscVIQp7P87mCVunSc8mwwLSIYu8lzS3K2/Z6hmgcIA/HQf9FXDS0ypoyP
         /Nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682148456; x=1684740456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AhkFmfxnytE5muWdXVkGlZ2Sbu4thV49OIL2hGsAGJ4=;
        b=LIztJlfTS4vyntx2bvQLq0cQkvfBxyAvv8P2xEhBZ8PQNMYVE93CgwIziNu5qsqTTB
         /JbrdFUdPWF7LEU09rmrUhvZwJfC7LdZma1jT5QqEqHuXW1hNTkyRCqxlNcWPaNwvQvW
         7yhyLqeDZ4R2QyYx4nDEOPGe8eOy7uzuOYhQPJgiSksHryeayW5b4uNkQ7dkIITVqwdW
         m2mwIjvDq/IDQ4VPy5a/17hO0iQz2739815vSwADtf2FS3xgo9WmhzuuIwN6blT3RP24
         9cEUyAs7Nkknn1l121JOTLd8GvMAnWjaZy0YmFLPIg7qLk7nmTXOE6pFBWW/raYZFreh
         RlFQ==
X-Gm-Message-State: AAQBX9fNkIFNxY1/tthgDGV0yId30264/NrDZLmGVKia18t4o6oBGmlo
        0M9rgNWvkf+KEO3j8oA3+7d44si/RWxD4YtOZ6CTWMsMnj5p5w9vU1w=
X-Google-Smtp-Source: AKy350bZDJGQjnrdUmB/xDz0wvEUG3fcoWed32w28NI+3771o1OkNFOccJYt49HOVd/UyLUsrwYnNBEDGF4iQOVihKo=
X-Received: by 2002:a17:906:269b:b0:94e:4fe5:613a with SMTP id
 t27-20020a170906269b00b0094e4fe5613amr4776175ejc.25.1682148456024; Sat, 22
 Apr 2023 00:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
 <CABgObfbPB2NYwDLHnQSW0gtw0AX96KbeNOQsszw0NqytObyfaQ@mail.gmail.com>
In-Reply-To: <CABgObfbPB2NYwDLHnQSW0gtw0AX96KbeNOQsszw0NqytObyfaQ@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 22 Apr 2023 12:57:23 +0530
Message-ID: <CAAhSdy2ywoeXG9At+9FoHmjmUM-Zjuz5L1a23fo00UxkQH_RLQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.4
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Sat, Apr 22, 2023 at 5:09=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> Hi Anup,
>
> while you did fix the bug that caused the mailing list date to
> disappear, I noticed that these patches have been _applied_ (not just
> rebased) earlier today, just a few hours before sending the pull
> request.
>
> The pull request was sent around midnight, Indian time, while the
> patches were applied around 5-6pm. I  recognized that this is not a
> rebase because the commit dates are grouped according to the topicsL
>
> 17:38:40 +0530 KVM: RISC-V: Retry fault if vma_lookup() results become in=
valid
> 17:38:42 +0530 RISC-V: KVM: Alphabetize selects
> 17:38:44 +0530 RISC-V: KVM: Add ONE_REG interface to enable/disable
> SBI extensions
> 17:38:46 +0530 RISC-V: KVM: Allow Zbb extension for Guest/VM
>
> 17:45:39 +0530 RISC-V: Add AIA related CSR defines
> 17:45:42 +0530 RISC-V: Detect AIA CSRs from ISA string
> 17:45:44 +0530 RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask de=
fines
> 17:45:48 +0530 RISC-V: KVM: Initial skeletal support for AIA
> 17:45:51 +0530 RISC-V: KVM: Implement subtype for CSR ONE_REG interface
> 17:45:54 +0530 RISC-V: KVM: Add ONE_REG interface for AIA CSRs
> 17:45:58 +0530 RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_=
mask
>
> 18:10:27 2023 +0530 RISC-V: KVM: Virtualize per-HART AIA CSRs

This was because I was waiting for ACK in one of the AIA patches
which I received just a few days ago.

>
> What this means, is that there is no way that these patches have been
> tested by anyone except you. Please try to push to the kvm-riscv/next
> branch as soon as patches are ready, since that makes it easier to
> spot conflicts between architectures.

Sure, I will push to riscv_kvm_next branch as soon as patches are
accepted or queued.

>
> In fact, since RISC-V is still pretty small, feel free to send me pull
> requests even early in the development period, as soon as some patches
> are ready.

Sure, this sounds good to me.

Regards,
Anup

>
> Paolo
>
> On Fri, Apr 21, 2023 at 7:34=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > Hi Paolo,
> >
> > We have the following KVM RISC-V changes for 6.4:
> > 1) ONE_REG interface to enable/disable SBI extensions
> > 2) Zbb extension for Guest/VM
> > 3) AIA CSR virtualization
> > 4) Few minor cleanups and fixes
> >
> > Please pull.
> >
> > Please note that the Zicboz series has been taken by
> > Palmer through the RISC-V tree which results in few
> > minor conflicts in the following files:
> > arch/riscv/include/asm/hwcap.h
> > arch/riscv/include/uapi/asm/kvm.h
> > arch/riscv/kernel/cpu.c
> > arch/riscv/kernel/cpufeature.c
> > arch/riscv/kvm/vcpu.c
> >
> > I am not sure if a shared tag can make things easy
> > for you or Palmer.
> >
> > Regards,
> > Anup
> >
> > The following changes since commit 6a8f57ae2eb07ab39a6f0ccad60c76074305=
1026:
> >
> >   Linux 6.3-rc7 (2023-04-16 15:23:53 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.4-1
> >
> > for you to fetch changes up to 2f4d58f7635aec014428e73ef6120c4d0377c430=
:
> >
> >   RISC-V: KVM: Virtualize per-HART AIA CSRs (2023-04-21 18:10:27 +0530)
> >
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.4
> >
> > - ONE_REG interface to enable/disable SBI extensions
> > - Zbb extension for Guest/VM
> > - AIA CSR virtualization
> >
> > ----------------------------------------------------------------
> > Andrew Jones (1):
> >       RISC-V: KVM: Alphabetize selects
> >
> > Anup Patel (10):
> >       RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensio=
ns
> >       RISC-V: KVM: Allow Zbb extension for Guest/VM
> >       RISC-V: Add AIA related CSR defines
> >       RISC-V: Detect AIA CSRs from ISA string
> >       RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
> >       RISC-V: KVM: Initial skeletal support for AIA
> >       RISC-V: KVM: Implement subtype for CSR ONE_REG interface
> >       RISC-V: KVM: Add ONE_REG interface for AIA CSRs
> >       RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
> >       RISC-V: KVM: Virtualize per-HART AIA CSRs
> >
> > David Matlack (1):
> >       KVM: RISC-V: Retry fault if vma_lookup() results become invalid
> >
> >  arch/riscv/include/asm/csr.h          | 107 +++++++++-
> >  arch/riscv/include/asm/hwcap.h        |   8 +
> >  arch/riscv/include/asm/kvm_aia.h      | 127 +++++++++++
> >  arch/riscv/include/asm/kvm_host.h     |  14 +-
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
> >  arch/riscv/include/uapi/asm/kvm.h     |  51 ++++-
> >  arch/riscv/kernel/cpu.c               |   2 +
> >  arch/riscv/kernel/cpufeature.c        |   2 +
> >  arch/riscv/kvm/Kconfig                |  10 +-
> >  arch/riscv/kvm/Makefile               |   1 +
> >  arch/riscv/kvm/aia.c                  | 388 ++++++++++++++++++++++++++=
++++++++
> >  arch/riscv/kvm/main.c                 |  22 +-
> >  arch/riscv/kvm/mmu.c                  |  28 ++-
> >  arch/riscv/kvm/vcpu.c                 | 194 +++++++++++++----
> >  arch/riscv/kvm/vcpu_insn.c            |   1 +
> >  arch/riscv/kvm/vcpu_sbi.c             | 247 ++++++++++++++++++++--
> >  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
> >  arch/riscv/kvm/vm.c                   |   4 +
> >  arch/riscv/kvm/vmid.c                 |   4 +-
> >  19 files changed, 1129 insertions(+), 91 deletions(-)
> >  create mode 100644 arch/riscv/include/asm/kvm_aia.h
> >  create mode 100644 arch/riscv/kvm/aia.c
> >
>
