Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4891CA7F1
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 12:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgEHKJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 06:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgEHKJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 06:09:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32870C05BD43;
        Fri,  8 May 2020 03:09:28 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so1185321wra.7;
        Fri, 08 May 2020 03:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8VKYlrpPH4YRMjE2iFfbycMZkHwOVHse6ZGSGY3uPKY=;
        b=JE0hxLvYsuxWE64dvjF2JUhfJ3IzSYJ9wp7QtA+M/MTuvoK7F98ieiQn8DJeN1eMGU
         GUNKkxeGUEYbCzyAXz+y+STyTh715A2PVe1n3J+XPY/W7K40+JbE/FaZHjjhMQMXggBQ
         +Kgg/FwsVhFvs6PzNlRKyZVIgXF/0kWSWE+WKELLZZymYCc1LjB6M6zTM/MBykl8VeG5
         IepMWO5t0tQEMhDqH3a4NuYN4eF9pL9QNGdodn7C5XsQn236R/CM/YR5od1AbKYtPNY9
         TreG/Z5Mr9dJ1jAfGi+9M9zrbNZc+ToV0+SOeUe5CwDlSg58ACXPwcfw0USieQOcf+XD
         ZiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8VKYlrpPH4YRMjE2iFfbycMZkHwOVHse6ZGSGY3uPKY=;
        b=ArABRVICh8MAg4Ep4EF/nbWm0bVxxS9ul4WpHavTSGIYoJzayxgoegcmXqG1KFqN1S
         3iIFUijLOEx1TbLZ9TNDMLM58ENaI3sks8DAO/GS7jdgJiHGsCV8IXlwMdGoGLdF6P4u
         Kcjd6Uy0AJIaIe6bBeEVZWunHI8o4D++dPeBU1ja4LuH56/ft6HSyi/zsd0Ikh+7nfVW
         t3YQE3RoaOCY5U0vh0yu1/55NxNYBS8KDDiLqIR9ECkGowKae6Sk4kNLmDVar8A6MkGS
         aMqjcWD9n3gjtHRng+qT9TA0+0OQgAfhvFWS5mg/hE+OTwy4GXRUIuktn+Luc3tGBL3G
         GJFw==
X-Gm-Message-State: AGi0PuaQz667iMtoDD9hW6VjKpZ93x5r5qCUILll1lKwKcg5QoBfuUzl
        LWzvfWRsyEe4RIodyKtqFOXvfbM/ijBqSfGDZvM=
X-Google-Smtp-Source: APiQypKIhO1+vEDdCLtLXyBrlYKHzVc0jr7QIpvq+o6OY332o917S1E6kc51ietEUOZ8OykjxapWccBATB+XXAm+S6k=
X-Received: by 2002:adf:94a6:: with SMTP id 35mr2036714wrr.420.1588932566539;
 Fri, 08 May 2020 03:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
 <1588500367-1056-5-git-send-email-chenhc@lemote.com> <CAHiYmc42QJ_XzHxoBKyccocb7sJCn42UtOuQ-2LNCzK=RqkEVQ@mail.gmail.com>
In-Reply-To: <CAHiYmc42QJ_XzHxoBKyccocb7sJCn42UtOuQ-2LNCzK=RqkEVQ@mail.gmail.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:08:56 +0200
Message-ID: <CAHiYmc4VfRG=vYzjNfPBUTcjWngaGo7gJBxLJ5NJKAseh7CrdQ@mail.gmail.com>
Subject: Re: [PATCH V3 04/14] KVM: MIPS: Add EVENTFD support which is needed
 by VHOST
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BF=D0=B5=D1=82, 8. =D0=BC=D0=B0=D1=98 2020. =D1=83 11:08 Aleksandar Mar=
kovic
<aleksandar.qemu.devel@gmail.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=
=81=D0=B0=D0=BE/=D0=BB=D0=B0:
>
> =D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:09 Huacai Chen =
<chenhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE=
/=D0=BB=D0=B0:
> >
> > Add EVENTFD support for KVM/MIPS, which is needed by VHOST. Tested on
> > Loongson-3 platform.
> >
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > ---
>
> Perhaps this patch needs rebasing to land cleanly into master.
>

Or, maybe, my tree was out-of-date. Sorry if that was the case.

Yours,
Aleksandar

> But, in general, for what is worth:
>
> Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>
>
> >  arch/mips/kvm/Kconfig     | 1 +
> >  arch/mips/kvm/Makefile    | 2 +-
> >  arch/mips/kvm/trap_emul.c | 3 +++
> >  arch/mips/kvm/vz.c        | 3 +++
> >  4 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
> > index b91d145..d697752 100644
> > --- a/arch/mips/kvm/Kconfig
> > +++ b/arch/mips/kvm/Kconfig
> > @@ -22,6 +22,7 @@ config KVM
> >         select EXPORT_UASM
> >         select PREEMPT_NOTIFIERS
> >         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > +       select HAVE_KVM_EVENTFD
> >         select HAVE_KVM_VCPU_ASYNC_IOCTL
> >         select KVM_MMIO
> >         select MMU_NOTIFIER
> > diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
> > index 01affc1..0a3cef6 100644
> > --- a/arch/mips/kvm/Makefile
> > +++ b/arch/mips/kvm/Makefile
> > @@ -2,7 +2,7 @@
> >  # Makefile for KVM support for MIPS
> >  #
> >
> > -common-objs-y =3D $(addprefix ../../../virt/kvm/, kvm_main.o coalesced=
_mmio.o)
> > +common-objs-y =3D $(addprefix ../../../virt/kvm/, kvm_main.o coalesced=
_mmio.o eventfd.o)
> >
> >  EXTRA_CFLAGS +=3D -Ivirt/kvm -Iarch/mips/kvm
> >
> > diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
> > index 5a11e83..f464506b 100644
> > --- a/arch/mips/kvm/trap_emul.c
> > +++ b/arch/mips/kvm/trap_emul.c
> > @@ -529,6 +529,9 @@ static int kvm_trap_emul_check_extension(struct kvm=
 *kvm, long ext)
> >         case KVM_CAP_MIPS_TE:
> >                 r =3D 1;
> >                 break;
> > +       case KVM_CAP_IOEVENTFD:
> > +               r =3D 1;
> > +               break;
> >         default:
> >                 r =3D 0;
> >                 break;
> > diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> > index dde2088..17932ab 100644
> > --- a/arch/mips/kvm/vz.c
> > +++ b/arch/mips/kvm/vz.c
> > @@ -2927,6 +2927,9 @@ static int kvm_vz_check_extension(struct kvm *kvm=
, long ext)
> >                 r =3D 2;
> >                 break;
> >  #endif
> > +       case KVM_CAP_IOEVENTFD:
> > +               r =3D 1;
> > +               break;
> >         default:
> >                 r =3D 0;
> >                 break;
> > --
> > 2.7.0
> >
