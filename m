Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C802ED670
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbhAGSKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:10:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbhAGSKi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 13:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610042951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tmc2SUr2EDYUvSr/Ugpsd9kuveplLIkFRP2hAGBtBmk=;
        b=hDJxfNDoVimnOxpjUGBSu4iAKwwwCa7bP3mv/zXy5IfOHfG1LiSJhv29JMM6JTELSJglz8
        KEWGxUYYWewFDwU+GVU5YneATnXpJGUYDPHuJ6pMrWXeIb4lVJY2Lzw2gltSvNzAOAQyul
        nl9NrGvjUYx2hHUNTyFfSWzZpO3NNz4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-t4ofhOAbN32NZJpX6Up-6g-1; Thu, 07 Jan 2021 13:09:09 -0500
X-MC-Unique: t4ofhOAbN32NZJpX6Up-6g-1
Received: by mail-wm1-f72.google.com with SMTP id b184so890519wmh.6
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 10:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tmc2SUr2EDYUvSr/Ugpsd9kuveplLIkFRP2hAGBtBmk=;
        b=L9X1CJ7Nzv7++w05kMWkhaFGTpCmFjX6kVL9OR0z9kE3/U6U+B3HAnWOEe6UUvE2Pp
         ybYPrgXeqF3L3KLwU4lNJQvNv+MsF+cQ+2El1bMXy5nOHOVZjAjrNIpQ6flmbPPU2BT7
         N7iVlYlXNgWzencubZI8zpoPi1nESaUyZOMn3wixxvo+l8OpJJ6OWO5g8v3Xc7eT8bGy
         pP01z/ecgfRiSqldAm2qVWJt7M79KnG5RPvrxggIPpurXBiUZRKFQlLl+1xKJRyY3Kds
         uVtBGHECisewYZ5zUZ7zBxeILcn9eoFdfe2tJ7kW4NHn3E6IuN1QYbU4s3L5AJ4pDgQz
         Yh0Q==
X-Gm-Message-State: AOAM531aPHmbFQygXLoaulAkuTV1EheGXTm0AZborW1tntHuK529+wNi
        FBhGls0CYpecuSk6FymlFuCHWP4GiExHBkWpHK/ivDdb/T5fD0h4UeJOD8B8prGrlo7pAk/Wwq/
        9Gm1WqwYddczb
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr9815096wrw.188.1610042948270;
        Thu, 07 Jan 2021 10:09:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXE1gHwUIxhIzO6TG3lEipQyZ/A/VhsKf7U7psi+SZvv4dijHU/+qhm67HIAUH8c/qp6kW/w==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr9815074wrw.188.1610042948050;
        Thu, 07 Jan 2021 10:09:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r16sm10445268wrx.36.2021.01.07.10.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 10:09:07 -0800 (PST)
Subject: Re: [PATCH] MAINTAINERS: Really update email address for Sean
 Christopherson
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
References: <20210106182916.331743-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1c37441a-1588-e735-c8eb-0da80b8e1ba9@redhat.com>
Date:   Thu, 7 Jan 2021 19:09:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210106182916.331743-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/01/21 19:29, Sean Christopherson wrote:
> Use my @google.com address in MAINTAINERS, somehow only the .mailmap
> entry was added when the original update patch was applied.
> 
> Fixes: c2b1209d852f ("MAINTAINERS: Update email address for Sean Christopherson")
> Cc: kvm@vger.kernel.org
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7c1e45c416b1..9201e6147cba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9776,7 +9776,7 @@ F:	tools/testing/selftests/kvm/s390x/
>   
>   KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
>   M:	Paolo Bonzini <pbonzini@redhat.com>
> -R:	Sean Christopherson <sean.j.christopherson@intel.com>
> +R:	Sean Christopherson <seanjc@google.com>
>   R:	Vitaly Kuznetsov <vkuznets@redhat.com>
>   R:	Wanpeng Li <wanpengli@tencent.com>
>   R:	Jim Mattson <jmattson@google.com>
> 

Applied, thanks.

Paolo

