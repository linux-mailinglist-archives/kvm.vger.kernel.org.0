Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516CD478CA5
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 14:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbhLQNrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 08:47:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234090AbhLQNrG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 08:47:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639748826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mcgkakOKyThMrqn8rgzoaYc4Z8VMoPj4tSG9E7dWGCs=;
        b=HMDbnm7R5yCJTnAey55y2zFlIGhqxwpJkDV2Q6yWlN5ne0s6brgaP3WJamo9pf2hN2B43K
        76E8Wm/b8c40D7dRlYkZZSb41MvL2dM22eMlDz94R9JpW6kg79XsJ+ErnqZBASCRYwsPoJ
        9FjY5Ibno+IilXjXi8BiMwSSBbAltCY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-veuSNcKePVmnXu5KEZF9rQ-1; Fri, 17 Dec 2021 08:47:04 -0500
X-MC-Unique: veuSNcKePVmnXu5KEZF9rQ-1
Received: by mail-wm1-f70.google.com with SMTP id b75-20020a1c804e000000b0034569bde713so2962097wmd.9
        for <kvm@vger.kernel.org>; Fri, 17 Dec 2021 05:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mcgkakOKyThMrqn8rgzoaYc4Z8VMoPj4tSG9E7dWGCs=;
        b=bghw2SZ9e7YeoSetbxzKzDhrBllO7M4wUnMSTwAkW4oeWiS/76JNr4msRLb5A0aOFC
         cJwMRWnbKDCQzB9wY+lDC8Il6cKuYw/5nVUPoom1xPrT9bFhP2eUrmsELlL+fg9zj07v
         DmqKaIDp48U+/fS6HbN9SSq71SvZH+ofBhaPsm6bruRYn6KKjIvQMLzbGXnbuP36q75s
         mKsBN/GYgd77saGUp5h7r2zzJrjtHJndeL0K5ibL/4XaPHPe/BAUwjioSp5TG/YCaqIj
         766G0rErt7d56hR3/W+S0lI1SPELibNjAB3hIyDhGDC8XUVvSn2Lb7WFPMlH5+2JPCej
         09Kw==
X-Gm-Message-State: AOAM530AUs//bHNwxeasmJ3d6MpIXYkMx8NAbqfx60SZigg8XwScCvYA
        JRNNzknheqf8nhwgCY3RvY5LwVcS3avf2jJiGc6qmvlEJTD+22KZvpt4VXkPrkk5E9lQkwgn7LL
        eZ8egDoVs2kQB
X-Received: by 2002:a5d:460c:: with SMTP id t12mr2705838wrq.484.1639748823829;
        Fri, 17 Dec 2021 05:47:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6BI7Ko1cjEUvdLQ7fA0fVlXkLWEnIr7gn+2V7NlGDXFN0+GvFKyKPUVLXtYZkPNlSgnydQw==
X-Received: by 2002:a5d:460c:: with SMTP id t12mr2705821wrq.484.1639748823589;
        Fri, 17 Dec 2021 05:47:03 -0800 (PST)
Received: from [192.168.2.110] (p54886ae3.dip0.t-ipconnect.de. [84.136.106.227])
        by smtp.gmail.com with ESMTPSA id k13sm7372552wri.6.2021.12.17.05.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 05:47:03 -0800 (PST)
Message-ID: <3e2035bd-0929-488c-28f3-d8256bec14a4@redhat.com>
Date:   Fri, 17 Dec 2021 14:47:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH kvm-unit-tests 1/2] s390x: diag288: Add missing clobber
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, frankja@linux.ibm.com
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
 <20211217103137.1293092-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211217103137.1293092-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/2021 11.31, Nico Boehr wrote:
> We clobber r0 and thus should let the compiler know we're doing so.
> 
> Because we change from basic to extended ASM, we need to change the
> register names, as %r0 will be interpreted as a token in the assembler
> template.
> 
> For consistency, we align with the common style in kvm-unit-tests which
> is just 0.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/diag288.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/diag288.c b/s390x/diag288.c
> index 072c04a5cbd6..da7b06c365bf 100644
> --- a/s390x/diag288.c
> +++ b/s390x/diag288.c
> @@ -94,11 +94,12 @@ static void test_bite(void)
>   	/* Arm watchdog */
>   	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
>   	diag288(CODE_INIT, 15, ACTION_RESTART);
> -	asm volatile("		larl	%r0, 1f\n"
> -		     "		stg	%r0, 424\n"
> +	asm volatile("		larl	0, 1f\n"
> +		     "		stg	0, 424\n"

Would it work to use %%r0 instead?

>   		     "0:	nop\n"
>   		     "		j	0b\n"
> -		     "1:");
> +		     "1:"
> +		     : : : "0");
>   	report_pass("restart");
>   }

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

