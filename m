Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AE86377BD
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiKXLex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 06:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiKXLeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 06:34:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB1C950CE
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669289638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vR4mMWp6eKt3AWmfc1Ojr0iAuojOM3p4Urp6WaNOTDw=;
        b=SWHa5wNdLfN9VbElrsfEygwmVEXnWR7xgT7NA+FESltCCFjYoYbJCCIj7r0VKoGb2PCiPv
        qbJDCEqOlg0gcxQCtRFN3IlYaLfyn8oralj/RMjxqBcKh1/a2kXbkU2jrOm8FgDwI4EhFn
        EFmSuxPQyLvx46Au8vaKCKDD5UusjtM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-BlWBobX6NMGpU51b19Kakg-1; Thu, 24 Nov 2022 06:33:57 -0500
X-MC-Unique: BlWBobX6NMGpU51b19Kakg-1
Received: by mail-wr1-f69.google.com with SMTP id h2-20020adfa4c2000000b00241cf936619so331783wrb.9
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 03:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vR4mMWp6eKt3AWmfc1Ojr0iAuojOM3p4Urp6WaNOTDw=;
        b=YAzzEZi1rUJtTl5NTLmmiECzdG7UERm44T+i5dJGhwHpN4MhpHphqGmCgNQ5g2hweI
         8egTGbFAGRxVBXfVEc9Wmj/tkwbqp1vN/JOCoC6pYmMyIlodPJG+i+gSqOuy3y1PhsBh
         GJYiy5Zq3CIc0p0OPAdPtCrl1kJSA6gbZvJeeqCOTdn4UzfdaPw1/zIM1fpu8QULbiJl
         a8r3Nm+cqbHCy3iPuPI122moohuY60lvongbe5iV2iIjr3QQO99az0779ttqLwzAHpbw
         NSjXMp9pFbLbELO2DUs2sXa42YEj8ZvEIQMkD0gfYDIqrFpHAo2pgsEISYyXaGslrSaH
         i7Rw==
X-Gm-Message-State: ANoB5plqPiCf1vN0DInBp9uowGVQxuqaIC7Kf6Rd7JFknXvyQdpbaIfh
        s7jFytpcp7bo1O9xJix0GrgDcjWJj+dZalpz+OnJcDtiiV+YSUin39tZ7XOxEncgjac72C7ut8z
        WmZ6Td36h9Hvz
X-Received: by 2002:adf:ef89:0:b0:22a:f477:7bb6 with SMTP id d9-20020adfef89000000b0022af4777bb6mr19814742wro.390.1669289636119;
        Thu, 24 Nov 2022 03:33:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7DcCWEvaVSwET6Kvi6qcuktYLqtN9rdF5DK+VRGqZYC6SffdcOpX0q3vwEjcYwFC6uhsnvKA==
X-Received: by 2002:adf:ef89:0:b0:22a:f477:7bb6 with SMTP id d9-20020adfef89000000b0022af4777bb6mr19814732wro.390.1669289635887;
        Thu, 24 Nov 2022 03:33:55 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-190.web.vodafone.de. [109.43.177.190])
        by smtp.gmail.com with ESMTPSA id l19-20020a056000023300b00241de5be3f0sm1114354wrz.37.2022.11.24.03.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 03:33:55 -0800 (PST)
Message-ID: <b112d219-adda-b2ac-da74-d00534ec5c04@redhat.com>
Date:   Thu, 24 Nov 2022 12:33:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v5 11/27] x86/pmu: Update rdpmc testcase to
 cover #GP path
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
References: <20221102225110.3023543-1-seanjc@google.com>
 <20221102225110.3023543-12-seanjc@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221102225110.3023543-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/11/2022 23.50, Sean Christopherson wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Specifying an unsupported PMC encoding will cause a #GP(0).
> 
> There are multiple reasons RDPMC can #GP, the one that is being relied
> on to guarantee #GP is specifically that the PMC is invalid. The most
> extensible solution is to provide a safe variant.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   lib/x86/processor.h | 21 ++++++++++++++++++---
>   x86/pmu.c           | 10 ++++++++++
>   2 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index f85abe36..ba14c7a0 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -438,11 +438,26 @@ static inline int wrmsr_safe(u32 index, u64 val)
>   	return exception_vector();
>   }
>   
> +static inline int rdpmc_safe(u32 index, uint64_t *val)
> +{
> +	uint32_t a, d;
> +
> +	asm volatile (ASM_TRY("1f")
> +		      "rdpmc\n\t"
> +		      "1:"
> +		      : "=a"(a), "=d"(d) : "c"(index) : "memory");
> +	*val = (uint64_t)a | ((uint64_t)d << 32);
> +	return exception_vector();
> +}
> +
>   static inline uint64_t rdpmc(uint32_t index)
>   {
> -	uint32_t a, d;
> -	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
> -	return a | ((uint64_t)d << 32);
> +	uint64_t val;
> +	int vector = rdpmc_safe(index, &val);
> +
> +	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
> +		   exception_mnemonic(vector), index);
> +	return val;
>   }

Seems like this is causing the CI to fail:

https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3339274319#L1260

I guess you have to use PRId32 here? Could you please send a patch?

  Thanks,
   Thomas


