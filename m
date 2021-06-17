Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5703ABBED
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 20:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhFQSjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 14:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230151AbhFQSjl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 14:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623955052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38MaJWJ06cbFFpdxNfvYHb//Q8oPQ4mle+cdo+ubdpE=;
        b=GKC9ouvFQPGOdD9dPv7wmYq3rWaKBYxwvY4g2QGpTp+4/egnsE24T5CQbpweWEuj2YrVSB
        wkLuehzw5K3JVraNoqWXcZ22ANJ10/S1UAFPdU73k4W3w6KN6EVVKMr5zOJ2RXkBIYNjv0
        92T1k3rAuWXuAEIvLbcSB4kdjq1EVtk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-DVFDQ9BOOTC_EwznObduDw-1; Thu, 17 Jun 2021 14:37:31 -0400
X-MC-Unique: DVFDQ9BOOTC_EwznObduDw-1
Received: by mail-ej1-f71.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so2807526ejz.5
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 11:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=38MaJWJ06cbFFpdxNfvYHb//Q8oPQ4mle+cdo+ubdpE=;
        b=ZVjRX8jBUcGCfm6H87ZtfbnRjJNodYVsP/OSiNaorUZoqG+XXKbVQaYcYydz7U+QXZ
         SRZvoQV+GvflYl7YdJFUd3Xgm1jAVBjAazKv3u7/5lQY90B3zpU08lx+hp4wmZz2y51x
         9fkMfyg29gYVADi/pFruRW7K48FOJr0dH6RLwgbP5EkDkPm3Rw6h0OMw8ZAsXMRp0D/X
         k09V5S4Vn2G60aCt0l56Jutbaq08YRF2skBRsR4P9U4Ns4YlHtZaWlfxuRiMfPF2+MxU
         9cI2xmECjxkIxjPn+/3Nmyf5OGVVsUAPLCHj/zajrNVRtWxEtckYEER17uG6+R0x4iyR
         NfQw==
X-Gm-Message-State: AOAM5338Fw5ErMaCcVyN4p9IFp4DwMH5h/AKwLd4M4cl8vs0Bdn0cc2w
        TOQd6kZXeYCl2HGaFtvSnxahk74HftulLGVbkRdr2tiR+xxRKHoyrqjXXjjSU2voaQBFB2leLSS
        EZkv3ZZsYEYxHesw0W6oDPBByz4MYyruE93EXcepwl/lr5Ze3j9Us+y9nPK4y3xZn
X-Received: by 2002:a17:906:a296:: with SMTP id i22mr4516468ejz.520.1623955050172;
        Thu, 17 Jun 2021 11:37:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHjTTLjoGKfMSJ1nfvQ0psFNX1MDRLyKNAl5pxJTxmas2GBGI6EQSepWSPrO5YHb7VI/VQhA==
X-Received: by 2002:a17:906:a296:: with SMTP id i22mr4516456ejz.520.1623955050027;
        Thu, 17 Jun 2021 11:37:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d25sm4947575edu.83.2021.06.17.11.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 11:37:29 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Flush the TLB after setting user-bit
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20210617101543.180792-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3043f67d-4745-f1a4-0681-09b1f7d9efe5@redhat.com>
Date:   Thu, 17 Jun 2021 20:37:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210617101543.180792-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/21 12:15, Nadav Amit wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> According to Intel SDM 4.10.4.3 "Optional Invalidation": "If CR4.SMEP =
> 0 and a paging-structure entry is modified to change the U/S flag from 0
> to 1, failure to perform an invalidation may result in a "spurious"
> page-fault exception (e.g., in response to an attempted user-mode
> access) but no other adverse behavior."
> 
> The access test actually causes in certain environments a spurious
> page-fault. So invalidate the relevant PTE after setting the user bit.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   x86/access.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 0ad677e..47807cc 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -216,8 +216,12 @@ static unsigned set_cr4_smep(int smep)
>       if (smep)
>           ptl2[2] &= ~PT_USER_MASK;
>       r = write_cr4_checking(cr4);
> -    if (r || !smep)
> +    if (r || !smep) {
>           ptl2[2] |= PT_USER_MASK;
> +
> +	/* Flush to avoid spurious #PF */
> +	invlpg((void *)(2 << 21));
> +    }
>       if (!r)
>           shadow_cr4 = cr4;
>       return r;
> 

Queued, thanks.

Paolo

