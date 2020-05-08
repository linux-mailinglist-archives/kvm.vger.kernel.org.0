Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A591CA9DB
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 13:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgEHLnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 07:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726792AbgEHLno (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 07:43:44 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59843C05BD43;
        Fri,  8 May 2020 04:43:44 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so1496377wrx.4;
        Fri, 08 May 2020 04:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qKGhrUPEHY1fphcNoABX/IHv164kpoZpOU/cK61zd18=;
        b=gIfE0RDCPNifBmsmWO7ny5anKMbhPu3jhwrv8CXiPnxjeuz95+8OyDHZmJFYj7jAvd
         hpCHM8e4T4P8d2hDJpLvDDRrnT5y3+iZJ8F6F8kHQZiEE4vxnm+lK5PdS9HtaHxhG7d5
         jao8mgYREs4uQpenwhP3hLfKVRbTmhhUNyvNrOjwsbTLNl6P0mSPeHTnuTrr7PL41Xez
         hsrQHIUl9YmfMsCKshraJNWLs/opu6CzMxV23p29+SCRzRR6g7dRjGswaYNZkTuQi8SY
         DcaSsmRp4t/9qof9GgGaZWzBlMY1A0MdMJM/1tzO4eYLK87TuHUi2DKTvr3RB+mK9NEv
         k8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qKGhrUPEHY1fphcNoABX/IHv164kpoZpOU/cK61zd18=;
        b=i0drPRRBRu01qWWmRfdd03b1VU5WXZLyDyHgaCgv7jNYDrBOxNOkbh7ZmcFJ9hthD+
         Ozcp3HaO4qFjh3XzVve+IkC7/bZ+zKUzfCRZkj0sc2mFwC++m5YLGS4XN7IOxClnAc6P
         z5F5UPOifgUrs7tkbmcVpv4XCMkgt+gxCiW7bkEvpvEfND7pvgc4GxSUdQ5PXn3U5ulD
         tY5PdBjQtvavQ+Mxkjjbsh3QalUTxA5LV2Agut+4vAqDK73s8QfTCrKOBQdRYuKXT9KO
         NbiuxXbvJ0OO2DQ+AyXf8RE2gPDg+94jUqGZO2ioHppOj+CsSYKrI3rPtVbJauLifpVX
         4ROA==
X-Gm-Message-State: AGi0Pubg67W8fLCOdZkmyvEFYHyxcWdJg1j9TM8AAp0yrku9CPwJe+wA
        ZizNRPKYMKuLa7pmpMIKdWyWCm9ic3jYLEMb+H4=
X-Google-Smtp-Source: APiQypK/2c0ZqyQa5bx07zYKDpZDBfCeDhkkWNQ5ES1fs2vEL0KHQqN5iu+gcwH1k/K8c88MGNYIffy75833IjusxZE=
X-Received: by 2002:adf:dc50:: with SMTP id m16mr2524484wrj.329.1588938222913;
 Fri, 08 May 2020 04:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 13:43:30 +0200
Message-ID: <CAHiYmc4f1N-8mvMEZNcxVP+zbxjp0=OWFQc2pDDssnpmZ6eJig@mail.gmail.com>
Subject: Re: [PATCH V3 00/14] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:06 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> We are preparing to add KVM support for Loongson-3. VZ extension is
> fully supported in Loongson-3A R4+, and we will not care about old CPUs
> (at least now). We already have a full functional Linux kernel (based
> on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their git
> repositories are here:
>
> QEMU: https://github.com/chenhuacai/qemu
> Kernel: https://github.com/chenhuacai/linux
>
> Of course these two repositories need to be rework and not suitable for
> upstream (especially the commits need to be splitted). We show them here
> is just to tell others what we have done, and how KVM/Loongson will look
> like.
>
> Our plan is make the KVM host side be upstream first, and after that,
> we will make the KVM guest side and QEMU emulator be upstream.
>

Huacei, I absolutely salute this series, as it is, in my opinion, of
tremendous significance not only for Loongson, but also for KVM for
MIPS in general.

As you probably know, James Hogan left KVM for MIPS kernel
maintainership some time ago. It was really too bad, as he was and
still is, from my direct experience, an excellent colleague and
engineer.

KVM for MIPS kernel maintainership left orphaned put me (as the
maintainer for KVM for MIPS in QEMU) in an awkward position.

May I ask that you and me jointly assume KVM for MIPS kernel
maintainership? For me, it makes perfect sense, and I would certainly
enjoy working with you. If you agree, please add such patch at the end
of this series, in its next version.

Yours,
Aleksandar


> V1 -> V2:
> 1, Remove "mips: define pud_index() regardless of page table folding"
>    because it has been applied.
> 2, Make Loongson-specific code be guarded by CONFIG_CPU_LOONGSON64.
>
> V2 -> V3:
> 1, Emulate a reduced feature list of CPUCFG.
> 2, Fix all possible checkpatch.pl errors and warnings.
>
> Xing Li(2):
>  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
>  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
>
> Huacai Chen(12):
>  KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
>  KVM: MIPS: Add EVENTFD support which is needed by VHOST
>  KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
>  KVM: MIPS: Introduce and use cpu_guest_has_ldpte
>  KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
>  KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
>  KVM: MIPS: Add more types of virtual interrupts
>  KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
>  KVM: MIPS: Add CPUCFG emulation for Loongson-3
>  KVM: MIPS: Add CONFIG6 and DIAG registers emulation
>  KVM: MIPS: Add more MMIO load/store instructions emulation
>  KVM: MIPS: Enable KVM support for Loongson-3
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/Kconfig                    |   1 +
>  arch/mips/include/asm/cpu-features.h |   3 +
>  arch/mips/include/asm/kvm_host.h     |  52 +++-
>  arch/mips/include/asm/mipsregs.h     |   7 +
>  arch/mips/include/uapi/asm/inst.h    |  11 +
>  arch/mips/kernel/cpu-probe.c         |   2 +
>  arch/mips/kvm/Kconfig                |   1 +
>  arch/mips/kvm/Makefile               |   5 +-
>  arch/mips/kvm/emulate.c              | 503 +++++++++++++++++++++++++++++=
+++++-
>  arch/mips/kvm/entry.c                |  19 +-
>  arch/mips/kvm/interrupt.c            |  93 +------
>  arch/mips/kvm/interrupt.h            |  14 +-
>  arch/mips/kvm/loongson_ipi.c         | 214 +++++++++++++++
>  arch/mips/kvm/mips.c                 |  49 +++-
>  arch/mips/kvm/tlb.c                  |  41 +++
>  arch/mips/kvm/trap_emul.c            |   3 +
>  arch/mips/kvm/vz.c                   | 235 +++++++++++-----
>  17 files changed, 1087 insertions(+), 166 deletions(-)
>  create mode 100644 arch/mips/kvm/loongson_ipi.c
> --
> 2.7.0
