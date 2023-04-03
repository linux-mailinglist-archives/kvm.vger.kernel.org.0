Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4896D3FB4
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjDCJIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjDCJIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:08:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264887687
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:08:46 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so13882165wms.5
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 02:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680512924;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ueHhr9Rx4c5lpA6R8+EcHcQ/2UhpEkDm3l41P08jek=;
        b=fX7p5lrLC/7UNb4Q3GJsDRTm6NNgCP8/+AKG5tBZsawce2rXSsxci1zOS6i6ow2EKm
         CR5xLo6eFH1e/apuQ8XX17U4nlv9/+r/tIBmpZr3x/w4mV50dNjUw9IFv4nTXvs0h42Q
         Acr+IR4a15EEnJIDNM5Ebg8PqqGisx9XqE4ryIMpCHyToiPvVWfz1a0Do/8lNREJM55u
         0f8tosIDmrXGMZQ97Xh21/S9ULfYjmwsD+dLGEMoh1HOGfoPqeLnSB6SmV41h3lwipmq
         ve8HCdXlocg6csalOgKj08yyjaqCvm7ooiXARYkk8ehDBp+arobJxHD8U7TZ1t0W0wXQ
         6x4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680512924;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ueHhr9Rx4c5lpA6R8+EcHcQ/2UhpEkDm3l41P08jek=;
        b=QKmQRP+yIlb/mY/6kg6gwA1pF+lo6ROeHaouAuTrrSgoM2Pfg1ci2nhjEvhn5l5e4E
         esHrgmdxVZbFJRtEULuuhPmkZO5X7faUKOaURu/OkY5veKUv4gNYlRR9eXrX1B72VPg2
         1tubkU1RRCKVpUBwiQLWg3BdIHiNs+QCJ9hThhaGcOmKNFGQS8QNJ0/Uz46A4OZd7zXm
         zwZ+PI9KqPq1qNLGkx3kzMBJvthuPaR1cBHEsQ2RkUjaeOC0LNrACqq0iC1ZSpKONLmh
         hHgcLKe4EEOuU3okzh0pAnt2GeYXRLiIVuRpBwYhzFtIG5HYsJ5EMD2LOZ+u9MdEf3qv
         2GfQ==
X-Gm-Message-State: AO0yUKXEtm6K5QoRIWe5bDzn6vdAnAKRoR3w3QuS7ymlDFB/eU/AYJXs
        73GKo9pBb7XsGkdGsxPFzZ+6Ic8YSCbT1ZlpEpNKCg==
X-Google-Smtp-Source: AK7set8X8iHyqegYJCwi9EFrxzGgYaxsJwn0wq+nWzGwtkL1rzWqDTXA3CPVCimobyBAhmo/+h58jg==
X-Received: by 2002:a7b:c404:0:b0:3ed:70df:37 with SMTP id k4-20020a7bc404000000b003ed70df0037mr26604545wmi.21.1680512924635;
        Mon, 03 Apr 2023 02:08:44 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:1600:2f4c:bf50:182f:1b04? (p200300f6af2216002f4cbf50182f1b04.dip0.t-ipconnect.de. [2003:f6:af22:1600:2f4c:bf50:182f:1b04])
        by smtp.gmail.com with ESMTPSA id q3-20020a05600c46c300b003eddc6aa5fasm18906754wmo.39.2023.04.03.02.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 02:08:44 -0700 (PDT)
Message-ID: <b261f377-39ec-73a6-45ad-bd19711625ff@grsecurity.net>
Date:   Mon, 3 Apr 2023 11:08:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v2 3/4] x86/access: Forced emulation
 support
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230331135709.132713-1-minipli@grsecurity.net>
 <20230331135709.132713-4-minipli@grsecurity.net>
 <ZCcJJoe2OhReyV7X@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCcJJoe2OhReyV7X@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.03.23 18:24, Sean Christopherson wrote:
> On Fri, Mar 31, 2023, Mathias Krause wrote:
>> Add support to enforce access tests to be handled by the emulator, if
>> supported by KVM. Exclude it from the ac_test_exec() test, though, to
>> not slow it down too much.
> 
> /enthusiastic high five

*clap*

> 
> I was going to ask if you could extend the test to utilize FEP, and woke up this
> morning to see it already done.  Thanks!!!!!
> 
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
> 
> ...
> 
>> @@ -152,6 +161,7 @@ const char *ac_names[] = {
>>  	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
>>  	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
>>  	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
>> +	[AC_FEP_BIT] = "fep",
>>  };
>>  
>>  static inline void *va(pt_element_t phys)
>> @@ -190,6 +200,7 @@ typedef struct {
>>  
>>  static void ac_test_show(ac_test_t *at);
>>  
>> +static bool fep_available;
> 
> I don't think fep_available needs to be captured in a global bool, the usage in
> the CR0_WP test can do
> 
> 	if (invalid_mask & AC_FEP_MASK)
> 		<skip>

Ok, makes it a little uglier, IMHO, but will change.

Again, I was just looking at other tests and copied what I thought was
sensible. But looking at x86/emulator.c again, I see it's not consistent
either. It caches the value in test_mov_pop_ss_code_db() but does not in
main().

Maybe I should just use is_fep_available() twice as well, as the
additional exception handling shouldn't matter much.

Thanks,
Mathias
