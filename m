Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC4C5F5BCE
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 23:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiJEVg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 17:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiJEVg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 17:36:57 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392FB80483
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 14:36:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bh13so44934pgb.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 14:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TF3OC6aX+P0/YGKKHwRrwWdaAzeL9LkSBSOfZoSBAC0=;
        b=oeejbn6VwmiIux3gXlUR/HrhVit694CVIpMXFHW/7M2iid6Nz9adUdP4w0897QPQ0f
         AlJznMc+jQne3Qz8i6BgYiSXZty5gu9EXjPSpQYxSSATmn3Pd88oaHduVXIAdfWE6SJ6
         ZZO2HW5rYuY5mMtCLl/6EurwmV0yJtwwycNhoa9mf0IhLVizyTL6BdnuWuW0putAV9pe
         tgPiNNbPXsManepXj/iz5z672ElsIuazoSEeJ565vbD1tdAUijWzd9gWF8JnDN11hMOl
         10zrZt7cdHKqyBZSCk2jkEVScs3CU+rb+Lqr2eDtzgsYgvIlcrusgM1T4csNDKZ1Hjxx
         hRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TF3OC6aX+P0/YGKKHwRrwWdaAzeL9LkSBSOfZoSBAC0=;
        b=WLgXs5M4PgUCkaJr9QPNMz5TrEd5ayMyc1+vDVz7+bintU3Sa/Y5lYkXo4rT87TbIz
         En8x/EIaNHDDdrb7rG0Ob9CTyeQp1J4sjO3x9yJXisoa4b97py5kSgm/14L2YsQFkojl
         49PLX7dDP71gdoJ575i1a4mWyuafgt8ry+qyrlg5h7dBJDTUHgG2W3B86pbDa1zHh4SU
         c/KApTNiHasWmVFJDEsY9nxI7LuhuteF3iRtP/F5kQk43Giwm16o6LsVwHc6DiBKQB9Q
         1J/g/7PbShwtzsJcbyfdzKMI4IgCdw7+llsjAYmrXzSi7VdAe7A/G8ty/QouscXhg8hM
         k1Xg==
X-Gm-Message-State: ACrzQf31L6riUGHfRDGLnCbFWoLYikmgdRV8WYdlpfJbWRNgr9RnYnPI
        /hd/bFgeM88DjT/tpEqkiRQ10A==
X-Google-Smtp-Source: AMsMyM7pUTMk5eCHcXlGZORW0DhE5abW+CoB8j2tBSPQbCQ4DzM8g39OrVpf+ZCjY0PIkbZ/jwzssg==
X-Received: by 2002:a63:d843:0:b0:43c:8ce9:2aab with SMTP id k3-20020a63d843000000b0043c8ce92aabmr1576780pgj.556.1665005810643;
        Wed, 05 Oct 2022 14:36:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z1-20020a170903018100b0016c9e5f290esm10956410plg.10.2022.10.05.14.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 14:36:50 -0700 (PDT)
Date:   Wed, 5 Oct 2022 21:36:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/pmu: Update rdpmc testcase to
 cover #GP and emulation path
Message-ID: <Yz347iKzq7cbjMdw@google.com>
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905123946.95223-6-likexu@tencent.com>
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

On Mon, Sep 05, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Specifying an unsupported PMC encoding will cause a #GP(0).
> All testcases should be passed when the KVM_FEP prefix is added.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  lib/x86/processor.h |  5 ++++-
>  x86/pmu.c           | 13 +++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 10bca27..9c490d9 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -441,7 +441,10 @@ static inline int wrmsr_safe(u32 index, u64 val)
>  static inline uint64_t rdpmc(uint32_t index)
>  {
>  	uint32_t a, d;
> -	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
> +	if (is_fep_available())
> +		asm volatile (KVM_FEP "rdpmc" : "=a"(a), "=d"(d) : "c"(index));
> +	else
> +		asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));

Hmm, not sure how I feel about the idea of always use FEP in a common helper when
it's available.  Part of me likes the idea, but part of me is worried that it
will cause confusion due to not being explicit.

Unless there's a pressing need to force emulation, let's punt the FEP stuff for
now.  More below.

>  	return a | ((uint64_t)d << 32);
>  }
>  
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 203a9d4..11607c0 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -758,12 +758,25 @@ static bool pmu_is_detected(void)
>  	return detect_intel_pmu();
>  }
>  
> +static void rdpmc_unsupported_counter(void *data)
> +{
> +	rdpmc(64);
> +}
> +
> +static void check_rdpmc_cause_gp(void)

Maybe check_invalid_rdpmc_gp()?  There are multiple reasons RDPMC can #GP, the
one that is being relied on to guarantee #GP is specifically that the PMC is
invalid.
dd

> +{
> +	report(test_for_exception(GP_VECTOR, rdpmc_unsupported_counter, NULL),

I'd really like to move away from test_for_exception() and use ASM_TRY().  Ignoring
FEP for the moment, the most extensible solution is to provide a safe variant:

static inline int rdpmc_safe(u32 index, uint64_t *val)
{
	uint32_t a, d;

	asm volatile (ASM_TRY("1f")
		      "rdpmc"
		      : "=a"(a), "=d"(d) : "c"(index));
	*val = (uint64_t)a | ((uint64_t)d << 32);
	return exception_vector();
}

static inline uint64_t rdpmc(uint32_t index)
{
	uint64_t val;
	int vector = rdpmc_safe(index, &val);

	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
		   exception_mnemonic(vector), index);
	return val;
}


For long-term emulation validation, the best idea I have at this point is to do
add a config knob to opt-in to using FEP in _all_ common helpers (where "all"
means everything KVM actually emulates).  It'd take some macro magic, but it'd
be easier to maintain (no need to have two paths in every helper) and would be
controllable.

> +		"rdpmc with invalid PMC index raises #GP");
> +}
> +
>  int main(int ac, char **av)
>  {
>  	setup_vm();
>  	handle_irq(PC_VECTOR, cnt_overflow);
>  	buf = malloc(N*64);
>  
> +	check_rdpmc_cause_gp();
> +
>  	if (!pmu_is_detected())
>  		return report_summary();
>  
> -- 
> 2.37.3
> 
