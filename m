Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C51AF8FF
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 11:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDSJf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Apr 2020 05:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725832AbgDSJf0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Apr 2020 05:35:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C18AC061A0C;
        Sun, 19 Apr 2020 02:35:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id 19so7393864ioz.10;
        Sun, 19 Apr 2020 02:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ifCEXwwU8W7gVbM6yZO1vYxfict7Lt94AKxJJRZLIg=;
        b=fv9753Jt8E8fPX/Ee7CMAhH/Emin1tEn2NOk49yzIwHiMFzWg0Vn8rsrIhdssC2oGD
         jLRY9VgNZ+pYhLFA88zNer3PwSy57GTZhwwuF/9rmy76plHV8fxCdFpEh5QGLx+PEJUo
         4+bwta5w82/90/C6bfVmrO1SqBSNBuZiItdYtetSyVnuRiTBZVMcTxHvd1VKQOOqQOHU
         lpf0heU0etTJz0WtwkDvOFdolKehNfJpoGhGLtp8rlURjfk5pufbvk5sDl2De02ncH5B
         aWVYuZXcHzD2Ewub/JkKhZ8/dTE7G1gKeEDs9S2E2+ufFLedt8uGPjyqm0wroxYwv+yM
         +Rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ifCEXwwU8W7gVbM6yZO1vYxfict7Lt94AKxJJRZLIg=;
        b=ts0anCLoyshmbB1rkYhh/Rjp1G2NKC7oCnvmeOuhOEhF5YBz0wfQIYx8ec3QO87jS+
         P9HYtuRotTNUFucQ3iBkgKo1NRiHji5G3OP/S/xeXmrf8BuNhaJ4Fijw51vMuvX3Sxhh
         4s7tToA5It++4j0iQAJQMDYM4g/H9LWwAbBBbnrp6pK/p0jBaWsZqw8y+qgnFg6si3/6
         0aeICHVIfZ4vJGSpzqoxddgSU2rWqoVuN9XxUFTwGVOaNyP9F3tPruLcXj5LGGXpkQ4E
         es9/Muek9O2dT7PdfCNV4pRDnihHgaPin33FNi0lgdo11s4UKxGf0GHVehKEx4Y/rIP6
         ldbA==
X-Gm-Message-State: AGi0Pubnpx+ySRGQAjBpc2nT6UZ/7gcLqtROz1gmkjVoIht9rWo58xwz
        /zSzS/So47NbjyFiwSt31zBpjaQGUXul76HNQNM=
X-Google-Smtp-Source: APiQypKrODPQCvtX30O5GZ0mt2fmmNk2aWstL6sC8lTi8uw9h0nbE9KVpREkCas6LhnruyKIKeUsPLHVLVLwrNCajUY=
X-Received: by 2002:a5e:880b:: with SMTP id l11mr11081929ioj.42.1587288925427;
 Sun, 19 Apr 2020 02:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
 <20200413161842.57ad8be4@flygoat-x1e> <bbbeb507-5692-5969-c320-57d04823edc7@loongson.cn>
 <20200414124458.4675125b@flygoat-x1e>
In-Reply-To: <20200414124458.4675125b@flygoat-x1e>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sun, 19 Apr 2020 17:42:44 +0800
Message-ID: <CAAhV-H70-n3zaVH789k8hnNYEaQ8sT36=+BbRZ0vZQSgKrxT7w@mail.gmail.com>
Subject: Re: [PATCH 0/15] KVM: MIPS: Add Loongson-3 support (Host Side)
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Xing Li <lixing@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, all,

On Tue, Apr 14, 2020 at 12:45 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>
> On Tue, 14 Apr 2020 09:40:26 +0800
> maobibo <maobibo@loongson.cn> wrote:
>
> > On 04/13/2020 04:18 PM, Jiaxun Yang wrote:
> > > On Mon, 13 Apr 2020 15:30:09 +0800
> > > Huacai Chen <chenhc@lemote.com> wrote:
> > >
> > >> We are preparing to add KVM support for Loongson-3. VZ extension is
> > >> fully supported in Loongson-3A R4+, and we will not care about old
> > >> CPUs (at least now). We already have a full functional Linux kernel
> > >> (based on Linux-5.4.x LTS) and QEMU (based on 5.0.0-rc2) and their
> > >> git repositories are here:
> > >>
> > >> QEMU: https://github.com/chenhuacai/qemu
> > >> Kernel: https://github.com/chenhuacai/linux
> > >>
> > >> Of course these two repositories need to be rework and not suitable
> > >> for upstream (especially the commits need to be splitted). We show
> > >> them here is just to tell others what we have done, and how
> > >> KVM/Loongson will look like.
> > >>
> > >> Our plan is make the KVM host side be upstream first, and after
> > >> that, we will make the KVM guest side and QEMU emulator be
> > >> upstream.
> > >
> > > + Aleksandar as QEMU/MIPS mainatiner
> > >
> > > I was involved in KVM/Loongson development a bit and also intend to
> > > help with mainline these works.
> > >
> > > After dealing with basic LS7A PCH kernel support, I'm going to
> > > cooperate with Huacai and anyone who interested in to deal with
> > > following stuff:
> > >
> > > - Basic QEMU/TCG support for Loongson64 instructions.
> > >     Well, it seems unrelated with KVM, but that would make
> > >     development easier with cross ISA emulation. I'm not going
> > > to implement all the features like Loongson's page table fast walk
> > >     extension and binary translation extension but I'll ensure
> > > any binary compiled with march=loongson3a can run flawlessly on
> > >     TCG.
> > >
> > > - Design of Loongson-VIRT QEMU machine
> > >     It is nearly impossible to bring a real Loongson system into
> > >     QEMU. Both RS780E and LS7A PCH have tons of unreasonable
> > > design that would make the emulation extremely complex, Loongson
> > >     company's KVM implementation[1] has already proofed that,
> > >     thay're now in the hell. So we all agreed that we should
> > > build a machine from draft. I think we should reuse existing infra
> > > as far as possible to reduce our work load. I'm planing to use
> > >     pci-host-cam-generic together with VIRTIO PCI devices and a
> > >     a strip down version of loongson,liointc-1.0a to build a
> > > pure PCI based system. But if any one have better idea please just
> > >     tell us, I'm still considering how to implement SMP-IPI and
> > > ACPI stuff.
>
> Hi Bibo,
> Thanks for your response.
>
> + Xing Li as I heard he is in charge of KVM from Loongson's news post.
>
> > It is a good job to add kvm virtualization support on loongson64
> > platform. I agree that we should define common virt machine hardware
> > system, however the compiled kernel binary should be the same with
> > host system, else it will bring out trouble for customers to
> > differentiate them between guest system and host system.
>
> I'm planing to use DeviceTree to pass device information between QEMU
> and guest kernel. So we can upgrade VM design at any moment without
> breaking Host Guest kernel compatibility.
>
>
> > For pci host bridge emulation, I suggest that gpex pcie host bridge
> > should be used, since it supports pcie hotplug and arm/riscv uses
> > this pcie host bridge.
>
>
> gpex is basically a pci-host-cam-generic at kernel point of view. I'm
> planing to reuse it too.
I agree to use GPEX, and the qemu in github is updated to use GPEX.

>
> >
> > For virtual interrupt controller, it should support MSI/MSIX
> > interrupt, irqchip in kernel, IRQFD, vhost/vfio etc. I have no idea
> > how to define virtual interrupt controller now.
>
> Yes, APIC from x86 and GIC from Arm are all bonded closely with their
> architecture so we can't reuse them. Probably what we need is a
> modified version of EXTIOI from Loongson-3A4000.
>
> Does Loongson have a plan to implement hardware virtual irqchip? If so
> we must align with it's design.
>
> My plan is we can firstly implement a very simple IRQCHIP instead of
> complex one which only handle UART and PCI INTx. That is enough to make
> the system work. After that we can sit and discuss how to implement a
> complicated version to archive more features.
>
> >
> >
> > regards
> > bibo,mao
> >
> [...]
