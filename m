Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578A01D04E1
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 04:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgEMCaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 22:30:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40567 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727082AbgEMCaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 22:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589337000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iT2hW+HYXkczOFTWfJmASn4ajF5YSjXsGJSRKP6B8QY=;
        b=CVOy29ssTBBUdBgXdE6VGpH7W+32DF86LhZcriuK6XUqjTXm0lLcpqLBfKGRGVxanBDBAP
        M5xKKo6ucy8eMs3JiMePsGcmTRrOSBGCn9EY1prNu/9QwebPIFPE4I8JLIGRmWp0sC8DnO
        AQGFIpIvZSkhqW9DlvuDICG8SwBEf8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-EmZXlPFvPpqAhwBszIdqLA-1; Tue, 12 May 2020 22:29:56 -0400
X-MC-Unique: EmZXlPFvPpqAhwBszIdqLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18B981005510;
        Wed, 13 May 2020 02:29:53 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 189CC60BF1;
        Wed, 13 May 2020 02:29:32 +0000 (UTC)
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com> <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com> <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03> <20200508231610.GO19158@mellanox.com>
 <20200509000909.GA79981@otc-nc-03> <20200509122113.GP19158@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <196b23b9-12f7-2fc2-5efb-22e0642c456a@redhat.com>
Date:   Wed, 13 May 2020 10:29:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200509122113.GP19158@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/5/9 下午8:21, Jason Gunthorpe wrote:
> On Fri, May 08, 2020 at 05:09:09PM -0700, Raj, Ashok wrote:
>> Hi Jason
>>
>> On Fri, May 08, 2020 at 08:16:10PM -0300, Jason Gunthorpe wrote:
>>> On Fri, May 08, 2020 at 01:47:10PM -0700, Raj, Ashok wrote:
>>>
>>>> Even when uaccel was under development, one of the options
>>>> was to use VFIO as the transport, goal was the same i.e to keep
>>>> the user space have one interface.
>>> I feel a bit out of the loop here, uaccel isn't in today's kernel is
>>> it? I've heard about it for a while, it sounds very similar to RDMA,
>>> so I hope they took some of my advice...
>> I think since 5.7 maybe? drivers/misc/uacce. I don't think this is like
>> RDMA, its just a plain accelerator. There is no connection management,
>> memory registration or other things.. IB was my first job at Intel,
>> but saying that i would be giving my age away:)
> rdma was the first thing to do kernel bypass, all this stuff is like
> rdma at some level.. I see this looks like the 'warp driver' stuff
> redone
>
> Wow, lots wrong here. Oh well.
>
>>> putting emulation code back into them, except in a more dangerous
>>> kernel location. This does not seem like a net win to me.
>> Its not a whole lot of emulation right? mdev are soft partitioned. There is
>> just a single PF, but we can create a separate partition for the guest using
>> PASID along with the normal BDF (RID). And exposing a consistent PCI like
>> interface to user space you get everything else for free.
>>
>> Yes, its not SRIOV, but giving that interface to user space via VFIO, we get
>> all of that functionality without having to reinvent a different way to do it.
>>
>> vDPA went the other way, IRC, they went and put a HW implementation of what
>> virtio is in hardware. So they sort of fit the model. Here the instance
>> looks and feels like real hardware for the setup and control aspect.
> VDPA and this are very similar, of course it depends on the exact HW
> implementation.
>
> Jason


Actually this is not a must. Technically we can do ring/descriptor 
translation in the vDPA driver as what zerocopy AF_XDP did.

Thanks


>

