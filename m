Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78243434665
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 10:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJTIFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 04:05:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhJTIFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 04:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634716996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VDA2Ey1tDwja0XRAatgK+bISxfCj+guwB8pLt88m7CY=;
        b=W5au+omsm5lBhWWG4E10tV2UvVuahJIYUVluVbTkRKcv1wWsKtXS87UAwM8fCf5WeJ9rxM
        FeWGP1pg2xaLnmC1r5xnygMcYLb8p5GIHg+g8e1iLZL8N+pnbuVqIraxDJaERT0Dxcmfv0
        KVqG3/m63pnp/q28aVsGTjQ06VTavqg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-GinOnagFOE6BzQcuppWXVw-1; Wed, 20 Oct 2021 04:03:12 -0400
X-MC-Unique: GinOnagFOE6BzQcuppWXVw-1
Received: by mail-ed1-f70.google.com with SMTP id i7-20020a50d747000000b003db0225d219so15561562edj.0
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 01:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VDA2Ey1tDwja0XRAatgK+bISxfCj+guwB8pLt88m7CY=;
        b=XWV7UjLyvHqMH7q1ud9haI1KFR7A4hJgDsQ+FA2M/iHWuic/lybjH8sx4Z2qA/AB/C
         v2wbvjXK8lU63N7RIv7u4Z6nGW+UW/37gSMnFaWS7cUhZEtAnDjCfGR+VsoaqzESlOfk
         t/3TAw+vprmwSb1FeeoDoz1Yd4oBjkb1G1rcKs8w9kueWa6O4eiJBdvyPYsyualoRyhn
         JmXpl91xL5pazCNTG4j07NL2/nqTs19Q//WmXXdD1VvhORHULWUAw+Wb1tmDB/8IY4AF
         sbPEHTfdWRhx5jDcS7btikjWEWZaUAMzYZVO3gZaOsgjID4xvq0MeitCOkZPhyHqEb47
         fFHw==
X-Gm-Message-State: AOAM5304VQ0KZnclbLxVYUf1Blr+LB0cF1vsDATzvuQSqsKTtxrHKjAH
        +NUsWLWmF90SBYPPgmnZ6Wkc7MHK6lo/LEKvG3/Sx9pt9jAt4OKr0OMfJ3KBQvUCCUiz3+VIFFm
        sLriyziqEuo6r
X-Received: by 2002:a05:6402:5215:: with SMTP id s21mr61041760edd.113.1634716991345;
        Wed, 20 Oct 2021 01:03:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFIn7SnMVdPw5ffZqY3maW/jierGXVkUq17/kHbSFey7MqEJZPtBeeq/6yA0QjG+9kvJINcw==
X-Received: by 2002:a05:6402:5215:: with SMTP id s21mr61041735edd.113.1634716991141;
        Wed, 20 Oct 2021 01:03:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id dt4sm637766ejb.27.2021.10.20.01.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 01:03:10 -0700 (PDT)
Message-ID: <87759b12-08c2-d654-aa52-f78f83fd9550@redhat.com>
Date:   Wed, 20 Oct 2021 10:03:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH 2/2] git: Ignore patch files in the git
 tree
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
References: <20211019225351.970397-1-oupton@google.com>
 <20211019225351.970397-2-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211019225351.970397-2-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 00:53, Oliver Upton wrote:
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   .gitignore | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index b3cf2cb..3d5be62 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -5,6 +5,7 @@ tags
>   *.o
>   *.flat
>   *.elf
> +*.patch
>   .pc
>   patches
>   .stgit-*
> 

Queued both, thanks.  (Next time, for unrelated patches you can use 
--no-numbered --no-thread in git-send-email).

Paolo

