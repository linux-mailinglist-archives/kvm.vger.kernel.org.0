Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DE4257CB
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242610AbhJGQYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242599AbhJGQYE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9lH9cFNuBWcVmka5xEUL5skSGU5C6UzDU5mPeoZKBE=;
        b=h/Lr7cYnK8WVMktl1ywnEIUhq9ESFNqSmAWaq+U68q/edz5haRW6lFFgm6kXM8lOrPMvhO
        KWHeVKTfkFRleuiOza2I9fdZNjxBDt0EzltLYIcjhcS676HKoQAwHxwdE2LHcgpI2GHhvh
        i4aPUNNn3OdXA0lcOIefpz1OQt0JYvw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-CqJwUFgOOSCKcxJqoRmOug-1; Thu, 07 Oct 2021 12:22:08 -0400
X-MC-Unique: CqJwUFgOOSCKcxJqoRmOug-1
Received: by mail-wr1-f70.google.com with SMTP id k16-20020a5d6290000000b00160753b430fso5155079wru.11
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q9lH9cFNuBWcVmka5xEUL5skSGU5C6UzDU5mPeoZKBE=;
        b=aX2BwQZtY2PDJK103qbq1wlnjUiLe8V7YRycQ3cXCnYt1DZdEAxaPip7oWTjhLnOan
         T5ngrAfZdGa55ppt2lIxf1SoWtGa0nipnAMfgl121nYVm420tvvQjFp0ynIioQ/j7A8V
         nLCDQIepJR9m4gC1o5ShMhY3ekhZ16GyR1d57PqODk8Pb+1aUp/bYFCnf8DOOsyIDK5O
         lu3NE+yiA/YTSzU6ONRZ0iWlrbBItZZqKxfLmc2Q4jB9GRY+pGjkT8NZVKYj+arzi3gH
         JPsbtIriAERisiuGXUlfYjylreBYjpEqF/ApCydxKU85YPZ40CLz0lwoE+kd3+wdA0SM
         SGcw==
X-Gm-Message-State: AOAM530PwmtFDI+f9eMBPJCUQHtPvCJ5NrrZaddJ2xIXs1w6MeZ1WTWI
        yYhlzqs027RBqRhInk9Jx5MFeitHH2gpYHGZxm8djXfNjvcIkKbHBgmhkcDMwGrUjflPlgZphs9
        qXgcJcdWnRa9c
X-Received: by 2002:adf:8b06:: with SMTP id n6mr6739274wra.5.1633623727249;
        Thu, 07 Oct 2021 09:22:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyFF9mQQo5Huyt4EQlO2ZEwdftVtY00KvMdp2QMVfFJvMJsW31Ru+/BQgVVb1U2yU97TTvAQ==
X-Received: by 2002:adf:8b06:: with SMTP id n6mr6739236wra.5.1633623727040;
        Thu, 07 Oct 2021 09:22:07 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id q204sm7239988wme.10.2021.10.07.09.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 09:22:06 -0700 (PDT)
Message-ID: <fc4d2cba-3900-c5bc-deb4-592b17cc121f@redhat.com>
Date:   Thu, 7 Oct 2021 18:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v4 23/23] MAINTAINERS: Cover SEV-related files with
 X86/KVM section
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-24-philmd@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <20211007161716.453984-24-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/21 18:17, Philippe Mathieu-Daudé wrote:
> Complete the x86/KVM section with SEV-related files.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 50435b8d2f5..a49555d94d5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -417,7 +417,9 @@ M: Paolo Bonzini <pbonzini@redhat.com>
>  M: Marcelo Tosatti <mtosatti@redhat.com>
>  L: kvm@vger.kernel.org
>  S: Supported
> +F: docs/amd-memory-encryption.txt

BTW maybe this one should be renamed docs/system/i386/sev.txt?

>  F: target/i386/kvm/
> +F: target/i386/sev*
>  F: scripts/kvm/vmxcap
>  
>  Guest CPU Cores (other accelerators)
> 

