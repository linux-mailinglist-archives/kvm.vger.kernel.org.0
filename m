Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7680A422D82
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhJEQLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235077AbhJEQLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 12:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633450200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJDCxoH/+Tuo5jDCONePynEKnwpBOxblOelcXgminvI=;
        b=W+LR5tckBrYEM7nZsF0TiRXvmd/61ibqDnkCw4B43HtzUz5FTS5EtQ8SFbUOx6gQT4ugRt
        CqCWi24dgXeFD1OQ03yxcMqo3phxPthXjpUSZVtU8iSirR22XQjAUZaulPAjkKRe3YauJV
        rk66YD6hRZAU4LLsW5TDQ3OXNt97+Qs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-y3CWkTVZOEyu1kGdFDQMdQ-1; Tue, 05 Oct 2021 12:09:59 -0400
X-MC-Unique: y3CWkTVZOEyu1kGdFDQMdQ-1
Received: by mail-wm1-f71.google.com with SMTP id f11-20020a7bcd0b000000b0030d72d5d0bcso1467764wmj.7
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 09:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJDCxoH/+Tuo5jDCONePynEKnwpBOxblOelcXgminvI=;
        b=b1ZYd+oIxoZFl0mTMtCdLC7XQ4Avg/+EBbGJ/0fHFPzZH0gbPto8jx62qytEqOUKRF
         Am5CliiZXYWXOMzZ1SXpi6daOyHA7M8jKtDXmBj6z5NXISOUK1aWh4wc0ZTljQ5C706C
         qvF+qYoT9QOLNjOOj/cEFzBaVX2Q59EM600PBn33pujjODRNaUo3z51RP4VeXyKnckb1
         dvqJYMwMEla8A2sSVGrEH5vorgBf7KAvmBwhIZYzGlM63ONRRL7MMXi23kXfxHLWwyqD
         segz91BoytV61npYMByUZ1ZLM4sICJfQHZngDSqIoO7bIIYdJaijfALgblBK7KG1I94L
         a9bQ==
X-Gm-Message-State: AOAM533Lwau/BnCfmrxGxMBO4+ZalfspchHWsZrtzN6r/LHZCFcyln3T
        DOdC7vCOgAeS5oEdpVNfG3sKknmLxwtfuJZm7bGuRMZgsJyS7L/RJO77UL8Atej7vPaEcLHXfRP
        tk01eJtseKSuXa2p5pLDmJWwrN3gfg7f+CwXaH/q/OG3O/k7otPryJjlV4Djf
X-Received: by 2002:a05:6000:144d:: with SMTP id v13mr22506904wrx.303.1633450197966;
        Tue, 05 Oct 2021 09:09:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq1dFd2fjEvXa2tUEpJZx9Rmy2pwzIGPBUTykrW2O89/Gb6iV262EocLjhYwdbQFKjS39lFg==
X-Received: by 2002:a05:6000:144d:: with SMTP id v13mr22506858wrx.303.1633450197680;
        Tue, 05 Oct 2021 09:09:57 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id y1sm7715642wrh.89.2021.10.05.09.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 09:09:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 0/5] Add specification exception tests
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <2f5f7152-1f11-f462-de27-3d49f4588dfe@redhat.com>
 <20211005103025.1998376-1-scgl@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <99e7ce31-8723-8c30-c503-61eb35e216a3@redhat.com>
Date:   Tue, 5 Oct 2021 18:09:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005103025.1998376-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2021 12.30, Janis Schoetterl-Glausch wrote:
> On Tue, Oct 05, 2021 at 11:13:22AM +0200, Thomas Huth wrote:
>> On 05/10/2021 11.09, Janis Schoetterl-Glausch wrote:
>>> Test that specification exceptions cause the correct interruption code
>>> during both normal and transactional execution.
>>>
>>> The last three patches are cosmetic only and could be dropped.
>>>
>>> Unrelated: There should not be * in the file patterns in MAINTAINERS,
>>> should there?
>>
>> I think those could be dropped, indeed. Care to send a patch?
> 
> You mean the * patterns, not the cosmetic patches, correct?
> 
> -- >8 --
> Subject: [kvm-unit-tests PATCH] MAINTAINERS: Include subdirectories in file
>   patterns
> 
> The * pattern does not cover subdirectories, so get_maintainer.pl does
> not know who maintains e.g. lib/<arch>/asm/*.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   MAINTAINERS | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4fc01a5..15b5e1b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -68,9 +68,9 @@ M: Andrew Jones <drjones@redhat.com>
>   S: Supported
>   L: kvm@vger.kernel.org
>   L: kvmarm@lists.cs.columbia.edu
> -F: arm/*
> -F: lib/arm/*
> -F: lib/arm64/*
> +F: arm/
> +F: lib/arm/
> +F: lib/arm64/
>   T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
>   
>   POWERPC
> @@ -79,9 +79,9 @@ M: Thomas Huth <thuth@redhat.com>
>   S: Maintained
>   L: kvm@vger.kernel.org
>   L: kvm-ppc@vger.kernel.org
> -F: powerpc/*
> -F: lib/powerpc/*
> -F: lib/ppc64/*
> +F: powerpc/
> +F: lib/powerpc/
> +F: lib/ppc64/
>   
>   S390X
>   M: Thomas Huth <thuth@redhat.com>
> @@ -92,13 +92,13 @@ R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>   R: David Hildenbrand <david@redhat.com>
>   L: kvm@vger.kernel.org
>   L: linux-s390@vger.kernel.org
> -F: s390x/*
> -F: lib/s390x/*
> +F: s390x/
> +F: lib/s390x/
>   
>   X86
>   M: Paolo Bonzini <pbonzini@redhat.com>
>   S: Supported
>   L: kvm@vger.kernel.org
> -F: x86/*
> -F: lib/x86/*
> +F: x86/
> +F: lib/x86/
>   T: https://gitlab.com/bonzini/kvm-unit-tests.git
> 
> base-commit: fe26131eec769cef7ad7e2e1e4e192aa0bdb2bba
> 

Thanks, applied.

  Thomas

