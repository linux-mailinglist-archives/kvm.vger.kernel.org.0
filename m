Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF647C63FF
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjJLEUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 00:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjJLEUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 00:20:43 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732A8A9
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 21:20:41 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-694f75deb1aso1344495b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 21:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697084441; x=1697689241; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Isqfx1ZTmd7S9NvMQ8FV/5Vywg+slY8+zlhmEKVnKB8=;
        b=h+UyKQNCE9fhudNJhQfWBA2cbLk0adZIFVIZlZnkBlqT956pg0QR1gM01w6qvLDd0I
         zeVPKac6YGAwvYz/fv6Obj1w+3/1wwTFddTrcRPUUWmw/tKVz8XdE4Qm0XFEAsQ7ZuuO
         nxZpfk5ZtMhnk71ndrykf2RMWNvEZiYS8q9qf7alRdoJKPeIOwYkyaQIEKSKliwX65nr
         28bS5G+HYnQOI6WqwQMg2oXLvIXlCBx5NPRCKCFVGCQLKb5kJgjNejxuiSemtecP1Giv
         dEe7D2xqgMJUpjJg3Y9b65OkSl66zOzIflJ9kI7bD0S6QYKs+TuEeQDcAPriD25KEsYo
         SQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697084441; x=1697689241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Isqfx1ZTmd7S9NvMQ8FV/5Vywg+slY8+zlhmEKVnKB8=;
        b=hoVwGQ2WeuvdJJKUbvjJ8Skjq7RF7x9cWP5mylafXx4vSvKzSh9u46pqQE7zUFc42S
         7SMYluyOiWE3PcmYzZsEbZlQbOkoUMcdLHTxbgsgiFtBzOq4tSM2kwrzQWqjkLsduxk9
         kBdnGXH0xmmfglfKvH/jqN/B5mGuYycoFA9ukbrBJsl0AormzpKPnMo6edb8Nr2QRcUp
         kNLG8KDZW4btNM1euY5AAKT/u5n+6nHZxFTfffyd7shxB+tjBhdFrsztsm2mYCKE4S6i
         kUMCsp0PkP6hsoepU/9tQ3BdgnxGy2GUExVhvl55wVFPIOeVn3vxCDwb2KtSvpEvXCOp
         N6qQ==
X-Gm-Message-State: AOJu0YxduGvoHVXaoChGZnImBWUDhk4lPLVAcO52WRot08kPa2apkylk
        WanFpDE2ywvZNVsOD/k9rRathksH/5oPBg/2/xwM0Q==
X-Google-Smtp-Source: AGHT+IGvt6iyqP1Dgue+gIsK2PqBB7T34Pg3W3ep49R8Zk6Hsda4NflTYJ43/KPq9N0rcGzNbvRBmSdXjdjdX+6Pyok=
X-Received: by 2002:a05:6a21:6d9b:b0:14d:e615:277c with SMTP id
 wl27-20020a056a216d9b00b0014de615277cmr31252575pzb.11.1697084440861; Wed, 11
 Oct 2023 21:20:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
In-Reply-To: <20230918125730.1371985-1-apatel@ventanamicro.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 12 Oct 2023 09:50:29 +0530
Message-ID: <CAK9=C2Vvu=kcR5CtzSFFh4DFvqxMsLrLNAHpMxoxrCf8nUixbw@mail.gmail.com>
Subject: Re: [kvmtool PATCH v2 0/6] RISC-V AIA irqchip and Svnapot support
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Mon, Sep 18, 2023 at 6:27=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> The latest KVM in Linux-6.5 has support for:
> 1) Svnapot ISA extension support
> 2) AIA in-kernel irqchip support
>
> This series adds corresponding changes in KVMTOOL to use the above
> mentioned features for Guest/VM.
>
> These patches can also be found in the riscv_aia_v2 branch at:
> https://github.com/avpatel/kvmtool.git
>
> Changes since v1:
>  - Rebased on commit 9cb1b46cb765972326a46bdba867d441a842af56
>  - Updated PATCH1 to sync header with released Linux-6.5
>
> Anup Patel (6):
>   Sync-up header with Linux-6.5 for KVM RISC-V
>   riscv: Add Svnapot extension support
>   riscv: Make irqchip support pluggable
>   riscv: Add IRQFD support for in-kernel AIA irqchip
>   riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
>   riscv: Fix guest/init linkage for multilib toolchain

Friendly ping ?

>
>  Makefile                            |   3 +
>  include/linux/kvm.h                 |   6 +-
>  riscv/aia.c                         | 227 ++++++++++++++++++++++++++++
>  riscv/fdt.c                         |  15 +-
>  riscv/include/asm/kvm.h             |  81 ++++++++++
>  riscv/include/kvm/fdt-arch.h        |   8 +-
>  riscv/include/kvm/kvm-arch.h        |  38 ++++-
>  riscv/include/kvm/kvm-config-arch.h |   3 +
>  riscv/irq.c                         | 138 ++++++++++++++++-
>  riscv/kvm.c                         |   2 +
>  riscv/pci.c                         |  32 ++--
>  riscv/plic.c                        |  61 ++++----
>  12 files changed, 563 insertions(+), 51 deletions(-)
>  create mode 100644 riscv/aia.c
>
> --
> 2.34.1
>

Regards,
Anup
