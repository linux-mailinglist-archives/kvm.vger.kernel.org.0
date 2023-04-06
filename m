Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F876D8B84
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 02:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbjDFANL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 20:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjDFANJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 20:13:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EA21FD2
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 17:13:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e186-20020a2537c3000000b00b72501acf50so37569097yba.20
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 17:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680739984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oIVv17QpIfjpv7NHijjNGS+xbKdk8/meE9TVNffXN1Y=;
        b=PRY0RJTTBJ67UCBYkIEfsKRFyOT1gcdKU7mv/OeUzw1r1nHClV6TBceqcc2vjff2tA
         aPBnlafF5cZNOFZk7kkdgzedBzJszoOmZ6449L11iLZyzQBJwlpKdC0qaOZBJyWu8z4M
         P0QAQTHfWIZF22LNU5dHMgudihMSjpdbQg3y2CTSzwBJJolDcfkY5TLf8sy8EzVb1R/l
         mC3myJMNfjzT0D9U3rl0dzlL4Yb+k5D0GFie433PGG9ovD4mM2lE01EC7KeVSPHh3N39
         58OrvOuOSTMsNWJGHY1yw7ar6BNckD+7YknVNuukTyYjrkODZjRDw55OF4eEDiSVle11
         WAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIVv17QpIfjpv7NHijjNGS+xbKdk8/meE9TVNffXN1Y=;
        b=BmY1GWsF3BnfbRf6WeVNXlVHiMLZEDMRKqNltsuQP3/FOp8p4HsQJN0K7zgrO5waGV
         VKglgDBUp0GLKwXk27TLoXbitcBpJQjCgdhI44bfDtBMs16Ds5qHvClJlzvkjDbcMrdQ
         lK5kI6hnMy1S5uCT1Uur4N4fj1EHbz3a8IE4hqIVDmIPc+7R1GrQTEDVWKr45bkV0r8/
         6JiWZWNUrD3siRsMRLy++lXGZRPZlX2mFVnbz1YzUSi0p/ZhWAPQCzbgCWy2yxHA+gs2
         3/HWfXJZ+rmfroDddw/b18qBkPcN8hzZUA3odOZwI+9hRwVLlNKKqnoLxRUF10fReU5X
         Qn2Q==
X-Gm-Message-State: AAQBX9cRqd3bqcBf3HxNyCcK5ALGI3Np3Uc6UPNqFv1zS6IjxoVyeZEK
        G8IDOVrw+Z+zfaeXUylyvn7GHB20ES8=
X-Google-Smtp-Source: AKy350bU395ykLooX4kh7nExUdXZhZMKGyWg+oKLdJndjcqqAmwjNJzfNYUADWizH4EUPPTWLDpdaY+aKrM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:df57:0:b0:b68:7b14:186b with SMTP id
 w84-20020a25df57000000b00b687b14186bmr751713ybg.1.1680739984384; Wed, 05 Apr
 2023 17:13:04 -0700 (PDT)
Date:   Wed, 5 Apr 2023 17:13:02 -0700
In-Reply-To: <20230405101350.259000-1-gehao@kylinos.cn>
Mime-Version: 1.0
References: <20230405101350.259000-1-gehao@kylinos.cn>
Message-ID: <ZC4OjuhPDlehRksi@google.com>
Subject: Re: [RESEND PATCH] kvm/selftests: Close opened file descriptor in stable_tsc_check_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Ge <gehao@kylinos.cn>
Cc:     pbonzini@redhat.com, shuah@kernel.org, dmatlack@google.com,
        coltonlewis@google.com, vipinsh@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        gehao618@163.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Hao Ge wrote:
> Close the "current_clocksource" file descriptor before
> returning or exiting from stable_tsc_check_supported()
> in vmx_nested_tsc_scaling_test
> 
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
>  .../selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c    | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> index d427eb146bc5..fa03c8d1ce4e 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
> @@ -126,12 +126,16 @@ static void stable_tsc_check_supported(void)
>  		goto skip_test;
>  
>  	if (fgets(buf, sizeof(buf), fp) == NULL)
> -		goto skip_test;
> +		goto close_fp;
>  
>  	if (strncmp(buf, "tsc", sizeof(buf)))
> -		goto skip_test;
> +		goto close_fp;
>  
> +	fclose(fp);
>  	return;
> +
> +close_fp:
> +	fclose(fp);
>  skip_test:
>  	print_skip("Kernel does not use TSC clocksource - assuming that host TSC is not stable");
>  	exit(KSFT_SKIP);

Actually, this can be streamlined by having the helper return a bool and punting
the skip logic to TEST_REQUIRE.  I'll still apply this patch first, but I'll post
a patch on top to yield:

static bool system_has_stable_tsc(void)
{
	bool tsc_is_stable;
	FILE *fp;
	char buf[4];

	fp = fopen("/sys/devices/system/clocksource/clocksource0/current_clocksource", "r");
	if (fp == NULL)
		return false;

	tsc_is_stable = fgets(buf, sizeof(buf), fp) &&
			!strncmp(buf, "tsc", sizeof(buf));

	fclose(fp);
	return tsc_is_stable;
}
