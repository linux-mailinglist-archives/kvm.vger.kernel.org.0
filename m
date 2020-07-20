Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1239D2261B4
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgGTOOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 10:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgGTOOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 10:14:04 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B01C0619D4
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 07:14:03 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r19so20324203ljn.12
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 07:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9DiHRnFNVQtLplAiqEhupb7TqEx9zvruD96MwLMbFL0=;
        b=Y2/c2wfUdN3DKORe7zeCca30O63TjzpDby0GTXv/vSxick4THyzfpL/d6o1Jc5zduK
         Qu8auVrQKid69N6GvMksvMzon7vw07vHmkJAnFdT6c6SNiP7/m1pNxD9lzzdZdPqCpa+
         BExD1qbSWx17l1TDVTT5fLzEAm36DS7lD2HcHooxy12pWtxIVMZAlI6gYat3q5VhCUd7
         CRDmCfKu3B2OaHgvOaBnPWbeObhX0xEniWddkPm3KOrHYDZI9YYhEbu618+0QllwhgO3
         pegp8c5wfrZVUc/rgHYILb2hzRAlgeJM0J4EkX6LxIQj8dQjts5OCSNsdc18rrDZIG1o
         zs7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9DiHRnFNVQtLplAiqEhupb7TqEx9zvruD96MwLMbFL0=;
        b=LAhBf0cuklTJx70Vb0UF0mzjMtaOdUZn0WbS3oh0zAdSPE8bQEDClvfjcuXgJycH4w
         N66lkhgIL4nGgwTl4jyQSO8q2T8pJlpCOapQdTBR8eFAkDeB86TqyA+u+e9qe81St4aR
         OAv2ikPgz+iuL+6kT11FMrflPOZmED0K7DWjyfpJ+wf3ph6KZH4QMyXkbqWq7FcUTnpy
         v2xBQeGQu0aSy9fEbD6rCgw7Tb9AHPnwZy2l6mLcJ0Cuxmud/B6Y43GTERhwAau/PTU6
         VuvKGDGuFPVKcDNl9NKyHHiFY9vJSGDdxX7OaHVnUOpXwT69bGqaqyDcEcsvGaIhpKz4
         x1UQ==
X-Gm-Message-State: AOAM5330Hdof3Cjh90LI6/lfKBSEy4HhyvHCtZAKPv5cbWbykI9OSoZn
        xP3TG20V43Un7PFbxIfr9ISQwLCCksJ165vW24JLgw==
X-Google-Smtp-Source: ABdhPJxdre1sEy80DzhnFCDjTrs8GKVeM3fBJ9cozNo11ss0SEiHRDDHrpXirEVm6TiEGg0DbCOnl43o/rAgf3lKoj4=
X-Received: by 2002:a2e:9089:: with SMTP id l9mr10612838ljg.431.1595254442239;
 Mon, 20 Jul 2020 07:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200712131003.23271-1-madhuparnabhowmik10@gmail.com>
 <20200712131003.23271-2-madhuparnabhowmik10@gmail.com> <20200712160856.GW9247@paulmck-ThinkPad-P72>
 <CA+G9fYuVmTcttBpVtegwPbKxufupPOtk_WqEtOdS+HDQi7WS9Q@mail.gmail.com>
 <CAA42JLY2L6xFju_qZsVguGtXvDMqfCKbO_h1K9NJPjmqJEav=Q@mail.gmail.com>
 <20200717170747.GW9247@paulmck-ThinkPad-P72> <CA+G9fYvtYr0ri6j-auNOTs98xVj-a1AoZtUfwokwnvuFFWtFdQ@mail.gmail.com>
 <20200718001259.GY9247@paulmck-ThinkPad-P72> <CA+G9fYs7s34mmtard-ETjH2r94psgQFLDJWayznvN6UTvMYh5g@mail.gmail.com>
 <20200719160824.GF9247@paulmck-ThinkPad-P72>
In-Reply-To: <20200719160824.GF9247@paulmck-ThinkPad-P72>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 20 Jul 2020 19:43:50 +0530
Message-ID: <CA+G9fYueEA0g4arZYQpZo803FHsYvh3WCq=PhYGULHEDa86pSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: mmu: page_track: Fix RCU list API usage
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     madhuparnabhowmik10@gmail.com,
        Dexuan-Linux Cui <dexuan.linux@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Paolo Bonzini <pbonzini@redhat.com>, rcu@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        frextrite@gmail.com, lkft-triage@lists.linaro.org,
        Dexuan Cui <decui@microsoft.com>, juhlee@microsoft.com,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Jul 2020 at 21:38, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Sun, Jul 19, 2020 at 05:52:44PM +0530, Naresh Kamboju wrote:
> > On Sat, 18 Jul 2020 at 05:43, Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > On Sat, Jul 18, 2020 at 12:35:12AM +0530, Naresh Kamboju wrote:
> > > > Hi Paul,
> > > >
> > > > > I am not seeing this here.
> > > >
> > > > Do you notice any warnings while building linux next master
> > > > for x86_64 architecture ?
> > >
> > > Idiot here was failing to enable building of KVM.  With that, I do see
> > > the error.  The patch resolves it for me.  Does it help for you?
> >
> > yes.
> > The below patch applied on top of linux -next 20200717 tag
> > and build pass.
>
> Thank you!  May I add your Tested-by?

That would be great please add
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Thank you !

- Naresh
