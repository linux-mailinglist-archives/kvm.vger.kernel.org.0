Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBE91EDD98
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgFDG52 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Jun 2020 02:57:28 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44889 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgFDG51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:57:27 -0400
Received: by mail-io1-f65.google.com with SMTP id p20so5097692iop.11;
        Wed, 03 Jun 2020 23:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YeTJP/xMMCYkZAkMz4q0C25mgzCugEJYabA6Tr8yPyI=;
        b=bq0wrrTImgZoj6a8p9ELvsI0N2P5pMI4+qGgBVUT5lFaUCFYKwqVc6hLWPefK/qX0Q
         1BFTsUkjrHPWt9p9M8yn68smiSxlL1kGlGIaC7hZ716HIFWyYTO5HTTGVUVfi3nJsNAL
         F3gGtCkeCxbSBqVacajlPiZw2/NRveNluEOXP5R1jCdDiXZJuMv4AMNTufOO/DvOjb9H
         2I/aPxu8SfcNL3iark4slzZGB1ij3KtTe2EPWHmmSH2DLmcQ73a3EC+vvVymFywdfWo0
         qCNF7B3Hm+5l/uV0J83JsHCD/q6AEhaQ5CYgwC69oCmjBwwxTEXRLoJ5w7ewg7LA1jrA
         goAg==
X-Gm-Message-State: AOAM5311bkG95korauabXe2lz4IkYrNu1cD1aUrJGP3wVyliTCC/BRXX
        WSS+eS7NUKylUkLtrXCx19ZG5Sv+aSvNPL7FPMU=
X-Google-Smtp-Source: ABdhPJwu213mhzh5qFScmYIi6fe6ret32HwhzvodK/nVlOs5VktTDYvoC3AYyDhsd1Gi9CWDISQk8flF4/fptgVp4vY=
X-Received: by 2002:a5d:9dd2:: with SMTP id 18mr2910166ioo.196.1591253845660;
 Wed, 03 Jun 2020 23:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com> <CAHiYmc4uMSypSUafphc1bRu=voVj4Swvu=wEG8WNaszq34aNqQ@mail.gmail.com>
In-Reply-To: <CAHiYmc4uMSypSUafphc1bRu=voVj4Swvu=wEG8WNaszq34aNqQ@mail.gmail.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Thu, 4 Jun 2020 14:57:14 +0800
Message-ID: <CAAhV-H6qTzUiq2nrGrTBft=KBSPnR58-zL13ZuLjwN2MLzAveA@mail.gmail.com>
Subject: Re: [PATCH V8 00/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo

On Thu, May 28, 2020 at 3:36 PM Aleksandar Markovic
<aleksandar.qemu.devel@gmail.com> wrote:
>
> нед, 24. мај 2020. у 13:13 Huacai Chen <chenhc@lemote.com> је написао/ла:
> >
> > We are preparing to add KVM support for Loongson-3. VZ extension is
> > fully supported in Loongson-3A R4+, and we will not care about old CPUs
> > (at least now). We already have a full functional Linux kernel (based
> > on Linux-5.4.x LTS) and QEMU (based on 5.0.0) and their git repositories
> > are here:
> >
> > QEMU: https://github.com/chenhuacai/qemu
> > Kernel: https://github.com/chenhuacai/linux
> >
> > Of course these two repositories need to be rework and not suitable for
> > upstream (especially the commits need to be splitted). We show them here
> > is just to tell others what we have done, and how KVM/Loongson will look
> > like.
> >
> > Our plan is make the KVM host side be upstream first, and after that,
> > we will make the KVM guest side and QEMU emulator be upstream.
> >
>
> Huacai, Paolo, Thomas,
>
> As you know, there are number of Huacai's patches to QEMU, related
> to this series, actually we could call them counterparts to this series.
>
> Regarding QEMU upstreaming, unless someone objects, I plan to send
> pull request that will include some of Huacai-s QEMU patches in next few
> days - those that are of general nature, do not rely on any kernel changes,
> and passed review process. The rest of Huacai's QEMU patches will wait
> for this series to be integrated in kernel upstream.
>
> Please give Huacai and myself some direction and path to go forward with
> this series. Please take into account that we inherit KVM for MIPS in an
> "orphaned" state, and do not know exactly all details how to "adopt" it.
> Forgive us if we made some missteps along the route.
>
> We would like to establish a long-lasting, and high-quality, workflow that
> will fit well to both KVM and MIPS kernel development.
>
> Please help us do it.
>
> Thanks in advance!
>
> Aleksandar
>
If you will take this series after MIPS tree be merged into upstream,
maybe V7 is better for you.

Huacai
>
>
> > V1 -> V2:
> > 1, Remove "mips: define pud_index() regardless of page table folding"
> >    because it has been applied.
> > 2, Make Loongson-specific code be guarded by CONFIG_CPU_LOONGSON64.
> >
> > V2 -> V3:
> > 1, Emulate a reduced feature list of CPUCFG.
> > 2, Fix all possible checkpatch.pl errors and warnings.
> >
> > V3 -> V4:
> > 1, Emulate LOONGSON_CFG0/LOONGSON_CFG3 in CPUCFG correctly.
> > 2, Update commit messages to explain Loongson-3 Virtual IPI.
> > 3, Add Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>.
> >
> > V4 -> V5:
> > 1, Fix a typo.
> > 2, Update MAINTAINERS.
> >
> > V5 -> V6:
> > 1, Fix a mismatch during rebasing.
> > 2, Add Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>.
> >
> > V6 -> V7:
> > 1, Rebase on latest mips-next (Config6 feature bits definition updated).
> >
> > V7 -> V8:
> > 1, Rebase to be applied on kvm tree, i.e., the linux-next branch of
> >    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/. Building KVM/MIPS
> >    need commit 3fbfb4585bfd4ff34e ("mips: define pud_index() regardless
> >    of page table folding"), which has already been in mips tree but not
> >    in kvm tree.
> >
> > Xing Li(2):
> >  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
> >  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
> >
> > Huacai Chen(13):
> >  KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
> >  KVM: MIPS: Add EVENTFD support which is needed by VHOST
> >  KVM: MIPS: Use lddir/ldpte instructions to lookup gpa_mm.pgd
> >  KVM: MIPS: Introduce and use cpu_guest_has_ldpte
> >  KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
> >  KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
> >  KVM: MIPS: Add more types of virtual interrupts
> >  KVM: MIPS: Add Loongson-3 Virtual IPI interrupt support
> >  KVM: MIPS: Add CPUCFG emulation for Loongson-3
> >  KVM: MIPS: Add CONFIG6 and DIAG registers emulation
> >  KVM: MIPS: Add more MMIO load/store instructions emulation
> >  KVM: MIPS: Enable KVM support for Loongson-3
> >  MAINTAINERS: Update KVM/MIPS maintainers
> >
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  MAINTAINERS                          |   4 +-
> >  arch/mips/Kconfig                    |   1 +
> >  arch/mips/include/asm/cpu-features.h |   3 +
> >  arch/mips/include/asm/kvm_host.h     |  52 +++-
> >  arch/mips/include/asm/mipsregs.h     |   7 +
> >  arch/mips/include/uapi/asm/inst.h    |  37 +++
> >  arch/mips/kernel/cpu-probe.c         |   2 +
> >  arch/mips/kvm/Kconfig                |   1 +
> >  arch/mips/kvm/Makefile               |   5 +-
> >  arch/mips/kvm/emulate.c              | 503 ++++++++++++++++++++++++++++++++++-
> >  arch/mips/kvm/entry.c                |  19 +-
> >  arch/mips/kvm/interrupt.c            |  93 +------
> >  arch/mips/kvm/interrupt.h            |  14 +-
> >  arch/mips/kvm/loongson_ipi.c         | 214 +++++++++++++++
> >  arch/mips/kvm/mips.c                 |  49 +++-
> >  arch/mips/kvm/tlb.c                  |  41 +++
> >  arch/mips/kvm/trap_emul.c            |   3 +
> >  arch/mips/kvm/vz.c                   | 237 ++++++++++++-----
> >  18 files changed, 1118 insertions(+), 167 deletions(-)
> >  create mode 100644 arch/mips/kvm/loongson_ipi.c
> > --
> > 2.7.0
