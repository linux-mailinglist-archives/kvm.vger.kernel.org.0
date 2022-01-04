Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6380484AB7
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 23:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiADWb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 17:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiADWb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 17:31:58 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F57C061799
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 14:31:57 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id g26so84846961lfv.11
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 14:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drummond.us; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WCROm2fnDVp3gJHoFF4FSh0CLwqqTwPGgd5WC3cykAE=;
        b=SpNAIy18+a+BDF8ohbOhhPTgn+rzzWGPHdpXue1Z95/qQvcACFPfls+EhsBOb9bJ5I
         J4obAOpt6rzp6Cc6ysV/HzbOKr1fr3e+TeLO6bRMnYdo3Gyh9nb1rzv1ICxH2cvlIvP1
         O7zLwOaJVfjhHVFevNE78XtRHOJLnOt4OvZNOrtO4+Qth9yQuKO3Y0zMqJxHhe1sPN68
         AsVbfWMCG2xnfSZ0gRMgCWFuQi9faGM0w08EmIWjCfBZLojXQfuuYl5i08TleIW/7b/n
         nzMZzBq9PSmCXV2xi+HfGLAjucKoCMHpfD9Bcb6PeCRSN1t/e4GZt0e33JDtOpwXUI3r
         +ijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WCROm2fnDVp3gJHoFF4FSh0CLwqqTwPGgd5WC3cykAE=;
        b=QZyVZTQz3ZGD6EGCE5nOMBvBP2QQiWBLxG5Pakh8dDzH+/057ykh1rfpzhch3WWvgM
         F9My5VK3NRL4ujUgp8EJwmgtuV8LVCNgnAxNE4cJUsm34oTJBSHzgVb4LjL44WR47ore
         p/i9iI7cGnbh88eIPvgQdjN8tFpBejPo+S0FrFBL2D7xNmk05cIDQASkOF9caMn8aXZr
         EkWqLJ/hD+WjK2dHJMn7sRzfFjWaGhFn287iwTb+3TnTSj2Q7AsFaA9Y/apMD0KX7h+o
         FnDqFenK7e3Nb7eYcr/0qunwOmGAn0fPsCfGGoGwVJCMcriR+WX8NSjg4kvWTeSDJLMm
         N2Xg==
X-Gm-Message-State: AOAM531Yx7MhVZdF361Ulr+2kWZzgybUbzvZMQ7AygeAXIAK09rDNCNL
        XXYy6GmwKp+PEAEVatA4gVC/9IZEpEh+yC/2hVnPfQ==
X-Google-Smtp-Source: ABdhPJx1kX6sFLTseOkg2YWGeBhi1W6ClRmDNwQ/+U2YIr6vghHpml3Y6bKghVPjgaFOMW5MDitHq9bLobHNxLYmId8=
X-Received: by 2002:a05:6512:ba9:: with SMTP id b41mr43938123lfv.529.1641335515666;
 Tue, 04 Jan 2022 14:31:55 -0800 (PST)
MIME-Version: 1.0
References: <20220103181956.983342-1-walt@drummond.us> <87iluzidod.fsf@email.froward.int.ebiederm.org>
 <YdSzjPbVDVGKT4km@mit.edu> <87pmp79mxl.fsf@email.froward.int.ebiederm.org> <YdTI16ZxFFNco7rH@mit.edu>
In-Reply-To: <YdTI16ZxFFNco7rH@mit.edu>
From:   Walt Drummond <walt@drummond.us>
Date:   Tue, 4 Jan 2022 14:31:44 -0800
Message-ID: <CADCN6nzT-Dw-AabtwWrfVRDd5HzMS3EOy8WkeomicJF07nQyoA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] signals: Support more than 64 signals
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>, aacraid@microsemi.com,
        viro@zeniv.linux.org.uk, anna.schumaker@netapp.com, arnd@arndb.de,
        bsegall@google.com, bp@alien8.de, chuck.lever@oracle.com,
        bristot@redhat.com, dave.hansen@linux.intel.com,
        dwmw2@infradead.org, dietmar.eggemann@arm.com, dinguyen@kernel.org,
        geert@linux-m68k.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        idryomov@gmail.com, mingo@redhat.com, yzaikin@google.com,
        ink@jurassic.park.msu.ru, jejb@linux.ibm.com, jmorris@namei.org,
        bfields@fieldses.org, jlayton@kernel.org, jirislaby@kernel.org,
        john.johansen@canonical.com, juri.lelli@redhat.com,
        keescook@chromium.org, mcgrof@kernel.org,
        martin.petersen@oracle.com, mattst88@gmail.com, mgorman@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        rth@twiddle.net, richard@nod.at, serge@hallyn.com,
        rostedt@goodmis.org, tglx@linutronix.de,
        trond.myklebust@hammerspace.com, vincent.guittot@linaro.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only standard tools that support SIGINFO are sleep, dd and ping,
(and kill, for obvious reasons) so it's not like there's a vast hole
in the tooling or something, nor is there a large legacy software base
just waiting for SIGINFO to appear.   So while I very much enjoyed
figuring out how to make SIGINFO work ...

I'll have the VSTATUS patch out in a little bit.

I also think there might be some merit in consolidating the 10
'sigsetsize != sizeof(sigset_t)' checks in a macro and adding comments
that wave people off on trying to do what I did.  If that would be
useful, happy to provide the patch.

On Tue, Jan 4, 2022 at 2:23 PM Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Jan 04, 2022 at 04:05:26PM -0600, Eric W. Biederman wrote:
> >
> > That is all as expected, and does not demonstrate a regression would
> > happen if SIGPWR were to treat SIG_DFL as SIG_IGN, as SIGWINCH, SIGCONT,
> > SIGCHLD, SIGURG do.  It does show there is the possibility of problems.
> >
> > The practical question is does anything send SIGPWR to anything besides
> > init, and expect the process to handle SIGPWR or terminate?
>
> So if I *cared* about SIGINFO, what I'd do is ask the systemd
> developers and users list if there are any users of the sigpwr.target
> feature that they know of.  And I'd also download all of the open
> source UPS monitoring applications (and perhaps documentation of
> closed-source UPS applications, such as for example APC's program) and
> see if any of them are trying to send the SIGPWR signal.
>
> I don't personally think it's worth the effort to do that research,
> but maybe other people care enough to do the work.
>
> > > I claim, though, that we could implement VSTATUS without implenting
> > > the SIGINFO part of the feature.
> >
> > I agree that is the place to start.  And if we aren't going to use
> > SIGINFO perhaps we could have an equally good notification method
> > if anyone wants one.  Say call an ioctl and get an fd that can
> > be read when a VSTATUS request comes in.
> >
> > SIGINFO vs SIGCONT vs a fd vs something else is something we can sort
> > out when people get interested in modifying userspace.
>
>
> Once VSTATUS support lands in the kernel, we can wait and see if there
> is anyone who shows up wanting the SIGINFO functionality.  Certainly
> we have no shortage of userspace notification interfaces in Linux.  :-)
>
>                                               - Ted
