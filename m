Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF78065C5D9
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbjACSOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbjACSOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:14:04 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C07F2BC1
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:14:03 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g16so23798960plq.12
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1FOidB/JSnmDZiz3L/XYWafO10aB6z9xcfW++7FQocM=;
        b=Ys4JDg0ZqID37zkdsDvoKqjpY9+rPDoQoqtTgh8eifJXoxOz7hHoi3lPSBILS5oTlU
         tn/3NTtQWRXuvcsdH3s5F1jH9xAt/gXnxplJ+eux0MMFn+IOg9A03VA826HIWmKvJcMR
         C7T08BgCya7VkJRiNDveA3h4s1SNlI+GZoB+erUZ/DgGTxd74hzUZSWz3YPk19/0H0Nc
         bAhVQ9KkwkvlPeUCrfFujU/q9hVNzZ3W4ODYFWSJysZCwKRDOguzfzcjlzjNE7QGv6d9
         vMecVwk2PrDNtfZHT0dlwce/w1b+YXArolfBA0p4D8144ulgwUK69vNKm+kFXuUo9PE/
         dvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1FOidB/JSnmDZiz3L/XYWafO10aB6z9xcfW++7FQocM=;
        b=AWBB5ehuJAuOLrtQd0hjnlEb2Rxl0aYX7I+t6R+nsWkGCdZ0uli4ldEQpyX9oE4QBA
         Xt26PN6xPih22hJMy7OLd9O5T1rTsCFJESlz8L/dAW1JPawwJUKqGKBQyti11GsWYhHC
         ZBee9Y93TXy/kpG+yqSersX8nZBM2gaE077r1VPWcdcB5Hfu1TETUb0Oq73cI1SVXBnI
         o3ffulVDIsAflCSWEhlQQ9SuP3ZXpyruD0wsS08dwu0dL4p6HE2IRcbp2deBi+Nsz1uu
         QNL2M1zKaXl2Fdfe8+5ZbBCseA8Uto/I0XiC5+9iTqS7Eautl3z8uu4InM9ebMjKhkHd
         hiNg==
X-Gm-Message-State: AFqh2krA1AhHIN4ShEF1xUMrcCqoXMsOOSb0clUOEs2hIQUDzWdD/i9R
        kV9MfFWpQ6jD7VBwhpYRtWmGMw==
X-Google-Smtp-Source: AMrXdXsxfoSy09Az4cHgIbampqJIqbbiJ+RSlzD1YiBY16oJi/m/GEbt0t6JwhFihnrqccW8XvxSZQ==
X-Received: by 2002:a17:90a:8b8c:b0:219:c2f2:f83c with SMTP id z12-20020a17090a8b8c00b00219c2f2f83cmr3606087pjn.2.1672769642805;
        Tue, 03 Jan 2023 10:14:02 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090a7c4c00b002267b2eb34asm3525967pjl.40.2023.01.03.10.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:14:02 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:13:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 1/2] KVM: selftests: Assert that XSAVE supports XTILE
 in amx_test
Message-ID: <Y7RwZg9XGIJREcph@google.com>
References: <20221230013648.2850519-1-aaronlewis@google.com>
 <20221230013648.2850519-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230013648.2850519-2-aaronlewis@google.com>
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
> The check in amx_test that ensures that XSAVE supports XTILE, doesn't
> actually check anything.  It simply returns a bool which the test does
> nothing with.
> 
> Assert that XSAVE supports XTILE.
> 
> Fixes: 5dc19f1c7dd3 ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX")

Doh.

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
> index bd72c6eb3b670..2f555f5c93e99 100644
> --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> @@ -119,9 +119,9 @@ static inline void check_cpuid_xsave(void)
>  	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
>  }
>  
> -static bool check_xsave_supports_xtile(void)
> +static inline void check_xsave_supports_xtile(void)

Don't explicitly tag local static functions as inline (ignore the existing code
that sets a bad precedent), modern compilers don't need the hint to generate
optimal code,

>  {
> -	return __xgetbv(0) & XFEATURE_MASK_XTILE;
> +	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);

Any objection to moving the assertion into check_xtile_info() and dropping this
one-line helper?

>  }
>  
>  static void check_xtile_info(void)
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
