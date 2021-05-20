Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B8A38AE4F
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhETMeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240796AbhETMeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:34:25 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52841C049EB0;
        Thu, 20 May 2021 04:40:35 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id y36so5764507ybi.11;
        Thu, 20 May 2021 04:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOKexcaIw4g2vbrwnKp/g+ph6O5XnE0uXT4mDO7PWv8=;
        b=GnJFb+uRtqee1qkdkQxzXg1Y+2KQ5NDp0kgEXxos+702pxqs64ye7RvB2WTT8j4Agk
         xvbcvm92rG/xl/JYAWmOda1E+BRfOtTRuWYIqObGt5jvH1I9mfhTAxkFC4Ywj2yry9p0
         7pKidPRp4Du3ztmXXWqDBUghuF+36OciigUJvtX3ED1n5JNPRIdz21sUrDRbcBqcS434
         X6Fqr2KsD8PRdmHZc6sJpc3ZXZm1fYLOMd4r0kl2wEvIkpLJyRXEXkCNK60Z6hbf9IKX
         hnWvBf//ruPYWW/GieQYuUuCKtHLs2i6T3Be9K3KslrrzOj72HtWPeARl+BJiwmzl+oJ
         G32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOKexcaIw4g2vbrwnKp/g+ph6O5XnE0uXT4mDO7PWv8=;
        b=NPfHnhF/n5CZmkF/zdQg/SVBUjaLD11F4+uab5ltzwD82axb1hqqwA45VMu6UXMaV/
         P7KOs2q8WVtuiB8pdCg1SAnOI/9vkMuISfscGEgABNozudnHDwUQmpiXCW29DNray6ds
         IS8um1h52IJO9WB83QCC5wYvonvErryQxlMW7jRlVnh6TUTmQB0KtDBWh4SLu6RdIccQ
         8817aRkM0bSho8cpgBhfVn4Wta9Vzy+UIld1I/a0/WhoxVq8OSBTTtGvKTD5zuDb9E5m
         myM1IBJLzbOuQUWrBeRtbDY/cQpPsYMfVNyBM3oiufLTA4xxmoW78F4wS4WIsJ1Ss+6Q
         o/2Q==
X-Gm-Message-State: AOAM533zvlxq7eSsyLOxvyAWa72+86dBopHn6r4I0yzcdaJa7hn1pvMw
        e3JrQ2rz2/Vi0G6/CbF/sCjamUocSXbZsHc3kmI=
X-Google-Smtp-Source: ABdhPJxMCd99LMdMXUg+BnOiV3mkGMsYuFGUgUpYt2rcFslbZo0dMYlj9vDhbVi2LIGAwBtL/bcFZnxVi5ZPgJVOMV0=
X-Received: by 2002:a25:6d89:: with SMTP id i131mr7000838ybc.148.1621510834531;
 Thu, 20 May 2021 04:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210520104343.317119-1-joerichey94@gmail.com> <20210520111119.GC17233@C02TD0UTHF1T.local>
In-Reply-To: <20210520111119.GC17233@C02TD0UTHF1T.local>
From:   Joseph Richey <joerichey94@gmail.com>
Date:   Thu, 20 May 2021 04:40:23 -0700
Message-ID: <CAAXkRofTpf7R31V8vQOghkzWL+Ofqu0eCNV-WOmpm8pmpTvtLg@mail.gmail.com>
Subject: Re: [PATCH 0/6] Don't use BIT() macro in UAPI headers
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     trivial@kernel.org, Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 4:11 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> Hi,
>
> On Thu, May 20, 2021 at 03:43:37AM -0700, Joe Richey wrote:
> > From: Joe Richey <joerichey@google.com>
> >
> > The BIT(n) macro is used in the kernel as an alias for (1 << n).
> > However, it is not defined in the UAPI headers, which means that any
> > UAPI header files must be careful not to use it, or else the user
> > will get a linker error.
>
> Beware that the common definition of BIT() (in include/vdso/bits.h) is:
>
> | #define BIT(nr)                 (UL(1) << (nr))
>
> That UL() can be important if `nr` is ever greater than bits per int.
>
> > For example, compiling the following program:
> >
> >     #include <sys/auxv.h>
> >     #include <asm/hwcap2.h>
> >
> >     // Detect if FSGSBASE instructions are enabled
> >     int main() {
> >         unsigned long val = getauxval(AT_HWCAP2);
> >         return !(val & HWCAP2_FSGSBASE);
> >     }
> >
> > Results in the following likner error:
> >
> >     /usr/bin/ld: /tmp/cceFpAdR.o: in function `main':
> >     gs.c:(.text+0x21): undefined reference to `BIT'
> >
> > This patch series changes all UAPI uses of BIT() to just be open-coded.
>
> In include/uapi/linux/const.h we have an equivaleint _BITUL() macro,
> which I think should be used in preference of open-coding this (and is
> already used in a number of uapi headers).

That's a good idea. I mostly just did the open-coding for
consistency with the surrounding code, but aside from kvm.h
there aren't really many usages to change, so I can do it.

For kvm.h, I think it might be best to leave it open-coded
and move the entire file to _BITUL() at once.

>
> > However, there really should be a check for this in checkpatch.pl
> > Currently, the script actually _encourages_ users to use the BIT macro
> > even if adding things to UAPI.
>
> I think having something that suggests s/BIT()/_BITUL()/ under uapi
> would be good.

I'll just change the script to recommend _BITUL() (instead
of BIT()) if the code path contains "uapi".

>
> Thanks,
> Mark.
>
> >
> > Running `rg "BIT\(" **/uapi/**` shows no more usage of BIT() in any
> > UAPI headers. Tested by building a basic kernel. Changes are trivial.
> >
> > Joe Richey (6):
> >   x86/elf: Don't use BIT() macro in UAPI headers
> >   KVM: X86: Don't use BIT() macro in UAPI headers
> >   drivers: firmware: psci: Don't use BIT() macro in UAPI headers
> >   uacce: Don't use BIT() macro in UAPI headers
> >   media: vicodec: Don't use BIT() macro in UAPI headers
> >   tools headers UAPI: Sync pkt_sched.h with the kernel sources
> >
> >  arch/x86/include/uapi/asm/hwcap2.h   |   2 +-
> >  include/uapi/linux/kvm.h             |   4 +-
> >  include/uapi/linux/psci.h            |   2 +-
> >  include/uapi/linux/v4l2-controls.h   |  22 ++---
> >  include/uapi/misc/uacce/uacce.h      |   2 +-
> >  tools/include/uapi/linux/kvm.h       |   4 +-
> >  tools/include/uapi/linux/pkt_sched.h | 122 ++++++++++++++++++++++++---
> >  7 files changed, 130 insertions(+), 28 deletions(-)
> >
> > --
> > 2.31.1
> >
