Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E731DCA61
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 11:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgEUJpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 05:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbgEUJpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 05:45:50 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4246CC061A0E;
        Thu, 21 May 2020 02:45:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a14so6472506ilk.2;
        Thu, 21 May 2020 02:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tkFgekeOU6U+z1MPjwzv8/IuksMHV7TUWnEMBAkfYLs=;
        b=XaMwdJ+0/ZEfkEyCDVx4AE3HQBJSyI1/htTin8HlTpqTWzL6165QkWZS02VQqZQ5TS
         rdHYL47EDbOA98dfzpU4GPEhGcYKtOjkMcKYcojqbVAvHev/U6CjtPzapJSHEYPOqKyh
         4meX+K43HM79ktenq8AkKjrY69curKfnb+tXRTmjprJ9p9vLfUW8HP/U5Hik4MtfSbJ9
         mW9gIGN2iYmSz521a2U50BsRmemGnFn8N7U1nCgsqj9quz1D1kDjeQKBW4CreSCbJqFy
         iOIJk3lmAIAJZ8+1ZeaTSyPucgljTUnkpuuSioVkp0AIrE8v0jWq7bsH8USGF7yVurpV
         +mgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tkFgekeOU6U+z1MPjwzv8/IuksMHV7TUWnEMBAkfYLs=;
        b=g4vkN+eEgDUDgukSoIZXBIkLQwX2zcoxaPxdAZbfAFsdNr5GFEFsovl7cxH5g4XdT1
         Ed8gKuwcytuR7StLBp5gzQPhJH+OtjyG18gYqFc4gF25zZvZOKGe1F+ayJv6HHGub/K4
         Soop1tmHJx6+HghhgaGcT5Z4kS2vi5m5uQZYX47CMgFQP6byO8FGPJKyv9CTrPCPSRPU
         ARA38uDPvNKuV20CbBelwAC3GH3pSW63wLr8ew80N4SJbWF4VubQgrnTXLZAS8VwkBP6
         rTDgdd6AeyX+agCliRRt6mGTWOmZGKjhHS2nbp2dOlke/80psyuuuPUMNPG9XKzrPF0E
         b58w==
X-Gm-Message-State: AOAM531r5J5bXAaxt1zO2m9vJyEwWfjOWULXVgBktwirZ9Cqw1mOoKzR
        th+4iSjFLTIBy3qj1Q+ou4rCgx1/09JvIL7sPVw=
X-Google-Smtp-Source: ABdhPJwLkGADJqr2QOW/Mx0qiNiCb3thBooEzb1RO9W+P8yjnozC8V55Si068q1qJR1ZCj318iWEIOIO/MRZpSJIF9M=
X-Received: by 2002:a05:6e02:503:: with SMTP id d3mr7823719ils.208.1590054349634;
 Thu, 21 May 2020 02:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com> <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com> <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
In-Reply-To: <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Thu, 21 May 2020 17:45:38 +0800
Message-ID: <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Aleksandar,

On Thu, May 21, 2020 at 5:23 PM Aleksandar Markovic
<aleksandar.qemu.devel@gmail.com> wrote:
>
> =D0=BF=D0=BE=D0=BD, 18. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:23 Aleksandar =
Markovic
> <aleksandar.qemu.devel@gmail.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=
=D1=81=D0=B0=D0=BE/=D0=BB=D0=B0:
> >
> > =D0=BD=D0=B5=D0=B4, 17. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:55 Thomas Bo=
gendoerfer
> > <tsbogend@alpha.franken.de> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=
=D0=B0=D0=BE/=D0=BB=D0=B0:
> > >
> > > On Sun, May 17, 2020 at 12:06:12PM +0800, Huacai Chen wrote:
> > > > James Hogan has become inactive for a long time and leaves KVM for =
MIPS
> > > > orphan. I'm working on KVM/Loongson and attempt to make it upstream=
 both
> > > > in kernel and QEMU, while Aleksandar Markovic is already a maintain=
er of
> > > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have alr=
eady
> > > > made some contributions in kernel and QEMU. If possible, we want to=
 take
> > > > the KVM/MIPS maintainership.
> > > >
> > > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > ---
> > > >  MAINTAINERS | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index e64e5db..59b3f43 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -9302,9 +9302,11 @@ F:     include/kvm/arm_*
> > > >  F:   virt/kvm/arm/
> > > >
> > > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > > +M:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > > +M:   Huacai Chen <chenhc@lemote.com>
> > >
> > > not sure, if other people see the same problem with this email addres=
s,
> > > but wouldn't it be better to use your gmail address here ?
> > >
> >
> > Huacai, Thomas,
> >
> > I personally and surprisingly do not have any technical difficulties
> > communicating with Huacai using his lemote.com address.
> >
> > However, I think Thomas observation makes sense. I was personally
> > a victim of various corporate decisions regarding emails, policies
> > around them, and similar. And - as you can see - I ended up switching
> > to gmail.com account, getting really sick and tired of repeated
> > unexpected and distracting problems using corporate email adresses.
> > Sounds strange, but it is true.
> >
> > Huacei, my honest advice and recommendation to you is to accept
> > Thomas' suggestion, and change your email address here to gmail.
> > We all now you work for Lemote, and that your using gmail is just a
> > matter of practicality. :)
> >
> > Please Huacei, do send v7 with such change, and perhaps some
> > other minor changes that you may or may noticed in the last minutes.
> >
>
> But, Huacai, please do not misunderstand me. I am perfectly fine with
> your lemote.com address, and do not have even the slightest technical
> problem using (sending/receiving messages) it.
>
> So, I was not requesting v7 - I just wanted to help eliminate that ridicu=
lous
> technical detail stopping this patch series, I am absolutely fine and eve=
n
> strongly support v6 in its entire intact form.
>
> Best Regards,
> Aleksandar
I'm sorry for the late response. These days I'm attempting to collect
some maintainers' PGP signatures, in order to get a kernel.org
account. So, I think we can keep the lemote.com address in MAINTAINERS
now, and update to the kernel.org address when I succeed.

Regards,
Huacai
>
>
>
> > Many thanks to Thomas to noticing this that may save us from many
> > really unnecessary troubles in future.
> >
> > Yours,
> > Aleksandar
> >
> >
> > > Thomas.
> > >
> > > --
> > > Crap can work. Given enough thrust pigs will fly, but it's not necess=
arily a
> > > good idea.                                                [ RFC1925, =
2.3 ]
