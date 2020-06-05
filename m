Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B4F1EF3B7
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgFEJJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 05:09:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25068 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbgFEJJR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 05:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591348155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=F4NHHC79n17giKLMo5VoyVCEUYO/fk1+yWE2JKf8Ozw=;
        b=PKxWlIryi+vepSwFTS/x5JLgl1oDfVW3Sx0kaEL7R5MZfz/n1x2qHNsTIQAlrK+b/GsVol
        zglpwKT30Tu8zsLfWtvIXGjbsKqYTrXBpj3BD0q2UyrDuGZ9vScD4qZ4ITEq1043jNlBD5
        3N0vFAcjVNo4YQIIBW/8+7AvUFl7L+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-PnttmtdNOZ2PagLhqTwNJA-1; Fri, 05 Jun 2020 05:09:11 -0400
X-MC-Unique: PnttmtdNOZ2PagLhqTwNJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28118BFC1;
        Fri,  5 Jun 2020 09:09:03 +0000 (UTC)
Received: from [10.36.114.72] (ovpn-114-72.ams2.redhat.com [10.36.114.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F3F45C1B0;
        Fri,  5 Jun 2020 09:08:44 +0000 (UTC)
Subject: Re: [PATCH RFC v4 00/13] virtio-mem: paravirtualized memory
To:     Alex Shi <alex.shi@linux.alibaba.com>, linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
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
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
References: <20191212171137.13872-1-david@redhat.com>
 <9acc5d04-c8e9-ef53-85e4-709030997ca6@redhat.com>
 <1cfa9edb-47ea-1495-4e28-4cf391eab44c@linux.alibaba.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <d6cd1870-1012-cb3d-7d29-8e5ad2703717@redhat.com>
Date:   Fri, 5 Jun 2020 11:08:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1cfa9edb-47ea-1495-4e28-4cf391eab44c@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.06.20 10:55, Alex Shi wrote:
> 
> 
> 在 2020/1/9 下午9:48, David Hildenbrand 写道:
>> Ping,
>>
>> I'd love to get some feedback on
>>
>> a) The remaining MM bits from MM folks (especially, patch #6 and #8).
>> b) The general virtio infrastructure (esp. uapi in patch #2) from virtio
>> folks.
>>
>> I'm planning to send a proper v1 (!RFC) once I have all necessary MM
>> acks. In the meanwhile, I will do more testing and minor reworks (e.g.,
>> fix !CONFIG_NUMA compilation).
> 
> 
> Hi David,
> 
> Thanks for your work!
> 
> I am trying your https://github.com/davidhildenbrand/linux.git virtio-mem-v5
> which works fine for me, but just a 'DMA error' happens when a vm start with
> less than 2GB memory, Do I missed sth?

Please use the virtio-mem-v4 branch for now, v5 is still under
construction (and might be scrapped completely if v4 goes upstream as is).

Looks like a DMA issue. Your're hotplugging 1GB, which should not really
eat too much memory. There was a similar issue reported by Hui in [1],
which boiled down to wrong usage of the swiotlb parameter.

In such cases you should always try to reproduce with hotplug of a
sam-sized DIMM. E.g., hotplugging a 1GB DIMM should result in the same
issue.

What does your .config specify for CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE?

I'll try to reproduce with v4 briefly.

[1]
https://lkml.kernel.org/r/9708F43A-9BD2-4377-8EE8-7FB1D95C6F69@linux.alibaba.com

> 
> Thanks
> Alex
> 
> 
> (qemu) qom-set vm0 requested-size 1g
> (qemu) [   26.560026] virtio_mem virtio0: plugged size: 0x0
> [   26.560648] virtio_mem virtio0: requested size: 0x40000000
> [   26.561730] systemd-journald[167]: no db file to read /run/udev/data/+virtio:virtio0: No such file or directory
> [   26.563138] systemd-journald[167]: no db file to read /run/udev/data/+virtio:virtio0: No such file or directory
> [   26.569122] Built 1 zonelists, mobility grouping on.  Total pages: 513141
> [   26.570039] Policy zone: Normal
> 
> (qemu) [   32.175838] e1000 0000:00:03.0: swiotlb buffer is full (sz: 81 bytes), total 0 (slots), used 0 (slots)
> [   32.176922] e1000 0000:00:03.0: TX DMA map failed
> [   32.177488] e1000 0000:00:03.0: swiotlb buffer is full (sz: 81 bytes), total 0 (slots), used 0 (slots)
> [   32.178535] e1000 0000:00:03.0: TX DMA map failed
> 
> my qemu command is like this:
> qemu-system-x86_64  --enable-kvm \
> 	-m 2G,maxmem=16G -kernel /root/linux-next/$1/arch/x86/boot/bzImage \
> 	-smp 4 \
> 	-append "earlyprintk=ttyS0 root=/dev/sda1 console=ttyS0 debug psi=1 nokaslr ignore_loglevel" \
> 	-hda /root/CentOS-7-x86_64-Azure-1703.qcow2 \
> 	-net user,hostfwd=tcp::2222-:22 -net nic -s \
>   -object memory-backend-ram,id=mem0,size=3G \
>   -device virtio-mem-pci,id=vm0,memdev=mem0,node=0,requested-size=0M \
> 	--nographic
> 
> 


-- 
Thanks,

David / dhildenb

