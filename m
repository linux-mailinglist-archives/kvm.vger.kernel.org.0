Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F7F7ABBF2
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 00:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjIVWos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 18:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjIVWoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 18:44:46 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC8D1A6
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 15:44:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c43cd8b6cbso27041605ad.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 15:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695422680; x=1696027480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XYbmeLhvjO0E562QDesBCa77gZtCW37F3RApV88htL4=;
        b=ddpo8XIiIDJx2V8rDkXl/ZAQ8HtNPR7tHW9wp3rNBZ98l8VUNNhq9hLf4nLyjX8Tn2
         8dZTAepgVK+HPPH+V/2lbmdJ79uVmFogVdpxG86laGLWYp9Zx517lKlKtn9FyjOvr4Sk
         yW+BOlBmPcA0VZON+CjaC+kf2qpethVZxEPAis3SQ+BYtrXFVTsZW+fFDL3e7+2R+hxG
         861RRPsieORPytnHCgCVAUp37aCdXWvyO1SVnCG09QT+L20ai+k7Kp7MJ323ElOmwyan
         fyaOIwHvB5uhEskGJt93If40C5ubL7CGOOr1fqVufKmO2ohIdu138gAQ7hKKjPO2kPdN
         aq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695422680; x=1696027480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XYbmeLhvjO0E562QDesBCa77gZtCW37F3RApV88htL4=;
        b=qr0l4saX7h1HOPjpzKyd71srTNBFJYkS0D/umMzPnoGOd8ZiMaQff76FT57jZ8QWmW
         7Ae3oos3pp2lxMpI82J4nGM8g9bDEmPiy8KYQUnSj7eURDTJUV3i5uy5M5UtDtysHfpi
         rvyyrV1IDz1X6WjckxCfDNrr2+KvR9ImMofDQadxYiALP+Zeq9ZKXLa6xYLsh1Itxezb
         ht+V1WVfbrag791rDNzvWunU60f8JNl3PQPp79/YeGI74yosG0nNhs8Nv7/6DXzDN1Pq
         lr/Nwk7qvgvYRzyAm1/nK5yYFxiY9H4IMtVsJ0Xly5p5hZJ/7fj6OfJzsvMPUb3oqy03
         lryQ==
X-Gm-Message-State: AOJu0YzwEit90pcSotbO1ZhcFhOALm2YMo2omNIK2Ttqlx64IsNj+CpK
        bYsHEBvbr0yF4DT7lza682/YE8HxpIM=
X-Google-Smtp-Source: AGHT+IEg3hi56dVcZv7snZdQYFvKZU1d5RdKevfc97ZMHOOXPop2V0S6Kldc7lnC8b/HKvrT/b7UVQ1TdK8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc8:b0:1bc:5182:1de2 with SMTP id
 a8-20020a170902ecc800b001bc51821de2mr9549plh.1.1695422680052; Fri, 22 Sep
 2023 15:44:40 -0700 (PDT)
Date:   Fri, 22 Sep 2023 15:44:38 -0700
In-Reply-To: <ZQ4A4KaSyygKHDUI@google.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4A4KaSyygKHDUI@google.com>
Message-ID: <ZQ4Y1u40/Qml6IaE@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> My initial testing on both QEMU and our GCP testing environment shows no
> "Uhhuh..." dmesg in guest.
> 
> Please take a look...

And now I'm extra confused, I thought the plan was for me to post a proper series
for the emulated_counter idea[*], get the code base healthy/functional, and then
build on top, e.g. improve performance and whatnot.

The below is just a stripped down version of that, and doesn't look quite right.
Specifically, pmc_write_counter() needs to purge emulated_count (my pseudo-patch
subtly handled that by pausing the counter).

I totally realize I'm moving sloooow, but I pinky swear I'm getting there.  My
compile-tested-only branch can be found at

  https://github.com/sean-jc/linux x86/pmu_refactor

There's a lot more in there, e.g. it has fixes from Roman and Jim, along with
some other found-by-inspection cleanups.

I dropped the "pause on WRMSR" proposal.  I still don't love the offset approach,
but I agree that pausing and reprogramming counters on writes could introduce an
entirely new set of problems.

I'm logging off for the weekend, but I'll pick this back up next (it's at the
top of my priority list, assuming guest_memfd doesn't somehow catch fire.

[*] https://lore.kernel.org/all/ZJ9IaskpbIK9q4rt@google.com

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..47acf3a2b077 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -240,12 +240,13 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
>  {
>  	u64 counter = pmc->counter;
> 
> -	if (!pmc->perf_event || pmc->is_paused)
> -		return;
> -
>  	/* update counter, reset event value to avoid redundant accumulation */
> -	counter += perf_event_pause(pmc->perf_event, true);
> -	pmc->counter = counter & pmc_bitmask(pmc);
> +	if (pmc->perf_event && !pmc->is_paused)
> +		counter += perf_event_pause(pmc->perf_event, true);
> +
> +	pmc->prev_counter = counter & pmc_bitmask(pmc);

Honest question, is it actually correct/necessary to mask the counter at the
intermediate steps?  Conceptually, the hardware count and the emulated count are
the same thing, just tracked separately.

> +	pmc->counter = (counter + pmc->emulated_counter) & pmc_bitmask(pmc);
> +	pmc->emulated_counter = 0;
>  	pmc->is_paused = true;
>  }
> 
> @@ -452,6 +453,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>  reprogram_complete:
>  	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
>  	pmc->prev_counter = 0;

I don't see any reason to keep kvm_pmc.prev_counter.  reprogram_counter() is the
only caller of pmc_pause_counter(), and so is effectively the only writer and the
only reader.  I.e. prev_counter can just be a local variable in reprogram_counter(),
no?
