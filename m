Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36449398899
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 13:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhFBLwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 07:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhFBLwO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 07:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622634631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4vgRjLyYu/AS6C4wM6Wkc0hI7h+K9vgstthqRW1EpdA=;
        b=TutWVhuO/LdQ33E2VgOXsu9zeLNW390lWm0FBJDRNAYooilavQR3xWrhuxiahtGWRXwKOO
        hrAdOe4pct0Bd2d7nljdptPHN0HJ0YUhNE+QHkPioa+Q3Mhw3BgA5s+yPFeADDrWLLarXs
        AVubLDPOi2MmCBcLzQNYa2zM0FCWEeU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-FeRwkqTvPMCH23tSOC1M9w-1; Wed, 02 Jun 2021 07:50:30 -0400
X-MC-Unique: FeRwkqTvPMCH23tSOC1M9w-1
Received: by mail-ej1-f71.google.com with SMTP id h18-20020a1709063992b02903d59b32b039so537298eje.12
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 04:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4vgRjLyYu/AS6C4wM6Wkc0hI7h+K9vgstthqRW1EpdA=;
        b=EEBb4b9R/37Aez5biefOK1m1OhDGfcFks1A3CALxHan+Wm3xTORiNXBGSe/x2mqvlt
         2uQwI2JHNJ2ZApvvDC2yAi7B+4paYjZFOZ6cEYH3P8OJFE6v3sxVc9qKKaGbn3OJcZev
         NaX7jaDb3FY+ui+/4jRuDo9CRubdQhw+uWekcoOO2R/avrPSjVBuxIGwZw2XMDBqDIph
         y9kZ4A2uoXS5ZTWDiHRPjM1WFYenfgwjjMJ/+2yWismggMQ5zrJbSc/L20y0tkpNOGP5
         6UavEefOFb6QQuI5jWphtkVuuALSrl1ubtkTIM4NWNRPr5xve9m9ppQHpKiXsSDKoy+L
         sLzA==
X-Gm-Message-State: AOAM532MSgZ8tXkgWZN1kvFaTGuW58hWivmQnDgN48A6bFSk8hA9pM1w
        Dueyt2pH2qfhJ4jHUSmMFqkT5JPlpNGLSu8/YGCJ3omF2TcJe3g/8fG0wA2y4ZLkC2CzowyDvu4
        IbPEasN/szIVc
X-Received: by 2002:aa7:d8d8:: with SMTP id k24mr22403632eds.253.1622634629093;
        Wed, 02 Jun 2021 04:50:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKJuxI0vXMLPhkBRiGMwN+tENwTyd3bPTBKJn8UuWlmVzyFj96Rn7oePshOjImai1tHEiKeQ==
X-Received: by 2002:aa7:d8d8:: with SMTP id k24mr22403620eds.253.1622634628986;
        Wed, 02 Jun 2021 04:50:28 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id kx3sm8312023ejc.44.2021.06.02.04.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 04:50:28 -0700 (PDT)
Date:   Wed, 2 Jun 2021 13:50:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] compiler: use __builtin_add_overflow_p
 for gcc >= 7.1.0
Message-ID: <20210602115026.mwsrblpxdiijuhyj@gator.home>
References: <20210602082443.20252-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210602082443.20252-1-po-hsu.lin@canonical.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 04:24:43PM +0800, Po-Hsu Lin wrote:
> Compilation on Ubuntu Xenial 4.4.0-210-generic i386 with gcc version 5.4.0
> 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.12) will fail with:
>   lib/linux/compiler.h:37:34: error: implicit declaration of function
>     ‘__builtin_add_overflow_p’ [-Werror=implicit-function-declaration]
> 
> From the GCC document[1] it looks like this built-in function was only
> introduced since 7.1.0
> 
> This can be fixed by simply changing the version check from 5.1.0 to 7.1.0
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc-7.1.0/gcc/Integer-Overflow-Builtins.html
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  lib/linux/compiler.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 745792a..5d9552a 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -30,7 +30,7 @@
>  	__builtin_mul_overflow(a, b, &__d);		\
>  })
>  #endif
> -#elif GCC_VERSION >= 50100
> +#elif GCC_VERSION >= 70100
>  #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
>  #define check_add_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) + (b)))0)
>  #define check_sub_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) - (b)))0)
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

