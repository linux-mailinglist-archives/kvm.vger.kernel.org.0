Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3F53A2A8B
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFJLq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 07:46:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229895AbhFJLq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 07:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623325472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DLP7A6CuLbvbdTjbJvOEkDk3V+FmEdn/cupIcH3ks2s=;
        b=OGLcLQE6OZ1vD8yZ7/0kb99PMkxZ/Rzm7NJwAlV5hTD9vWiiyiBjyYRnRirT4SEtczCufu
        bSpjJMafUELr2oCrJElzXxouWuGJAqpbKYP/+iLidFLveNr8AqWRXB081oVNdER4qJWC5o
        GXADmbrATf7/pKiVwcVbxb4OrJcCHjo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-oQiK4tSIMQm7hUD9nWIcJg-1; Thu, 10 Jun 2021 07:44:30 -0400
X-MC-Unique: oQiK4tSIMQm7hUD9nWIcJg-1
Received: by mail-wm1-f71.google.com with SMTP id g14-20020a05600c4eceb02901b609849650so3255989wmq.6
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 04:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DLP7A6CuLbvbdTjbJvOEkDk3V+FmEdn/cupIcH3ks2s=;
        b=M8Afsnww0P48Ph0ZbThKOYWcLSAhqkaifJ9veWqraV73WR6K1FuCFss08220xtJZib
         n0LTkkmqTY1YdCP+Ay26bPUmy6TcTwag0EG7RCe4YngqLNEF8y5VWtSDDUGJcG1TnWts
         37UfTbAHeKi6LNvi8JsJShoDBkdzxEXPgDCYqVDEMQ9nSviFHj9DyKC5cfMKBZhZ2Z8R
         p/nPd790pShoMjGDIUdkRHsyuuADIbW7pAanBQYev7AYPSi4lDavJLMdrkeo5VgayD8u
         LAxAs9gLDD/ErnNW2lugyVK9RlvLc0h4Z7eSXEmqofnvvaMDBYs4D4hN9nV1P3M56uOy
         qDXA==
X-Gm-Message-State: AOAM530q0VWF9EmK5zl5NlTPuhZluAtN1Ny/xXF6NfzBozbsVC32qd/N
        SxEzlYgNP3jt1iDJg3Ooe0eXH4wGjDxn0zkkfW14eilY20iTES7kwkaCneFdOlKioBDddF2cQ6H
        68nfYpDSEKRe83JFeJ++xMDEQgvGGpKCd+EWtVcBo5O4ePzTmob7mo0UJENmlzNF1
X-Received: by 2002:a05:600c:3650:: with SMTP id y16mr4638603wmq.92.1623325469133;
        Thu, 10 Jun 2021 04:44:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1lmFvAsZ9dR3FveYn+Jg9WbESvuVq28eec500iykHmPAXI+zuvFJmaCD4cOM+dNYVTZMVUw==
X-Received: by 2002:a05:600c:3650:: with SMTP id y16mr4638575wmq.92.1623325468844;
        Thu, 10 Jun 2021 04:44:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id d131sm9213775wmd.4.2021.06.10.04.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 04:44:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] make: Add tags target and gitignore the
 tags file
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, kvm@vger.kernel.org
References: <20210610113128.5418-1-sidcha@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea7d753a-33cd-6626-7afc-955f8ff06bd7@redhat.com>
Date:   Thu, 10 Jun 2021 13:44:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210610113128.5418-1-sidcha@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 13:31, Siddharth Chandrasekaran wrote:
> Add make target to generate ctags tags file and add it to .gitignore.
> 
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>   Makefile   | 4 ++++
>   .gitignore | 1 +
>   2 files changed, 5 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index e0828fe..017e7d8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -128,3 +128,7 @@ cscope:
>   	find -L $(cscope_dirs) -maxdepth 1 \
>   		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
>   	cscope -bk
> +
> +.PHONY: tags
> +tags:
> +	ctags -R
> diff --git a/.gitignore b/.gitignore
> index 784cb2d..8534fb7 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -1,3 +1,4 @@
> +tags
>   .gdbinit
>   *.a
>   *.d
> 

Queued, thanks.

Paolo

