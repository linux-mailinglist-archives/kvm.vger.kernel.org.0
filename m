Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B192D6EAB5C
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 15:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjDUNQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 09:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjDUNQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 09:16:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E5CC156
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 06:16:15 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-505934ccc35so2753654a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 06:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1682082974; x=1684674974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XMxjEm4UvnsoHzLAHBkPkEwF3Gt/9CwX8y4iqsN5RM=;
        b=jG+FvIrl+PnQY2V/+/flKf7p6cz0IwKUMHve/yF8z2kv2EiqetKGPGvzn9z3sWYh+Y
         iQs/X0Do1qDOY4E0w4wH+jWgK9owtfi4Aer5sxYo/dPb1NYkKAMM6eaEpUBHFiF+AUsS
         RacrXeGWmbXtI/V0+88BPz5aCwqfR6FVenFm2aRwGDmlh7vbrkUhhLssYsf6ouuG+wNS
         73L4fBzQuRIG6JViXq93O7EXoP7uCN/RISzWwBiyLOquRiFH2rhk6+aRyji4ymw34Qk6
         JoNdfQqG+p8fcBU1NUvsk1TSgJteVfiNMgY/cntm5cH9Tc3Lk+OWgEqXuXhRcBui/PJc
         qcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682082974; x=1684674974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XMxjEm4UvnsoHzLAHBkPkEwF3Gt/9CwX8y4iqsN5RM=;
        b=NFj3XTE74d0kZu34c/nsPR7IPJqrvEYZOjCiWZoQmLDXdseFbap+QxPNdlGdzqRcFo
         ZMF+dS+sh50MxSsiof9WyLeVJCVBlrPwhKTqkku7Ad1HL98Mt76ahOBpPQc7WNNLa2bW
         UBCoEj30aAvwi0Xisz5K3AesoqAPCiLW3twYXx2Uo8kGHEVqvSgvQD/beZJqV2gAHQwl
         /OWvraFYHSleE8vNLuZQkUR0LKo2sIn2FWuRJwvv2pH1VOxsMA/0FmHYyxRQP/Ufng9I
         SuqdoR8CFwNCp4KOF1wn1BVDIon2WLvOUZwSGrBoSjw+W0GiRac7O9WoXoqA4MNnjX+Y
         lopw==
X-Gm-Message-State: AAQBX9dHW4nguwWIW7DW9ONYnWVHJ5eCCwUGkU+E5c8qnyu7Ph8rwZ0R
        qfW6ycutSvwMdStbIkp0LviabWKGwmCjcScJgVfIQg==
X-Google-Smtp-Source: AKy350YpLHxIgjQxSyvTw/OkPmB9KWS2SVXe5O8dmW8okji2xcd0yrVO+8HrGFVCIpoLQvcaAPH1ap/uCtVjJhCk4Xk=
X-Received: by 2002:a17:906:c416:b0:953:37eb:7727 with SMTP id
 u22-20020a170906c41600b0095337eb7727mr2260294ejz.43.1682082974310; Fri, 21
 Apr 2023 06:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
In-Reply-To: <20230404153452.2405681-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 21 Apr 2023 18:46:02 +0530
Message-ID: <CAAhSdy3V-BMzuCLcvZ9YVLVF+0o3D+6rMrSGJ3-BDBxxpBx1ZQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] RISC-V KVM virtualize AIA CSRs
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 4, 2023 at 9:05=E2=80=AFPM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> The RISC-V AIA specification is now frozen as-per the RISC-V internationa=
l
> process. The latest frozen specifcation can be found at:
> https://github.com/riscv/riscv-aia/releases/download/1.0-RC3/riscv-interr=
upts-1.0-RC3.pdf
>
> This series implements first phase of AIA virtualization which targets
> virtualizing AIA CSRs. This also provides a foundation for the second
> phase of AIA virtualization which will target in-kernel AIA irqchip
> (including both IMSIC and APLIC).
>
> The first two patches are shared with the "Linux RISC-V AIA Support"
> series which adds AIA driver support.
>
> To test this series, use AIA drivers from the "Linux RISC-V AIA Support"
> series and use KVMTOOL from the riscv_aia_v1 branch at:
> https://github.com/avpatel/kvmtool.git
>
> These patches can also be found in the riscv_kvm_aia_csr_v4 branch at:
> https://github.com/avpatel/linux.git
>
> Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
> (https://lore.kernel.org/lkml/20230401112730.2105240-1-apatel@ventanamicr=
o.com/)
>
> Based-on: 20230403121527.2286489-1-apatel@ventanamicro.com
> (https://lore.kernel.org/lkml/20230403121527.2286489-1-apatel@ventanamicr=
o.com/)
>
> Changes since v3:
>  - Split PATCH7 into two patches
>  - Addressed comments in PATCH7, PATCH8 and PATCH9
>
> Changes since v2:
>  - Rebased on Linux-6.3-rc5
>  - Split PATCH5 into two separate patches as suggested by Atish.
>
> Changes since v1:
>  - Addressed from Drew and Conor in PATCH1
>  - Use alphabetical ordering for SMAIA and SSAIA enum in PATCH2
>  - Use GENMASK() in PATCH3
>
> Anup Patel (9):
>   RISC-V: Add AIA related CSR defines
>   RISC-V: Detect AIA CSRs from ISA string
>   RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
>   RISC-V: KVM: Initial skeletal support for AIA
>   RISC-V: KVM: Implement subtype for CSR ONE_REG interface
>   RISC-V: KVM: Add ONE_REG interface for AIA CSRs
>   RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
>   RISC-V: KVM: Virtualize per-HART AIA CSRs
>   RISC-V: KVM: Implement guest external interrupt line management

I have queued PATCH1 to PATCH8 for Linux-6.4

The PATCH9 depends on "RISC-V IPI Improvements" series
so this patch will be sent as separate PR or differed to Linux-6.5

Regards,
Anup

>
>  arch/riscv/include/asm/csr.h      | 107 ++++-
>  arch/riscv/include/asm/hwcap.h    |   8 +
>  arch/riscv/include/asm/kvm_aia.h  | 137 +++++++
>  arch/riscv/include/asm/kvm_host.h |  14 +-
>  arch/riscv/include/uapi/asm/kvm.h |  18 +-
>  arch/riscv/kernel/cpu.c           |   2 +
>  arch/riscv/kernel/cpufeature.c    |   2 +
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/aia.c              | 627 ++++++++++++++++++++++++++++++
>  arch/riscv/kvm/main.c             |  23 +-
>  arch/riscv/kvm/mmu.c              |   3 +-
>  arch/riscv/kvm/vcpu.c             | 190 +++++++--
>  arch/riscv/kvm/vcpu_insn.c        |   1 +
>  arch/riscv/kvm/vm.c               |   4 +
>  arch/riscv/kvm/vmid.c             |   4 +-
>  15 files changed, 1083 insertions(+), 58 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c
>
> --
> 2.34.1
>
