Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C014FFB15
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 18:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiDMQWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 12:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiDMQWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 12:22:41 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35F6416
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:20:19 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f3so2449097pfe.2
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 09:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sghRdo0LgYErT0afHGp9AEP7s4FdDDHNg3pw863pU4M=;
        b=OS7QoZ9Yqy0TkEonQrZzN/RyJXY8CWRkXZIp84HXX5twCkz9YUSAHXZxdx/qfuFd8Y
         N2uAB2vH8p9XDR4frDWOmBDdT5LxECdNe8Tu4YAYWjEgQzxGm7mom9BGcEcbswOA5G4p
         lW6QbA2yv9b6N+pW2uZjdxQzpCPxEcSaeoj/NY7g7MkGa8eSnmILnuNQV/kpGL2iML8r
         HhiEs8VHCzDLjE793tJRBTGAy8pDY+1gQjgNEeHy3s8xjJVe6eLjPFSwMKSOyV/jWsrA
         LCzHrJ0/qdOzRIjGh3FXLUOoKYA7ApAwaOVth93bur9prpy4+DYZT9SeTblp6Wj+wg+r
         tIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sghRdo0LgYErT0afHGp9AEP7s4FdDDHNg3pw863pU4M=;
        b=M2bmPiY9onFDAAqI9NZHV+Lg4Z5g8GRkn1M8Xm5FJfzUWAT317nYF+DAQjJi6NV+BI
         57K+u3fnNGeQS7dzlFM0fZbkrPr01jsCRCxnkbvOpq79AOwMG2D4CTKrRDqsyla1ClAs
         M3gw8CI1Dh3/sjF+KfvV3l8iFIPwHYsftv/fKeIQPbF1yjiVcAD71Ob61iy0pBV/a6wx
         7d4+kzZ7gRRlhuAtrAuOWnM3Q/J7r/TQOVLsvXb7KLVhX0teRo7UTqpTtttPRfsYmOZ2
         5zAPfxVszzgJT4baFHtmpOXg3E8Ggb8wEATmDVf8dEcxSeCGHvng1zmmIPH2XbUML4Nx
         mT/g==
X-Gm-Message-State: AOAM531BhDx1iF5QBByor/aJl3FlGQN+MPXRvIuIjGKOgKw/QJYe5+rc
        Ul0LIA/bekWA87WH2oAbOyFuLw==
X-Google-Smtp-Source: ABdhPJwbsm/8xW1O82MjTEhevQQbEOSjaLT4AJGY2nKH4qLzo26Gw5Wc7hJp2nRzy6mBhVfFIHM3GA==
X-Received: by 2002:a63:d905:0:b0:399:370e:eee1 with SMTP id r5-20020a63d905000000b00399370eeee1mr36429275pgg.53.1649866819096;
        Wed, 13 Apr 2022 09:20:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q15-20020a056a00150f00b004fb28ea8d9fsm45450836pfu.171.2022.04.13.09.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 09:20:18 -0700 (PDT)
Date:   Wed, 13 Apr 2022 16:20:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 05/10] x86: efi: Stop using
 UEFI-provided stack
Message-ID: <Ylb4PnJ2WQa2UO0w@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-6-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-6-varad.gautam@suse.com>
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

On Tue, Apr 12, 2022, Varad Gautam wrote:
> UEFI test builds currently use the stack pointer configured by the
> UEFI implementation.
> 
> Reserve stack space in .data for EFI testcases and switch %rsp to
> use this memory on early boot. This provides one 4K page per CPU
> to store its stack / percpu data.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  x86/efi/crt0-efi-x86_64.S | 3 +++
>  x86/efi/efistart64.S      | 8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
> index eaf1656..1708ed5 100644
> --- a/x86/efi/crt0-efi-x86_64.S
> +++ b/x86/efi/crt0-efi-x86_64.S
> @@ -58,6 +58,9 @@ _start:
>  	popq %rdi
>  	popq %rsi
>  
> +	/* Switch away from EFI stack. */
> +	lea stacktop(%rip), %rsp
> +
>  	call efi_main
>  	addq $8, %rsp
>  
> diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
> index 8eadca5..cb08230 100644
> --- a/x86/efi/efistart64.S
> +++ b/x86/efi/efistart64.S
> @@ -6,6 +6,14 @@
>  
>  .data
>  
> +max_cpus = MAX_TEST_CPUS

Why declare max_cpus?  MAX_TEST_CPUS can be used directly.

> +

Rather than align the stack top, wouldn't it be easier and more obvious to the
reader to pre-align to?

.align PAGE_SIZE

> +/* Reserve stack in .data */
> +	. = . + 4096 * max_cpus

Use PAGE_SIZE instead of open coding 4096.

E.g. this works for me with my MSR_GS_BASE suggestion in the next patch (spoiler
alert).

/* Reserve stack in .data */
.data
.align PAGE_SIZE
	. = . + PAGE_SIZE * MAX_TEST_CPUS
.globl stacktop
stacktop:


> +	.align 16
> +.globl stacktop
> +stacktop:
> +
>  .align PAGE_SIZE
>  .globl ptl2
>  ptl2:
> -- 
> 2.32.0
> 
