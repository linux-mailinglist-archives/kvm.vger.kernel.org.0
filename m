Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB2616B3C
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiKBRyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiKBRyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:54:08 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D1A2EF08
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:54:06 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m6so17112977pfb.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fpYDgRbuVtbAhi3UvVtxCWU8xfrY9oiPW0Q34ekpElc=;
        b=hxfe4fBYz4313JRDaRhX/2VOVL6R5WuSg81AhHXoXgcKkgKCZIcsqi6OEsH/S5/0b/
         gxJPieyRiBsbohb3PU4LfisAyQq5GvSUhcrrMvuIXubDveQEQORoNCrXCAQ8A5rIQ5O4
         FOjLPpklhT+9SJmIppKund9yD8PmTLTClCtSshMXXd1HwbExEvRizP0utogDMQgKAWE8
         XODhChNefXkWpJJZ4DJJZsIGoNb7zTSS4yxxmgW4oU59Um3u/cH6kzu4ghUtHTsq+KgX
         JRPLHvqGuJY4zhLV410kl/oZQSUZjjtHdf+fvjrp60gaoOUjn9YKkBkn5MUoc3YMR5k4
         KuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpYDgRbuVtbAhi3UvVtxCWU8xfrY9oiPW0Q34ekpElc=;
        b=AZCeYAsg7Ka89EBayQcmtRhCKYOupL1T95OwUdG8JmlkAjx6e6vOTQDlFG/yi56oGQ
         KXbn2Vv6QfyIzqpaINKiu6YeDWwGt45ekhQwx1Thl+ctmtko7oigMbF5Q/ExuOn67MdF
         41CUsBoY3vMJW9zC/yrwuG0RaHYiFQwRhFRaTNFsxlsgBp+VzjuDVy8hO32Yfk/+LJEU
         b9ANL0I2IptiMR9ETqGZoT/7oSOK/iL9/LhfLtRJO6kAFD6pgvAiZLiujyLmLs8/xt40
         Xt3wjltoaXyknGoKydFSZPxqyoItZxyCwyxf5MCg/8mZ9LQsWrxyWmkejhR+UlrrAtPW
         XoFA==
X-Gm-Message-State: ACrzQf33I+Ke5s4S0/VdqoJBZt6cMCHHalfVlEDDRS/gnA6WN4UGWAJG
        /oSkzwvdjqfwc8CxymDFA3iKHg==
X-Google-Smtp-Source: AMsMyM5E7+t+kS5JVd2cmZMa9gFkaxoNxKHfenISUdm+vEOb5xM6B4Nui+S0COKjfSAqKIjIzhgJqw==
X-Received: by 2002:a65:6d1b:0:b0:46a:f245:8825 with SMTP id bf27-20020a656d1b000000b0046af2458825mr22759441pgb.224.1667411646061;
        Wed, 02 Nov 2022 10:54:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x189-20020a6263c6000000b0056b8af5d46esm8731631pfb.168.2022.11.02.10.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:54:05 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:54:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 16/24] x86/pmu: Add GP counter related
 helpers
Message-ID: <Y2Kuui/2op6aXbkJ@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-17-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-17-likexu@tencent.com>
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
 +static inline u32 gp_counter_base(void)
> +{
> +	return pmu.msr_gp_counter_base;
> +}
> +
> +static inline void set_gp_counter_base(u32 new_base)
> +{
> +	pmu.msr_gp_counter_base = new_base;
> +}
> +
> +static inline u32 gp_event_select_base(void)
> +{
> +	return pmu.msr_gp_event_select_base;
> +}
> +
> +static inline void set_gp_event_select_base(u32 new_base)
> +{
> +	pmu.msr_gp_event_select_base = new_base;
> +}
> +
> +static inline u32 gp_counter_msr(unsigned int i)
> +{
> +	return gp_counter_base() + i;
> +}
> +
> +static inline u32 gp_event_select_msr(unsigned int i)

As propsed in the previous version, I think it makes sense to make these look
like macros so that it's more obvious that the callers are computing an MSR index
and not getting the MSR, e.g.

	MSR_GP_EVENT_SELECTx(i)

> +{
> +	return gp_event_select_base() + i;
> +}
> +
> +static inline void write_gp_counter_value(unsigned int i, u64 value)
> +{
> +	wrmsr(gp_counter_msr(i), value);
> +}
> +
> +static inline void write_gp_event_select(unsigned int i, u64 value)
> +{
> +	wrmsr(gp_event_select_msr(i), value);
> +}

Almost all of these one-line wrappers are unnecessary.  "struct pmu_caps pmu" is
already exposed, just reference "pmu" directly.  And for the rdmsr/wrmsr wrappers,
the code I wanted to dedup was the calculation of the MSR index, hiding the actual
WRMSR and RDMSR operations are a net-negative IMO.
