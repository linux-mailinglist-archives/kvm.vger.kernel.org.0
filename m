Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBFB1A351A
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgDINss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 09:48:48 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36236 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726621AbgDINss (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 09:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586440127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HL0WqxG+/LDNhffOus2cXeJAbUJD4UU/um/UQsUeAkw=;
        b=KM6fesfIPvsS0bXzK9TcWR+VkLJSQBcqfOaU9haF/zceq3C6gY8CvUxsKAYSTqcaXjRPvs
        l8PedXiDu2kxzN4pedH3tHxH7E54fll8eQeBUWWL2/VKvUxYC8kiMqGBsDSopoV8jUn9y4
        ThRcefknzU8uQIK8n3+kda4TTujMxt4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-13cD1wRUNy6dPfKcJc6F3g-1; Thu, 09 Apr 2020 09:48:41 -0400
X-MC-Unique: 13cD1wRUNy6dPfKcJc6F3g-1
Received: by mail-wm1-f70.google.com with SMTP id y1so1876946wmj.3
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 06:48:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HL0WqxG+/LDNhffOus2cXeJAbUJD4UU/um/UQsUeAkw=;
        b=aUpvhcQ5XVIl/T/TTKULOU0t6hWwxWeRSZLafln7IM+dQwVgdXE6FNk6xWWYfelx35
         LMC9t8pFdaY355Po2+Q3sPG2iV7F9BU5JNiAcDJWK85bWgKe0K6icwlmTFRXcI2RPUcG
         Fyy9cp5BzaP4KYf2NEmVwSdSSvZhbnAfKDBHAdeyJXfUZQLDunFchJ4lsN2QSDCXpKNj
         44T9nfajQjkJvjHx8rlMVTjhoAFfgW7EyPJ4ICZZ/SzAdQCUB15QtIqaSdvdOF4nyASH
         f94kBY0OKg63M56l5EFSpYhLDy57qYBciOIs3rzLrPT+4/uSXvJApjFJ/M2NMWG8SGB+
         KQUg==
X-Gm-Message-State: AGi0PuZMUJQVTyGXvtGUQzP7Hv5hBCJdKfSyA1wnY5l90oTFyAaGI4Vx
        EDnKgCpX1CepErATVxM0qqbvIR70uQzRQAeaf1fJsHKcAywRpZmIrhx9ocmis2pC+er3tNKSYRz
        91ng+ku3GiSFx
X-Received: by 2002:a1c:6a1a:: with SMTP id f26mr10243189wmc.170.1586440120366;
        Thu, 09 Apr 2020 06:48:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypIFUjEZvGgHXpyHkvqOi4FbFCrxx9WvmBM5jSkLAs2czMX8P907Ka8rJzI4GWLu0fkRplFwcQ==
X-Received: by 2002:a1c:6a1a:: with SMTP id f26mr10243169wmc.170.1586440120168;
        Thu, 09 Apr 2020 06:48:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id k185sm3925972wmb.7.2020.04.09.06.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 06:48:39 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 0/2] svm: NMI injection and HLT tests
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20200409133247.16653-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d0430a4-b97e-73d5-3306-3130964f5df2@redhat.com>
Date:   Thu, 9 Apr 2020 15:48:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409133247.16653-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 15:32, Cathy Avery wrote:
> Patch 1 is NMI injection and intercept. Patch 2 is the same test with guest in
> HLT.
> 
> Cathy Avery (2):
>   svm: Add test cases around NMI injection
>   svm: Add test cases around NMI injection with HLT
> 
>  x86/svm_tests.c | 187 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 187 insertions(+)
> 

Looks good, apart from one nit in patch 1.  Using the LAPIC timer could
have been an alternative (which would also let the HLT test run on
uniprocessor guests), but there is certainly no issue with using an IPI
and making things a little more varied. :)

Paolo

