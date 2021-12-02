Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC7C465F2B
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 09:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352761AbhLBIRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 03:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238808AbhLBIRG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 03:17:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638432823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o+kNqH6Vd9vBOGeJbtq5B9QQjZZDFor6PKOFKiojneA=;
        b=HnFFkPe1+DmNvlM1gjt3lZyiBqNCf7mNdUAHzcx8G0WOe7C5NaH2k5nc0XCBDy8o869mso
        2RpB7LdjesAztKRNtqG/1iakE83k6oY9q1bIO/TLHo/L40oGlTw0DQ77qeNQgqK+ZZp1Oc
        THuYobe4O9ttM1HdY1WxDgSmkElTjZ8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-chZ5_3_vPVaCoL2pZkZi3Q-1; Thu, 02 Dec 2021 03:13:42 -0500
X-MC-Unique: chZ5_3_vPVaCoL2pZkZi3Q-1
Received: by mail-wm1-f72.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so13586426wmg.9
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 00:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o+kNqH6Vd9vBOGeJbtq5B9QQjZZDFor6PKOFKiojneA=;
        b=W/gfU1DTqerxqrl3pJLiR924pf3TUlRPJMncC5WY1wXdu5oTbYQPhycB5dHqVe1IHL
         Jexnr/32xXGh/kj2AtEFv9PR2TKR4rvUHUWTjqTJ4I6YZw4f8YtKsfUBhuahuinwMaP7
         v9SHMbso1hK9JT/f7m8NVDtnA7ryUfuVPPa5YSjGmRgQpmLZtf5cmWVev6Vs+INeqiGy
         CSu7bWCQA+4Ea8BwRcHH9wAqpMeJkD+fGbDYK2QNs3oOUZGXqIhnYgoBbnNfoYZekM1c
         L2Tfpw3bVGb/u6zxqA1xjpzioxSh1XvMKGcI75IYqeSqdFjJv/+2dBWrYrRN/aJdpX7/
         PI1A==
X-Gm-Message-State: AOAM533SLUCyxcxRLuAzXQlpmwo7HzBE0XCO+1Fhw5zBPggERu4tUOIE
        99xxZ62QwpNMdW+ASYZ4bUXsntVIL4w490hwERITyLd88xoJGBzo5oiWs2k1DnjWdq3IuAIL5dM
        04snR8zyC1+74
X-Received: by 2002:a5d:4084:: with SMTP id o4mr13324940wrp.47.1638432820855;
        Thu, 02 Dec 2021 00:13:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxE67oaB+6Ytf+8AQxVhEwVTZsFg/tRqEWdC9em9C60CnA4o7cQlFx8h0beTCcjKgIEiczmbQ==
X-Received: by 2002:a5d:4084:: with SMTP id o4mr13324924wrp.47.1638432820655;
        Thu, 02 Dec 2021 00:13:40 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id q123sm1372653wma.30.2021.12.02.00.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 00:13:40 -0800 (PST)
Message-ID: <c2c6a664-d91d-5b2e-2e82-70057f62c8b3@redhat.com>
Date:   Thu, 2 Dec 2021 09:13:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] s390x/cpumodel: give each test a unique
 output line
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20211201160917.331509-1-borntraeger@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211201160917.331509-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/12/2021 17.09, Christian Borntraeger wrote:
> Until now we had multiple tests running under the same prefix. This can
> result in multiple identical lines like
> SKIP: cpumodel: dependency: facility 5 not present
> SKIP: cpumodel: dependency: facility 5 not present
> 
> Make this unique by adding a proper prefix.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   s390x/cpumodel.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 67bb6543f4a8..12bc82c1d0ec 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -116,14 +116,15 @@ int main(void)
>   
>   	report_prefix_push("dependency");
>   	for (i = 0; i < ARRAY_SIZE(dep); i++) {
> +		report_prefix_pushf("%d implies %d", dep[i].facility, dep[i].implied);
>   		if (test_facility(dep[i].facility)) {
>   			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
>   				     test_facility(dep[i].implied),
> -				     "%d implies %d",
> -				     dep[i].facility, dep[i].implied);
> +				     "but not available");

<bikeshedding>
Maybe rather something like "implication not correct" or so?
</bikeshedding>

>   		} else {
>   			report_skip("facility %d not present", dep[i].facility);
>   		}
> +		report_prefix_pop();
>   	}
>   	report_prefix_pop();
>   
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

