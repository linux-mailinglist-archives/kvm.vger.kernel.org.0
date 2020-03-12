Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9EF8182725
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 03:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbgCLC4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 22:56:00 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38165 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgCLCz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 22:55:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id w1so4673193ljh.5
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 19:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hsS48m6LR9cXGJBBVG+DToxPnhsfOEVUJkGScSiXLHM=;
        b=kPPSFOlxkkXWcCwIrF9BMn05RqMqZKPh03FB7wzqY43xpwJJysDK9Ex3U5laEo7J9W
         LUwgS9CHkcBwMUr5HokC8u1L0hzjerat3N5ohJPmMptcvg18d7hyuyrOQ1KeIlPi8+5P
         4zuy8hGUikahVSMZLvJ6gWE1sMJD5BWW994bec7F2cmcVDpUbldHFVow8BtQRlvhik0i
         mZ/CuPIhzlZXTgfVCfG3c5AS3/YkrZiS6XLOggmkMdukGm82vdsSBtmIz4E4koZAIneT
         YqZEmUT8eoFi5YTHuLtOMpxrj+eydMq5t4mhojAXiEqgxxIJ5d5Rq7rg5XiBNCQOFNao
         Om9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hsS48m6LR9cXGJBBVG+DToxPnhsfOEVUJkGScSiXLHM=;
        b=aB11hTDXF0VM7g+wlCJAvw7qyELyqok+IYoWjBN0oisPAToYAQ09Ql7BsSb1WEFnUC
         2iHQbBfIhyk7vXV0JEKCTqwC7hxNG6zE4Sd8PyhMarUwrAXuzZLFB974KksZVtb3l92x
         a/ObgD11ZdnfJ80snRGsVix2pgU1mBD3tevEhLgRFOFX9tDknWEMzZ3WCLpZPwOcCKj8
         TAVwEnVPdguSQPYTC4/LtqrEWW7KAxTH4amqxexl7PFwhrgvRh/f4JFEaXa57mQ7ecBS
         NphvFyhT6WbN5KZ2GGg/hNmSSYwE2OOjBnZRhXl5f7zCQX8TxncQdYhsYkEhHi2LaXE8
         y9Og==
X-Gm-Message-State: ANhLgQ3DIwuHi5BMQsuM14IBimHBJZhcIikYTMR8pidEq6e2xyEG0JgX
        TYSRBSYvtvkvbuvMVY/i8CTCkRCBJutA17Z9tYvckQ==
X-Google-Smtp-Source: ADFU+vsahOnnT4SwaIal4nExbTEVNWe0RvajxIg8XZpCwZLxZ6k2OSf3JTEeBKwgILLBGggLDoHn8pImTsLeAL/8438=
X-Received: by 2002:a05:651c:1114:: with SMTP id d20mr3646951ljo.103.1583981757540;
 Wed, 11 Mar 2020 19:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <0a0b3815e03dcee47ca0fbf4813821877b4c2ea0.1581555616.git.ashish.kalra@amd.com>
 <CABayD+ciJiF8gf+s6d57vENcnSQPQGzTTwdo0TLBsNLdoy0tWw@mail.gmail.com> <20200312003855.GA26448@ashkalra_ubuntu_server>
In-Reply-To: <20200312003855.GA26448@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 11 Mar 2020 19:55:21 -0700
Message-ID: <CABayD+ejsAt3QZGHGhkKh7GDd89R5QzMAbwJV6FW1t88Ne=MNg@mail.gmail.com>
Subject: Re: [PATCH 04/12] KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 5:39 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> But, ret will be the value returned by __sev_issue_cmd(), so why will it
> look like -ENOMEM ?
My bad, this is fine.
>
> >
> > > +       ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
> > > +                               error);
> > > +       if (ret)
> > > +               goto e_free;
> > > +
> > > +       /* Bind ASID to this guest */
> >
> > Ideally, set ret to another distinct value, since the error spaces for
> > these commands overlap, so you won't be sure which had the problem.
> > You also wouldn't be sure if one succeeded and the other failed vs
> > both failing.
>
> Both commands "may" return the same error code as set by sev_do_cmd(), but
> then we need that very specific error code, sev_do_cmd() can't return
> different error codes for each command it is issuing ?

I'll try to separate my comment into two levels: High level response,
and pragmatic response.

--- High level ---
At the end of the day, I want to be able to handle these errors in a
reasonable way. As often as possible, I'd like userspace to be able to
see a set of errors and know what to do in response. I find this
particularly important for migration, where you are mucking around
with a live VM with customer data you don't want to lose.

One red flag for me is when one pair of {errno, SEV error code}
corresponds to two distinct situations. For example, when, in another
patch in this series, {EFAULT, SUCCESS} could have corresponded to
either the command succeeding or the command never having run. Seems
like a pretty wide range of possibilities for a single error value.

I want to try to give the return codes scrutiny now, since we are
probably going to be stuck with maintaining them indefinitely, even if
there are mistakes.

--- Pragmatic ---
There's probably a strong argument that most situations like this
don't matter, since there's nothing you can do about an error except
kill the VM (or not continue migrating) anyway. I'm pretty open to
this argument. In particular, looking at SEV RECEIVE START, I think
you could throw away this attempt at creating a migration target, and
just make a new one (pretty much without consequence), so I think my
comment on this particular patch is moot. You can't cancel the SEND
START so you will be stuck working with this particular destination
host, but you can mint a new target VM via SEV RECEIVE START.

Looking at the earlier patches, older commands seem to have the same
ambiguity. The command SEV LAUNCH START also has identical errors that
could be sourced from either of two commands. Seems like we're already
committed to ambiguity being ok.

Given that I have no further comments on this particular patch:
Reviewed-by: Steve Rutherford <srutherford@google.com>

>
> >
> > > +       ret = sev_bind_asid(kvm, start->handle, error);
> > > +       if (ret)
> > > +               goto e_free;
> > > +
>
> Thanks,
> Ashish
>
