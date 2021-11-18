Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE345592B
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 11:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245721AbhKRKk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 05:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245686AbhKRKkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 05:40:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C68EC061766
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 02:37:24 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id u1so10547629wru.13
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 02:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zz8eDZC6xwwur+gHvMaJohiRubD6VjA06kq1bYWRgn4=;
        b=xKLPnIOMs+kZNuq5VUreKwmLFJXamaD18aFrG7L8eh8/niRFVjLgOds85L/jKKJSXQ
         45XLdDjxAlvToNXYCkcq868k1T5B7DGvQcQKj6y2jEYkKG2nYoFtrm27EEu1SMw9U6mC
         nGobP9x7fhFuci/fFhTlnRFBFVXegiS8RzTxCzjL2EU43i6E/JO8iBQSaCqQBA78zoH2
         7ReVvVka6e6Gjernc5Ku5rus83TduHFLkOe1by2r4lssfe8Yyx58G9HmbTAbL/Ow6LrX
         sPtsvDOCIl+4HCRUwR0Cs4v901LP0vSvIurcUzA35HT7SxKq9e7WYpSKJ0TJ6d64oUSN
         9KEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zz8eDZC6xwwur+gHvMaJohiRubD6VjA06kq1bYWRgn4=;
        b=htblhHogABBH1MAC6kRY07qsxEOmQ4ZaGexHHCdCC1SexFv1S4w7jWkUYRy6Wr/RRq
         +s7tfT2qUJx+FQVcPZ9M+Loo1lVrksUpHZU77T6wz/1mfDgU1/UcZDTKE5CSe0C5lZqw
         ghr0OlGX4TIlHBLGR/8vm+X0mqeT+455YLRfJDw1sPkMrgK7vdXiRMKzGc7W1TT9OEzI
         Vw96k/JO7l0dYk/GxMIA0TXhAMxPsHSzDqX6E3B3Iwp2X2H6JNT4M3XUwMuUOh8XetLg
         FY0Phfj8+S7TcsZNKqnQrqcF35MTsvABMi5jblfX2t7A6ScYUkf+f2Zc4AlArX6pEcOA
         eqFw==
X-Gm-Message-State: AOAM533YhynO13hOuSgh7F8w52jW1nd7OsQZTXc2uVixYFOOHHEECPTG
        HnDKJlG7DTMWPjt8GxGJROIRWbxzrpi76cFTzPXd7Q==
X-Google-Smtp-Source: ABdhPJxUn4E6Ct+2cmiknAcAd/Lr1Cr6Ofttmjt6vr29kNJf3RG5EmKVa7Kqa5dR44tDwLAIrKkRQ1Wmbb2ya9rdsIo=
X-Received: by 2002:a5d:4846:: with SMTP id n6mr28716674wrs.249.1637231843057;
 Thu, 18 Nov 2021 02:37:23 -0800 (PST)
MIME-Version: 1.0
References: <20211116052130.173679-1-anup.patel@wdc.com> <20211116052130.173679-6-anup.patel@wdc.com>
 <87mtm17ovr.wl-maz@kernel.org>
In-Reply-To: <87mtm17ovr.wl-maz@kernel.org>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 18 Nov 2021 16:07:11 +0530
Message-ID: <CAAhSdy1_3kGBUwBFAqtx6yDh2MduY_HQYrhVXcn5KfveJxJRDQ@mail.gmail.com>
Subject: Re: [PATCH v10 kvmtool 5/8] riscv: Add PLIC device emulation
To:     Marc Zyngier <maz@kernel.org>
Cc:     Anup Patel <anup.patel@wdc.com>, Will Deacon <will@kernel.org>,
        julien.thierry.kdev@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        Vincent Chen <vincent.chen@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 3:43 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 16 Nov 2021 05:21:27 +0000,
> Anup Patel <anup.patel@wdc.com> wrote:
> >
> > The PLIC (platform level interrupt controller) manages peripheral
> > interrupts in RISC-V world. The per-CPU interrupts are managed
> > using CPU CSRs hence virtualized in-kernel by KVM RISC-V.
> >
> > This patch adds PLIC device emulation for KVMTOOL RISC-V.
> >
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > [For PLIC context CLAIM register emulation]
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > ---
> >  Makefile                     |   1 +
> >  riscv/include/kvm/kvm-arch.h |   2 +
> >  riscv/irq.c                  |   4 +-
> >  riscv/plic.c                 | 518 +++++++++++++++++++++++++++++++++++
> >  4 files changed, 523 insertions(+), 2 deletions(-)
> >  create mode 100644 riscv/plic.c
> >
>
> [...]
>
> > +static void plic__context_write(struct plic_state *s,
> > +                             struct plic_context *c,
> > +                             u64 offset, void *data)
> > +{
> > +     u32 val;
> > +     bool irq_update = false;
> > +
> > +     mutex_lock(&c->irq_lock);
> > +
> > +     switch (offset) {
> > +     case CONTEXT_THRESHOLD:
> > +             val = ioport__read32(data);
> > +             val &= ((1 << PRIORITY_PER_ID) - 1);
> > +             if (val <= s->max_prio)
> > +                     c->irq_priority_threshold = val;
> > +             else
> > +                     irq_update = true;
> > +             break;
> > +     case CONTEXT_CLAIM:
> > +             val = ioport__read32(data);
> > +             if (val < plic.num_irq) {
> > +                     c->irq_claimed[val / 32] &= ~(1 << (val % 32));
> > +                     irq_update = true;
> > +             }
>
> This seems to ignore the nasty bit of the PLIC spec where a write to
> CLAIM is ignored if the interrupt is masked.

Sure, I will update the CLAIM write emulation to ignore
masked interrupts.

Thanks for catching.

Regards,
Anup

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
