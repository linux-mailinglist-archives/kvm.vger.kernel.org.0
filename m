Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152C6415DF2
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 14:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhIWMND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 08:13:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240619AbhIWMNC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 08:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632399090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZYLxYRodoRHYx95kXrw1Pr6lp8NG1jW3l7FzybD6ks=;
        b=HlTX+CNshlIobHWJiISGzSWbgv2NQ/O/blPqBv0jjLG5lmimOA9jR38THx+g7kpzNL1KUD
        VW5W0lrCCGkQObod982gGbaGUFUrE/5J8tYYQRJT6tJCLE2sd9zUR69hW9JVMNJ1fjY4g1
        41bIz3SVSP6QWVboXhDEcYDkhcDUs4M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-RdU2kyt3PBOJHXaWIwbfag-1; Thu, 23 Sep 2021 08:11:29 -0400
X-MC-Unique: RdU2kyt3PBOJHXaWIwbfag-1
Received: by mail-wr1-f69.google.com with SMTP id z2-20020a5d4c82000000b0015b140e0562so4968232wrs.7
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 05:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+ZYLxYRodoRHYx95kXrw1Pr6lp8NG1jW3l7FzybD6ks=;
        b=p5i7P/izMyx3zVbdAnZNxQE/so5HnV2p6Xi6Kf+pAuyi8rvgyBfcHLguuiBBATbW69
         dfuBuIPWXn2549TGsUbmLjY5G1L/4Hh9bxxtlFtwSLqytgb/XrRRsx9tTMHrZERGMtp7
         pkcr4Nyaa9agQZRYSF/gJJ2mt7V11ZSUXSWV3uFM3xE2S6LI4Rf7JyU17DGp6BpWJlCZ
         8tQdBb3dp0Mj8E5uIF4aJuYtecaMV2nvU1w+Ocxupmshk+P5LbtpRbIYbTzdau6F4DKH
         xbiy0ShMjU8kvSN4NM/2kMD/C45Ixi7KsMBbv31J5TYQbWcNXcLy4Dk/GfmrUTPW6s9G
         klbg==
X-Gm-Message-State: AOAM531GOaF8ZWHbJ9+F5evSXDYrWopUvaYp5qj6NfSjAblkGUf29xza
        8Vh4yAgPV5NtWAYgyYKX0Nk1ivrO2irTIp59m5/EJamK8e8C9UfaLRlcMzUPCUq7U6EBaTgtwwW
        icwmk0qV0DGXe
X-Received: by 2002:adf:f2c4:: with SMTP id d4mr4819163wrp.434.1632399088295;
        Thu, 23 Sep 2021 05:11:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNY86nqoVtoLOCUpc2er0+Hq6REk+ai1lDUo7cRZFqBpegXrsP1oIm5QPG+LF9y1jpw9MiOQ==
X-Received: by 2002:adf:f2c4:: with SMTP id d4mr4819134wrp.434.1632399088071;
        Thu, 23 Sep 2021 05:11:28 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.21.142])
        by smtp.gmail.com with ESMTPSA id i18sm5174091wrn.64.2021.09.23.05.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 05:11:27 -0700 (PDT)
Message-ID: <579a6630-f6c6-3c2c-039e-4182a1033b0f@redhat.com>
Date:   Thu, 23 Sep 2021 14:11:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210923114814.229844-1-pbonzini@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20210923114814.229844-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2021 13:48, Paolo Bonzini wrote:
> Mark PPC as maintained since it is a bit more stagnant than the rest.
> 
> Everything else is supported---strange but true.
> 
> Cc: Laurent Vivier <lvivier@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   MAINTAINERS | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 89b21c2..4fc01a5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -56,6 +56,7 @@ Maintainers
>   M: Paolo Bonzini <pbonzini@redhat.com>
>   M: Thomas Huth <thuth@redhat.com>
>   M: Andrew Jones <drjones@redhat.com>
> +S: Supported
>   L: kvm@vger.kernel.org
>   T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
>   
> @@ -64,6 +65,7 @@ Architecture Specific Code:
>   
>   ARM
>   M: Andrew Jones <drjones@redhat.com>
> +S: Supported
>   L: kvm@vger.kernel.org
>   L: kvmarm@lists.cs.columbia.edu
>   F: arm/*
> @@ -74,6 +76,7 @@ T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
>   POWERPC
>   M: Laurent Vivier <lvivier@redhat.com>
>   M: Thomas Huth <thuth@redhat.com>
> +S: Maintained
>   L: kvm@vger.kernel.org
>   L: kvm-ppc@vger.kernel.org
>   F: powerpc/*
> @@ -83,6 +86,7 @@ F: lib/ppc64/*
>   S390X
>   M: Thomas Huth <thuth@redhat.com>
>   M: Janosch Frank <frankja@linux.ibm.com>
> +S: Supported
>   R: Cornelia Huck <cohuck@redhat.com>
>   R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R: David Hildenbrand <david@redhat.com>
> @@ -93,6 +97,7 @@ F: lib/s390x/*
>   
>   X86
>   M: Paolo Bonzini <pbonzini@redhat.com>
> +S: Supported
>   L: kvm@vger.kernel.org
>   F: x86/*
>   F: lib/x86/*
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

