Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA775F5CD8
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJEWoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJEWoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:44:23 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ECA84E65
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:44:22 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id l4so48448plb.8
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LOQMhSU5WgKqvLmA7dxXtC5yJpKLeZOqdG0Cst2NQtc=;
        b=fXeBDVCJznDT9jUSWalL1Z/NwqJDeRov6WZOqYGkURdQx5QqqI89aeB3JhkHYqT1MT
         eNW2hzG7C10hYc0M/Ibzq/nTCquak92fIboMTbrWnuXY/G1VzVPJV9/5+Xdqh9zTEGMm
         wlCTMNbkKE4o0Ep28hzE9e16F53IwQ2A1YxsFzES7oTCbihQIaTgUrGmpVob2qeKL7o3
         an+Al4qhYSSOunFqbadpoY6SqGvhYnJddWrOOHQpvIigxCZMTeAZRJjnxB2FlNC8mAkb
         YvzExIX1of8iVf96rP+TcrCTBTfaC3c9zeUBH3cwySaCuwTt1uiJdWCm4xwQhhlmRBQs
         h0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOQMhSU5WgKqvLmA7dxXtC5yJpKLeZOqdG0Cst2NQtc=;
        b=5pGFJLx4tXYAty3nBfm9eVWoC6F8P8zEZFdD9vKyKNHnAfK6vzJXIfFen2a4vpRqFW
         fnNkdaCpwEg1MIC+bB0NQiO/JYxYfjXgonTgykEOn0sPIbuGivmI3RKw5Cj2oP/Mjlg8
         zEjmuNcfGWwCKwr3hKuK6hP458SqkfhCbLoxPI2XF9ZzZ/tv/JqwCQc2+00wwMSXwUA+
         q0Xtm0J2f8ogs36Wtf6nx3a9rHTtZvsZ14qKNtH6UNP58FYDRAaRaAUYPw/bCOKQ0qJV
         sKNMvzAns9PS2I9HuKg6O3lqhVaLSrtHWEKsE5IBfe7Hwn3D9I57JoDop/a+h0BiiiOn
         bhLw==
X-Gm-Message-State: ACrzQf3pEqVHWhfaOSZ5XjepwZgvglw/smngeoLWN/v4HDYPHLpQ3h5H
        JgfPrqLnMQ+kSnwF9NYoSRGNY30zO1JjWQ==
X-Google-Smtp-Source: AMsMyM6YLkVKSr3x9q1Kl/5sYS1KUTXLzZSXFLGbjhfWZtWLSF4BUEYz7oDuTU0W5GNYJrNVm3QW+g==
X-Received: by 2002:a17:90b:350b:b0:202:8495:6275 with SMTP id ls11-20020a17090b350b00b0020284956275mr7483446pjb.216.1665009861774;
        Wed, 05 Oct 2022 15:44:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e10-20020aa7980a000000b0055fb15ff08csm8996030pfl.184.2022.10.05.15.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:44:21 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:44:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 12/13] x86/pmu: Add assignment
 framework for Intel-specific HW resources
Message-ID: <Yz4IwVKje90pcIUN@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-13-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-13-likexu@tencent.com>
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
> @@ -65,7 +65,13 @@ struct pmu_event {
>  };
>  
>  #define PMU_CAP_FW_WRITES	(1ULL << 13)
> -static u64 gp_counter_base = MSR_IA32_PERFCTR0;
> +static u32 gp_counter_base;
> +static u32 gp_select_base;
> +static unsigned int gp_events_size;
> +static unsigned int nr_gp_counters;
> +
> +typedef struct pmu_event PMU_EVENTS_ARRAY_t[];
> +static PMU_EVENTS_ARRAY_t *gp_events = NULL;

There's no need for a layer of indirection, C d.  The NULL is also not strictly
required.  E.g. this should Just Work.

  static struct pmu_event *gp_events;

And then I beleve a large number of changes in this series go away.

>  char *buf;
>  
> @@ -114,9 +120,9 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>  	if (is_gp(cnt)) {
>  		int i;
>  
> -		for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
> -			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
> -				return &gp_events[i];
> +		for (i = 0; i < gp_events_size; i++)
> +			if ((*gp_events)[i].unit_sel == (cnt->config & 0xffff))
> +				return &(*gp_events)[i];
>  	} else
>  		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
>  
> @@ -142,12 +148,22 @@ static void global_disable(pmu_counter_t *cnt)
>  			~(1ull << cnt->idx));
>  }
>  
> +static inline uint32_t get_gp_counter_msr(unsigned int i)

Rather than helpers, what about macros?  The problem with "get" is that it sounds
like the helper is actually reading the counter/MSR.  E.g. see MSR_IA32_MCx_CTL()

Something like this?

  MSR_PERF_GP_CTRx()

> +{
> +	return gp_counter_base + i;
> +}
> +
> +static inline uint32_t get_gp_select_msr(unsigned int i)
> +{
> +	return gp_select_base + i;

Same here, maybe?

  MSR_PERF_GP_SELECTx()

