Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA54DE2D4
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 21:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiCRUvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 16:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240832AbiCRUvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 16:51:15 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE62107ABC
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:49:56 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s8so10424434pfk.12
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gVt42dxY4XsYu/jUnlir9efYggk8x5Y2GQzM+hfTO0k=;
        b=k10ba2fpj/c86GaX7N8Q7y3gQyhyTL6ewYQwX/YP0t/9Z34PrZE96qXzdfGpcdthiS
         NQxg0LecShV2c/uY8P+90xyytrg0TR2/TQ9HIzdeh8YpCfloNqmklSYkSAo44Q3SoLdz
         rKmjJXB+xFFFoNhi2pDmbsjEmwycBgLlLbwBvnA07SgFdWllwzgBJWkQiHooqMR3BMom
         IvJDtLiRaEqpqz/urNIYKmswtAss8hDSHO2LWabY94/H2k+kaZaafcv/rOLiBj9rvU6/
         ySeUIFJyOeWy+ifjD0szlU1kcz081O/3QmCwVPjofFF8DBgAZ6Ln+8jTKvOZLLVihJ/2
         laog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gVt42dxY4XsYu/jUnlir9efYggk8x5Y2GQzM+hfTO0k=;
        b=s2YjFP0W1/feFKT9tdB+dT/vmvJ7jIydVNM9XT9iiQ967k2evluiZdq3LQUlXORL7V
         fGCwO/P5HCreJkBU+jTjl/XJ0u+uzBzfpI5ZQurlOsGLXW167G/ph3pRg8dz+X6H2v4u
         0RYpSrPcwHI2RbQl9LgiYuqI2Ov05/PZ2ATxOlq007z5ZZddFA6BPfa9+ZKkgw3p3oUJ
         SMJQ9KvjIehU5P6t0w4qd38O+HfklsZMwC+/N6rSVqvoWuI4e07Qzj/WnWvtGXhPvXkX
         GlUmPNbyPC2uQu1IeLrD3utafZJTLN2NBNiXerMyNPsWSo5KDTyqWSKg8l5NyovrlazN
         A83w==
X-Gm-Message-State: AOAM531sEtIBomQvndVzr9pCAfd5yqo3oG+dExVPXQChEqBEdh1bD+9d
        zVhMrBPK2aA+c/+Dw6F4PmxoebQ/EEsfXQ==
X-Google-Smtp-Source: ABdhPJwKkLD/f/nrBS6pOWuLQuqgkqO2xZayA6Y4KD/plr9meROqwO0LF93z8SiHNPs+tMyvI6IvXw==
X-Received: by 2002:a63:121f:0:b0:382:2513:df9e with SMTP id h31-20020a63121f000000b003822513df9emr5338133pgl.269.1647636595399;
        Fri, 18 Mar 2022 13:49:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f10-20020a056a00228a00b004f769b40bd6sm10952592pfe.103.2022.03.18.13.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:49:54 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:49:51 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        pbonzini@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
Message-ID: <YjTwb0+3MPfK62qb@google.com>
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-3-ricarkol@google.com>
 <YjLY5y+KObV0AR9g@google.com>
 <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 08:52:38AM +0000, Marc Zyngier wrote:
> On 2022-03-17 06:44, Oliver Upton wrote:
> > On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
> > > Add an arch_timer edge-cases selftest. For now, just add some basic
> > > sanity checks, and some stress conditions (like waiting for the timers
> > > while re-scheduling the vcpu). The next commit will add the actual
> > > edge
> > > case tests.
> > > 
> > > This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> > > interrupts for suspended vCPU".
> > > 
> > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > > Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> [...]
> 
> > > +		asm volatile("wfi\n"
> > > +			     "msr daifclr, #2\n"
> > > +			     /* handle IRQ */
> > 
> > I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
> > having a hard time finding the same language in the H.a revision of the
> > manual :-/

Got it, adding it. Saw that there is a similar pattern in the kernel and
it has an ISB in the middle.

> 
> D1.3.6 probably is what you are looking for.
> 
> "Context synchronization event" is the key phrase to remember
> when grepping through the ARM ARM. And yes, the new layout is
> a nightmare (as if we really needed an additional 2800 pages...).
> 
> > 
> > > +			     "msr daifset, #2\n"
> > > +			     : : : "memory");
> > > +	}
> > > +}
> 
> [...]
> 
> > > +	/* tval should keep down-counting from 0 to -1. */
> > > +	SET_COUNTER(DEF_CNT, test_args.timer);
> > > +	timer_set_tval(test_args.timer, 0);
> > > +	if (use_sched)
> > > +		USERSPACE_SCHEDULE();
> > > +	/* We just need 1 cycle to pass. */
> > > +	isb();
> > 
> > Somewhat paranoid, but:
> > 
> > If the CPU retires the ISB much more quickly than the counter ticks, its
> > possible that you could observe an invalid TVAL even with a valid
> > implementation.
> 
> Worse than that:
> 
> - ISB doesn't need to take any time at all. It just needs to ensure
>   that everything is synchronised. Depending on how the CPU is built,
>   this can come for free.
> 
> - There is no relation between the counter ticks and CPU cycles.

Good point.

> 
> > What if you spin waiting for CNT to increment before the assertion? Then
> > you for sureknow (and can tell by reading the test) that the
> > implementation is broken.
> 
> That's basically the only way to implement this. You can't rely
> on any other event.

The next commit fixes this (by spinning on the counter). Will move it
here.

> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...

Thank you both for the review.
