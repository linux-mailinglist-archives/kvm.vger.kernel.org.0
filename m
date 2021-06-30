Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E313B86C0
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhF3QGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 12:06:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235889AbhF3QGT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 12:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625069030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FS5ojfhO5/yVKj1V0nH6bL6f/AE7ImYMI8LkO28luFQ=;
        b=SsMt49dkKtvzXynzRs/J0jdjohAwhAjdp9rM+qaX9DA6T7VY2/GIeunwjTTkwUcPowvdCS
        6DOwrokkE1Gvr2Rs0qz149n0a5fkebyCni1R3HhYBBHXh2oVfJ3jBvPOiMSGmyt7/PRcGd
        gK6byNhDk1ue6ryuVnRk6Q2Zoggo7Zo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-wMJx7wefNiiAHFNAjyYE-A-1; Wed, 30 Jun 2021 12:03:48 -0400
X-MC-Unique: wMJx7wefNiiAHFNAjyYE-A-1
Received: by mail-ej1-f70.google.com with SMTP id de48-20020a1709069bf0b029048ae3ebecabso948306ejc.16
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FS5ojfhO5/yVKj1V0nH6bL6f/AE7ImYMI8LkO28luFQ=;
        b=T2pm1n2mO+qAPacpDLluzOiOcED5TKbkBxGptZrDHJc3fKgt851vQfZM5pa5F1irSu
         YBoJK/9uoXHzR3xn25w9dwkOCWwXHwLF8o62DENJjBemYAwVIwpzwn0iEPG9G90ABcsP
         lli21zhvjm+9YRuRZxhgwz09noBPM+bqdapu2EG4fvdN6EvB2ZlwlXfaFq3Xm05T8aLb
         eZ0irCKeOUPZeVp/+wwsq/iOtyCMqFnuxREZwyL9WoKHOjaJUaWy7bHp3N4EafDEK3r/
         QbOZMWY5N5L60TAMswypGO9GqrdGB5xLHxQxRv6flvOInfAX5etJdtH1fvQKh8etSPZf
         vUSQ==
X-Gm-Message-State: AOAM533h6mNG8u4KDtUZ/cwytxcA0nqh3gh9tLL7+Obr1tnykKedEDGj
        8GtXviU1Ph+2K/pS8/Z5EcjY3cbK4lcplS9ObTUqTBFmigNzRkUOJXv3UakUujMCROgBGwI1vGq
        AX3jhKNwI0XLQ
X-Received: by 2002:aa7:c88c:: with SMTP id p12mr47674052eds.244.1625069027314;
        Wed, 30 Jun 2021 09:03:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFjTWumRyG3pyxayke0q2tQGcH+jVUYAVJtH1AWyTLwt9G6/xTDbpIIwENkFjXBgGIrowtag==
X-Received: by 2002:aa7:c88c:: with SMTP id p12mr47674025eds.244.1625069027068;
        Wed, 30 Jun 2021 09:03:47 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id s18sm9741487ejh.12.2021.06.30.09.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:03:46 -0700 (PDT)
Date:   Wed, 30 Jun 2021 18:03:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
Message-ID: <20210630160344.jvoqs2k56ki34e4n@gator.home>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
 <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
 <d28b8ee3-6957-a987-10da-727110343b8e@arm.com>
 <20210629161346.txzpeyqq2r2uaqyy@gator>
 <3d5e3769-a48b-03b8-a97b-3b2e533e676c@arm.com>
 <20210630122350.6nnuxa4yvjjfli7e@gator.home>
 <1a3d8df3-fb1e-24cb-8ab0-e0bbc5053331@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a3d8df3-fb1e-24cb-8ab0-e0bbc5053331@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021 at 05:19:57PM +0300, Nikos Nikoleris wrote:
> On 30/06/2021 15:23, Andrew Jones wrote:
...
> > It also looks derived from kvm-unit-tests:arm/Makefile.common. So why not
> > just modify that instead? Possibly creating a new make target in order to
> > accommodate any differences.
> > 
> 
> I was trying to completely get rid of
> herdtools:litmus/libdir/_aarch64/kvm.rules and the cfg files because they
> are replicating much of kvm-unit-tests:arm/Makefile.common and
> kvm-unit-tests:Makefile. If I understand correctly in your proposal we will
> generate them automatically?

Either generate or add lines to kvm-unit-tests Makefiles which can be used
when building a litmus7 specific build target, e.g. 'make litmus7'

> 
> > > 
> > > >    2) Add kvm-unit-tests as a git submodule to [1] to get access to the
> > > >       generated .cfg files and to build the litmus tests for kvm-unit-tests.
> > > >       A litmus7 command will invoke the kvm-unit-tests build (using
> > > >       make -C).
> > > 
> > > That's possible but it doesn't solve the biggest problem which is figuring
> > > out what is the command(s) we need to run to link an elf and subsequently
> > > generate a flat file.
> > 
> > Shouldn't all those commands be in the Makefiles that will be used as part
> > of the 'make -C <kut-submodule-dir>' call?
> > 
> 
> Without making any changes to the existing kvm-unit-tests build system 'make
> -C <kut-submodule-dir>' will build all objects and flat files for the
> existing tests. Or am I missing something?

You can modify kvm-unit-tests Makefiles if necessary. And/or add a new
one, e.g. arm/Makefile.litmus7

> 
> > > 
> > > >    3) Create an additional unittests.cfg file (e.g. litmus7-tests.cfg) for
> > > >       kvm-unit-tests that allows easily running all the litmus7 tests.
> > > >       (That should also allow 'make standalone' to work for litmus7 tests.)
> > > 
> > > This is a good point I can have a look at how we could add this.
> > > 
> > > >    4) Like patch 3/3 already does, document the litmus7 stuff in
> > > >       kvm-unit-tests, so people understand the purpose of the --litmus7
> > > >       configure switch and also to inform them of the ability to run
> > > >       additional tests and how (by using [1]).
> > > > 
> > > 
> > > Overall it would be great if we could piggyback on the build system of
> > > kvm-unit-tests rather than try to re-generate (part of) it. This is what the
> > > patch 2/3 tries to do. This is not solving the problem in a way that is
> > > specific to litmus7 and allows for adding more source files to the all-tests
> > > list.
> > 
> > Patch 2/3 only adds the ability to add a new dir to look at. It leaves
> > everything else up to litmus7 build code to duplicate what it needs and
> > also manual commands to populate that new directory. I'd rather we have a
> > more coherent solution.
> > 
> > We want to build litmus7 tests as kvm-unit-tests. We can look at this two
> > ways: 1) we want to add litmus7 tests to kvm-unit-tests or 2) we want to
> > build litmus7 tests for kvm-unit-tests.
> >  > This patch series is going for (1), but without actually committing the
> > tests to kvm-unit-tests. I'm arguing we should do (2), especially since
> > the litmus7 build code already appears to need to know about
> > kvm-unit-tests.
> > 
> 
> I was more looking to add support for external tests similar to the idea of
> having external modules to the linux kernel. The implementation might not be
> ideal; I didn't want the changes to be very intrusive but if that's the
> problem then I am happy to make changes.

I don't expect the changes to be too intrusive and they can probably be
mostly isolated into their own Makefile.litmus7 file if necessary.

> 
> As for assumptions, the external dir needs to have at least a .c file for
> the code of the test, a minimal Makefile specifying tests and object files
> and as you pointed out a unittests.cfg.
> 
> If we ignore litmus7 for a bit, the general question is, I have a test
> (e.g., kvm-unit-test:arm/selftest.c) which is not part of the tree and not
> in the build system, how can I build the corresponding flat or efi file
> based on it?
> 
> I think your proposal, is more in line with what we do now. At least, we
> would automatically generate the config files. kvm-unit-tests generates
> config files, which litmus7 would use as input to generate a Makefile. I
> wanted to move away from that but we can live with it. Also note that if we
> added a --litmus7 configure switch, it would be very specific to way we do
> things in litmus7.

Let's see what it looks like. I'm having trouble imagining how this repo
combination will work, but I'm optimistic that it's doable without too
many changes to either repo. And most the specific to litmus7 stuff should
still be in the litmus7 repo, even if we need kvm-unit-tests to be aware
of some build differences and therefore provide the configure switch.

> 
> > I think we should only need to modify the build scripts of litmus7 to
> > use/build kvm-unit-tests as a submodule and to somehow build litmus7
> > tests with it. Also, litmus7 test running could be done from the
> > litmus7 build repo or kvm-unit-tests standalone tests could built for
> > litmus7 tests and installed elsewhere.
> > 
> > A final note on patch 2/3. Why not just override the TEST_DIR config
> > variable with a different directory? (If it doesn't work for some
> > reason, then we could hopefully fix that.)
> > 
> 
> External (litmus7) tests target an arch (could be arm64, could be x86), and
> there are many variables inside $(TEST_DIR)/ that we would need. If I am
> building for arm64, I need arm/flat.lds and information that currently
> resides in arm/Makefile.arm64:
> 
> bits = 64
> ldarch = elf64-littleaarch64
> 
> arch_LDFLAGS = -pie -n
> CFLAGS += -mstrict-align
> 
> and if I change TEST_DIR to point to ~/litmus7_tests I will need to
> replicate all that somewhere else.
> 
> I am not saying that it would be impossible to override TEST_DIR but it
> doesn't make things simple.

It'd probably be safe to change the build scripts to use something
like $ARCH/Makefile.$ARCH and $ARCH/flat.lds, but we'll need a
arm64 -> arm link. Overriding TEST_DIR may not be easier, but I
think it's worth experimenting with it, since I feel like it would
be cleaner than the "add an arbitrary directory" configure switch.

Thanks,
drew

