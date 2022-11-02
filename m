Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC8616B4A
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiKBRzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKBRzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:55:14 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C92EF13
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:55:13 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g129so16886794pgc.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMS+WfBtmQrbOCgghgAGwCMyXX9HnJa+859sdM3a+yk=;
        b=ptGhNrqgBlw2auc9znaCWMVG1KBD1wMcgomkKrkOrDktQY3j834pD1l1aSmIdixxr1
         bsDGYdhnQjXlfRaPwz4Tq65Ux+R6yVgDF4tzhCkWOcDyVYGFLW0eDM5wWbHiCxH9dpH4
         jsB5HaNH7QMl5Cj/0rqpaDB6akyJW+9OnotHBVNurnnlAufyMrSKqbVpn9XTEEdoHaNa
         zhoAdrjENKimY/UDZpjHzpp1clTKqbQZ7ZgpjMkJCXlNJ5xDYYj7ch85iLqVwpDGT9UH
         7zjYeOcnowBrZI6Fnr2L7dJgws9WMoT/RWk5cn/0Gtw1s3Vp1hJwjwhevTUEHcvIdrGA
         g9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMS+WfBtmQrbOCgghgAGwCMyXX9HnJa+859sdM3a+yk=;
        b=dH2jXXhFxFYpd2bWVlktVF1Q3jKjr9fP+IDPSIAOj1A4Z797BipQbSSV5k8Q4eDS69
         j1pD2jKX2WsT+u7qNzwwU/KB1Tsj7sIV7cLVipHCMCs36ux+VERL6rYTX+y4Q8X9GT2n
         uC7/8dDyyqc4QVlgcqlGW/WaWeSaOFpTYgbGGvJnZ3eK4b7iIKmn1IVjsomxCwFpiObF
         gM5jkgtIf84YJX9aO9C6SF0AA6GpcEDVC0Ga70EAv41EEv4GoedSm55Ty8cY/UZRjoqA
         jfU9zfgUyX1fHg54oFScsnc8ts7hvegwwJ0DQHzv4uxvP3fNnmxJD8iGPioQzSfAoYgQ
         vi0g==
X-Gm-Message-State: ACrzQf2g9NefCIjBlU4rStXzGHeHszwqDnkRj9RTzeSWNh1iIKAHavPx
        PGmdah6YZ95ZW3Zdh91e9OeaYg==
X-Google-Smtp-Source: AMsMyM5XoAWJXx/kHnEUgaFQniqiNgLXz4JKq/3nQxskQ50pNXtkbI0QVZuMYSEXNioj+iPzWBt/Bg==
X-Received: by 2002:a63:6f8a:0:b0:439:36bc:89f9 with SMTP id k132-20020a636f8a000000b0043936bc89f9mr22159087pgc.100.1667411712959;
        Wed, 02 Nov 2022 10:55:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902900200b0017f9db0236asm8659771plp.82.2022.11.02.10.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:55:12 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:55:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 17/24] x86/pmu: Add GP/Fixed counters
 reset helpers
Message-ID: <Y2Ku/TEg06b57FSM@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-18-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-18-likexu@tencent.com>
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
> +static inline u32 fixed_counter_msr(unsigned int i)
> +{
> +	return MSR_CORE_PERF_FIXED_CTR0 + i;

This should be added in a separate patch.
> +}
> +
> +static inline void write_fixed_counter_value(unsigned int i, u64 value)
> +{
> +	wrmsr(fixed_counter_msr(i), value);
> +}
> +
> +static inline void reset_all_gp_counters(void)
> +{
> +	unsigned int idx;
> +
> +	for (idx = 0; idx < pmu_nr_gp_counters(); idx++) {
> +		write_gp_event_select(idx, 0);
> +		write_gp_counter_value(idx, 0);
> +	}
> +}
> +
> +static inline void reset_all_fixed_counters(void)
> +{
> +    unsigned int idx;
> +
> +	if (!pmu_nr_fixed_counters())
> +		return;
> +
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> +	for (idx = 0; idx < pmu_nr_fixed_counters(); idx++)
> +		write_fixed_counter_value(idx, 0);
> +}
> +
> +static inline void reset_all_counters(void)

Prefix these with "pmu_" so that it's obvious what counters are being rese.

> +{
> +    reset_all_gp_counters();
> +    reset_all_fixed_counters();
> +}
