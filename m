Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C73142D324
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 09:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhJNHEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 03:04:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229902AbhJNHEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 03:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634194923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nV+9cAXFAaAUf9+EligMbnXZds0iT1HILQQ/LHkCQ8M=;
        b=OqE5a553O0PqCr56bdkCpQoQAmvIhYdOwHhX8piVT0bsu/7pnlc7DsCP6wgh+D8Z8wAAC5
        xaJV3atir9vuWuXE08Z4VFY7Mgx5wQRdydTBkJ9+LUkFSTgmtXiPV2AsZYBb0hJ/MTIbOn
        2jYxBRZPhKvAC8h9jINFUAhL9DdzfW8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-wTB049rsO8uhF8wTLsvZ_Q-1; Thu, 14 Oct 2021 03:02:02 -0400
X-MC-Unique: wTB049rsO8uhF8wTLsvZ_Q-1
Received: by mail-wr1-f71.google.com with SMTP id d13-20020adfa34d000000b00160aa1cc5f1so3783961wrb.14
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 00:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=nV+9cAXFAaAUf9+EligMbnXZds0iT1HILQQ/LHkCQ8M=;
        b=gOy+xFYyX//huyhFuHDjva3ejEQ7tM7Td+pisttqDSX2LhmA6xVrb0nY0kTPI/47Mr
         +asJUPAxu21lmDPnoX6v8JBYMP1dOknJPezhYlcnIkkFTGioeTEPGcnTXmePpoxSrfsD
         vL9/cii9Sk0vo10G5u8tCIipMRCOVl6Eoq0cIQjnRmC7NrtO/VRu/8Y7hKNRcfN1+K9d
         BaGlxf21Zpq06+Z7yNaWEkEC3BLbLK06rNuWf7vg711N3Pbj3vMb0SNNq06CxLBC+B+z
         xR20WGbkwMhtv+/aAlsV9+iKMrbYPDNN2uwWUnVZk8zGfRrR3dXbQd7qgua0G1yjKRx4
         pUJQ==
X-Gm-Message-State: AOAM532QWgZTfICpikOGltkIRPV+UyekFF2w1D7EhYCwuaMhy8qGUodP
        +YQQE+4+XvvfTbaOftHyLBieMkJzJ/OPhDx1cybL8G7R5KWQI284K3AvVKV4GGIaPY+Rh8pY/0w
        eG1O1ubJ27wFQ
X-Received: by 2002:adf:a4d5:: with SMTP id h21mr4513637wrb.203.1634194920801;
        Thu, 14 Oct 2021 00:02:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDx2I3U4zxq/63r7oAUEGjcUmSrHpTlks2tcl8ZftOIzFaiE3I9j4MrrbpibabmH0jBI2hHw==
X-Received: by 2002:adf:a4d5:: with SMTP id h21mr4513615wrb.203.1634194920578;
        Thu, 14 Oct 2021 00:02:00 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c694e.dip0.t-ipconnect.de. [91.12.105.78])
        by smtp.gmail.com with ESMTPSA id q7sm1609405wrs.73.2021.10.14.00.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 00:02:00 -0700 (PDT)
Message-ID: <f63fc766-a044-7978-df40-27dff8f79bf5@redhat.com>
Date:   Thu, 14 Oct 2021 09:01:59 +0200
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
 <YWcthytjDJUXdN0w@work-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH RFC 00/15] virtio-mem: Expose device memory via separate
 memslots
In-Reply-To: <YWcthytjDJUXdN0w@work-vm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.10.21 21:03, Dr. David Alan Gilbert wrote:
> * David Hildenbrand (david@redhat.com) wrote:
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
>>
>> So instead, expose the RAM memory region not by a single large mapping
>> (consuming one memslot) but instead by multiple mappings, each consuming
>> one memslot. To do that, we divide the RAM memory region via aliases into
>> separate parts and only map the aliases into a device container we actually
>> need. We have to make sure that QEMU won't silently merge the memory
>> sections corresponding to the aliases (and thereby also memslots),
>> otherwise we lose atomic updates with KVM and vhost-user, which we deeply
>> care about when adding/removing memory. Further, to get memslot accounting
>> right, such merging is better avoided.
>>
>> Within the memslots, virtio-mem can (un)plug memory in smaller granularity
>> dynamically. So memslots are a pure optimization to tackle a) and b) above.
>>
>> Memslots are right now mapped once they fall into the usable device region
>> (which grows/shrinks on demand right now either when requesting to
>>  hotplug more memory or during/after reboots). In the future, with
>> VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to (un)map aliases even
>> more dynamically when (un)plugging device blocks.
>>
>>
>> Adding a 500GiB virtio-mem device and not hotplugging any memory results in:
>>     0000000140000000-000001047fffffff (prio 0, i/o): device-memory
>>       0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
>>
>> Requesting the VM to consume 2 GiB results in (note: the usable region size
>> is bigger than 2 GiB, so 3 * 1 GiB memslots are required):
>>     0000000140000000-000001047fffffff (prio 0, i/o): device-memory
>>       0000000140000000-0000007e3fffffff (prio 0, i/o): virtio-mem-memslots
>>         0000000140000000-000000017fffffff (prio 0, ram): alias virtio-mem-memslot-0 @mem0 0000000000000000-000000003fffffff
>>         0000000180000000-00000001bfffffff (prio 0, ram): alias virtio-mem-memslot-1 @mem0 0000000040000000-000000007fffffff
>>         00000001c0000000-00000001ffffffff (prio 0, ram): alias virtio-mem-memslot-2 @mem0 0000000080000000-00000000bfffffff
> 
> I've got a vague memory that there were some devices that didn't like
> doing split IO across a memory region (or something) - some virtio
> devices?  Do you know if that's still true and if that causes a problem?

Interesting point! I am not aware of any such issues, and I'd be
surprised if we'd still have such buggy devices, because the layout
virtio-mem now creates is just very similar to the layout we'll
automatically create with ordinary DIMMs.

If we hotplug DIMMs they will end up consecutive in guest physical
address space, however, having separate memory regions and requiring
separate memory slots. So, very similar to a virtio-mem device now.

Maybe the catch is that it's hard to cross memory regions that are e.g.,
>- 128 MiB aligned, because ordinary allocations (e.g., via the buddy in
Linux which supports <= 4 MiB pages) in won't cross these blocks.

-- 
Thanks,

David / dhildenb

