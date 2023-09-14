Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD1E7A0B12
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjINQ4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 12:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjINQ4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 12:56:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753261FDE
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 09:56:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-273527a8fdeso986321a91.2
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 09:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694710606; x=1695315406; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8QfuXExCc9cSMiJxJKYBjr6Y4vNmIaVGVdq3tHbZZs=;
        b=jHQ3a4ru9hqq36DykpEmdZgnjboS+wjhmyEdHCeCI0AQuJ4b0iMxrhtKJ3/cCUSIRt
         O8ottHXdMSM+dgJT55mKHWEzGAYTQo8qsTaT9IB2T3MhJD8kw+xtqf1Rba/L2NIotnUC
         L+HXkSjnunbKMEWySfnN3jt1cafLDCMeaOKOvbVsNlXOT0yUpEtB9H9AxS3OPp6sCGCv
         rWen6NodJnzYyYmxNdRrfutu+1UCGqaplHLfT+DMmInVbwvA+zqIAiQg3ooMyFxMCW5q
         7LLW4DGso3upJDPOXszgyHNWZaRU3Q1Y/N6lEJZAefwAvl9OPBaKCe3IPG3cyLN3jkL8
         t/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694710606; x=1695315406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8QfuXExCc9cSMiJxJKYBjr6Y4vNmIaVGVdq3tHbZZs=;
        b=vx2PGMCJXOkjOFReMNhyG/Y/U3t/wDh13zeON4iQ2HxwzyjRXqIucpL8c15rqWeej0
         +UYcpJ28DbWS/S9TVqoPVcx0hEgkOOqKrOEzedoyong3rRddBCef//uyP+EsxR937MoX
         8uz0Av8pDeYPDKG6ZYkvK3n6SbsIJ9dyBMocd8URi2z8OYNgtbe8mv6D1EE1tKktnvID
         bkA/FrS2pUhrjjvAwegYs1v31VRiCOMOPVir/AKA+cEUp0pEwkiKaG2S8i/g652Js/4q
         hPPx0rph+7RKrWfW+HWeGPfHnOibsx2R/yDq9aG2ZV45ccBERJLR0D3/UV8Lx41zBOsO
         oMow==
X-Gm-Message-State: AOJu0YwWzEROEGuakz2tckIRao3VUXy5ewhqn+6luL6ToQYmV5vbx0aE
        eXixhjOYkVRblia+CqR+sImziEmS02WIgAotPFktGw==
X-Google-Smtp-Source: AGHT+IGddv1w9MDzOp2CWDx5EXsPDantUH7/FsJHm6texg+p9ppC/GB2dMxKnArB/KV4FxuLcrEWiwraQS5qBwMrfjU=
X-Received: by 2002:a17:90a:4090:b0:274:46cd:5af2 with SMTP id
 l16-20020a17090a409000b0027446cd5af2mr5618729pjg.34.1694710605827; Thu, 14
 Sep 2023 09:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230725152430.3351564-1-apatel@ventanamicro.com>
In-Reply-To: <20230725152430.3351564-1-apatel@ventanamicro.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 14 Sep 2023 22:26:34 +0530
Message-ID: <CAK9=C2WkkEpA3YM99HMNRk743mkhk2FDEpV_ffG3UWH9Vy3YkA@mail.gmail.com>
Subject: Re: [kvmtool PATCH 0/6] RISC-V AIA irqchip and Svnapot support
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>, maz@kernel.org,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, julien.thierry.kdev@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Tue, Jul 25, 2023 at 8:54=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> The latest KVM in Linux-6.5 has support for:
> 1) Svnapot ISA extension support
> 2) AIA in-kernel irqchip support
>
> This series adds corresponding changes in KVMTOOL to use the above
> mentioned features for Guest/VM.
>
> These patches can also be found in the riscv_aia_v1 branch at:
> https://github.com/avpatel/kvmtool.git
>
> Anup Patel (6):
>   Sync-up header with Linux-6.5-rc3 for KVM RISC-V
>   riscv: Add Svnapot extension support
>   riscv: Make irqchip support pluggable
>   riscv: Add IRQFD support for in-kernel AIA irqchip
>   riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
>   riscv: Fix guest/init linkage for multilib toolchain

Friendly ping ?

Regards,
Anup

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
