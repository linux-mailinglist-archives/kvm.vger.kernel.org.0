Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A718F43CE6D
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhJ0QON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 12:14:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232600AbhJ0QON (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 12:14:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635351106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tp8pI/NX9R97ElgvFrMxoiR0pIFpk3lkgyhZal5vqeg=;
        b=Zs9GL0nLoyXIyEKkc3CukDfyDjlL9U+6HDo/BzQqrOj85HProVs5MH9QHUk/79Vssmf2L6
        /cOJdtlUHYfSEUE2ixYZDS6Nmvw+3SyqnfzCQFbwHObwxsIEzV4y1yXqSqeIcUeTf0x6fR
        ahV62zTpinR504LmRbSPROheTfiz7K4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-LJnO9FXKM0y1LKNapU3KPQ-1; Wed, 27 Oct 2021 12:11:45 -0400
X-MC-Unique: LJnO9FXKM0y1LKNapU3KPQ-1
Received: by mail-wm1-f72.google.com with SMTP id g77-20020a1c2050000000b0032ccc05989cso1460249wmg.4
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 09:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Tp8pI/NX9R97ElgvFrMxoiR0pIFpk3lkgyhZal5vqeg=;
        b=hHk+1K+uE/h9bhicUl2479pepANaWBtzBS/ojS9uV5astIo4cpLVfinkbbfOvaICfP
         WEM1/Ihu+iIkaeSjhRxo/mGPlKrPMnk7r4+bj+tLkCPfLvrKwfHjY3qP4zx7ycU1Ec6v
         9RiZd3NLVQ8QaA0okE/GsCuvuleNk4/oIRqATQronNKNcC6FYD6C5LNjrPyFCraxgCGe
         Ygo4eL3M5XHSr4KXnMLr8sakxAGoH8z9ytb9BVs3q0rPpCtdE36SOpBkBNnJvug9jbFt
         MnIuF+gog8UznC7GpkbheSZv1DJgZ0X+kNI7SA5I87FCqhTH4bLJXwp8QwiD2f565QsV
         zsnA==
X-Gm-Message-State: AOAM530Swt0Yk2dXONRB0NK+txSG3tVdidZkp6Xc2bphQk7z5LuuybQj
        O0qpjJynJ+HogCdwTYveMOnkyPhKnmuZbqfm1ZPU0xDwh9NMwXoC65Eg8l43gA7R8C3ct8CZC9k
        jwhGy7P07PKGb
X-Received: by 2002:a5d:47c5:: with SMTP id o5mr12831778wrc.195.1635351104113;
        Wed, 27 Oct 2021 09:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpOLW7jV+/HatJTkMLZ6kOwq0FymModjxXnE+UfPNLOc8xkzUcru8/8mr4YXejMngGEKv0Wg==
X-Received: by 2002:a5d:47c5:: with SMTP id o5mr12831751wrc.195.1635351103961;
        Wed, 27 Oct 2021 09:11:43 -0700 (PDT)
Received: from [192.168.1.36] (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id r10sm296226wrl.92.2021.10.27.09.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 09:11:43 -0700 (PDT)
Message-ID: <99dde5cf-2f96-18c9-a806-f72365f68f8c@redhat.com>
Date:   Wed, 27 Oct 2021 18:11:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
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
 <1a01da70-fc6d-f0f0-bd75-8f0a3c2dff94@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <1a01da70-fc6d-f0f0-bd75-8f0a3c2dff94@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/21 17:45, David Hildenbrand wrote:
> On 27.10.21 17:33, Michael S. Tsirkin wrote:
>> On Wed, Oct 27, 2021 at 04:11:38PM +0200, Philippe Mathieu-Daudé wrote:
>>> On 10/27/21 16:04, David Hildenbrand wrote:
>>>> On 27.10.21 15:36, Philippe Mathieu-Daudé wrote:
>>>>> On 10/27/21 14:45, David Hildenbrand wrote:
>>>>>> Let's return the number of free slots instead of only checking if there
>>>>>> is a free slot. Required to support memory devices that consume multiple
>>>>>> memslots.
>>>>>>
>>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>>> ---
>>>>>>  hw/mem/memory-device.c    | 2 +-
>>>>>>  hw/virtio/vhost-stub.c    | 2 +-
>>>>>>  hw/virtio/vhost.c         | 4 ++--
>>>>>>  include/hw/virtio/vhost.h | 2 +-
>>>>>>  4 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>>>>> -bool vhost_has_free_slot(void)
>>>>>> +unsigned int vhost_get_free_memslots(void)
>>>>>>  {
>>>>>>      return true;
>>>>>
>>>>>        return 0;
>>>>
>>>> Oh wait, no. This actually has to be
>>>>
>>>> "return ~0U;" (see real vhost_get_free_memslots())
>>>>
>>>> ... because there is no vhost and consequently no limit applies.
>>>
>>> Indeed.
>>>
>>> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>
>> confused. are you acking the theoretical patch with ~0 here?
>>
> 
> That's how I interpreted it.

~0U doesn't seem harmful when comparing. However I haven't tested
nor looked at the big picture. I wonder if vhost_has_free_slot()
shouldn't take the Error* as argument and each implementation set
the error message ("virtio/vhost support disabled" would be more
explicit in the stub case). But I still don't understand why when
built without virtio/vhost we return vhost_get_free_memslots() > 0.

