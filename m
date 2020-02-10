Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C965F157DEF
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 15:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgBJO4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 09:56:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52067 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727008AbgBJO4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 09:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581346568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABdF4dB4/BkNlv83ySzAGEclBY8An7y43q/SnIcw/38=;
        b=TwWUw2c0Cpk8gZWy8lNihMtlgrgrBwvSfxQ31EbQljFjpBoEvjSS0BhuMn1/E9iMOMXjyg
        whoJ4laaN6KroM+RrWOW9Cq5sQe/4/W3rZsXrgMY2oSc8EtviLpz2UhD34ufiJ9fYSNfDo
        zRRPbj8TQJ09SlfujkDnVvQlwb/vnag=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-lt25OBLPPKWlmA26F5wQKA-1; Mon, 10 Feb 2020 09:56:06 -0500
X-MC-Unique: lt25OBLPPKWlmA26F5wQKA-1
Received: by mail-wm1-f71.google.com with SMTP id p26so3290387wmg.5
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 06:56:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABdF4dB4/BkNlv83ySzAGEclBY8An7y43q/SnIcw/38=;
        b=Oj+XpeTaQa1Pm19AIp5SwXks6dampoY6FGlk+4GNpuPWREh2Ls6xnAUEv9eaUGrjzT
         oAEEQ3HCaY4NdxxHqMXjXClE5WJzB1WfqJwXYjWN5CQ+z1y8vJQxkzbGxIMCzG7l4ybi
         dwCzsH3grAqrVpWi5RSW2L474m9V7qhcoMPBy05Cq7xw4zeh27ETbs0cFgU1pBWOgxp4
         VsP2lUPnq9uvlEYi8rPid3+B6xyGp5t66KJA5MB/N6c4j3j7Pe+/r/KhaR0Dm1eKD/e9
         JkQZOEASKXr2+P2lM1/dLqH8rGMc8las60Wsrkpb6Pj6yOKwf8weTdm7m6WZoDzkiPuI
         OX5A==
X-Gm-Message-State: APjAAAXxNaRMt2YxWnHfl6TIFvoVDX4IFlCfwUWgvcxIfPyBY3hqAcz7
        temCvyEvDMPHdozvzSfl2UwprAhZim2KX5pjPwI42Pa+nj0bPaL+3fNJhq2F74Oh7/D0cPmLpaM
        VoXySO3Ne+zhR
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr2433674wrt.100.1581346565554;
        Mon, 10 Feb 2020 06:56:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiZeXQlApAAdUnaKQQbP0Obrz01xwNVY6iMJa7qjhYLhmGDfg4gIjxU2XFZ3RVPIYA81Ukzg==
X-Received: by 2002:a5d:4b8f:: with SMTP id b15mr2433652wrt.100.1581346565275;
        Mon, 10 Feb 2020 06:56:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:50ec:2e9a:84be:2bbe? ([2001:b07:6468:f312:50ec:2e9a:84be:2bbe])
        by smtp.gmail.com with ESMTPSA id x14sm810940wmj.42.2020.02.10.06.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 06:56:04 -0800 (PST)
Subject: Re: [kvm-unit-tests v2 PATCH] Fixes for the umip test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200210143514.5347-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8701a05c-21cd-e13b-c94b-4d78b7cfefaf@redhat.com>
Date:   Mon, 10 Feb 2020 15:56:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200210143514.5347-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/20 15:35, Thomas Huth wrote:
>  #define GP_ASM(stmt, in, clobber)                  \
> -     asm ("mov" W " $1f, %[expected_rip]\n\t"      \
> +    asm volatile (                                 \
> +          "mov" W " $1f, %[expected_rip]\n\t"      \
>            "movl $2f-1f, %[skip_count]\n\t"         \
>            "1: " stmt "\n\t"                        \
>            "2: "                                    \
> @@ -159,7 +160,7 @@ static int do_ring3(void (*fn)(const char *), const char *arg)
>  		  : [ret] "=&a" (ret)
>  		  : [user_ds] "i" (USER_DS),
>  		    [user_cs] "i" (USER_CS),
> -		    [user_stack_top]"m"(user_stack[sizeof user_stack]),
> +		    [user_stack_top]"m"(user_stack[sizeof(user_stack) - 2]),

This should be "- sizeof(long)" in order to keep the stack aligned.

I can fix this when I apply.

Paolo

>  		    [fn]"r"(fn),
>  		    [arg]"D"(arg),
>  		    [kernel_ds]"i"(KERNEL_DS),
> 

