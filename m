Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC342DA20
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhJNNT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:19:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhJNNT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 09:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634217472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NM1i2J1rp8JeWkPr4/uwbyR3ctjMXN7223LR2qKUpY=;
        b=jOBc7kDMC3XONRCkXvLLok77PrQOPx0xr0POMbNdFRsPyW63NXLp0IaJG1woFKfDPvwTBW
        Wxv2puZ0LBUEkmHMfzvDjOTGv/CwaolzU1LRiPYspYoJEaBCq9/uchS4X+dbN4LgZdYZg/
        RCvcUIGYENzLesjw3pZMObox/AULeSY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-x7pB5mEOMS6fSaA_Dp-DCA-1; Thu, 14 Oct 2021 09:17:50 -0400
X-MC-Unique: x7pB5mEOMS6fSaA_Dp-DCA-1
Received: by mail-wr1-f72.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso4552266wrg.1
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 06:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=+NM1i2J1rp8JeWkPr4/uwbyR3ctjMXN7223LR2qKUpY=;
        b=rfGdtGFmLl6QqCGmSYx8QrI5L4n64wKuOaaNoQKj/Yi3h807lACKiRL38XwAPWCSYd
         g9B6WtgbNXlQGa0VkGis6wFaTRYfHrU3W8YF5VNkx5/9KmWuQsHbJNrgKSqrs9gJyTVJ
         whP8DfBtnNGtwOPeI7jaGnJGk3xQNp7Iw2A0IGNIj/1SIvW/6a0POsNJ9xW6psSlaJ6d
         OgxX8VBOAKpTHFM3cxHw2BYfJhTZ0ZzCdRnYQTDuVjRJdE+2EsFaVLCdBcHOZa3sQR8Q
         pY1HU5JQz4LXrjlSAMjDa9VppX5xTdY1GlpE0ckUZK/CPFAU8M62Ni7cfxbltKX6fw/M
         idcQ==
X-Gm-Message-State: AOAM531nE0RLBpkpYNQ8/Fv6NESuVTKiLpxkphuBnSazfeho726n3gPS
        ziDRRBEV8BYZIhdeImRGNQ3Wml2NhRrfqlTG4xim3N845jsP2dxzudBaHa7MeO5da/AiozI/csU
        Mi2+x3EZUnW3r
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr6666734wrh.131.1634217469621;
        Thu, 14 Oct 2021 06:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2BfYIGMw79FwUmfGlEluL+KqUBa1b2ecvJGEpX5k+JnUg3VeJnT6NiIpjp/IKGNNy7P2dmg==
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr6666700wrh.131.1634217469359;
        Thu, 14 Oct 2021 06:17:49 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c694e.dip0.t-ipconnect.de. [91.12.105.78])
        by smtp.gmail.com with ESMTPSA id l2sm2353420wrw.42.2021.10.14.06.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 06:17:48 -0700 (PDT)
Message-ID: <83270a38-a179-b2c5-9bab-7dd614dc07d6@redhat.com>
Date:   Thu, 14 Oct 2021 15:17:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org
References: <20211013103330.26869-1-david@redhat.com>
 <20211013103330.26869-13-david@redhat.com> <YWgYdWXsiI2mcfak@work-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH RFC 12/15] virtio-mem: Expose device memory via separate
 memslots
In-Reply-To: <YWgYdWXsiI2mcfak@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.10.21 13:45, Dr. David Alan Gilbert wrote:
> * David Hildenbrand (david@redhat.com) wrote:
>> KVM nowadays supports a lot of memslots. We want to exploit that in
>> virtio-mem, exposing device memory via separate memslots to the guest
>> on demand, essentially reducing the total size of KVM slots
>> significantly (and thereby metadata in KVM and in QEMU for KVM memory
>> slots) especially when exposing initially only a small amount of memory
>> via a virtio-mem device to the guest, to hotplug more later. Further,
>> not always exposing the full device memory region to the guest reduces
>> the attack surface in many setups without requiring other mechanisms
>> like uffd for protection of unplugged memory.
>>
>> So split the original RAM region via memory region aliases into separate
>> chunks (ending up as individual memslots), and dynamically map the
>> required chunks (falling into the usable region) into the container.
>>
>> For now, we always map the memslots covered by the usable region. In the
>> future, with VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to map
>> memslots on actual demand and optimize further.
>>
>> Users can specify via the "max-memslots" property how much memslots the
>> virtio-mem device is allowed to use at max. "0" translates to "auto, no
>> limit" and is determinded automatically using a heuristic. When a maximum
>> (> 1) is specified, that auto-determined value is capped. The parameter
>> doesn't have to be migrated and can differ between source and destination.
>> The only reason the parameter exists is not make some corner case setups
>> (multiple large virtio-mem devices assigned to a single virtual NUMA node
>>  with only very limited available memslots, hotplug of vhost devices) work.
>> The parameter will be set to be "0" as default soon, whereby it will remain
>> to be "1" for compat machines.
>>
>> The properties "memslots" and "used-memslots" are read-only.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> I think you need to move this patch after the vhost-user patches so that
> you don't break a bisect including vhost-user.

As the default is set to 1 and is set to 0 ("auto") in the last patch in
this series, there should be (almost) no difference regarding vhost-user.

> 
> But I do worry about the effect on vhost-user:

The 4096 limit was certainly more "let's make it extreme so we raise
some eyebrows and we can talk about the implications". I'd be perfectly
happy with 256 or better 512. Anything that's bigger than 32 in case of
virtiofsd :)

>   a) What about external programs like dpdk?

At least initially virtio-mem won't apply to dpdk and similar workloads
(RT). For example, virtio-mem is incompatible with mlock. So I think the
most important use case to optimize for is virtio-mem+virtiofsd
(especially kata).

>   b) I worry if you end up with a LOT of slots you end up with a lot of
> mmap's and fd's in vhost-user; I'm not quite sure what all the effects
> of that will be.

At least for virtio-mem, there will be a small number of fd's, as many
memslots share the same fd, so with virtio-mem it's not an issue.

#VMAs is indeed worth discussing. Usually we can have up to 64k VMAs in
a process. The downside of having many is some reduce pagefault
performance. It really also depends on the target application. Maybe
there should be some libvhost-user toggle, where the application can opt
in to allow more?

-- 
Thanks,

David / dhildenb

