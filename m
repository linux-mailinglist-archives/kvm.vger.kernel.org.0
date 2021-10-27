Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE40443CDDF
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 17:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhJ0Prm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 11:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233252AbhJ0Prl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 11:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635349515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SIGkDHIUVkYP70eTHFjrm/6ZTOCdlcXs59fUFAQIFH4=;
        b=KeIUhgO9OZIFli1o85PS+5DI+X0nB6pcCBnc+SCfRuhB6+jBuRxFWnvYnLiKybqgjFNw4l
        FSO11zWL8shZZYhL1JI05RXf8YboaLFYHK9Nti1NkHAyBVo0N4edQgkA3RtZ3Q83OtMvZs
        wjSc02sVQxUY4NuDgrnBPKhkOV+JODg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-LkaaYnfCNTaVOT0uy5EAxg-1; Wed, 27 Oct 2021 11:45:14 -0400
X-MC-Unique: LkaaYnfCNTaVOT0uy5EAxg-1
Received: by mail-wm1-f70.google.com with SMTP id v10-20020a1cf70a000000b00318203a6bd1so1337730wmh.6
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 08:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=SIGkDHIUVkYP70eTHFjrm/6ZTOCdlcXs59fUFAQIFH4=;
        b=t4Wlcyx38rDwFDVV/StEJgpGyEnc1vsSs3WwmUnNHAPpjflLtjwxQXcir8dE1UPanp
         9plsQho5NdssyEEM/Y2yKkVKwFqmTXWlzH9ANzJ3ozFJvvSMqY9MxJSiC3HGqVu9KZg+
         klAqqtKWxKTsg6VCmBknnuW82k6p0sUZzmgjmPunsiBv+Yx42XfG7QMJBB9BR4y0CQPD
         HBNuNNgxjgklQOl7VOy2hRx+bGv5ZJwng1IOMiYJ92vXYGgcLw9XkNjY+tuVL+bypovw
         4lfLw5dHcRb9q4mTS9yXybILYwsG9hSGm6LWlD0Ekxd9FVox6NwGeFEmAwA31BuFOw+s
         6CNg==
X-Gm-Message-State: AOAM532zLzIeVOo3ma2orhdT783oK65SujjkvYlTWU3F2Vcy+qEdNjSf
        hr4yaZKeSkQeasJdbVuntrwan4sCJAGDMzAw6/aW4Ym1qOSZdDuynPRo/HciMPniVAwte1r68TW
        TBcfFLtxx14yE
X-Received: by 2002:a7b:c8d0:: with SMTP id f16mr6422796wml.193.1635349513364;
        Wed, 27 Oct 2021 08:45:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHTYW5hgWloBaFrBCq9K/FgnbelKLC8BS0fFuuZPYsub01BQvaMISk1qWWRLde3+jZig5qCw==
X-Received: by 2002:a7b:c8d0:: with SMTP id f16mr6422768wml.193.1635349513180;
        Wed, 27 Oct 2021 08:45:13 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d76.dip0.t-ipconnect.de. [79.242.61.118])
        by smtp.gmail.com with ESMTPSA id m125sm3608153wmm.44.2021.10.27.08.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:45:12 -0700 (PDT)
Message-ID: <1a01da70-fc6d-f0f0-bd75-8f0a3c2dff94@redhat.com>
Date:   Wed, 27 Oct 2021 17:45:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org,
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
 <7f1ee7ea-0100-a7ac-4322-316ccc75d85f@redhat.com>
 <8fc703aa-a256-fdef-36a5-6faad3da47d6@redhat.com>
 <20211027113245-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211027113245-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.10.21 17:33, Michael S. Tsirkin wrote:
> On Wed, Oct 27, 2021 at 04:11:38PM +0200, Philippe Mathieu-Daudé wrote:
>> On 10/27/21 16:04, David Hildenbrand wrote:
>>> On 27.10.21 15:36, Philippe Mathieu-Daudé wrote:
>>>> On 10/27/21 14:45, David Hildenbrand wrote:
>>>>> Let's return the number of free slots instead of only checking if there
>>>>> is a free slot. Required to support memory devices that consume multiple
>>>>> memslots.
>>>>>
>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>> ---
>>>>>  hw/mem/memory-device.c    | 2 +-
>>>>>  hw/virtio/vhost-stub.c    | 2 +-
>>>>>  hw/virtio/vhost.c         | 4 ++--
>>>>>  include/hw/virtio/vhost.h | 2 +-
>>>>>  4 files changed, 5 insertions(+), 5 deletions(-)
>>
>>>>> -bool vhost_has_free_slot(void)
>>>>> +unsigned int vhost_get_free_memslots(void)
>>>>>  {
>>>>>      return true;
>>>>
>>>>        return 0;
>>>
>>> Oh wait, no. This actually has to be
>>>
>>> "return ~0U;" (see real vhost_get_free_memslots())
>>>
>>> ... because there is no vhost and consequently no limit applies.
>>
>> Indeed.
>>
>> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> confused. are you acking the theoretical patch with ~0 here?
> 

That's how I interpreted it.

-- 
Thanks,

David / dhildenb

