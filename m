Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5F71A647C
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 11:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgDMJNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 05:13:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45296 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgDMJNS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 05:13:18 -0400
Received: by mail-io1-f66.google.com with SMTP id i19so8655025ioh.12;
        Mon, 13 Apr 2020 02:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+Skmoxt5MI5HXvfLUf4druORyMZBVzf5KJrih23ccU=;
        b=fDp2jxtXNOb+7h5ClJ6Oio/gIdyczrnz2lBDSxGWc5BhTFplVqxU69XOTd7Xaqy0wO
         ImNpO4sr18SLmRxifFtpHSM02TTgVpBogzrEt3vLvUInt5cenw2/GA/D10dqXCxsoUDA
         hzzetVoTEQi9piL7DKYgItknlKumBQ3a5tPOx0ppt/sDZJujSix4EFooH8I151p+khBq
         jaowPoFmaqjvkoR0vhuJJZy8Bsxt+ROsPLvPeE4VgekvhYBS4ZoHIvGjHH8GdQwX7Z5R
         rC0ysyWv5QoT0pzvq9c84DDDqkAdH2PhYkOJMUgd86LLKYmNV/vH2IkHUgK3oPAF5GMd
         Na+w==
X-Gm-Message-State: AGi0Pua7T08af6muYtGup9nGqkILPSnbY+7I8nBFQdrmoVheQ8EWP1e6
        jYpvtu//OT5PTCHF0Jzlv/+euVxq8PfM37AN+a4=
X-Google-Smtp-Source: APiQypKBH3KZtdNrHmV1/kgu47YGEODs/VxE3gNQeAODVmlqj9hysfzpPU9zGmyEV8ESs72m5RhUyLJM/N2cuoZ4iNI=
X-Received: by 2002:a6b:8b4b:: with SMTP id n72mr15497824iod.72.1586769196934;
 Mon, 13 Apr 2020 02:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com> <20200413161842.57ad8be4@flygoat-x1e>
In-Reply-To: <20200413161842.57ad8be4@flygoat-x1e>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Mon, 13 Apr 2020 17:20:27 +0800
Message-ID: <CAAhV-H5+3cKtCH=h=kprfYbbcT-3YcwqCD-tE1E7VB0NZnfnjQ@mail.gmail.com>
Subject: Re: [PATCH 0/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jiaxun,

On Mon, Apr 13, 2020 at 4:19 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>
> On Mon, 13 Apr 2020 15:30:09 +0800
> Huacai Chen <chenhc@lemote.com> wrote:
>
> > We are preparing to add KVM support for Loongson-3. VZ extension is
> > fully supported in Loongson-3A R4+, and we will not care about old
> > CPUs (at least now). We already have a full functional Linux kernel
> > (based on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their git
> > repositories are here:
> >
> > QEMU: https://github.com/chenhuacai/qemu
> > Kernel: https://github.com/chenhuacai/linux
> >
> > Of course these two repositories need to be rework and not suitable
> > for upstream (especially the commits need to be splitted). We show
> > them here is just to tell others what we have done, and how
> > KVM/Loongson will look like.
> >
> > Our plan is make the KVM host side be upstream first, and after that,
> > we will make the KVM guest side and QEMU emulator be upstream.
>
> + Aleksandar as QEMU/MIPS mainatiner
>
> I was involved in KVM/Loongson development a bit and also intend to
> help with mainline these works.
>
> After dealing with basic LS7A PCH kernel support, I'm going to
> cooperate with Huacai and anyone who interested in to deal with
> following stuff:
>
> - Basic QEMU/TCG support for Loongson64 instructions.
>         Well, it seems unrelated with KVM, but that would make
>         development easier with cross ISA emulation. I'm not going to
>         implement all the features like Loongson's page table fast walk
>         extension and binary translation extension but I'll ensure any
>         binary compiled with march=loongson3a can run flawlessly on
>         TCG.
>
> - Design of Loongson-VIRT QEMU machine
>         It is nearly impossible to bring a real Loongson system into
>         QEMU. Both RS780E and LS7A PCH have tons of unreasonable design
>         that would make the emulation extremely complex, Loongson
>         company's KVM implementation[1] has already proofed that,
>         thay're now in the hell. So we all agreed that we should build
>         a machine from draft. I think we should reuse existing infra as
>         far as possible to reduce our work load. I'm planing to use
>         pci-host-cam-generic together with VIRTIO PCI devices and a
>         a strip down version of loongson,liointc-1.0a to build a pure
>         PCI based system. But if any one have better idea please just
>         tell us, I'm still considering how to implement SMP-IPI and ACPI
>         stuff.
>
> - BIOS in VM
>         This has a lower priority. But BIOS is required to make a
>         emulated machine looks like a real machine. Loongson have their
>         open-sourced PMON and close-sourced UEFI(Based on tianocore).
>         I'd really with Loongson or Lemote will open-source their UEFI
>         but PMON is also a option.
There will be an open source BIOS, we have completed 98%.

>
> Any kind of feedback is appreciated.
>
> Thanks.
>
> Wish you good health :-)
>
>
> [1]: http://cgit.loongnix.org/cgit/linux-3.10/ &
> http://cgit.loongnix.org/cgit/qemu-2.7.0/
>
> Btw: I think Cc qemu-devel for the whole series is a little bit
> disturb, probably we should only Cc qemu-devel for the cover letter.
Sorrry, its my mistake.

>
> >
> > Mike Rapoport(1):
> >  mips: define pud_index() regardless of page table folding
> >
> > Xing Li(2):
> >  KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
> >  KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
> >
> > Huacai Chen(12):
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
> >
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  arch/mips/Kconfig                    |   1 +
> >  arch/mips/include/asm/cpu-features.h |   3 +
> >  arch/mips/include/asm/kvm_host.h     |  50 +++-
> >  arch/mips/include/asm/mipsregs.h     |   7 +
> >  arch/mips/include/asm/pgtable-64.h   |   4 +-
> >  arch/mips/include/uapi/asm/inst.h    |  11 +
> >  arch/mips/kernel/cpu-probe.c         |   2 +
> >  arch/mips/kvm/Kconfig                |   1 +
> >  arch/mips/kvm/Makefile               |   5 +-
> >  arch/mips/kvm/emulate.c              | 461
> > ++++++++++++++++++++++++++++++++++- arch/mips/kvm/entry.c
> >    |  19 +- arch/mips/kvm/interrupt.c            |  93 +------
> >  arch/mips/kvm/interrupt.h            |  14 +-
> >  arch/mips/kvm/loongson_ipi.c         | 215 ++++++++++++++++
> >  arch/mips/kvm/mips.c                 |  49 +++-
> >  arch/mips/kvm/tlb.c                  |  39 +++
> >  arch/mips/kvm/trap_emul.c            |   3 +
> >  arch/mips/kvm/vz.c                   | 204 +++++++++++-----
> >  18 files changed, 1013 insertions(+), 168 deletions(-)
> >  create mode 100644 arch/mips/kvm/loongson_ipi.c
> > --
> > 2.7.0
>
Huacai
