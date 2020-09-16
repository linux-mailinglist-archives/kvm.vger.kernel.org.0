Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B927026CD21
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIPUyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:54:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbgIPQxC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 12:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600275178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OHlFrQhUqBL1DWeL5u4a54eYPkpfgwlp82rza8GtDRI=;
        b=RdJ1GUpwhb8NqdGw6uQCOtquhgPXG0Nzae5gV8OfDCZr0u/Qcoha0ASgm9asmvA4nyeMjO
        ub1+ANcIDxJGw2Mzukpbnl+xXmGnY+7a2n1zpIpgduWSCejBVEUtjhjab9pcxUfkzWU8wO
        Jc+R5kQ2oTTtrBQooOoWet3mKqJ1bwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-vMiUF0y-M1-PFV9VUZuMag-1; Wed, 16 Sep 2020 12:50:51 -0400
X-MC-Unique: vMiUF0y-M1-PFV9VUZuMag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4C0C8797E1;
        Wed, 16 Sep 2020 16:50:49 +0000 (UTC)
Received: from [10.36.112.29] (ovpn-112-29.ams2.redhat.com [10.36.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B26D778809;
        Wed, 16 Sep 2020 16:50:33 +0000 (UTC)
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com> <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com> <20200914163310.450c8d6e@x1.home>
 <20200915142906.GX904879@nvidia.com>
 <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200916083217.GA5316@myrica> <20200916145148.GD6199@nvidia.com>
 <20200916162052.GE5316@myrica> <20200916163246.GC3699@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <47671ace-9b8f-7eca-0529-1191f00ed904@redhat.com>
Date:   Wed, 16 Sep 2020 18:50:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200916163246.GC3699@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 9/16/20 6:32 PM, Jason Gunthorpe wrote:
> On Wed, Sep 16, 2020 at 06:20:52PM +0200, Jean-Philippe Brucker wrote:
>> On Wed, Sep 16, 2020 at 11:51:48AM -0300, Jason Gunthorpe wrote:
>>> On Wed, Sep 16, 2020 at 10:32:17AM +0200, Jean-Philippe Brucker wrote:
>>>> And this is the only PASID model for Arm SMMU (and AMD IOMMU, I believe):
>>>> the PASID space of a PCI function cannot be shared between host and guest,
>>>> so we assign the whole PASID table along with the RID. Since we need the
>>>> BIND, INVALIDATE, and report APIs introduced here to support nested
>>>> translation, a /dev/sva interface would need to support this mode as well.
>>>
>>> Well, that means this HW cannot support PASID capable 'SIOV' style
>>> devices in guests.
>>
>> It does not yet support Intel SIOV, no. It does support the standards,
>> though: PCI SR-IOV to partition a device and PASIDs in a guest.
> 
> SIOV is basically standards based, it is better thought of as a
> cookbook on how to use PASID and IOMMU together.
> 
>>> I admit whole function PASID delegation might be something vfio-pci
>>> should handle - but only if it really doesn't fit in some /dev/sva
>>> after we cover the other PASID cases.
>>
>> Wouldn't that be the duplication you're trying to avoid?  A second
>> channel for bind, invalidate, capability and fault reporting
>> mechanisms?
> 
> Yes, which is why it seems like it would be nicer to avoid it. Why I
> said "might" :)
> 
>> If we extract SVA parts of vfio_iommu_type1 into a separate chardev,
>> PASID table pass-through [1] will have to use that.
> 
> Yes, '/dev/sva' (which is a terrible name) would want to be the uAPI
> entry point for controlling the vIOMMU related to PASID.
> 
> Does anything in the [1] series have tight coupling to VFIO other than
> needing to know a bus/device/function? It looks like it is mostly
> exposing iommu_* functions as uAPI?

this series does not use any PASID so it fits quite nicely into the VFIO
framework I think. Besides cache invalidation that takes the struct
device, other operations (MSI binding and PASID table passing operate on
the iommu domain). Also we use the VFIO memory region and
interrupt/eventfd registration mechanism to return faults.

Thanks

Eric
> 
> Jason
> 

