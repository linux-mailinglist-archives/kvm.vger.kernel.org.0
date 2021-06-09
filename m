Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178893A17AC
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhFIOrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238077AbhFIOrc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnzGT8LB+qqMPyhJStfYGlKykN8fg6Vcl9Y43OphKvE=;
        b=FltXgozsdU5YjSr6PxEIBjs51ZeeoCGVOxczcYeSBH1wbhsuxY3gf9FatwI9hTDLHA6kWj
        OCejbUBMCcDoCT40qmgONxO4ZYCNwXskSFsyRSLgGCR2bzN6vvmPTbS+WxiF7q6AUyC99A
        RtE/SHtGtGlE43sj9mjSsL2Tiqk5rK4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-OeMTEjPOOAal5YC-9gQFiw-1; Wed, 09 Jun 2021 10:45:35 -0400
X-MC-Unique: OeMTEjPOOAal5YC-9gQFiw-1
Received: by mail-wm1-f70.google.com with SMTP id n8-20020a05600c3b88b02901b6e5bcd841so507007wms.9
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tnzGT8LB+qqMPyhJStfYGlKykN8fg6Vcl9Y43OphKvE=;
        b=StOP7OP8eY/eodA+lAK8UQiFVUy7burfBxVfP1F/X8TqEOGrqpW7BnE6VX9yZm7oV7
         IpSWQB+4IQYvwh+PLAaRu/UzmVKuQOOLKpYE5dE1IZ18KpMhMoEbBbTQAGDCI1nuUFB/
         ppAGLNkezZswSU8r5d4++oS/j1lBPtspmEX24YpMsO+bBp/l0rhj1q2rT8WbmlhAyAYb
         0/yTY0yV9gNcc9SCX9GKfez4roTYAXK0WK/CpFUf4PT0foKnh9kIzghmNIaaL1dfzSSU
         3C4OpFT3x91SQSJ6xbP6uAwnjRW5MrMiQFPgKhII/2dG/sBEFdqBlvyicinyFJFjuSak
         ZYgA==
X-Gm-Message-State: AOAM5307fKD/RV7/atYek+NCXLeEN8mnCFQdk3sJYdQUDltKyFEQlbOo
        pYTaFxd36NtZVLSb0HvfMpzNpJkK0lE9OVQO8MDC+LZ3Hwmm/D6vnE2/JdSAj15AneVGt/v2l2C
        qt8Xz82xJMSmf
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr166302wri.61.1623249934239;
        Wed, 09 Jun 2021 07:45:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBlt+Qd2SzrFOQD3lcTBbx/uITEZdEoScRy5/tAvd6+BgUrQgY42qMDWZ4IPIP1cvrcUECgg==
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr166282wri.61.1623249934070;
        Wed, 09 Jun 2021 07:45:34 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id k82sm6877536wmf.11.2021.06.09.07.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:45:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for header
 guards format
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
Date:   Wed, 9 Jun 2021 16:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-2-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   README.md | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 24d4bdaaee0d..687ff50d0af1 100644
> --- a/README.md
> +++ b/README.md
> @@ -156,6 +156,15 @@ Exceptions:
>   
>     - While the kernel standard requires 80 columns, we allow up to 120.
>   
> +Header guards:
> +
> +Please try to adhere to adhere to the following patterns when adding
> +"#ifndef <...> #define <...>" header guards:
> +    ./lib:             _HEADER_H_
> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_

I'd have used _ARCH_ASM_HEADER_H_

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

