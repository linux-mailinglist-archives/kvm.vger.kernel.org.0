Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCB2F3F9B
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbhALW3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 17:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394592AbhALW3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 17:29:06 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C49C061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 14:28:26 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p18so115362pgm.11
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 14:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jKIXNkDnv+LH0iozvbbc4c92HnvXaZ+MtD53RZRxsSQ=;
        b=ELxDFPTYb2RNZavQkPRkQP/legx2gjv58wWggJzQ0ToW08+Gdv7JscmGQjrCtYedmY
         2MdPdN2TfWOV3BaVT3aCcgPtz99pwB3iBHA18tCJ0xgU1+zlTgePl5yQ7XDWnYtEyvxq
         0xYRmmwFx4iri0lVfTmJmea7nlAKz4pd28f3mP9rFktLQSgJurK/BUaT8Y6QYpzXmb0l
         CjdOBO8EhnSU2r495WQ03K0ZuEczHb96aXXC7KNvpxmpjvB7u1QjrL2Kdm36N4hL8P+W
         hz9EcVBLtjhFdx2OMCY3b3D5Su1JccZX7XSGyhXgnPX/xzVWP+1urI5QHl9R98ypP1nx
         erIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jKIXNkDnv+LH0iozvbbc4c92HnvXaZ+MtD53RZRxsSQ=;
        b=CXkBTHnr1eDWQa+DfJ9DJuvwdzXDFoAQMppAURSh9icvBIKBQwz8tQeTi8o1Rwl0JA
         oazAlzBJfGO3AO77/9p3UGXPSsoXhHWhOh3d6MpzGUkPG5PoY0PlLeCbJkHBsgb8gTpZ
         svy9qfmVTexT51smrh3xQf2D5AWYiB970dqoml5vbN36yQJK3/LSR9F6lRSYJybGaFvi
         G3pqhCHgCA9VKuPGFJF0SsLl5AzqXbbkPNvgYcmBi8rHajfnojubUeGWjRknt+ZaLpVW
         /io0NVAhnsN5qJIoCAO/W8OtAsqwkHKAVq8tT3TlUG3L9lS9zFGUd7yQB00YGZMn4Wo8
         pH6Q==
X-Gm-Message-State: AOAM530zTu+SDWNXEjhqrfMLVUHV/4g0XgWiJ3SS7aqvoZS+jXof7hIi
        h8mN+j3ZoYwWTVkdComrT2pFp2HRf6RF4g==
X-Google-Smtp-Source: ABdhPJwksddjG6jFCvI6lDmW75hj6gKg+5UE54KeAKCtqMk1AA1NxpZdG5H7Jqe+h8RpBd4kRrA9VA==
X-Received: by 2002:a62:528c:0:b029:19e:4a39:d9ea with SMTP id g134-20020a62528c0000b029019e4a39d9eamr1443668pfb.20.1610490505636;
        Tue, 12 Jan 2021 14:28:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id q70sm37684pja.39.2021.01.12.14.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 14:28:24 -0800 (PST)
Date:   Tue, 12 Jan 2021 14:28:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <X/4igkJA1ZY5rCk7@google.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 02, 2021, Paolo Bonzini wrote:
> On 28/12/20 23:25, Sean Christopherson wrote:
> > On Wed, Dec 23, 2020, Paolo Bonzini wrote:
> > > This short series adds a generic stress test to KVM unit tests that runs a
> > > series of
> > 
> > Unintentional cliffhanger?
> 
> ... event injections, timer cycles, memory updates and TLB invalidations.
> 
> > > The configuration of the test is set individually for each VCPU on
> > > the command line, for example:
> > > 
> > >     ./x86/run x86/chaos.flat -smp 2 \
> > >        -append 'invtlb=1,mem=12,hz=100  hz=250,edu=1,edu_hz=53,hlt' -device edu
> > > 
> > > runs a continuous INVLPG+write test on 1<<12 pages on CPU 0, interrupted
> > > by a 100 Hz timer tick; and keeps CPU 1 mostly idle except for 250 timer
> > > ticks and 53 edu device interrupts per second.
> > 
> > Maybe take the target cpu as part of the command line instead of implicitly
> > defining it via group position?
> 
> Sure, the command line syntax can be adjusted.
> 
>   The "duplicate" hz=??? is confusing.  E.g.
> > 
> >      ./x86/run x86/chaos.flat -smp 2 \
> >        -append 'cpu=0,invtlb=1,mem=12,hz=100 cpu=1,hz=250,edu=1,edu_hz=53,hlt' -device edu
> > 
> > > For now, the test runs for an infinite time so it's not included in
> > > unittests.cfg.  Do you think this is worth including in kvm-unit-tests,
> > 
> > What's the motivation for this type of test?  What class of bugs can it find
> > that won't be found by existing kvm-unit-tests or simple boot tests?
> 
> Mostly live migration tests.  For example, Maxim found a corner case in
> KVM_GET_VCPU_EVENTS that affects both nVMX and nSVM live migration (patches
> coming), and it is quite hard to turn it into a selftest because it requires
> the ioctl to be invoked exactly when nested_run_pending==1.  Such a test
> would allow stress-testing live migration without having to set up L1 and L2
> virtual machine images.

Ah, so you run the stress test in L1 and then migrate L1?

What's the biggest hurdle for doing this completely within the unit test
framework?  Is teaching the framework to migrate a unit test the biggest pain?
Writing a "unit test" that puts an L2 guest into a busy loop doesn't seem _that_
bad.
