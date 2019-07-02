Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5485D3E5
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGBQIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:08:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53700 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGBQIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:08:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so1414723wmj.3
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wxx0J+J36BoI99Tt8CicdxoyIVFx6EGgJ3h5qzhv4ZY=;
        b=hWzZHD7+KdUXpWKr/vi2YC+nv/yj78tRqk3lSupT9ChmPj7zjGGnu5mma3WK0N4rwb
         uMAPfGVZA20eOYPJtn4EU8Qm6/gdVgdqfXi3W0atDn4KwQPEnU5UNjh0rO2D8mZOK9a+
         qxXVq8sMd6Y6p80tNssZ0fErKReJbTNgQTgLuVG2WFtpQ1/XyfyMlSYaXBScj2nzX7p3
         4FtTnAxcFKCGSepOYHn0aw5s8Ib4ZOX0o+F1hn5SKGSJChggmAOqEdd4OyVbEbzZhCC6
         1DKhAbRv33RmpRK4/clBydSWsP0KS5Xredx9SElgYgcvK+EYJmhfd2mBkqebt8JDOe2u
         /gEg==
X-Gm-Message-State: APjAAAXrmIjDAurZT1Ik0lRGNH0/Ls3HTp1wCCa2wZQAmR7KepLBNzDd
        IR9qCn+hy0yiEgjX8JUG2rSmiEDF2vE=
X-Google-Smtp-Source: APXvYqy1p/x5ZQQO+i49EKPdrHIGdLgdkZoH/pof61gk+dgd8qFA3u+nChlgRNN9EjkJkZqfRNsBpg==
X-Received: by 2002:a1c:1f4c:: with SMTP id f73mr4203397wmf.151.1562083725139;
        Tue, 02 Jul 2019 09:08:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id t140sm3149450wmt.0.2019.07.02.09.08.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:08:44 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/3] libcflat: use stdbool
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-2-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <206afe8e-b7f8-0501-2ee8-45c9177a079d@redhat.com>
Date:   Tue, 2 Jul 2019 18:08:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628203019.3220-2-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/19 22:30, Nadav Amit wrote:
> To avoid any future build errors, using stdbool instead of defining
> bool.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/libcflat.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 7529958..b94d0ac 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -24,6 +24,7 @@
>  #include <stddef.h>
>  #include <stdint.h>
>  #include <string.h>
> +#include <stdbool.h>
>  
>  #define __unused __attribute__((__unused__))
>  
> @@ -53,10 +54,6 @@ typedef uint64_t	u64;
>  typedef int64_t		s64;
>  typedef unsigned long	ulong;
>  
> -typedef _Bool		bool;
> -#define false 0
> -#define true  1
> -
>  #if __SIZEOF_LONG__ == 8
>  #  define __PRI32_PREFIX
>  #  define __PRI64_PREFIX	"l"
> 

Queued this one.

Paolo
