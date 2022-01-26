Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D8E49D1F9
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 19:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiAZSol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 13:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAZSok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 13:44:40 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7648C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 10:44:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x11so376811plg.6
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 10:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NAegYWjfMiY1EiEccBws2fXLDlAqm9iiC44gjvSzOHo=;
        b=G8miMWpIziGdaV0t8rpwsfXsW2z7KJxl2M4fAXiFgvvmuf8qKYm4GO6Uluhqhr+wQe
         L51M3MMlfNApwivQDOCxt87IlGvcdBhpYxodkhCZi0pMhVHKm23MAKrTRLuHBJrymlMU
         by+MYhPpyJVAqcNPLTevLg6MPXzKo1ucY1HxJWbRc5Z5wW7E4X6fU7mqY4JP63S6ALWU
         q4GboKA+lgS6zNrDl2wqaXBmJ93/+wNiTLiyR8dynNWePZvA3L+KTNKhPuJOgbffn2m4
         w3PkvN+sD2GW4fXiBG+9NfNjhgr16voSWnfLKElYq2eQpm3mIw+3eVfN87BDJKmRSsif
         8+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NAegYWjfMiY1EiEccBws2fXLDlAqm9iiC44gjvSzOHo=;
        b=C7vyJjDjEE528ak5NL/v03XffeanVLfTv6Sd6W7WyUof58cCaAgML8aHTU8oSJqLSx
         kxmg7d/FEXbiPrYlXlTY0X2NIcwIqgCxjn991wxstDky0vNkqwXWCCtxXt5/PZUfCCD/
         39nSP4sQVV9KOC+y/yFjoE4v98eQJteKxX3TUIOng/uw5xVKr1i6xY/eFaTWkfdE58BC
         NGjZIE+DoU0Ex7LsPWhLuOZLpZhXlJrsls0IVUyJXiF/PkuisIKJZx2WInG86FVYA4Nq
         m29xQs3FYUp8fVRRJKiVK4hTcYKco9vaC0pBiOUWzMMBlFbIvvW81S19LoFFyOctmqoU
         YW7A==
X-Gm-Message-State: AOAM532gvJTPr6yxckZJ42gCf7leCpC+KaKJvDBauVs2pCnDn0MmWd04
        kz7LtWxyEg32cRHuRdkdEUmYZA==
X-Google-Smtp-Source: ABdhPJxVau3Xn9Wr8b+iFCAAkbil3GMudYI9IeoEEsNxjbskdEqPHLvxmroYE5e5SfzfJygM+1Y5Kw==
X-Received: by 2002:a17:90b:4b0a:: with SMTP id lx10mr230888pjb.33.1643222680002;
        Wed, 26 Jan 2022 10:44:40 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id r14sm3668919pjo.39.2022.01.26.10.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 10:44:39 -0800 (PST)
Date:   Wed, 26 Jan 2022 10:44:36 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH 2/2] kvm: selftests: aarch64: fix some vgic related
 comments
Message-ID: <YfGWlIT37gTYFBxi@google.com>
References: <20220120173905.1047015-1-ricarkol@google.com>
 <20220120173905.1047015-3-ricarkol@google.com>
 <20220126152203.6bxqpqw2ld5r6eog@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126152203.6bxqpqw2ld5r6eog@gator>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 04:22:03PM +0100, Andrew Jones wrote:
> On Thu, Jan 20, 2022 at 09:39:05AM -0800, Ricardo Koller wrote:
> > Fix the formatting of some comments and the wording of one of them (in
> > gicv3_access_reg).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reported-by: Reiji Watanabe <reijiw@google.com>
> > Cc: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
> >  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 11 +++++++----
> >  tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
> >  3 files changed, 17 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > index e6c7d7f8fbd1..258bb5150a07 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > @@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
> >  	uint32_t prio, intid, ap1r;
> >  	int i;
> >  
> > -	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> > +	/*
> > +	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> >  	 * in descending order, so intid+1 can preempt intid.
> >  	 */
> >  	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
> > @@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
> >  		gic_set_priority(intid, prio);
> >  	}
> >  
> > -	/* In a real migration, KVM would restore all GIC state before running
> > +	/*
> > +	 * In a real migration, KVM would restore all GIC state before running
> >  	 * guest code.
> >  	 */
> >  	for (i = 0; i < num; i++) {
> > @@ -503,7 +505,8 @@ static void guest_code(struct test_args args)
> >  		test_injection_failure(&args, f);
> >  	}
> >  
> > -	/* Restore the active state of IRQs. This would happen when live
> > +	/*
> > +	 * Restore the active state of IRQs. This would happen when live
> >  	 * migrating IRQs in the middle of being handled.
> >  	 */
> >  	for_each_supported_activate_fn(&args, set_active_fns, f)
> > @@ -837,7 +840,8 @@ int main(int argc, char **argv)
> >  		}
> >  	}
> >  
> > -	/* If the user just specified nr_irqs and/or gic_version, then run all
> > +	/*
> > +	 * If the user just specified nr_irqs and/or gic_version, then run all
> >  	 * combinations.
> >  	 */
> >  	if (default_args) {
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > index e4945fe66620..93fc35b88410 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > @@ -19,7 +19,7 @@ struct gicv3_data {
> >  	unsigned int nr_spis;
> >  };
> >  
> > -#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
> > +#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
> >  #define DIST_BIT				(1U << 31)
> >  
> >  enum gicv3_intid_range {
> > @@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
> >  {
> >  	uint32_t val;
> >  
> > -	/* All other fields are read-only, so no need to read CTLR first. In
> > +	/*
> > +	 * All other fields are read-only, so no need to read CTLR first. In
> >  	 * fact, the kernel does the same.
> >  	 */
> >  	val = split ? (1U << 1) : 0;
> > @@ -160,8 +161,10 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
> >  
> >  	GUEST_ASSERT(bits_per_field <= reg_bits);
> >  	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
> > -	/* Some registers like IROUTER are 64 bit long. Those are currently not
> > -	 * supported by readl nor writel, so just asserting here until then.
> > +	/*
> > +	 * This function does not support 64 bit accesses as those are
> > +	 * currently not supported by readl nor writel, so just asserting here
> > +	 * until then.
> 
> Well, readl and writel will never support 64 bit accesses. We'd need to
> implement readq and writeq for that. If we're going to rewrite this
> comment please state it that way instead.

Good point, will make it clearer in v2. Thanks!

> 
> >  	 */
> >  	GUEST_ASSERT(reg_bits == 32);
> >  
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > index b3a0fca0d780..79864b941617 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
> >  		attr += SZ_64K;
> >  	}
> >  
> > -	/* All calls will succeed, even with invalid intid's, as long as the
> > +	/*
> > +	 * All calls will succeed, even with invalid intid's, as long as the
> >  	 * addr part of the attr is within 32 bits (checked above). An invalid
> >  	 * intid will just make the read/writes point to above the intended
> >  	 * register space (i.e., ICPENDR after ISPENDR).
> > -- 
> > 2.35.0.rc0.227.g00780c9af4-goog
> >
> 
> Thanks,
> drew
> 
