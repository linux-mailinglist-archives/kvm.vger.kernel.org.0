Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF342395989
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 13:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhEaLRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 07:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231164AbhEaLRD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 07:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622459722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbVQVF2Oxhjo1ML89s9a3cuayWvFHjuQHqPKwdseAmY=;
        b=Uk71La7IDzbvQpOI/dRlN4KVmq32x2tuplfpSxZJilM+pqzB+unnpC0V0nRQjzzcT1+o3m
        JyZwq98zKk2vQidVEQqdHpkA1Up4QG1CUow/o0CIhSmmgPhIeNXWClhrKkLHKuNphQsAOB
        x1vicZ/JUYquluVGS9XZJ/qvy3Id4oE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-iKxEKMM9OgebrJtOM9cShg-1; Mon, 31 May 2021 07:15:21 -0400
X-MC-Unique: iKxEKMM9OgebrJtOM9cShg-1
Received: by mail-wr1-f72.google.com with SMTP id n2-20020adfb7420000b029010e47b59f31so3819467wre.9
        for <kvm@vger.kernel.org>; Mon, 31 May 2021 04:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HbVQVF2Oxhjo1ML89s9a3cuayWvFHjuQHqPKwdseAmY=;
        b=e3cLOkSOnnhuLmzSeBH1scWcpV+1pUIHcKU8jukJP5EIRCb1HUTTJXq0DDO918h492
         iiE2pKNjo2J8bASwer0dRA+q0MVL/fY0OHkbZH09ZBSYZ3jZMI1ik5/TLOq6gMd21ASj
         x2x9S4dN5liMFC7AoSy+/MkI//6imbjR39KxDq3jdokH7HSrM03tWWlbt/iYmoDCCHYH
         hO2dUT31qdT56HrRZMo2K+pv8G9KalRMqQrP9dIocONwazytQWox3TksOS1Xyr52Whw7
         aKEP5Rzcnf8gwbVPzTsbj/0SkIOyHURThFBVAw9ZODY33pAFmkSRkFbUQVK+rSnpNOGR
         P4EA==
X-Gm-Message-State: AOAM532fuFY+BePiX5oOA66dFrYTWCSNcDgAQgF+/Z3o5mREskLyycMK
        CxcTjtQMQiYSfTI6WKNTaJJ8R8yuZWRwuiWZkXLdel+9CUr6gjUBl9JdkhKfSbTxtdzuD1orsMu
        CfiuWAA5jmjAN
X-Received: by 2002:a1c:98c7:: with SMTP id a190mr1261163wme.77.1622459720357;
        Mon, 31 May 2021 04:15:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmIMZAUU4FULPo1/tg519tmgeOBZl4HC1m1a7zYeTUqKsNpyLXP2/Z2AVWVzUGCi4Leh5TpA==
X-Received: by 2002:a1c:98c7:: with SMTP id a190mr1261143wme.77.1622459720086;
        Mon, 31 May 2021 04:15:20 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6a6f.dip0.t-ipconnect.de. [91.12.106.111])
        by smtp.gmail.com with ESMTPSA id d9sm16694626wrx.11.2021.05.31.04.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 04:15:19 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] s390x: selftest: Fix report output
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210531105003.44737-1-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <53383a4f-8841-ae12-3fd0-14bda08801e2@redhat.com>
Date:   Mon, 31 May 2021 13:15:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531105003.44737-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.05.21 12:50, Janosch Frank wrote:
> To make our TAP parser (and me) happy we don't want to have to reports
> with exactly the same wording.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/selftest.c | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index b2fe2e7b..c2ca9896 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -47,12 +47,19 @@ static void test_malloc(void)
>   	*tmp2 = 123456789;
>   	mb();
>   
> -	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
> -	report(*tmp == 123456789, "malloc: access works");
> +	report_prefix_push("malloc");
> +	report_prefix_push("ptr_0");

instead of this "ptr_0" vs. "ptr_1" I'd just use

"allocated 1st page"
"wrote to 1st page"
"allocated 2nd page"
"wrote to 2nd page"
"1st and 2nd page differ"

Avoids one hierarchy of prefix_push ...

> +	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
> +	report(*tmp == 123456789, "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report_prefix_push("ptr_1");
>   	report((uintptr_t)tmp2 & 0xf000000000000000ul,
> -	       "malloc: got 2nd vaddr");
> -	report((*tmp2 == 123456789), "malloc: access works");
> -	report(tmp != tmp2, "malloc: addresses differ");
> +	       "allocated memory");
> +	report((*tmp2 == 123456789), "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report(tmp != tmp2, "allocated memory addresses differ");
>   
>   	expect_pgm_int();
>   	configure_dat(0);
> @@ -62,6 +69,7 @@ static void test_malloc(void)
>   
>   	free(tmp);
>   	free(tmp2);
> +	report_prefix_pop();
>   }
>   
>   int main(int argc, char**argv)
> 


-- 
Thanks,

David / dhildenb

