Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED1A553EA7
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354798AbiFUWpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354574AbiFUWpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:45:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B005231DD7
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:45:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m14so13774297plg.5
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Zy9tzwg3/BucaMbjJ1QTMRtMrhWwRUdxzlXAzRxa1M=;
        b=PQ7VEIGI0qEX7iyQJqAJ8evzehdLsN4TrTBnHsKZzwyVlCmsTWR8G+2YBJBy5Bi8Ph
         Ix230PPwrLT4sP/vKdRRs6hRbhZ/gG/CSDJ4t+1h5llsOJ1FbJbu52Sdg6osa3Fj7cxa
         QrjLVsO6pZQJKQ6Z8Ty7rE2KDh5xRyIvzDx6dFg8Q1wN9jSRAwghH4O+hA9Hi6X0HxkW
         LQ004XJ8XS51iYl4PuGoy4WTPlbxx62Po5O1g87kNXjbW/843lu7uKK+DFvHO/xvS+Td
         f6mkkGjo36T9xlvkLy8sp0ww07IYwu8Y72nkugnorQGKEv3jVOb2I/XrVqCbnYWrcgaP
         Qtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Zy9tzwg3/BucaMbjJ1QTMRtMrhWwRUdxzlXAzRxa1M=;
        b=1mLucW+oM3kzjmxJFp90iyref4tKaSLodJZ+SpU+yL/n9kMggb5bQDchAq7DqnBbhP
         a915NQBPnnTtX2jgT6oC/DFD51khwcJ8s14NjNI7XnV+WboWZZvnRaF3qprTy1e/jYwM
         8n73MBLosg4VhFRiyFwyrKCUP15E3HiGWL1ttwpOlrJSyETIfLsVM5um4BBSk7LMWIJd
         W/PNpsOZXEf784xRzwUAyQ/pmzyQuoC8eVyNTfuCOoQEZDYt0lGqOT2C4KA3PyVv29JX
         PgQ/EaaKJmcKVcz8yJiaEC8M2t7ZJ1s+1WRS/UaC2RI+TmyitDLPKegY/LzA52d1nYNu
         g6Xg==
X-Gm-Message-State: AJIora/P/LtZIo7UWPraVpPB+fIifJwTLi7dymS3W84t/VLnM8cvBkuk
        xisXTgFgGhTcrD3OwzHF9GDjFg==
X-Google-Smtp-Source: AGRyM1too6YrJDMJDbHLFJDGfI2AY3bvaROK5eqc9gypWdAQXrMGx4D4eQHwO+uv8K94pqeWu86yFA==
X-Received: by 2002:a17:903:2d1:b0:168:e83e:dab0 with SMTP id s17-20020a17090302d100b00168e83edab0mr30335998plk.118.1655851515034;
        Tue, 21 Jun 2022 15:45:15 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id w9-20020aa79a09000000b00525204224afsm5610876pfj.94.2022.06.21.15.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:45:14 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:45:11 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 21/23] x86: Move x86_64-specific EFI
 CFLAGS to x86_64 Makefile
Message-ID: <YrJJ9xDhOWDI7dOV@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-22-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-22-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:56:03PM +0100, Nikos Nikoleris wrote:
> Compiler flag -macculate-outgoing-args is only needed by the x86_64
> ABI. Move it to the relevant Makefile.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  Makefile            | 4 ----
>  x86/Makefile.x86_64 | 4 ++++
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5dea..307bc29 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -40,14 +40,10 @@ OBJDIRS += $(LIBFDT_objdir)
>  
>  # EFI App
>  ifeq ($(CONFIG_EFI),y)
> -EFI_ARCH = x86_64

Should this be moved to the x86 Makefile as well? (just in case)

>  EFI_CFLAGS := -DCONFIG_EFI
>  # The following CFLAGS and LDFLAGS come from:
>  #   - GNU-EFI/Makefile.defaults
>  #   - GNU-EFI/apps/Makefile
> -# Function calls must include the number of arguments passed to the functions
> -# More details: https://wiki.osdev.org/GNU-EFI
> -EFI_CFLAGS += -maccumulate-outgoing-args
>  # GCC defines wchar to be 32 bits, but EFI expects 16 bits
>  EFI_CFLAGS += -fshort-wchar
>  # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index f18c1e2..ac588ed 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -2,6 +2,10 @@ cstart.o = $(TEST_DIR)/cstart64.o
>  bits = 64
>  ldarch = elf64-x86-64
>  ifeq ($(CONFIG_EFI),y)
> +# Function calls must include the number of arguments passed to the functions
> +# More details: https://wiki.osdev.org/GNU-EFI
> +CFLAGS += -maccumulate-outgoing-args
> +
>  exe = efi
>  bin = so
>  FORMAT = efi-app-x86_64
> -- 
> 2.25.1
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>
