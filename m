Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B38157F43
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 16:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgBJPzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 10:55:12 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:53137 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbgBJPzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 10:55:12 -0500
Received: from mail-qv1-f54.google.com ([209.85.219.54]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MPGmZ-1iquVU3k33-00PaGe for <kvm@vger.kernel.org>; Mon, 10 Feb 2020
 16:55:10 +0100
Received: by mail-qv1-f54.google.com with SMTP id db9so3393932qvb.3
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 07:55:09 -0800 (PST)
X-Gm-Message-State: APjAAAVV0+xuo7PoWZJAxqeaEgImPDCr8mM1JseQSYd9vWJtNWvCNRiY
        PaEX4bDQSTmufpxxL4SjYIxOigvcq1k9mEiStWY=
X-Google-Smtp-Source: APXvYqzD4gF79za8QjGnOdvdxMye/9gCcsvE1sbWfcQ/2Iho40EJZiFepFIPJyPs4Sj+zYmpLY+XdCjR8myFcnfghrI=
X-Received: by 2002:a0c:f9c7:: with SMTP id j7mr10699586qvo.222.1581350108754;
 Mon, 10 Feb 2020 07:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org> <CAOesGMhHkez-5vxwWuzXc2Rm=dYYWjMX9C8AewVy9GDWuZcwMw@mail.gmail.com>
In-Reply-To: <CAOesGMhHkez-5vxwWuzXc2Rm=dYYWjMX9C8AewVy9GDWuZcwMw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 10 Feb 2020 16:54:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1pi3yBVMdXQyZsm_NFLn=UrVRgQ2O5b3-RmF9JTi5z7A@mail.gmail.com>
Message-ID: <CAK8P3a1pi3yBVMdXQyZsm_NFLn=UrVRgQ2O5b3-RmF9JTi5z7A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Olof Johansson <olof@lixom.net>
Cc:     Marc Zyngier <maz@kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm list <kvm@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ToNzOiX7EGZ6YhfImhFpQASkj6DpkGU7u1Kq1+/tDZJiv8mMeIa
 /Ru9NQEYMFz6C1LuJEJ1LhaKMpx6XQ8vsRqDZauzSTO5aMoKYYcshOFhndeDm0mVscSUMdM
 EPOsLpG1TNKF2hOXiPxQ+xKBSk3FTuYD3bgYj6aldOqshAw9+s3Mfa0N/Fq4I12/6Dn5tiQ
 AZ60Z6NoOJq4o+JaXcyfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:61Gki2XLGKs=:7QvMnlxP3kgG2hnGjwxDcL
 M8sIeejwgxAKktUlbazukUmdgf67+45N2i0Uj/AZh+YmVUJ7hc0CCG33ArcKYpPIMh1mMsanz
 Nc1m1M3Y+rOjFFi/ogfbXO0d0MNJRaTUYyeKrG2kJdEeg6s3JyKRiTZp0D15yOrAHGbLIPC2F
 1tXfTEJ3P8kCdnXB7tnrfgEjEYSW65tc+PXL4b1x1OU1jUs60xrgXemD68bjeA71i4KB+goKQ
 Zc4qzGoP7dSGt8l6L8GEgeYPfAkq0Uec//8nnf4yCxeMQz1CaFuOvhE1ZyWthTugYvOKFELM3
 VZKC/8eEJHNH8lgt9q+EyKyW58jenTTjyU/yX7i23gtefDbm50MZ4Dety5Dsq9adLASuZnEOS
 7XHKHNUABa0QwmnGLs1taBO6bbdJljoI1RsZjtCyAEicRGDoOinVldULiLLwSJdtVWbRDWMMR
 Il9Riyy+5uYLTVlBaOvlTbXF4MO15mF0+5c+MWHyaQknN0Re0F9yZ0h40sPZfIOeBV1ZJxmdL
 yb6Ne+B04714wkFRKianO3/PEiN9QxO/H8KYZSRjZMUcl5Q6DNz0P0dYCSooPO5htZiYn9nZS
 u+p23yp1tCIn1t2XrJzjzG5XaxFWwGd59OO1AhUKM+4kIX57ECEJiKAJt2ffXgXl+frmkaZhi
 h30NebnUnDjkmGwVMoG0sFAYSjhLeUaJhNnt0x9HjsNtLu4a9oXmY/Ewli4kR9m3NuHbvCl2t
 h8vXlE+yCa7Qx7SRerKo1C6u+43LsbD3hfGk5QtTr7FX7Kvs/JajsZC6DD5lxDm5sNmXww35K
 K1Wd3+jCEXPNKh/wfnHXF+GZTluYlPUC9deNDxniZvZS3uAVQE=
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 4:32 PM Olof Johansson <olof@lixom.net> wrote:
> On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
> >
> > KVM/arm was merged just over 7 years ago, and has lived a very quiet
> > life so far. It mostly works if you're prepared to deal with its
> > limitations, it has been a good prototype for the arm64 version,
> > but it suffers a few problems:
> >
> > - It is incomplete (no debug support, no PMU)
> > - It hasn't followed any of the architectural evolutions
> > - It has zero users (I don't count myself here)
> > - It is more and more getting in the way of new arm64 developments
> >
> > So here it is: unless someone screams and shows that they rely on
> > KVM/arm to be maintained upsteam, I'll remove 32bit host support
> > form the tree. One of the reasons that makes me confident nobody is
> > using it is that I never receive *any* bug report. Yes, it is perfect.
> > But if you depend on KVM/arm being available in mainline, please shout.
> >
> > To reiterate: 32bit guest support for arm64 stays, of course. Only
> > 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
> > arm64, and cleanup all the now unnecessary abstractions.

I think this makes a lot of sense: we are seeing fewer new 32-bit
systems that have enough RAM to be a usable virtualization host,
as most new boards with more than 1GB of RAM typically pick 64-bit
SoCs, and on less than 1GB it gets awfully tight to do anything useful.

> Since I'm generally happy to drop legacy code that has no users, with
> the "if there are any significant users that speak up, I'll revoke my
> support" caveat:
>
> Acked-by: Olof Johansson <olof@lixom.net>

Same here

Acked-by: Arnd Bergmann <arnd@arndb.de>
