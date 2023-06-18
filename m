Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22917346E6
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjFRQC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 12:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFRQC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 12:02:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E511918B
        for <kvm@vger.kernel.org>; Sun, 18 Jun 2023 09:02:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-510d6b939bfso3772071a12.0
        for <kvm@vger.kernel.org>; Sun, 18 Jun 2023 09:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1687104144; x=1689696144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tk69zSZBq69irQ6KXTUmFnUhhXE2H+D4z+iALKYIPbg=;
        b=5ExsAWaueLejYhbjVuFgF9fLjy9aWDlVfEnQwmoK7Asl4V2KYyGvLQvsnTWp4gqq6J
         pbxKuB2cFYwoaOnNGhYecK3+AyrbCgWGtS9Ef2zGA+eSFRokvsOtidXHQPptDUg1MgwA
         bhbjq0KTXFrMHHhxl6UlOEJmsG/7wr9S1TE7WszAxtfOg39hY8lFucCgOzU4gs5u0uul
         Ky+SSi1QSWo3+bAskKWltpwg3K5Bdb/HEhmhifsvZ8VB8gMnkW+FMbD9SUzWtaVWiccd
         MEtF93ChTUoxV2P/8Yc1EgdrnsbAFkE5o4dQvSw2XPIlk43PskK54sMS+BWsSA9XS8MQ
         OqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687104144; x=1689696144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tk69zSZBq69irQ6KXTUmFnUhhXE2H+D4z+iALKYIPbg=;
        b=OMYrmpH7gIYfjMxBJYBYpP92IaU+rJLt5OYxjNBgPeKEKCQe8rh45bFp4lubR3D+SB
         nE3/cGKzFVtwQNnUwvNg2K0n6BsMM5NyXCscMVo3d2VEeLOD4mZt+Pe8kCgKE4AsGUsu
         X/SySjvP6ucse+ez0egoCjZt24hNa9KEWM6OZEd10uvzpFM6h3H9GPIApJ8Pt/syTVnp
         sqinhotUicTMyCZ18+tLc6fAR2FIhIEUQ1Oq1AKEMjQlzW/vF+IK0/ghFJGPN+V58ODM
         uer4nt8q40Kh0JGvhJAz2iFEjN6mjn9MVRCtR7iBQPp9FNDpm9zKNKBMBQt14sqV1kjM
         gF2w==
X-Gm-Message-State: AC+VfDxex9kZcKrFXuDdjKrlmInO+d8DJ0bUb5Bpi4xHBYBi1DbMLwA6
        cJ0DRZ6BTJHDgY4DuAI6uLGAfyN1FClFaIZ10pcfbg==
X-Google-Smtp-Source: ACHHUZ6pEuJe8TtsnRFY0sITQcWqM15hbBlRIOS926qG/437YFWkJnqH4ZQfBz5ivkzz052KxyOt+e/IrbO31r9GXb0=
X-Received: by 2002:aa7:c992:0:b0:51a:1f10:8a79 with SMTP id
 c18-20020aa7c992000000b0051a1f108a79mr5278054edt.31.1687104144358; Sun, 18
 Jun 2023 09:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230615073353.85435-1-apatel@ventanamicro.com>
In-Reply-To: <20230615073353.85435-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 18 Jun 2023 21:32:12 +0530
Message-ID: <CAAhSdy3UL97dnBttjedFv3EztC0oyrNOLuTQK+JituLY7h0FYA@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] RISC-V KVM in-kernel AIA irqchip
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023 at 1:04=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series adds in-kernel AIA irqchip to KVM RISC-V which trap-n-emulate
> IMSIC and APLIC MSI-mode for Guest. The APLIC MSI-mode trap-n-emulate is
> optional so KVM user space can emulate APLIC entirely in user space.
>
> The use of IMSIC HW guest files to accelerate IMSIC virtualization will b=
e
> done as separate series since this depends on AIA irqchip drivers to be
> upstreamed. This series has no dependency on the AIA irqchip drivers.
>
> There is also a KVM AIA irq-bypass (or device MSI virtualization) series
> under development which depends on this series and upcoming IOMMU driver
> series.
>
> These patches (or this series) can also be found in the
> riscv_kvm_aia_irqchip_v3 branch at: https://github.com/avpatel/linux.git
>
> Changes since v2:
>  - Added KVM_CAP_IRQCHIP in PATCH5
>  - Fix check for KVM_DEV_RISCV_AIA_CONFIG_IDS write in PATCH6
>  - Fix APLIC_IRQ_STATE_ENPEND usage in PATCH7
>
> Changes since v1:
>  - Rebased on Linux-6.4-rc6
>  - Addressed Atish's comment in PATCH6
>  - Added comments in arch/riscv/include/uapi/asm/kvm.h about APLIC and
>    IMSIC device attribute type
>
> Anup Patel (10):
>   RISC-V: KVM: Implement guest external interrupt line management
>   RISC-V: KVM: Add IMSIC related defines
>   RISC-V: KVM: Add APLIC related defines
>   RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
>   RISC-V: KVM: Skeletal in-kernel AIA irqchip support
>   RISC-V: KVM: Implement device interface for AIA irqchip
>   RISC-V: KVM: Add in-kernel emulation of AIA APLIC
>   RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
>   RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
>   RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip

Queued this series for 6.5

Regards,
Anup

>
>  arch/riscv/include/asm/kvm_aia.h       |  107 ++-
>  arch/riscv/include/asm/kvm_aia_aplic.h |   58 ++
>  arch/riscv/include/asm/kvm_aia_imsic.h |   38 +
>  arch/riscv/include/asm/kvm_host.h      |    4 +
>  arch/riscv/include/uapi/asm/kvm.h      |   72 ++
>  arch/riscv/kvm/Kconfig                 |    4 +
>  arch/riscv/kvm/Makefile                |    3 +
>  arch/riscv/kvm/aia.c                   |  274 +++++-
>  arch/riscv/kvm/aia_aplic.c             |  619 ++++++++++++++
>  arch/riscv/kvm/aia_device.c            |  673 +++++++++++++++
>  arch/riscv/kvm/aia_imsic.c             | 1083 ++++++++++++++++++++++++
>  arch/riscv/kvm/main.c                  |    3 +-
>  arch/riscv/kvm/vcpu.c                  |    2 +
>  arch/riscv/kvm/vm.c                    |  118 +++
>  include/uapi/linux/kvm.h               |    2 +
>  15 files changed, 3027 insertions(+), 33 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
>  create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
>  create mode 100644 arch/riscv/kvm/aia_aplic.c
>  create mode 100644 arch/riscv/kvm/aia_device.c
>  create mode 100644 arch/riscv/kvm/aia_imsic.c
>
> --
> 2.34.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
