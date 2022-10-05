Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A4A5F5CC2
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJEWfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJEWfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:35:43 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F136068D
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:35:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x32-20020a17090a38a300b00209dced49cfso3467658pjb.0
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mU7OoB3o5jMUluZGX4ToZ2qrNbb+qWkBplRABQ84M0E=;
        b=Dy7EQ0TTf51MW3/24LDT4pOISIyR3O9qFeeJNGrSlytzEmCi/edJEAhrssXwnphbZY
         jcShgGH83K2DDcdry10T4IZVKRP+9CSFfmsusAH7Q7kqKXzaCNeyNjXb2eIpbpQ1f+8u
         pfl6f09Ulpfix4Tk95Pioz6vOn4TlKvcPV2Zt62aUTbwppmKUc9zR+WAs0MVCv2iJKDl
         FRBrnoHSlw++zP5GvMlWxBIhtucdua/b/5mfayM2vTUZVAUgTndIK0GAnbAxIUaNB8Jz
         woV17R/CL4a7tcBZ+rpUp+X7cL8dna3GH+MNmt0ditooOi5TomSR9PpTlMAxpisj0KLM
         C0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mU7OoB3o5jMUluZGX4ToZ2qrNbb+qWkBplRABQ84M0E=;
        b=o39fWzrwikAbVlE9/JoC2+gEyR9LeKMZ8uVJere6Q/pmfvSiXhyhZ/XTLbAfwPh0IA
         97ZrjvH11SByGkI1uy2aVaKcX78DKldU4gx/z5xqQzQbPSGe8lYJzFJ2wiUoFcrC+sZf
         gnHOOZ1vy4gntRPZFZWbre88w8GGuPJQapvFjyJuzCedIqTNqz0h4cmBPr7OyA82tfQ1
         qT8HNJxVHtN+vq7o8Cw3+3HEHCsaaMtFedePhk/mfj3wqhjycAdjEkDRV6L6imMYQsFH
         L3ufiUwYEMS/WqLk+WEO9Na8V6qDyAe4JrptRJvWsz219rqWaajKX6EWf92iRu+WYCf/
         4xLw==
X-Gm-Message-State: ACrzQf0/AEw3ZUAxodtuKH87MDmjGN6KHZLifM9uKJ1C9t5YOTFanm7G
        enfyV+schBIetStFcqe0i5hk01Q40+ichQ==
X-Google-Smtp-Source: AMsMyM7ibWcnO48qE0Svypiu5RHx8U4lF9Ggbc6nBKWgb0HYufF0CptHDTEBDgbfZGCMwnBdJ2MmQw==
X-Received: by 2002:a17:90a:178c:b0:20a:7e16:a693 with SMTP id q12-20020a17090a178c00b0020a7e16a693mr1923429pja.165.1665009338016;
        Wed, 05 Oct 2022 15:35:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i19-20020a17090320d300b00179f442519csm10932067plb.40.2022.10.05.15.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:35:37 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:35:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Message-ID: <Yz4GtqyPIMCMsUEl@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-11-likexu@tencent.com>
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

On Fri, Aug 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> For most unit tests, the basic framework and use cases which test
> any PMU counter do not require any changes, except for two things:
> 
> - No access to registers introduced only in PMU version 2 and above;
> - Expanded tolerance for testing counter overflows
>   due to the loss of uniform control of the gloabl_ctrl register
> 
> Adding some pmu_version() return value checks can seamlessly support
> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.

Phrase this as a command so that it's crystal clear that this is what the patch
does, as opposed to what the patch _can_ do.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 43 insertions(+), 21 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 25fafbe..826472c 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -125,14 +125,19 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>  
>  static void global_enable(pmu_counter_t *cnt)
>  {
> -	cnt->idx = event_to_global_idx(cnt);
> +	if (pmu_version() < 2)

Helper please.

> +		return;
>  
> +	cnt->idx = event_to_global_idx(cnt);
>  	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
>  			(1ull << cnt->idx));
>  }
>  
>  static void global_disable(pmu_counter_t *cnt)
>  {
> +	if (pmu_version() < 2)
> +		return;
> +
>  	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
>  			~(1ull << cnt->idx));
>  }
> @@ -301,7 +306,10 @@ static void check_counter_overflow(void)
>  	count = cnt.count;
>  
>  	/* clear status before test */
> -	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +	if (pmu_version() > 1) {

Should be a helper to use from an earlier patch.

Hmm, looking forward, maybe have an upper level helper?  E.g.

  void pmu_clear_global_status_safe(void)
  {
	if (!exists)
		return

	wrmsr(...);
  }

Ignore this suggestion if these checks go away in the future.

> +		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +		      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +	}
>  
>  	report_prefix_push("overflow");
>  
> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>  			cnt.config &= ~EVNTSEL_INT;
>  		idx = event_to_global_idx(&cnt);
>  		__measure(&cnt, cnt.count);
> -		report(cnt.count == 1, "cntr-%d", i);
> +
> +		report(check_irq() == (i % 2), "irq-%d", i);
> +		if (pmu_version() > 1)

Helper.

> +			report(cnt.count == 1, "cntr-%d", i);
> +		else
> +			report(cnt.count < 4, "cntr-%d", i);
> +
> +		if (pmu_version() < 2)

Helper.

> +			continue;
> +
>  		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>  		report(status & (1ull << idx), "status-%d", i);
>  		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
>  		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>  		report(!(status & (1ull << idx)), "status clear-%d", i);
> -		report(check_irq() == (i % 2), "irq-%d", i);
>  	}
>  
>  	report_prefix_pop();
> @@ -440,8 +456,10 @@ static void check_running_counter_wrmsr(void)
>  	report(evt.count < gp_events[1].min, "cntr");
>  
>  	/* clear status before overflow test */
> -	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> -	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +	if (pmu_version() > 1) {

Helper.  Curly braces aren't necessary.

> +		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +	}
>  
>  	start_event(&evt);
>  
> @@ -453,8 +471,11 @@ static void check_running_counter_wrmsr(void)
>  
>  	loop();
>  	stop_event(&evt);
> -	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> -	report(status & 1, "status");
> +
> +	if (pmu_version() > 1) {

Helper.

> +		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> +		report(status & 1, "status");

Can you opportunistically provide a better message than "status"?

> +	}
>  
>  	report_prefix_pop();
>  }
> @@ -474,8 +495,10 @@ static void check_emulated_instr(void)
>  	};
>  	report_prefix_push("emulated instruction");
>  
> -	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> -	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +	if (pmu_version() > 1) {

Helper, no curly braces.  Ah, IIRC, kernel perf prefers curly braces if the code
spans multiple lines.  KVM and KUT does not.

> +		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
> +	}
>  
>  	start_event(&brnch_cnt);
>  	start_event(&instr_cnt);
> @@ -509,7 +532,8 @@ static void check_emulated_instr(void)
>  		:
>  		: "eax", "ebx", "ecx", "edx");
>  
> -	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +	if (pmu_version() > 1)

Helper.

> +		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>  
>  	stop_event(&brnch_cnt);
>  	stop_event(&instr_cnt);
> @@ -520,10 +544,13 @@ static void check_emulated_instr(void)
>  	       "instruction count");
>  	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
>  	       "branch count");
> -	// Additionally check that those counters overflowed properly.
> -	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> -	report(status & 1, "instruction counter overflow");
> -	report(status & 2, "branch counter overflow");
> +
> +	if (pmu_version() > 1) {

Helper?  E.g. if this is a "has architectural PMU".

> +		// Additionally check that those counters overflowed properly.
> +		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> +		report(status & 1, "instruction counter overflow");
> +		report(status & 2, "branch counter overflow");
> +	}
>  
>  	report_prefix_pop();
>  }
> @@ -647,12 +674,7 @@ int main(int ac, char **av)
>  	buf = malloc(N*64);
>  
>  	if (!pmu_version()) {
> -		report_skip("No pmu is detected!");
> -		return report_summary();
> -	}
> -
> -	if (pmu_version() == 1) {
> -		report_skip("PMU version 1 is not supported.");
> +		report_skip("No Intel Arch PMU is detected!");
>  		return report_summary();
>  	}
>  
> -- 
> 2.37.2
> 
