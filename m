Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0297B68DEC1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjBGRRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 12:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjBGRRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 12:17:02 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694EB3EFF8
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 09:16:22 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d2so12030864pjd.5
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 09:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sc8Dzie9A8y8S45kzCPXX5BYzIIhqs78gp47BlQd0i8=;
        b=Ll2X9VD0OteaIRqAqdVdEYSZyu0gSNQwuSfB9Rrn2fwPWRX1u7pghVhAcREsP2+lGk
         HVglbUWsQBazz2zBgjvN/8RW4U+/JA80B6vZHzLSpfnPVAPfDwMIlElMZfzna+NTuxPQ
         FINzOStCndAXqlMJVvndo5XC7u2wsw6HjP3KT1hq9p3C8ghI5p6kxjFDQfEucFV07QF8
         rEu8eW/zunu6ER3FaTFankMS23LaH3w4X+stdpQPcK/x9izguRwY/NkOOOmf+8cx98r/
         Uiu+zSf819YyMm4At/RW4mX2rOFl0nazUkwdz9LpmRqqNirNhtXfWtA6HBdqWlUG28Of
         3sPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sc8Dzie9A8y8S45kzCPXX5BYzIIhqs78gp47BlQd0i8=;
        b=syOuY+OPnEtKe2P/nPoGoZflh5L7gZJWHGOg5QB/7EtJ+p9iEEr6gDNt2CHpm4/0Ks
         s1ANPUUNmKrWpot7XvWdz0X3iu7+qAbxQH7rU4UsZh+Y2Jp1UAGpf7YjJOyk7ioCpxQ2
         COeIR+tvYJUQ6jbZzt0ned0RectBwdy/aRwnSFYKoQufs/fGP7huWBBXMjhAouYY/bIb
         RCgCYhHSbtn3xjLLwELjjYHxTaUDxou9TeIKvqqsYyMmOrN65jRucG6Wj7oMpsc9Q61s
         V+WGe4W4p3XDOFEZMER1b/363jzmJTxKXSgnO3BkeB1mKBdVsCrCoOSXh0GeGk/6wEl/
         ID/w==
X-Gm-Message-State: AO0yUKWE/+iB35Hu6qZlgpCyPW9cjBtrMzZLfWGu+T2DewYwrevsmjaQ
        0FLPv5fZGRejY2Ahuxs009ASpg==
X-Google-Smtp-Source: AK7set+VDV5Y413ktncXB7sF4EsTzFuW3K3pRZJn4EaA5h/D6ZlGr+w9UI/RIwZTZ5Z+S0MJKONyMQ==
X-Received: by 2002:a17:902:9895:b0:198:af50:e4eb with SMTP id s21-20020a170902989500b00198af50e4ebmr223213plp.17.1675790171184;
        Tue, 07 Feb 2023 09:16:11 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 200-20020a6214d1000000b0058de0998f17sm9431054pfu.154.2023.02.07.09.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 09:16:10 -0800 (PST)
Date:   Tue, 7 Feb 2023 17:16:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Message-ID: <Y+KHVdYG3tyBGfuk@google.com>
References: <20230131085031.88939-1-likexu@tencent.com>
 <Y9k7eyfmXjqW9lYF@google.com>
 <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
 <Y9v7tEXPlki7YOT4@google.com>
 <7dc66398-aa0c-991f-3fa9-43aac8c710fd@gmail.com>
 <Y91DUmMjCLzIXlp+@google.com>
 <f0f6dbed-0e1d-059c-11a4-07fd4bec5c99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0f6dbed-0e1d-059c-11a4-07fd4bec5c99@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023, Like Xu wrote:
> On 4/2/2023 1:28 am, Sean Christopherson wrote:
> > On Fri, Feb 03, 2023, Like Xu wrote:
> > > On 3/2/2023 2:06 am, Sean Christopherson wrote:
> > > > On Thu, Feb 02, 2023, Like Xu wrote:
> > > > > On 1/2/2023 12:02 am, Sean Christopherson wrote:
> > > > > The perf interface only provides host PMU capabilities and the logic for
> > > > > choosing to disable (or enable) vPMU based on perf input should be left
> > > > > in the KVM part so that subsequent development work can add most code
> > > > > to the just KVM, which is very helpful for downstream users to upgrade
> > > > > loadable KVM module rather than the entire core kernel.
> > > > > 
> > > > > My experience interacting with the perf subsystem has taught me that
> > > > > perf change required from KVM should be made as small as possible.
> > > > 
> > > > I don't disagree, but I don't think that's relevant in this case.  Perf doesn't
> > > > provide the necessary bits for KVM to virtualize a hybrid PMU, so unless KVM is
> > > > somehow able to get away with enumerating a very stripped down vPMU, additional
> > > > modifications to perf_get_x86_pmu_capability() will be required.
> > > > 
> > > > What I care more about though is this ugliness in perf_get_x86_pmu_capability():
> > > > 
> > > > 	/*
> > > > 	 * KVM doesn't support the hybrid PMU yet.
> > > > 	 * Return the common value in global x86_pmu,
> > > > 	 * which available for all cores.
> > > 
> > > I would have expected w/ current code base, vpmu (excluding pebs and lbr, intel_pt)
> > > to continue to work on any type of pCPU until you decide to disable them completely.
> > 
> > Didn't follow this.
> 
> My expectation is that, if a guest doesn't enable "PEBS, LBR and intel_pt",
> and only has the most basic pmu conters (its number is the lesser number
> of big and small cores supported), with some pmu_event_fileter allow list
> mechanism, vPMU works regardless of the vcpu model and does not
> require cpu pined. Any complaints from users on this usages ?

No?  But I highly doubt the average user is even aware of KVM_SET_PMU_EVENT_FILTER,
let alone knows how to use it.  E.g. AFAICT QEMU doesn't support the ioctl().
And for people that do use event filters, I doubt they're running on hybrid CPUs.

> > > > I really don't want to leave that comment lying around as it's flat out wrong in
> > > > that it obviously doesn't address the other differences beyond the number of
> > > > counters.  And since there are dependencies on perf, my preference is to disable
> > > > PMU enumeration in perf specifically so that whoever takes on vPMU enabling is
> > > > forced to consider the perf side of things, and get buy in from the perf folks.
> > > 
> > > The perf_get_x86_pmu_capability() obviously needs to be revamped,
> > > but until real effective KVM enabling work arrives, any inconsequential intrusion
> > > into perf/core code will only lead to trivial system maintenance.
> > 
> > Trivial doesn't mean useless or unnecessary though.  IMO, there's value in capturing,
> > in code, that perf_get_x86_pmu_capability() doesn't properly support hybrid vPMUs.
> > 
> > That said, poking around perf, checking is_hybrid() is wrong.  This quirk suggests
> > that if E-cores are disabled via BIOS, (a) X86_FEATURE_HYBRID_CPU is _supposed_ to
> > be cleared, and (b) the base PMU will reflect the P-core PMU.  I.e. someone can
> > enable vPMU by disabling E-cores.
> > 
> >                  /*
> >                   * Quirk: For some Alder Lake machine, when all E-cores are disabled in
> >                   * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
> >                   * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
> 
> Sigh. Then what if E-cores are manually offline via "/.../cpu$/online" and
> then init kvm module ?

KVM has to be paranoid and assume those CPUs could be onlined in the future.

> I suggest leaving these open issues to that enabling guy (or maybe it's still me).
> 
> >                   * mistakenly add extra counters for P-cores. Correct the number of
> >                   * counters here.
> >                   */
> >                  if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
> >                          pmu->num_counters = x86_pmu.num_counters;
> >                          pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
> >                  }
> > 
> > Side topic, someone (*cough* Intel) should fix that, e.g. detect the scenario
> > during boot and manually clear X86_FEATURE_HYBRID_CPU.
> 
> Maybe they did it on purpose.

That seems unlikely.  My interpretation of the comment, specifically the "Quirk" and
"some ... machine" parts, is that the intended behavior is to clear the HYBRID bit,
but _some_ platforms fail to do so.

I don't think Intel's intent matters though.  If the kernel benefits from clearing
HYBRID and there are no downsides, then it should be cleared regardless of what
Intel intended ucode to do.
