Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119377D0E37
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 13:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377022AbjJTLOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 07:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376988AbjJTLOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 07:14:05 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F31C1A8
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 04:14:02 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-3573fa82923so2584985ab.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 04:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1697800441; x=1698405241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ui4lAScxS4avp7oCJ7ZH8jd7TnRHOi5lmcUoRRDmRE=;
        b=Cpj3I7CBqqtjU1eMO55yWvD4nivuNfVhBaom75clkV+yxX2/QanwvFJwSvSWTOq6F8
         hvxzseN2uR1tUTfrxETJionCMWLh68iNTjgJc+A/4g12BaUSl05srD39ZQ5UfiTQ1WhY
         hBW1TOocPprig61gN1hS1RE8eUmlbTLraZ4P9cmk4MzurNPATRMffnJ4rElw23mLFkkY
         yhtp28S2up5RoAPHo2ddrNj7ZTWCr4TN7jRqT1vyby2BFlYKSL+HFBOKRH7RgW8EPnVA
         iEu4AIn2ZsIo3rFtvocNJQjojVQVEik0g1QD1uQJzH5J1lvAyURvMWWryagY1nBo2/8a
         +bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697800441; x=1698405241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Ui4lAScxS4avp7oCJ7ZH8jd7TnRHOi5lmcUoRRDmRE=;
        b=cT8xHObQGBu4tczd8WdvOl77qdnLCEM40z5P/fIV5xdpblqxsoRyAqneoS59u2Jn82
         Sxg7SCmjTKu6OtnFHJLWGzwsDKgQDnYSecp+ZjLO1bB6jI4rnQpq6TaEqsMGcogRAqa/
         RWOtCgRwnyAEssNZSPIDMh+OnKb51NZcvFjMTvcBC+9Zb4Ob/U91bNrQT82PFj4y2cSW
         6nLdw6dKLzyfzMCLQ6BXmGXLN99QJdRZPNWlzgBDImg1i4p4LmX9rlBM00PE5Ek57/Cq
         dVgmVhQLN7DROc3o9F0gE+QfdZXmxHw/rFn45DsEPFb5xuFglb3jmTZDhdiyfLlZDmE+
         O3Zg==
X-Gm-Message-State: AOJu0Yxt8v/Vzn7ZpP5bXW+aPKPZ4yva0mklKOnoN3mB1Kps8j2Xx7lf
        Xa2Bx08Ps3LK0SpWecYIqSiu1LMkHgFaiyFWwJMbLg==
X-Google-Smtp-Source: AGHT+IEitVBts/lHHu15Qiuy69Q0OAhUE5hrFg148JtL4A9RHhcapJhDM1ssRdMIbsrFJ9GgKO6swmiB+E5FvbTcRNA=
X-Received: by 2002:a05:6e02:147:b0:357:5234:802d with SMTP id
 j7-20020a056e02014700b003575234802dmr1903255ilr.10.1697800441567; Fri, 20 Oct
 2023 04:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <20231020072140.900967-1-apatel@ventanamicro.com>
In-Reply-To: <20231020072140.900967-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 20 Oct 2023 16:43:49 +0530
Message-ID: <CAAhSdy2Ncc4+fvjrWHGZuHKB8jFtd1WkRhPifiTEfftpyEY7+w@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] RISC-V SBI debug console extension support
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 12:51=E2=80=AFPM Anup Patel <apatel@ventanamicro.co=
m> wrote:
>
> The SBI v2.0 specification is now frozen. The SBI v2.0 specification defi=
nes
> SBI debug console (DBCN) extension which replaces the legacy SBI v0.1
> functions sbi_console_putchar() and sbi_console_getchar().
> (Refer v2.0-rc5 at https://github.com/riscv-non-isa/riscv-sbi-doc/release=
s)
>
> This series adds support for SBI debug console (DBCN) extension in KVM RI=
SC-V
> and Linux RISC-V.
>
> To try these patches with KVM RISC-V, use KVMTOOL from riscv_sbi_dbcn_v1
> branch at: https://github.com/avpatel/kvmtool.git
>
> These patches can also be found in the riscv_sbi_dbcn_v3 branch at:
> https://github.com/avpatel/linux.git
>
> Changes since v2:
>  - Rebased on Linux-6.6-rc5
>  - Handled page-crossing in PATCH7 of v2 series
>  - Addressed Drew's comment in PATCH3 of v2 series
>  - Added new PATCH5 to make get-reg-list test aware of SBI DBCN extension
>
> Changes since v1:
>  - Remove use of #ifdef from PATCH4 and PATCH5 of the v1 series
>  - Improved commit description of PATCH3 in v1 series
>  - Introduced new PATCH3 in this series to allow some SBI extensions
>    (such as SBI DBCN) do to disabled by default so that older KVM user sp=
ace
>    work fine and newer KVM user space have to explicitly opt-in for emula=
ting
>    SBI DBCN.
>  - Introduced new PATCH5 in this series which adds inline version of
>    sbi_console_getchar() and sbi_console_putchar() for the case where
>    CONFIG_RISCV_SBI_V01 is disabled.
>
> Anup Patel (8):
>   RISC-V: Add defines for SBI debug console extension
>   RISC-V: KVM: Change the SBI specification version to v2.0
>   RISC-V: KVM: Allow some SBI extensions to be disabled by default
>   RISC-V: KVM: Forward SBI DBCN extension to user-space
>   KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
>   RISC-V: Add stubs for sbi_console_putchar/getchar()
>   tty/serial: Add RISC-V SBI debug console based earlycon
>   RISC-V: Enable SBI based earlycon support
>
> Atish Patra (1):
>   tty: Add SBI debug console support to HVC SBI driver

Queued PATCH1 to PATCH5 for Linux-6.7

Remaining PATCH6 to PATCH9 are still under review.

Thanks,
Anup

>
>  arch/riscv/configs/defconfig                  |  1 +
>  arch/riscv/configs/rv32_defconfig             |  1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h         |  7 +-
>  arch/riscv/include/asm/sbi.h                  | 12 +++
>  arch/riscv/include/uapi/asm/kvm.h             |  1 +
>  arch/riscv/kvm/vcpu.c                         |  6 ++
>  arch/riscv/kvm/vcpu_sbi.c                     | 61 +++++++-------
>  arch/riscv/kvm/vcpu_sbi_replace.c             | 32 ++++++++
>  drivers/tty/hvc/Kconfig                       |  2 +-
>  drivers/tty/hvc/hvc_riscv_sbi.c               | 82 +++++++++++++++++--
>  drivers/tty/serial/Kconfig                    |  2 +-
>  drivers/tty/serial/earlycon-riscv-sbi.c       | 32 +++++++-
>  .../selftests/kvm/riscv/get-reg-list.c        |  2 +
>  13 files changed, 198 insertions(+), 43 deletions(-)
>
> --
> 2.34.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
