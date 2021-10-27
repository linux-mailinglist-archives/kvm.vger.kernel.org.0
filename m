Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA443CB7E
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhJ0OHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:07:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237451AbhJ0OHA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635343474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YN/bLTk9W4jFoqX1MmfKo8264P/GPmaZJoxCKcTGJ7Q=;
        b=Tq3VzCvQUmCwLFaCf1O4NFwJ8K9mthZwQrSL3WJ5zLfEVqc504dh1XNTBGijxo+dVq2xjt
        ze6O7DuyGI6oFFCBxktyAyX8r1ssNLVIj0a5Wuwi2Vnsqe3BTA5fyijNRqiKUZkrMenydS
        vHuMRmymRWR8k0XDXYXgR9GkuwDXmFE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-dk9gY1SdOlyBjkw0JI42Yg-1; Wed, 27 Oct 2021 10:04:33 -0400
X-MC-Unique: dk9gY1SdOlyBjkw0JI42Yg-1
Received: by mail-wm1-f72.google.com with SMTP id u14-20020a05600c19ce00b0030d8549d49aso1819376wmq.0
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 07:04:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=YN/bLTk9W4jFoqX1MmfKo8264P/GPmaZJoxCKcTGJ7Q=;
        b=KnFt+YmECPUxsh9fxxCkUYLTJ+1aRWu8Zyx2Fkdb05E5+nF1HAcF8ev0+Z8KrEnG6j
         lVTxiUnDc4IRj09wpK9V9EXGqTYVgYZR0gEglinkR5jTXAaEH3ObHqWqG6bRl18/+2Uo
         ATg89SzrSddnNmZEnFiKW49vBwHnY2rWN46TUOfZnLaPp0nify3nawQcImxtQI9Iujg6
         4mOL/xSoiFT2nARBPq5wzG73a/nypAOY8MFQ6992Y/ZZKqzcVwSEN8M+88tYuwdyzKGo
         gs0aFdyySFn2xJQqvzOAj6Bvewgw3DWa8+269oWPGKDYxc4SAKr7QRH2Gf7k7j/Lqu4P
         DhIg==
X-Gm-Message-State: AOAM5329O24vRNxhaKDgCNHGIA3tS9JJRmWUNaIsygsDNgEbn7EIRilu
        67QjQYQ4k9P0mMTt8h3tIVgXE5m+s7AEmQ8NRVJYocuO/hmQ8xJt6GWgai55djADc04/CWKdrl6
        vVXk4Fq0EGqB0
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr39135212wri.359.1635343472025;
        Wed, 27 Oct 2021 07:04:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMG5hMHU+fqjF6OiSm16HnX+RXpo9rofMs4qTZ/GsQ4SgoEFZ97KLsPkMhH1j+K05s+YoZkQ==
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr39135082wri.359.1635343471021;
        Wed, 27 Oct 2021 07:04:31 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d76.dip0.t-ipconnect.de. [79.242.61.118])
        by smtp.gmail.com with ESMTPSA id 126sm3461950wmz.28.2021.10.27.07.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 07:04:29 -0700 (PDT)
Message-ID: <7f1ee7ea-0100-a7ac-4322-316ccc75d85f@redhat.com>
Date:   Wed, 27 Oct 2021 16:04:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
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
 <4ce74e8f-080d-9a0d-1b5b-6f7a7203e2ab@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <4ce74e8f-080d-9a0d-1b5b-6f7a7203e2ab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.10.21 15:36, Philippe Mathieu-Daudé wrote:
> On 10/27/21 14:45, David Hildenbrand wrote:
>> Let's return the number of free slots instead of only checking if there
>> is a free slot. Required to support memory devices that consume multiple
>> memslots.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>  hw/mem/memory-device.c    | 2 +-
>>  hw/virtio/vhost-stub.c    | 2 +-
>>  hw/virtio/vhost.c         | 4 ++--
>>  include/hw/virtio/vhost.h | 2 +-
>>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
>> --- a/hw/virtio/vhost-stub.c
>> +++ b/hw/virtio/vhost-stub.c
>> @@ -2,7 +2,7 @@
>>  #include "hw/virtio/vhost.h"
>>  #include "hw/virtio/vhost-user.h"
>>  
>> -bool vhost_has_free_slot(void)
>> +unsigned int vhost_get_free_memslots(void)
>>  {
>>      return true;
> 
>        return 0;

Oh wait, no. This actually has to be

"return ~0U;" (see real vhost_get_free_memslots())

... because there is no vhost and consequently no limit applies.

-- 
Thanks,

David / dhildenb

