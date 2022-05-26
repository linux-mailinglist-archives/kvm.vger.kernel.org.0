Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E8D53555D
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiEZVRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiEZVRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:17:20 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2F29D04E
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:17:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q4so2455430plr.11
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7WmKmhq7Co3oIFnUCAxcgs0ZItaJFPEI6tYE/o6LOyo=;
        b=M4bpMFKrFU6q1UuWiroij5UU0lvQmOSpjQHGvQJjso9rEngC9n5a1N1ByUnLWtO4FJ
         th9GKL4AQDwYpwXRTrZ5QJOfg8L0NOz5/2UAjhwIISd1z4oIZr/XPk5GSP08aWPtbBVd
         yJiDKSf0NncO1Ar9j9rjphfzxFi8H6kEeD/UzOxs6Ciwgbotdjtq1O3et8WS/g9Uazin
         2/TR88AHcN0jleqvCl1lJVkIUvfPxniUak+iWRY/HQMTmkbchLohWh8kt2xuWrxDu0pB
         R56F6MbgKav/j3qlI9wux0aITJJPZCcDvwu2McJiZaqpnJFk96kIiLQC6+rNHS5mPNPj
         0oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7WmKmhq7Co3oIFnUCAxcgs0ZItaJFPEI6tYE/o6LOyo=;
        b=d1toZYbuFNN89UHxfus4rK1VnxRu5+/Yerfcmg6JmT4UbYR7wd5HeMzrSceOdfQa+F
         OjgCoB9FUKv7ZRwsjYR1JjEG5U+9rTum39CO/28/0qqbhUXS1WdTkI5ct2cKgK2CiyvU
         fm+L6QFLvCP3MhOeR9OYrADrzh+Z7mxozLc6GpOk81BLeGqwYfQolc5nySYrruzenQNc
         mAr27LZbZQyNJIp0UeBiFnfbQnB/LQrUfYbJzCymJ6GKzf88Z2bNwf0M8TdgOmES2RUr
         zhPLgXTKBGviCk+uzZjTBTjIHz5ADu4/BG4QYabSzYIH8rQZI5XAnUMnT+R1CX9IHvY3
         YfIA==
X-Gm-Message-State: AOAM5334+hCWQwY/CcvJDlO0n6pPsUubFzMyB9iF151hWdb0DFKcY2lQ
        gi54QCaD7qzeq51GA9cOc8KGZA==
X-Google-Smtp-Source: ABdhPJy5Q0xggTcxMnnpurpWdm6qGA8gAfHjS9puQnafoBHmIeRsTXs5GP6iNCkofZmEjV7/+4H+fg==
X-Received: by 2002:a17:902:d54b:b0:161:8f46:8207 with SMTP id z11-20020a170902d54b00b001618f468207mr40317429plf.67.1653599838834;
        Thu, 26 May 2022 14:17:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a588d00b001d9927ef1desm88159pji.34.2022.05.26.14.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 14:17:18 -0700 (PDT)
Date:   Thu, 26 May 2022 21:17:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Cross <cross@oxidecomputer.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] kvm-unit-tests: invoke $LD explicitly in
Message-ID: <Yo/uWpZg2qQniSTP@google.com>
References: <20220526071156.yemqpnwey42nw7ue@gator>
 <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-2-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526173949.4851-2-cross@oxidecomputer.com>
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

On Thu, May 26, 2022, Dan Cross wrote:
> Change x86/Makefile.common to invoke the linker directly instead
> of using the C compiler as a linker driver.
> 
> This supports building on illumos, allowing the user to use
> gold instead of the Solaris linker.  Tested on Linux and illumos.
> 
> Signed-off-by: Dan Cross <cross@oxidecomputer.com>
> ---
>  x86/Makefile.common | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index b903988..0a0f7b9 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -62,7 +62,7 @@ else
>  .PRECIOUS: %.elf %.o
>  
>  %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
> -	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
> +	$(LD) -T $(SRCDIR)/x86/flat.lds -nostdlib -o $@ \
>  		$(filter %.o, $^) $(FLATLIBS)
>  	@chmod a-x $@
>  
> @@ -98,8 +98,8 @@ test_cases: $(tests-common) $(tests)
>  $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
>  
>  $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
> -	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
> -	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
> +	$(LD) -m elf_i386 -nostdlib -o $@ \
> +	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^

AFAICT, this is functionally a nop, and both 32-bit and 64-bit are happy, so,

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
