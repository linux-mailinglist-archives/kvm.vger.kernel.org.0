Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5395397AD1
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 21:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhFATsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 15:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233853AbhFATsf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 15:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622576813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFg6dKRGX05/OpUoApdspKMfiFJcRvSvkAxKURmBAyQ=;
        b=cf7Uzf4d7S26MY++RR180Rx/6wrUj/Ff+U3BFd/I51NIaTOUu4H20AfLYgoRynxGJ0GByS
        MVpFBhz1qGMGwuR7WnrEXrOKPD1AjiS4sWn/hG2skI5ukU7X9xFgOdWN0X1OWk1MLX0whp
        ps7YXTIDIdPhHDVJ2RBbZ63lqaJTue4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-XucEw256NXSj7Stkwy8Tog-1; Tue, 01 Jun 2021 15:46:51 -0400
X-MC-Unique: XucEw256NXSj7Stkwy8Tog-1
Received: by mail-ej1-f72.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so49427ejz.5
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 12:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mFg6dKRGX05/OpUoApdspKMfiFJcRvSvkAxKURmBAyQ=;
        b=YqZZqypm1eHj1eN3UhRQ765jxNXydP5aD5UngIOUTJBVXsceCsky485k/SRHeeA9Cd
         6Ec9nX0To2cl3teEnhIX30rkxUVdGqOO6uTyLUotrAQmoRji2QuX1ttbliAlvc2xKMGl
         I7CM2Rwv2ZbWXme2OkVw0/XVzVer3orIhPMwYfgp9plrNNPk6sVGFECpFGEJWl3bwuDi
         Qdf4rxGhAvfOEd57NSOZst6pM+UJ9CuF2oeiOzaKooccyJrxrwVGsjJEo2co21Me/UET
         JGrVqWMxoI/oftpHN48dWQdUci00mpp9T6CmE4cWAX4B7JFTC+1wPcQbMN1Oncgj7k1o
         3KQw==
X-Gm-Message-State: AOAM530yyUF29nkAU8fu8foey9F7TQcdwjNnXIn6p5hfrTW9OSaASfvx
        mD0E1tu2pFjFZrwNMc6Au8aPT3m7y2XGExn0AcmdrrdJacz7PfGNPuz9bgY4sy10gfzRcpqin7u
        CIhtLJgPeHl6F
X-Received: by 2002:a05:6402:1d0c:: with SMTP id dg12mr11032444edb.155.1622576810785;
        Tue, 01 Jun 2021 12:46:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxbUPimAs6A73voDIIQ7UzbNe86cT5d42Vz4uZzsv/u4iPJgbTgX5R6x1u2RrubCP0A/kXRw==
X-Received: by 2002:a05:6402:1d0c:: with SMTP id dg12mr11032429edb.155.1622576810607;
        Tue, 01 Jun 2021 12:46:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id v1sm7546424ejw.117.2021.06.01.12.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 12:46:50 -0700 (PDT)
Date:   Tue, 1 Jun 2021 21:46:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Message-ID: <20210601194648.fdymtxiz6lkxycsx@gator.home>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
 <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
 <87sg21bk7r.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sg21bk7r.fsf@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 05:49:01PM +0100, Alex Bennée wrote:
> 
> Auger Eric <eric.auger@redhat.com> writes:
> 
> > Hi Alex,
> >
> > On 5/25/21 7:26 PM, Alex Bennée wrote:
> >> When running the test in TCG we are basically running on bare metal so
> >> don't rely on having a particular kernel errata applied.
> >> 
> >> You might wonder why we handle this with a totally new test name
> >> instead of adjusting the append to take an extra parameter? Well the
> >> run_migration shell script uses eval "$@" which unwraps the -append
> >> leading to any second parameter being split and leaving QEMU very
> >> confused and the test hanging. This seemed simpler than re-writing all
> >> the test running logic in something sane ;-)
> >
> > there is
> > lib/s390x/vm.h:bool vm_is_tcg(void)
> >
> > but I don't see any particular ID we could use to differentiate both the
> > KVM and the TCG mode, do you?
> 
> For -cpu max we do:
> 
>         /*
>          * Reset MIDR so the guest doesn't mistake our 'max' CPU type for a real
>          * one and try to apply errata workarounds or use impdef features we
>          * don't provide.
>          * An IMPLEMENTER field of 0 means "reserved for software use";
>          * ARCHITECTURE must be 0xf indicating "v7 or later, check ID registers
>          * to see which features are present";
>          * the VARIANT, PARTNUM and REVISION fields are all implementation
>          * defined and we choose to define PARTNUM just in case guest
>          * code needs to distinguish this QEMU CPU from other software
>          * implementations, though this shouldn't be needed.
>          */
>         t = FIELD_DP64(0, MIDR_EL1, IMPLEMENTER, 0);
>         t = FIELD_DP64(t, MIDR_EL1, ARCHITECTURE, 0xf);
>         t = FIELD_DP64(t, MIDR_EL1, PARTNUM, 'Q');
>         t = FIELD_DP64(t, MIDR_EL1, VARIANT, 0);
>         t = FIELD_DP64(t, MIDR_EL1, REVISION, 0);
>         cpu->midr = t;
> 
> However for the default -cpu cortex-a57 we aim to look just like the
> real thing - only without any annoying micro-architecture bugs ;-)
> 
> >
> > without a more elegant solution,
> 
> I'll look into the suggestion made by Richard.

Where did Richard make a suggestion? And what is it?

Thanks,
drew

> 
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >
> > Thanks
> >
> > Eric
> >
> >
> >> 
> >> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> >> ---
> >>  arm/gic.c         |  8 +++++++-
> >>  arm/unittests.cfg | 10 +++++++++-
> >>  2 files changed, 16 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/arm/gic.c b/arm/gic.c
> >> index bef061a..0fce2a4 100644
> >> --- a/arm/gic.c
> >> +++ b/arm/gic.c
> >> @@ -36,6 +36,7 @@ static struct gic *gic;
> >>  static int acked[NR_CPUS], spurious[NR_CPUS];
> >>  static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
> >>  static cpumask_t ready;
> >> +static bool under_tcg;
> >>  
> >>  static void nr_cpu_check(int nr)
> >>  {
> >> @@ -834,7 +835,7 @@ static void test_migrate_unmapped_collection(void)
> >>  		goto do_migrate;
> >>  	}
> >>  
> >> -	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
> >> +	if (!errata(ERRATA_UNMAPPED_COLLECTIONS) && !under_tcg) {
> >>  		report_skip("Skipping test, as this test hangs without the fix. "
> >>  			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> >>  		test_skipped = true;
> >> @@ -1005,6 +1006,11 @@ int main(int argc, char **argv)
> >>  		report_prefix_push(argv[1]);
> >>  		test_migrate_unmapped_collection();
> >>  		report_prefix_pop();
> >> +	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection-tcg")) {
> >> +		under_tcg = true;
> >> +		report_prefix_push(argv[1]);
> >> +		test_migrate_unmapped_collection();
> >> +		report_prefix_pop();
> >>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
> >>  		report_prefix_push(argv[1]);
> >>  		test_its_introspection();
> >> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> >> index 1a39428..adc1bbf 100644
> >> --- a/arm/unittests.cfg
> >> +++ b/arm/unittests.cfg
> >> @@ -205,7 +205,7 @@ extra_params = -machine gic-version=3 -append 'its-pending-migration'
> >>  groups = its migration
> >>  arch = arm64
> >>  
> >> -[its-migrate-unmapped-collection]
> >> +[its-migrate-unmapped-collection-kvm]
> >>  file = gic.flat
> >>  smp = $MAX_SMP
> >>  accel = kvm
> >> @@ -213,6 +213,14 @@ extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
> >>  groups = its migration
> >>  arch = arm64
> >>  
> >> +[its-migrate-unmapped-collection-tcg]
> >> +file = gic.flat
> >> +smp = $MAX_SMP
> >> +accel = tcg
> >> +extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection-tcg'
> >> +groups = its migration
> >> +arch = arm64
> >> +
> >>  # Test PSCI emulation
> >>  [psci]
> >>  file = psci.flat
> >> 
> 
> 
> -- 
> Alex Bennée
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

