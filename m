Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752034A6B48
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 06:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbiBBFTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 00:19:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbiBBFTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 00:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643779191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11guVR86PEuQIqw/AZslNbndyD6zWHs6+5yv0VdZa8c=;
        b=CiJsJgANJiXHrvvokdWDCARK0w+Qste6gxV1uA63N3UBRK/6oR+tCyRnsTl71F6aWj+BqZ
        i1MX+RAocen0JT5qIHmO+2U+brhJqwZ+0QSNUYYA66hZtsrmFjmujhPvrZ8eNEl1riwJrN
        ZgZjqlYRv4R5/LQehk7geAcP08lbHBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-9CPgrUM3O6qez3g-EHQ_1A-1; Wed, 02 Feb 2022 00:19:49 -0500
X-MC-Unique: 9CPgrUM3O6qez3g-EHQ_1A-1
Received: by mail-wm1-f71.google.com with SMTP id bg32-20020a05600c3ca000b00349f2aca1beso1975794wmb.9
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 21:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=11guVR86PEuQIqw/AZslNbndyD6zWHs6+5yv0VdZa8c=;
        b=Jaqxm91ubaOJfD5vlanAF2/eU+ipo5pfVC2ys7hx+55YUn5PvI6Tk3hXl2CEkYDU1r
         WGGjCDiF/u6b3I3cvRp3V+8KKWL/2sEV1cwtZ2Jf3gswKMOlq/P/qKFIaB+KhqOAtFsT
         DxospAiS+bC7MEXmmAbp5qQQOPF77shQDhbRxL5sRCCRg6SAiHD/ChOEyvQBH4syl3Qa
         mk73fCnJiH6EjeThQnragYLIlsTItGel4god32lJd0FTVubcjpjo8Ipc2KZlnM2oJ0GG
         bBbHzOgoL2kI6lvkuGPgyrxtdEb3lIJvGc9tU9LSEi8GfPP/Yr7Ipv7VnpWPwVumvZNb
         oTlA==
X-Gm-Message-State: AOAM530raHczbIfZ4ltta5J4W+usgqkIYz72HD3DUGToSnbW6CHUUb6X
        J6IEM1U6pOqp908z8BwF43YwTCCWvS/YMoTDAN4hbJ6ibcbvMddWsu4XvjhdYTRO4kVU1+DqAF0
        cXl2bD3Hh5hjd
X-Received: by 2002:a05:600c:3c89:: with SMTP id bg9mr4520041wmb.194.1643779188741;
        Tue, 01 Feb 2022 21:19:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyItiWNEeBAtS7+dzvfIR/4HMu/t+pEF1xtdam8ZAVh3WyP+E6RPoHma/Ee3CRT9Bi5a3JUcQ==
X-Received: by 2002:a05:600c:3c89:: with SMTP id bg9mr4520033wmb.194.1643779188567;
        Tue, 01 Feb 2022 21:19:48 -0800 (PST)
Received: from [192.168.8.100] (tmo-096-196.customers.d1-online.com. [80.187.96.196])
        by smtp.gmail.com with ESMTPSA id bg26sm3668551wmb.48.2022.02.01.21.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 21:19:47 -0800 (PST)
Message-ID: <51425935-acb6-1c34-cdbc-2349b1f8e05e@redhat.com>
Date:   Wed, 2 Feb 2022 06:19:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm-unit-tests] arm64: Fix compiling with ancient compiler
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20220201190116.182415-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220201190116.182415-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2022 20.01, Andrew Jones wrote:
> When compiling with an ancient compiler (gcc-4.8.5-36.el7_6.2.aarch64)
> the build fails with
> 
>    lib/libcflat.a(alloc.o): In function `mult_overflow':
>    /home/drjones/kvm-unit-tests/lib/alloc.c:19: undefined reference to `__multi3'
> 
> According to kernel commit fb8722735f50 ("arm64: support __int128 on
> gcc 5+") GCC5+ will not emit __multi3 for __int128 multiplication,
> so let's just fallback to the non-__int128 overflow check when we
> use gcc versions older than 5.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   lib/alloc.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/alloc.c b/lib/alloc.c
> index f4266f5d064e..70228aa32c6c 100644
> --- a/lib/alloc.c
> +++ b/lib/alloc.c
> @@ -1,6 +1,7 @@
>   #include "alloc.h"
>   #include "asm/page.h"
>   #include "bitops.h"
> +#include <linux/compiler.h>
>   
>   void *malloc(size_t size)
>   {
> @@ -13,7 +14,7 @@ static bool mult_overflow(size_t a, size_t b)
>   	/* 32 bit system, easy case: just use u64 */
>   	return (u64)a * (u64)b >= (1ULL << 32);
>   #else
> -#ifdef __SIZEOF_INT128__
> +#if defined(__SIZEOF_INT128__) && (!defined(__aarch64__) || GCC_VERSION >= 50000)
>   	/* if __int128 is available use it (like the u64 case above) */
>   	unsigned __int128 res = a;
>   	res *= b;

I'd also be OK if we'd simply declare GCC compiler versions < 5 as 
unsupported ... but since it's an easy fix:

Acked-by: Thomas Huth <thuth@redhat.com>

