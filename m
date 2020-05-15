Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733DE1D43CE
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 04:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgEOC6X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 May 2020 22:58:23 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:43156 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727029AbgEOC6X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 22:58:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=teawaterz@linux.alibaba.com;NM=1;PH=DS;RN=41;SR=0;TI=SMTPD_---0TyZxr82_1589511481;
Received: from 127.0.0.1(mailfrom:teawaterz@linux.alibaba.com fp:SMTPD_---0TyZxr82_1589511481)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 May 2020 10:58:15 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [virtio-dev] [PATCH v3 00/15] virtio-mem: paravirtualized memory
From:   teawater <teawaterz@linux.alibaba.com>
In-Reply-To: <cda84c4d-0f4c-1dd8-44f6-68f211e5de6d@redhat.com>
Date:   Fri, 15 May 2020 10:58:00 +0800
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
Content-Transfer-Encoding: 8BIT
Message-Id: <9708F43A-9BD2-4377-8EE8-7FB1D95C6F69@linux.alibaba.com>
References: <20200507103119.11219-1-david@redhat.com>
 <7848642F-6AA7-4B5E-AE0E-DB0857C94A93@linux.alibaba.com>
 <31c5d2f9-c104-53e8-d9c8-cb45f7507c85@redhat.com>
 <A3BBAEEE-FBB9-4259-8BED-023CCD530021@linux.alibaba.com>
 <389b6bdc-b196-e4b9-b6be-dcac57524fdf@redhat.com>
 <3c82e149-6c42-690e-9d58-bb8e69870fe0@redhat.com>
 <e48ded49-9b92-7025-a06f-49b24f1c53a6@redhat.com>
 <cda84c4d-0f4c-1dd8-44f6-68f211e5de6d@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> 2020年5月14日 20:19，David Hildenbrand <david@redhat.com> 写道：
> 
> On 14.05.20 13:47, David Hildenbrand wrote:
>> On 14.05.20 13:10, David Hildenbrand wrote:
>>> On 14.05.20 12:12, David Hildenbrand wrote:
>>>> On 14.05.20 12:02, teawater wrote:
>>>>> 
>>>>> 
>>>>>> 2020年5月14日 16:48，David Hildenbrand <david@redhat.com> 写道：
>>>>>> 
>>>>>> On 14.05.20 08:44, teawater wrote:
>>>>>>> Hi David,
>>>>>>> 
>>>>>>> I got a kernel warning with v2 and v3.
>>>>>> 
>>>>>> Hi Hui,
>>>>>> 
>>>>>> thanks for playing with the latest versions. Surprisingly, I can
>>>>>> reproduce even by hotplugging a DIMM instead as well - that's good, so
>>>>>> it's not related to virtio-mem, lol. Seems to be some QEMU setup issue
>>>>>> with older machine types.
>>>>>> 
>>>>>> Can you switch to a newer qemu machine version, especially
>>>>>> pc-i440fx-5.0? Both, hotplugging DIMMs and virtio-mem works for me with
>>>>>> that QEMU machine just fine.
>>>>> 
>>>>> I still could reproduce this issue with pc-i440fx-5.0 or pc.  Did I miss anything?
>>>>> 
>>>> 
>>>> Below I don't even see virtio_mem. I had to repair the image (filesystem
>>>> fsck) because it was broken, can you try that as well?
>>>> 
>>>> Also, it would be great if you could test with v4.
>>>> 
>>> 
>>> Correction, something seems to be broken either in QEMU or the kernel. Once I
>>> define a DIMM so it's added and online during boot, I get these issues:
>>> 
>>> (I have virtio-mem v4 installed in the guest)
>>> 
>>> #! /bin/bash
>>> sudo x86_64-softmmu/qemu-system-x86_64 \
>>>    -machine pc-i440fx-5.0,accel=kvm,usb=off \
>>>    -cpu host \
>>>    -no-reboot \
>>>    -nographic \
>>>    -device ide-hd,drive=hd \
>>>    -drive if=none,id=hd,file=/home/dhildenb/git/Fedora-Cloud-Base-31-1.9.x86_64.qcow2,format=qcow2 \
>>>    -m 1g,slots=10,maxmem=2G \
>>>    -smp 1 \
>>>    -object memory-backend-ram,id=mem0,size=256m \
>>>    -device pc-dimm,id=dimm0,memdev=mem0 \
>>>    -s \
>>>    -monitor unix:/var/tmp/monitor,server,nowait
>>> 
>>> 
>>> Without the DIMM it seems to work just fine.
>>> 
>> 
>> And another correction. 
>> 
>> Using QEMU v5.0.0, Linux 5.7-rc5, untouched
>> Fedora-Cloud-Base-32-1.6.x86_64.qcow2, I get even without any memory hotplug:
>> 
>> #! /bin/bash
>> sudo x86_64-softmmu/qemu-system-x86_64 \
>>    -machine pc-i440fx-5.0,accel=kvm,usb=off \
>>    -cpu host \
>>    -no-reboot \
>>    -nographic \
>>    -device ide-hd,drive=hd \
>>    -drive if=none,id=hd,file=/home/dhildenb/git/Fedora-Cloud-Base-32-1.6.x86_64.qcow2,format=qcow2 \
>>    -m 5g,slots=10,maxmem=6G \
>>    -smp 1 \
>>    -s \
>>    -kernel /home/dhildenb/git/linux/arch/x86/boot/bzImage \
>>    -append "console=ttyS0 rd.shell nokaslr swiotlb=noforce" \
>>    -monitor unix:/var/tmp/monitor,server,nowait
>> 
>> 
>> Observe how big the initial RAM even is!
>> 
>> 
>> So this is no DIMM/hotplug/virtio_mem issue. With memory hotplug, it seems to get
>> more likely to trigger if "swiotlb=noforce" is not specified.
>> 
>> "swiotlb=noforce" seems to trigger some pre-existing issue here. Without
>> "swiotlb=noforce", I was only able to observe this via pc-i440fx-2.1,
>> 
> 
> (talking to myself :) )
> 
> I think I finally understood why using "swiotlb=noforce" with hotplugged
> memory is wrong - or with memory > 3GB. Via "swiotlb=noforce" you tell
> the system to "Never use bounce buffers (for debugging)". This works as
> long as all memory is DMA memory (e.g., < 3GB) AFAIK.
> 
> "If specified, trying to map memory that cannot be used with DMA will
> fail, and a rate-limited warning will be printed."
> 
> Hotplugged memory (under QEMU) is never added below 4GB, because of the
> PCI hole. So both, memory from DIMMs and from virtio-mem will end up at
> or above 4GB. To make a device use that memory, you need bounce buffers.
> 
> Hotplugged memory is never DMA memory.
> 


Hi David,

It is fixed when I remove "swiotlb=noforce”.

Thanks for your help.

Best,
Hui

> -- 
> Thanks,
> 
> David / dhildenb

