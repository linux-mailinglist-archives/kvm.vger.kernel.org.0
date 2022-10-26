Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9EE60EAAC
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiJZVJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiJZVJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:09:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BC5F4F
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:09:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m6so16780742pfb.0
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o3Luk1f0sE+f0Ad+XSXmjNxpnQOGYvr3N5CPFb4/Fvs=;
        b=ITUzPTrioeXMsQJUsnNZz9WLk92F8DBuka0f71+J91IoaXHTBZwhZupi4clnGEg95T
         wRgA4N1u+lGJtyRhFDtkHa0NgZc2KALyrZL6HpouKyyZ6kgwQjmuVqueWHMKfZKVe3Bz
         GMp7RxHuDuD5vjpxdG+zHbzehKx5YFDtj5Mf+K8Q90Jb/W7OpwRNs6nhT4pCzr/osq1U
         Yq31lKdG5VRpfECHQwwohbTs+vorgQrx/4ge0VBZkzCcujP/gVMXXYbIv7Wtq5mg3HZS
         AoLdkbPlw28gDO4df4vJ15hQiEs5bsGeI8wCztMPT4GyQI5ARxLO8Sc2NncQ2lOLsX3K
         GILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o3Luk1f0sE+f0Ad+XSXmjNxpnQOGYvr3N5CPFb4/Fvs=;
        b=jYIfN4szxtRJVLX8XO482EYIcpe3w2GNB2ntXETfqcaE4ZvvIK7mO32Y9uytZXmQbQ
         VumhOQ9WjAdlQd52exdkxjviG/Zun9Ymou19sEE1P7tyBwR94dg0LYQKz+f56VRQdvTm
         nZybE2XmqGQ3nPLxDUzqDe/ZXaFJcx+p6e52I8RPV7CaUksGwT8KLUraQ7daP0ALxnVO
         zhuJn7FbtDIZntqoI8puveG2Kt/FClXt3o6ONndSi8ZtRQIQ0yP0ZQ8+6zAjSPZvgrG+
         6fE+a/dBxbyGXXl0fiFCNKt7LiVRMslgOcw7wYpKmrsx/ECD3EgumXs99W8sdXIYAYzl
         D8qQ==
X-Gm-Message-State: ACrzQf2kkNr7vKlNA388Jj1r2LBDstRH5od1zn70DY7iS/W6yQTDcZN4
        m/Aoc6RkOX/67p5LAWsrUU1QpnGkdf8Jdg==
X-Google-Smtp-Source: AMsMyM459I4qoo/Edy4Z7kD2q2cAnS5cEs57hO4JKVSXw/39teZ4EXVT4APvxvCEf6lMsTB4laSkYw==
X-Received: by 2002:a05:6a00:a05:b0:563:5d36:ccd4 with SMTP id p5-20020a056a000a0500b005635d36ccd4mr45597683pfh.25.1666818568952;
        Wed, 26 Oct 2022 14:09:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x28-20020aa79a5c000000b0053e4baecc14sm3408903pfj.108.2022.10.26.14.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:09:28 -0700 (PDT)
Date:   Wed, 26 Oct 2022 21:09:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v7 1/3] KVM: selftests: implement random number
 generation for guest code
Message-ID: <Y1miBTa4cID5yH3Z@google.com>
References: <20221019221321.3033920-1-coltonlewis@google.com>
 <20221019221321.3033920-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221019221321.3033920-2-coltonlewis@google.com>
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

On Wed, Oct 19, 2022, Colton Lewis wrote:
> Implement random number generation for guest code to randomize parts
> of the test, making it less predictable and a more accurate reflection
> of reality.
> 
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to 0. The random seed is set with
> perf_test_set_random_seed() and must be set before guest_code runs to
> apply.
> 
> The random number generator chosen is the Park-Miller Linear
> Congruential Generator, a fancy name for a basic and well-understood
> random number generator entirely sufficient for this purpose. Each
> vCPU calculates its own seed by adding its index to the seed provided.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>

This patch has changed a fair bit since David and Ricardo gave their reviews,
their Reviewed-by's should be dropped.  Alternatively, if a patch has is on the
fence so to speak, i.e. has changed a little bit but not thaaaaat much, you can
add something in the cover letter, e.g. "David/Ricardo, I kept your reviews, let
me know if that's not ok".  But in this case, I think the code has changed enough
that their reviews should be dropped.

> ---
>  .../testing/selftests/kvm/dirty_log_perf_test.c | 12 ++++++++++--
>  .../selftests/kvm/include/perf_test_util.h      |  2 ++
>  tools/testing/selftests/kvm/include/test_util.h |  7 +++++++
>  .../testing/selftests/kvm/lib/perf_test_util.c  |  7 +++++++
>  tools/testing/selftests/kvm/lib/test_util.c     | 17 +++++++++++++++++
>  5 files changed, 43 insertions(+), 2 deletions(-)

I think it makes sense to introduce "struct guest_random_state" separately from
the usage in perf_test_util and dirty_log_perf_test.  E.g. so that if we need to
revert the perf_test_util changes (extremely unlikely), we can do so without having
to wipe out the pRNG at the same time.  Or so that someone can pull in the pRNG to
their series without having to take a dependency on the other changes.

> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index befc754ce9b3..9e4f36a1a8b0 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -152,4 +152,11 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +struct guest_random_state {
> +	uint32_t seed;
> +};
> +
> +struct guest_random_state new_guest_random_state(uint32_t seed);
> +uint32_t guest_random_u32(struct guest_random_state *state);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..5f0eebb626b5 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -49,6 +49,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	uint64_t gva;
>  	uint64_t pages;
>  	int i;
> +	struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);

lib/perf_test_util.c: In function ‘perf_test_guest_code’:
lib/perf_test_util.c:52:35: error: unused variable ‘rand_state’ [-Werror=unused-variable]
   52 |         struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);
      |                                   ^~~~~~~~~~

This belongs in the next path.  I'd also prefer to split the declaration from the
initialization as this is an unnecessarily long line, e.g.

	struct perf_test_args *pta = &perf_test_args;
	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
	struct guest_random_state rand_state;
	uint64_t gva;
	uint64_t pages;
	uint64_t addr;
	uint64_t page;
	int i;

	rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);
