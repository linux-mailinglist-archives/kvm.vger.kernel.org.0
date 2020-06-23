Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C984B2045A3
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbgFWAew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:34:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731442AbgFWAeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 20:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592872489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=707xbEGzUTi+S9zm8+1WYYk5fPnxtjeAbSa8piAkZ+E=;
        b=VGqJExj9btSYuRoDsCq5IBsNAeijrlhMhp5u24/JhMoZpu6KQ8BNAw6lu8oqfagsPOd9OE
        3K4xXyqqzoGA1GwPG2/j2RVdC/uYU/DRH3qTrzMaHcBsoNs7/fkeJczqIgMibQEY4GbZtT
        VnAjKKIB8kEd/nri9ZwntYqsEUbWjzY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-YLaieSX7P5K1a7K6S2NecA-1; Mon, 22 Jun 2020 20:34:47 -0400
X-MC-Unique: YLaieSX7P5K1a7K6S2NecA-1
Received: by mail-wr1-f71.google.com with SMTP id a18so1007792wrm.14
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 17:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=707xbEGzUTi+S9zm8+1WYYk5fPnxtjeAbSa8piAkZ+E=;
        b=f6hvHp3AcXbAVF51fYJVSyDHGC0t7kQv02TO2sIPqF8fwAEzKi4fDMftTTLlSsrkKq
         Apv/8zSKXkszD5l0rY4rVXPWmgCEfln0jyrKN8dSdNfq0dDc1lgrkQi2bZK7lDSUAwpJ
         SLbDkjBhKCRq9B/TMHdEFjJ4To3Q2Tg7ONnIKyvvcT1amRJbDhiibDtSsqC3Av7dSTqK
         7NBVZ05JBKWwX86W3oEV6JKtYuYNBVt9/Jrm4HhC/tpjRkkZdFJb3pSsQHHIKESyDfFD
         KzjQmHlGNvBL+qcUDQDjFNoLavUSldrkaEIi8QqR5NMYG9x3GRXjTezy0hOEzkx56cab
         5EPQ==
X-Gm-Message-State: AOAM530WWkbjel4oyDhk0RrLTf2OYc3jE/8m7m0dIZPTmrirFQWqIXN+
        P/V0YHsvUpaDQQzfis8eBbAOOkgMNYsHLNRCX+jiRV2iYv1QhbP8IaoYGciJCMjZ429IVH335Dl
        LicUgBr7q1dKT
X-Received: by 2002:a1c:254:: with SMTP id 81mr20855541wmc.93.1592872486302;
        Mon, 22 Jun 2020 17:34:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzk3E4YGtER6qFONqvwwGuEqS3boensfHGNW8mQCu7OSHX68Bym5KE6mP3VAYLaAGfG25GAA==
X-Received: by 2002:a1c:254:: with SMTP id 81mr20855523wmc.93.1592872486017;
        Mon, 22 Jun 2020 17:34:46 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id m65sm1412718wmf.17.2020.06.22.17.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 17:34:45 -0700 (PDT)
Subject: Re: [kvm-unit-tests v3 PATCH] Fixes for the umip test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200512094438.17998-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5fe149c8-a0df-0aa5-3fe4-175d578844b2@redhat.com>
Date:   Tue, 23 Jun 2020 02:34:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200512094438.17998-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/20 11:44, Thomas Huth wrote:
> When compiling umip.c with -O2 instead of -O1, there are currently
> two problems. First, the compiler complains:
> 
>  x86/umip.c: In function ‘do_ring3’:
>  x86/umip.c:162:37: error: array subscript 4096 is above array bounds of
>     ‘unsigned char[4096]’ [-Werror=array-bounds]
>        [user_stack_top]"m"(user_stack[sizeof user_stack]),
>                            ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
> 
> This can be fixed by initializing the stack to point to one of the last
> bytes of the array instead.
> 
> The second problem is that some tests are failing - and this is due
> to the fact that the GP_ASM macro uses inline asm without the "volatile"
> keyword - so that the compiler reorders this code in certain cases
> where it should not. Fix it by adding "volatile" here.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v3: Use "sizeof(long)" instead of "2"
> 
>  x86/umip.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/umip.c b/x86/umip.c
> index 7eee294..37f1ab8 100644
> --- a/x86/umip.c
> +++ b/x86/umip.c
> @@ -22,7 +22,8 @@ static void gp_handler(struct ex_regs *regs)
>  
>  
>  #define GP_ASM(stmt, in, clobber)                  \
> -     asm ("mov" W " $1f, %[expected_rip]\n\t"      \
> +    asm volatile (                                 \
> +          "mov" W " $1f, %[expected_rip]\n\t"      \
>            "movl $2f-1f, %[skip_count]\n\t"         \
>            "1: " stmt "\n\t"                        \
>            "2: "                                    \
> @@ -159,7 +160,8 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>  		  : [ret] "=&a" (ret)
>  		  : [user_ds] "i" (USER_DS),
>  		    [user_cs] "i" (USER_CS),
> -		    [user_stack_top]"m"(user_stack[sizeof user_stack]),
> +		    [user_stack_top]"m"(user_stack[sizeof(user_stack) -
> +						   sizeof(long)]),
>  		    [fn]"r"(fn),
>  		    [arg]"D"(arg),
>  		    [kernel_ds]"i"(KERNEL_DS),
> 

Pushed, thanks.

Paolo

