Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5D598FBB
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 23:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbiHRVl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 17:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345474AbiHRVl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 17:41:56 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A929C0B5C
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 14:41:54 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id x64so2082628iof.1
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 14:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=12trcFRxDuHrpJDyiPsv28L/LnqZ2qb9yEz4s6vZWvE=;
        b=XeM6jeX+CrtxFwgUSYb6nmX2DC8Tzwd/6PUwSacv3azNVXYuYkZFuHgU/RAo8sTD79
         5yhRghlAn+wSnrhhXnJW+4Tzahvv5TqKHttI4ebQcDlKlYsUnKb1FldzG+nbI+9Xg4h/
         JFMukpRHqMpX6htETtWBPhLRj/HXyPS/JMEb9YqDnF7k5cBrNjQo7c2c3GnNPeiYzeJ7
         4v5K9SwYdnezrJdnSLdu1FFEeUhQGpT9y0VSdTiV8AABvFEbFUAXheQgPOVGG8R3KQQ1
         r09CE7mpqDLC7Gz9GaahcxbdTIV8qvcG9I0WXGXp0sPzwUOefEdCI11QIsCx3eqVgtK9
         nEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=12trcFRxDuHrpJDyiPsv28L/LnqZ2qb9yEz4s6vZWvE=;
        b=PN1ndoPxcqb+d8jBqYuSID2PgxTtFoOIHr1gIOX30QaQRnKGk1441LxZ2Lc+qzdCBb
         PjD93ednzuvtt+M2C5VDZkjDnSHapFGsVWDD1ZvyCYFKRArcPyOU0rQ3PU1XNtPZld5A
         EVXpwkFyba46lPkCyCyHsSQbPkdWPeeIiIdKsZISb0lBxRWig10AcNiW9bViOJ4BxDvv
         8x9/vSaIQa4vbqvg14ew5Xvhj800rDudiRfgyRGwIbUcKx9tatU86nDsaaMgPwIvtTX2
         8n9Po4KEx8hs6QSZqfb+RvQ8zO6R3FDqQvYsR8drGCyVhSwJnEOa3SLfIBFBbyis1+QN
         kK8w==
X-Gm-Message-State: ACgBeo1If2JUo/+lOuCGTsfw3jDZV76WXVSwP9P62ubVeoipMVEVtmNM
        LGq++BYPrvBuHjecyc49xulMoSNYCgZ0Y5Tr
X-Google-Smtp-Source: AA6agR75pBbU7S1QxEfB698K/586faQBXuHYenL56qfENNqtPSmnn7rmwZhzWJsOWdQC4NVKgEpSZQ==
X-Received: by 2002:a05:6638:300b:b0:341:d28e:871 with SMTP id r11-20020a056638300b00b00341d28e0871mr2266631jak.140.1660858912928;
        Thu, 18 Aug 2022 14:41:52 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com. [34.135.64.30])
        by smtp.gmail.com with ESMTPSA id bv10-20020a056638448a00b003428c21ed12sm996638jab.167.2022.08.18.14.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 14:41:52 -0700 (PDT)
Date:   Thu, 18 Aug 2022 21:41:48 +0000
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v2 3/3] KVM: selftests: Randomize page access order.
Message-ID: <Yv6yHCmtdJCOpZZM@google.com>
References: <20220817214146.3285106-1-coltonlewis@google.com>
 <20220817214146.3285106-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817214146.3285106-4-coltonlewis@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 09:41:46PM +0000, Colton Lewis wrote:
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 9226eeea79bc..af9754bda0a4 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>  	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
> +		case 'a':
> +			p.random_access = true;
> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;

Was double checking this and forgot to add an "a" to the getopt
string. This is small enough that I will wait for the rest to get more
eyes before rerolling the patch.
