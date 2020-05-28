Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB01E58BD
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 09:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgE1HgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 03:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE1HgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 03:36:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF58C05BD1E;
        Thu, 28 May 2020 00:36:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so21429579wrp.2;
        Thu, 28 May 2020 00:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T8l9ZUxIOXsJeQU9fuugyzz0//RYyLlqRCwB65ghuSE=;
        b=deb9hob6pj80MVXWoVPyZ8C/QckMbya8tmtIm+WfUcS77V8mHh9bKJuaVGOCey3wRy
         GqfvQ3dz1zbg/LbOlAoP9i3xuZyOJQk4LDu5odAzx26hK8pzNG2+dowfP1md75LXHnEt
         64T6ueicoEn8V4MGD5DcxA/qE/J34Rw4wQB4JaBBqfByzWbsLWkBhb6f05uR4H6ZM251
         cyEcTrjIDtjYTox+ra/LIvawYTt5Z5SdONu4pv5IoY0Bw6wwtrRlKiRRwbt7mh6UepWO
         XMfgmtTHgWU2U+/ElLkAl73or8QFMBsyfamfrDweoTUo/cjLrXoJxmDNJfaCAJ0ZaHPU
         2sBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T8l9ZUxIOXsJeQU9fuugyzz0//RYyLlqRCwB65ghuSE=;
        b=qQXXsOY2TCj7057GjkcRNp/daf/mvkXzn+BD1J1wMfI7tBKqzwI1+QD5Tfd/p2QNdg
         Un5FXaBk833TP3E2oF3M9nfAekFUPJltzeJ62WVTx7UoICd+tkVxsamSvfpLN7xMEzdE
         Hg7FBjXDAA3evSrxFH0bHK9jI+5kPBmG7trVW/fP6chJViibxaHRgaoKisWEq/MRmdRN
         Mii+s9N5nHjNmw3rTscpQ1ihhBZj/vic1wY7JNlxkQwOlmzJWeOcT7fW1E4gqznpVnW5
         NU1oQYlIFsjc+dYfCuHJemGVsP1DKk6WLWtiOAOx/N9eDSFzEHDGxf9//bKHkPfXORlV
         zqdA==
X-Gm-Message-State: AOAM531Xqrkp4vXwJJ4Y8Fngiy9cLmWelf0ybjTn2bFZDwuOBQ9cxzlb
        ZcAEy7Mu+iDNCbejYE7XUiV2aR0w+fFqwXIBOd4=
X-Google-Smtp-Source: ABdhPJy7gL+Mp0mVGqHjv05fp1fiqbe1u7pVHix37JcsNca7ofRJ8Du/5GDLPee2w/BB2iFGI2h9m5/dDrBw74nl0AY=
X-Received: by 2002:a5d:4385:: with SMTP id i5mr2142543wrq.420.1590651370875;
 Thu, 28 May 2020 00:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Thu, 28 May 2020 09:35:57 +0200
Message-ID: <CAHiYmc4uMSypSUafphc1bRu=voVj4Swvu=wEG8WNaszq34aNqQ@mail.gmail.com>
Subject: Re: [PATCH V8 00/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 24. =D0=BC=D0=B0=D1=98 2020. =D1=83 13:13 Huacai Chen <=
chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> We are preparing to add KVM support for Loongson-3. VZ extension is
> fully supported in Loongson-3A R4+, and we will not care about old CPUs
> (at least now). We already have a full functional Linux kernel (based
> on Linux-5.4.x LTS) and QEMU (based on 5.0.0) and their git repositories
> are here:
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

Huacai, Paolo, Thomas,

As you know, there are number of Huacai's patches to QEMU, related
to this series, actually we could call them counterparts to this series.

Regarding QEMU upstreaming, unless someone objects, I plan to send
pull request that will include some of Huacai-s QEMU patches in next few
days - those that are of general nature, do not rely on any kernel changes,
and passed review process. The rest of Huacai's QEMU patches will wait
for this series to be integrated in kernel upstream.

Please give Huacai and myself some direction and path to go forward with
this series. Please take into account that we inherit KVM for MIPS in an
"orphaned" state, and do not know exactly all details how to "adopt" it.
Forgive us if we made some missteps along the route.

We would like to establish a long-lasting, and high-quality, workflow that
will fit well to both KVM and MIPS kernel development.

Please help us do it.

Thanks in advance!

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
> V3 -> V4:
> 1, Emulate LOONGSON_CFG0/LOONGSON_CFG3 in CPUCFG correctly.
> 2, Update commit messages to explain Loongson-3 Virtual IPI.
> 3, Add Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>=
.
>
> V4 -> V5:
> 1, Fix a typo.
> 2, Update MAINTAINERS.
>
> V5 -> V6:
> 1, Fix a mismatch during rebasing.
> 2, Add Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>.
>
> V6 -> V7:
> 1, Rebase on latest mips-next (Config6 feature bits definition updated).
>
> V7 -> V8:
> 1, Rebase to be applied on kvm tree, i.e., the linux-next branch of
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/. Building KVM/MIPS
>    need commit 3fbfb4585bfd4ff34e ("mips: define pud_index() regardless
>    of page table folding"), which has already been in mips tree but not
>    in kvm tree.
>
> Xing Li(2):
>  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
>  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
>
> Huacai Chen(13):
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
>  MAINTAINERS: Update KVM/MIPS maintainers
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  MAINTAINERS                          |   4 +-
>  arch/mips/Kconfig                    |   1 +
>  arch/mips/include/asm/cpu-features.h |   3 +
>  arch/mips/include/asm/kvm_host.h     |  52 +++-
>  arch/mips/include/asm/mipsregs.h     |   7 +
>  arch/mips/include/uapi/asm/inst.h    |  37 +++
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
>  arch/mips/kvm/vz.c                   | 237 ++++++++++++-----
>  18 files changed, 1118 insertions(+), 167 deletions(-)
>  create mode 100644 arch/mips/kvm/loongson_ipi.c
> --
> 2.7.0
