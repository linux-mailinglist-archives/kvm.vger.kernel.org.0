Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53FB442996
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 09:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKBIgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 04:36:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhKBIge (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 04:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635842039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7fsGBnnhC8BQeylsaAgY7K2+bRY3MKBnbDUAo28LV0=;
        b=cRNKTpjUbDUrBTKmPg8GdSKia7bspo18WcuXmkvh4BiF6QTtjcQTMEymgzElROn0E50oUg
        xVzZ9dGYhM7JrC70/zp/FOROmwydv6xWYh/wpNSnqnphY+OHLOqsJ9N8C8Aunj3zqYPk7p
        lmwY+03uC1Bbbq4LV0RtT1lwSliVBQU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-COh9qV0nMy23c_FlUK77gA-1; Tue, 02 Nov 2021 04:33:58 -0400
X-MC-Unique: COh9qV0nMy23c_FlUK77gA-1
Received: by mail-wr1-f70.google.com with SMTP id r12-20020adfdc8c000000b0017d703c07c0so3966709wrj.0
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 01:33:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=q7fsGBnnhC8BQeylsaAgY7K2+bRY3MKBnbDUAo28LV0=;
        b=RwrSHALtud/b0G6bqdtHErjEllrmC0pwslsMcd4hVgt57U7ArzaPIWF2rAZe0Wujgy
         MfgauFWslJLQJwUWhC7D0A8dMVAzJcVcxWTJmosTDiFoFKDi0sUbFZlNVqM688bGHWl/
         K7nEd1x3y01Ev0DgJ4vDL6w9Pvhmd+JKXKGYFiUqfkh9GVQCu/qiPhaajGDAZp4TDPsE
         KfP4hwlKQce9pwygkIBMHBx50WsoVx/adc3IW2SR67by+v2DTqfRTrk3CENNmgAXCLK3
         RNkX1/3rWaeteVE13qpxsDeHRil5eIotKzxeRrXTLEi/9b5iCahHZOriQNrYlaRnMN2L
         /X4g==
X-Gm-Message-State: AOAM533kUhQRH1pXgtTAOMHONisXEEaRgtdKy8m62pGQLwK5R0kT6LLU
        YzH8TypHXE3+PsHnJWhHQXZVE3W4LqmjGyaDan0nZFhLB0ypTsCqBwsUts1Gy9dXVZcet0u8M1G
        rTJrwHoDBJwQK
X-Received: by 2002:adf:e109:: with SMTP id t9mr12442504wrz.387.1635842037403;
        Tue, 02 Nov 2021 01:33:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs2tnlyBrfSp//qVukaaX2gV3Nt62R9ZyF4w+gV8LdMIo4KHmR/ftwxaIaWeKCzGOnk9KbOA==
X-Received: by 2002:adf:e109:: with SMTP id t9mr12442485wrz.387.1635842037201;
        Tue, 02 Nov 2021 01:33:57 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id z8sm10432494wrh.54.2021.11.02.01.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 01:33:56 -0700 (PDT)
Message-ID: <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
Date:   Tue, 2 Nov 2021 09:33:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
References: <20211027124531.57561-1-david@redhat.com>
 <20211101181352-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
In-Reply-To: <20211101181352-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.11.21 23:15, Michael S. Tsirkin wrote:
> On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
>> This is the follow-up of [1], dropping auto-detection and vhost-user
>> changes from the initial RFC.
>>
>> Based-on: 20211011175346.15499-1-david@redhat.com
>>
>> A virtio-mem device is represented by a single large RAM memory region
>> backed by a single large mmap.
>>
>> Right now, we map that complete memory region into guest physical addres
>> space, resulting in a very large memory mapping, KVM memory slot, ...
>> although only a small amount of memory might actually be exposed to the VM.
>>
>> For example, when starting a VM with a 1 TiB virtio-mem device that only
>> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
>> in order to hotplug more memory later, we waste a lot of memory on metadata
>> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
>> optimizations in KVM are being worked on to reduce this metadata overhead
>> on x86-64 in some cases, it remains a problem with nested VMs and there are
>> other reasons why we would want to reduce the total memory slot to a
>> reasonable minimum.
>>
>> We want to:
>> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
>>    inside QEMU KVM code where possible.
>> b) Not always expose all device-memory to the VM, to reduce the attack
>>    surface of malicious VMs without using userfaultfd.
> 
> I'm confused by the mention of these security considerations,
> and I expect users will be just as confused.

Malicious VMs wanting to consume more memory than desired is only
relevant when running untrusted VMs in some environments, and it can be
caught differently, for example, by carefully monitoring and limiting
the maximum memory consumption of a VM. We have the same issue already
when using virtio-balloon to logically unplug memory. For me, it's a
secondary concern ( optimizing a is much more important ).

Some users showed interest in having QEMU disallow access to unplugged
memory, because coming up with a maximum memory consumption for a VM is
hard. This is one step into that direction without having to run with
uffd enabled all of the time.

("security is somewhat the wrong word. we won't be able to steal any
information from the hypervisor.)


> So let's say user wants to not be exposed. What value for
> the option should be used? What if a lower option is used?
> Is there still some security advantage?

My recommendation will be to use 1 memslot per gigabyte as default if
possible in the configuration. If we have a virtio-mem devices with a
maximum size of 128 GiB, the suggestion will be to use memslots=128.
Some setups will require less (e.g., vhost-user until adjusted, old
KVM), some setups can allow for more. I assume that most users will
later set "memslots=0", to enable auto-detection mode.


Assume we have a virtio-mem device with a maximum size of 1 TiB and we
hotplugged 1 GiB to the VM. With "memslots=1", the malicious VM could
actually access the whole 1 TiB. With "memslots=1024", the malicious VM
could only access additional ~ 1 GiB. With "memslots=512", ~ 2 GiB.
That's the reduced attack surface.

Of course, it's different after we hotunplugged memory, before we have
VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE support in QEMU, because all memory
inside the usable region has to be accessible and we cannot "unplug" the
memslots.


Note: With upcoming VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE changes in QEMU,
one will be able to disallow any access for malicious VMs by setting the
memblock size just as big as the device block size.

So with a 128 GiB virtio-mem device with memslots=128,block-size=1G, or
with memslots=1024,block-size=128M we could make it impossible for a
malicious VM to consume more memory than intended. But we lose
flexibility due to the block size and the limited number of available
memslots.

But again, for "full protection against malicious VMs" I consider
userfaultfd protection more flexible. This approach here gives some
advantage, especially when having large virtio-mem devices that start
out small.

-- 
Thanks,

David / dhildenb

