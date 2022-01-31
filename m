Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871C44A48CC
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 14:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379197AbiAaNzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 08:55:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379186AbiAaNzN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 08:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643637313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fx5MwJXI9jbSRmK3ke19dRUQnHx+DgTcMNZi7bzIlow=;
        b=UNnXvcCmFgxbPH0uBRNQEsYpdSgSVk2zNWuyjLKnW9XD1bg3/k6/sMsk+y4LXHm8BEKRq3
        Xo82LsYA119Xot+teyMix4oBZZwmx6Hf8qu+4s61idJmF0Og8Lge7Us/8M42jPCbCa/wk7
        xdmr9ryu/mHD6pru1f2Gnea4NWUguZ8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-yW3Rqw_RPUOQ4jCVW-u1dw-1; Mon, 31 Jan 2022 08:55:11 -0500
X-MC-Unique: yW3Rqw_RPUOQ4jCVW-u1dw-1
Received: by mail-ed1-f72.google.com with SMTP id n7-20020a05640205c700b0040b7be76147so2467674edx.10
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 05:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=fx5MwJXI9jbSRmK3ke19dRUQnHx+DgTcMNZi7bzIlow=;
        b=LhjE9FlJMPlri8/IsOK7UyBKECJYpTRNqFWUMGDY3WAiGER22HnQVwDeNAw9bdA2ZY
         TzhezaHwtL3aVHxjAXyrMFAnrI5VitIm+3Yz4Xltsj3k2UIdf4RLNYsZBDKr9zEJuCgl
         xLRHxmxNLBmHBqYu2L1d3ngIyYp33Yeoe8IK8r6alBUKn2SYIXK5BdhdcL5yrhvziYl8
         5bghqklhCspvONz2J6YFaqzmEhZDdSLyvDtYcMxFZPTjFZhg0Od26k7EbptdB9FMHJz5
         M8Xus8GBLTTWak0cUdPx8IpjNmRIZ7VrH30RzHMjVJRCvbneD5KsCnU63lmNBPYolVm1
         uXSA==
X-Gm-Message-State: AOAM531Knv/qawQOLdXv0QeE/y8mxqztQIsAVSIyujrGWyfhSqzfYVss
        6WPOzqry6IfMAoiQjxCTFYj5o3uRUbG2CptO8/VxvFozVBwT0sQgYV7Bwmgy36lK3Mn5iuixcGo
        CL25V+1f8h5YC
X-Received: by 2002:aa7:c156:: with SMTP id r22mr20573671edp.106.1643637310646;
        Mon, 31 Jan 2022 05:55:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwz1TJMW51rRDjDdFNRPZUi18fpOMSURaTf/YE5trxTOk2OClTWFpXQbzVG6oTKK7/pP0vxdg==
X-Received: by 2002:aa7:c156:: with SMTP id r22mr20573657edp.106.1643637310487;
        Mon, 31 Jan 2022 05:55:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:b200:f007:5a26:32e7:8ef5? (p200300cbc709b200f0075a2632e78ef5.dip0.t-ipconnect.de. [2003:cb:c709:b200:f007:5a26:32e7:8ef5])
        by smtp.gmail.com with ESMTPSA id fn3sm13443016ejc.58.2022.01.31.05.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 05:55:09 -0800 (PST)
Message-ID: <f99fc058-03fa-3bb7-7520-4cea7fd9a004@redhat.com>
Date:   Mon, 31 Jan 2022 14:55:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH v1 2/5] lib: s390x: smp: guarantee that
 boot CPU has index 0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
 <20220128185449.64936-3-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220128185449.64936-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.01.22 19:54, Claudio Imbrenda wrote:
> Guarantee that the boot CPU has index 0. This simplifies the
> implementation of tests that require multiple CPUs.
> 
> Also fix a small bug in the allocation of the cpus array.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: f77c0515 ("s390x: Add initial smp code")
> Fixes: 52076a63 ("s390x: Consolidate sclp read info")
> ---
>  lib/s390x/smp.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 64c647ec..01f513f0 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -25,7 +25,6 @@
>  #include "sclp.h"
>  
>  static struct cpu *cpus;
> -static struct cpu *cpu0;
>  static struct spinlock lock;
>  
>  extern void smp_cpu_setup_state(void);
> @@ -81,7 +80,7 @@ static int smp_cpu_stop_nolock(uint16_t addr, bool store)
>  	uint8_t order = store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
>  
>  	cpu = smp_cpu_from_addr(addr);
> -	if (!cpu || cpu == cpu0)
> +	if (!cpu || addr == cpus[0].addr)
>  		return -1;
>  
>  	if (sigp_retry(addr, order, 0, NULL))
> @@ -205,7 +204,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>  	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
>  
>  	/* Copy all exception psws. */
> -	memcpy(lc, cpu0->lowcore, 512);
> +	memcpy(lc, cpus[0].lowcore, 512);
>  
>  	/* Setup stack */
>  	cpu->stack = (uint64_t *)alloc_pages(2);
> @@ -263,15 +262,16 @@ void smp_setup(void)
>  	if (num > 1)
>  		printf("SMP: Initializing, found %d cpus\n", num);
>  
> -	cpus = calloc(num, sizeof(cpus));
> +	cpus = calloc(num, sizeof(*cpus));
>  	for (i = 0; i < num; i++) {
>  		cpus[i].addr = entry[i].address;
>  		cpus[i].active = false;
>  		if (entry[i].address == cpu0_addr) {
> -			cpu0 = &cpus[i];
> -			cpu0->stack = stackptr;
> -			cpu0->lowcore = (void *)0;
> -			cpu0->active = true;
> +			cpus[i].addr = cpus[0].addr;

Might deserve a comment that we'll move the the boot CPU to index 0.

What's the expected behavior if i == 0?

-- 
Thanks,

David / dhildenb

