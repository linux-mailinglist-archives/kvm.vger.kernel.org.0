Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0248A42F776
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 17:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241075AbhJOP7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 11:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233464AbhJOP7s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 11:59:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634313461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMrSHmEHXqrRGcdLpv53RMkgGFyce3geioBHOKMdLVU=;
        b=F3ePTPVGbEiANsD+0GzZJVj36jqsZJAnmk8+T0j7wEnH5B4DNGZVeSM09c6rz8vqimchdd
        fKLZABxe4+iKugOerykwaDFsRYx1yjmh0zXP+tD02iraD64kPAeIaJOQCOSnYb60yv7s9r
        Xjbs4ll9B0wIbWk7wb/ePUjIuTc5DTc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-5xhJ-DEQN3iXqWVQFgvMFA-1; Fri, 15 Oct 2021 11:57:40 -0400
X-MC-Unique: 5xhJ-DEQN3iXqWVQFgvMFA-1
Received: by mail-ed1-f71.google.com with SMTP id c30-20020a50f61e000000b003daf3955d5aso8653296edn.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 08:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gMrSHmEHXqrRGcdLpv53RMkgGFyce3geioBHOKMdLVU=;
        b=eXFOSA8E3Ko3hl9KzT10PQF3DUeqmHBXh/cqV6ENbtwIRT/PzY9s+Q0tQvF07wDBUx
         TXs5ULRgdoWaX1xs+dkP7dTS2YFUXFiNF60IqcYFB8Dca/10Dtx6qcBufDyyqMU92O8W
         jq4GdOpiRMxlFCym4pgwCNQAxhdpbv673RzxuLHIXrF7wDLH2T+wAhESPtIRl7/Q5q9m
         UTpANF8CMEEz7bjToSSrZWNLcWRjaOrWvjszPjtgeW13SO82kzqA81G2b5n0kPLX9oii
         ZrRUbaF68W/7jVZzq5sGO+ibgf5zP/zjR+/umrXYC+YiCDgX+mD29ZbyV/JNX7IHRL1f
         OSCQ==
X-Gm-Message-State: AOAM531DI+Pn7uDIVRFOLsQ9DOPTVcYcL5Fy/ZtD+bXnHxmohLLO7stl
        doaCKHDQ5Db8QRGT+LkZ1BKiAuQ73LrOIJazuR5JGM6EV2VLiyHSuBF6bYDWDnLvGdmURizdkMt
        CytVwVyeRexsT
X-Received: by 2002:a05:6402:11cf:: with SMTP id j15mr18697653edw.232.1634313459167;
        Fri, 15 Oct 2021 08:57:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvIgegLc+Pa9JmmQ+SCnKAcCqmOldCrjxzYzqYzfWuYz81NbG9P5QZ7zDZdNIFVvpDV8on8A==
X-Received: by 2002:a05:6402:11cf:: with SMTP id j15mr18697630edw.232.1634313458925;
        Fri, 15 Oct 2021 08:57:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m6sm4685848ejl.42.2021.10.15.08.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 08:57:38 -0700 (PDT)
Message-ID: <8df06ec3-85a7-caae-04dc-6096de632e6f@redhat.com>
Date:   Fri, 15 Oct 2021 17:57:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v2 3/3] x86/msr.c generalize to any input
 msr
Content-Language: en-US
To:     ahmeddan@amazon.com, kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        drjones@redhat.com, graf@amazon.com
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
 <20210927153028.27680-1-ahmeddan@amazon.com>
 <20210927153028.27680-3-ahmeddan@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210927153028.27680-3-ahmeddan@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/21 17:30, ahmeddan@amazon.com wrote:
> From: Daniele Ahmed <ahmeddan@amazon.com>
> 
> If an MSR description is provided as input by the user,
> run the test against that MSR. This allows the user to
> run tests on custom MSR's.
> 
> Otherwise run all default tests.
> 
> This is to validate custom MSR handling in user space
> with an easy-to-use tool. This kvm-unit-test submodule
> is a perfect fit. I'm extending it with a mode that
> takes an MSR index and a value to test arbitrary MSR accesses.
> 
> Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>

Queued, thanks.  I removed the "64-bit only" functionality because, for 
manual invocation, you can just not run the test when running on 32-bit 
targets.

Paolo

> ---
>   x86/msr.c | 29 +++++++++++++++++++++++++++--
>   1 file changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/msr.c b/x86/msr.c
> index 8931f59..1a2d791 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -3,6 +3,17 @@
>   #include "libcflat.h"
>   #include "processor.h"
>   #include "msr.h"
> +#include <stdlib.h>
> +
> +/**
> + * This test allows two modes:
> + * 1. Default: the `msr_info' array contains the default test configurations
> + * 2. Custom: by providing command line arguments it is possible to test any MSR and value
> + *	Parameters order:
> + *		1. msr index as a base 16 number
> + *		2. value as a base 16 number
> + *		3. "0" if the msr is available only in 64b hosts, any other string otherwise
> + */
>   
>   struct msr_info {
>   	int index;
> @@ -100,8 +111,22 @@ int main(int ac, char **av)
>   	bool is_64bit_host = this_cpu_has(X86_FEATURE_LM);
>   	int i;
>   
> -	for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
> -		test_msr(&msr_info[i], is_64bit_host);
> +	if (ac == 4) {
> +		char msr_name[16];
> +		int index = strtoul(av[1], NULL, 0x10);
> +		snprintf(msr_name, sizeof(msr_name), "MSR:0x%x", index);
> +
> +		struct msr_info msr = {
> +			.index = index,
> +			.name = msr_name,
> +			.is_64bit_only = !strcmp(av[3], "0"),
> +			.value = strtoull(av[2], NULL, 0x10)
> +		};
> +		test_msr(&msr, is_64bit_host);
> +	} else {
> +		for (i = 0 ; i < ARRAY_SIZE(msr_info); i++) {
> +			test_msr(&msr_info[i], is_64bit_host);
> +		}
>   	}
>   
>   	return report_summary();
> 

