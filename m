Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3C1D72E9
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 10:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgERIXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 04:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERIXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 04:23:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2B0C061A0C;
        Mon, 18 May 2020 01:23:41 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d207so18837234wmd.0;
        Mon, 18 May 2020 01:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gZLQD0FEl5J6fjDPmseTi5EDE2CxTb3SUF6hUHkwd/I=;
        b=i6CGj5/2/ufS2xoBjzJgZDnAH0qfi0gseS2gYe+RFuuxRkra67lYGep5dW7RIUAm19
         L6Uay2n8WJXYB70WMy+ymeYAltJh734T1XF2PzXKUz6bGynqy2A7Y0AJ17e+3B4ddocL
         BFKJu/yyLDqceGQ7fiLgdRwiULhZ9d8ByxCp5MAyd8d1ZnKZ/B/SUnMkZ/lQDIIV3xfX
         21ixvcgsltQYtm5qKobBhGzzvLfDPNVevRZ2Rr6xmN6JEc0gQOVnFVDUeXy2tGrD8o4G
         H0wSg539PWE3b2Mbyo8AMsHCJ4y61MtBQmUanJ8LMrHLZlvgbR5tCg2JoZTangyRDnwF
         V6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gZLQD0FEl5J6fjDPmseTi5EDE2CxTb3SUF6hUHkwd/I=;
        b=Q2QtgocvaW8xYP3qBQ5uYeBdWdJVM1Xe2uX7Z7vtbHnqEf2g9RvljEObn9QnIuXWjr
         p5YIgCjVL9av0uTkRRxoA3bK7/1D29sz1dBhROAXQbb+wDt7S2ubANVQu0y7DDSHoikt
         COUL08eKRBQmXmesqB+c6Mirxflh3B1WXHwMSegV57sjliCkOxlVmjargOX+CrwycLWs
         u1ZCu2CuITy92Olhjd2sTSYzlVtMLzrDm9lFgja8Zn+uZJHUE4DOhrJHA1lhEK3iiZcw
         KUPQS/nM3Qr9mVS9BINvnRLWh4n1qo6XkVN/q2JCN8IUf0HfV7hoICutnDJnQthUkx3s
         yaBQ==
X-Gm-Message-State: AOAM5335yhjYhVxWVA1qzPuFHxj0OdbFaV4W0i4g41sMq5MnkwAjxSka
        OTx04B5ow99nDdOFsLJ7MLmDl9XT1lBsUeY2DE0=
X-Google-Smtp-Source: ABdhPJwerkDmdOWugeNcvH/q/IdYFuk0Qlbkv56alymGWRuXb3yMwse96SmCYb0VWoy2a+9I1UwcV/IRjRiT98GU0Os=
X-Received: by 2002:a1c:9a09:: with SMTP id c9mr17503294wme.159.1589790220663;
 Mon, 18 May 2020 01:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com> <20200517082242.GA3939@alpha.franken.de>
In-Reply-To: <20200517082242.GA3939@alpha.franken.de>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Mon, 18 May 2020 10:23:26 +0200
Message-ID: <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 17. =D0=BC=D0=B0=D1=98 2020. =D1=83 10:55 Thomas Bogend=
oerfer
<tsbogend@alpha.franken.de> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=
=B0=D0=BE/=D0=BB=D0=B0:
>
> On Sun, May 17, 2020 at 12:06:12PM +0800, Huacai Chen wrote:
> > James Hogan has become inactive for a long time and leaves KVM for MIPS
> > orphan. I'm working on KVM/Loongson and attempt to make it upstream bot=
h
> > in kernel and QEMU, while Aleksandar Markovic is already a maintainer o=
f
> > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> > made some contributions in kernel and QEMU. If possible, we want to tak=
e
> > the KVM/MIPS maintainership.
> >
> > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  MAINTAINERS | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e64e5db..59b3f43 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9302,9 +9302,11 @@ F:     include/kvm/arm_*
> >  F:   virt/kvm/arm/
> >
> >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > +M:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > +M:   Huacai Chen <chenhc@lemote.com>
>
> not sure, if other people see the same problem with this email address,
> but wouldn't it be better to use your gmail address here ?
>

Huacai, Thomas,

I personally and surprisingly do not have any technical difficulties
communicating with Huacai using his lemote.com address.

However, I think Thomas observation makes sense. I was personally
a victim of various corporate decisions regarding emails, policies
around them, and similar. And - as you can see - I ended up switching
to gmail.com account, getting really sick and tired of repeated
unexpected and distracting problems using corporate email adresses.
Sounds strange, but it is true.

Huacei, my honest advice and recommendation to you is to accept
Thomas' suggestion, and change your email address here to gmail.
We all now you work for Lemote, and that your using gmail is just a
matter of practicality. :)

Please Huacei, do send v7 with such change, and perhaps some
other minor changes that you may or may noticed in the last minutes.

Many thanks to Thomas to noticing this that may save us from many
really unnecessary troubles in future.

Yours,
Aleksandar


> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessaril=
y a
> good idea.                                                [ RFC1925, 2.3 =
]
