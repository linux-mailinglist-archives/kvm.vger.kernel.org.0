Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250F7486163
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 09:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiAFIZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 03:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiAFIY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 03:24:58 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47B2C061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 00:24:57 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v123so1232700wme.2
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 00:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=18Hu6pHHT8+wZmsysRD7OPc1d8jjkREA01CkZ/k2MYA=;
        b=r0aiCYND3F+tbMUHcd7XhNoB3Mw/LTUGw0E9YDG0Q1zIruDQYML+d4J588HgU74/Jn
         jRu9exVOo2yY8ny8OC49x4fqLBbTmS945tf3JSHSKgnJkOpY/Zh2oiykVTE0n9hvhMqt
         1zwj8pixwWVV/p6oE8CPwlDOfx/oBTrj8n6iOOJ1wKjcYj1JqjT0cvkoWy7klZne76bJ
         Jmct9SiASlC6NXzUbzxHul1eL6Y5xKD2gCv+2BHyDPl/1ayiO+On/BubZ+c9sKIVhXm+
         Tr6oXZDxRTRbsLkUpOZ1qPLHAe0aXbrH/fWj/qQIMDNDoWhWlX5GpxyGM/2cM6yRP1VP
         yEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=18Hu6pHHT8+wZmsysRD7OPc1d8jjkREA01CkZ/k2MYA=;
        b=AHbN1RwJHYPv8yKosrWnXBoIx/f82d90LUjn4/eN43vo1LRZcCRaAW97gOaBbEipGc
         YOtTDZ/DX94S7ByZgc3JfI2YBW2juYDeEDaN8YVzh84CD/zxJb41lSrjn1OOOvU4bqRe
         fKF4VOr7KFMHa3F9/JAFqshUt4Mxp38tI1aIi6+SUFHNFy01PHd12Is4zbtB5sGY7VsD
         hCfUb9vp/rFRoUCVi2J5NW48y+ijs+JzUkvfMApWYqTKAG5UgptL/a67a2lvpiz6OSuh
         TNid08E4RTqQ7ZOa7WDc8UhBc6bKr5Y4yqyYnDC6QoCc/EeEKiC81H2yhNXRuZcvQnaC
         0png==
X-Gm-Message-State: AOAM533nre38Of0ZmJfdN3SkBLE2UK3uHIGps/e8MZVsfsNQ4og4ubVX
        3SUCaFk58+fRJlhqWp6FIwweGPsIqlPRtIWpa+y96Q==
X-Google-Smtp-Source: ABdhPJwypdPCTyuWbVbVQiwnWTjO+ZwD0lE2C7hOstG24vnO0DT7pW9BbGPMqwZce4soAaiPqm+KjnxsUIsriXFUAvY=
X-Received: by 2002:a05:600c:1da5:: with SMTP id p37mr6170286wms.59.1641457496207;
 Thu, 06 Jan 2022 00:24:56 -0800 (PST)
MIME-Version: 1.0
References: <20220103133759.103814-1-anup@brainfault.org> <CAOnJCUJkVT9W6X+oe1CHjnHLUFs11Z_3qeXnats9pUcxCUiDPw@mail.gmail.com>
In-Reply-To: <CAOnJCUJkVT9W6X+oe1CHjnHLUFs11Z_3qeXnats9pUcxCUiDPw@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 6 Jan 2022 13:54:43 +0530
Message-ID: <CAAhSdy0CTwQn3PJER2H3snYA0D9y9f=nN3PCGxvVH_n7zFdZQA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update Anup's email address
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 4, 2022 at 1:37 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Mon, Jan 3, 2022 at 5:38 AM Anup Patel <anup@brainfault.org> wrote:
> >
> > I am no longer work at Western Digital so update my email address to
> > personal one and add entries to .mailmap as well.
> >
> > Signed-off-by: Anup Patel <anup@brainfault.org>
> > ---
> >  .mailmap    | 1 +
> >  MAINTAINERS | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/.mailmap b/.mailmap
> > index e951cf1b1730..f5d327f0c4be 100644
> > --- a/.mailmap
> > +++ b/.mailmap
> > @@ -46,6 +46,7 @@ Andy Adamson <andros@citi.umich.edu>
> >  Antoine Tenart <atenart@kernel.org> <antoine.tenart@bootlin.com>
> >  Antoine Tenart <atenart@kernel.org> <antoine.tenart@free-electrons.com>
> >  Antonio Ospite <ao2@ao2.it> <ao2@amarulasolutions.com>
> > +Anup Patel <anup@brainfault.org> <anup.patel@wdc.com>
> >  Archit Taneja <archit@ti.com>
> >  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
> >  Arnaud Patard <arnaud.patard@rtp-net.org>
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3e8241451b49..aa7769f8c779 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10443,7 +10443,7 @@ F:      arch/powerpc/kernel/kvm*
> >  F:     arch/powerpc/kvm/
> >
> >  KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> > -M:     Anup Patel <anup.patel@wdc.com>
> > +M:     Anup Patel <anup@brainfault.org>
> >  R:     Atish Patra <atishp@atishpatra.org>
> >  L:     kvm@vger.kernel.org
> >  L:     kvm-riscv@lists.infradead.org
> > --
> > 2.25.1
> >
>
> Acked-by: Atish Patra <atishp@rivosinc.com>

I have queued this patch for 5.17

Thanks,
Anup

>
>
> --
> Regards,
> Atish
