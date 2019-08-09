Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4694873EC
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 10:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405671AbfHIIWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 04:22:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50398 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfHIIWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 04:22:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so4823355wml.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 01:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNp+g/vzuyou+8SOuxEdKIcRZJyNxl5KwEsu62IXuGU=;
        b=McbvzcBJfP+h0NnjsTTuaoLwxpZGA7dGjabt7my3rltA7R0trFNTKNQComMgOJzJOx
         slP5Yw4Qdp30DslmvJ4o8MfRdsPKZu9phvRP7U/sYWn9kGp6VKO/MIF8JuIFkVXaa4rf
         T33OYcFUVPzUdwE8Zg0xFX6KV8MbR6VpklDwVUby0z6XD3f7N7n6DVqUGjbltAFwRRus
         +kP+FHDnZZ8F2EXny8Pc4toQheMVEfLe1PPkHfByRfJfjJGPfbkT+w9+Mvy2xaagI0zd
         BFfUkF54ag0sA9pHCm8TDOElD7Y8Luo/9q54gkNIswD/IIk1OXcEqp6R6LGmuh7N9NiU
         AMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNp+g/vzuyou+8SOuxEdKIcRZJyNxl5KwEsu62IXuGU=;
        b=WVcYRR/Wy6xscaaykU22rJ+vOPeH3APgURazZ04gtzH2iBn+hd1BUQxCIvYy7nWNy/
         CDcjssNHlQ030KDaKnHBLXdNZzPk5mRdGneUu6NiNrEiCIT0fLNlcmbjxof2X9z5KHGn
         d8STXuZHe96aoXrZFZXYF0XzIV0AOnquISg4LatOcrIKNIBBWtWzISt5Yq1ITVhUH6Bd
         P196luES9pf6T6PpwpXIlrhk2l0TXW0OkMCxgXRJA1V4Lr06dOl4h1dDYgAeorvrl1XG
         90mkaKsGfUjXg/tIu0D547aDHBVnNmFWYG2RBT5HH4q0peoHoA+5PufMLOwJG2cKprSn
         NgMw==
X-Gm-Message-State: APjAAAW8UdD4KHUJCf/trE/V4nAua0o2p8A9H3FH626olLtelIvHTAMI
        CHRL4NB579iXEPXydgnhTr6f219Pnt2ryxJf7U5Wgw==
X-Google-Smtp-Source: APXvYqwp3nuRKA8dCG1GKtRTblI3EushHwDGCgL1HJWLLG1enXfHuScwMYxlxKAy5IYXAC+HAEaXftvzSe9EONOIJ/E=
X-Received: by 2002:a1c:be05:: with SMTP id o5mr9482966wmf.52.1565338968612;
 Fri, 09 Aug 2019 01:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190807122726.81544-1-anup.patel@wdc.com> <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
 <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
 <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com> <alpine.DEB.2.21.9999.1908081824500.21111@viisi.sifive.com>
 <2ea0c656-bd7e-ae79-1f8e-6b60374ccc6e@redhat.com>
In-Reply-To: <2ea0c656-bd7e-ae79-1f8e-6b60374ccc6e@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 9 Aug 2019 13:52:36 +0530
Message-ID: <CAAhSdy1Hn69CxERttqa39wWr1-EYJtUPSG7TZnavZQqnMOHUqA@mail.gmail.com>
Subject: Re: [PATCH v4 00/20] KVM RISC-V Support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 9, 2019 at 1:07 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/08/19 03:35, Paul Walmsley wrote:
> > On Thu, 8 Aug 2019, Paolo Bonzini wrote:
> >
> >> However, for Linux releases after 5.4 I would rather get pull requests
> >> for arch/riscv/kvm from Anup and Atish without involving the RISC-V
> >> tree.  Of course, they or I will ask for your ack, or for a topic
> >> branch, on the occasion that something touches files outside their
> >> maintainership area.  This is how things are already being handled for
> >> ARM, POWER and s390 and it allows me to handle conflicts in common KVM
> >> files before they reach Linus; these are more common than conflicts in
> >> arch files. If you have further questions on git and maintenance
> >> workflows, just ask!
> >
> > In principle, that's fine with me, as long as the arch/riscv maintainers
> > and mailing lists are kept in the loop.  We already do something similar
> > to this for the RISC-V BPF JIT.  However, I'd like this to be explicitly
> > documented in the MAINTAINERS file, as it is for BPF.  It looks like it
> > isn't for ARM, POWER, or S390, either looking at MAINTAINERS or
> > spot-checking scripts/get_maintainer.pl:
> >
> > $ scripts/get_maintainer.pl -f arch/s390/kvm/interrupt.c
> > Christian Borntraeger <borntraeger@de.ibm.com> (supporter:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> > Janosch Frank <frankja@linux.ibm.com> (supporter:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> > David Hildenbrand <david@redhat.com> (reviewer:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> > Cornelia Huck <cohuck@redhat.com> (reviewer:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> > Heiko Carstens <heiko.carstens@de.ibm.com> (supporter:S390)
> > Vasily Gorbik <gor@linux.ibm.com> (supporter:S390)
> > linux-s390@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> > linux-kernel@vger.kernel.org (open list)
> > $
> >
> > Would you be willing to send a MAINTAINERS patch to formalize this
> > practice?
>
> Ah, I see, in the MAINTAINERS entry
>
> KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> M:      Anup Patel <anup.patel@wdc.com>
> R:      Atish Patra <atish.patra@wdc.com>
> L:      linux-riscv@lists.infradead.org
> T:      git git://github.com/avpatel/linux.git
> S:      Maintained
> F:      arch/riscv/include/uapi/asm/kvm*
> F:      arch/riscv/include/asm/kvm*
> F:      arch/riscv/kvm/
>
> the L here should be kvm@vger.kernel.org.  arch/riscv/kvm/ files would
> still match RISC-V ARCHITECTURE and therefore
> linux-riscv@lists.infradead.org would be CCed.

In addition to above mentioned lists, we insist of having a separate
KVM RISC-V list which can be CCed for non-kernel patches for projects
such as QEMU, KVMTOOL, and Libvirt. This KVM RISC-V list can also
be used for general queries related to KVM RISCV.

>
> Unlike other subsystems, for KVM I ask the submaintainers to include the
> patches in their pull requests, which is why you saw no kvm@vger entry
> for KVM/s390.  However, it's probably a good idea to add it and do the
> same for RISC-V.

For KVM RISC-V, we will always CC both kvm@vger.kernel.org and
linux-riscv@lists.infradead.org.

Regards,
Anup
