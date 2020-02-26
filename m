Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76F616FA28
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgBZJCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:02:52 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:41773 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgBZJCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:02:52 -0500
Received: by mail-ua1-f66.google.com with SMTP id f7so698088uaa.8
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wB1uOzh72FfbCGOQ2QNUmORqhwJvP6j71vGmzookO3M=;
        b=j97b2qKGB7gWbywinIL8pVWZIItzLuV3ewoOJ1pJJ8dTlZPNgdRppg4S1uIzANzKq7
         AvYdjno/aRLBHOKWpVuw5YTJCb+sTVgw1IOwX/syXJrc0yXl+lSSmO+sqDSyUQxapJ8t
         xJwveieM4QftQGS0Q403ZN6xA5Z8x/jSrpOWZl1fflhSOvfHDZwDg+b2ggPApwRkLlqV
         VJZNkDbkNPEmhm993JrqsGwHlEgmWUINsPFT1Fk/1yRzZdUPXFxZjaZNcz26IfaJfQ4/
         NqUeq9iWBtzpUpu7DNFh267D/0daLrgIrCrPnHedT5GhGv4zXA9KAnRd69q+EgLEqUG/
         ccZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wB1uOzh72FfbCGOQ2QNUmORqhwJvP6j71vGmzookO3M=;
        b=c+aT7UCx9sOUYBOEa4ZV0HxeO1kBVXsboEW8Wc0ECuDCyKO+eBXylQLQU0lraKAG/9
         NiX52aU4H/dz12Mmg66v6oZvoj+h1YRkmhVYZ8TDU13XpPy6hb+5wINT2ENjPy8EiQcA
         CihLRFiFexF+I4fLBoUtjJ/zzRdL+oLdifMlwAM6Sh1/rY5Xp6+WA3/W2uieY6mbMA0N
         ZpPB/MxOq5y0357FiiB4Gg/JGXHjWUfHkr5y8DphLN6fbRqOp98rxfn1JuHPzZlMmRfB
         RycqZ3+ymKrg3FobD63QfGfSl8q2JobKDlZD+PLhrbVDS/WXfJ1CvWED7X8H8BCCCJhr
         UUGA==
X-Gm-Message-State: APjAAAVUIaZtcvFDPZ8SuVBH0/foEnZcNBV/ZUS6hGjaLohnwsZVWLGd
        pwSirfcgCmotOlp3EG5VCgdNp/DKgj0Zbqc8RTd9
X-Google-Smtp-Source: APXvYqyecuUs8lXWpD5ReXtgYaTT/BJfrhQ2WjnEnQDI9qoHV59lhWH2eJWdfi/Ufzq/6S4xvqLvpGZyizTDok4j/10=
X-Received: by 2002:a9f:24c1:: with SMTP id 59mr3169897uar.75.1582707770541;
 Wed, 26 Feb 2020 01:02:50 -0800 (PST)
MIME-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226074427.169684-3-morbo@google.com>
 <20200226075902.3ngaicupvy6ibirr@kamzik.brq.redhat.com>
In-Reply-To: <20200226075902.3ngaicupvy6ibirr@kamzik.brq.redhat.com>
From:   Bill Wendling <morbo@google.com>
Date:   Wed, 26 Feb 2020 01:02:39 -0800
Message-ID: <CAGG=3QX3repwwZ2=CNoF2F_RgZgdqKczHsMPPw_4pOXVDJ9CHA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long values
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I suspect then that how it's used in the kvm-unit-tests isn't correct.
Or at least it's not how it's used in the Linux source code. Would it
be better to cast all uses of these masks to uint32_t?

-bw


On Tue, Feb 25, 2020 at 11:59 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, Feb 25, 2020 at 11:44:22PM -0800, morbo@google.com wrote:
> > From: Bill Wendling <morbo@google.com>
> >
> > The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> > to 32-bit variables. Use 32-bit masks, since we're interested only in
> > the least significant 4-bits.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  lib/linux/pci_regs.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
> > index 1becea8..3bc2b92 100644
> > --- a/lib/linux/pci_regs.h
> > +++ b/lib/linux/pci_regs.h
> > @@ -96,8 +96,8 @@
> >  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M        0x02    /* Below 1M [obsolete] */
> >  #define  PCI_BASE_ADDRESS_MEM_TYPE_64        0x04    /* 64 bit address */
> >  #define  PCI_BASE_ADDRESS_MEM_PREFETCH       0x08    /* prefetchable? */
> > -#define  PCI_BASE_ADDRESS_MEM_MASK   (~0x0fUL)
> > -#define  PCI_BASE_ADDRESS_IO_MASK    (~0x03UL)
> > +#define  PCI_BASE_ADDRESS_MEM_MASK   (~0x0fU)
> > +#define  PCI_BASE_ADDRESS_IO_MASK    (~0x03U)
> >  /* bit 1 is reserved if address_space = 1 */
> >
> >  /* Header type 0 (normal devices) */
> > --
> > 2.25.0.265.gbab2e86ba0-goog
> >
>
> This file comes directly from the Linux source. If it's not changed
> there, then it shouldn't change here.
>
> Thanks,
> drew
>
