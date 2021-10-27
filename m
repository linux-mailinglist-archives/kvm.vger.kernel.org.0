Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1243CF0B
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbhJ0Qx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 12:53:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242964AbhJ0Qxy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 12:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635353488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gy5cJnvtXii1KYg8kaPz4ztKoxko3IwoHdJfXjXNCAc=;
        b=ewq5zh8w2I8nsNmU8fp0O8mdjeg8NrnHFzSpRTKYy7T4Y19a7VibRL0Xb/ZTnEXJ3I0pOV
        8loXmRiC7ff2YnEtPu3Sj5TRROYPOqBRj35b1c8oSlMxLV0o7vt46kOfEEJqkDSvx4vVZp
        O7gfN8hV/7SA0ZJ3p/uu3P2+aqBNlPM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416--BTuqxa0Ng-mqilv4rh4SQ-1; Wed, 27 Oct 2021 12:51:27 -0400
X-MC-Unique: -BTuqxa0Ng-mqilv4rh4SQ-1
Received: by mail-wm1-f71.google.com with SMTP id k126-20020a1ca184000000b003231d0e329bso2140022wme.4
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 09:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=gy5cJnvtXii1KYg8kaPz4ztKoxko3IwoHdJfXjXNCAc=;
        b=COPxvlmKgJTLBSe26S2JBk70MVFynGLD5Rei4hIBUmQQCeaobI0b3yzeZocUExl1YK
         ac0olyfhVyMG5sLuQab31GANpANG2Mc/WkmtrHncrALNxUiSMm2Eq8ixFzkFGNccao8g
         z0FT+frhB1W4qVIMwX+zeQtxN+KcJfm+W4eT+YQX3KmjgTrK7wcLEliCn96kb23sJ/uG
         x1anCThTQD1+PZipl8wOIge0MmtXcBGElSobRnv2C8H/xsaOBCUnclLsRXxwOisppxua
         10CXrj4fujZl0597lqpWnrr/AsVFqtiPrgRh7JPn99UTM0dzuTB13EzIrr+czkUhtrGW
         +rpg==
X-Gm-Message-State: AOAM531q3YPZ0yu90OM1eK2wApyCKAtwMp9vU92c1B2HgIrDpoYi9iK+
        mbbNAJYJiWcNpGqQeFcAFgUHgvQSXNAE7BDKsK32pXhvFiUN3+vW75Lg9SFX2QY/7ZkJFATZ1GR
        yYgFGQ4jnZEtk
X-Received: by 2002:a5d:530e:: with SMTP id e14mr42490470wrv.326.1635353486061;
        Wed, 27 Oct 2021 09:51:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvOL9tcB4shi2C0GoOD7T7Et3/vAlnQm4M0rMtYahyCRUvvNXt2UK95E6yY2/83fDh2wAYXA==
X-Received: by 2002:a5d:530e:: with SMTP id e14mr42490425wrv.326.1635353485826;
        Wed, 27 Oct 2021 09:51:25 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23d76.dip0.t-ipconnect.de. [79.242.61.118])
        by smtp.gmail.com with ESMTPSA id r1sm4339811wmr.36.2021.10.27.09.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 09:51:25 -0700 (PDT)
Message-ID: <747f8a27-5a06-7a82-803f-e5bbf2bbbd7b@redhat.com>
Date:   Wed, 27 Oct 2021 18:51:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
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
 <99dde5cf-2f96-18c9-a806-f72365f68f8c@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <99dde5cf-2f96-18c9-a806-f72365f68f8c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.10.21 18:11, Philippe Mathieu-Daudé wrote:
> On 10/27/21 17:45, David Hildenbrand wrote:
>> On 27.10.21 17:33, Michael S. Tsirkin wrote:
>>> On Wed, Oct 27, 2021 at 04:11:38PM +0200, Philippe Mathieu-Daudé wrote:
>>>> On 10/27/21 16:04, David Hildenbrand wrote:
>>>>> On 27.10.21 15:36, Philippe Mathieu-Daudé wrote:
>>>>>> On 10/27/21 14:45, David Hildenbrand wrote:
>>>>>>> Let's return the number of free slots instead of only checking if there
>>>>>>> is a free slot. Required to support memory devices that consume multiple
>>>>>>> memslots.
>>>>>>>
>>>>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>>>>> ---
>>>>>>>  hw/mem/memory-device.c    | 2 +-
>>>>>>>  hw/virtio/vhost-stub.c    | 2 +-
>>>>>>>  hw/virtio/vhost.c         | 4 ++--
>>>>>>>  include/hw/virtio/vhost.h | 2 +-
>>>>>>>  4 files changed, 5 insertions(+), 5 deletions(-)
>>>>
>>>>>>> -bool vhost_has_free_slot(void)
>>>>>>> +unsigned int vhost_get_free_memslots(void)
>>>>>>>  {
>>>>>>>      return true;
>>>>>>
>>>>>>        return 0;
>>>>>
>>>>> Oh wait, no. This actually has to be
>>>>>
>>>>> "return ~0U;" (see real vhost_get_free_memslots())
>>>>>
>>>>> ... because there is no vhost and consequently no limit applies.
>>>>
>>>> Indeed.
>>>>
>>>> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>
>>> confused. are you acking the theoretical patch with ~0 here?
>>>
>>
>> That's how I interpreted it.
> 
> ~0U doesn't seem harmful when comparing. However I haven't tested
> nor looked at the big picture. I wonder if vhost_has_free_slot()
> shouldn't take the Error* as argument and each implementation set
> the error message ("virtio/vhost support disabled" would be more
> explicit in the stub case). But I still don't understand why when
> built without virtio/vhost we return vhost_get_free_memslots() > 0.

For the same reason we faked infinite slots via
vhost_has_free_slot()->true for now. We call it unconditionally from
memory device code.

Sure, we could add a stub "vhost_available()-> false" (or
vhost_enabled() ?) instead and do

if (vhost_available())
	... vhost_get_free_memslots()

similar to how we have

if (kvm_enabled())
	... kvm_get_free_memslots()

Not sure if it's worth it, though.

-- 
Thanks,

David / dhildenb

