Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226D224319
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 20:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgGQSZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 14:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgGQSZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 14:25:38 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8711C0619D3
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 11:25:37 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id y22so8740400oie.8
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 11:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kg4S7uclrZ5I69uo3imTxol1DJCZzu47bNS6rfDtCCY=;
        b=VFaH1+AIJ+enjGLy5eIENCFaiUrQsqozvHROKDK3bPQC7w0xF32ov1eZo+SmlfkEJc
         DzdykkwY4wd5ceFw/oH2m8Il2xzYOFV4nxeJ5QHNQ5bVy7OtCYOzAiUCdVI1aWsSPzJk
         NgQ4MJ/3iACFbJBlroq4UB6olr4XnblRDcOzOyVtUiXcoPF6nwpFiNChaJxCUtC3odsn
         aoLWvQsa+8urlQri0/aMWqcyFrW+aPHli3c6OmkLAn3v48XR2wICxudAztFy9X2jflhZ
         OBCTwaPxhWDCipCA5ZUMcdZ4rnS3WavEWXdKRkw9JBxessaFXU5X9BGMQtd6IpEy1lj2
         KAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kg4S7uclrZ5I69uo3imTxol1DJCZzu47bNS6rfDtCCY=;
        b=U0Hnqp6cjGbPKoKQoS9rBlBzx+eG47TkhDfWltQBSl4zD3WU4pG2iIy/gXyZrexZ7v
         7Y6tZPlGeCIPlrCPf+MeesxnP2oiuaqqrMqy9gjUriUwztutfIEX8Euyy3pnfYJTwRvs
         tM6jXOTxbVvpn1MdnzpTXYey/sHYCcYUUWYi2ZCDRWyyxmho/TwOYjgJ/V8SrmYA2QZ7
         s7uAqTIyiW3qTphkVhc5qCCQ8TOSa/OWgvOn1gXnfA57Oe0NP5JWuCiEnOyJw5v/HwfK
         jQxh1ZJoVSJj/o16/fwJSugrr19hvdp+hiWlRRgiudRyi4jaYURkmd+dlFGzMa4HyWuW
         F5Tg==
X-Gm-Message-State: AOAM531NgG5+lGqzweGW30/dTeKgSxRukn4/UxF3r3rgMRkCYVOtpN5S
        BApDi38dYCsLYCgwjBHvPOmXxVD/En7IZTc9zxeq4w==
X-Google-Smtp-Source: ABdhPJxX0uCkychUXbC7UEtPt0pfK+yu86bAuoc4L6CIsppWrXKNkoTCgOVkuiTBWaN5tPvPYoLxrJJffJqH9u5vEOQ=
X-Received: by 2002:aca:380a:: with SMTP id f10mr8190766oia.161.1595010337104;
 Fri, 17 Jul 2020 11:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com> <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
 <20200717170747.GW9247@paulmck-ThinkPad-P72> <CAEUSe79Ze92eB2kpTZUYvo357ca0C81BOxK+RCbr9h8C--SpSA@mail.gmail.com>
In-Reply-To: <CAEUSe79Ze92eB2kpTZUYvo357ca0C81BOxK+RCbr9h8C--SpSA@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Fri, 17 Jul 2020 13:25:26 -0500
Message-ID: <CAEUSe784hEv+C3zN1BDw=iaL1TFs8LNgp=ZfMpUES6Mn_Kb=Ew@mail.gmail.com>
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

The sender of this email would like to recall the message. And drink
more coffee. The sender will also avoid making any more commits on
Friday.

On Fri, 17 Jul 2020 at 13:03, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
>
> Hello!
>
> On Fri, 17 Jul 2020 at 12:07, Paul E. McKenney <paulmck@kernel.org> wrote=
:
> >
> > On Thu, Jul 16, 2020 at 05:19:52PM -0700, Dexuan-Linux Cui wrote:
> > > On Thu, Jul 16, 2020 at 7:47 AM Naresh Kamboju
> > > <naresh.kamboju@linaro.org> wrote:
> > > >
> > > > On Sun, 12 Jul 2020 at 21:39, Paul E. McKenney <paulmck@kernel.org>=
 wrote:
> > > > >
> > > > > On Sun, Jul 12, 2020 at 06:40:03PM +0530, madhuparnabhowmik10@gma=
il.com wrote:
> > > > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > > >
> > > > > > Use hlist_for_each_entry_srcu() instead of hlist_for_each_entry=
_rcu()
> > > > > > as it also checkes if the right lock is held.
> > > > > > Using hlist_for_each_entry_rcu() with a condition argument will=
 not
> > > > > > report the cases where a SRCU protected list is traversed using
> > > > > > rcu_read_lock(). Hence, use hlist_for_each_entry_srcu().
> > > > > >
> > > > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.co=
m>
> > > > >
> > > > > I queued both for testing and review, thank you!
> > > > >
> > > > > In particular, this one needs an ack by the maintainer.
> > > > >
> > > > >                                                         Thanx, Pa=
ul
> > > > >
> > > > > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/p=
age_track.c
> > > > > > index a7bcde34d1f2..a9cd17625950 100644
> > > > > > --- a/arch/x86/kvm/mmu/page_track.c
> > > > > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > > > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *=
vcpu, gpa_t gpa, const u8 *new,
> > > > > >               return;
> > > > > >
> > > > > >       idx =3D srcu_read_lock(&head->track_srcu);
> > > > > > -     hlist_for_each_entry_rcu(n, &head->track_notifier_list, n=
ode)
> > > > > > +     hlist_for_each_entry_srcu(n, &head->track_notifier_list, =
node,
> > > > > > +                             srcu_read_lock_held(&head->track_=
srcu))
> > > >
> > > > x86 build failed on linux -next 20200716.
> > > >
> > > > arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_write':
> > > > include/linux/rculist.h:727:30: error: left-hand operand of comma
> > > > expression has no effect [-Werror=3Dunused-value]
> > > >   for (__list_check_srcu(cond),     \
> > > >                               ^
> > > > arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro
> > > > 'hlist_for_each_entry_srcu'
> > > >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > > >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > > arch/x86/kvm/mmu/page_track.c: In function 'kvm_page_track_flush_sl=
ot':
> > > > include/linux/rculist.h:727:30: error: left-hand operand of comma
> > > > expression has no effect [-Werror=3Dunused-value]
> > > >   for (__list_check_srcu(cond),     \
> > > >                               ^
> > > > arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro
> > > > 'hlist_for_each_entry_srcu'
> > > >   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
> > > >   ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > > cc1: all warnings being treated as errors
> > > > make[3]: *** [arch/x86/kvm/mmu/page_track.o] Error 1
> > > >
> > > > build link,
> > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DI=
STRO=3Dlkft,MACHINE=3Dintel-corei7-64,label=3Ddocker-lkft/815/consoleText
> > > >
> > >
> > > Hi, we're seeing the same building failure with the latest linux-next=
 tree.
> >
> > I am not seeing this here.  Could you please let us know what compiler
> > and command-line options you are using to generate this?

Please disregard anything below.

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org


> It fails with gcc-8 and gcc-9, but it builds with gcc-10. Quick way to
> reproduce:
>   [host] docker run --rm -it -v /linux:/linux -w /linux
> tuxbuild/build-gcc-9_mips
>   [docker] make ARCH=3Dmips CROSS_COMPILE=3Dmips-linux-gnu- defconfig
>   [docker] make ARCH=3Dmips CROSS_COMPILE=3Dmips-linux-gnu- mm
>
> You can use these other Docker containers: tuxbuild/build-gcc-8_mips
> and tuxbuild/build-gcc-10_mips.
>
> Logs for those builds (and allnoconfig, tinyconfig, with gcc-8, gcc-9
> and gcc-10) can also be found here:
>   https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/643978135
>
> Greetings!
>
> Daniel D=C3=ADaz
> daniel.diaz@linaro.org
