Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CFE5A6349
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiH3M1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiH3M1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:27:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5098FD6D
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 05:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661862462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0wGTB9LFd8O3OQX6VCV8VsTwQxbK1zUmkJN478H5liE=;
        b=X/zcUStkkC1o0tGo+TpCt4R2IeuSCuUaYu27nzDdNoahh2W+/UCV9C46XHyA9xYJgPcYM9
        a7yd4/XIOxz5cgZDbKRhNbhQ9SCRy1HkXaSRf4AzX+rqgl1yXvR68vnG7oIppqXtDogjlf
        7ZFiG4vYZ+E/IvOVS1ICkDM6EGpOD2M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-424--p1VGdoINdWzspyYWrNMtg-1; Tue, 30 Aug 2022 08:27:33 -0400
X-MC-Unique: -p1VGdoINdWzspyYWrNMtg-1
Received: by mail-wm1-f70.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so10030307wmq.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 05:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=0wGTB9LFd8O3OQX6VCV8VsTwQxbK1zUmkJN478H5liE=;
        b=zpcigASONfPwQIWDXgJt07iBxsIfGle+6fdvMJmktd7AxdBOHtlTckh2CfILHEdain
         0lwd1Ks+ZYNyvk8Yf13lDAM5qTLdeKEo4q8PuIQ7dvKVk01zhoR0P64LTyZCUgwKgKAy
         VvdcrUpafB1NljJJUUauCuV0KqAhkfRo8euwj/OTigrPWuEiY8Ll8gXPNoXroECUE85U
         a+6cLw+Udhr5pwVU6szWEMmnoP6A2E2HJAK3STLXdFKOfvdDxy3jLTT4R2Kodcwz4Zht
         mkjS2lXEsHurhpEltTgHQGnRdPWAqbBnJ2quqs5Ttev4G/2oNswpq3NSDwRU7sWJuJts
         K1Rg==
X-Gm-Message-State: ACgBeo113QYU3G9XXH4MmcYB45JQnS7kCctzm8UIOkV2mmjLE15eFlKH
        LJiQDslHQCyLqUbOQfGPHXMWN1m2vxx8MVZeMcH95BF2ivPzGmLkqCZwiwK3XV5001lOcE49ZJ7
        bjBo0er12WSUw
X-Received: by 2002:adf:a447:0:b0:226:133a:907a with SMTP id e7-20020adfa447000000b00226133a907amr9193781wra.250.1661862452444;
        Tue, 30 Aug 2022 05:27:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7V/2Muy1TsPe0NqPrmDvdajHgQR8Z5aWTacV/SFEn+39QU9cpdmgkolLyttcpPOo6tBRFjcw==
X-Received: by 2002:adf:a447:0:b0:226:133a:907a with SMTP id e7-20020adfa447000000b00226133a907amr9193774wra.250.1661862452247;
        Tue, 30 Aug 2022 05:27:32 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-96.web.vodafone.de. [109.43.176.96])
        by smtp.gmail.com with ESMTPSA id n1-20020a05600c4f8100b003a5c064717csm13549463wmq.22.2022.08.30.05.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 05:27:31 -0700 (PDT)
Message-ID: <2867caf0-b944-6cf5-f0f5-2af5706feb49@redhat.com>
Date:   Tue, 30 Aug 2022 14:27:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib/s390x: time: add wrapper for
 stckf
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220830115623.515981-1-nrb@linux.ibm.com>
 <20220830115623.515981-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220830115623.515981-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/2022 13.56, Nico Boehr wrote:
> Upcoming changes will do performance measurements of instructions. Since
> stck is designed to return unique values even on concurrent calls, it is
> unsuited for performance measurements. stckf should be used in this
> case.
> 
> Hence, add a nice wrapper for stckf to the time library.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/asm/time.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..d7c2bcb4f306 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -14,6 +14,15 @@
>   #define STCK_SHIFT_US	(63 - 51)
>   #define STCK_MAX	((1UL << 52) - 1)
>   
> +static inline uint64_t get_clock_fast(void)
> +{
> +	uint64_t clk;
> +
> +	asm volatile(" stckf %0 " : : "Q"(clk) : "memory");
> +
> +	return clk;
> +}

Using clk as input parameter together with memory clobbing sounds like a bad 
solution to me here. The Linux kernel properly uses it as output parameter 
instead:

static inline unsigned long get_tod_clock_fast(void)
{
         unsigned long clk;

         asm volatile("stckf %0" : "=Q" (clk) : : "cc");
         return clk;
}

(see arch/s390/include/asm/timex.h in the kernel sources)

As you can see, also the "cc" should be in the clobber list here.

  Thomas

