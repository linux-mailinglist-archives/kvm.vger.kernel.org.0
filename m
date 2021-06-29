Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA3E3B764F
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 18:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhF2QQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 12:16:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231892AbhF2QQU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 12:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624983232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aLJ/SKVwJwB/WabGPGWzqfQWr3aEvu38+kKgAkvXE/g=;
        b=YOnlYj28Tl1BnS3jv92Hqz+omRZhS/P4bXN3W24oBId5OouBFnXFgoye/78pTheISW5Hbf
        BjPP6ydpbE6RsWPMtCKSt27yA3pNYI9vb8EwszPAe7wCxNmP1NX0M0wSiKmtvPM2Ux99uV
        zSn4IGf5l5qLf/vniLtvhRC9/Myg6pI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-U4JZc-EwObOAKkq6yT5ZHQ-1; Tue, 29 Jun 2021 12:13:51 -0400
X-MC-Unique: U4JZc-EwObOAKkq6yT5ZHQ-1
Received: by mail-ej1-f69.google.com with SMTP id de48-20020a1709069bf0b029048ae3ebecabso5895269ejc.16
        for <kvm@vger.kernel.org>; Tue, 29 Jun 2021 09:13:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aLJ/SKVwJwB/WabGPGWzqfQWr3aEvu38+kKgAkvXE/g=;
        b=XDb1TrYDlHULV7EP1dMZV600exPyybjtl+PiDe/beVBX6txOihpM/fl+Nu1zZxgwv+
         zteNEQPYBIMRU0zErtTaWSfsnDO76CXFrmllTTuPXmKRqn6Z/btg3BxdtBkZmW0wb+vv
         ZX2I/HjCZz/xMd3e8msx4QC1fR6bdbiDpiDzCy2qyOuP+XxGCSBOsA2qoogcJpb6nAUZ
         xGfOFQ8DZDspfjhxjHubXnDuH6uaGwpFxfCrOdoONaiyzv2nza2Xlx6JBhOx2WQKrCkU
         yZz2thlxR30a3SbPYAmSC3hvFgwz+mB8X4Eke8YPTGITgN11s7pK23tjMxQYchfMMEIG
         5/iQ==
X-Gm-Message-State: AOAM533uzK68XodkY1IP3Zv/yAyvOCZpztenmJnc0775otIgYOgS+2z0
        v+FfEsTI+7H1HGO4/DqacOYs2kxa/KJR+9HdTUTT6PhZ7IOfl2NDiGR+GixNQOMA0I5M9dNMt3c
        laLz6DTuBSmdP
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr40598823edb.214.1624983229875;
        Tue, 29 Jun 2021 09:13:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYLbqmP6sK8vu6t1aK1eC6oNBWi6amiphRZMnr9QhdWtWQKVdiBEw+4XNqQwnomlQFR259lw==
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr40598805edb.214.1624983229650;
        Tue, 29 Jun 2021 09:13:49 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id g23sm8402309ejh.116.2021.06.29.09.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 09:13:49 -0700 (PDT)
Date:   Tue, 29 Jun 2021 18:13:46 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
Message-ID: <20210629161346.txzpeyqq2r2uaqyy@gator>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
 <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
 <d28b8ee3-6957-a987-10da-727110343b8e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d28b8ee3-6957-a987-10da-727110343b8e@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29, 2021 at 04:32:36PM +0300, Nikos Nikoleris wrote:
> Hi all,
> 
> On 14/04/2021 11:42, Andrew Jones wrote:
> > On Tue, Apr 13, 2021 at 05:52:37PM +0100, Nikos Nikoleris wrote:
> > > On 24/03/2021 17:13, Nikos Nikoleris wrote:
> > > > This set of patches makes small changes to the build system to allow
> > > > easy integration of tests not included in the repository. To this end,
> > > > it adds a parameter to the configuration script `--ext-dir=DIR` which
> > > > will instruct the build system to include the Makefile in
> > > > DIR/Makefile. The external Makefile can then add extra tests,
> > > > link object files and modify/extend flags.
> > > > 
> > > > In addition, to demonstrate how we can use this functionality, a
> > > > README file explains how to use litmus7 to generate the C code for
> > > > litmus tests and link with kvm-unit-tests to produce flat files.
> > > > 
> > > > Note that currently, litmus7 produces its own independent Makefile as
> > > > an intermediate step. Once this set of changes is committed, litmus7
> > > > will be modifed to make use hook to specify external tests and
> > > > leverage the build system to build the external tests
> > > > (https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).
> > > > 
> > > 
> > > Just wanted to add that if anyone's interested in trying out this series
> > > with litmus7 I am very happy to help. Any feedback on this series or the way
> > > we use kvm-unit-tests would be very welcome!
> > 
> > Hi Nikos,
> > 
> > It's on my TODO to play with this. I just haven't had a chance yet. I'm
> > particularly slow right now because I'm in the process of handling a
> > switch of my email server from one type to another, requiring rewrites
> > of filters, new mail synchronization methods, and, in general, lots of
> > pain... Hopefully by the end of this week all will be done. Then, I can
> > start ignoring emails on purpose again, instead of due to the fact that
> > I can't find them :-)
> > 
> > Thanks,
> > drew
> > 
> 
> Just wanted to revive the discussion on this. In particular there are two
> fairly small changes to the build system that allow us to add external tests
> (in our case, generated using litmus7) to the list of tests we build. This
> is specific to arm builds but I am happy to look into generalizing it to
> include all archs.
>

Hi Nikos,

I just spent a few minutes playing around with litmus7. I see the
litmus/libdir/kvm-*.cfg files in herdtools7[1] are very kvm-unit-tests
specific. They appear to absorb much of the kvm-unit-tests Makefile
paths, flags, cross compiler prefixes, etc. Are these .cfg files the
only kvm-unit-tests specific files in herdtools7?

Here's a half-baked proposal that I'd like your input on:

 1) Generate the kvm-unit-tests specific .cfg files in kvm-unit-tests when
    configured with a new --litmus7 configure switch. This will ensure
    that the paths, flags, etc. will be up to date in the .cfg file.
 2) Add kvm-unit-tests as a git submodule to [1] to get access to the
    generated .cfg files and to build the litmus tests for kvm-unit-tests.
    A litmus7 command will invoke the kvm-unit-tests build (using
    make -C).
 3) Create an additional unittests.cfg file (e.g. litmus7-tests.cfg) for
    kvm-unit-tests that allows easily running all the litmus7 tests.
    (That should also allow 'make standalone' to work for litmus7 tests.)
 4) Like patch 3/3 already does, document the litmus7 stuff in
    kvm-unit-tests, so people understand the purpose of the --litmus7
    configure switch and also to inform them of the ability to run
    additional tests and how (by using [1]).

[1] https://github.com/herd/herdtools7.git 

Thanks,
drew

