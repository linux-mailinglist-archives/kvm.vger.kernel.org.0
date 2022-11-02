Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044346172E7
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiKBXkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKBXkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:40:12 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9827012088
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:35:22 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q71so185425pgq.8
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MGonWWHLJx7s3mf3ha4qeMLjkPi6ZLS+gTWV5IcwZTc=;
        b=brsWkHi8ScmS/se+3yISYO0McpBvnBAidGpoJUq0jyZHm7gAvg9BUuqh2v6/UgFSe0
         cNou2/VXJcI7OEfndfxsRuRYvTudxdHwYOVF2jGIgT2IVVkf4sNXwruD/dtqzmu+q1cm
         6sRxH0+uOFFhic/0gjF4lo+YU1Tz4I3h8gRr8Q55xba22MZE4rMZDj18QWJNuAdqx7Zf
         xKQAOzzt2QOVqFGRDCENRUQhrVHPo8bzDSJvTJS6idQLr7QJ6bbboBeihch5i79c3e3M
         l86STmNXVZKENjJVR4G/MIFNyKVwRVdgFUvv+DW2iiq7rVzlOC8A1jRZVv1wLzYwdfA1
         VMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGonWWHLJx7s3mf3ha4qeMLjkPi6ZLS+gTWV5IcwZTc=;
        b=d6wrIfyHX9qZue6JB9T8GwfZ0a1Ak1pjaWmFPS3nITeIkOxMIQ1znP4GOpw8Wp9gII
         Fiv1EJsBJ0z61arFfokbhQAKlgieboepgiiNKOyvcmDksi8vD3ZtluQvBcCgSTHMdgp+
         gQob5dULdzQv5zgbRZlKkNIDPJHzJNXuJGpDVtcqWFWPU6XAAQkIcATT5dBK8wloA0ND
         JoBfbtZ8blu1OLG77Lao/+h0//7OcZLPzpSP0ziuxbBnQ7zBbqTK2Ezgczz3MNtLx4lT
         XOsa+yohRQwQyP62RXCRSCOdzAp16BjTun4D6xuz4+i/KrLq9ReWZDFcfjuVX6cBnp2n
         Tnnw==
X-Gm-Message-State: ACrzQf1OEq/nNrNLMz7TNWMBzWbIDbmikSaSiGDzYUBC9knQ0BU72Ujr
        0DHQiDsSBYiHNHo7YvBqIBzu0lhIJhfNxQ==
X-Google-Smtp-Source: AMsMyM5eSd4yspVbZG5F/TBx7x1xR882JYrlqlJwmgY7J6G+zYut03vS21V2Ol2humX/kfsB/FPD6A==
X-Received: by 2002:a63:1110:0:b0:46f:b040:f5a with SMTP id g16-20020a631110000000b0046fb0400f5amr17316672pgl.84.1667432122073;
        Wed, 02 Nov 2022 16:35:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k17-20020a63f011000000b0046ec0ef4a7esm8145206pgh.78.2022.11.02.16.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 16:35:21 -0700 (PDT)
Date:   Wed, 2 Nov 2022 23:35:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v9 2/4] KVM: selftests: create -r argument to specify
 random seed
Message-ID: <Y2L+tt1uwb4qrPvu@google.com>
References: <20221102160007.1279193-1-coltonlewis@google.com>
 <20221102160007.1279193-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102160007.1279193-3-coltonlewis@google.com>
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

On Wed, Nov 02, 2022, Colton Lewis wrote:
> Create a -r argument to specify a random seed. If no argument is
> provided, the seed defaults to 1. The random seed is set with
> perf_test_set_random_seed() and must be set before guest_code runs to
> apply.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..0bb0659b9a0d 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -229,6 +229,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
>  	sync_global_to_guest(vm, perf_test_args);
>  }
>  
> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> +{
> +	perf_test_args.random_seed = random_seed;
> +	sync_global_to_guest(vm, perf_test_args.random_seed);

After Vishal's series[*] to add a kvm_selftest_init() and kvm_arch_vm_post_create()
lands, we should look into moving the pRNG support to kvm_vm and kvm_vcpu.  E.g.
parse the base kvm_selftest_init(), copy it to each VM during kvm_arch_vm_post_create(),
and then init the per-vCPU pRNG when a vCPU is createrd.

The common parsing will probably require mucking with args[], or maybe using an
environment variable, but it'd be nice for the pRNG to be automagically available
to guest code.

[*] https://lore.kernel.org/all/20221013121319.994170-3-vannapurve@google.com
