Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF25543CACB
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 15:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242212AbhJ0NjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 09:39:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242206AbhJ0NjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 09:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635341795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SrQ6jaJilOp1yrFZ9zv1K0mKYN/sJK782ufNt11Lqg=;
        b=YY1w9MQyOT9KAyRGLKD/AQaWbkrn7hRlkcYSpFtSERKiQVSZbeT6R4dtcIeVPDR11mTvDa
        OmLNEKn2enBALKvw9JakdPAeMz1Ujo/CTIl/AljvE6pVy+DR0oqMZQDk6V7ulPdCWpPMF3
        xYKvqiQMgkXxZATF3doTrW6L9UvZ43Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-_co_vZc2OXa_F43K1JT6uQ-1; Wed, 27 Oct 2021 09:36:34 -0400
X-MC-Unique: _co_vZc2OXa_F43K1JT6uQ-1
Received: by mail-wr1-f69.google.com with SMTP id f18-20020a5d58f2000000b001645b92c65bso677293wrd.6
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 06:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1SrQ6jaJilOp1yrFZ9zv1K0mKYN/sJK782ufNt11Lqg=;
        b=C1LhLV7ABuS35SoGkmBL7qmnVoLy8C/D6WVa+EGaGqIk4VzihoKMxOzORpTG5pUAzW
         uFBBXyR/IQ7xChsyZ03WM5cLMygHJUWnKh3wEWKj1IGQky1pap80CRjvjwjQwhPIIL9Y
         +oBsprdXVqxW+Au8HCT1J+hr9gxAEF70ot5Q5mTcmjP0NvDJhQ64YFYCJzolwJlkSUo1
         00WJ5FUhiWmMBGEV4zzmTSI4UINE7rjb4dE4+hluXSxnrLaWOqXphP1W7yRLc4MSbNX0
         46Ml3QYqMsL/CfR2Jyymxu4xd2pkF70EztLM3YFKKWUII63TbZCfEutaE6S1jCHOtCND
         kz5Q==
X-Gm-Message-State: AOAM533qYTQPSe4zgJOypW9xrNcliYV2+i0oNAWmLr0yc0oXUis1LRNb
        vXoMoIS7CNpz/whcjuVu1iHxYH87I+OJ7TR/+qiX1WaVo3CkcocuhpVtw4vypQEM7iRCEpCjfqP
        R6z2x7X/FLe0c
X-Received: by 2002:a5d:59aa:: with SMTP id p10mr40379625wrr.45.1635341793211;
        Wed, 27 Oct 2021 06:36:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEOZHXkux47bJsEHIMV3VqdLetz3CsBoRWhuCRjNcgcHCrOfHRroHar5PFK0+IW5n+RlAcsw==
X-Received: by 2002:a5d:59aa:: with SMTP id p10mr40379584wrr.45.1635341793004;
        Wed, 27 Oct 2021 06:36:33 -0700 (PDT)
Received: from [192.168.1.36] (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id l6sm3788173wmq.17.2021.10.27.06.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 06:36:32 -0700 (PDT)
Message-ID: <4ce74e8f-080d-9a0d-1b5b-6f7a7203e2ab@redhat.com>
Date:   Wed, 27 Oct 2021 15:36:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hui Zhu <teawater@gmail.com>
References: <20211027124531.57561-1-david@redhat.com>
 <20211027124531.57561-3-david@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <20211027124531.57561-3-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/21 14:45, David Hildenbrand wrote:
> Let's return the number of free slots instead of only checking if there
> is a free slot. Required to support memory devices that consume multiple
> memslots.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/mem/memory-device.c    | 2 +-
>  hw/virtio/vhost-stub.c    | 2 +-
>  hw/virtio/vhost.c         | 4 ++--
>  include/hw/virtio/vhost.h | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)

> --- a/hw/virtio/vhost-stub.c
> +++ b/hw/virtio/vhost-stub.c
> @@ -2,7 +2,7 @@
>  #include "hw/virtio/vhost.h"
>  #include "hw/virtio/vhost-user.h"
>  
> -bool vhost_has_free_slot(void)
> +unsigned int vhost_get_free_memslots(void)
>  {
>      return true;

       return 0;

>  }

