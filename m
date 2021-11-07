Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77641447256
	for <lists+kvm@lfdr.de>; Sun,  7 Nov 2021 10:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhKGJYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Nov 2021 04:24:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234994AbhKGJYU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Nov 2021 04:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636276897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=olfzwTtSHUIfHVCl6XtPYdi4mvQIwS2D4a2QqwCFifc=;
        b=L7sakSEPazk9ZzAZ0o9gOlg9cbdiegJpIXYemNh2h5zVYGzs4mPrO6sScH+CpUJokHb0mp
        wTKGgJDJMXmV8cx50+kL3FKnXN7O8ESk5jNuGlAbGYj4XJkwgfN2X9Ilh5DU+hb7tP4/jF
        Qr4PCZMrAbvmAsaQkdP3KrFNOZ3bpdY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-8-yQc2oqO0mYaaDIRNMHwA-1; Sun, 07 Nov 2021 04:21:36 -0500
X-MC-Unique: 8-yQc2oqO0mYaaDIRNMHwA-1
Received: by mail-wr1-f72.google.com with SMTP id r12-20020adfdc8c000000b0017d703c07c0so2862760wrj.0
        for <kvm@vger.kernel.org>; Sun, 07 Nov 2021 01:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=olfzwTtSHUIfHVCl6XtPYdi4mvQIwS2D4a2QqwCFifc=;
        b=cAvH8S4AvpsNpFpQ9N2EbWPXUYvGprpGAtJWWijv71H8Cl/uA2vyoa+cqjmYmeiG+Z
         S3oLNFZCRHcD9vKH3Vk97YUERu8oK4gpmKI/qP5Rh+kLXR1o2RxPAmlMs3C+CoOkTYE7
         cK989C8LqxBH8cCPkopawY0r/mFKggWiqpn/HkwXKkp0wRQqxa2nPPhvLQh0WnGWVeTz
         1gn7/+uIYODSrF3i9CiEdop5fHMcIayXfihkeHW6YNSMesKMRuRI3I+A7f6Z3Knp6nFs
         iiol6CgUcQZq2ZPGHAKkffjfExMxHPcJ2+bR/hiiM4S2Jun9Nuw5fb5k+xC4ZkqSHWsE
         2r7w==
X-Gm-Message-State: AOAM533MsJsiAfGeQsutDJRQ5dNN5tPlb1krTZy52LcYWK+UM/ztumvP
        W6VRujz1DKm8ex8TzmAPDl+wE82CKfGj3gIUStpOF5+6y7kInEstYO/GSQnLWbJuyzO77s+n9t9
        qVc+lon/dUIil
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr45064945wmp.52.1636276895251;
        Sun, 07 Nov 2021 01:21:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyETHxRAngHYa7R7dHv9Vr3ecQLaLuP+5ugn9puKukXXr0doKpPm31X9p9sX/2s9B0zzS0lSg==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr45064926wmp.52.1636276895015;
        Sun, 07 Nov 2021 01:21:35 -0800 (PST)
Received: from ?IPV6:2003:d8:2f0c:a000:3f25:9662:b5cf:73f9? (p200300d82f0ca0003f259662b5cf73f9.dip0.t-ipconnect.de. [2003:d8:2f0c:a000:3f25:9662:b5cf:73f9])
        by smtp.gmail.com with ESMTPSA id a4sm11864894wmg.10.2021.11.07.01.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 01:21:34 -0800 (PST)
Message-ID: <f6071d5f-d100-a128-9f66-a801436aa78a@redhat.com>
Date:   Sun, 7 Nov 2021 10:21:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
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
 <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
 <20211102072843-mutt-send-email-mst@kernel.org>
 <171c8ed0-d55e-77ef-963b-6d836729ef4b@redhat.com>
 <20211102111228-mutt-send-email-mst@kernel.org>
 <e4b63a74-57ad-551c-0046-97a02eb798e5@redhat.com>
 <20211107031316-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211107031316-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.11.21 09:14, Michael S. Tsirkin wrote:
> On Tue, Nov 02, 2021 at 06:10:13PM +0100, David Hildenbrand wrote:
>> On 02.11.21 18:06, Michael S. Tsirkin wrote:
>>> On Tue, Nov 02, 2021 at 12:55:17PM +0100, David Hildenbrand wrote:
>>>> On 02.11.21 12:35, Michael S. Tsirkin wrote:
>>>>> On Tue, Nov 02, 2021 at 09:33:55AM +0100, David Hildenbrand wrote:
>>>>>> On 01.11.21 23:15, Michael S. Tsirkin wrote:
>>>>>>> On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
>>>>>>>> This is the follow-up of [1], dropping auto-detection and vhost-user
>>>>>>>> changes from the initial RFC.
>>>>>>>>
>>>>>>>> Based-on: 20211011175346.15499-1-david@redhat.com
>>>>>>>>
>>>>>>>> A virtio-mem device is represented by a single large RAM memory region
>>>>>>>> backed by a single large mmap.
>>>>>>>>
>>>>>>>> Right now, we map that complete memory region into guest physical addres
>>>>>>>> space, resulting in a very large memory mapping, KVM memory slot, ...
>>>>>>>> although only a small amount of memory might actually be exposed to the VM.
>>>>>>>>
>>>>>>>> For example, when starting a VM with a 1 TiB virtio-mem device that only
>>>>>>>> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
>>>>>>>> in order to hotplug more memory later, we waste a lot of memory on metadata
>>>>>>>> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
>>>>>>>> optimizations in KVM are being worked on to reduce this metadata overhead
>>>>>>>> on x86-64 in some cases, it remains a problem with nested VMs and there are
>>>>>>>> other reasons why we would want to reduce the total memory slot to a
>>>>>>>> reasonable minimum.
>>>>>>>>
>>>>>>>> We want to:
>>>>>>>> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
>>>>>>>>    inside QEMU KVM code where possible.
>>>>>>>> b) Not always expose all device-memory to the VM, to reduce the attack
>>>>>>>>    surface of malicious VMs without using userfaultfd.
>>>>>>>
>>>>>>> I'm confused by the mention of these security considerations,
>>>>>>> and I expect users will be just as confused.
>>>>>>
>>>>>> Malicious VMs wanting to consume more memory than desired is only
>>>>>> relevant when running untrusted VMs in some environments, and it can be
>>>>>> caught differently, for example, by carefully monitoring and limiting
>>>>>> the maximum memory consumption of a VM. We have the same issue already
>>>>>> when using virtio-balloon to logically unplug memory. For me, it's a
>>>>>> secondary concern ( optimizing a is much more important ).
>>>>>>
>>>>>> Some users showed interest in having QEMU disallow access to unplugged
>>>>>> memory, because coming up with a maximum memory consumption for a VM is
>>>>>> hard. This is one step into that direction without having to run with
>>>>>> uffd enabled all of the time.
>>>>>
>>>>> Sorry about missing the memo - is there a lot of overhead associated
>>>>> with uffd then?
>>>>
>>>> When used with huge/gigantic pages, we don't particularly care.
>>>>
>>>> For other memory backends, we'll have to route any population via the
>>>> uffd handler: guest accesses a 4k page -> place a 4k page from user
>>>> space. Instead of the kernel automatically placing a THP, we'd be
>>>> placing single 4k pages and have to hope the kernel will collapse them
>>>> into a THP later.
>>>
>>> How much value there is in a THP given it's not present?
>>
>> If you don't place a THP right during the first page fault inside the
>> THP region, you'll have to rely on khugepagd to eventually place a huge
>> page later -- and manually fault in each and every 4k page. I haven't
>> done any performance measurements so far. Going via userspace on every
>> 4k fault will most certainly hurt performance when first touching memory.
> 
> So, if the focus is performance improvement, maybe show the speedup?

Let's not focus on b), a) is the primary goal of this series:

"
a) Reduce the metadata overhead, including bitmap sizes inside KVM but
also inside QEMU KVM code where possible.
"

Because:

"
For example, when starting a VM with a 1 TiB virtio-mem device that only
exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
in order to hotplug more memory later, we waste a lot of memory on
metadata for KVM memory slots (> 2 GiB!) and accompanied bitmaps.
"

Partially tackling b) is just a nice side effect of this series. In the
long term, we'll want userfaultfd-based protection, and I'll do a
performance evaluation then, how userfaultf vs. !userfaultfd compares
(boot time, run time, THP consumption).

I'll adjust the cover letter for the next version to make this clearer.

-- 
Thanks,

David / dhildenb

