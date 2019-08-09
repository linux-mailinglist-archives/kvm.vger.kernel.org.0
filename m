Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD97875DF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 11:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406077AbfHIJ1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 05:27:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40749 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfHIJ1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 05:27:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so97545050wrl.7
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLdmDC9KjK8wHYH/YMGOndzUePeH788tGhoJ+JIDrPM=;
        b=E/Vu0yrEkOThSq9wuddnkRFUhVX217tVcF3EL/LqSZyuKCRyKIxRjF9CXhrEEAHERj
         Q78KpXScVLFUeq0sJzV1UbMno/4roNOmcTPmtp6LDPxIEZxgoKmDFXbxJsW35JfksSg4
         up7eANYH6DWzkqrrxbbsvvQMy/Pmr+PbSKNtpjS795l/bRS6ltOGZHD40QmAaTSzoX8+
         qZrtihKBmIh/EeryTVirjIksEkj1jr2S4QJbSL+HBW6jt70MrpB1de5QbKFjISaqb2UA
         VuP7HE4kdZjsx0Mjv+N8fjLsV5esiL3mqw89fVOMfZRHQ8T0v9SKQZ4KA/eBMNA/5j1I
         NVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLdmDC9KjK8wHYH/YMGOndzUePeH788tGhoJ+JIDrPM=;
        b=mRH4GpIwSWQQN86uE+bTTuK+BYiCyO8Cwnwkiw/GXICHBCT29bzaAXZX6S9b5yqHNO
         34re73ko+A4Bn6Ls9YoaN/ai9t7Ue5bMX1cglrbM1lCYexBbxaCQ9ozm39ASwevE0GQK
         ZKFQ+HRv0Lr8eZDHtIwvcOBXKqRwsPCcxZ2K4h5OPU5ryQq5x7rE5ps0IGwZF+GvmHm0
         VzCXpI07FzQ24lCO5K60ONlcyLfZTt+urEr5JS5c+WXMoC2bMQ6lFUpjk/T4cndiIpNG
         Ves2MpxE8/KFrgM7VNF7l6yMVcGlJ9CtSPxRHlTBgohHqVa6jY9+e1wwpjYUlSzYpiXo
         p+jQ==
X-Gm-Message-State: APjAAAV/5gCPM8QiRrHTvVzjIEpqEOUWI+MJN+9oKM4ZPzziKGs5r2NE
        aAyivIBnMzxmtv9CY2n/z18/jRk/MK283KitoFZvBQ==
X-Google-Smtp-Source: APXvYqxB1pzR3hxupojw9Egj6YewSb1YvyESNLOa/iAcw0xgJGG8uNiUTWLKLCG/1fQBkubFwECh5h4lkT0KrD5JV44=
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr21389392wra.328.1565342818831;
 Fri, 09 Aug 2019 02:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190807122726.81544-1-anup.patel@wdc.com> <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
 <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
 <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com> <alpine.DEB.2.21.9999.1908081824500.21111@viisi.sifive.com>
 <2ea0c656-bd7e-ae79-1f8e-6b60374ccc6e@redhat.com> <CAAhSdy1Hn69CxERttqa39wWr1-EYJtUPSG7TZnavZQqnMOHUqA@mail.gmail.com>
 <97987944-b42f-4f51-acfb-f318b41875bc@redhat.com>
In-Reply-To: <97987944-b42f-4f51-acfb-f318b41875bc@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 9 Aug 2019 14:56:47 +0530
Message-ID: <CAAhSdy2-72mJWMyeBrOgp0m=FKRKdDOuj8aoyEwJcTG20tDUtg@mail.gmail.com>
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

On Fri, Aug 9, 2019 at 2:30 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/08/19 10:22, Anup Patel wrote:
> >> the L here should be kvm@vger.kernel.org.  arch/riscv/kvm/ files would
> >> still match RISC-V ARCHITECTURE and therefore
> >> linux-riscv@lists.infradead.org would be CCed.
> > In addition to above mentioned lists, we insist of having a separate
> > KVM RISC-V list which can be CCed for non-kernel patches for projects
> > such as QEMU, KVMTOOL, and Libvirt. This KVM RISC-V list can also
> > be used for general queries related to KVM RISCV.
>
> You can use kvm@vger.kernel.org for that, with CCs to the other
> appropriate list (qemu-devel, libvir-list, LKML, linux-riscv, etc.).
> But if you want to have kvm-riscv, go ahead and ask for it.
>
> In any case, you can send v5 with all R-b and Acked-by and a fixed
> MAINTAINERS entry (listing kvm@vger for now), and Paul will apply it.
> For 5.5 you can start sending patches to me, either for direct
> application to the KVM tree or as pull requests.

Sure, I will send v5 early next week.

Regards,
Anup
