Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0693B3B228A
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFWVjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:39:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWVi7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624484201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YMYTmvK4BZEj8BbRJO6x7ECAEMNR05qfc4Z3CjrzPOc=;
        b=ESOAyUD7b9l1ogkR6DLuivUx+uL4kUwMGnmzocG32b2LAY6b+dNqlIuGwVPrLhll4R4fD2
        r6rmziGLncR8SMX2VEYe8UyMlzFoTEfnYIPLekMh7DVRqUnhJbk3RAWiXBFBp2uBe+fx9f
        4UV//gESnk1kJm9WOKikrJWw7SLkAco=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-8TJ9JX4PPBWhfpEuDLPhOA-1; Wed, 23 Jun 2021 17:36:35 -0400
X-MC-Unique: 8TJ9JX4PPBWhfpEuDLPhOA-1
Received: by mail-ed1-f69.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so2050900edt.13
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YMYTmvK4BZEj8BbRJO6x7ECAEMNR05qfc4Z3CjrzPOc=;
        b=P+coJT7Vudblgi2UbKdf4vp8E3gUpOiOIn2FzJVVvndt15VMPIA8ZkcN2BkDKpzUS0
         5mmKPoWcOfj/g3vfRNfRpYMxlYlrni4NqMfGS41z4Qltc1ZZAyR+Q93ntf2x8G6c5WI6
         BEnASxHd/NdiTxMVtsEkddyafjA0W66i5LY/wzoS7Ox0i9H9ubitQP5TfD5UyzoK332/
         FcNtnw+4j1N6M2wdPBHBvrt5T0bmiW1gCJzhWqmyGoub4atCVHE3RERAfEUIDQ4hzUmj
         jH4eSIkWcLMmyNCznt4Z1nVtfO+Gi6ioHUaP4DW95zGz93g5rIKlzTGm8/AUfHFF1ynt
         KNHQ==
X-Gm-Message-State: AOAM533b9Ls2CaAa80fXUUyU7IITgiMIj7Ue7AWewWXd6EJ/HBj+SrD0
        r93RIshHZflRFrZt/fNx5xoHCkZl4FuK6Oj13oEvIoBG1q/hGmG0cBv1ziB1VTLObsELP2zR2Mw
        PhCLW/zHvby09
X-Received: by 2002:a50:9e6b:: with SMTP id z98mr2536415ede.210.1624484194001;
        Wed, 23 Jun 2021 14:36:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBNp5KMH0pvKgn8Jr/UlAypkGehSLTEB+52K5xFd3xdpAzerV1dn7npIhD3x93xFMJweYMwA==
X-Received: by 2002:a50:9e6b:: with SMTP id z98mr2536407ede.210.1624484193885;
        Wed, 23 Jun 2021 14:36:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ck2sm676939edb.72.2021.06.23.14.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:36:33 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: disable the narrow guest module parameter on
 unload
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, mgamal@redhat.com
References: <20210623203426.1891402-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9846d951-7afc-cb68-7a76-30201746c095@redhat.com>
Date:   Wed, 23 Jun 2021 23:36:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210623203426.1891402-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 22:34, Aaron Lewis wrote:
> When the kvm_intel module unloads the module parameter
> 'allow_smaller_maxphyaddr' is not cleared because it is also used in the
> kvm module.  As a result, if the module parameter's state was set before
> kvm_intel unloads, it will also be set when it reloads.  Explicitly
> clear the state in vmx_exit() to prevent this from happening.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2a779b688e6..fd161c9a83fd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7996,6 +7996,8 @@ static void vmx_exit(void)
>   	}
>   #endif
>   	vmx_cleanup_l1d_flush();
> +
> +	allow_smaller_maxphyaddr = false;
>   }
>   module_exit(vmx_exit);
>   
> 

Queued, thanks.

Paolo

