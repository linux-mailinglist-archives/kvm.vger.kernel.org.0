Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD981DC9ED
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 11:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgEUJXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 05:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbgEUJXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 05:23:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589DFC061A0E;
        Thu, 21 May 2020 02:23:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u1so4966552wmn.3;
        Thu, 21 May 2020 02:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nb1hlmK7omNNMZYAiEDIg6npl1yviZIWjJhPEVqfSF4=;
        b=FMp+gzETHTA6uRPBpZJKGgwQ+qV2zMo/PxOJl+65kcDY9UD97NAwRlYLGT1dwZJcUn
         fLBTJwuU8Cr++m69vzDL53shf5yZl6aAKHnLEVe+quOvKXZnb+tg0jChuGHhC2p2nfoI
         fPoX1mbwTAQjIJKzMwp+QOCfPoIw9NHDjiV6zuZel/GE8qXayxjIB7pSSkgFjzSZohia
         +LQ+V6PVgfUqiAnHuYiribHzlcD7kSBIpTODgX73Hdqb8KbcR5vSvfnRP9+GWEQ4onlR
         /BMuK2lKMwFRj1VsOjSPrY6SS1UQ/rd/xqHKdvjZpNFf06r2vYlPgsdG2mU4wu5OR88a
         aT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nb1hlmK7omNNMZYAiEDIg6npl1yviZIWjJhPEVqfSF4=;
        b=RzqMyOyAEebYFEk2lOMVQvVVyg2CLC0TVOQ/IwpuFXwPs60L8aJPpCt+v6JgKmPH+j
         IYvVi9+2hni4wRTq6i6EWAl5OcFst+EWWgWkx6BZ17zry+622aAwbkus4DDWvLjV1uFQ
         Dbm2qVwajW3mbLxTDQbOfOQgt3GFJ+LimsGKsAV0XnsztX9dmZPVyFm8qIdw81jVatqu
         ZMOQ5GKsiSjM+0dilAZimdJagUrIGLrLpT1WS0e6BzVUV9rkGPkqaXTEHHxBrwp8fT0D
         g8jUaQFqXv1O8hvtus2TFKEntD59FwHIFYcLj04Gxij1Q8J6pdg75YmPjTFf/SoPUSol
         NP+A==
X-Gm-Message-State: AOAM532d1y1LSXV+amT5/kNNgALFvIauUFBxPRmjYrGP+kLGl2FVvM0C
        Ph9xeNIGoCkyokJ2I7yzDx0lOqYzlV+LON+fbNM=
X-Google-Smtp-Source: ABdhPJzSD0FxBMdBQ/hMqkk/0NsgDQJoqu2dLGtH90pERY1JKF/h47QFmnDdJc/stJtomPJmQ733sM7sWHp6AQJlF8w=
X-Received: by 2002:a1c:2e16:: with SMTP id u22mr6864407wmu.168.1590053014083;
 Thu, 21 May 2020 02:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com> <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
In-Reply-To: <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Thu, 21 May 2020 11:22:14 +0200
Message-ID: <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BF=D0=BE=D0=BD, 18. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:23 Aleksandar Ma=
rkovic
<aleksandar.qemu.devel@gmail.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=
=81=D0=B0=D0=BE/=D0=BB=D0=B0:
>
> =D0=BD=D0=B5=D0=B4, 17. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:55 Thomas Boge=
ndoerfer
> <tsbogend@alpha.franken.de> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=
=D0=B0=D0=BE/=D0=BB=D0=B0:
> >
> > On Sun, May 17, 2020 at 12:06:12PM +0800, Huacai Chen wrote:
> > > James Hogan has become inactive for a long time and leaves KVM for MI=
PS
> > > orphan. I'm working on KVM/Loongson and attempt to make it upstream b=
oth
> > > in kernel and QEMU, while Aleksandar Markovic is already a maintainer=
 of
> > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have alrea=
dy
> > > made some contributions in kernel and QEMU. If possible, we want to t=
ake
> > > the KVM/MIPS maintainership.
> > >
> > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > ---
> > >  MAINTAINERS | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index e64e5db..59b3f43 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -9302,9 +9302,11 @@ F:     include/kvm/arm_*
> > >  F:   virt/kvm/arm/
> > >
> > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > +M:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > +M:   Huacai Chen <chenhc@lemote.com>
> >
> > not sure, if other people see the same problem with this email address,
> > but wouldn't it be better to use your gmail address here ?
> >
>
> Huacai, Thomas,
>
> I personally and surprisingly do not have any technical difficulties
> communicating with Huacai using his lemote.com address.
>
> However, I think Thomas observation makes sense. I was personally
> a victim of various corporate decisions regarding emails, policies
> around them, and similar. And - as you can see - I ended up switching
> to gmail.com account, getting really sick and tired of repeated
> unexpected and distracting problems using corporate email adresses.
> Sounds strange, but it is true.
>
> Huacei, my honest advice and recommendation to you is to accept
> Thomas' suggestion, and change your email address here to gmail.
> We all now you work for Lemote, and that your using gmail is just a
> matter of practicality. :)
>
> Please Huacei, do send v7 with such change, and perhaps some
> other minor changes that you may or may noticed in the last minutes.
>

But, Huacai, please do not misunderstand me. I am perfectly fine with
your lemote.com address, and do not have even the slightest technical
problem using (sending/receiving messages) it.

So, I was not requesting v7 - I just wanted to help eliminate that ridiculo=
us
technical detail stopping this patch series, I am absolutely fine and even
strongly support v6 in its entire intact form.

Best Regards,
Aleksandar



> Many thanks to Thomas to noticing this that may save us from many
> really unnecessary troubles in future.
>
> Yours,
> Aleksandar
>
>
> > Thomas.
> >
> > --
> > Crap can work. Given enough thrust pigs will fly, but it's not necessar=
ily a
> > good idea.                                                [ RFC1925, 2.=
3 ]
