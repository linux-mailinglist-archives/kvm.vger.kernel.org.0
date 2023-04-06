Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02CE6D8DD0
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 05:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbjDFDCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 23:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjDFDCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 23:02:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7165BA9
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 20:02:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c2-20020a170903234200b001a0aecba4e1so22110064plh.16
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 20:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680750150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qyj+UBSn+qJbXYis+Uut8ABKQ6jjNoJJtNcP+yAVe0I=;
        b=VYHPND+7vhU1REET2977g166RgzUsIabTCQR5nO0ldkN3EmSZ3oQIylhq1gjk1hL2C
         lnVHt4Vfrf24Pgr3te4SWu6xJQdTq0kLgQ1ybQMeh89hnAUaM6c0RYhLJo2zNeKwu2iK
         WzMXn3JIBYQzIBP7ECvWV//wrhViF0bXx3xaBfWVMERkUr01iFjJ+B/6azFM7U9Q7pU9
         cApdBt+hgsuq4r+7ARG0j/qsE6jKKc2SVMDQrJf1Qrxyt/BzTqY6GVCBZwrrnLzzSeo4
         Ssf6iITiUSdU6aGQYO6KMxfZYGi6xQP0JnZS7bKPIm3FTpQAv+sReRTb9m7rhuO/yW1x
         1whg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680750150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qyj+UBSn+qJbXYis+Uut8ABKQ6jjNoJJtNcP+yAVe0I=;
        b=U74OD9C/8RpVklO8YvIURW7/OHaaIh7v9PHY1xuFcNSDSsdO/UVvJhAYfFfUi1BSMj
         fShdVD2n6yXlxmcn1qyDZ5vjLJ40JH6M62VoPz7PxCMuE1lH3MjlZh4VLp8QebV+4zt1
         bKJHzeCKlCl+a7l6AuYuRxiudieKQJ5J2W7zHsdiqS2/dcCCWWHh4a0OE7tUB/Bf0cTK
         ixJVmKqcqVKc3FX42oZyIH6W2mi5bvx/dtap4u2DQV1GSEhpu3qG3uwswKqR4eLRIwhu
         49HcC4ntS5mxNX1mmKwGAe8DhJE2nXc2q60R9M5IbJJdHRcWggJaXO/HrcngTVQ2dw9/
         tzNA==
X-Gm-Message-State: AAQBX9fQpi1wU+EAVPL31ggIG2AyrD+e4xZYKpL7ocq3yv5CofW1Zt+/
        jlmU6xXAEgC3caCW/QqhAGlxQPyidEw=
X-Google-Smtp-Source: AKy350Zh1qglJn4qtXvSoMtt2oBvfqPfZmhPHg8bUjnCDxMGMzTcoO4o3RVeYkaWPhm3MqELgQssfbLS678=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4383:b0:23b:419d:8efe with SMTP id
 r3-20020a17090a438300b0023b419d8efemr3179503pjg.3.1680750150729; Wed, 05 Apr
 2023 20:02:30 -0700 (PDT)
Date:   Wed, 5 Apr 2023 20:02:29 -0700
In-Reply-To: <20230215142344.20200-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230215142344.20200-1-minipli@grsecurity.net>
Message-ID: <ZC42RavGH2Z82oJd@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test non-canonical memory
 access exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
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

On Wed, Feb 15, 2023, Mathias Krause wrote:
> +static void test_reg_noncanonical(void)
> +{
> +	extern char nc_rsp_start, nc_rsp_end, nc_rbp_start, nc_rbp_end;
> +	extern char nc_rax_start, nc_rax_end;
> +	handler old_ss, old_gp;
> +
> +	old_ss = handle_exception(SS_VECTOR, advance_rip_and_note_exception);
> +	old_gp = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
> +
> +	/* RAX based, should #GP(0) */
> +	exceptions = 0;
> +	rip_advance = &nc_rax_end - &nc_rax_start;
> +	asm volatile("nc_rax_start: orq $0, (%[msb]); nc_rax_end:\n\t"

Can't we use ASM_TRY() + exception_vector() + exception_error_code()?  Installing
a dedicated handler is (slowly) being phased out.  Even better, if you're willing
to take a dependency and/or wait a few weeks for my series to land[*], you should
be able to use asm_safe() to streamline this even further.

[*] https://lkml.kernel.org/r/20230406025117.738014-1-seanjc%40google.com


> +		     : : [msb]"a"(1ul << 63));

Use BIT_ULL().  Actually, scratch that, we have a NONCANONICAL macro.  It _probably_
won't matter, but who know what will happen with things like LAM and LASS.

And why hardcode use of RAX?  Won't any "r" constraint work?

E.g. I believe this can be something like:

	asm_safe_report_ex(GP_VECTOR, "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
	report(!exception_error_code());

Or we could even add asm_safe_report_ex_ec(), e.g.

	asm_safe_report_ex_ec(GP_VECTOR, 0,
			      "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
