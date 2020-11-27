Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A692C60C1
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 09:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgK0IPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 03:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgK0IPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 03:15:07 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CEEC0613D4
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 00:15:05 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 3so1947093wmg.4
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 00:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NMhtxoOQO9MieYk5Rltrie3Vdx47/RH1jVgYv6FFhaQ=;
        b=m18nERKWsFZ00KX/m38Vvp9IoTZj62sK5tPmNvoeLIbF/briBEzrkI4Hs/aP0+f5Dk
         b6L6mUdr+pMsHGojOE1pYEaNg+qTaTwxdx3UC3m6PH7giJbpoICZWLUfN6McEJznQI0/
         ADGFpQpnm3rro734UAHnBzt65wVTVP9BpbCXcx94t+MOoll+iCpnDcavAFcdF0+QDELM
         12QxEZVpZX7d+cnirVswy7GSxpe3Mi/4Rk9WyUD/NhH36baHA//UTri8KODMTLjGwSZU
         jLOOkQku0V93aTg4vi4zxvjXe+Whmc44JqBeo++EqL9Q/YPCtY5Ta5ONyPUR14qNpZId
         wP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NMhtxoOQO9MieYk5Rltrie3Vdx47/RH1jVgYv6FFhaQ=;
        b=qkISlWTV10jZRFEAswOGk6eE9veCRam4tz4iydyFhNPTBUm5LbrJjx5y/iGEbVK8n3
         W3x2agCPwgCrTVewpjqBi2y6pDZn0HSLam9jJ6tE0MhkoOIytTNIzLCOCiAmJyPd4TDu
         NQkRiEYtyxeDTjItxtzMNcoyWVaoCavdtiYf+pNnM4mV1Z+7I8r1I051gvwEksmf+j6j
         7oT99mrhLklMpCUx0NqzlECYP6CcWeFr5RGLZOQa57msVsWFkgkFNmwFj67N3WjaRUKJ
         m7LZLPZi0vVKoEtBzIX8B5H1YOGtibYwINlUYvPb9pq3kVe2CiSBdX9cw8QqPykJPGRQ
         oNQQ==
X-Gm-Message-State: AOAM531njf1WfH+8VXva06idM/DSbpm/58FgdZDaD78rNNmbw4Gu8j1x
        FTe49k8+DxkhVMP4wa/wxhfk16k10XuAgMWZZes+/w==
X-Google-Smtp-Source: ABdhPJyk6kMwRndUJx8qkTrZCUGCRggV1uLiA8zUdqoxIaXhDdJQV7aRToPt4xzAJtqmF1NyBDcB0fbNhk0qaRpavdQ=
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr121691wmk.157.1606464903925;
 Fri, 27 Nov 2020 00:15:03 -0800 (PST)
MIME-Version: 1.0
References: <20200803175846.26272-1-atish.patra@wdc.com>
In-Reply-To: <20200803175846.26272-1-atish.patra@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 27 Nov 2020 13:44:52 +0530
Message-ID: <CAAhSdy0hrKNwOA4428Vf4mf32gZSw1cKiSXhhXB1s==yq7jEpA@mail.gmail.com>
Subject: Re: [PATCH 0/6] Add SBI v0.2 support for KVM
To:     Atish Patra <atish.patra@wdc.com>
Cc:     kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        KVM General <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 3, 2020 at 11:29 PM Atish Patra <atish.patra@wdc.com> wrote:
>
> The Supervisor Binary Interface(SBI) specification[1] now defines a
> base extension that provides extendability to add future extensions
> while maintaining backward compatibility with previous versions.
> The new version is defined as 0.2 and older version is marked as 0.1.
>
> This series adds following features to RISC-V Linux KVM.
> 1. Adds support for SBI v0.2 in KVM
> 2. SBI Hart state management extension (HSM) in KVM
> 3. Ordered booting of guest vcpus in guest Linux
>
> This series depends on the base kvm support series[2].
>
> Guest kernel needs to also support SBI v0.2 and HSM extension in Kernel
> to boot multiple vcpus. Linux kernel supports both starting v5.7.
> In absense of that, guest can only boot 1vcpu.
>
> [1] https://github.com/riscv/riscv-sbi-doc/blob/master/riscv-sbi.adoc
> [2] http://lists.infradead.org/pipermail/linux-riscv/2020-July/001028.html
>
> Atish Patra (6):
> RISC-V: Add a non-void return for sbi v02 functions
> RISC-V: Mark the existing SBI v0.1 implementation as legacy
> RISC-V: Reorganize SBI code by moving legacy SBI to its own file
> RISC-V: Add SBI v0.2 base extension
> RISC-V: Add v0.1 replacement SBI extensions defined in v02
> RISC-V: Add SBI HSM extension in KVM
>
> arch/riscv/include/asm/kvm_vcpu_sbi.h |  32 +++++
> arch/riscv/include/asm/sbi.h          |  17 ++-
> arch/riscv/kernel/sbi.c               |  32 ++---
> arch/riscv/kvm/Makefile               |   4 +-
> arch/riscv/kvm/vcpu.c                 |  19 +++
> arch/riscv/kvm/vcpu_sbi.c             | 194 ++++++++++++--------------
> arch/riscv/kvm/vcpu_sbi_base.c        |  73 ++++++++++
> arch/riscv/kvm/vcpu_sbi_hsm.c         | 109 +++++++++++++++
> arch/riscv/kvm/vcpu_sbi_legacy.c      | 129 +++++++++++++++++
> arch/riscv/kvm/vcpu_sbi_replace.c     | 136 ++++++++++++++++++
> 10 files changed, 619 insertions(+), 126 deletions(-)
> create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
> create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_legacy.c
> create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c
>
> --
> 2.24.0
>

Please implement the SBI SRST extension in your series.

Also, the PATCH1 can be merged separately so I would suggest
you to send this patch separately.

Regards,
Anup
