Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461186220F9
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 01:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKIAwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 19:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKIAwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 19:52:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C1D3C6E9
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 16:52:11 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id k7so15669223pll.6
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 16:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bfeSvcp44r+HmrabSN2ANNdIIAKiX+FEpsORioHhnhI=;
        b=CKbzWMr/rXxKkH0/SSdD9IQLWVFJ3K3SktHHWu/bsfcmXu6eljp5z2XNnck9l0639X
         NAt9oZ381nC542mFXTQ0sALdyjBaUnbdEuWDYHCdBaxVs37M4/tbfgGxjEgwAj66UW3Y
         B7clo0/coXe96lMacrpUR3CBtu/OHoxPWjETtXErQh6G2205CTBr9OhB3k2qVvisLVvi
         bB0qSni430ZxMxS/BDPtz390irGXGwIx3Uho1ZPriQCGhhPGB8qt7r3jQ0zFHwSJBpJM
         xoD4IhiDLyClJsQVY34uJ8mIrNDW9APzAam4Ef7qS/DnjeiHgkJpUg4tyvm0TufBUSrK
         vXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bfeSvcp44r+HmrabSN2ANNdIIAKiX+FEpsORioHhnhI=;
        b=E1BZIUayMHhUCGQACHZ+H1YkXmJ0daorwECfeUBk3cW5Dav40wz0YG55gWffMr1X/5
         BbaLf0HRmahMENWoPfKcDPMqD+Pj83o8rkXXOodOlm4v+90lwbW5umfxEjb1Gxuupoul
         Ic15o5fG8WyF8WegVIDUnL+v7VFe+vIZMT85r324bD4OtOSfjdo2WG5w1TKLakaW7GMx
         +KYLRieV9T8w74Nhk1w3pXAdkL7qNnWIE5egI5i1r8ndoHRktJWrwT21YH3vxWyodrD1
         kn7raMEXi/2Dg/6+ES+SBAXVgkkyD6B0f9Nm+9SDKYmY8c0EfPxof/YZkEB9jJol2Gsg
         JFVg==
X-Gm-Message-State: ACrzQf1ezt2SmkKFUpstsLIGCUjp7z7j/1YBgP0XaCNiPuYzja1Wheos
        FBcjwNykr9HkIInkpso4Qtp53w==
X-Google-Smtp-Source: AMsMyM5tenBST42alFy+Vnph+h1IABnhezzTrx3PH/0dt2BmdezWSoVOzaoY0fruZlXlQtwGeWR1ow==
X-Received: by 2002:a17:902:ebc4:b0:186:b32c:4ce5 with SMTP id p4-20020a170902ebc400b00186b32c4ce5mr57765433plg.74.1667955131103;
        Tue, 08 Nov 2022 16:52:11 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i2-20020a170902c94200b00186dcc37e17sm7598607pla.210.2022.11.08.16.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:52:10 -0800 (PST)
Date:   Wed, 9 Nov 2022 00:52:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
Subject: Re: [kvm-unit-tests PATCH v5 26/27] x86/pmu: Update testcases to
 cover AMD PMU
Message-ID: <Y2r5txrjTjG7gcZN@google.com>
References: <20221102225110.3023543-1-seanjc@google.com>
 <20221102225110.3023543-27-seanjc@google.com>
 <adcb7098-5bae-7dc3-f48f-5c84fd3f4f7d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adcb7098-5bae-7dc3-f48f-5c84fd3f4f7d@redhat.com>
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

On Tue, Nov 08, 2022, Paolo Bonzini wrote:
> On 11/2/22 23:51, Sean Christopherson wrote:
> > +		pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
> > +		pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
> > +		if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
> > +			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
> > +		else
> > +			pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
> > +
> 
> If X86_FEATURE_PERFCTR_CORE is not set, pmu.msr_gp_*_base should point to
> MSR_K7_PERFCTR0/MSR_K7_EVNTSEL0:

/facepalm

I only ran the PMU tests, which all passthrough the relevant host CPUID.

Glad you debugged this, all tests were failing on Milan due to this.  I shudder
to think about how long it would have taken me to figure this out.

Thanks!

> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index af68f3a..8d5f69f 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -47,10 +47,13 @@ void pmu_init(void)
>  		pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
>  		if (this_cpu_has(X86_FEATURE_AMD_PMU_V2))
>  			pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
> -		else if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
> -			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
> -		else
> +		else if (this_cpu_has(X86_FEATURE_PERFCTR_CORE))

Nit, the if and else-if statements should also have braces.

>  			pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +		else {
> +			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
> +			pmu.msr_gp_counter_base = MSR_K7_PERFCTR0;
> +			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
> +		}
> 
>  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
>  		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> 
> Paolo
> 
