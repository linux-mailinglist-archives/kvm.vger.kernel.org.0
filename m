Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B152D6CC5
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 01:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgLKAvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 19:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394684AbgLKAu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 19:50:57 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA275C0613CF
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 16:50:16 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id r4so3723982pls.11
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 16:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rXA7fTXet0wVaoiJTbTmZFj5ug6YoWhUS6dbyqtvztI=;
        b=D9pWR6D1ogylm4rKXIQX/Rd/OrjXggO20MZaIruIALcJSKmGkqxZpIGrFzumgneVGl
         QRV2dJXTSkFYAyvQJb1iHfRdMowA8sEcWusF39SISX5zO4exafOEU200u4xwLv7/L8GK
         fVVITZaIb7XcSeJiHsK6hdjLvvPk4fC6whPQKCjFFBe6MlLavVTlAIMADqMF1hnSBIvN
         ogT0vTyZBw8aZdsRX50d4P5XMMP9OuTtKex5J1LNnvYFA2ht6tuHKGZ5PoZW8FPpUCm7
         UFQaSOq+wpL8YHJn20k/DGyz9pZOKwr6g8P0lOxowE1twnOhOUYm9StZ7MiZ/4zIO/9u
         RRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rXA7fTXet0wVaoiJTbTmZFj5ug6YoWhUS6dbyqtvztI=;
        b=TLKgQnyJwy56rMvGdCw126RiG1l5tKiXLd+Zx3fabbHiBVSXQeLRGq9pmaAbmpFRW2
         2cgS2ioxkIZF4lFDzUP9kh+z73Ob2NoeiKk54gppHCeu0FqGIUg2HjD4hfMZ14P0XjJB
         UGnXA3rkXYlC+6mZ/YBttcov8PJwYUuwhjR0iF5ajHPXpjjoaNZiNz/fMtnDljfDurk1
         FcO9L5n17pORdoat2UJD2qG7XVPHBztXqJI89hC5GKQrpvBhL429EB6ye+dCaQgXY2Ds
         UKcC2zcFbnpZmobceZWOvyG9agdkjC2mGnQ96MMMgyoHh5FhSq4qja9DFlTDUiSVHkdG
         XlaQ==
X-Gm-Message-State: AOAM530P2DleX1nBUsuA+0YnPHhJbHtsfe44xsuslAqbzKaEHPJiXA9M
        219Nbx8kIyP4rwMmzHoRvPwmNA==
X-Google-Smtp-Source: ABdhPJwc2W7jmCZe93n/EadQMtdlm47rbkdqwMHDC0+yoa1+AWzeglr5QI67lPS5RXgi7nC6xpDotQ==
X-Received: by 2002:a17:902:c40c:b029:da:74c9:df4f with SMTP id k12-20020a170902c40cb02900da74c9df4fmr8553686plk.68.1607647816274;
        Thu, 10 Dec 2020 16:50:16 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a21sm7678444pjq.37.2020.12.10.16.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 16:50:15 -0800 (PST)
Date:   Thu, 10 Dec 2020 16:50:09 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shuah Khan <shuah@kernel.org>, Jian Cai <caij2003@gmail.com>
Subject: Re: [PATCH] selftests: kvm: remove reassignment of non-absolute
 variables
Message-ID: <X9LCQYB2yqMaUqkj@google.com>
References: <20201210043611.3156624-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210043611.3156624-1-morbo@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 09, 2020, Bill Wendling wrote:
> Clang's integrated assembler does not allow symbols with non-absolute
> values to be reassigned. Modify the interrupt entry loop macro to be
> compatible with IAS by using a label and an offset.
> 
> Cc: Jian Cai <caij2003@gmail.com>
> Signed-off-by: Bill Wendling <morbo@google.com>
> References: https://lore.kernel.org/lkml/20200714233024.1789985-1-caij2003@gmail.com/
> ---
>  tools/testing/selftests/kvm/lib/x86_64/handlers.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/handlers.S b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
> index aaf7bc7d2ce1..3f9181e9a0a7 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/handlers.S
> +++ b/tools/testing/selftests/kvm/lib/x86_64/handlers.S
> @@ -54,9 +54,9 @@ idt_handlers:
>  	.align 8
>  
>  	/* Fetch current address and append it to idt_handlers. */
> -	current_handler = .
> +0 :
>  .pushsection .rodata
> -.quad current_handler
> +	.quad 0b

Bit of a silly nit: can we use a named label, or at least a non-zero shorthand?
It's really easy to misread "0b" as zeroing out the value, at least for me.

>  .popsection
>  
>  	.if ! \has_error
> -- 
> 2.29.2.576.ga3fc446d84-goog
> 
