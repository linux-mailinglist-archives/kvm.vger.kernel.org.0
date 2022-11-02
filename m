Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AC2616B57
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiKBR67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiKBR6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:58:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1021B1DF02
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:58:43 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y13so17086544pfp.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=870ePeKf/g5/gv7jvhhc9uXlyy+wXSAuC1dLJzDbfU4=;
        b=bKBi4f3Mj/csNXtmaCXh9uZTo5NRblA00Y9vUFqQFWzv1bfG/4NyylKmwl3YH9UqFS
         hR7kU7RZvCi22SBIKaeVMMuDh76PhfDdg+z/WwV+tXEbqPaQM5JWuk1FvJXs8aR67QEk
         Re2EXlz/4B0RAvG4fzClH1lLz1M2grsUUmJWx6MeqoHoIIPBSz86OVIOwJ0foFxx1Si5
         P2PBCHeNKeX8KWwCpDPiVuaX0bJuLs5hwbRToEMSGc/U5nqOc/G1Ok5B4C4lR8Vs06XH
         vSdHmoigBqXuCPZvjVG3SjOZMD8ArE+HQtnxv/dcPeYXBtchyS3docJm0LYiFD7ZM4cz
         s77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=870ePeKf/g5/gv7jvhhc9uXlyy+wXSAuC1dLJzDbfU4=;
        b=16Z7PRB7pMr4wHAdRduFsa8vJpyQqZJ87vjh9YtU45Z8RxwoOlF+ug+ncI17T+8aEA
         eMl1oNXXr8AKsMd4oB6am+zOHkgb/qtmQjYLF47SJn0Xk4S40ItUiAM8ldvba6NjJEim
         0KbFzvQMbHGs9KB+7o9dPkSerVc5/+oxtpgJ9wbfxEbKTUR7ZPfoDh8UOfjV4n5V9Tk4
         vFDtWpG6hpUWVyKPvfgTf9bqAcSW22FJ1j6iw43ZD5Ws2W8Vrk5qaigNcVTp7ur4UUci
         6KQzUFLXoY8ziYkBkHZsYDL8rSuJOCB0tj5jtUeUC+F8C8JU6Ehoqsn980pH7IjvIX9N
         n1SA==
X-Gm-Message-State: ACrzQf2GMOJeOy3OpWAcyx7UXDRJCVcIQq/gSd2j/IBNe2g776OXEezQ
        +Q4zxYLCXbI3BlFJ7xA9YaeMvQ==
X-Google-Smtp-Source: AMsMyM5dWNkcf2+fykK6GVeKAEqK2UQrPkyh4w5OxsoelvaCcQsmow7nQRO6GWHLdnekHTyAPxI/mA==
X-Received: by 2002:a65:53c6:0:b0:46f:cbcb:7402 with SMTP id z6-20020a6553c6000000b0046fcbcb7402mr13577265pgr.366.1667411922325;
        Wed, 02 Nov 2022 10:58:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h13-20020a63384d000000b0045751ef6423sm7852427pgn.87.2022.11.02.10.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:58:41 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:58:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sandipan Das <sandipan.das@amd.com>
Subject: Re: [kvm-unit-tests PATCH v4 23/24] x86/pmu: Update testcases to
 cover AMD PMU
Message-ID: <Y2KvzqPsU5VIGU+x@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-24-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-24-likexu@tencent.com>
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

On Mon, Oct 24, 2022, Like Xu wrote:
> @@ -104,11 +115,17 @@ static inline void write_gp_event_select(unsigned int i, u64 value)
>  
>  static inline u8 pmu_version(void)
>  {
> +	if (!is_intel())
> +		return 0;

This can be handled by adding pmu_caps.version.

> +
>  	return cpuid_10.a & 0xff;
>  }
>  
>  static inline bool this_cpu_has_pmu(void)
>  {
> +	if (!is_intel())
> +		return true;

I think it makes sense to kill off this_cpu_has_pmu(), the only usage is after
an explicit is_intel() check, and practically speaking that will likely hold true
since differentiating between Intel and AMD PMUs seems inevitable.

> +
>  	return !!pmu_version();
>  }
>  
> @@ -135,12 +152,18 @@ static inline void set_nr_gp_counters(u8 new_num)
>  
>  static inline u8 pmu_gp_counter_width(void)
>  {
> -	return (cpuid_10.a >> 16) & 0xff;
> +	if (is_intel())

Again, can be handled by utilizing pmu_caps.

> +		return (cpuid_10.a >> 16) & 0xff;
> +	else
> +		return PMC_DEFAULT_WIDTH;
>  }
>  
>  static inline u8 pmu_gp_counter_mask_length(void)
>  {
> -	return (cpuid_10.a >> 24) & 0xff;
> +	if (is_intel())
> +		return (cpuid_10.a >> 24) & 0xff;
> +	else
> +		return pmu_nr_gp_counters();
>  }
>  
>  static inline u8 pmu_nr_fixed_counters(void)
> @@ -161,6 +184,9 @@ static inline u8 pmu_fixed_counter_width(void)
>  
>  static inline bool pmu_gp_counter_is_available(int i)
>  {
> +	if (!is_intel())
> +		return i < pmu_nr_gp_counters();
> +
>  	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
>  	return !(cpuid_10.b & BIT(i));
>  }
> @@ -268,4 +294,9 @@ static inline bool pebs_has_baseline(void)
>  	return pmu.perf_cap & PMU_CAP_PEBS_BASELINE;
>  }
>  
> +static inline bool has_amd_perfctr_core(void)

Unnecessary wrappers, just use this_cpu_has() directly.

> +{
> +	return this_cpu_has(X86_FEATURE_PERFCTR_CORE);
> +}
