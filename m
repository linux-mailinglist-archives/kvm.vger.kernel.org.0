Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB653360A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 19:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfFCRG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 13:06:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37918 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbfFCRG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 13:06:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so10266397pfa.5
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HYJoR/zfyv70Em+OIILglCe3XWuiH6p+K727C24pDAs=;
        b=XymoGc7JWCRKHtM+wd/9hGi9VWGsUM72Lwa90KnvQJ358uEmtUgcHoKdtU9g/YH4UJ
         5u34zZdjU4FRJazo1vFuW3Ni1y1DNZVh/alS1ECRtC3BF7TZUH+GUyZUoEV1ZTcu35tt
         nObul5i9lrx30r8a/e6JYyssLeymB2ctqES0N7//YxV4uMKqEsaUeN3+PzxtLJVdrwsh
         Z/k985v/01dgnrGjVh59cUp9Nom/0K7l3TgAT4n5WZQPD1vgp3vkfuUimZ+Xh+PsD+fW
         QdzcgoJaWOtWSqcWc9IK1QohrHJZ7wW5wsfUIytyUhIb0Cs9PUborvrLgVelRcAz9JGB
         usaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HYJoR/zfyv70Em+OIILglCe3XWuiH6p+K727C24pDAs=;
        b=G8xarU5pxhjjF/Wf5+WVFZdzrXmFmlfTrtbdBjYq/61/ymMASnaTlaL/ASCP4j8H0r
         a44VpQL2u3cpO6FlJx09duJCxiH/NTg44tlJV6slvARCJvrMXo4qyxfRJicUawvmDSRa
         DPHamcMlh2RqFYbmFlUysG19VVQhWVxKFHCtNCcAefO/4YiMaOilueCyJpp+09G3cuO9
         tn+eqJMwmVERCjHHzmzRhZglmB21y4a8G/I7a8CycPXtZmgOZ6A+G4wkfT26gs/2fK8c
         IKTB0gz0IyRNg/D1jV2xvDqwSfmjYolGAbF2Cd+FILjD3HXx0Ru84wtmKt3mm2MOAqG/
         gmYQ==
X-Gm-Message-State: APjAAAVDp3+wl1I0k8mleTMKeire/TI+O8od4np/ntvI+PBkkIE/Mb6J
        iwAEeKGhAlFRuVJGUj/vLy487ILHzFSyITdRmyBFYw==
X-Google-Smtp-Source: APXvYqzVD08oLbUBv5TB7pQev79oUx9XvjbFqir2kEseCZEnF7+ERZIlVyBSOpSgKKJ3rEYpDIEwDIElz1nyAoYLJGY=
X-Received: by 2002:a17:90a:2488:: with SMTP id i8mr23649149pje.123.1559581585869;
 Mon, 03 Jun 2019 10:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com> <097bc300a5c6554ca6fd1886421bb2e0adb03420.1559580831.git.andreyknvl@google.com>
 <8ff5b0ff-849a-1e0b-18da-ccb5be85dd2b@oracle.com>
In-Reply-To: <8ff5b0ff-849a-1e0b-18da-ccb5be85dd2b@oracle.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 3 Jun 2019 19:06:14 +0200
Message-ID: <CAAeHK+xX2538e674Pz25unkdFPCO_SH0pFwFu=8+DS7RzfYnLQ@mail.gmail.com>
Subject: Re: [PATCH v16 01/16] uaccess: add untagged_addr definition for other arches
To:     Khalid Aziz <khalid.aziz@oracle.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 7:04 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
>
> On 6/3/19 10:55 AM, Andrey Konovalov wrote:
> > To allow arm64 syscalls to accept tagged pointers from userspace, we must
> > untag them when they are passed to the kernel. Since untagging is done in
> > generic parts of the kernel, the untagged_addr macro needs to be defined
> > for all architectures.
> >
> > Define it as a noop for architectures other than arm64.
> >
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  include/linux/mm.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 0e8834ac32b7..949d43e9c0b6 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -99,6 +99,10 @@ extern int mmap_rnd_compat_bits __read_mostly;
> >  #include <asm/pgtable.h>
> >  #include <asm/processor.h>
> >
> > +#ifndef untagged_addr
> > +#define untagged_addr(addr) (addr)
> > +#endif
> > +
> >  #ifndef __pa_symbol
> >  #define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
> >  #endif
> >
>
> Andrey,
>
> This patch has now become part of the other patch series Chris Hellwig
> has sent out -
> <https://lore.kernel.org/lkml/20190601074959.14036-1-hch@lst.de/>. Can
> you coordinate with that patch series?

Hi!

Yes, I've seen it. How should I coordinate? Rebase this series on top
of that one?

Thanks!

>
> --
> Khalid
>
