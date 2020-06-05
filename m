Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A712B1EF37E
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 10:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgFEIz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 04:55:26 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:40365 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbgFEIz0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 04:55:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0U-diTxY_1591347318;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0U-diTxY_1591347318)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Jun 2020 16:55:19 +0800
Subject: Re: [PATCH RFC v4 00/13] virtio-mem: paravirtualized memory
To:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
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
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <1cfa9edb-47ea-1495-4e28-4cf391eab44c@linux.alibaba.com>
Date:   Fri, 5 Jun 2020 16:55:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9acc5d04-c8e9-ef53-85e4-709030997ca6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/1/9 下午9:48, David Hildenbrand 写道:
> Ping,
> 
> I'd love to get some feedback on
> 
> a) The remaining MM bits from MM folks (especially, patch #6 and #8).
> b) The general virtio infrastructure (esp. uapi in patch #2) from virtio
> folks.
> 
> I'm planning to send a proper v1 (!RFC) once I have all necessary MM
> acks. In the meanwhile, I will do more testing and minor reworks (e.g.,
> fix !CONFIG_NUMA compilation).


Hi David,

Thanks for your work!

I am trying your https://github.com/davidhildenbrand/linux.git virtio-mem-v5
which works fine for me, but just a 'DMA error' happens when a vm start with
less than 2GB memory, Do I missed sth?

Thanks
Alex


(qemu) qom-set vm0 requested-size 1g
(qemu) [   26.560026] virtio_mem virtio0: plugged size: 0x0
[   26.560648] virtio_mem virtio0: requested size: 0x40000000
[   26.561730] systemd-journald[167]: no db file to read /run/udev/data/+virtio:virtio0: No such file or directory
[   26.563138] systemd-journald[167]: no db file to read /run/udev/data/+virtio:virtio0: No such file or directory
[   26.569122] Built 1 zonelists, mobility grouping on.  Total pages: 513141
[   26.570039] Policy zone: Normal

(qemu) [   32.175838] e1000 0000:00:03.0: swiotlb buffer is full (sz: 81 bytes), total 0 (slots), used 0 (slots)
[   32.176922] e1000 0000:00:03.0: TX DMA map failed
[   32.177488] e1000 0000:00:03.0: swiotlb buffer is full (sz: 81 bytes), total 0 (slots), used 0 (slots)
[   32.178535] e1000 0000:00:03.0: TX DMA map failed

my qemu command is like this:
qemu-system-x86_64  --enable-kvm \
	-m 2G,maxmem=16G -kernel /root/linux-next/$1/arch/x86/boot/bzImage \
	-smp 4 \
	-append "earlyprintk=ttyS0 root=/dev/sda1 console=ttyS0 debug psi=1 nokaslr ignore_loglevel" \
	-hda /root/CentOS-7-x86_64-Azure-1703.qcow2 \
	-net user,hostfwd=tcp::2222-:22 -net nic -s \
  -object memory-backend-ram,id=mem0,size=3G \
  -device virtio-mem-pci,id=vm0,memdev=mem0,node=0,requested-size=0M \
	--nographic

