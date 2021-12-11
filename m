Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED41D47127E
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 08:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhLKH3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 02:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhLKH3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 02:29:03 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAECBC061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 23:29:02 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id q3so18435066wru.5
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 23:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NCxbKQbBvq7DAhX8XxN50vu86niU3L9rA+r4FBy78NI=;
        b=WnWMTCmF/oJ7lcN32MHHE3EzTeXGytb5JGkc++i6GG2lVAowTOfZcdm5tUUWfsSSBz
         KVGffsSg4BoiV8gRWO7QX1p4X41udFVteKlDSTf8xNMtSRNub+7UHgzNcj8PPYsWxoSx
         yDLBRfARyEkTFoY2TnkuQh+JgQQ7A3wznckXVIJ/NknUVMi5iAo+A0tcDIU1RBZFq9bI
         wsz05yyY121S62mcptyjd6ZRg9y35B+4tctMg2Cemf03Fh2oCNNyPDskuIL/ZOrNed1q
         GHWMD8sNPioh5FZ46NQazf+v9T2LnQ8CJeTDgVGOiCiksGG6+lwanv8AjMnYTOkT0LEg
         g8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NCxbKQbBvq7DAhX8XxN50vu86niU3L9rA+r4FBy78NI=;
        b=Xy/xf+a7k8hHG6Kv7fxmsdUchw6oP++vjMadCYwtsATOkBfOKyuDJJ0G1S4Y5f2z3g
         YzWkxfa7RPIo6TDtwItK8mViqg9XK5ecFubSPDaS09FYRNAbzeKuSa3uCmWPPsPq8wit
         SgHCZuNm3Wamd9nyf4bbktI4Wi/rBXjzkl5qWp96IFEdhhIYAij1C5WxedPhVP6sS7S6
         2eT65HUfYADG0ydlrf0qbTDd8f06l03BQadNM832Xm4Ssm3gpaVm0ZyYDhF1S1QsM6K5
         RHHPgSOKEzmSTxYqFSO9YZfxP7SumlAtGB0wGSSK/Il5ujT5GXnQcdLyTlpaN6lPPr+N
         i7Bg==
X-Gm-Message-State: AOAM53038nQRmkM77fYNVXBLR5VFEBs8OVH0MpHG4KHY0SArqwrsldMu
        UxTJ0DhB1v40i/FsG8hQ1Ij6uichprhz3jWwx6tWSBKonmQ=
X-Google-Smtp-Source: ABdhPJzGtZWleUsxAg6ZN7iRhKt1By3irNcDyGM4y5afLzs9+QBzgJa/sOu4xfMMgFdZ8ts6+dY2MKYgaoM3TSnmqNg=
X-Received: by 2002:adf:d082:: with SMTP id y2mr19460738wrh.214.1639207741180;
 Fri, 10 Dec 2021 23:29:01 -0800 (PST)
MIME-Version: 1.0
References: <20211119124515.89439-1-anup.patel@wdc.com>
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 11 Dec 2021 12:58:49 +0530
Message-ID: <CAAhSdy1pqS5PYdxuxx5RD8baeqfd07Vm1DM7_Eq9Mby37mS_ig@mail.gmail.com>
Subject: Re: [PATCH v11 kvmtool 0/8] KVMTOOL RISC-V Support
To:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     julien.thierry.kdev@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Hi Will,

On Fri, Nov 19, 2021 at 6:15 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> This series adds RISC-V support for KVMTOOL and it is based on the
> Linux-5.16-rc1. The KVM RISC-V patches have been merged in the Linux
> kernel since 5.16-rc1.
>
> The KVMTOOL RISC-V patches can be found in riscv_master branch at:
> https//github.com/kvm-riscv/kvmtool.git

Ping ?
Do you have further comments on this series ?

Regards,
Anup

>
> Changes since v10:
>  - Updated PLIC CLAIM write emulation in PATCH5 to ignore writes when
>    interrupt is disabled for the PLIC context. This behaviour is as-per
>    definition of interrupt completion process in the RISC-V PLIC spec.
>
> Changes since v9:
>  - Rebased on recent commit 39181fc6429f4e9e71473284940e35857b42772a
>  - Sync-up headers with Linux-5.16-rc1
>
> Changes since v8:
>  - Rebased on recent commit 2e7380db438defbc5aa24652fe10b7bf99822355
>  - Sync-up headers with latest KVM RISC-V v20 series which is based
>    on Linux-5.15-rc3
>  - Fixed PLIC context CLAIM register emulation in PATCH5
>
> Changes since v7:
>  - Rebased on recent commit 25c1dc6c4942ff0949c08780fcad6b324fec6bf7
>  - Sync-up headers with latest KVM RISC-V v19 series which is based
>    on Linux-5.14-rc3
>
> Changes since v6:
>  - Rebased on recent commit 117d64953228afa90b52f6e1b4873770643ffdc9
>  - Sync-up headers with latest KVM RISC-V v17 series which is based
>    on Linux-5.12-rc5
>
> Changes since v5:
>  - Sync-up headers with latest KVM RISC-V v16 series which is based
>    on Linux-5.11-rc3
>
> Changes since v4:
>  - Rebased on recent commit 90b2d3adadf218dfc6bdfdfcefe269843360223c
>  - Sync-up headers with latest KVM RISC-V v15 series which is based
>    on Linux-5.10-rc3
>
> Changes since v3:
>  - Rebased on recent commit 351d931f496aeb2e97b8daa44c943d8b59351d07
>  - Improved kvm_cpu__show_registers() implementation
>
> Changes since v2:
>  - Support compiling KVMTOOL for both RV32 and RV64 systems using
>    a multilib toolchain
>  - Fix kvm_cpu__arch_init() for RV32 system
>
> Changes since v1:
>  - Use linux/sizes.h in kvm/kvm-arch.h
>  - Added comment in kvm/kvm-arch.h about why PCI config space is 256M
>  - Remove forward declaration of "struct kvm" from kvm/kvm-cpu-arch.h
>  - Fixed placement of DTB and INITRD in guest RAM
>  - Use __riscv_xlen instead of sizeof(unsigned long) in __kvm_reg_id()
>
> Anup Patel (8):
>   update_headers: Sync-up ABI headers with Linux-5.16-rc1
>   riscv: Initial skeletal support
>   riscv: Implement Guest/VM arch functions
>   riscv: Implement Guest/VM VCPU arch functions
>   riscv: Add PLIC device emulation
>   riscv: Generate FDT at runtime for Guest/VM
>   riscv: Handle SBI calls forwarded to user space
>   riscv: Generate PCI host DT node
>
>  INSTALL                             |   7 +-
>  Makefile                            |  24 +-
>  arm/aarch64/include/asm/kvm.h       |  56 ++-
>  include/linux/kvm.h                 | 441 ++++++++++++++++++++-
>  powerpc/include/asm/kvm.h           |  10 +
>  riscv/fdt.c                         | 195 ++++++++++
>  riscv/include/asm/kvm.h             | 128 +++++++
>  riscv/include/kvm/barrier.h         |  14 +
>  riscv/include/kvm/fdt-arch.h        |   8 +
>  riscv/include/kvm/kvm-arch.h        |  89 +++++
>  riscv/include/kvm/kvm-config-arch.h |  15 +
>  riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
>  riscv/include/kvm/sbi.h             |  48 +++
>  riscv/ioport.c                      |   7 +
>  riscv/irq.c                         |  13 +
>  riscv/kvm-cpu.c                     | 490 ++++++++++++++++++++++++
>  riscv/kvm.c                         | 174 +++++++++
>  riscv/pci.c                         | 109 ++++++
>  riscv/plic.c                        | 571 ++++++++++++++++++++++++++++
>  util/update_headers.sh              |   2 +-
>  x86/include/asm/kvm.h               |  64 +++-
>  21 files changed, 2497 insertions(+), 19 deletions(-)
>  create mode 100644 riscv/fdt.c
>  create mode 100644 riscv/include/asm/kvm.h
>  create mode 100644 riscv/include/kvm/barrier.h
>  create mode 100644 riscv/include/kvm/fdt-arch.h
>  create mode 100644 riscv/include/kvm/kvm-arch.h
>  create mode 100644 riscv/include/kvm/kvm-config-arch.h
>  create mode 100644 riscv/include/kvm/kvm-cpu-arch.h
>  create mode 100644 riscv/include/kvm/sbi.h
>  create mode 100644 riscv/ioport.c
>  create mode 100644 riscv/irq.c
>  create mode 100644 riscv/kvm-cpu.c
>  create mode 100644 riscv/kvm.c
>  create mode 100644 riscv/pci.c
>  create mode 100644 riscv/plic.c
>
> --
> 2.25.1
>
