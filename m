Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884DC3B2ED9
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhFXMYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:24:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:41405 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFXMYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 08:24:51 -0400
IronPort-SDR: MLuoo6qtTpJWerVSRRDnjVSe9fry8hx4W29I3IzSOKVrE+09o6NjUADfcfKQFH2jd1Afn28fgA
 R5BGeRmvUPbg==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="204450313"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="204450313"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 05:22:24 -0700
IronPort-SDR: q7SXO0zUj+MLdVTAzPX5Ffcx7ypQVhI54W2wkx/ktyNNnEWHQjIqGctUmmQL2fRKVQbSq4Cdee
 JUv8iZfyRIhQ==
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="487737745"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.211.177]) ([10.254.211.177])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 05:22:18 -0700
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
To:     David Gibson <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YNQJY2Ji+KOBYWbt@yekko>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <8e55d3c2-82ac-9be6-5c15-181b459c7893@linux.intel.com>
Date:   Thu, 24 Jun 2021 20:22:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNQJY2Ji+KOBYWbt@yekko>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/6/24 12:26, David Gibson wrote:
> On Fri, Jun 18, 2021 at 04:57:40PM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Friday, June 18, 2021 8:20 AM
>>>
>>> On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:
>>>
>>>> I've referred to this as a limitation of type1, that we can't put
>>>> devices within the same group into different address spaces, such as
>>>> behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
>>>> As isolation support improves we see fewer multi-device groups, this
>>>> scenario becomes the exception.  Buy better hardware to use the devices
>>>> independently.
>>>
>>> This is basically my thinking too, but my conclusion is that we should
>>> not continue to make groups central to the API.
>>>
>>> As I've explained to David this is actually causing functional
>>> problems and mess - and I don't see a clean way to keep groups central
>>> but still have the device in control of what is happening. We need
>>> this device <-> iommu connection to be direct to robustly model all
>>> the things that are in the RFC.
>>>
>>> To keep groups central someone needs to sketch out how to solve
>>> today's mdev SW page table and mdev PASID issues in a clean
>>> way. Device centric is my suggestion on how to make it clean, but I
>>> haven't heard an alternative??
>>>
>>> So, I view the purpose of this discussion to scope out what a
>>> device-centric world looks like and then if we can securely fit in the
>>> legacy non-isolated world on top of that clean future oriented
>>> API. Then decide if it is work worth doing or not.
>>>
>>> To my mind it looks like it is not so bad, granted not every detail is
>>> clear, and no code has be sketched, but I don't see a big scary
>>> blocker emerging. An extra ioctl or two, some special logic that
>>> activates for >1 device groups that looks a lot like VFIO's current
>>> logic..
>>>
>>> At some level I would be perfectly fine if we made the group FD part
>>> of the API for >1 device groups - except that complexifies every user
>>> space implementation to deal with that. It doesn't feel like a good
>>> trade off.
>>>
>>
>> Would it be an acceptable tradeoff by leaving >1 device groups
>> supported only via legacy VFIO (which is anyway kept for backward
>> compatibility), if we think such scenario is being deprecated over
>> time (thus little value to add new features on it)? Then all new
>> sub-systems including vdpa and new vfio only support singleton
>> device group via /dev/iommu...
> 
> The case that worries me here is if you *thought* you had 1 device
> groups, but then discover a hardware bug which means two things aren't
> as isolated as you thought they were.  What do you do then?
> 

Normally a hardware bug/quirk is identified during boot. For above case,
iommu core should put these two devices in a same iommu_group during
iommu_probe_device() phase. Any runtime hardware bug should be reported
to the OS through various methods so that the device could be quiet
and isolated. I don't think two devices could be in different groups
initially and then be moved to a single one.

Best regards,
baolu
