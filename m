Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4491543CACC
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhJ0Njw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 09:39:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35487 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235710AbhJ0Njv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 09:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635341845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ut7JFSM6pT1dCI/plvMy2BAlhUzvqJVXt8BhFqSqPVU=;
        b=CoCxm7dncniwko/9FMSbtKMGFg3CMW2RPC54SXOhdOkncu2zOm6fPZlZUF4zSRWQ0XmLTL
        am7/Er0GRl5KVzZAqy77mlmIe1i55eaUOnu4fA9fYDINCN5vDa6JXR8a3F0agaPG6tjlnR
        /sVml1t4YrsHY7spVOACIHRHtQtec/4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-RKSoTTqANW2LyPhL8a7OEA-1; Wed, 27 Oct 2021 09:37:24 -0400
X-MC-Unique: RKSoTTqANW2LyPhL8a7OEA-1
Received: by mail-wm1-f70.google.com with SMTP id l187-20020a1c25c4000000b0030da46b76daso1984930wml.9
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 06:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Ut7JFSM6pT1dCI/plvMy2BAlhUzvqJVXt8BhFqSqPVU=;
        b=hHgQuCjpZGhYfnFcJlIq7aZseZ3OovvjPZ7BXqeIqsohYsGXh0+fvqpl8IfQ9zojpB
         UoawiHw8lNfPLNnwHh2WUZenQOMJbBioHvr5BR9ekzNTNKY7NtIxXndjs0y6PFIN3wJR
         TjY41WQHohroM6LHRWQ52O+WrLY9LN0OA0JaykDZUM6p1lvrCZXB1uiBhynEmDuSFo3n
         BzFeN/NBgLCDVOFBoM9Jz7FqvsetmBFhBbMpgJyo4pYpcn6in5akuEi3B9BBWHLe34DI
         fOdr90YhOj1D2ue8MLZ7m5wfvnCRFwfrOAdRl3UIhlKnlr51XN8beLttJ1n4GjNwtcCJ
         X94A==
X-Gm-Message-State: AOAM533Ib4nmw/a83108cpyO4B1HDObWxzr/aNqLBkmMGjTZTBaenTVS
        A3rUF7OXtkPXjY3N975f+pNZsFFly/k7sMWYn8lsOMjn/LNeacSUzfQwANxWFec+9b6A54/sS+k
        Uhxp9l6Ua8INc
X-Received: by 2002:a05:6000:154b:: with SMTP id 11mr40214380wry.422.1635341843365;
        Wed, 27 Oct 2021 06:37:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSE64BO1997/KxNCx8CUwU8ijBlTBVBUYZasxWGQVPEl+UMA5zCI9OPkDTTnCzFDbSMFniRg==
X-Received: by 2002:a05:6000:154b:: with SMTP id 11mr40214352wry.422.1635341843200;
        Wed, 27 Oct 2021 06:37:23 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d76.dip0.t-ipconnect.de. [79.242.61.118])
        by smtp.gmail.com with ESMTPSA id a4sm3300928wmb.39.2021.10.27.06.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 06:37:22 -0700 (PDT)
Message-ID: <a656bb15-0bf1-1738-c6de-6db31bc269c2@redhat.com>
Date:   Wed, 27 Oct 2021 15:37:21 +0200
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

Thanks, nice catch!

-- 
Thanks,

David / dhildenb

