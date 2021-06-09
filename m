Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754EE3A17CB
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhFIOtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:49:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238195AbhFIOtG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623250031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7p3iSSBeE9IsLDvewBcO4q2lNyiQ1LDLULJ0BkngOw=;
        b=RgIarz+RAQ9YTJfm8/fZvoXdZ6Fh5rF3zZkMdiCjvmcPNOMzUvJPYSCmonTsegTRLksQDD
        IO6HTqNl+U98+P7saKIrwU8+as6OzdKqG6ye8X1wCyAqpx9S5XzkAX594M6CnL+yhOFnpA
        cPgUBZ8KCpAZ4PteCoFgk+aDV7wnu9U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-cMhJWihKPXWS_ttn5OVOXQ-1; Wed, 09 Jun 2021 10:47:09 -0400
X-MC-Unique: cMhJWihKPXWS_ttn5OVOXQ-1
Received: by mail-wr1-f71.google.com with SMTP id k25-20020a5d52590000b0290114dee5b660so10891086wrc.16
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 07:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r7p3iSSBeE9IsLDvewBcO4q2lNyiQ1LDLULJ0BkngOw=;
        b=tOJq/ZoKM43NjAISUuBgN2IhBSgjamFcG19dTWYtvsPdM+9fCYyiHwFa/iyvuB+ZMg
         oa+qne9bGwzKIiYT+E1/qIW18gnQfvHkJzqEhAZNJsU0hIIlwA2OTGP8zX3aMTqfIVo/
         zPdmnVWExRSsivZv1V0XFLWCrkLHnGJp4uNcWlm9aQMIZCyOOACwzDqlXh/Te/q+7c6v
         lg2b+VasuXMaMt+o2o6FBPKYsy00O+JznADDK7pzS2qP/A3beKuPi75unwRqARd2OPOA
         tgfDX9BwP2M7fh5DOv1FHbnH7jJFWRLSFYSUdd2Hs/g/p+BEaaPI8ZKbznHgBYZpWiH1
         PRJg==
X-Gm-Message-State: AOAM5302vL+q/wpiijpmARU+Ngc7AmhZlTMMSMS5pwatWPI9Zvxk8Ima
        pQCTthxgT4Ir3IhskZ73Vkp1tv9RFPawICAk/FsmTmCHn/+fsdk/wsSO3GKXWBSx/ttLhB6ya0E
        FE7x2RBGNYO5b
X-Received: by 2002:adf:a195:: with SMTP id u21mr137234wru.367.1623250028742;
        Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweqEQec2chpibdCqZRkKANHtLLkFIjRh58mELPpwoK9PTJW2sYNOXC6gBVGIEq5Mnyq5WnhA==
X-Received: by 2002:adf:a195:: with SMTP id u21mr137211wru.367.1623250028562;
        Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id l16sm6741263wmj.47.2021.06.09.07.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 5/7] powerpc: unify header guards
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
 <20210609143712.60933-6-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <2eefe369-2eeb-17dc-0aec-cc262485c4e3@redhat.com>
Date:   Wed, 9 Jun 2021 16:47:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-6-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Only spapr.h needed a tweak.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   powerpc/spapr.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/powerpc/spapr.h b/powerpc/spapr.h
> index b41aece07968..3a29598be44f 100644
> --- a/powerpc/spapr.h
> +++ b/powerpc/spapr.h
> @@ -1,6 +1,6 @@
> -#ifndef _ASMPOWERPC_SPAPR_H_
> -#define _ASMPOWERPC_SPAPR_H_
> +#ifndef POWERPC_SPAPR_H
> +#define POWERPC_SPAPR_H
>   
>   #define SPAPR_KERNEL_LOAD_ADDR 0x400000
>   
> -#endif /* _ASMPOWERPC_SPAPR_H_ */
> +#endif /* POWERPC_SPAPR_H */
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

