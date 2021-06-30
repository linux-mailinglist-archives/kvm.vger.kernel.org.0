Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F763B8212
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 14:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhF3M0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 08:26:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234426AbhF3M0Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 08:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02KZVZINR5eeSJp8fjmn2mtAw2RjOU8lCXk4THynFKA=;
        b=LO9ZyvwiuxslSCa/iBkG73J+bAaZiNhEkeJMA83QQU+QRY+IaRo2yERSsG+dFiBcm9k1g6
        jdutXjVxqSOC9mNQilGnf7W1RU953qE+Dr3DbzpSbi1HChIn7ZANY69xnXY8KWuvfI14jV
        dQGm8QWjLxYL3+GEJj+Kn0vtg18XLnc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-70pqPY4lM6WOwsn8mXAKnA-1; Wed, 30 Jun 2021 08:23:54 -0400
X-MC-Unique: 70pqPY4lM6WOwsn8mXAKnA-1
Received: by mail-ej1-f71.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso708717ejp.3
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 05:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=02KZVZINR5eeSJp8fjmn2mtAw2RjOU8lCXk4THynFKA=;
        b=qBEh+xg7xeYLYOGRK6sAJks4Ku/6+UUdZdozW8YIVEfN23WUXPa7FP4G93+UNaAUkc
         w3J32YKB8NXYw1tFVUNkoi5NrtawWClNzXbPU9iVu/VvCOaXqqp6v72Qk+Pj0AQtBJTG
         bPeuXNL6QMV1SaEcsl25qtRXjlj+PQD2WR2Sn29KlOjLRoTWKtHzCpE2GMdShuG7e5/v
         JMjLXKbUDNfbMCQgvBjlq/7dDYKfN+HC00/TNXG6GabnRVbMCIvoCfJ08e/28lawR/mB
         QTcvauFoYqD9Gx3FXIqYhpKpsmBnIJL7kkAGkmRqbfXuXptS56zRpTNlM+xWCBs7miE3
         GXHg==
X-Gm-Message-State: AOAM531SyMpDvZYfEDpMbOmyWjxypl+/SFOa4W8GXGPM4kaabR/uv6LQ
        aQJyVfxSmnZERLwENi2BenHZ1xbDC41PBh4QpDH1w5GuY/imtQqpy2P8ygTXRb6pnA6DpO2eYe8
        u707PiqMZcwYG
X-Received: by 2002:aa7:dcd9:: with SMTP id w25mr45737628edu.372.1625055833162;
        Wed, 30 Jun 2021 05:23:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh9C79wqER+Wm2IP9GN1MpLgNiQ+DyzKcWB/dXKfkhrxXhsOS4PpiAbi+0B2Yuj51RcE7VGw==
X-Received: by 2002:aa7:dcd9:: with SMTP id w25mr45737603edu.372.1625055832895;
        Wed, 30 Jun 2021 05:23:52 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id ch17sm12693027edb.54.2021.06.30.05.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:23:52 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:23:50 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
Message-ID: <20210630122350.6nnuxa4yvjjfli7e@gator.home>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
 <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
 <d28b8ee3-6957-a987-10da-727110343b8e@arm.com>
 <20210629161346.txzpeyqq2r2uaqyy@gator>
 <3d5e3769-a48b-03b8-a97b-3b2e533e676c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d5e3769-a48b-03b8-a97b-3b2e533e676c@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29, 2021 at 07:49:37PM +0300, Nikos Nikoleris wrote:
> 
> 
> On 29/06/2021 19:13, Andrew Jones wrote:
> > On Tue, Jun 29, 2021 at 04:32:36PM +0300, Nikos Nikoleris wrote:
> > > Hi all,
> > > 
> > > On 14/04/2021 11:42, Andrew Jones wrote:
> > > > On Tue, Apr 13, 2021 at 05:52:37PM +0100, Nikos Nikoleris wrote:
> > > > > On 24/03/2021 17:13, Nikos Nikoleris wrote:
> > > > > > This set of patches makes small changes to the build system to allow
> > > > > > easy integration of tests not included in the repository. To this end,
> > > > > > it adds a parameter to the configuration script `--ext-dir=DIR` which
> > > > > > will instruct the build system to include the Makefile in
> > > > > > DIR/Makefile. The external Makefile can then add extra tests,
> > > > > > link object files and modify/extend flags.
> > > > > > 
> > > > > > In addition, to demonstrate how we can use this functionality, a
> > > > > > README file explains how to use litmus7 to generate the C code for
> > > > > > litmus tests and link with kvm-unit-tests to produce flat files.
> > > > > > 
> > > > > > Note that currently, litmus7 produces its own independent Makefile as
> > > > > > an intermediate step. Once this set of changes is committed, litmus7
> > > > > > will be modifed to make use hook to specify external tests and
> > > > > > leverage the build system to build the external tests
> > > > > > (https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).
> > > > > > 
> > > > > 
> > > > > Just wanted to add that if anyone's interested in trying out this series
> > > > > with litmus7 I am very happy to help. Any feedback on this series or the way
> > > > > we use kvm-unit-tests would be very welcome!
> > > > 
> > > > Hi Nikos,
> > > > 
> > > > It's on my TODO to play with this. I just haven't had a chance yet. I'm
> > > > particularly slow right now because I'm in the process of handling a
> > > > switch of my email server from one type to another, requiring rewrites
> > > > of filters, new mail synchronization methods, and, in general, lots of
> > > > pain... Hopefully by the end of this week all will be done. Then, I can
> > > > start ignoring emails on purpose again, instead of due to the fact that
> > > > I can't find them :-)
> > > > 
> > > > Thanks,
> > > > drew
> > > > 
> > > 
> > > Just wanted to revive the discussion on this. In particular there are two
> > > fairly small changes to the build system that allow us to add external tests
> > > (in our case, generated using litmus7) to the list of tests we build. This
> > > is specific to arm builds but I am happy to look into generalizing it to
> > > include all archs.
> > > 
> > 
> > Hi Nikos,
> > 
> 
> Hi Drew,
> 
> Thanks for having a look!
> 
> > I just spent a few minutes playing around with litmus7. I see the
> > litmus/libdir/kvm-*.cfg files in herdtools7[1] are very kvm-unit-tests
> > specific. They appear to absorb much of the kvm-unit-tests Makefile
> > paths, flags, cross compiler prefixes, etc. Are these .cfg files the
> > only kvm-unit-tests specific files in herdtools7?
> > 
> 
> Indeed these kvm-*.cfg files redefine much of the same variables we have in
> kvm-unit-tests make files. litmus7 uses these cfg files (and
> litmus/libdir/_aarch64/kvm.rules for the rules) to generate a standalone
> Makefile. When we call make, we compile the generated sources and link with
> kvm-unit-tests object files. The generated Makefile redefines much of the
> build system in kvm-unit-tests which is not great. If we make any change to
> the build system in kvm-unit-tests (e.g., add support for efi) we have to
> port this change to the standalone Makefile we generate using litmus7.

Right, that's why I'm suggesting that kvm-unit-tests be brought into the
litmus7 build as a submodule.

> 
> > Here's a half-baked proposal that I'd like your input on:
> > 
> >   1) Generate the kvm-unit-tests specific .cfg files in kvm-unit-tests when
> >      configured with a new --litmus7 configure switch. This will ensure
> >      that the paths, flags, etc. will be up to date in the .cfg file.
> 
> This wouldn't be enough we would also need some sort of minimal Makefile too
> (something like litmus/libdir/_aarch64/kvm.rules).

It also looks derived from kvm-unit-tests:arm/Makefile.common. So why not
just modify that instead? Possibly creating a new make target in order to
accommodate any differences.

> 
> >   2) Add kvm-unit-tests as a git submodule to [1] to get access to the
> >      generated .cfg files and to build the litmus tests for kvm-unit-tests.
> >      A litmus7 command will invoke the kvm-unit-tests build (using
> >      make -C).
> 
> That's possible but it doesn't solve the biggest problem which is figuring
> out what is the command(s) we need to run to link an elf and subsequently
> generate a flat file.

Shouldn't all those commands be in the Makefiles that will be used as part
of the 'make -C <kut-submodule-dir>' call?

> 
> >   3) Create an additional unittests.cfg file (e.g. litmus7-tests.cfg) for
> >      kvm-unit-tests that allows easily running all the litmus7 tests.
> >      (That should also allow 'make standalone' to work for litmus7 tests.)
> 
> This is a good point I can have a look at how we could add this.
> 
> >   4) Like patch 3/3 already does, document the litmus7 stuff in
> >      kvm-unit-tests, so people understand the purpose of the --litmus7
> >      configure switch and also to inform them of the ability to run
> >      additional tests and how (by using [1]).
> > 
> 
> Overall it would be great if we could piggyback on the build system of
> kvm-unit-tests rather than try to re-generate (part of) it. This is what the
> patch 2/3 tries to do. This is not solving the problem in a way that is
> specific to litmus7 and allows for adding more source files to the all-tests
> list.

Patch 2/3 only adds the ability to add a new dir to look at. It leaves
everything else up to litmus7 build code to duplicate what it needs and
also manual commands to populate that new directory. I'd rather we have a
more coherent solution.

We want to build litmus7 tests as kvm-unit-tests. We can look at this two
ways: 1) we want to add litmus7 tests to kvm-unit-tests or 2) we want to
build litmus7 tests for kvm-unit-tests.

This patch series is going for (1), but without actually committing the
tests to kvm-unit-tests. I'm arguing we should do (2), especially since
the litmus7 build code already appears to need to know about
kvm-unit-tests.

I think we should only need to modify the build scripts of litmus7 to
use/build kvm-unit-tests as a submodule and to somehow build litmus7
tests with it. Also, litmus7 test running could be done from the
litmus7 build repo or kvm-unit-tests standalone tests could built for
litmus7 tests and installed elsewhere.

A final note on patch 2/3. Why not just override the TEST_DIR config
variable with a different directory? (If it doesn't work for some
reason, then we could hopefully fix that.)

Thanks,
drew

> 
> If 2/3 was accepted then we would do something like [1]. And the generated
> Makefile for the litmus7 tests turns into something very simple:
> 
> CFLAGS += -march=armv8.1-a
> 
> tests += $(EXT_DIR)/MP.flat
> 
> cflatobjs += $(EXT_DIR)/utils.o
> cflatobjs += $(EXT_DIR)/kvm_timeofday.o
> 
> [1]: https://github.com/relokin/herdtools7/commit/6fa5ec06856c8263a0823ad21e097a39c97cabc1
> 
> Thanks,
> 
> Nikos
> 
> > [1] https://github.com/herd/herdtools7.git
> > 
> > Thanks,
> > drew
> > 
> 

