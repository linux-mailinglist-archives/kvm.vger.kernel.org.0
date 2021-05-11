Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A98637A5EB
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhEKLor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:44:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230501AbhEKLoq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620733420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R61d3xwdyDD7x6c1LP7evU2g3D1imnjYhld/TmvsON0=;
        b=XFjgUPNxvWF2030fKjYYJYBrnotjao9nvLKtspOPCsEfpcZc1kTPRGSwW2ce7Wi5SPhH0z
        ysB3ne45w5w9NY1mnXTfzqJcYAdgFIHORPUQ30bKmheD8ilHz8QJ7mgTHTBdYVGq1vNw/D
        37yJO9EE3NQ81KdirYUDQoqIFnS0ptE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-84RplLatPf6tejPQDnaZ2Q-1; Tue, 11 May 2021 07:43:38 -0400
X-MC-Unique: 84RplLatPf6tejPQDnaZ2Q-1
Received: by mail-wm1-f71.google.com with SMTP id y193-20020a1c32ca0000b029014cbf30c3f2so952788wmy.1
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 04:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=R61d3xwdyDD7x6c1LP7evU2g3D1imnjYhld/TmvsON0=;
        b=oZXXXH162JDmqevWdhCHnsQ66ihzgT0zSKc1VygiddF7zyrnh7Ykm+qtEWcL3h3316
         GjrbRK0Z8GZmm+6N+Hxeq3UhDXi5rBpwCpRBdC5lW4E7S9lQ+/wtfi9jUwo9PMQZao+I
         srVACKZSoA4x68Dr4IFFrqQO3qR+A15pKApUJCH1J6WojuanZh42qav4CVjcaQfD/wTx
         kZpb77zudZUqkk6wF2LOEi5SNBT4FfrfYRTm2p3kmGCHEIZd7Q6IR6Lnyq5EOI+emYXZ
         8Cd0Cfic+72BOf/L/QzD5gSwDvM7hiNpJhJGrBvu6ksm9wMfrwhLj/MZ/ozC4tAa/wbf
         77dw==
X-Gm-Message-State: AOAM532bx2Au7EMhNydx0HVtjCMomG3QYpf4/l0jVAj4dm6imZA7f/hH
        IiXG/SvrWm0hCEg/f+a06dppZ2PyXVFTmIbFoeRjiEcXtsc0cgZuIqIz2Tl91MhgaIaeUhUHHrL
        3WWfDjRdUQEm4
X-Received: by 2002:a05:6000:1286:: with SMTP id f6mr734415wrx.226.1620733417405;
        Tue, 11 May 2021 04:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaFJoiMBvy0DznXdcNHkbHPAkZjMIyDw0VJ4Zof2iz9Vz6sy3hBLp7VRZ/8RXV5oH4v/pBYg==
X-Received: by 2002:a05:6000:1286:: with SMTP id f6mr734402wrx.226.1620733417244;
        Tue, 11 May 2021 04:43:37 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id k10sm4640820wmf.0.2021.05.11.04.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 04:43:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/4] lib: s390x: sclp: Extend feature
 probing
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210510150015.11119-1-frankja@linux.ibm.com>
 <20210510150015.11119-3-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <b0db681f-bfe3-5cf3-53f8-651bba04a5c5@redhat.com>
Date:   Tue, 11 May 2021 13:43:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210510150015.11119-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.05.21 17:00, Janosch Frank wrote:
> Lets grab more of the feature bits from SCLP read info so we can use
> them in the cpumodel tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/sclp.c | 20 ++++++++++++++++++++
>   lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
>   2 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index f11c2035..f25cfdb2 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
>   	return (CPUEntry *)(_read_info + read_info->offset_cpu);
>   }
>   
> +static bool sclp_feat_check(int byte, int mask)
> +{
> +	uint8_t *rib = (uint8_t *)read_info;
> +
> +	return !!(rib[byte] & mask);
> +}

Instead of a mask, I'd just check for bit (offset) numbers within the byte.

static bool sclp_feat_check(int byte, int bit)
{
	uint8_t *rib = (uint8_t *)read_info;

	return !!(rib[byte] & (0x80 >> bit));
}

-- 
Thanks,

David / dhildenb

