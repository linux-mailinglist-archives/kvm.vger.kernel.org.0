Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF9F591535
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 20:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbiHLSEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 14:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiHLSEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 14:04:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5D1B2869
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 11:04:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r69so1412098pgr.2
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 11:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ZEOidN8uNAw6cljxlEo4mr+whguB3vP3lH0je9rqjAE=;
        b=hCzoq6Usv8dM2F28yfNoAorEnwPgINB7IaKsBZO9opFfPYYaUSTg2XZs2EeEmOHVsF
         pk5U/1+17wEURzMZqoSyUBhYzacyw1WqbnH7l3+x6+CvaelA60yJo/QCa0LPwkPkpC6S
         zYwygNiKOJQiubTrBeKLANvRkRjo7z4LdZ47xZrMebkQ/O4EJEQ73oII+7XYLY25VeWJ
         t3uVpOw6cFreV6DQC9o62Hp2MV2Tf/W7K05OF4YX3XRo/8JUyovudn4CNNNnY38Du/v2
         gA3OxX+DTd+zKFJISsH/m+U8JLr6ft5FpqAPLu5QqKBY9OivlBarnLO+SZ/oBwtw/fA6
         E3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ZEOidN8uNAw6cljxlEo4mr+whguB3vP3lH0je9rqjAE=;
        b=PH+g4eWD9Pa8AWNShCqF9zqFAchyYTsm9xTgpFaVvpDfyuN1NY+XBXGQxDLvBH5raD
         u7xw96xqAjRd2o4HJqSVO3plXInUHujkxdGWG5scz5GM5Kg2kVw9QFpTDfqyQcjHlmmm
         8zwZK4aXZ0Fd1hSFHyIMjVwtnoQQc3ySJF0EcQ2AScEUJnefNInQlPhBtulfIIS0kV9+
         7Hd8GPJwmVjCkyc+PlLEwoMIwKNxUWK5YDN8+B2wkbRFRRdiqa4Ud/1vZhbo5F6GReAT
         bdwzC2RijBeRQzriCK9N+q+4xZzWPjCfyJg9tS5AXxGkAs5L6niG9H6ZdUuA0sVJrD1g
         HOxg==
X-Gm-Message-State: ACgBeo3n3KjyyYp7uLaLUeGgwCT9ecOAV1ryhs788TGH9LCHCz1C3atL
        8z4FvY8QySgvKQPNZexrp8q5KA==
X-Google-Smtp-Source: AA6agR6ERTS+PGB0KWeavKIu0qNzRTCOnolZNxKepc2JkSrO5YBtNUnRhcLTWQBg8yIuKlvHTwF5XQ==
X-Received: by 2002:a63:ba49:0:b0:41c:2713:3984 with SMTP id l9-20020a63ba49000000b0041c27133984mr3928586pgu.468.1660327472676;
        Fri, 12 Aug 2022 11:04:32 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id y198-20020a6264cf000000b0052d4ffac466sm1868617pfb.188.2022.08.12.11.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 11:04:31 -0700 (PDT)
Date:   Fri, 12 Aug 2022 11:04:25 -0700
From:   David Matlack <dmatlack@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: selftests: Use TEST_REQUIRE() in nx_huge_pages_test
Message-ID: <YvaWKUs+/gLPjOOT@google.com>
References: <20220812175301.3915004-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812175301.3915004-1-oliver.upton@linux.dev>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 05:53:01PM +0000, Oliver Upton wrote:
> Avoid boilerplate for checking test preconditions by using
> TEST_REQUIRE(). While at it, add a precondition for
> KVM_CAP_VM_DISABLE_NX_HUGE_PAGES to skip (instead of silently pass) on
> older kernels.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 24 +++++--------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index cc6421716400..e19933ea34ca 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -118,13 +118,6 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
>  	vm = vm_create(1);
>  
>  	if (disable_nx_huge_pages) {
> -		/*
> -		 * Cannot run the test without NX huge pages if the kernel
> -		 * does not support it.
> -		 */
> -		if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
> -			return;
> -
>  		r = __vm_disable_nx_huge_pages(vm);
>  		if (reboot_permissions) {
>  			TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
> @@ -248,18 +241,13 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> -	if (token != MAGIC_TOKEN) {
> -		print_skip("This test must be run with the magic token %d.\n"
> -			   "This is done by nx_huge_pages_test.sh, which\n"
> -			   "also handles environment setup for the test.",
> -			   MAGIC_TOKEN);
> -		exit(KSFT_SKIP);
> -	}
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));

This cap is only needed for run_test(..., true, ...) below so I don't think we should require it for the entire test.

That being said, it still might be good to inform the user that the test is being skipped. So perhaps something like this:

  ...
  run_test(reclaim_period_ms, false, reboot_permissions);

  if (kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
          run_test(reclaim_period_ms, true, reboot_permissions);
  else
          print_skip("KVM_CAP_VM_DISABLE_NX_HUGE_PAGES not supported");
  ...

> +	TEST_REQUIRE(reclaim_period_ms > 0);
>  
> -	if (!reclaim_period_ms) {
> -		print_skip("The NX reclaim period must be specified and non-zero");
> -		exit(KSFT_SKIP);
> -	}
> +	__TEST_REQUIRE(token == MAGIC_TOKEN,
> +		       "This test must be run with the magic token %d.\n"
> +		       "This is done by nx_huge_pages_test.sh, which\n"
> +		       "also handles environment setup for the test.");
>  
>  	run_test(reclaim_period_ms, false, reboot_permissions);
>  	run_test(reclaim_period_ms, true, reboot_permissions);
> 
> base-commit: 93472b79715378a2386598d6632c654a2223267b
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
