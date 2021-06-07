Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4C639D31A
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 04:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhFGCtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 22:49:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGCtC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Jun 2021 22:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623034031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mr3tocRxWL7KHdg8awV/zpzMwDBrih+hXjg05z6CBzk=;
        b=drLTDpCuX5HGGbbaJJem9ZCgnDXVJXNuOmofwoVhczaoeIpXU09WuDGpuEyFPUnId0zNPA
        CLrmiSOaFCdcMk6n/O+MfWQC3rhxdMgNhLp0P6gpSNk1fVLDCybr8fMgpmVnK69N9YqteS
        qwtV5UxlHsDDUqGdq9OUhcsfsa9Fq78=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-u0HpMP14NY2JN35BD1OY2A-1; Sun, 06 Jun 2021 22:47:10 -0400
X-MC-Unique: u0HpMP14NY2JN35BD1OY2A-1
Received: by mail-pl1-f198.google.com with SMTP id z10-20020a170903018ab02901108a797206so2235404plg.16
        for <kvm@vger.kernel.org>; Sun, 06 Jun 2021 19:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Mr3tocRxWL7KHdg8awV/zpzMwDBrih+hXjg05z6CBzk=;
        b=Ugymfyz34itXy7X2kJFXvk6uoB17DoJh/sAO8Hpixf3lmQhDrGyFwNZRbWvZ8SLBVq
         A4IU3BFMHuyV9jPJ31Od7au1/l5L6EU4LiZ9JfzpXVkTqC9a5A/dDX0y51HtA0xZuOaJ
         ayMeUKqSxCTmjEbSWljW5j0J6mArCBkyv4gNvKGy0fhgwtHCLYYO5yb0RLJRtMLxhyXY
         e4fgtP3owwl4YvWfbu9/5jMLhaIIxxgzbDH3EDqw5vE4/Z2rSnVUhWpLZD7y2d/uwgHM
         RnBqhL1c6AjLD6B0vDOUOboLvnbzS64yrfWnw3QjXaJTisb+9uKnkN/FH5taCN0ei0p8
         oygA==
X-Gm-Message-State: AOAM532Ipz8squcdI8aAMGAk6JSQ/jPsIlmlR+e0rRd0FB5ibf5LlDgb
        XbiUF0ugTgjqowpK+ndUTsmOLdghfFLnQEdRheyoVpr1IfnRsNTBvKVwIly7Nz/k4+ygtU3KWQq
        wFJYnyvMHTOB+hBXMwqAu8JxLxgM8YLTliF/HXnZEZPGrNUw16klo66whSJq1AgC2
X-Received: by 2002:a17:90a:a512:: with SMTP id a18mr10789102pjq.215.1623034028520;
        Sun, 06 Jun 2021 19:47:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxp6+IFTDaA+xiekaXr4IMEzKNt6UmxaapTPVHbpvF501mj9bOPvGKBHxi8b6knZswIY52v0A==
X-Received: by 2002:a17:90a:a512:: with SMTP id a18mr10789078pjq.215.1623034028146;
        Sun, 06 Jun 2021 19:47:08 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z134sm6704296pfc.209.2021.06.06.19.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:47:07 -0700 (PDT)
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, kvm@vger.kernel.org
References: <20210421032117.5177-1-jasowang@redhat.com>
 <YInOQt1l/59zzPJK@Konrads-MacBook-Pro.local>
 <9b089e3b-7d7a-b9d6-a4a1-81a6eff2e425@redhat.com>
 <e8a35789-5001-3e17-1546-80fa9daa5ab1@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b4f25e0e-5115-2d58-e433-1839651d747f@redhat.com>
Date:   Mon, 7 Jun 2021 10:46:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e8a35789-5001-3e17-1546-80fa9daa5ab1@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/6/4 下午11:17, Konrad Rzeszutek Wilk 写道:
> On 4/29/21 12:16 AM, Jason Wang wrote:
>>
>> 在 2021/4/29 上午5:06, Konrad Rzeszutek Wilk 写道:
>>> On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
>>>> Hi All:
>>>>
>>>> Sometimes, the driver doesn't trust the device. This is usually
>>>> happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
>>>> like swiotlb is used to prevent the poking/mangling of memory from the
>>>> device. But this is not sufficient since current virtio driver may
>>>> trust what is stored in the descriptor table (coherent mapping) for
>>>> performing the DMA operations like unmap and bounce so the device may
>>>> choose to utilize the behaviour of swiotlb to perform attacks[2].
>>> We fixed it in the SWIOTLB. That is it saves the expected length
>>> of the DMA operation. See
>>>
>>> commit daf9514fd5eb098d7d6f3a1247cb8cc48fc94155
>>> Author: Martin Radev <martin.b.radev@gmail.com>
>>> Date:   Tue Jan 12 16:07:29 2021 +0100
>>>
>>>      swiotlb: Validate bounce size in the sync/unmap path
>>>      The size of the buffer being bounced is not checked if it happens
>>>      to be larger than the size of the mapped buffer. Because the size
>>>      can be controlled by a device, as it's the case with virtio 
>>> devices,
>>>      this can lead to memory corruption.
>>
>>
>> Good to know this, but this series tries to protect at different 
>> level. And I believe such protection needs to be done at both levels.
>>
>
> My apologies for taking so long to respond, somehow this disappeared 
> in one of the folders.


No problem.


>>
>>>> For double insurance, to protect from a malicous device, when DMA API
>>>> is used for the device, this series store and use the descriptor
>>>> metadata in an auxiliay structure which can not be accessed via
>>>> swiotlb instead of the ones in the descriptor table. Actually, we've
>>> Sorry for being dense here, but how wold SWIOTLB be utilized for
>>> this attack?
>>
>>
>> So we still behaviors that is triggered by device that is not 
>> trusted. Such behavior is what the series tries to avoid. We've 
>> learnt a lot of lessons to eliminate the potential attacks via this. 
>> And it would be too late to fix if we found another issue of SWIOTLB.
>>
>> Proving "the unexpected device triggered behavior is safe" is very 
>> hard (or even impossible) than "eliminating the unexpected device 
>> triggered behavior totally".
>>
>> E.g I wonder whether something like this can happen: Consider the DMA 
>> direction of unmap is under the control of device. The device can 
>> cheat the SWIOTLB by changing the flag to modify the device read only 
>> buffer. 
>
> <blinks> Why would you want to expose that to the device? And wouldn't 
> that be specific to Linux devices - because surely Windows DMA APIs 
> are different and this 'flag' seems very Linux-kernel specific?


Just to make sure we are in the same page. The "flag" I actually mean 
the virtio descriptor flag which could be modified by the device. And 
driver deduce the DMA API flag from the descriptor flag.


>
>> If yes, it is really safe?
>
> Well no? But neither is rm -Rf / but we still allow folks to do that.
>>
>> The above patch only log the bounce size but it doesn't log the flag. 
>
> It logs and panics the system.


Good to know that.


>
>> Even if it logs the flag, SWIOTLB still doesn't know how each buffer 
>> is used and when it's the appropriate(safe) time to unmap the buffer, 
>> only the driver that is using the SWIOTLB know them.
>
> Fair enough. Is the intent to do the same thing for all the other 
> drivers that could be running in an encrypted guest and would require 
> SWIOTLB.
>
> Like legacy devices that KVM can expose (floppy driver?, SVGA driver)?


My understanding is that we shouldn't enable the legacy devices at all 
in this case.

Note that virtio has been extended to various types of devices (we can 
boot qemu without PCI and legacy devices (e.g the micro VM))

- virtio input
- virtio gpu
- virtio sound
...

I'm not sure whether we need floppy, but it's not hard to have a 
virtio-floppy if necessary

So it would be sufficient for us to audit/harden the virtio drivers.


>
>>
>> So I think we need to consolidate on both layers instead of solely 
>> depending on the SWIOTLB.
>
> Please make sure that this explanation is in part of the cover letter
> or in the commit/Kconfig.


I will do that if the series needs a respin.


>
> Also, are you aware of the patchset than Andi been working on that 
> tries to make the DMA code to have extra bells and whistles for this 
> purpose?


Yes, but as described above they are not duplicated. Protection at both 
levels would be optimal.

Another note is that this series is not only for DMA/swiotlb stuffs, it 
eliminate all the possible attacks via the descriptor ring.

(One example is the attack via descriptor.next)

Thanks


>
> Thank you.
>> Thanks
>>
>>
>>>
>>>> almost achieved that through packed virtqueue and we just need to fix
>>>> a corner case of handling mapping errors. For split virtqueue we just
>>>> follow what's done in the packed.
>>>>
>>>> Note that we don't duplicate descriptor medata for indirect
>>>> descriptors since it uses stream mapping which is read only so it's
>>>> safe if the metadata of non-indirect descriptors are correct.
>>>>
>>>> The behaivor for non DMA API is kept for minimizing the performance
>>>> impact.
>>>>
>>>> Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
>>>> the guest.
>>>>
>>>> Please review.
>>>>
>>>> [1] 
>>>> https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/ 
>>>>
>>>> [2] 
>>>> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b 
>>>>
>>>>
>>>> Jason Wang (7):
>>>>    virtio-ring: maintain next in extra state for packed virtqueue
>>>>    virtio_ring: rename vring_desc_extra_packed
>>>>    virtio-ring: factor out desc_extra allocation
>>>>    virtio_ring: secure handling of mapping errors
>>>>    virtio_ring: introduce virtqueue_desc_add_split()
>>>>    virtio: use err label in __vring_new_virtqueue()
>>>>    virtio-ring: store DMA metadata in desc_extra for split virtqueue
>>>>
>>>>   drivers/virtio/virtio_ring.c | 189 
>>>> ++++++++++++++++++++++++++---------
>>>>   1 file changed, 141 insertions(+), 48 deletions(-)
>>>>
>>>> -- 
>>>> 2.25.1
>>>>
>>
>

