Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546B82242D0
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 20:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgGQSDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 14:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGQSDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 14:03:21 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3909EC0619D3
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 11:03:21 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 5so7451120oty.11
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 11:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=luRf2VFyr0NmiSmannOi4zh0OF91VllQcnlKgm+zo4g=;
        b=jjIz257pmSzixZ6M59Q5Resoy9nbHEMelsdZf823TfLrgjwGDb7vB5NY4nFO+Jy0GX
         L/x5uyqhNZY/xrevkQ6Gi8Z6wemYY3u5ZFBpwds2VtBQZSWHsnKaVSJeQfX+OGdLmd2b
         ntkea8vhu6+W/wmUWNX6dfLyrhyA0OQedD8hpSVScQeXDHo3hVJBaLXxdEu1Aa41gDMd
         kbGlLUz00fIq5s4/8MFgPge87CaG9rGYOIrJhMRvj4NMC8XZkf3ggWEjG9GOTAETPl8y
         ZP3uCrL8eS5qlr416OZtRCscFNc2MOlHNbsYmK+wCGPl2rpG6y9Bgi7ZIm0tLylbrIp5
         GoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=luRf2VFyr0NmiSmannOi4zh0OF91VllQcnlKgm+zo4g=;
        b=tQaQ68T4V1Njp9Ise9I9fIpwuxUMUYxgxn0HlNBywikNBsrMj0CHS0V5P8NDlGqcDi
         ++EGZiEwlO6PJ/HknkIkOBsPXam9i95olVJ9JnzimALgp3olbVYaLMwpUSmxQ1vTuBIy
         hIX8AgNY7PVs7GTDruoO80G2RVwVSfbdv+AwsaDLfdFSqZA867hP9ny+GCDthnjR6BdQ
         5lgKT6hhGe1Rg6Lv+5Dj6C5Z9Gnmyu+Jcs5I0iaUKMWeRVs+lqt+Ps8NznrQZ2zVs/hj
         YtMf55EoVNxHn/ezlUFON8gMz8WE1+QQkDB866K61ysXBnOZWrtEvcGsPApoYtwvh9yU
         Uy6g==
X-Gm-Message-State: AOAM530fpp8kufa7GvoCR8u1KEbbIAwACXt5fZ6axNnthBa+cXIJ259j
        DeqntKD4wOLvDr0pqacUWvWEljhBVg04f7g7NQK5SA==
X-Google-Smtp-Source: ABdhPJwedNLKBj6RXcDv8Hg0DZBHMUMYMrjlPDpNs9WB4Wjei18jrgpHUm6nlOR1blpO6b3y7nVRFD2Rqi4OKsKtAP4=
X-Received: by 2002:a9d:6a11:: with SMTP id g17mr10315659otn.50.1595009000242;
 Fri, 17 Jul 2020 11:03:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com> <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com> <20200717170747.GW9247@paulmck-ThinkPad-P72>
In-Reply-To: <20200717170747.GW9247@paulmck-ThinkPad-P72>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Fri, 17 Jul 2020 13:03:09 -0500
Message-ID: <CAEUSe79Ze92eB2kpTZUYvo357ca0C81BOxK+RCbr9h8C--SpSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Dexuan-Linux Cui <dexuan.linux@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        madhuparnabhowmik10@gmail.com,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org,
        Dexuan Cui <decui@microsoft.com>, juhlee@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello!

On Fri, 17 Jul 2020 at 12:07, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Thu, Jul 16, 2020 at 05:19:52PM -0700, Dexuan-Linux Cui wrote:
> > On Thu, Jul 16, 2020 at 7:47 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Sun, 12 Jul 2020 at 21:39, Paul E. McKenney <paulmck@kernel.org> w=
rote:
> > > >
> > > > On Sun, Jul 12, 2020 at 06:40:03PM +0530, madhuparnabhowmik10@gmail=
.com wrote:
> > > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > >
> > > > > Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry_r=
cu()
> > > > > as it also checkes if the right lock is held.
> > > > > Using hlist_for_each_entry_rcu() with a condition argument will n=
ot
> > > > > report the cases where a SRCU protected list is traversed using
> > > > > rcu_read_lock(). Hence, use hlist_for_each_entry_srcu().
> > > > >
> > > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > >
> > > > I queued both for testing and review, thank you!
> > > >
> > > > In particular, this one needs an ack by the maintainer.
> > > >
> > > >                                                         Thanx, Paul
> > > >
> > > > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/pag=
e_track.c
> > > > > index a7bcde34d1f2..a9cd17625950 100644
> > > > > --- a/arch/x86/kvm/mmu/page_track.c
> > > > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vc=
pu, gpa_t gpa, const u8 *new,
> > > > >               return;
> > > > >
> > > > >       idx =3D srcu_read_lock(&head->track_srcu);
> > > > > -     hlist_for_each_entry_rcu(n, &head->track_notifier_list, nod=
e)
> > > > > +     hlist_for_each_entry_srcu(n, &head->track_notifier_list, no=
de,
> > > > > +                             srcu_read_lock_held(&head->track_sr=
cu))
> > >
> > > x86 build failed on linux -next 20200716.
> > >
> > > arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_write':
> > > include/linux/rculist.h:727:30: error: left-hand operand of comma
> > > expression has no effect [-Werror=3Dunused-value]
> > >   for (__list_check_srcu(cond),     \
> > >                               ^
> > > arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro
> > > 'hlist_for_each_entry_srcu'
> > >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_flush_slot=
':
> > > include/linux/rculist.h:727:30: error: left-hand operand of comma
> > > expression has no effect [-Werror=3Dunused-value]
> > >   for (__list_check_srcu(cond),     \
> > >                               ^
> > > arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro
> > > 'hlist_for_each_entry_srcu'
> > >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > cc1: all warnings being treated as errors
> > > make[3]: *** [arch/x86/kvm/mmu/page_track.o] Error 1
> > >
> > > build link,
> > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DIST=
RO=3Dlkft,MACHINE=3Dintel-corei7-64,label=3Ddocker-lkft/815/consoleText
> > >
> >
> > Hi, we're seeing the same building failure with the latest linux-next t=
ree.
>
> I am not seeing this here.  Could you please let us know what compiler
> and command-line options you are using to generate this?

It fails with gcc-8 and gcc-9, but it builds with gcc-10. Quick way to
reproduce:
  [host] docker run --rm -it -v /linux:/linux -w /linux
tuxbuild/build-gcc-9_mips
  [docker] make ARCH=3Dmips CROSS_COMPILE=3Dmips-linux-gnu- defconfig
  [docker] make ARCH=3Dmips CROSS_COMPILE=3Dmips-linux-gnu- mm

You can use these other Docker containers: tuxbuild/build-gcc-8_mips
and tuxbuild/build-gcc-10_mips.

Logs for those builds (and allnoconfig, tinyconfig, with gcc-8, gcc-9
and gcc-10) can also be found here:
  https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/643978135

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
