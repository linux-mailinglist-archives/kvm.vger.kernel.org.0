Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EFA65DA97
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 17:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbjADQpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 11:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240088AbjADQow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 11:44:52 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F51343A08
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 08:43:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id ge16so33014518pjb.5
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 08:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GJGzsVqc0RH5NEpH/nYCC5djq7BOccUoPDmHsHYpZwE=;
        b=KaxhlHQF5TQjW01S1eDEGwJgxs9WhYjpWHUSjUTVUaOQbJl4mINBsEjD74mKJLmhTj
         w9q3++UpDsEptTQhal8HNfoo+mbJ7LylI4W/0/1IGL6BY24OEbvjTf8G9oWEHi+dEcvV
         MYpHOB9nuwUjddOsKrCzIFnC63Us8QTShUlfahJxTQ6PkkIlZJBxGieWyeVJD0ZPnRIp
         1Lgq/E0k04PxiAWASP7VuhnSVHn/q1yasyk5I3e10p1SoIA4j2SfEhcEyuMZxQLEArce
         5Y1VICuP80DVjaPNcUXKd6zaEbMPF1LjRWScHfoZbjrabc6YlD6T8uR9BuZ7BIsurxWq
         tewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJGzsVqc0RH5NEpH/nYCC5djq7BOccUoPDmHsHYpZwE=;
        b=0gMjV+oeLpGY4OLZZthaxkmQc3sjkZ+KqYUGvrvxb5MsInTC2rgeAfturWvebhCsfP
         R9CgRJ4/zFPbvoBWkA0hI3l1fPm9391Rmhdx57x3CqDGaERV4mscGrQeD18mTEOivw5y
         8ZqrGTYK/E7E0kmP5teLwWA8kk3E1dMskIIBfI9XfS8GJkNHk2TVB7grkA1TaKCyRH8j
         k1++tgkOC6qlOfjDEXbvzpbqXCLEzve6GNgSpu9PI4DiMocCpSvAr+T1/0W4+r1aXb9r
         FgMMEdUQmmaZakomqoci/l1VUNczrhnNj18A6owWlLyF2uVKy20HAnYBnC8HwdRMJ2hi
         0vjQ==
X-Gm-Message-State: AFqh2kp5/7uXUJ0c8tIuGETfLLdGDw3tZmi+Xhto4uuRtycAPu1ZmTuH
        AnhzZLAOprJ/GAUzNSUCfWO8dA==
X-Google-Smtp-Source: AMrXdXtYFmPSuHX/OSbe7mC5KMIZ4r5Pn8smw+kSOhqck7iyztzXqRZq4dsqIFnLMBWidoGOAWCz2Q==
X-Received: by 2002:a17:902:d4d1:b0:189:3a04:4466 with SMTP id o17-20020a170902d4d100b001893a044466mr4718738plg.2.1672850603260;
        Wed, 04 Jan 2023 08:43:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jb3-20020a170903258300b0018bde2250fcsm24490402plb.203.2023.01.04.08.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:43:22 -0800 (PST)
Date:   Wed, 4 Jan 2023 16:43:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 5/6] KVM: selftests: Add XFEATURE masks to common code
Message-ID: <Y7WspxRhEVwyWf5Y@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-6-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230162442.3781098-6-aaronlewis@google.com>
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

On Fri, Dec 30, 2022, Aaron Lewis wrote:
> Add XFEATURE masks to processor.h to make them more broadly available
> in KVM selftests.
> 
> They were taken from fpu/types.h, which included a difference in

Nit, state the rename as a command, e.g.

  Use the names from the kernel's fpu/types.h for consistency, i.e. rename
  XTILECFG and XTILEDATA to XTILE_CFG and XTILE_DATA respectively.

> spacing between the ones in amx_test from XTILECFG and XTILEDATA, to
> XTILE_CFG and XTILE_DATA.  This has been reflected in amx_test.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 16 ++++++++++++++
>  tools/testing/selftests/kvm/x86_64/amx_test.c | 22 +++++++------------
>  2 files changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 5f06d6f27edf7..c1132ac277227 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -45,6 +45,22 @@
>  #define X86_CR4_SMAP		(1ul << 21)
>  #define X86_CR4_PKE		(1ul << 22)
>  

Add 

 #define XFEATURE_MASK_FP		BIT_ULL(0)

so that you don't have to open code the literal in the next patch.

> +#define XFEATURE_MASK_SSE		BIT_ULL(1)
> +#define XFEATURE_MASK_YMM		BIT_ULL(2)
> +#define XFEATURE_MASK_BNDREGS		BIT_ULL(3)
> +#define XFEATURE_MASK_BNDCSR		BIT_ULL(4)
> +#define XFEATURE_MASK_OPMASK		BIT_ULL(5)
> +#define XFEATURE_MASK_ZMM_Hi256		BIT_ULL(6)
> +#define XFEATURE_MASK_Hi16_ZMM		BIT_ULL(7)
> +#define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
> +#define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
> +
> +#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK \
> +					 | XFEATURE_MASK_ZMM_Hi256 \
> +					 | XFEATURE_MASK_Hi16_ZMM)

'|' on the previous line please, i.e.

#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
					 XFEATURE_MASK_ZMM_Hi256 | \
					 XFEATURE_MASK_Hi16_ZMM)

> +#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA \
> +					 | XFEATURE_MASK_XTILE_CFG)

Same comment here.
