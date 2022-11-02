Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE4616B25
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKBRqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiKBRqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:46:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6B512ACD
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:45:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v17so14245819plo.1
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pY0dUZsRBdN0AINZJjCeDckxHGzVpXYMyKJg3xV8JzU=;
        b=Hbp6HO0r5jaiNAEW9ZCDdcErM2VwhfjO0aa2m1s7T6l5nZuAGVjapgXD0rPIzq5HSw
         O6TJXzaAjGkXSjFsuruqjseP0PTbGNEdFWf5RUDcClknlqamXQuZanL5A0irSLL2bZO0
         dwdVy5iWaQKUgCRlr0HvxyUbrjR+4olRGNjHPdjMVa131nHtBCVHy1Cl04SDHCr/oM90
         hvNE2HDjIPZ+xpCtPwCid+ZQHwPu/61SiOnYfOV6YWvfTM9IH42tKT6LfnWcri+bXN/0
         YdhFnBwZqGA30NlstdvUcB6j8VfpXyv22EA+TmFI99j2qlmnMmRD5bihbYrH4obwMthB
         EJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pY0dUZsRBdN0AINZJjCeDckxHGzVpXYMyKJg3xV8JzU=;
        b=FBU91TTLuroak8QAQXousKYuO5s5yICKuOA3p06b2/zDaz4rLHrNfAzBdDzL9iwqQt
         yulz+aXmjAAZjHwJAXSt2lsDbqAIhOQ9WYmvYu33U+cFGjCnYq6PAERC7a0OGtsDj48U
         SsC7WhoZjU/jjQXri3y1RhOVzWsAHhrUuJKG/hwQXYiT2WdHy7zr9HuzV5y7QkcVIjup
         3IMCv8tz+PIvGrJwim/NHCrMIslmyk/qUqNZMAMRP+rm0D/CirQGBiJBErZo7Ds9GwWH
         Ocf5+psoR3EYiFqUvX/C5eMOl3fe6F9EWbCMIBAlGiBkcAXJ/uBiYmeJgMOzguvgD1OY
         cQ4w==
X-Gm-Message-State: ACrzQf20ap6WMtnHHEZWHRqOQnwK3YApyl+Lal5u1EFG3Pxz2nH3owAa
        F1T8yRcdvoTSxoFADQt3SIaHTQ==
X-Google-Smtp-Source: AMsMyM4Y3s19v+Kz132cQY64lUo9pV7FFKtKdGuvMH7i1T2y6ZiHuXe/8AZnkt3jqVDuOdFI35VucQ==
X-Received: by 2002:a17:902:e810:b0:186:e9ff:4ec2 with SMTP id u16-20020a170902e81000b00186e9ff4ec2mr25176969plg.26.1667411159028;
        Wed, 02 Nov 2022 10:45:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z20-20020aa79f94000000b0056246403534sm8760578pfr.88.2022.11.02.10.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 10:45:58 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:45:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 15/24] x86/pmu: Initialize PMU
 perf_capabilities at pmu_init()
Message-ID: <Y2Ks08tQA+08wI5/@google.com>
References: <20221024091223.42631-1-likexu@tencent.com>
 <20221024091223.42631-16-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024091223.42631-16-likexu@tencent.com>
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
> From: Like Xu <likexu@tencent.com>
> 
> Re-reading PERF_CAPABILITIES each time when needed, adding the
> overhead of eimulating RDMSR isn't also meaningless in the grand
> scheme of the test.
> 
> Based on this, more helpers for full_writes and lbr_fmt can also
> be added to increase the readability of the test cases.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  lib/x86/pmu.c |  3 +++
>  lib/x86/pmu.h | 18 +++++++++++++++---
>  x86/pmu.c     |  2 +-
>  x86/pmu_lbr.c |  7 ++-----
>  4 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index e8b9ae9..35b7efb 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -1,8 +1,11 @@
>  #include "pmu.h"
>  
>  struct cpuid cpuid_10;
> +struct pmu_caps pmu;
>  
>  void pmu_init(void)
>  {
>      cpuid_10 = cpuid(10);
> +    if (this_cpu_has(X86_FEATURE_PDCM))
> +        pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);

Tabs...
