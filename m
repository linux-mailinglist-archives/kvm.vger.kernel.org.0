Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB46EBED6
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 09:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfKAIEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 04:04:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33841 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729881AbfKAIEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 04:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572595477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6rZmQBegxHUQyLKKdi/tNOtCE2aLFrWdL4xE9f27taI=;
        b=GNmxIBQykmzh9Rq3y4YN7vuP7L7uDt4kS0xz7jYJe4eA180c6ZrK5Ry0YmH7DTdMHOdN/a
        oBhGVnqVktCB2OEnFl/svh98VQgWB5XeBPu1H6Vfhota2OeVtdKy8fo70TVddpPfQgsaqX
        o4lMXnjAI7vxc3PAI1fmBhPcXqTOt9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-gcnoxJCMOs-SFE5cJEMmFA-1; Fri, 01 Nov 2019 04:04:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6EC71005500;
        Fri,  1 Nov 2019 08:04:32 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19E455D6A7;
        Fri,  1 Nov 2019 08:04:17 +0000 (UTC)
Subject: Re: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Cc:     "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <367adad0-eb05-c950-21d7-755fffacbed6@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0619@SHSMSX104.ccr.corp.intel.com>
 <fa994379-a847-0ffe-5043-40a2aefecf43@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A0EACA6@SHSMSX104.ccr.corp.intel.com>
 <960389b5-2ef4-8921-fc28-67c9a6398c43@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5E17C7@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <18534f1b-3488-994b-73e2-17e7d8ccb4c2@redhat.com>
Date:   Fri, 1 Nov 2019 16:04:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5E17C7@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: gcnoxJCMOs-SFE5cJEMmFA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/1 =E4=B8=8B=E5=8D=883:46, Tian, Kevin wrote:
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Friday, November 1, 2019 3:30 PM
>>
>>
>> On 2019/10/31 =E4=B8=8B=E5=8D=8810:07, Liu, Yi L wrote:
>>>> From: Jason Wang [mailto:jasowang@redhat.com]
>>>> Sent: Thursday, October 31, 2019 5:33 AM
>>>> Subject: Re: [RFC v2 00/22] intel_iommu: expose Shared Virtual
>> Addressing to VM
>>>>
>>>> On 2019/10/25 =E4=B8=8B=E5=8D=886:12, Tian, Kevin wrote:
>>>>>> From: Jason Wang [mailto:jasowang@redhat.com]
>>>>>> Sent: Friday, October 25, 2019 5:49 PM
>>>>>>
>>>>>>
>>>>>> On 2019/10/24 =E4=B8=8B=E5=8D=888:34, Liu Yi L wrote:
>>>>>>> Shared virtual address (SVA), a.k.a, Shared virtual memory (SVM) on
>>>>>>> Intel platforms allow address space sharing between device DMA
>> and
>>>>>> applications.
>>>>>>
>>>>>>
>>>>>> Interesting, so the below figure demonstrates the case of VM. I
>>>>>> wonder how much differences if we compare it with doing SVM
>> between
>>>>>> device and an ordinary process (e.g dpdk)?
>>>>>>
>>>>>> Thanks
>>>>> One difference is that ordinary process requires only stage-1
>>>>> translation, while VM requires nested translation.
>>>> A silly question, then I believe there's no need for VFIO DMA API in t=
his
>> case consider
>>>> the page table is shared between MMU and IOMMU?
>>> Echo Kevin's reply. We use nested translation here. For stage-1, yes, n=
o
>> need to use
>>> VFIO DMA API. For stage-2, we still use VFIO DMA API to program the
>> GPA->HPA
>>> mapping to host. :-)
>>
>> Cool, two more questions:
>>
>> - Can EPT shares its page table with IOMMU L2?
> yes, their formats are compatible.
>
>> - Similar to EPT, when GPA->HPA (actually HVA->HPA) is modified by mm,
>> VFIO need to use MMU notifier do modify L2 accordingly besides DMA API?
>>
> VFIO devices need to pin-down guest memory pages that are mapped
> in IOMMU. So notifier is not required since mm won't change the mapping
> for those pages.


The GUP tends to lead a lot of issues, we may consider to allow=20
userspace to choose to not pin them in the future.

Thanks


>
> Thanks
> Kevin

