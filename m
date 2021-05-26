Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07F83913D3
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhEZJd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:33:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233599AbhEZJdt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 05:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622021537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0QEwaUio+l4PhkxpW6dJzymlevSAwmMq8o5++mT+tA=;
        b=h+mHZFzoN/k51A1ca4vKQ/5RbvewiuL7DkucU14qi9F1nEKkHyOk6t8cVveaswUcPAF8z7
        n63NGmLb+knHnWEIPLyMwvHxwGEK8wmufRnkbr2tawP7c8rYxoK1VkXxbryPPkgeQ/EQyE
        rJeZaVYdzzEsoTxD3R9mjnENHwBuvbA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-64-BmDbBP1qmvp9pIrrZnA-1; Wed, 26 May 2021 05:32:15 -0400
X-MC-Unique: 64-BmDbBP1qmvp9pIrrZnA-1
Received: by mail-ej1-f70.google.com with SMTP id dt6-20020a170906b786b02903dc2a6918d6so231578ejb.1
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 02:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z0QEwaUio+l4PhkxpW6dJzymlevSAwmMq8o5++mT+tA=;
        b=pWWU+M1T6TMY9GNFgBAuvAMMCvOodlvwwLD33Cw4zjVfedAf+zUuDzlrx/Si2l8Jlu
         ibpOBZAm4O7xEALOMHSCtJLGlWvP7dA9nojMG+ExHTlyOgXmO4kE2/jP3tBA1ZwiD0/1
         UANFJnQTJZjvbriMf242Qh36c7pKv9O1b7u/K0f8JM7GBAulFd+hrShShWvLaXS6ZGqC
         mcIlIOKw9NNqxxQZMoXUgyziAgPcUL60YGwFtigIPf8yqrKM97lBjWOOQpAz4FCcgk5p
         4hsQIfTFCKlgrqP9muWlJzVmwg1NEKENRfc1gs+ISlV/KbOG88Yr7VICtHImLrN6RobO
         KHtQ==
X-Gm-Message-State: AOAM533tturKHYrhIC5YLQpe/U9Btr54oP43jyP2Weq6hWaNKp8p0zGx
        VMgSKq6sDsGO8GjVR0RRWCSp7IDln1h+/W/VKvYZREjZM/T3PaaZGPmJoayxU4i+TlFyqZ9gES9
        rOkMEx3ZGbXhH
X-Received: by 2002:aa7:cfcd:: with SMTP id r13mr36849852edy.177.1622021534396;
        Wed, 26 May 2021 02:32:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPhQgu+2Xa4WvCvZ9JhZjf/o7+Rz7zOlbTCKXBmJU13BofbOV20+LAx3eU4Sorf/UglLOV4w==
X-Received: by 2002:aa7:cfcd:: with SMTP id r13mr36849841edy.177.1622021534250;
        Wed, 26 May 2021 02:32:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id c10sm12168911eds.90.2021.05.26.02.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 02:32:13 -0700 (PDT)
Date:   Wed, 26 May 2021 11:32:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <20210526093211.loppoo42twel6inw@gator.home>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
 <YK1ZcqgyLFSDH14+@google.com>
 <87zgwhvq7r.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgwhvq7r.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 09:44:56AM +0100, Marc Zyngier wrote:
> On Tue, 25 May 2021 21:09:22 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
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
> > > be fixed, and so does this selftest. The fix for this selftest is to
> > > pull the PMU registers out of the base register sublist into their
> > > own sublist and then create new, pmu-enabled vcpu configs which can
> > > be tested.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
> > >  1 file changed, 38 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > index dc06a28bfb74..78d8949bddbd 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > @@ -47,6 +47,7 @@ struct reg_sublist {
> > >  struct vcpu_config {
> > >  	const char *name;
> > >  	bool sve;
> > > +	bool pmu;
> > >  	struct reg_sublist sublists[];
> > >  };
> > 
> > I think it's possible that the number of sublists keeps increasing: it
> > would be very nice/useful if KVM allowed enabling/disabling more
> > features from userspace (besides SVE, PMU etc).
> 
> [tangential semi-rant]
> 
> While this is a very noble goal, it also doubles the validation space
> each time you add an option. Given how little testing gets done
> relative to the diversity of features and implementations, that's a
> *big* problem.

It's my hope that this test, especially now after its refactoring, will
allow us to test all configurations easily and therefore frequently.

> 
> I'm not against it for big ticket items that result in a substantial
> amount of state to be context-switched (SVE, NV). However, doing that
> for more discrete features would require a radical change in the way
> we develop, review and test KVM/arm64.
>

I'm not sure I understand how we should change the development and
review processes. As for testing, with simple tests like this one,
we can actually achieve exhaustive configuration testing fast, at
least with respect to checking for expected registers and checking
that we can get/set_one_reg on them. If we were to try and setup
QEMU migration tests for all the possible configurations, then it
would take way too long.

Thanks,
drew

