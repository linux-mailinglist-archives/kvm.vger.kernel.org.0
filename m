Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E41D2F79
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgENMUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:20:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45231 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgENMUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 08:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589458821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=9aCz4qvsPpwDokPvw5swdrzksgBU0j0lrQXHgXqHs5M=;
        b=dYXpXTtC1SSAWOKYAyYi+u8VRvcGv3Yi2JDsvOP09s+oeA0QVKudzDoC+ngWXZiYOyFA/0
        h49bz7Ur6BdbBKlap+wtth9NgwErNi+T1SYL5IUPm5Su81KoC/zILTNqfqO+HTxeftJQDC
        x7sD3VzYcFY6qOLTEkgPms5wKNxQ7JY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-gw2F4bHnNB6zA23Q_4lAsg-1; Thu, 14 May 2020 08:20:17 -0400
X-MC-Unique: gw2F4bHnNB6zA23Q_4lAsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5E121902EA7;
        Thu, 14 May 2020 12:20:12 +0000 (UTC)
Received: from [10.36.114.168] (ovpn-114-168.ams2.redhat.com [10.36.114.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45F1A1001920;
        Thu, 14 May 2020 12:19:52 +0000 (UTC)
Subject: Re: [virtio-dev] [PATCH v3 00/15] virtio-mem: paravirtualized memory
From:   David Hildenbrand <david@redhat.com>
To:     teawater <teawaterz@linux.alibaba.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
References: <20200507103119.11219-1-david@redhat.com>
 <7848642F-6AA7-4B5E-AE0E-DB0857C94A93@linux.alibaba.com>
 <31c5d2f9-c104-53e8-d9c8-cb45f7507c85@redhat.com>
 <A3BBAEEE-FBB9-4259-8BED-023CCD530021@linux.alibaba.com>
 <389b6bdc-b196-e4b9-b6be-dcac57524fdf@redhat.com>
 <3c82e149-6c42-690e-9d58-bb8e69870fe0@redhat.com>
 <e48ded49-9b92-7025-a06f-49b24f1c53a6@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <cda84c4d-0f4c-1dd8-44f6-68f211e5de6d@redhat.com>
Date:   Thu, 14 May 2020 14:19:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e48ded49-9b92-7025-a06f-49b24f1c53a6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.05.20 13:47, David Hildenbrand wrote:
> On 14.05.20 13:10, David Hildenbrand wrote:
>> On 14.05.20 12:12, David Hildenbrand wrote:
>>> On 14.05.20 12:02, teawater wrote:
>>>>
>>>>
>>>>> 2020年5月14日 16:48，David Hildenbrand <david@redhat.com> 写道：
>>>>>
>>>>> On 14.05.20 08:44, teawater wrote:
>>>>>> Hi David,
>>>>>>
>>>>>> I got a kernel warning with v2 and v3.
>>>>>
>>>>> Hi Hui,
>>>>>
>>>>> thanks for playing with the latest versions. Surprisingly, I can
>>>>> reproduce even by hotplugging a DIMM instead as well - that's good, so
>>>>> it's not related to virtio-mem, lol. Seems to be some QEMU setup issue
>>>>> with older machine types.
>>>>>
>>>>> Can you switch to a newer qemu machine version, especially
>>>>> pc-i440fx-5.0? Both, hotplugging DIMMs and virtio-mem works for me with
>>>>> that QEMU machine just fine.
>>>>
>>>> I still could reproduce this issue with pc-i440fx-5.0 or pc.  Did I miss anything?
>>>>
>>>
>>> Below I don't even see virtio_mem. I had to repair the image (filesystem
>>> fsck) because it was broken, can you try that as well?
>>>
>>> Also, it would be great if you could test with v4.
>>>
>>
>> Correction, something seems to be broken either in QEMU or the kernel. Once I
>> define a DIMM so it's added and online during boot, I get these issues:
>>
>> (I have virtio-mem v4 installed in the guest)
>>
>> #! /bin/bash
>> sudo x86_64-softmmu/qemu-system-x86_64 \
>>     -machine pc-i440fx-5.0,accel=kvm,usb=off \
>>     -cpu host \
>>     -no-reboot \
>>     -nographic \
>>     -device ide-hd,drive=hd \
>>     -drive if=none,id=hd,file=/home/dhildenb/git/Fedora-Cloud-Base-31-1.9.x86_64.qcow2,format=qcow2 \
>>     -m 1g,slots=10,maxmem=2G \
>>     -smp 1 \
>>     -object memory-backend-ram,id=mem0,size=256m \
>>     -device pc-dimm,id=dimm0,memdev=mem0 \
>>     -s \
>>     -monitor unix:/var/tmp/monitor,server,nowait
>>
>>
>> Without the DIMM it seems to work just fine.
>>
> 
> And another correction. 
> 
> Using QEMU v5.0.0, Linux 5.7-rc5, untouched
> Fedora-Cloud-Base-32-1.6.x86_64.qcow2, I get even without any memory hotplug:
> 
> #! /bin/bash
> sudo x86_64-softmmu/qemu-system-x86_64 \
>     -machine pc-i440fx-5.0,accel=kvm,usb=off \
>     -cpu host \
>     -no-reboot \
>     -nographic \
>     -device ide-hd,drive=hd \
>     -drive if=none,id=hd,file=/home/dhildenb/git/Fedora-Cloud-Base-32-1.6.x86_64.qcow2,format=qcow2 \
>     -m 5g,slots=10,maxmem=6G \
>     -smp 1 \
>     -s \
>     -kernel /home/dhildenb/git/linux/arch/x86/boot/bzImage \
>     -append "console=ttyS0 rd.shell nokaslr swiotlb=noforce" \
>     -monitor unix:/var/tmp/monitor,server,nowait
> 
> 
> Observe how big the initial RAM even is!
> 
> 
> So this is no DIMM/hotplug/virtio_mem issue. With memory hotplug, it seems to get
> more likely to trigger if "swiotlb=noforce" is not specified.
> 
> "swiotlb=noforce" seems to trigger some pre-existing issue here. Without
> "swiotlb=noforce", I was only able to observe this via pc-i440fx-2.1,
> 

(talking to myself :) )

I think I finally understood why using "swiotlb=noforce" with hotplugged
memory is wrong - or with memory > 3GB. Via "swiotlb=noforce" you tell
the system to "Never use bounce buffers (for debugging)". This works as
long as all memory is DMA memory (e.g., < 3GB) AFAIK.

"If specified, trying to map memory that cannot be used with DMA will
fail, and a rate-limited warning will be printed."

Hotplugged memory (under QEMU) is never added below 4GB, because of the
PCI hole. So both, memory from DIMMs and from virtio-mem will end up at
or above 4GB. To make a device use that memory, you need bounce buffers.

Hotplugged memory is never DMA memory.

-- 
Thanks,

David / dhildenb

