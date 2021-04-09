Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A21B35A4A0
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhDIR30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:29:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233896AbhDIR3Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 13:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617989351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ROG10t1hmEcxouWvzQa/hFe4MtOZHgtNbLbDkBlToyc=;
        b=KHSIEIG62Mv9z80gRflBYxU80cOYQGONtK4DcBaO7RqLGsjaUROkT5DH1Sz95rqZsmR3AK
        5QRrTz93pA8PEuSeGGOVI+feLGSRERswbs/8VfXoV9szFx2ddgPCqzZdVODwMuSR/vBx2F
        7mKDk+rM6gRcQjQ3v26LMFkNk8gRn3A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-8g-rBfQXMhS2Y7emJFzmuQ-1; Fri, 09 Apr 2021 13:29:09 -0400
X-MC-Unique: 8g-rBfQXMhS2Y7emJFzmuQ-1
Received: by mail-ej1-f71.google.com with SMTP id bg7so2479837ejb.12
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 10:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ROG10t1hmEcxouWvzQa/hFe4MtOZHgtNbLbDkBlToyc=;
        b=Y25Qq+gIPHdDMXAu+E6VjD5tN14UvvjzwI0gPGH6CoV658IuAbk2P55PY1P1YuCbxd
         xieU1PgFKVd7YvRl8+Kvrym3ozEoYE9WejDWAQfqECXMRCm42LPzOJYRNMf5C6/KDqoO
         7fLFGltd1OzhkDF0j+QqURqo+azTdNDIe2M0zjVo2wm+02ti57jpRnY7Ib64nrVWHCXL
         GniDQeb+QXy9takX7M+JgmAVWpDY8y/Wu/N1Kpc7SLaGICGlJOhKWuqk7h7Eqk7YLK68
         rKtusRn9QuSsYSjOgBe+YFiftrv2CDkD0r5MOCrWLUuEZPTf8S7P7h0eleDRrfU0vBa+
         w7kQ==
X-Gm-Message-State: AOAM531JN7QLvZ/PsRFpUsMmtMvpkNdKley9we0MC7iDsSGYeuiGentj
        k2ISm31szQhGstl3n99X27H4jQ7BqqmuzGMG1bUtt12Pp14Ou3apUcmZ6H4w6JqPplZSOZDxlmL
        hbTe0muOFmfAzL8rTPTHg4gADQXL3h4tgW5m55YZTkYNkS/pi07JUDsYVb/3sKsw/
X-Received: by 2002:a17:906:b7d1:: with SMTP id fy17mr17335057ejb.110.1617989348164;
        Fri, 09 Apr 2021 10:29:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7puf/gAZxu+Vp6rAeE043OaH62+P9k+coK0dOeY/2ADcOgSdz8C5d+iqCEPNop5/LShXKcQ==
X-Received: by 2002:a17:906:b7d1:: with SMTP id fy17mr17335049ejb.110.1617989347999;
        Fri, 09 Apr 2021 10:29:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q12sm1526832ejy.91.2021.04.09.10.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 10:29:07 -0700 (PDT)
Subject: Re: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test
 failure
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org
References: <20210409075518.32065-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
Date:   Fri, 9 Apr 2021 19:29:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210409075518.32065-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/21 09:55, Yang Weijiang wrote:
> During kvm-unit-test, below failure pattern is observed, this is due to testing thread
> migration + cache "lazy" flush during test, so forcely flush the cache to avoid the issue.
> Pin the test app to certain physical CPU can fix the issue as well. The error report is
> misleading, pke is the victim of the issue.
> 
> test user cr4.pke: FAIL: error code 5 expected 4
> Dump mapping: address: 0x123400000000
> ------L4: 21ea007
> ------L3: 21eb007
> ------L2: 21ec000
> ------L1: 2000000
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   x86/access.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 7dc9eb6..379d533 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -211,6 +211,8 @@ static unsigned set_cr4_smep(int smep)
>           ptl2[2] |= PT_USER_MASK;
>       if (!r)
>           shadow_cr4 = cr4;
> +
> +    invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
>       return r;
>   }
>   
> 

Applied, thanks.

Paolo

