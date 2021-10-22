Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7700F43763A
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 13:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhJVL6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 07:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhJVL6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 07:58:19 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A40DC061766
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 04:56:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so2278820wmz.2
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 04:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GfBU0GpSmy79GbH1anUO6sQjWFqwumWH7YxWakuinzc=;
        b=tWFAlFo6sqxss1FMA0XqNpWM7eRhtkHwtdMZr7zjgIb9Kk1jFDMx8krC6Pb6mRQJaB
         YVlYtaP1wZZWcAIaqOa3C8Og9j133Gm0PjCPtNTZycCwAwGHM4UIaSAzKegCraumHUGv
         dpUQ8+yZex7bLvyKOSSG/AZ2J1OernkkHlGRiAcIkbd11zkrEMqmmdJ7L0aBsbQGht97
         73yRbPa0l6tjQwWs5yRdKAsPp3i3/kVscHlz7wmqgWkqPNxcWSm1jbdCXHbO+CqRJEdB
         u1ODdswp9XwhcF2Gg8cDf+JBaZJZXIMThDP9nPL1xI6qdhI5XPKP/sQuCqOZf39UcAKY
         KHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfBU0GpSmy79GbH1anUO6sQjWFqwumWH7YxWakuinzc=;
        b=5C/RdOT4P+GEgKkjWaQ1GKKJhl5P9wj7VFoFGTscxnnt9s6EE60N3l0TuDUUAbV/Ue
         B/KxFKbgS4PPp+1MC06ZuW11Ib89MLmk9autSoCI2+/nw5Lwu4Xbq+45yLhQ3RdgGgoy
         XsZgdoC17GffUszDyFBKI3w4gExKU3RYsx7WR9DjrKMrjhOo/UV4scIx+NPxvN3ZcCAz
         jESl7vfoRHcV/qNWvv5SBNPxbk3ElgDtw3JY4Pal9bymWS9KHpqIs81A8vdDLs0mEQKS
         Kl4ZwvQ6/GKd2HetNyGRFXF6pLJIA/ghZLZ4NNZCrLBzCjOJ+kXC3zQWccNUsaSYUU/W
         6nSA==
X-Gm-Message-State: AOAM5337s0VmsBPP0IA5w6ns6QDr24/aiZ1YoHUkzCdgZM801PIF7fIL
        KnzUJDVwlLTbI+pp/DVp+pX9wegvDESgk3eHudi60Q==
X-Google-Smtp-Source: ABdhPJyje0rIg0VhIHC70ks2ose2WVfVFBCEjQcBhQxEnJNRdtAXMllSDvh8stJgNdMbceG5aDtLDTWNxC9gMg0twV0=
X-Received: by 2002:a1c:7918:: with SMTP id l24mr13289169wme.137.1634903759923;
 Fri, 22 Oct 2021 04:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211022061514.25946-1-lukas.bulwahn@gmail.com> <5c27a2ff-b7a2-99d8-bdc4-7f2b20092500@redhat.com>
In-Reply-To: <5c27a2ff-b7a2-99d8-bdc4-7f2b20092500@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 22 Oct 2021 17:25:48 +0530
Message-ID: <CAAhSdy0h38gOZ-7WKDN=SLBhC0pbRjXS19XyU9eu-PzUi3Xv7A@mail.gmail.com>
Subject: Re: [PATCH] riscv: do not select non-existing config ANON_INODES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021 at 3:24 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/10/21 08:15, Lukas Bulwahn wrote:
> > Commit 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support") selects
> > the config ANON_INODES in config KVM, but the config ANON_INODES is removed
> > since commit 5dd50aaeb185 ("Make anon_inodes unconditional") in 2018.
> >
> > Hence, ./scripts/checkkconfigsymbols.py warns on non-existing symbols:
> >
> >    ANON_INODES
> >    Referencing files: arch/riscv/kvm/Kconfig
> >
> > Remove selecting the non-existing config ANON_INODES.
> >
> > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > ---
> >   arch/riscv/kvm/Kconfig | 1 -
> >   1 file changed, 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> > index a712bb910cda..f5a342fa1b1d 100644
> > --- a/arch/riscv/kvm/Kconfig
> > +++ b/arch/riscv/kvm/Kconfig
> > @@ -22,7 +22,6 @@ config KVM
> >       depends on RISCV_SBI && MMU
> >       select MMU_NOTIFIER
> >       select PREEMPT_NOTIFIERS
> > -     select ANON_INODES
> >       select KVM_MMIO
> >       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >       select HAVE_KVM_VCPU_ASYNC_IOCTL
> >
>
> Queued, thanks.

Thanks Paolo for applying this directly.

Regards,
Anup

>
> Paolo
>
