Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F8A443459
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 18:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhKBRMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 13:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhKBRMx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 13:12:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635873017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqB2+vWDu8kUZTT+JPMQEQDA5wOgN4OdhbbH+AKsKFU=;
        b=iC6525jZuP81ZPbFifVeXD5gnlF+MhDeDTTUl4J/3hOlOsWeTtXIxw6TGxJFdX/uJkMadh
        wlx3KsfxS37HKWlNpXafJIzDxdJ0Kh31un8eKsmQtsBGSki6fnxlTaC8q5ujv2cMlxuEQI
        2PWhtrO7ka2WkzX0oQMCgLml97rfUj0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-O47oNnc_NTiDZcOBL0U6ig-1; Tue, 02 Nov 2021 13:10:16 -0400
X-MC-Unique: O47oNnc_NTiDZcOBL0U6ig-1
Received: by mail-wr1-f71.google.com with SMTP id y10-20020adffa4a000000b0017eea6cb05dso3780159wrr.6
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 10:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=AqB2+vWDu8kUZTT+JPMQEQDA5wOgN4OdhbbH+AKsKFU=;
        b=YzHPr2tVp+JJvufwGgZmTU5E57yC3e8Bds6h0aOmAPrq89eflKgJSKIQCpa/TiyllB
         BBmfP7Mqx/Uavgb/QdjF1sa56GE0RAUsZST1iE7fOWkoVy4IkP+/MRuA/J6txStpm0PA
         JKBjjrW1Qa3jkvLweqESoli6KIQ8ge9jTmC0S8pEo09wRN97WdFTYNcJb9iCP8C/JNw4
         tyEDjNj/cBzn48SjUXyEgnpvsAJ1YBdxXfD/XG4H9W82J2SuBcCPpJFAHvKBFcnGXJWv
         /gQMjNaOzQ0m+pZzCdwBAJbD/322VbzN2gdXFaESg9iqD1kfFvUOzjj958BygW/3HzQn
         ZWPQ==
X-Gm-Message-State: AOAM531V8fLMX/z5RPDC5UxPuoxTF6bO8U7xLK8EKfiuk0acbHb9xgop
        bzVzXGQvlmCEjE/6T1v8ZmBS4mASjlylbUyaLBGisv2vkJ1fRinYj6XtEmhCBSshCxC1G2xGlfu
        Ja510JljQD42E
X-Received: by 2002:a5d:5984:: with SMTP id n4mr27750289wri.23.1635873015297;
        Tue, 02 Nov 2021 10:10:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2W66tFfyiDF+65PYWfaVjjbQg42cKoiuKxiz9n2v7pdkOFWhAZRfESPhnoXBuqcFdQeT6xA==
X-Received: by 2002:a5d:5984:: with SMTP id n4mr27750240wri.23.1635873015040;
        Tue, 02 Nov 2021 10:10:15 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id w15sm8634967wrk.77.2021.11.02.10.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 10:10:14 -0700 (PDT)
Message-ID: <e4b63a74-57ad-551c-0046-97a02eb798e5@redhat.com>
Date:   Tue, 2 Nov 2021 18:10:13 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211102111228-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.11.21 18:06, Michael S. Tsirkin wrote:
> On Tue, Nov 02, 2021 at 12:55:17PM +0100, David Hildenbrand wrote:
>> On 02.11.21 12:35, Michael S. Tsirkin wrote:
>>> On Tue, Nov 02, 2021 at 09:33:55AM +0100, David Hildenbrand wrote:
>>>> On 01.11.21 23:15, Michael S. Tsirkin wrote:
>>>>> On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
>>>>>> This is the follow-up of [1], dropping auto-detection and vhost-user
>>>>>> changes from the initial RFC.
>>>>>>
>>>>>> Based-on: 20211011175346.15499-1-david@redhat.com
>>>>>>
>>>>>> A virtio-mem device is represented by a single large RAM memory region
>>>>>> backed by a single large mmap.
>>>>>>
>>>>>> Right now, we map that complete memory region into guest physical addres
>>>>>> space, resulting in a very large memory mapping, KVM memory slot, ...
>>>>>> although only a small amount of memory might actually be exposed to the VM.
>>>>>>
>>>>>> For example, when starting a VM with a 1 TiB virtio-mem device that only
>>>>>> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
>>>>>> in order to hotplug more memory later, we waste a lot of memory on metadata
>>>>>> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
>>>>>> optimizations in KVM are being worked on to reduce this metadata overhead
>>>>>> on x86-64 in some cases, it remains a problem with nested VMs and there are
>>>>>> other reasons why we would want to reduce the total memory slot to a
>>>>>> reasonable minimum.
>>>>>>
>>>>>> We want to:
>>>>>> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
>>>>>>    inside QEMU KVM code where possible.
>>>>>> b) Not always expose all device-memory to the VM, to reduce the attack
>>>>>>    surface of malicious VMs without using userfaultfd.
>>>>>
>>>>> I'm confused by the mention of these security considerations,
>>>>> and I expect users will be just as confused.
>>>>
>>>> Malicious VMs wanting to consume more memory than desired is only
>>>> relevant when running untrusted VMs in some environments, and it can be
>>>> caught differently, for example, by carefully monitoring and limiting
>>>> the maximum memory consumption of a VM. We have the same issue already
>>>> when using virtio-balloon to logically unplug memory. For me, it's a
>>>> secondary concern ( optimizing a is much more important ).
>>>>
>>>> Some users showed interest in having QEMU disallow access to unplugged
>>>> memory, because coming up with a maximum memory consumption for a VM is
>>>> hard. This is one step into that direction without having to run with
>>>> uffd enabled all of the time.
>>>
>>> Sorry about missing the memo - is there a lot of overhead associated
>>> with uffd then?
>>
>> When used with huge/gigantic pages, we don't particularly care.
>>
>> For other memory backends, we'll have to route any population via the
>> uffd handler: guest accesses a 4k page -> place a 4k page from user
>> space. Instead of the kernel automatically placing a THP, we'd be
>> placing single 4k pages and have to hope the kernel will collapse them
>> into a THP later.
> 
> How much value there is in a THP given it's not present?

If you don't place a THP right during the first page fault inside the
THP region, you'll have to rely on khugepagd to eventually place a huge
page later -- and manually fault in each and every 4k page. I haven't
done any performance measurements so far. Going via userspace on every
4k fault will most certainly hurt performance when first touching memory.

-- 
Thanks,

David / dhildenb

