Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DBE292A30
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 17:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbgJSPRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 11:17:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgJSPRn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 11:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603120661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7ovWK7RltKO0KeEsCS0Cs0Y2y32wxq5Sek3JRAbHEo=;
        b=Yw3A0eNc8/CqpOyYRUOu2dyklXMY8TuKwrRf1hE5WcDZiKi4QizydptyfuW//+w45SnLao
        u6gYIeAnIo7eKxCE6ZOPEWpC+n33iB8O4ttIGHfLgCXON+qvGJVy+iY9WvHmE8t20muMoJ
        r4fKp9PRCx3z4CtUf5uBztDYBHc0zxI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-gALBQa2AM4Se36OsevbYWg-1; Mon, 19 Oct 2020 11:17:36 -0400
X-MC-Unique: gALBQa2AM4Se36OsevbYWg-1
Received: by mail-wm1-f72.google.com with SMTP id y83so53119wmc.8
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 08:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a7ovWK7RltKO0KeEsCS0Cs0Y2y32wxq5Sek3JRAbHEo=;
        b=Q5xtsC7KRbWf6Yp/sdEpKhGvipjll3HkhN3QHqLbg6N1CCcFzHxNJZ0HYoaZkSXU2K
         BMt1aTdiWUqrKL+c0ade6ovGHtPIxQiwGUgSNHp+YUfh0Ruq98IVvN41BqDFJ6mh8hC8
         PvXL8ibVtzyvMrULaL6TIzmUlNX9iciN2J/y+yAwhM1VKe/UHr3LmNzCK3FplFc9IMJL
         rNiMib2x/iDl2j4FIKQplcRstWpg7LhpN+o9DTTRe5hDAGa9PJ4ebe+8sW3lvi8xvbFD
         n2T87FO7r0IXDjGKD5/leQdaCZrWur+687l+DdbUyY8+TiW2acc0TX1zmdvpLesI/6bn
         +57A==
X-Gm-Message-State: AOAM533UbFV1IYtOjCRjvA5kAhUHpc0vTl2XPMuvh/2firqbe4ruSKta
        s8jRjR7jm2uLtir/yd4sJeA/Rm+sad+MkR0Uo4LqYPk34kYm2tB4GE1gYCqQNnzL9wNSdl5V7A0
        Q6XlvFHGx/Pqc
X-Received: by 2002:adf:9e06:: with SMTP id u6mr46715wre.208.1603120655793;
        Mon, 19 Oct 2020 08:17:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrU3psweUfaYlpWF/qnlaOgo6R+sEWPLIXJNAQAKvV498q6G0djF0HOVliXhPJQxACX0ExFQ==
X-Received: by 2002:adf:9e06:: with SMTP id u6mr46697wre.208.1603120655619;
        Mon, 19 Oct 2020 08:17:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e7sm80707wrm.6.2020.10.19.08.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 08:17:34 -0700 (PDT)
Subject: Re: [PATCH] x86/kvm: hide KVM options from menuconfig when KVM is not
 compiled
To:     Matteo Croce <mcroce@linux.microsoft.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201001112014.9561-1-mcroce@linux.microsoft.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ff8bc03-8503-a21d-e2b6-cb730e04c942@redhat.com>
Date:   Mon, 19 Oct 2020 17:17:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001112014.9561-1-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 13:20, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Let KVM_WERROR depend on KVM, so it doesn't show in menuconfig alone.
> 
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  arch/x86/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index fbd5bd7a945a..f92dfd8ef10d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -66,6 +66,7 @@ config KVM_WERROR
>  	default y if X86_64 && !KASAN
>  	# We use the dependency on !COMPILE_TEST to not be enabled
>  	# blindly in allmodconfig or allyesconfig configurations
> +	depends on KVM
>  	depends on (X86_64 && !KASAN) || !COMPILE_TEST
>  	depends on EXPERT
>  	help
> 

Queued, thanks.

Paolo

