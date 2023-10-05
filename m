Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C757F7BA528
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbjJEQOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbjJEQNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:13:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7836EA9
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 23:41:41 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40537481094so5408935e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 23:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696488100; x=1697092900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vdqveFoqTC4kTMjULrJM/pFuxAH0pZ83O2NiJo6o6s=;
        b=u36YCd/sGIJoSFSh+280Jj7t+31EiOJylJmuP9BM2OQURFLvRGDj8inwgmZzHidOYk
         iBo2/l/eki3uSq2O3HeOVE1/frG9LB+i3Gq6pc8CfNg87AVASXn9XK1OT2znqVtI3mgK
         WTQ8fG1u0AOY6Zh9f1yhhj9o8cK/QEwWP+l2+mOOyJ1dgJWcXmXp/eDfbIJWpz+LxIo8
         H2R0kBFS2SOUEuvvnfU2DWPM4JmuM2LAbWaW2YaZ9ZOK0MPqgJZuH0CBVg9+6Y548gaj
         Pwq0RgtpmMNVq8GtCLrD/Rq/EDunT+Xms9FWSfpt6TM8nH7Jwk6/apaf0PehJyuxZXfg
         o7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696488100; x=1697092900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+vdqveFoqTC4kTMjULrJM/pFuxAH0pZ83O2NiJo6o6s=;
        b=bvlKM7YckUiI7c35kYczELcwQgz+88ZT9Lc/RkytyP+4fFi/B/rY6inAoVXe6Ry2su
         9IDx+Azbm1qYmA12bbxSMWqgkhVPUNwNnEzHZ7OgWIhBWISzegez7XEeq7PrWzPHn4YK
         nbVr+3Du2Yk3n135tb4m4jGR/HauwkzUihqRLTOCQjFp/Y20qd1cahhW+MoJWHOtvh6M
         s0vlpfAVbUuWtTPBMUtYlOedBenk3c2HzK1dv7f9ufrfAgTVgHNoBsQ1TT3lfvqGpZ7d
         W5gkVYTxmSZ6B/ZpjuFrN+8if3RVLFaodd9+sRK5wOJxh5BDNT6Uro3c/5kxSHO2VIeF
         MpqQ==
X-Gm-Message-State: AOJu0YyMBTOX+KmdXJwfZ58hxMRsUy7gSmoxPSw3jl8zCzgTgctLGINp
        NxbhmqJoXGeiuQnenOlBP2p0Tw==
X-Google-Smtp-Source: AGHT+IHNUBZ6VZpnWD/fhUNGLtXjR6FAs+pOJe4wa66hFEyLksfC+l3y866skRAcnPsjdJ4dQW60QQ==
X-Received: by 2002:a7b:c851:0:b0:405:3252:fe2 with SMTP id c17-20020a7bc851000000b0040532520fe2mr4050578wml.14.1696488100310;
        Wed, 04 Oct 2023 23:41:40 -0700 (PDT)
Received: from [192.168.69.115] (tbo33-h01-176-171-211-120.dsl.sta.abo.bbox.fr. [176.171.211.120])
        by smtp.gmail.com with ESMTPSA id w21-20020a05600c015500b0040652e8ca13sm3011556wmm.43.2023.10.04.23.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 23:41:39 -0700 (PDT)
Message-ID: <631a4966-982b-8d7c-1ad5-e9358f98fcf4@linaro.org>
Date:   Thu, 5 Oct 2023 08:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: selftests: Zero-initialize entire test_result in
 memslot perf test
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
References: <20231005002954.2887098-1-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231005002954.2887098-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/23 02:29, Sean Christopherson wrote:
> Zero-initialize the entire test_result structure used by memslot_perf_test
> instead of zeroing only the fields used to guard the pr_info() calls.
> 
> gcc 13.2.0 is a bit overzealous and incorrectly thinks that rbestslottim's
> slot_runtime may be used uninitialized.
> 
>    In file included from memslot_perf_test.c:25:
>    memslot_perf_test.c: In function ‘main’:
>    include/test_util.h:31:22: error: ‘rbestslottime.slot_runtime.tv_nsec’ may be used uninitialized [-Werror=maybe-uninitialized]
>       31 | #define pr_info(...) printf(__VA_ARGS__)
>          |                      ^~~~~~~~~~~~~~~~~~~
>    memslot_perf_test.c:1127:17: note: in expansion of macro ‘pr_info’
>     1127 |                 pr_info("Best slot setup time for the whole test area was %ld.%.9lds\n",
>          |                 ^~~~~~~
>    memslot_perf_test.c:1092:28: note: ‘rbestslottime.slot_runtime.tv_nsec’ was declared here
>     1092 |         struct test_result rbestslottime;
>          |                            ^~~~~~~~~~~~~
>    include/test_util.h:31:22: error: ‘rbestslottime.slot_runtime.tv_sec’ may be used uninitialized [-Werror=maybe-uninitialized]
>       31 | #define pr_info(...) printf(__VA_ARGS__)
>          |                      ^~~~~~~~~~~~~~~~~~~
>    memslot_perf_test.c:1127:17: note: in expansion of macro ‘pr_info’
>     1127 |                 pr_info("Best slot setup time for the whole test area was %ld.%.9lds\n",
>          |                 ^~~~~~~
>    memslot_perf_test.c:1092:28: note: ‘rbestslottime.slot_runtime.tv_sec’ was declared here
>     1092 |         struct test_result rbestslottime;
>          |                            ^~~~~~~~~~~~~
> 
> That can't actually happen, at least not without the "result" structure in
> test_loop() also being used uninitialized, which gcc doesn't complain
> about, as writes to rbestslottime are all-or-nothing, i.e. slottimens can't
> be non-zero without slot_runtime being written.
> 
> 	if (!data->mem_size &&
> 	    (!rbestslottime->slottimens ||
> 	     result.slottimens < rbestslottime->slottimens))
> 		*rbestslottime = result;
> 
> Zero-initialize the structures to make gcc happy even though this is
> likely a compiler bug.  The cost to do so is negligible, both in terms of
> code and runtime overhead.  The only downside is that the compiler won't
> warn about legitimate usage of "uninitialized" data, e.g. the test could
> end up consuming zeros instead of useful data.  However, given that the
> test is quite mature and unlikely to see substantial changes, the odds of
> introducing such bugs are relatively low, whereas being able to compile
> KVM selftests with -Werror detects issues on a regular basis.
> 
> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> I don't like papering over compiler bugs, but this is causing me quite a bit of
> pain, and IMO the long-term downsides are quite minimal.  And I already spent
> way too much time trying to figure out if there is some bizarre edge case that
> gcc is detecting :-/
> 
>   tools/testing/selftests/kvm/memslot_perf_test.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

