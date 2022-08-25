Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD105A173F
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 18:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiHYQxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 12:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbiHYQxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 12:53:02 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34F0113
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 09:52:58 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z187so20331748pfb.12
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 09:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=vJj32hJvJGqkLqOH+3ra6D6nxOVq8DAl1sAc3dJpCjQ=;
        b=A1nxbuvolMJoJdVb4d2CeQ4deHP4rqOZs/TGKqEa/qgD20Q02IBCEc7eW+rStkj5K0
         D21GMCjOP5e+syC4ioQV2krjxXU3tlECG79YnCr/mqa7dW1y3k6V1iF+pKdPw3gs9jc3
         RPbmWLoQnxwHxEo4e0ueRPrkmNH9MZX/WT83UdZl0/xKtVmHzW/B/PsoXYeF71v6DW1Q
         SLQO+5avsNIKeAMF+hneHrKaaHt8oP/WjoFWKerxjct5NLGVqO0os2PrCDr5xMFGqFkC
         KmZGD2U9lEFfXh/XMifNiI/81vv/RCaPOyyGHwkg5quLecKl7Enr21eRs/2f7LYv4vGN
         9NAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vJj32hJvJGqkLqOH+3ra6D6nxOVq8DAl1sAc3dJpCjQ=;
        b=beiZ/sycdWhxAF67WB4VPk1xBwDJB5wPpivmC4LKeF0ZUEU8l/oned70a0a4guZgL4
         owKXVwttTPRHCQ5xpRX2gGuhmZgKATrq/Fl5sfCby/VzzcU/sjVgGo2iyO5PYTDs9tlq
         TrFyqiKlzkfKP+yX38JYjiNMe7GIKdskLlTViMAdNuvwDNn46hIwMpaR8uaqs3ZnQzpx
         kW0yUS+fSPwY4spGjcJfjyYGBr/XRNqsnm55pqaixsaolQQsKZsyWFPnvHCBZgYhq+TG
         kRYbX3RPlkGmJ/cjrb3x0dU1cdAswWkN5V3SVimS2obtM/gAdHBFlJuTQ40DaRpSQchH
         eyjg==
X-Gm-Message-State: ACgBeo290SPaFk0cPvQq27IxGb7eEQeOxeV/GE/ewRuWS4dt3faq73Hl
        48IY+mNsc6PMM6AqyCksHRIw0Q==
X-Google-Smtp-Source: AA6agR5NVWXmyuXOgXsVmLZCpYheZR95GpW+RbkOLt2FXFMx1LD4VylP1CW8x/Hy3QYEIDM/dHONMw==
X-Received: by 2002:a63:e74d:0:b0:429:ead9:a350 with SMTP id j13-20020a63e74d000000b00429ead9a350mr30400pgk.194.1661446377961;
        Thu, 25 Aug 2022 09:52:57 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id j125-20020a625583000000b00535fd3290f0sm13789154pfb.113.2022.08.25.09.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 09:52:56 -0700 (PDT)
Date:   Thu, 25 Aug 2022 09:52:53 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a
 field of an ID register
Message-ID: <Yweo5cmA6D0pxwmJ@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-2-reijiw@google.com>
 <Ywen44OKe8gGcOcW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywen44OKe8gGcOcW@google.com>
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URI_DOTEDU,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 09:48:35AM -0700, Oliver Upton wrote:
> Hi Reiji,
> 
> On Wed, Aug 24, 2022 at 10:08:38PM -0700, Reiji Watanabe wrote:
> > Introduce helpers to extract a field of an ID register.
> > Subsequent patches will use those helpers.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h     |  2 ++
> >  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index a8124f9dd68a..a9b4b4e0e592 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >  
> >  uint32_t guest_get_vcpuid(void);
> >  
> > +int cpuid_get_sfield(uint64_t val, int field_shift);
> > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 6f5551368944..0b2ad46e7ff5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >  		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> >  		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> >  }
> > +
> > +/* Helpers to get a signed/unsigned feature field from ID register value */
> > +int cpuid_get_sfield(uint64_t val, int field_shift)
> > +{
> > +	int width = 4;
> > +
> > +	return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > +}
> 
> I don't believe this helper is ever used.
> 
> > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
> > +{
> > +	int width = 4;
> > +
> > +	return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > +}
> 
> I would recommend not open-coding this and instead make use of
> ARM64_FEATURE_MASK(). You could pull in linux/bitfield.h to tools, or do
> something like this:
> 
>   #define ARM64_FEATURE_GET(ftr, val)					\
>   	  	  ((ARM64_FEATURE_MASK(ftr) & val) >> ftr##_SHIFT)
> 
> Slight preference for FIELD_{GET,SET}() as it matches the field
> extraction in the kernel as well.

Was doing that with this commit:

	[PATCH v5 05/13] tools: Copy bitfield.h from the kernel sources

Maybe you could just use it given that it's already reviewed.

> 
> --
> Thanks,
> Oliver
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
