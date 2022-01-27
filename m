Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE48A49E56E
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 16:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbiA0PGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 10:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237372AbiA0PGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 10:06:45 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322F5C061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:06:45 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j2so4045164edj.8
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cA1lg3Dd5LbRAQ5aawd3cz5k8zHSySm2HgwQKBcf6DY=;
        b=UJMBk5sOyDdO52DubA7r6BLKw1F+menFstYh1fMWNG94Fmv2bq0s+zts9U2mBlBJVg
         jVUdZ7e37YUBOZRVYxPbMmjufyUSDt12n4ge1Um4rg1Wxq/xynvEhapidPTdaQwyS+q3
         l0Do78hON1dznFIEbjwXbriIT8h7l9/5/XcJSj/rzuLP5XpVHQAUg/4/jwx6vOl3meh1
         UIqT/QaJb7LH5MlQ0AIyMM4/z5PLsoW+C1pveqHQZcz277oy37rexPpMf6UlQxpQjt5o
         wzA2ekVhJ1dbKEPQMML4hdWQPHhHyGgWUDLzN16AU9XqzTtMuU3vv96vwuwGLAEq6/Vq
         AAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cA1lg3Dd5LbRAQ5aawd3cz5k8zHSySm2HgwQKBcf6DY=;
        b=Ho8/xwn1vaCeo5RE2dUBDYdTCjNobeHU9NVgfWZa3WZ1CAyqm8Hag2o0YI3doLJoMM
         PbeswYIjLJn1YIf5NoLS8LPKuMVt1wfhTxBCq2H3Kqwe8HCws7qYv9s4L2DGVzGlnHEu
         PhyEti9KlPULUJigbhhh4uUdM96g6WvYd/RuKySgN7kK6e74l5fvH5LrigWKvlnq5+kj
         5I4J0ve7eKyxYVpuIijxbpL7lswvfu+khXqQkOnJ67rNs6yHpJfTbRI237NXs+ef7pXt
         ySvgnCH5p27fEualVcHA0FavcpdVlycjI3EjcNKWDsGM5BqWBDOUE9vNYIesxcr/iFK8
         e/KA==
X-Gm-Message-State: AOAM533uX8YerkiBbbujcKEu9ypALv2hy2IY3CdsxC6vSJKz3YBgxS2L
        9bokCCfFI9sPXE4GzdhU+ZpDcapin2kKjO1wESQf2A==
X-Google-Smtp-Source: ABdhPJwdqC53pKKOmb7Ul4w+8PEMJOe9FlNNbGVfhT2KbeWAUotCmLEV7n9OSxuEqzobzhyspNKa4miN74rjlwQuxjY=
X-Received: by 2002:a50:bb0b:: with SMTP id y11mr4024325ede.71.1643296003331;
 Thu, 27 Jan 2022 07:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com> <20220127030858.3269036-5-ricarkol@google.com>
 <20220127074922.6m53vckomn7lacog@gator>
In-Reply-To: <20220127074922.6m53vckomn7lacog@gator>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 27 Jan 2022 07:06:31 -0800
Message-ID: <CAOHnOrwjNzvrZV9qPWNnE2P5W_5DfTRXNuuJu+DjEvj2SNPi+g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] kvm: selftests: aarch64: fix some vgic related comments
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 11:49 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Jan 26, 2022 at 07:08:57PM -0800, Ricardo Koller wrote:
> > Fix the formatting of some comments and the wording of one of them (in
> > gicv3_access_reg).
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reported-by: Reiji Watanabe <reijiw@google.com>
> > Cc: Andrew Jones <drjones@redhat.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> I didn't give my r-b to this patch before, but you can keep it, because
> here's another one
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks Andrew. Sorry, it was supposed to go to the assert one.

> > ---
> >  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
> >  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
> >  tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
> >  3 files changed, 16 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > index 0106fc464afe..f0230711fbe9 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > @@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
> >       uint32_t prio, intid, ap1r;
> >       int i;
> >
> > -     /* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> > +     /*
> > +      * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> >        * in descending order, so intid+1 can preempt intid.
> >        */
> >       for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
> > @@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
> >               gic_set_priority(intid, prio);
> >       }
> >
> > -     /* In a real migration, KVM would restore all GIC state before running
> > +     /*
> > +      * In a real migration, KVM would restore all GIC state before running
> >        * guest code.
> >        */
> >       for (i = 0; i < num; i++) {
> > @@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
> >               test_injection_failure(args, f);
> >       }
> >
> > -     /* Restore the active state of IRQs. This would happen when live
> > +     /*
> > +      * Restore the active state of IRQs. This would happen when live
> >        * migrating IRQs in the middle of being handled.
> >        */
> >       for_each_supported_activate_fn(args, set_active_fns, f)
> > @@ -840,7 +843,8 @@ int main(int argc, char **argv)
> >               }
> >       }
> >
> > -     /* If the user just specified nr_irqs and/or gic_version, then run all
> > +     /*
> > +      * If the user just specified nr_irqs and/or gic_version, then run all
> >        * combinations.
> >        */
> >       if (default_args) {
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > index e4945fe66620..263bf3ed8fd5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > @@ -19,7 +19,7 @@ struct gicv3_data {
> >       unsigned int nr_spis;
> >  };
> >
> > -#define sgi_base_from_redist(redist_base)    (redist_base + SZ_64K)
> > +#define sgi_base_from_redist(redist_base)    (redist_base + SZ_64K)
> >  #define DIST_BIT                             (1U << 31)
> >
> >  enum gicv3_intid_range {
> > @@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
> >  {
> >       uint32_t val;
> >
> > -     /* All other fields are read-only, so no need to read CTLR first. In
> > +     /*
> > +      * All other fields are read-only, so no need to read CTLR first. In
> >        * fact, the kernel does the same.
> >        */
> >       val = split ? (1U << 1) : 0;
> > @@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
> >
> >       GUEST_ASSERT(bits_per_field <= reg_bits);
> >       GUEST_ASSERT(!write || *val < (1U << bits_per_field));
> > -     /* Some registers like IROUTER are 64 bit long. Those are currently not
> > -      * supported by readl nor writel, so just asserting here until then.
> > +     /*
> > +      * This function does not support 64 bit accesses. Just asserting here
> > +      * until we implement readq/writeq.
> >        */
> >       GUEST_ASSERT(reg_bits == 32);
> >
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > index b3a0fca0d780..79864b941617 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
> >               attr += SZ_64K;
> >       }
> >
> > -     /* All calls will succeed, even with invalid intid's, as long as the
> > +     /*
> > +      * All calls will succeed, even with invalid intid's, as long as the
> >        * addr part of the attr is within 32 bits (checked above). An invalid
> >        * intid will just make the read/writes point to above the intended
> >        * register space (i.e., ICPENDR after ISPENDR).
> > --
> > 2.35.0.rc0.227.g00780c9af4-goog
> >
>
