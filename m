Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9035F7F00
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 22:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJGUlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 16:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJGUlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 16:41:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF2CAE84C
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 13:41:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q9so5614230pgq.8
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 13:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lnS7B+5I9Nqz0REvKfNYqOBTdIB5sEywNL6jx390bVw=;
        b=ooyt7vi6gCGclnhP/JdFqXwt5nx98GMBwyAsVabRImjkG8Mr/8A1Z6Mx9ausQutQb9
         d0t5KCtp1IXWXHwuQMNN4Gqvm3SOHc4r1QRjZghg1bx8jU5jLGNdzuYEYR42eklLz5YM
         du+QF2WSPBviQZ5Wdh763KyrWQEp5viHnX+rOH0tEJEc9LLRckC87CqesUrRDmqeKmIg
         pH5HSqazazWJCe2R1zFxMCuFRdqL86hbo4FV4t0dY8pGQPKZUKuMwmmaK3mMVyVQzzDu
         cd6Q6YHTujIiVs7iClZTapIMsv/GM/17jA0mKOVgU2Q+WKIxq4dDWJPSHhiFUbq8Vyuq
         SZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnS7B+5I9Nqz0REvKfNYqOBTdIB5sEywNL6jx390bVw=;
        b=Mf4aqADUg88iqn8Bhw/zSZ3+UycIRG7nTXEFPgW2z0dG+0Nmqy0k+buMV8VzPPIm0E
         bvPIugn9Qrx/EI8N3RoMtjl8NugLDLlLjPRJ9pF9VHCrL3Chok38uzqGRq8mYRddLiiH
         nI0YPtOyE2xuZJpQCDuLqTsW1kOZkEvg+yLws2uC4HD7/xfzULbAri3vGsPsIbS4HCMZ
         0mTQ2QCC3PYMOnXAPDkEfwvJTkLm3y7sfzyCg5wglOdCeaXO8o5d9Vk1X6jZHZX40SO2
         2TxnRd/tx/eWrQ5NNquDPWRvJ+t4BOZfXKd6E9uITYU/NiITMRjadv17DXC1yiq+LD3i
         39xg==
X-Gm-Message-State: ACrzQf13c2drRNE4Oi1FTaCdsfY4wc6Z8jlXGQ1vjdErF5YJtnZ7tWh5
        O2/PongeygRx/Q9lw9fN3cyeYA==
X-Google-Smtp-Source: AMsMyM7d8+92EG+vP9Aoiva1/8uoTvVcfsdq581oBAjP8C8T7bB1Wmhh0hl8r8iYURXUlKrgR2TfMQ==
X-Received: by 2002:a65:5bc6:0:b0:457:3ce8:4a1b with SMTP id o6-20020a655bc6000000b004573ce84a1bmr6121872pgr.202.1665175295808;
        Fri, 07 Oct 2022 13:41:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p14-20020aa79e8e000000b005625f08116esm2049076pfq.68.2022.10.07.13.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 13:41:35 -0700 (PDT)
Date:   Fri, 7 Oct 2022 20:41:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Subject: Re: [PATCH v6 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y0CO+5m8hJyok/oG@google.com>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195849.3989707-2-coltonlewis@google.com>
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
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 99e0dcdc923f..2dd286bcf46f 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +void guest_random(uint32_t *seed);

This is a weird and unintuitive API.  The in/out param exposes the gory details
of the pseudo-RNG to the caller, and makes it cumbersome to use, e.g. to create
a 64-bit number or to consume the result in a conditional.

It's also not inherently guest-specific, or even KVM specific.  We should consider
landing this in common selftests code so that others can use it and even expand on
it.  E.g. in a previous life, I worked with a tool that implemented all sorts of
random number magic that provided APIs to get random bools with 1->99 probabilty,
random numbers along Guassian curves, bounded numbers, etc.

We definitely don't need that level of fanciness right way, but it doesn't require
much effort to define the initial APIs such that they won't require modification
if/when fancier usage comes along.

E.g. to start:

---
.c:

/*
 * Random number generator that is usable in any context.  Not thread-safe.
 * This is the Park-Miller LCG using standard constants.
 */
struct ksft_pseudo_rng {
	uint32_t state;
}

void ksft_pseudo_rng_init(struct ksft_pseudo_rng *rng, uint64_t seed)
{
	rng->state = seed;	
}

static uint32_t ksft_pseudo_rng_random(struct ksft_pseudo_rng *rng)
{

	*rng->state = (uint64_t)*rng->state * 48271 % ((1u << 31) - 1);
	return *rng->state;
}

uint32_t random_u32(struct ksft_pseudo_rng *rng)
{
	return ksft_pseudo_rng_random(rng);
}

uint64_t random_u64(struct ksft_pseudo_rng *rng)
{
	return (uint64_t)random_u32(rng) << 32 | random_u32(rng);
}

.h

struct ksft_pseudo_rng;

void ksft_pseudo_rng_init(struct ksft_pseudo_rng *rng, uint64_t seed);
uint32_t random_u32(struct ksft_pseudo_rng *rng);
uint64_t random_u64(struct ksft_pseudo_rng *rng);
---

And then if/when want to add fancier stuff, say bounded 32-bit values, we can do
so without having to update existing users.
