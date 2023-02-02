Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88347688611
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjBBSHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjBBSGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:06:55 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288E6DB24
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:06:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id r8so2698508pls.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wnwgjrHepV+H3nCkJcaUs0IGb7Rlz+pPTaZ+oHX/Xh4=;
        b=dCZLFetoHYEdLjXuduYmjGgC+4Qh1sS48dw6tEJC9xHF2s5tu+pwO3IPRYDMem9EBL
         quSh3YnNAzpu0ODOMss1V7ge6VLGCl1r8zHkijeD0LMfvOg7Ev6CjMeUtjJyuhXIm21B
         VVF0IhNRdolCFyP84SHwWLD63pDs60NwwhqdfTGhInuTRX7SoHPWoM2yb9gqvUmFwUIP
         Hw99UcB6YxVYXDc0/DwAObc8mWZXKfc6OVyYLKc0OOczKtGrKRqm7e5FBfIIvJxAlNx+
         QijuGiuItpKgmquxmJI6jf8aep3zfnA4x8BzUMQFPyS5hVw+lWIpbo8ay3l49bWbfl+9
         HW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnwgjrHepV+H3nCkJcaUs0IGb7Rlz+pPTaZ+oHX/Xh4=;
        b=yOSV3Og0x7F6iZKDySL7kYyZJdk+FfYjllawrp7qpC633IUUvIdmn0vAbzw7gH1+rp
         S9LAdmCt/ROF399ufxvjkk9FXugHYk9qfauvqFGqadjc5v3leCXr+52kpcp/CPIcT3QH
         KCtjKHdcEx+FyJmTpd0skyCOU8fudTfMf7z/rePK0AIC+vSjSl/O0ne4Y2hVKWyR2Vvx
         5aFEUAiLYP19ZWmroK3EM4zq9/908zQGRRIGDcqW6MHZI35eVcmcURhUNwaNvYYaKyQg
         HkYA9MHODAe/TTRvr6598gfFNaXNJmDm9INOiR3Ge7LLRHb3Yib0PomwnXJkNi0sYSXT
         XozQ==
X-Gm-Message-State: AO0yUKUj7B7M8Gh3qkGjk//wxpRqzcthiMlrMZLnzY1rps6pa6gHLT6a
        8FPkQd11y9zQ19fttbwwCSkT7A==
X-Google-Smtp-Source: AK7set+5qH3JUjrkoBgHPl06pDMVhp8SO/e8uUOIcO+DUveaJLsEbcyP3GWObhd5xYnUTFYrZU6rxA==
X-Received: by 2002:a17:902:c3c4:b0:198:af50:e4df with SMTP id j4-20020a170902c3c400b00198af50e4dfmr54828plj.5.1675361208333;
        Thu, 02 Feb 2023 10:06:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7870f000000b0058119caa82csm13759528pfo.205.2023.02.02.10.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 10:06:47 -0800 (PST)
Date:   Thu, 2 Feb 2023 18:06:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Message-ID: <Y9v7tEXPlki7YOT4@google.com>
References: <20230131085031.88939-1-likexu@tencent.com>
 <Y9k7eyfmXjqW9lYF@google.com>
 <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02, 2023, Like Xu wrote:
> On 1/2/2023 12:02 am, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > > index 79988dafb15b..6a3995657e1e 100644
> > > --- a/arch/x86/kvm/pmu.h
> > > +++ b/arch/x86/kvm/pmu.h
> > > @@ -166,9 +166,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
> > >   	 /*
> > >   	  * For Intel, only support guest architectural pmu
> > > -	  * on a host with architectural pmu.
> > > +	  * on a non-hybrid host with architectural pmu.
> > >   	  */
> > > -	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
> > > +	if (!kvm_pmu_cap.num_counters_gp ||
> > > +	    (is_intel && (!kvm_pmu_cap.version ||
> > > +			  boot_cpu_has(X86_FEATURE_HYBRID_CPU))))
> > 
> > Why do this here instead of in perf_get_x86_pmu_capability()[*]?  The issue isn't
> > restricted to Intel CPUs, it just so happens that Intel is the only x86 vendor
> > that has shipped hybrid CPUs/PMUs.  Similarly, it's entirely possible to create a
> > hybrid CPU with a fully homogeneous PMU.  IMO KVM should rely on the PMU's is_hybrid()
> > and not the generic X86_FEATURE_HYBRID_CPU flag.
> > 
> > [*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com
> 
> As of today, other x86 vendors do not have hybrid core products in their
> road maps. Before implementing the virtual hybrid vCPU model, there is
> no practical value in talking about homogeneous PMU on hybrid vCPU
> at the present stage.

Why not?  I assume Intel put a fair bit of effort into ensuring feature parity
between P and E cores.  Other than time, money, and effort, I don't see any
reason why Intel can't do the same for the PMU.

> The perf interface only provides host PMU capabilities and the logic for
> choosing to disable (or enable) vPMU based on perf input should be left
> in the KVM part so that subsequent development work can add most code
> to the just KVM, which is very helpful for downstream users to upgrade
> loadable KVM module rather than the entire core kernel.
> 
> My experience interacting with the perf subsystem has taught me that
> perf change required from KVM should be made as small as possible.

I don't disagree, but I don't think that's relevant in this case.  Perf doesn't
provide the necessary bits for KVM to virtualize a hybrid PMU, so unless KVM is
somehow able to get away with enumerating a very stripped down vPMU, additional
modifications to perf_get_x86_pmu_capability() will be required.

What I care more about though is this ugliness in perf_get_x86_pmu_capability():

	/*
	 * KVM doesn't support the hybrid PMU yet.
	 * Return the common value in global x86_pmu,
	 * which available for all cores.
	 */
	cap->num_counters_gp	= x86_pmu.num_counters;

I really don't want to leave that comment lying around as it's flat out wrong in
that it obviously doesn't address the other differences beyond the number of
counters.  And since there are dependencies on perf, my preference is to disable
PMU enumeration in perf specifically so that whoever takes on vPMU enabling is
forced to consider the perf side of things, and get buy in from the perf folks.
