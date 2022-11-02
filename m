Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0912B616B50
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiKBR4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKBR4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:56:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879B62EF10
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:56:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v3so1934981pgh.4
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xv4CXOqGXyqNk5dTsAv8wfCPmiVi4wwfPNTzhkgk0Nk=;
        b=EIP823ZoFCvhq1PjjRThpLI1nujOsPxmrwnOyMZyg0M5lsLflJjnLeK0sBgtUpQEHV
         rf4UVhQdeMkQk2j/Tfof57nxmCjCjkSa8AKL0CJtyoYEBflceGmfpPRtta1hk6HdnRDs
         gSYC7b92WnfpviGAWTabWAx59Mjj8nhTJw0EIpBVyNXI6WLKAD/Krmr9OHZVV7AUf3v4
         GcpXD5Be6BadxBXbcTK6jboK7Vrc505y+AgIfokf8qGjMsBr0X9RF3HdqZJd6QExUYWk
         X+/hkkDyVvA9DbtE71+ABZZZEbk+KIyvsER4js8H3EvHW819C77sD5fZC91S57fkrjiv
         58YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xv4CXOqGXyqNk5dTsAv8wfCPmiVi4wwfPNTzhkgk0Nk=;
        b=oNHzrMH92EeVk1SqPuuWu0xXMw+MXXg0aslKu5NGuyeCvnFfCbRTJhd4aI7OUrDUBt
         kTLg71P2GPd9SND5WPZMlYh7O9bHrK+Ub1Nrq1J5jYoPMnIkZj6nsv6Pa506KibJn+M4
         lNdljUJiryQRdMkUJFHAbl2oRJkoS69m1XMBIP+UvOXa1vsnUUtfzcfWxoszAa6EFujN
         JGps3M8/XHz5f1PzINi0Te1u4HJhcUveckLS3i9X/y9NWUIEfYghnJqL7QKeqWqNiHik
         W/wxzFA+Sg6BEdol2+9xrroFr/r4K66xe1dloMyufa/2YSQL8V7Q1i/tsV2MZrkr0A5p
         LrBA==
X-Gm-Message-State: ACrzQf1TAlTTf12eNbO03iW51jz7uysvjGL1hYxRM+vZq622yniymPiW
        /Dh9nE40bAfQ0pSyVguNHtCqvgupPSHfaQ==
X-Google-Smtp-Source: AMsMyM7VYu8oyaU4JxA1zfFJz89mEBbV8jjnvLJSwD7td2SKO7kzaf6gZ0DYZeDBqMkYagGJl9zgDA==
X-Received: by 2002:a05:6a00:b47:b0:56d:5266:464c with SMTP id p7-20020a056a000b4700b0056d5266464cmr19396685pfo.2.1667411769953;
        Wed, 02 Nov 2022 10:56:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b189-20020a621bc6000000b0056b818142a2sm8756052pfb.109.2022.11.02.10.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:56:09 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:56:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 18/24] x86/pmu: Add a set of helpers
 related to global registers
Message-ID: <Y2KvNo4t6YDNwMy/@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-19-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-19-likexu@tencent.com>
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
> @@ -194,4 +197,34 @@ static inline void reset_all_counters(void)
>      reset_all_fixed_counters();
>  }
>  
> +static inline void pmu_clear_global_status(void)
> +{
> +	wrmsr(pmu.msr_global_status_clr, rdmsr(pmu.msr_global_status));
> +}
> +
> +static inline u64 pmu_get_global_status(void)
> +{
> +	return rdmsr(pmu.msr_global_status);
> +}
> +
> +static inline u64 pmu_get_global_enable(void)
> +{
> +	return rdmsr(pmu.msr_global_ctl);
> +}
> +
> +static inline void pmu_set_global_enable(u64 bitmask)
> +{
> +	wrmsr(pmu.msr_global_ctl, bitmask);
> +}
> +
> +static inline void pmu_reset_global_enable(void)
> +{
> +	wrmsr(pmu.msr_global_ctl, 0);
> +}
> +
> +static inline void pmu_ack_global_status(u64 value)
> +{
> +	wrmsr(pmu.msr_global_status_clr, value);
> +}

Other, than pmu_clear_global_status(), which provides novel functionality, the
rest of these wrappers are superfluous.
