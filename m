Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1243B442D47
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 12:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhKBL55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 07:57:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhKBL54 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 07:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635854121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fFshW3JLim2zFO9+vUC4D0dfCH/FT0qqDtGdoGlRVNk=;
        b=LZC5mdTZ1s5hBaM9L1Ffsju82iev/pYV6Drp60gKicKOBaFB72qxJ9nCIKUui37fWuVkUQ
        12dhe5bkn7q0zi78oEX6XlMeLxbR9GWcqDc3kJA0dU9eIy0fRmJNArSdBdJu00Dpczs2yV
        7J3eanAmswI4hVsqOS+3PaUBtxd4G9k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-h7TuBfjlP2yXU0gKZx9v2g-1; Tue, 02 Nov 2021 07:55:20 -0400
X-MC-Unique: h7TuBfjlP2yXU0gKZx9v2g-1
Received: by mail-wm1-f70.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so430002wmb.3
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 04:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=fFshW3JLim2zFO9+vUC4D0dfCH/FT0qqDtGdoGlRVNk=;
        b=A5w/UMmkrLrc+fsAtAbnM1wQDvU3d4aKLQVaYGuG5lLBfjtTkCPf45Wxoa1DE63/Gz
         MM+km+yaOCZxvvcm5Kwvlu+efhB9Cmib3654vhuJqViqdoAol2Q+JWEAE1EPybzAQA/0
         idgg2GCSpBlP/YjkdC1VVVTRkoFIslCyaQJhM+2qEEQgxCmi5vE5kh9JSRVjChjI2PlX
         g5V3pwHuJA6nkTZq1xNL6r+dvb7TOB1orRtflxKP5BLM2MWXBddlnA5nKYI9bdNmUvA6
         dBD42ZPEWb4M2wJeC74oNxh5S9/HiZshwIAQ3u4EaPdS1IeZnE+9E5f0v4FxxD/S0kyB
         4n9Q==
X-Gm-Message-State: AOAM532x9DQz6sS9h+3VJXp0KjlndcfWQMBJ1RZKyRJXrO93gV/EzVyc
        6c1e+6tO3tC7R2aK3Nzy11oBq9xtm9qP5WgsZmBr4s6R+iW1sQ6QcZzZBlUn4rLTLd3QEFVhM9T
        VwJnlsdQU2LNG
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr43852282wrn.82.1635854119067;
        Tue, 02 Nov 2021 04:55:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxe7p+c9E/Dn4jS7oHad/sj2/GKi44Lr+SGhdT5gVBsStvYSoAer9B4vFXlfhkBnQwIjOvoKA==
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr43852238wrn.82.1635854118870;
        Tue, 02 Nov 2021 04:55:18 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6810.dip0.t-ipconnect.de. [91.12.104.16])
        by smtp.gmail.com with ESMTPSA id l20sm2517148wmq.42.2021.11.02.04.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 04:55:18 -0700 (PDT)
Message-ID: <171c8ed0-d55e-77ef-963b-6d836729ef4b@redhat.com>
Date:   Tue, 2 Nov 2021 12:55:17 +0100
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
 <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
 <20211102072843-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
In-Reply-To: <20211102072843-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.11.21 12:35, Michael S. Tsirkin wrote:
> On Tue, Nov 02, 2021 at 09:33:55AM +0100, David Hildenbrand wrote:
>> On 01.11.21 23:15, Michael S. Tsirkin wrote:
>>> On Wed, Oct 27, 2021 at 02:45:19PM +0200, David Hildenbrand wrote:
>>>> This is the follow-up of [1], dropping auto-detection and vhost-user
>>>> changes from the initial RFC.
>>>>
>>>> Based-on: 20211011175346.15499-1-david@redhat.com
>>>>
>>>> A virtio-mem device is represented by a single large RAM memory region
>>>> backed by a single large mmap.
>>>>
>>>> Right now, we map that complete memory region into guest physical addres
>>>> space, resulting in a very large memory mapping, KVM memory slot, ...
>>>> although only a small amount of memory might actually be exposed to the VM.
>>>>
>>>> For example, when starting a VM with a 1 TiB virtio-mem device that only
>>>> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
>>>> in order to hotplug more memory later, we waste a lot of memory on metadata
>>>> for KVM memory slots (> 2 GiB!) and accompanied bitmaps. Although some
>>>> optimizations in KVM are being worked on to reduce this metadata overhead
>>>> on x86-64 in some cases, it remains a problem with nested VMs and there are
>>>> other reasons why we would want to reduce the total memory slot to a
>>>> reasonable minimum.
>>>>
>>>> We want to:
>>>> a) Reduce the metadata overhead, including bitmap sizes inside KVM but also
>>>>    inside QEMU KVM code where possible.
>>>> b) Not always expose all device-memory to the VM, to reduce the attack
>>>>    surface of malicious VMs without using userfaultfd.
>>>
>>> I'm confused by the mention of these security considerations,
>>> and I expect users will be just as confused.
>>
>> Malicious VMs wanting to consume more memory than desired is only
>> relevant when running untrusted VMs in some environments, and it can be
>> caught differently, for example, by carefully monitoring and limiting
>> the maximum memory consumption of a VM. We have the same issue already
>> when using virtio-balloon to logically unplug memory. For me, it's a
>> secondary concern ( optimizing a is much more important ).
>>
>> Some users showed interest in having QEMU disallow access to unplugged
>> memory, because coming up with a maximum memory consumption for a VM is
>> hard. This is one step into that direction without having to run with
>> uffd enabled all of the time.
> 
> Sorry about missing the memo - is there a lot of overhead associated
> with uffd then?

When used with huge/gigantic pages, we don't particularly care.

For other memory backends, we'll have to route any population via the
uffd handler: guest accesses a 4k page -> place a 4k page from user
space. Instead of the kernel automatically placing a THP, we'd be
placing single 4k pages and have to hope the kernel will collapse them
into a THP later.

khugepagd will only collapse into a THP if all affected page table
entries are present and don't map the zero page, though.

So we'll most certainly use less THP for our VM and VM startup time
("first memory access after plugging memory") can be slower.

I have prototypes for it, with some optimizations (e.g., on 4k guest
access, populate the whole THP area), but we might not want to enable it
all of the time. (interaction with postcopy has to be fixed, but it's
not a fundamental issue)


Extending uffd-based protection for virtio-mem to other processes
(vhost-user), is a bit more complicated, and I am not 100% sure if it's
worth the trouble for now. memslots provide at least some high-level
protection for the important case of having a virtio-mem device to
eventually hotplug a lot of memory later.

> 
>> ("security is somewhat the wrong word. we won't be able to steal any
>> information from the hypervisor.)
> 
> Right. Let's just spell it out.
> Further, removing memory still requires guest cooperation.

Right.


-- 
Thanks,

David / dhildenb

