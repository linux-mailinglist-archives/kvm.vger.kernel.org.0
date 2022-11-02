Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BF1616AE8
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiKBRiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiKBRiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:38:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326BB2E688
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667410630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F9IV6/6rbdvffzBjqdciSaf9XsgMEpSMKZkoTczewlk=;
        b=CLzTTi6AkhB/K3FpwTfwMLN4vnRgM7Izwnhc0i3EzU00fRez1JMNjTjZBfyuEHSzu5L1UQ
        sPtwqknxru0zl0k3H9q9w76Z2q68sZnlFno/9/y1f9tuejsO2TxKHBMIPsHMh6sgS5lGnt
        n/VfhaaXY0tMb5U/NoSQWthErBQoHBg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-393-9LV25xxcO7OGga4Wfp6L6A-1; Wed, 02 Nov 2022 13:37:00 -0400
X-MC-Unique: 9LV25xxcO7OGga4Wfp6L6A-1
Received: by mail-ej1-f71.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso10338242ejb.14
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F9IV6/6rbdvffzBjqdciSaf9XsgMEpSMKZkoTczewlk=;
        b=1FqEM/cUyWLPhsmItzHYu2xuWE/cHeXuG7b0XBbsxjsLiDPE4ZF8+fkJ/Uz+obxlFH
         GNqBLhnuPzUqyDfE8MVPuGwhEQIE1l/IaPXu6GWy8+AlSGcqMDQpuStFSVfucUIIPG1t
         oxhwwoOEozm2V98/foBtKRYvG6tFXojvYA6+axEGbd6BnLwnnDp1/JF7GOxJ1XHE2Gis
         tiT8MBnDTdDe9tCLS6qU0FzUNd+h61GtJ0GaUZx4+Ce8159/Aj84N3Ozz3++LMdYu6Wv
         jR7LqGz4xi6l6DCPDpNZFPb0VjwNOUb5/+v7f4jZMxga/1CCzji+/mkaAOzefUocOCeI
         iPyQ==
X-Gm-Message-State: ACrzQf3x3Wa9GuJD+vFG953CRcUaRFArfhLPcrg0LVemTLeZUVJLnGbR
        przDskUWzj5s5A4aoRcX7MWSZpN51j8ys0fVBIgV47/7yh9H4k9nuaw2VaOvo32CN91vLtv++65
        OwQf8/24ZBfji
X-Received: by 2002:a05:6402:1ccd:b0:459:aa70:9e12 with SMTP id ds13-20020a0564021ccd00b00459aa709e12mr25657191edb.206.1667410614186;
        Wed, 02 Nov 2022 10:36:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5PIOCtcjdwI40WYnRXIy6XLVsdrMv9E+sINf5fBWFcuaO8MNwp4+TdCyqdMhowZzmRbhNAfA==
X-Received: by 2002:a05:6402:1ccd:b0:459:aa70:9e12 with SMTP id ds13-20020a0564021ccd00b00459aa709e12mr25657166edb.206.1667410613928;
        Wed, 02 Nov 2022 10:36:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id b23-20020a17090630d700b007ae0fde7a9asm203286ejb.201.2022.11.02.10.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:36:53 -0700 (PDT)
Message-ID: <768fcf2b-dc09-f9ba-249b-16fa7bd6e17d@redhat.com>
Date:   Wed, 2 Nov 2022 18:36:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] x86/pmu: Disable inlining of measure()
Content-Language: en-US
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
Cc:     Bill Wendling <isanbard@gmail.com>,
        Jim Mattson <jmattson@google.com>
References: <20220601163012.3404212-1-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220601163012.3404212-1-morbo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 18:30, Bill Wendling wrote:
> From: Bill Wendling <isanbard@gmail.com>
> 
> Clang can be more aggressive at inlining than GCC and will fully inline
> calls to measure(). This can mess with the counter overflow check. To
> set up the PMC overflow, check_counter_overflow() first records the
> number of instructions retired in an invocation of measure() and checks
> to see that subsequent calls to measure() retire the same number of
> instructions. If inlining occurs, those numbers can be different and the
> overflow test fails.
> 
>    FAIL: overflow: cntr-0
>    PASS: overflow: status-0
>    PASS: overflow: status clear-0
>    PASS: overflow: irq-0
>    FAIL: overflow: cntr-1
>    PASS: overflow: status-1
>    PASS: overflow: status clear-1
>    PASS: overflow: irq-1
>    FAIL: overflow: cntr-2
>    PASS: overflow: status-2
>    PASS: overflow: status clear-2
>    PASS: overflow: irq-2
>    FAIL: overflow: cntr-3
>    PASS: overflow: status-3
>    PASS: overflow: status clear-3
>    PASS: overflow: irq-3
> 
> Disabling inlining of measure() keeps the assumption that all calls to
> measure() retire the same number of instructions.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   x86/pmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a46bdbf4788c..bbfd268aafa4 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -211,7 +211,7 @@ static void stop_event(pmu_counter_t *evt)
>   	evt->count = rdmsr(evt->ctr);
>   }
>   
> -static void measure(pmu_counter_t *evt, int count)
> +static noinline void measure(pmu_counter_t *evt, int count)
>   {
>   	int i;
>   	for (i = 0; i < count; i++)

Queued, thanks.

Paolo

