Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDA51691E4
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 22:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgBVVbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 16:31:53 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53325 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgBVVbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 16:31:53 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N4Qg2-1jXd3Z2Bz4-011Vfk for <kvm@vger.kernel.org>; Sat, 22 Feb 2020
 22:31:51 +0100
Received: by mail-lf1-f54.google.com with SMTP id s23so4045693lfs.10
        for <kvm@vger.kernel.org>; Sat, 22 Feb 2020 13:31:51 -0800 (PST)
X-Gm-Message-State: APjAAAVPN6Edewv5IfjND7P5mUX1BfBzILFhT7bEOcV4pWUvKFYIS22o
        mU9UAJRP0FvN5k4dXLsPRawCp++JP+g2lj0n0ro=
X-Google-Smtp-Source: APXvYqw08WaVpwqyvapB9jwmtZ9FkkkQyrz5uYJ12nY2XRMB6nrK7EaFW5taPH3fOq3Exia34Hd+8TSqfX93FnPLHNA=
X-Received: by 2002:ac2:5f62:: with SMTP id c2mr4862268lfc.207.1582407110902;
 Sat, 22 Feb 2020 13:31:50 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org> <20200222154030.5625fa5f.takashi@yoshi.email>
In-Reply-To: <20200222154030.5625fa5f.takashi@yoshi.email>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 22 Feb 2020 22:31:40 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3iaDqU7RRpoL2XyempBiKN8k22rNAM7C23n8JNpPm4qw@mail.gmail.com>
Message-ID: <CAK8P3a3iaDqU7RRpoL2XyempBiKN8k22rNAM7C23n8JNpPm4qw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To:     Takashi Yoshi <takashi@yoshi.email>
Cc:     Marc Zyngier <maz@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
X-Provags-ID: V03:K1:APoqwatqbfIzGXAsvG7xy8LcNuXilxk/dB0h2dlnr8xxMEpp28Z
 Vtd4qz7CGiuouS2MGkdw01eSTAgVFuQH25g1CQVOH8sbxw2wjdGMreU8XsOZl92GPOjpCY8
 TEp8+R/iyl+59nzwn9XuaG0dWL1BlecVDkICw4E9eurRzobyGdG/J2Fr1JhXBW6T2tFrL3k
 kvpdl/PU9+TjORTxPyvqw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xtf71T0M97I=:kH8MH3KzLkZPBj+5bhJQCG
 s+kiy3nzRgDBpyitRHa4u0rplnX6rOcWfz/BEUX8WZrM2pXGhNDO5WTJYIuDMN4B2hQYexKmE
 Atm7vm+UbnM/HAdEIyP/WIUdFAOBVWK4usAgZGClWjH6VV8pgAfe5A+KAKnPpyOaH2l2WQv3z
 qw4TNERc7iy0uaPrBd2GU+mz5ZTexQFr168oGQBd8zJ7p3PtQ1Wp7qz5bM7gAsgzt6n4PwDa9
 lXR25TG4WGAv/csBL9TofK2JEbri61yYbfKB8E1CvwIOb8keNsXZIGrmYL7CthKqw+OfCSvCh
 3H+QtWdcWPLRmyZR/cksLMmjlWUDGMcFTckd7vT51Ek9hzkEBgKsI+L+3ssT+5SSAyJ/zo1Is
 mk4JtqFHjZQs4phVxfwtDby7aS2CbKkaRjKWt1Vyv3Uis8ku91lTv0qmJcEC5yNcdZIzfnPXH
 /N5FOg6sxZ4P4QbqYCNU/pqZKYGvYXZyDy7mfX+GNeknZ5dNABpNh4zRbejZGKD7+BrkG5yil
 EOJsw8SDTJ/6OwfeG7UGwee3yEaUDRSrvcHSbkv0DI6GDDgX1FSZ21tYaSiNdKseJsuWqTu4Q
 esWVzo1UvfmvTCvHWB9rzS50EFx+GKNLNUeLUWu6pSHR0Lla0cXSLqr2Z6apUOB0wn564WziA
 JQNQQQIGwXy01TVj48i2uvTW+tlpVkiv6qp1DKRQAMzxGiAHs4/C+vcudsfmeiouel8uw3Une
 1ALze0fkdLfId7i/JIDis/HxNcK+N3SahXB6F6zQLjgFKBHH1ZTqRDT0Ejm3lYGK0JTvaGYiX
 I8sLimM+0xjvLjxt9F2t1WU5kHf03r48yImfRu1tcntMaAEgk0=
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 22, 2020 at 3:40 PM Takashi Yoshi <takashi@yoshi.email> wrote:
> On Monday, 10.02.2020, 14:13 +0000 Marc Zyngier wrote:
> > KVM/arm was merged just over 7 years ago, and has lived a very quiet
> > life so far. It mostly works if you're prepared to deal with its
> > limitations, it has been a good prototype for the arm64 version,
> > but it suffers a few problems:
> >
> > - It is incomplete (no debug support, no PMU)
> > - It hasn't followed any of the architectural evolutions
> > - It has zero users (I don't count myself here)
>
> I might not be an important user, but I have been for multiple years
> and still am a regular user of KVM/arm32 on different devices.
>
> I use KVM on my Tegra K1 Chromebook for app development and have
> multiple SBCs at home on which I run VMs on using KVM+libvirt.
>
> Sure, neither of these devices has many resources available, but they
> are working fine. I would love to keep them in service since I haven't
> found arm64-based replacements that don't require hours upon hours of
> tinkering to just get a basic OS installation running with a mainline
> kernel.
>
> As an example that they can still be of use in 2020 I'd like to point
> out that one of the SBCs is running my DNS resolver, LDAP server,
> RSS reader, IRC bouncer, and shared todo list just fine, each in their
> separate VM.

Thank you for providing an important data point to this question.

> > - It is more and more getting in the way of new arm64 developments
> >
> > So here it is: unless someone screams and shows that they rely on
> > KVM/arm to be maintained upsteam, I'll remove 32bit host support
> > form the tree.
>
> *scream*
>
> > One of the reasons that makes me confident nobody is
> > using it is that I never receive *any* bug report. Yes, it is
> > perfect.
>
> This assumption is deeply flawed. Most users (including me) are not
> subscribed to this mailing list and will never find this thread at all.
> I myself stumbled upon this discussion just by chance while I was
> browsing the web trying to find something completely unrelated.
>
> I've been using KVM on x86, ppc and arm for many years, yet I never
> felt the need to report a bug on the mailing list.
> (This is to be interpreted as a compliment to the great work the devs
> of KVM have done!)
>
> Just going by the number of bugs reported on a developers mailing list
> is not going to paint an accurate picture.
>
> I am convinced that I'm not the only one relying on KVM/arm32 in the
> mainline kernel and would ask you to please reconsider keeping arm32 in
> the mainline kernel for a few more years until adequate arm64
> replacements are available on the market and have gained proper support
> in the mainline kernel.

Can you provide some more information about how you use KVM on 32-bit
machines, to make it possible to better estimate how many others might
do the same, and how long you will need to upgrade to newer kernels for?

In particular:

- What is the smallest amount of physical RAM that you have to found to
   make a usable ARM/KVM host? Note that the 4GB configuration of the
   Tegra K1 (an rk3288) Chromebooks seems to be extremely rare in other
   devices, while most new 32-bit SBCs come with 1GB or less these days.

- How often do you update the host kernels on those 32-bit machines that
  you still use to newer releases? What is the oldest/newest you run at the
  moment?

- Are you able to move the host installation to a distribution with a long-term
  stable release cycle such as Debian, Ubuntu that gives you a ~five year
  support after a kernel release?

         Arnd
