Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D90345F2B2
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 18:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349784AbhKZRP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 12:15:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232382AbhKZRN4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 12:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637946642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2oAsaBCZqzzu8lg0d4rHOgTkD3t28sGm93eznlHHRPI=;
        b=N+CNzZuasHzX61qAC1ylyWo6ltqIseDXwiwQTaDPNlZ21n0ZosgZ5/5fEIKKsMUTa8LPpr
        qdtke9O2Wf52XxPuvZRSZHjjDZOWl/dFqbainQRf+SsMiIWb+OTMLll+mc+z15dhMLd0cp
        8a2VKW9Dkeh2L149Vqat2z9F7UxFErk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-87-zqSqgVPYNyyyJv-_Co2hIw-1; Fri, 26 Nov 2021 12:10:41 -0500
X-MC-Unique: zqSqgVPYNyyyJv-_Co2hIw-1
Received: by mail-wr1-f72.google.com with SMTP id k15-20020adfe8cf000000b00198d48342f9so1795534wrn.0
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 09:10:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=2oAsaBCZqzzu8lg0d4rHOgTkD3t28sGm93eznlHHRPI=;
        b=qTTHiEGyyAW29H/IkeG2VGxKqrnc3OeR58JzqzY2l96TJa357dOgHndDx6598ED2sF
         AvAEfefDqO3N76ayEbHfx23e2e3HCGmfR2oe53F01gQwetc6CddJ2n1yz73tsDVMtByp
         SdvcH8xYDCkE7MrAXnzKSAH/k517XXY4kInXq6Dnyply7L0XfKVkalI78IXFdLcxlHDZ
         Cu765AK8WLTyFatlDEnX0NcYlJyfvWoPOAHnN+ufFd6Q4nsi9FYRHRv569+2jXxlF1DG
         z+khRDQwnV3sCiCDBrpeHV3+nPB7HHYg1aJLqPadCXTSOOKMWwuXIuuWV7LA834EET80
         f74Q==
X-Gm-Message-State: AOAM532p5NF3nX5U1OTzfXlFN1mZXx88yYD87MEn+Ql/8yu8+kFYPPZl
        fdWcpwbiX/g2Fjn+tx+GANlwdYa5fYKrrzY+iLMpZ5tLZXOwSOrQpb9/RHOx5UYmBGkxSwiiUlM
        UEQLxZHsthsl6
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr14647314wrn.349.1637946640054;
        Fri, 26 Nov 2021 09:10:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzK4lbduIqJTvg1e0XLUeXX1W9HH6Y9/Kp+hpm07N7j62khyd/8jP9NyIkPWSYXkfOcaI8z8w==
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr14647286wrn.349.1637946639887;
        Fri, 26 Nov 2021 09:10:39 -0800 (PST)
Received: from [192.168.3.132] (p5b0c69e1.dip0.t-ipconnect.de. [91.12.105.225])
        by smtp.gmail.com with ESMTPSA id o1sm6042808wrn.63.2021.11.26.09.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 09:10:39 -0800 (PST)
Message-ID: <78b0d664-a029-b239-c7ab-cb5ce0b2d269@redhat.com>
Date:   Fri, 26 Nov 2021 18:10:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 1/3] KVM: s390: gaccess: Refactor gpa and length
 calculation
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211126164549.7046-1-scgl@linux.ibm.com>
 <20211126164549.7046-2-scgl@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211126164549.7046-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.11.21 17:45, Janis Schoetterl-Glausch wrote:
> Improve readability by renaming the length variable and
> not calculating the offset manually.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

