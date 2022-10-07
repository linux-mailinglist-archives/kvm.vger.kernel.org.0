Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B355F7F7B
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 23:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJGVJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJGVJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 17:09:53 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0642B1FCDE
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 14:09:50 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q9so5666026pgq.8
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W3sI1hYHI9mcWHNfC1WlecDK11RvAjlbSmMyVDeq0UQ=;
        b=Z4DK/fcphuDBF+c0XkgcD/1BXjnyCcnEVHox11j8IccglcEhzq1pDGlLGgVJlRqTo2
         Kgrovlm9VNCsVkJEOAnh3TxvVhWLsObobn3X9naQvzuitsTQaORvduQmiqDDKsYHjst5
         iqmKAMnAGlsevjHyAkk735hfjrA/9sZ+uy/a96nOzW4Vpt05/YI0dZQAR1HQwNtMDtED
         0rgqdOHdJGkCcpAkGKbZwTXgS+6tJEwPGev//fNbyncLJNVtrpLLMYiJ1gzWA0m31ilQ
         Z4qLaX9tFm0nbVwhbVovibZyWsX9BiRVkvPMxkrgi5YXQ2wmrsaBb7bsTBYd2XuhYGNC
         3B/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3sI1hYHI9mcWHNfC1WlecDK11RvAjlbSmMyVDeq0UQ=;
        b=Vb6jZ55DBVrl1fixwqLaByWNy1jN3MYvP8AQk97/XJkumu9Aif+3AKKQkd1isI0xl2
         +N9rFqwiWrPqwP2rAdvl7EhsNBLuPS3b0lQWK+wRD28MCzLI3vVxIDayDSksavp/bn1r
         8yyw4AeLRI53TYOx9xcGLl4jRE7z0Bs6+ElOBYeQVyGIEH7vnlQhce1MbeN9wnZ2u10t
         yIR9sfQ+eyH1reeJfsOQIhk6LqxvOtQSAeN4A5xNKHPs1z1DEJD+NSdc7kkiGuSTZBL7
         jZWS1lGb8OCqG7n4Lu1liyez6fQh48LAkKO7GwmHypfJGd5kKQ1N2aj0I33RJEwH8R5E
         a6lA==
X-Gm-Message-State: ACrzQf3S0FiYXujGOX30ICTUKdK2fg9n8mIS9myGU0NRZ8YNkWLKfk6a
        S1noOPdSIZMcm/ca6XSzWxFKHw==
X-Google-Smtp-Source: AMsMyM6uwb5CEHlO0vCxfnFaXX4JZsU+3ECCLHQEBvgdJ8+qaQ2NQtly5dadxtjlkz3XPCzUnsJHxQ==
X-Received: by 2002:a63:581d:0:b0:42b:399:f15a with SMTP id m29-20020a63581d000000b0042b0399f15amr6166377pgb.337.1665176989202;
        Fri, 07 Oct 2022 14:09:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y198-20020a62cecf000000b005627868e27esm2022405pfg.127.2022.10.07.14.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 14:09:48 -0700 (PDT)
Date:   Fri, 7 Oct 2022 21:09:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 3/3] KVM: selftests: randomize page access order
Message-ID: <Y0CVmS9rydRbdFkN@google.com>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195849.3989707-4-coltonlewis@google.com>
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

On Mon, Sep 12, 2022, Colton Lewis wrote:
> @@ -57,7 +58,17 @@ void perf_test_guest_code(uint32_t vcpu_id)
>  
>  	while (true) {
>  		for (i = 0; i < pages; i++) {
> -			uint64_t addr = gva + (i * pta->guest_page_size);
> +			guest_random(&rand);
> +
> +			if (pta->random_access)
> +				addr = gva + ((rand % pages) * pta->guest_page_size);

Shouldn't this use a 64-bit random number since "pages" is a 64-bit value?  Ha!
And another case where the RNG APIs can help, e.g.

  uint64_t __random_u64(struct ksft_pseudo_rng *rng, uint64_t max);

or maybe avoid naming pain and go straight to:


  uint64_t __random_u64(struct ksft_pseudo_rng *rng, uint64_t min, uint64_t max);

> +			else
> +				addr = gva + (i * pta->guest_page_size);

Since the calculation is the same, only the page index changes, I think it makes
sense to write this as:

			uint64_t idx = i;

			if (pta->random_access)
				idx = __random_u64(rng, 0, pages);

			addr = gva + (idx * pta->guest_page_size);

That way it's easy to introduce other access patterns.

> +
> +			/*
> +			 * Use a new random number here so read/write
> +			 * is not tied to the address used.
> +			 */
>  			guest_random(&rand);

Ya, I'm trippling (quadrupling?) down on my suggestion to improve the APIs.  Users
should not be able to screw up like this, i.e. shouldn't need comments to warn
readers, and adding another call to get a random number shouldn't affect unrelated
code.
