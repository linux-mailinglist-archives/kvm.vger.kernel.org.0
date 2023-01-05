Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB7565E89E
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 11:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjAEKHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 05:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjAEKHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 05:07:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1056B2DC8
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 02:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672913172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KoUWBAnd6FL/mfG+yeIEH93rjbYXLkBdS2xnTNfB3pY=;
        b=GX3sl4FiBb7apqcNZKm7hLw8g6R4Y8tyJhTUicGeOuwSOQPZBrar0g5Mzf4g4m4j6DRl3m
        ZmTx8gZm/7+P5SMh1oeo43nAqSR8vTH2VsGOOUZSUiGkvuUN+83YdhCZo7lXksWGD93TOd
        5unp5oIe5i/comSNLjtnKcy5uDXRzTE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-CHB7vXPUMSukzM1fPaaEBg-1; Thu, 05 Jan 2023 05:06:03 -0500
X-MC-Unique: CHB7vXPUMSukzM1fPaaEBg-1
Received: by mail-wr1-f69.google.com with SMTP id i26-20020adfaada000000b0027c76c49445so3535879wrc.13
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 02:06:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KoUWBAnd6FL/mfG+yeIEH93rjbYXLkBdS2xnTNfB3pY=;
        b=pWTLkbbGEtNDtrm3rD4NWWjsaQw38ei5cVorDugu6Fvrd0uOQP0w5HS7a8cupu1qrd
         07M8e6pegf8p9hjNeMHuItr2vVhbTLetAXITGsU0kF2aNLJjWmObaHBclJDxqIP5+w84
         5VKQaWFJ+JPPPkMurk+WiXjvKD+2S1/75GG2SDMuZUOSVb8KjgIl84AdzQEqhI4fHd/n
         RH2d56PoiFG34d2T9tczUWbL5TC3Ea8pUKkPs/SCoAFnuAv1jRVBvlGFq+Km+xdEtlCt
         ngelPIf9oqIditoC6lwPXxWDBXWuuglgFqaLAWT5Kmwvo0/4MeNXZyzrm0MP1hKjeBxk
         N9bg==
X-Gm-Message-State: AFqh2kp50NxXkJxugaqWuENU+/85QBvyYIAFBY98Gd5AElzKGApLC+rZ
        6UmLxGIdT6j0updIGaOjZs9mYH65dvQPQ47Yx128/9IJCRFmF7F0b/v0bVIEhE/tvkjpC+cFksz
        zcRC0Zor3XIcj
X-Received: by 2002:adf:da43:0:b0:250:779a:7391 with SMTP id r3-20020adfda43000000b00250779a7391mr29791935wrl.47.1672913162372;
        Thu, 05 Jan 2023 02:06:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXslGiIC8LlWUvexD9DQVF/QXglT71Bff5vDHiNPVqNKVgctXDR1uE8+JWvwz1ZoveMRfeRsFA==
X-Received: by 2002:adf:da43:0:b0:250:779a:7391 with SMTP id r3-20020adfda43000000b00250779a7391mr29791923wrl.47.1672913162195;
        Thu, 05 Jan 2023 02:06:02 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-239.web.vodafone.de. [109.43.176.239])
        by smtp.gmail.com with ESMTPSA id r15-20020a0560001b8f00b002709e616fa2sm36058437wru.64.2023.01.05.02.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 02:06:01 -0800 (PST)
Message-ID: <6aac5837-221b-9f1a-347d-a44156c07bcb@redhat.com>
Date:   Thu, 5 Jan 2023 11:05:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Fix integer literal in skey.c
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230104175950.731988-1-nsg@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230104175950.731988-1-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/2023 18.59, Nina Schoetterl-Glausch wrote:
> The code is a 64bit number of which the upper 48 bits must be 0.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   s390x/skey.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 1167e4d3..7c7a8090 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -320,7 +320,7 @@ static void test_diag_308(void)
>   		"lr	%[response],%%r3\n"
>   		: [response] "=d" (response)
>   		: [ipib] "d" (ipib),
> -		  [code] "d" (5)
> +		  [code] "d" (5L)
>   		: "%r2", "%r3"
>   	);
>   	report(response == 0x402, "no exception on fetch, response: invalid IPIB");
> 
> base-commit: 73d9d850f1c2c9f0df321967e67acda0d2c305ea

Thanks, I've pushed it directly as a trivial fix.

  Thomas

