Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128B046880F
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 23:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhLDW31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 17:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhLDW31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 17:29:27 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1346AC0613F8
        for <kvm@vger.kernel.org>; Sat,  4 Dec 2021 14:26:01 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id v64so20144937ybi.5
        for <kvm@vger.kernel.org>; Sat, 04 Dec 2021 14:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qcg0aEVPOQ3a95B0ETH9mS6ByVpwHi67XqdndVxxFvQ=;
        b=MIZKLa9Cx6Tf6Bwvb0+Z/17NPkeAlVEgERWE04/qWUXKpJ87fisyXocTBmfjKpOG81
         wvYHxqhY1+FeTsjc27qF8df8RBlVqLtziIjV+DIhO7X4xquPEIl3WJw8zHyMnnj/uVe3
         fxOnRAu44x1xpx4aYqZGVTKaN2Bw4/PxRasS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qcg0aEVPOQ3a95B0ETH9mS6ByVpwHi67XqdndVxxFvQ=;
        b=C3Q9zamt3c2B2rIDYLoaReEaWMcoDg5ssnAzBKyixk0l9J6vaHh1qZKIjMK4IWFd1W
         mbKc2eDvsljG27HxGl4xE6UkppNAljt3qP4ThaF8PTbSUu7sGRsnUlMhJ9LIz9EvYSL7
         zk7CbMJTs55uz+AFj0pUZB9ElaUqJhtfBe7iu8QVz4j2x/MFq/SiZxf2NtFan/WqTqyU
         LsQL/Wb8mDWHoA3RL/mIERxdxosgHDGQ7HVghQjB9Dz1Wqjdy1KB1f75+ngArl9f7McW
         wLA+m7FWdUCETYFd2dUoxEBfE34Kqg6nrvu4YkXUmBDqFEOy1LqJRLPI31znR/K6ej5e
         KWlA==
X-Gm-Message-State: AOAM533J69OmeWGw66ncBQP8SY0pkb2WxcrHD0FcJ8SyuLhsZjBZE2Ge
        ydPdLw/Nlt5+hHmJZmWom61rmeJ5ogcu/1b/XurS
X-Google-Smtp-Source: ABdhPJzVvqa7FoBwJ6nErsYp08ao5SKye++77MfXJmWLigHPRM/FFHyZemC5cgwIIH02w0nZQqrIF0L+JOTATQ4+19c=
X-Received: by 2002:a25:bbc4:: with SMTP id c4mr30734398ybk.309.1638656760120;
 Sat, 04 Dec 2021 14:26:00 -0800 (PST)
MIME-Version: 1.0
References: <20211202235823.1926970-1-atishp@atishpatra.org>
 <f63e9f1b-4b8e-6c3e-8e21-f9a5f97ca17d@arm.com> <CAAhSdy2xRwUmdi7Kc7ZokgB5W1LWKZ7YU-doHZ5dfaVKvzRdUg@mail.gmail.com>
In-Reply-To: <CAAhSdy2xRwUmdi7Kc7ZokgB5W1LWKZ7YU-doHZ5dfaVKvzRdUg@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Sat, 4 Dec 2021 14:25:49 -0800
Message-ID: <CAOnJCULO06SFXuJBXUGsYursBgoJk3bS9c=T9wyu3B-KhQHm3Q@mail.gmail.com>
Subject: Re: [PATCH v3] MAINTAINERS: Update Atish's email address
To:     Anup Patel <anup@brainfault.org>
Cc:     Steven Price <steven.price@arm.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 3, 2021 at 8:09 PM Anup Patel <anup@brainfault.org> wrote:
>
> On Fri, Dec 3, 2021 at 9:40 PM Steven Price <steven.price@arm.com> wrote:
> >
> > On 02/12/2021 23:58, Atish Patra wrote:
> > > I am no longer employed by western digital. Update my email address to
> > > personal one and add entries to .mailmap as well.
> > >
> > > Signed-off-by: Atish Patra <atishp@atishpatra.org>
> > > ---
> > >  .mailmap    | 1 +
> > >  MAINTAINERS | 2 +-
> > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/.mailmap b/.mailmap
> > > index 6277bb27b4bf..23f6b0a60adf 100644
> > > --- a/.mailmap
> > > +++ b/.mailmap
> > > @@ -50,6 +50,7 @@ Archit Taneja <archit@ti.com>
> > >  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
> > >  Arnaud Patard <arnaud.patard@rtp-net.org>
> > >  Arnd Bergmann <arnd@arndb.de>
> > > +Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com> <atishp@rivosinc.com>
> >
> > I don't think this does what you expect. You can't list more than one
> > email address to replace on the same line. You can use the command "git
> > check-mailmap" to test what happens, e.g. with this change applied:
> >
> >   $ git check-mailmap "<atishp@rivosinc.com>"
> >   <atishp@rivosinc.com>
> >   $ git check-mailmap "<atish.patra@wdc.com>"
> >   Atish Patra <atishp@atishpatra.org>
> >   $ git check-mailmap "<atishp@atishpatra.org>"
> >   <atishp@atishpatra.org>
> >
> > So only your @wdc.com address is translated. If you want to translate
> > the @rivosinc.com address as well you need a second line. As the file says:
>
> Thanks Steve for noticing this. Even, I realized this while queuing the patch.
>
> I have removed @rivosinc.com email address from the patch in my queue. I
> believe Atish currently uses both personal and @rivosinc.com email addresses
> on LKML.
>

Thanks!

> Refer,
> https://github.com/kvm-riscv/linux/commit/2255b100410179bb8151e99e8396debddea0ef1d
> https://github.com/kvm-riscv/linux/commits/riscv_kvm_queue
>
> Regards,
> Anup
>
> >
> > # For format details, see "MAPPING AUTHORS" in "man git-shortlog".
> >
> > Steve
> >
> > >  Axel Dyks <xl@xlsigned.net>
> > >  Axel Lin <axel.lin@gmail.com>
> > >  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 5250298d2817..6c2a34da0314 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -10434,7 +10434,7 @@ F:    arch/powerpc/kvm/
> > >
> > >  KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> > >  M:   Anup Patel <anup.patel@wdc.com>
> > > -R:   Atish Patra <atish.patra@wdc.com>
> > > +R:   Atish Patra <atishp@atishpatra.org>
> > >  L:   kvm@vger.kernel.org
> > >  L:   kvm-riscv@lists.infradead.org
> > >  L:   linux-riscv@lists.infradead.org
> > >
> >



-- 
Regards,
Atish
