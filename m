Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B296391117
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhEZG7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232678AbhEZG7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 02:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622012250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gZt/78b9E0Mn5efYKHSVxpMzVKaf5ArhTjnMdIGx+ys=;
        b=g9zFXttWcVq9Zrcj4hwG6ixrGtfKZP/K9hz/D8i5QZjpuhd9vBdaYJWSCe/d8eflREMTXy
        S6DoU/xOTGc+CbwVfTePUf64e2nzT4X/mU9nGAmHMbPiX7MLILnXr/pXCz/kJ8i1pSM4xu
        5qwZcea6Z6Ys+dnjVUHnrJlddw0XN7w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-03rIkFwTMAqukjYNHyZ8Rw-1; Wed, 26 May 2021 02:57:28 -0400
X-MC-Unique: 03rIkFwTMAqukjYNHyZ8Rw-1
Received: by mail-ed1-f69.google.com with SMTP id x3-20020a50ba830000b029038caed0dd2eso8242ede.7
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gZt/78b9E0Mn5efYKHSVxpMzVKaf5ArhTjnMdIGx+ys=;
        b=mxH0q2dYhRbM9no1M4xhoo5ujYvMn1J/7wsHMmmijfZ8iKTahi8lE9OhbVEwkrM92G
         6Y6dmBDb+nuz5unowlmcg/bDXnQ8LJVjFMMtgoLmzpjVmkwZ2pcfYh4zR/1LdEGdEIfP
         lvFyHKQwGESDwIwgmTtFTH12966tEr3avPBtDvUT8MUKlyAzFPlFpc6Ucv4EshOve5UX
         Oryz3yHK+5th50i9otqc1nfKXGusweIr7zzuuv/PeKi65ScaIo96uGMKRP3UfrZOIvYu
         bNRo0lkzumTJwQnsScC0TVlZxCjHaGzhhy4zF1LKJcy6ClMpo7bP5Mu+nonPm+Rryxkd
         XTfw==
X-Gm-Message-State: AOAM530uLFSZVOTq3KakDolo1T8deSGFtU70X5rao75MCviwUz072+Gb
        8Gs3GmPdoTnDP+50vul3bx2n0WRY8mHw5zK0Zs5Eq1siwwD0Vhrx1FCEIjo635AD/4c9gwGGaTW
        GjtNDyy97QRpn
X-Received: by 2002:a17:906:2ec6:: with SMTP id s6mr32026721eji.65.1622012246810;
        Tue, 25 May 2021 23:57:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhPq8SdNrjADFqrVzJgDpb3cS5SqR/RGkCmodlewr7RVLMZ4m5CY/r4/YTrlyRDt5VoC3TvQ==
X-Received: by 2002:a17:906:2ec6:: with SMTP id s6mr32026703eji.65.1622012246542;
        Tue, 25 May 2021 23:57:26 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id y27sm9898401ejf.104.2021.05.25.23.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 23:57:25 -0700 (PDT)
Date:   Wed, 26 May 2021 08:57:24 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <20210526065724.3qb3fz5idwlskhpx@gator.home>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
 <YK1ZcqgyLFSDH14+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK1ZcqgyLFSDH14+@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021 at 01:09:22PM -0700, Ricardo Koller wrote:
> On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
> > Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> > userspace when not available") the get-reg-list* tests have been
> > failing with
> > 
> >   ...
> >   ... There are 74 missing registers.
> >   The following lines are missing registers:
> >   ...
> > 
> > where the 74 missing registers are all PMU registers. This isn't a
> > bug in KVM that the selftest found, even though it's true that a
> > KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> > flag, but still expecting the PMU registers to be in the reg-list,
> > would suddenly no longer have their expectations met. In that case,
> > the expectations were wrong, though, so that KVM userspace needs to
> > be fixed, and so does this selftest. The fix for this selftest is to
> > pull the PMU registers out of the base register sublist into their
> > own sublist and then create new, pmu-enabled vcpu configs which can
> > be tested.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
> >  1 file changed, 38 insertions(+), 8 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > index dc06a28bfb74..78d8949bddbd 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -47,6 +47,7 @@ struct reg_sublist {
> >  struct vcpu_config {
> >  	const char *name;
> >  	bool sve;
> > +	bool pmu;
> >  	struct reg_sublist sublists[];
> >  };
> 
> I think it's possible that the number of sublists keeps increasing: it
> would be very nice/useful if KVM allowed enabling/disabling more
> features from userspace (besides SVE, PMU etc). In that case, it might
> be easier if adding a new feature to get-reg-list just requires defining
> a new config and not dealing with the internals of vcpu_config.

Yes, adding the bools is a bit ugly, but how will we easily check if a
given feature is present in a given config? We could put a copy of the
vcpu_init features bitmap in vcpu_config, but I'm not sure if not touching
the vcpu_config structure is worth having to use test_bit() and friends
everywhere.

> 
> Do you think it's possible in general to associate a sublist to a
> capability and a feature? It works for the PMU and SVE. If that is
> possible, what do you think of something like this? this would be the
> config for sve+pmu:
> 
> static struct vcpu_config sve_pmu_config = {
>       "sve+pmu",
>        .sublists = {
>        { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
>        { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
>        { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
>        {0},
>        },
> };
> 
> Appended a rough patch at the end to make this idea more concrete.

Comments below

> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 78d8949bddbd..33b8735bdb15 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -38,6 +38,11 @@ static struct kvm_reg_list *reg_list;
>  static __u64 *blessed_reg, blessed_n;
>  
>  struct reg_sublist {
> +       const char *name;
> +       bool base;
> +       int feature;
> +       int capability;
> +       bool finalize;
>         __u64 *regs;
>         __u64 regs_n;
>         __u64 *rejects_set;
> @@ -46,8 +51,6 @@ struct reg_sublist {
>  
>  struct vcpu_config {
>         const char *name;
> -       bool sve;
> -       bool pmu;
>         struct reg_sublist sublists[];
>  };
>  
> @@ -257,10 +260,7 @@ static void print_reg(struct vcpu_config *c, __u64 id)
>                 printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
>                 break;
>         case KVM_REG_ARM64_SVE:
> -               if (c->sve)
> -                       printf("\t%s,\n", sve_id_to_str(c, id));
> -               else
> -                       TEST_FAIL("%s: KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", c->name, id);
> +               printf("\t%s,\n", sve_id_to_str(c, id));

I'd rather not lose this test. What we were doing here is making sure we
don't see registers with KVM_REG_ARM64_SVE when sve is not enabled.

>                 break;
>         default:
>                 TEST_FAIL("%s: Unexpected coproc type: 0x%llx in reg id: 0x%llx",
> @@ -327,31 +327,42 @@ static void core_reg_fixup(void)
>  
>  static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
>  {
> -       if (c->sve)
> -               init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
> -       if (c->pmu)
> -               init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> +       struct reg_sublist *s;
> +
> +       for_each_sublist(c, s) {
> +               if (s->base)
> +                       continue;
> +               init->features[0] |= 1 << s->feature;
> +       }

If we want this to be general then we should ensure s->feature is < 32,
otherwise we need to move to the next word. Granted we only have a few
features so far for all the years we've had Arm KVM, so we probably don't
need to worry about this any time soon...

>  }
>  
>  static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid, struct vcpu_config *c)
>  {
> +       struct reg_sublist *s;
>         int feature;
>  
> -       if (c->sve) {
> -               feature = KVM_ARM_VCPU_SVE;
> -               vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
> +       for_each_sublist(c, s) {
> +               if (s->base)
> +                       continue;

Probably don't need the if (s->base) continue, since base registers won't
have s->finalize.

> +               if (s->finalize) {
> +                       feature = s->feature;
> +                       vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
> +               }
>         }
>  }
>  
>  static void check_supported(struct vcpu_config *c)
>  {
> -       if (c->sve && !kvm_check_cap(KVM_CAP_ARM_SVE)) {
> -               fprintf(stderr, "%s: SVE not available, skipping tests\n", c->name);
> -               exit(KSFT_SKIP);
> -       }
> -       if (c->pmu && !kvm_check_cap(KVM_CAP_ARM_PMU_V3)) {
> -               fprintf(stderr, "%s: PMU not available, skipping tests\n", c->name);
> -               exit(KSFT_SKIP);
> +       struct reg_sublist *s;
> +
> +       for_each_sublist(c, s) {
> +               if (s->base)
> +                       continue;

Also don't need the if (s->base) continue, since base registers won't have
capabilities.

> +               if (!kvm_check_cap(s->capability)) {
> +                       fprintf(stderr, "%s: %s not available, skipping tests\n", c->name, s->name);
> +                       exit(KSFT_SKIP);
> +
> +               }
>         }
>  }
>  
> @@ -975,34 +986,34 @@ static __u64 sve_rejects_set[] = {
>  static struct vcpu_config vregs_config = {
>         "vregs",
>         .sublists = {
> -       { base_regs,    ARRAY_SIZE(base_regs), },
> -       { vregs,        ARRAY_SIZE(vregs), },
> +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> +       { "vregs", true, 0, 0, false, vregs, ARRAY_SIZE(vregs), },
>         {0},
>         },
>  };
>  static struct vcpu_config vregs_pmu_config = {
> -       "vregs+pmu", .pmu = true,
> +       "vregs+pmu",
>         .sublists = {
> -       { base_regs,    ARRAY_SIZE(base_regs), },
> -       { vregs,        ARRAY_SIZE(vregs), },
> -       { pmu_regs,     ARRAY_SIZE(pmu_regs), },
> +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> +       { "vregs", true, 0, 0, false, vregs, ARRAY_SIZE(vregs), },
> +       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
>         {0},
>         },
>  };
>  static struct vcpu_config sve_config = {
> -       "sve", .sve = true,
> +       "sve",
>         .sublists = {
> -       { base_regs,    ARRAY_SIZE(base_regs), },
> -       { sve_regs,     ARRAY_SIZE(sve_regs),   sve_rejects_set,        ARRAY_SIZE(sve_rejects_set), },
> +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> +       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
>         {0},
>         },
>  };
>  static struct vcpu_config sve_pmu_config = {
> -       "sve+pmu", .sve = true, .pmu = true,
> +       "sve+pmu",
>         .sublists = {
> -       { base_regs,    ARRAY_SIZE(base_regs), },
> -       { sve_regs,     ARRAY_SIZE(sve_regs),   sve_rejects_set,        ARRAY_SIZE(sve_rejects_set), },
> -       { pmu_regs,     ARRAY_SIZE(pmu_regs), },
> +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> +       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
> +       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
>         {0},
>         },
>  };
> 

It looks pretty good to me. While I don't really care about needing to add
booleans to vcpu_config, the biggest advantage I see is not needing to
modify prepare_vcpu_init, finalize_vcpu, and check_supported, and that the
feature bits and caps are better associated with the sublists.

These tables are getting wordy, though, so we'll probably want some
macros.

I'll experiment with this to see if I can integrate some of your
suggestions into a v3.

Thanks,
drew

