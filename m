Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB0682444
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 07:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAaGBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 01:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjAaGBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 01:01:35 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3CC3B3F8
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 22:01:31 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id h19so13222386vsv.13
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 22:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+jH9jtw54xpyA3LsRz4MvxNgaHM7qf/mASxIp14kGwU=;
        b=Xe+fcSj6UKNT8s+4fYZgUIM1+O2VECK/uLab2bCFNZHpaA1Cw291Dn2vZYt6yHkj6W
         04gmIeNZSuxOhlh4B5MwNZTnNU4gVwq5br6cQWtmoVtb6cm7tTjaZxtu6uL27Iqd4t9R
         tqdT0LMuv6CySqxMNp8Qbysw3UZ9OGVNCIOk5wj1hbu1xlglsaObX4P4AkqTdFUhkiKk
         x/bQpLU9FIbUHQvvluXYbkfwxXUEeyKm+naVg9f5ISLlWyQ9DfdHOtqJIBgrC0tZkWM/
         QkoY1fxbgwUwXx15kpfnP2jntPWT5pSbhGSYS6irEu5lrBdnOZjic7/7Bo1/KomxyBVw
         uDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+jH9jtw54xpyA3LsRz4MvxNgaHM7qf/mASxIp14kGwU=;
        b=a5OuMic2YiNuntoiHRVaN9c+SiMxz28e9bXw3ft4giM8B7joDw0bU+YGoeryZcp/Oi
         LjIPUiiS7H7zU8KO6LySxk/GukThKwjmakAwxRUBnKXKnIL/jWhK6ZsB1FVXye1vDr4/
         ozuzDaE5XMaQgxEW9GlBTas+bY38TYXSRJPP7iMjpZL2TUwoquf45p92irMt5fmiWoh3
         ZnzAu2yQKr9lFkTZkL1L+CMVaj83kF93GkjZw9WDuP0GZryUIaOfIcYS3L6crMRcFrJD
         t97TGSkR990tiScHwsA9lbXSzUvUjCp2yZ43DF5yFZoIKCZoITLpAWWMy/64xLhPUxoS
         QhrQ==
X-Gm-Message-State: AO0yUKXOdGN43W7WsnyNHAjCEVJBR+ED5mcK0/MDVdr31jpmEcQEP468
        yEbhjuCaCiF99G6yVomlpGHCWwkpcIiouTOM88xnyA==
X-Google-Smtp-Source: AK7set8T8zGFEyjd7YIsBGyAbXe+hLHmog7RQVHiqnPBoaPeefEtsDF+IRzZWa18/zB+XQZSyeHb16GQwO/ao//beQo=
X-Received: by 2002:a05:6102:3098:b0:3ec:1029:9eae with SMTP id
 l24-20020a056102309800b003ec10299eaemr2618701vsb.10.1675144890577; Mon, 30
 Jan 2023 22:01:30 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-1-apatel@ventanamicro.com>
In-Reply-To: <20230128072737.2995881-1-apatel@ventanamicro.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Tue, 31 Jan 2023 11:31:19 +0530
Message-ID: <CAK9=C2W=MPqU8UGBt89HMWW7Mpda8prm3_8WnuTR=8vipynDYQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] RISC-V KVM virtualize AIA CSRs
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Palmer,

On Sat, Jan 28, 2023 at 12:57 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The RISC-V AIA specification is now frozen as-per the RISC-V international
> process. The latest frozen specifcation can be found at:
> https://github.com/riscv/riscv-aia/releases/download/1.0-RC1/riscv-interrupts-1.0-RC1.pdf
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
> These patches can also be found in the riscv_kvm_aia_csr_v2 branch at:
> https://github.com/avpatel/linux.git
>
> Changes since v1:
>  - Addressed from Drew and Conor in PATCH1
>  - Use alphabetical ordering for SMAIA and SSAIA enum in PATCH2
>  - Use GENMASK() in PATCH3
>
> Anup Patel (7):
>   RISC-V: Add AIA related CSR defines
>   RISC-V: Detect AIA CSRs from ISA string
>   RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
>   RISC-V: KVM: Initial skeletal support for AIA
>   RISC-V: KVM: Add ONE_REG interface for AIA CSRs
>   RISC-V: KVM: Virtualize per-HART AIA CSRs
>   RISC-V: KVM: Implement guest external interrupt line management

Can you please provide ACK for the first two patches so that I can
take it through the KVM RISC-V tree. ?

Regards,
Anup

>
>  arch/riscv/include/asm/csr.h      | 107 ++++-
>  arch/riscv/include/asm/hwcap.h    |   8 +
>  arch/riscv/include/asm/kvm_aia.h  | 137 +++++++
>  arch/riscv/include/asm/kvm_host.h |  14 +-
>  arch/riscv/include/uapi/asm/kvm.h |  22 +-
>  arch/riscv/kernel/cpu.c           |   2 +
>  arch/riscv/kernel/cpufeature.c    |   2 +
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/aia.c              | 624 ++++++++++++++++++++++++++++++
>  arch/riscv/kvm/main.c             |  14 +
>  arch/riscv/kvm/mmu.c              |   3 +-
>  arch/riscv/kvm/vcpu.c             | 185 +++++++--
>  arch/riscv/kvm/vcpu_insn.c        |   4 +-
>  arch/riscv/kvm/vm.c               |   4 +
>  arch/riscv/kvm/vmid.c             |   4 +-
>  15 files changed, 1075 insertions(+), 56 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c
>
> --
> 2.34.1
>
