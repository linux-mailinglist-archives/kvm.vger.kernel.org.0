Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597371EF59C
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgFEKqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 06:46:35 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:38402 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726465AbgFEKqe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 06:46:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0U-e32eJ_1591353986;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0U-e32eJ_1591353986)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Jun 2020 18:46:27 +0800
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
 <1cfa9edb-47ea-1495-4e28-4cf391eab44c@linux.alibaba.com>
 <d6cd1870-1012-cb3d-7d29-8e5ad2703717@redhat.com>
 <6b4724bf-84b5-9880-5464-1908425d106d@redhat.com>
 <e1643897-ebd7-75f8-d271-44f62318aa66@redhat.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <95c6ef21-23e0-c768-999d-3af7f69d02d3@linux.alibaba.com>
Date:   Fri, 5 Jun 2020 18:46:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e1643897-ebd7-75f8-d271-44f62318aa66@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/6/5 下午6:05, David Hildenbrand 写道:
>> I guess I know what's happening here. In case we only have DMA memory
>> when booting, we don't reserve swiotlb buffers. Once we hotplug memory
>> and online ZONE_NORMAL, we don't have any swiotlb DMA bounce buffers to
>> map such PFNs (total 0 (slots), used 0 (slots)).
>>
>> Can you try with "swiotlb=force" on the kernel cmdline?
> Alternative, looks like you can specify "-m 2G,maxmem=16G,slots=1", to
> create proper ACPI tables that indicate hotpluggable memory. (I'll have
> to look into QEMU to figure out to always indicate hotpluggable memory
> that way).
> 


That works too. Yes, better resolved in qemu, maybe. :)

Thanks!
