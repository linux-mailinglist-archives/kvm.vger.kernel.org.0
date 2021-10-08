Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55EC42716E
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 21:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhJHTcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 15:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhJHTcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 15:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633721428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZ3e60eb6DlJByLWoWmwQIIU3x4CCDxVSy6/c14Fz78=;
        b=PuMFP1+BvTf3rQMSj23qS6HohRUOvLpPVOZ4ddqTM+cRT4TG8h9fW59M64LRxZycwNoh00
        AfDTwBRAXJZHO/7+ukCBlKJds0yxepnKPuwu5g+eIdQMoNDLB63suSAbAI9wmmCr8fUABK
        kd0LCWfnzvuCi1A+RMeVwy12iH2C/ZU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-a_MKOPGiN2uyEApQhbnuQw-1; Fri, 08 Oct 2021 15:30:02 -0400
X-MC-Unique: a_MKOPGiN2uyEApQhbnuQw-1
Received: by mail-wr1-f69.google.com with SMTP id y12-20020a056000168c00b00160da4de2c7so4978408wrd.5
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 12:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GZ3e60eb6DlJByLWoWmwQIIU3x4CCDxVSy6/c14Fz78=;
        b=byPzWOu41cSwjjPxJlFUM792S0XKUulgDuBNVZySswDYKh5fz3kov3IL5i40Xz5/iL
         x1EhnFu1cHiuqcxgdrDBSJjRH22G2xx6bbqgZjjiZcdDNkY2fSZ3DaXjSp3LSRpSlrvu
         8mQRYx21D8CQhBXaVyGxOXW3bPMC2iTieqmMep4hepB9y3fTZg2qZC8JEtIyduC57gRL
         5NX20j05aRLW7D4eO+rTxlshLyG2mxk3TQPlCkNJ9HDrBQfSpXhuEA+iU9s2lRIFrpvT
         HW9IJsF5DhpnE5e0HF5CQGQlnMUSKP8QQV+ADOsqBHpa75vlFWe1MhNfL9PQvmgQHY7A
         0mrw==
X-Gm-Message-State: AOAM5336i5Ywa2tBR1WNaaXWIR7Dh4v3HjFKkBXtd76YbKJAPGOnC2GP
        kZQD1chBUSSsclMxecK5Ek8JD0yfQyZeHoU47rzIHRa5kiaPB7OebzB6Itm4XT9DzMHIyRz6qYF
        McMeOlxQ4z9gn
X-Received: by 2002:adf:8b9a:: with SMTP id o26mr6559685wra.109.1633721401628;
        Fri, 08 Oct 2021 12:30:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydOdniTQkK5EUFQQSup3n6LHAyboyuNYyQ6hqQCCBJUXmBhFUwwAkDBIJEZ4ws+2QeVFwntQ==
X-Received: by 2002:adf:8b9a:: with SMTP id o26mr6559662wra.109.1633721401363;
        Fri, 08 Oct 2021 12:30:01 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.3.114])
        by smtp.gmail.com with ESMTPSA id e5sm243617wrd.1.2021.10.08.12.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 12:30:00 -0700 (PDT)
Message-ID: <f3677533-0ede-c0a2-8507-38925ca7f10d@redhat.com>
Date:   Fri, 8 Oct 2021 21:29:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH kvm-unit-tests] parse_keyval: Allow hex vals
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, ricarkol@google.com
References: <20211008070309.84205-1-drjones@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20211008070309.84205-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/2021 09:03, Andrew Jones wrote:
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
Reviewed-by: Laurent Vivier <lvivier@redhat.com>

