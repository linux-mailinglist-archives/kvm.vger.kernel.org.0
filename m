Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B8D4CAF1B
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbiCBT4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiCBT4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:56:15 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF095D763A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:55:31 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id r8so3217111ioj.9
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t48F+updsV7T2pr/t57RE2xz11TJHa9Jd7tNCDUAq/8=;
        b=TYAxFlG/fB4zbMIlTaqNBs1Z0P4LQ18nao+fVPmsTJPImo3mo3fWLx+eQ2JVc3lRWp
         Tb4h+Ndoj+4HFpacdhGJtTp0wLbxe8NipiZ7IZmOr2FRL4hAw6vxRnDeNWYmmuKaiC4B
         fsGU7gso+iwqoPr0ZAis8DW/PL60NyvTEksLGDB21VE3Mdy9WvPioubovzUAvoKRlNf/
         WJQGgyJHWxgYWhrLyfT4xOZ5TnwkwgSzWj5oW1G0BCX0Mf6L57Qmsx+tqC0ylp6APHgH
         a5QAzRIDAfqQfZbeRJonXbI9pJHAQqO4i4kSM3HAlZBnylq5JD0bk5vZMwcaf82o0EPi
         E2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t48F+updsV7T2pr/t57RE2xz11TJHa9Jd7tNCDUAq/8=;
        b=HjiUfo+gmHBxS9IJaQUrHQYkCLKpT67wHQy6d8k5STOYKz0NajpnV2xO1YSKEL3XYu
         kx+6vms1QiR0pWwgegZDY0R2ahraqu/mHG8uxrNwU54KDMm0H3mGUR1S7ESf7uOCRk1X
         t32IE/NluEUf7cS+PSmNP9brIN7Nhi31SmAnCSQY7yXIc4DDhMp1gvSf8iPipRGUrcQb
         blcjzn21VkEl12fA7wmoXeTQJZlXYNbp32BVhc/EF+zNGT0iUpdyqjIb/PjHjLdQBpQu
         2AnqGbyf+GIpUE2t6XgFC9dkv97WXyGD+EcCO/nDQluBdd+Y5xnWbkPM0jwPqCMpOh1e
         zITQ==
X-Gm-Message-State: AOAM533ggmqvdSkS82oI521ucCEaMTG5FRqhouDYSYCqBRuH3Mf9cJbu
        eClZlATZUKOr83bthpqwfYGIkQ==
X-Google-Smtp-Source: ABdhPJx7CPtEkHkG+44IZ4Lz4AGVrSAfzwK12Oo2APntBBtYATw0leJMlE93nhI9PHg/1e3LWJhz8w==
X-Received: by 2002:a02:69cc:0:b0:314:3518:780b with SMTP id e195-20020a0269cc000000b003143518780bmr26021611jac.133.1646250930988;
        Wed, 02 Mar 2022 11:55:30 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id r3-20020a92ac03000000b002c3dfcb9a6csm3664750ilh.77.2022.03.02.11.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:55:30 -0800 (PST)
Date:   Wed, 2 Mar 2022 19:55:26 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com
Subject: Re: [PATCH 1/3] KVM: arm64: selftests: add timer_get_tval() lib
 function
Message-ID: <Yh/LrphX9no9FRzR@google.com>
References: <20220302172144.2734258-1-ricarkol@google.com>
 <20220302172144.2734258-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302172144.2734258-2-ricarkol@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 09:21:42AM -0800, Ricardo Koller wrote:
> Add timer_get_tval() into the arch timer library functions in
> selftests/kvm. Bonus: change the set_tval function to get an int32_t
> (tval is signed).
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> index cb7c03de3a21..93f35a4fc1aa 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> @@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
>  	return 0;
>  }
>  
> -static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
> +static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
>  {
>  	switch (timer) {
>  	case VIRTUAL:
> @@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
>  	isb();
>  }
>  
> +static inline int32_t timer_get_tval(enum arch_timer timer)
> +{
> +	isb();
> +	switch (timer) {
> +	case VIRTUAL:
> +		return (int32_t)read_sysreg(cntv_tval_el0);
> +	case PHYSICAL:
> +		return (int32_t)read_sysreg(cntp_tval_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
>  static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
>  {
>  	switch (timer) {
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
