Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AC2368448
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhDVP6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 11:58:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDVP6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 11:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619107088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A+D2duNY6Jz6vEcKAT3xK6NwCd9dhD5XS9gTlIjixsw=;
        b=aOqeRjzLVgv4ITup7bcZGcnWCMbz7KZ6V6YPFbkJovl0gejE9e4R4D11NQ43gjDh5wt0hN
        wC5OAIZjKWfnqyJQcZ76H1QGQRdYzFtOYhoYX+D6ivR3N0+gZ0iJLcadFBQHbwLTDJ/SyT
        QHXKfEsY6IJ3HnNW4euD9OxMVoq4Rec=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-grvWMv3XP2KlIfroAAS2jA-1; Thu, 22 Apr 2021 11:58:01 -0400
X-MC-Unique: grvWMv3XP2KlIfroAAS2jA-1
Received: by mail-wm1-f71.google.com with SMTP id o7-20020a1c41070000b02901336831e90fso1784020wma.4
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A+D2duNY6Jz6vEcKAT3xK6NwCd9dhD5XS9gTlIjixsw=;
        b=raoqInVXL0Zj2Ll1AZulbzo5L5lywH7myn+WyK0LzOzfl4hStk6vZejsQxD+k0Gx0i
         QF5fRHRmgJT2nBmjYSSVr8LAw5MoFhjJQMgaymKe499fFxqp4oEwVt3TT05OkBmXgs6r
         0FU9O42opqIzLfX/jyO8WjyEdMhojzHCaIT57PM+tANxzGMwkBuOfuyYmhwMmX5P9xel
         uDFhd9xwEvaKy7IofvTAXeldkaANdziMsSLPNU0L+hYQLoXXT4peXfyHLM9hK68+w+Fd
         GJUsSx76CyOXtI7NAlqe0SxvnOFf1S98oWriQ+UQptfU0Z7QORS+lYQfS+kBa6iplsRF
         hnRQ==
X-Gm-Message-State: AOAM5301S90AQaSQXjmbUCbtRDRUHiQpKNnCx7xDKepzLhGLXwZhDAbo
        Kyme8tDQgaaYJHzhVZRvrzdqMBjH7Iqr06aD9oI/p037BEjQkI4YI2qahWPT+JoFcQYusIGiS1V
        svjZUP0lZLkOA
X-Received: by 2002:a1c:6709:: with SMTP id b9mr760597wmc.56.1619107080313;
        Thu, 22 Apr 2021 08:58:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJcWLTOHJxFOQB3JHKtX9wIpaWaYcPOqbAAKCb6qD6isl9e5hO+ELChr11nzNKNkT3fLLD3Q==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr760580wmc.56.1619107080126;
        Thu, 22 Apr 2021 08:58:00 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id o4sm5132985wrn.81.2021.04.22.08.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 08:57:59 -0700 (PDT)
Date:   Thu, 22 Apr 2021 17:57:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm
 with --target
Message-ID: <20210422155757.t4pvv6blkvoyi2oy@gator>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
 <20210420165101.irbx2upgqbazkvlt@gator.home>
 <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 04:17:27PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/20/21 5:51 PM, Andrew Jones wrote:
> > Hi Alex,
> >
> > On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
> >> This is an RFC because it's not exactly clear to me that this is the best
> >> approach. I'm also open to using a different name for the new option, maybe
> >> something like --platform if it makes more sense.
> > I like 'target'.
> >
> >> I see two use cases for the patch:
> >>
> >> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
> >> as opposed to a KVM guest (described in the commit message).
> >>
> >> 2. This is speculation on my part, but I can see extending
> >> arm/unittests.cfg with a "target" test option which can be used to decide
> >> which tests need to be run based on the configure --target value. For
> >> example, migration tests don't make much sense on kvmtool, which doesn't
> >> have migration support. Similarly, the micro-bench test doesn't make much
> >> sense (to me, at least) as an EFI app. Of course, this is only useful if
> >> there are automated scripts to run the tests under kvmtool or EFI, which
> >> doesn't look likely at the moment, so I left it out of the commit message.
> > Sounds like a good idea. unittests.cfg could get a new option 'targets'
> > where a list of targets is given. If targets is not present, then the
> > test assumes it's for all targets. Might be nice to also accept !<target>
> > syntax. E.g.
> >
> > # builds/runs for all targets
> > [mytest]
> > file = mytest.flat
> >
> > # builds/runs for given targets
> > [mytest2]
> > file = mytest2.flat
> > targets = qemu,kvmtool
> >
> > # builds/runs for all targets except disabled targets
> > [mytest3]
> > file = mytest3.flat
> > targets = !kvmtool
> 
> That's sounds like a good idea, but to be honest, I would wait until someone
> actually needs it before implementing it. That way we don't risk not taking a use
> case into account and then having to rework it.

Don't we have a usecase? Above you said that kvmtool should at least skip
the migration tests.

> 
> >
> > And it wouldn't bother me to have special logic for kvmtool's lack of
> > migration put directly in scripts/runtime.bash
> 
> Good to keep in mind when support is added.
> 
> >
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 132389c7dd59..0d5cb51df4f4 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -132,7 +132,7 @@ function run()
> >      }
> >  
> >      cmdline=$(get_cmdline $kernel)
> > -    if grep -qw "migration" <<<$groups ; then
> > +    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
> >          cmdline="MIGRATION=yes $cmdline"
> >      fi
> >      if [ "$verbose" = "yes" ]; then
> >
> >> Using --vmm will trigger a warning. I was thinking about removing it entirely in
> >> a about a year's time, but that's not set in stone. Note that qemu users
> >> (probably the vast majority of people) will not be affected by this change as
> >> long as they weren't setting --vmm explicitely to its default value of "qemu".
> >>
> > While we'd risk automated configure+build tools, like git{hub,lab} CI,
> > failing, I think the risk is pretty low right now that anybody is using
> > the option. Also, we might as well make them change sooner than later by
> > failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
> > we are concerned about the disruption, then I'd just make vmm an alias
> > for target and not bother deprecating it ever.
> 
> I also think it will not be too bad if we make the change now, but I'm not sure
> what you mean by making vmm an alias of target. The patch ignores --vmm is it's
> not specified, and if it is specified on the configure command line, then it must
> match the value of --target, otherwise configure fails.
>

The current patch does both things; it says don't use --vmm and it says
the new --vmm is --target. I'm saying do one or the other. Either
completely rename vmm to target, which will then error out when vmm is
specified as an unknown option or allow the user to use either --vmm or
--target with no error and where both mean to do the same thing, which is
to set the TARGET variable.

Thanks,
drew

