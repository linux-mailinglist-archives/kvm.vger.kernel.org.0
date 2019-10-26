Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B344E583F
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 05:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZDWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 23:22:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38127 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfJZDWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 23:22:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id v9so4406783wrq.5
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 20:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDkPt2vxGvwt3QPswZka6NmewYvhNdxaRnBgmjWNMNE=;
        b=C9LwTpoMiaGEtarmKKTOEugKrY4v8PqKTr/nwd8Q6hsQ0nXW13bIbP+NnYd8Zvv+Fu
         rZ+9G77bPVots2ydjdBiOh9zuet8WyKKEyOBGhEkknv5Me+seTlOfxgxy0GiRD4vxU3N
         dy9s9GpEj1dYi8+E9wftSWMDmtnsuw0o+zgvOHHvCkWvwK2WZf2E4TBaI8hdZC3H0uUA
         VFikOoun+D4A5NnI/tYjBEBX9r35NzIbkqSON1Sa/RT1x6hQjDlPwHiKOevFW9W9vKmq
         NkPp/8DD38VvRZ9FLUFWSqRpdnKG6jlP8HTBD4GXjW8h9s+MmJZeW42sEoeGFkkUfx/i
         VlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDkPt2vxGvwt3QPswZka6NmewYvhNdxaRnBgmjWNMNE=;
        b=U5NvoEoxW5svs/6GIKh05hZCM4JKm4SqqC8PNR7TcoOm27D7G2487npsL+aGxnl1Gt
         Ojj8uXRW1PbF07uNuE9fxSNWY9G1og9xYItRkaRz43pTFOXrovWfuOX3QEzA7qCvh2/s
         clk8S/hnwtrCC7vBJf8Hb2E02obg30gdQYntLdgeVULbe0sdb3zxC+q3KUmw11oE0mnr
         cW/nL42bLu+/SZCrm7lQMZtwA/jXmrItTSAog4mAmBMLH18K1QvyM7XL/TllAuFq0vAn
         6m+IU2H30ZqjIHtH1RChmt+RWqIU2N4V1L0wR/A5L/PFv7pqNQiTZK547VkaIcLiw4Pm
         AloA==
X-Gm-Message-State: APjAAAXtzb/Zf2QItv/lAO7SLO3ew1ndMIlQnWyK0cV7lVCYpUX4RfLP
        y9Eo8VoThRZrTtmVDceYb86ryR9vRGEAl8iL1eCuWg==
X-Google-Smtp-Source: APXvYqzGZAwZcrHBPmOgmCPHvyvMfVI74sgWBPVAhX27aA6UWJHfjZjS6tcIVVoOKyt4lXWyW/tRQWr+XDi0GMbCxqI=
X-Received: by 2002:a05:6000:351:: with SMTP id e17mr5324719wre.96.1572060147773;
 Fri, 25 Oct 2019 20:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160649.24622-1-anup.patel@wdc.com> <alpine.DEB.2.21.9999.1910251609500.12828@viisi.sifive.com>
In-Reply-To: <alpine.DEB.2.21.9999.1910251609500.12828@viisi.sifive.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 26 Oct 2019 08:52:16 +0530
Message-ID: <CAAhSdy1zfL2kPM-Le6TZSqS2TU1RkgC+zTbB4y31t8TXwVjhEg@mail.gmail.com>
Subject: Re: [PATCH v9 00/22] KVM RISC-V Support
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
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

On Sat, Oct 26, 2019 at 4:40 AM Paul Walmsley <paul.walmsley@sifive.com> wrote:
>
> Hi Anup,
>
> On Wed, 16 Oct 2019, Anup Patel wrote:
>
> > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > RISC-V 64bit Linux Guests with multiple VCPUs.
> >
> > Few key aspects of KVM RISC-V added by this series are:
> > 1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
> > 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
> > 3. KVM ONE_REG interface for VCPU register access from user-space.
> > 4. PLIC emulation is done in user-space.
> > 5. Timer and IPI emuation is done in-kernel.
> > 6. MMU notifiers supported.
> > 7. FP lazy save/restore supported.
> > 8. SBI v0.1 emulation for KVM Guest available.
> > 9. Forward unhandled SBI calls to KVM userspace.
> > 10. Hugepage support for Guest/VM
>
> Several patches in this series cause 'checkpatch.pl --strict' to flag
> issues.  When you respin this series, could you fix those, please?

I generally run checkpatch.pl every time before sending patches.

I will try checkpatch.pl with --strict parameter as well in v10 series.

Regards,
Anup

>
>
> thanks,
>
> - Paul
