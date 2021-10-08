Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22F2426507
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 09:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhJHHId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 03:08:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhJHHId (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 03:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633676798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsf6jDGY5/GqouCpq1M7goRZtVY3wZ9jP6KiI2uGQ2s=;
        b=G0RyFtGzQ39O0xFMU+183ogiF134PZkalSrnuv6JXohYQJQ7KbOOJ4s16LxnqXa9myiani
        cc7EMedkmZUrfgSyQcr7H0+uBiWIk4JZwGSZ48EojfPSPFB7/jrKz6thqgoE/PUlE7ayeP
        FstrLfPE+mzq3ToV07KWuO/YrWR6NK0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-LzyCGPfqPXm2HTmVYe1SvQ-1; Fri, 08 Oct 2021 03:06:37 -0400
X-MC-Unique: LzyCGPfqPXm2HTmVYe1SvQ-1
Received: by mail-wr1-f72.google.com with SMTP id 75-20020adf82d1000000b00160cbb0f800so5776365wrc.22
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 00:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsf6jDGY5/GqouCpq1M7goRZtVY3wZ9jP6KiI2uGQ2s=;
        b=CVHzKhwd7crMDplR7QWTWiPbNyGcF+l6f8XMt0OGoP/CF3n85AVf1mX/OJ1wf4qVhZ
         CWGP5RwSk0q2Fp8k0JCAa8s9UeiAXTrSvdU1c70bfTeuikDTZoVKLjfR1hRYjr6BiDKm
         a1zWMR56U1IG1fCCmCQMjryoNQkZoFAWarcR21VjaVvEc49xrR7z8WG5W9WOWtrx78wY
         p83vcmneeS1ygf3z/W59DsBMJz6+SajTdeR8IXC13vrGkShQc+i5FM3ffx1l/zRGFXNy
         f7sEXOU1U9ZqgpwSqPIVojZLLBKX8zwOe9r0juK85FVizJcLxLJhFnGxhaAqD74nPK/T
         kJmQ==
X-Gm-Message-State: AOAM532Eoo2q1J/Vd5a1kkGC4bpSTl6AmID/HgVP35ANPu89TcU1go09
        aDlNWJjG/kXVct10KIE5jkjjhkY9WURp9GKBPh6YHnVZJaU4XMjInTRwqaNiuVTut4wBWGs1Tts
        Mjaibh+o9f732
X-Received: by 2002:a5d:4908:: with SMTP id x8mr1856582wrq.251.1633676795929;
        Fri, 08 Oct 2021 00:06:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqTYPQMcNOIA3pYqLz47pG8aHObo1J/m8C8f4pWkh6I9FJLm0BDLELo+EeZW6gIHyTGNw7Ag==
X-Received: by 2002:a5d:4908:: with SMTP id x8mr1856568wrq.251.1633676795750;
        Fri, 08 Oct 2021 00:06:35 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id z12sm136226wmk.38.2021.10.08.00.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 00:06:35 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] parse_keyval: Allow hex vals
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     lvivier@redhat.com, ricarkol@google.com
References: <20211008070309.84205-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <ada92011-844a-7cce-f5a6-3adab11ebe11@redhat.com>
Date:   Fri, 8 Oct 2021 09:06:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008070309.84205-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/2021 09.03, Andrew Jones wrote:
> When parse_keyval was first written we didn't yet have strtol.
> Now we do, let's give users more flexibility.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   lib/util.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/util.c b/lib/util.c
> index a90554138952..682ca2db09e6 100644
> --- a/lib/util.c
> +++ b/lib/util.c
> @@ -4,6 +4,7 @@
>    * This work is licensed under the terms of the GNU LGPL, version 2.
>    */
>   #include <libcflat.h>
> +#include <stdlib.h>
>   #include "util.h"
>   
>   int parse_keyval(char *s, long *val)
> @@ -14,6 +15,6 @@ int parse_keyval(char *s, long *val)
>   	if (!p)
>   		return -1;
>   
> -	*val = atol(p+1);
> +	*val = strtol(p+1, NULL, 0);
>   	return p - s;
>   }
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

