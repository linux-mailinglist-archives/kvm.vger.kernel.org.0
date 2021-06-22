Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2542B3AFE51
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFVHvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:51:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230174AbhFVHvC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624348126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w3/ExjzsF+2HstscGugNhVD5aJGwY7/sJV7g6WW6sRQ=;
        b=TTFBkyYIcFWz8OCJC5MWf1WZNEfZoMU58HfLaphIMFXnu8o0AL9dQBnr25NhOhsdNxxV/4
        vjEbk073JOrU/SguETfdtEiffPYd4ufQbDttUaSrryAvIlIyxIlH6RMWgfx3kmV8aHi3Aj
        RtKq9M6Bh2dyJ6c3hNQEJwOP4AlaKg4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-UV1kOFZZN-CRXX00w7YajQ-1; Tue, 22 Jun 2021 03:48:44 -0400
X-MC-Unique: UV1kOFZZN-CRXX00w7YajQ-1
Received: by mail-ed1-f70.google.com with SMTP id cb4-20020a0564020b64b02903947455afa5so7218289edb.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w3/ExjzsF+2HstscGugNhVD5aJGwY7/sJV7g6WW6sRQ=;
        b=pyVcmbn/ZumLQWiEIlE4zs2h+k/tUgS/MOBkhrXVMvceBOWzDqcYIW/3QlYnBHaIBX
         evmyx7N1go5lVQr9Mnz0lS6ejCmjK3oR5SJ51hGFQNq+bSPKotRk08t0gO4gjVMfq3e9
         n6cj/4PKFcGfqE953aOI+YdwCjFmK7VLPdw99FRmlPrhLnKIrD/DxveVAJqGaI+QiZFx
         e+QqYhndX06jxoEI8Rt7bgyVbrpcIjKK+IbENBCGdKffjEOQzjFgExZdx9FgeutoiIJy
         tHd6apERSZ9XB8dghIxHFAmjwNZ3GSTGMcfhzY3+0DkAV+jHwOXYolr+YketvLvkRKz/
         Riiw==
X-Gm-Message-State: AOAM533qYSXTS0k7Q1jMZita1xldpifymLXkvYLFKaLbyyGm05ipgxBZ
        n3V9nmKu6C3R5zdrtxeBSRAluVhCXIIYeFTxH1T4sP7xomqcsE/2/kJZIcFChsslUOrwR6oJHX2
        Iu8wv19novKxw
X-Received: by 2002:a17:907:2651:: with SMTP id ar17mr2588837ejc.135.1624348123786;
        Tue, 22 Jun 2021 00:48:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQPANaf1gnr3VrtMggQ7XkKBkZxYQrVYm1TCYwqOu7GPYzFbd0SPFej6fHnHmwig2VtLVGZg==
X-Received: by 2002:a17:907:2651:: with SMTP id ar17mr2588817ejc.135.1624348123579;
        Tue, 22 Jun 2021 00:48:43 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id g8sm11771648edw.89.2021.06.22.00.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 00:48:43 -0700 (PDT)
Date:   Tue, 22 Jun 2021 09:48:41 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 0/5] KVM: arm64: selftests: Fix get-reg-list
Message-ID: <20210622074841.in2halgoakruglzs@gator>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210622070732.zod7gaqhqo344vg6@gator>
 <878s32cq1o.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s32cq1o.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 08:32:51AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On Tue, 22 Jun 2021 08:07:32 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > On Mon, May 31, 2021 at 12:33:39PM +0200, Andrew Jones wrote:
> > > v3:
> > >  - Took Ricardo's suggestions in order to avoid needing to update
> > >    prepare_vcpu_init, finalize_vcpu, and check_supported when adding
> > >    new register sublists by better associating the sublists with their
> > >    vcpu feature bits and caps [Ricardo]
> > >  - We now dynamically generate the vcpu config name by creating them
> > >    from its sublist names [drew]
> > > 
> > > v2:
> > >  - Removed some cruft left over from a previous more complex design of the
> > >    config command line parser
> > >  - Dropped the list printing factor out patch as it's not necessary
> > >  - Added a 'PASS' output for passing tests to allow testers to feel good
> > >  - Changed the "up to date with kernel" comment to reference 5.13.0-rc2
> > > 
> > > 
> > > Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> > > userspace when not available") the get-reg-list* tests have been
> > > failing with
> > > 
> > >   ...
> > >   ... There are 74 missing registers.
> > >   The following lines are missing registers:
> > >   ...
> > > 
> > > where the 74 missing registers are all PMU registers. This isn't a
> > > bug in KVM that the selftest found, even though it's true that a
> > > KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> > > flag, but still expecting the PMU registers to be in the reg-list,
> > > would suddenly no longer have their expectations met. In that case,
> > > the expectations were wrong, though, so that KVM userspace needs to
> > > be fixed, and so does this selftest.
> > > 
> > > We could fix the test with a one-liner since we just need a
> > > 
> > >   init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> > > 
> > > in prepare_vcpu_init(), but that's too easy, so here's a 5 patch patch
> > > series instead :-)  The reason for all the patches and the heavy diffstat
> > > is to prepare for other vcpu configuration testing, e.g. ptrauth and mte.
> > > With the refactoring done in this series, we should now be able to easily
> > > add register sublists and vcpu configs to the get-reg-list test, as the
> > > last patch demonstrates with the pmu fix.
> > > 
> > > Thanks,
> > > drew
> > > 
> > > 
> > > Andrew Jones (5):
> > >   KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
> > >   KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs
> > >     at once
> > >   KVM: arm64: selftests: get-reg-list: Provide config selection option
> > >   KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
> > >   KVM: arm64: selftests: get-reg-list: Split base and pmu registers
> > > 
> > >  tools/testing/selftests/kvm/.gitignore        |   1 -
> > >  tools/testing/selftests/kvm/Makefile          |   1 -
> > >  .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 -
> > >  .../selftests/kvm/aarch64/get-reg-list.c      | 439 +++++++++++++-----
> > >  4 files changed, 321 insertions(+), 123 deletions(-)
> > >  delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> > > 
> > > -- 
> > > 2.31.1
> > >
> > 
> > Gentle ping.
> > 
> > I'm not sure if I'm pinging Marc or Paolo though. MAINTAINERS shows Paolo
> > as all kvm selftests, but I think Marc has started picking up the AArch64
> > specific kvm selftests.
> 
> I'm happy to queue this series.
> 
> > Marc, if you've decided to maintain AArch64 kvm selftests, would you be
> > opposed to adding
> > 
> >   F: tools/testing/selftests/kvm/*/aarch64/
> >   F: tools/testing/selftests/kvm/aarch64/
> > 
> > to "KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"?
> 
> No problem to add this, but I *will* rely on you (and whoever wants to
> part-take) to do the bulk of the reviewing. Do we have a deal?

It's a deal. Thanks!

drew

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

