Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAF6295689
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 04:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895229AbgJVC4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 22:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895224AbgJVC4e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 22:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603335393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ebof72AAYUkpsZe+d7w21egOfOytLBoHlz0y4o/tgs=;
        b=VWQ6ajWRD6C/w2+R3182+Wzx270n2FC2VY2ftIdbS33KzOAzm9erE2xUamGEIq7L2o+ArS
        YML6K3XsrWbgk6WtHwYaFsNH3XBLdlka83wAGc/R+uM9atldBgfCL4pxj6Td2O1nIUIBN+
        jN7IYjhBHWcafSk3awdP9wQHCPcsDHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-_x_WK2oLO_OHAr8IvqDeRg-1; Wed, 21 Oct 2020 22:56:29 -0400
X-MC-Unique: _x_WK2oLO_OHAr8IvqDeRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57DDD835B49;
        Thu, 22 Oct 2020 02:56:27 +0000 (UTC)
Received: from [10.72.13.119] (ovpn-13-119.pek2.redhat.com [10.72.13.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1D381002C05;
        Thu, 22 Oct 2020 02:55:56 +0000 (UTC)
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
To:     "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
References: <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com> <20201020162430.GA85321@otc-nc-03>
 <20201020170336.GK6219@nvidia.com> <20201020195146.GA86371@otc-nc-03>
 <20201020195557.GO6219@nvidia.com> <20201020200844.GC86371@otc-nc-03>
 <20201020201403.GP6219@nvidia.com> <20201020202713.GF86371@otc-nc-03>
 <20201021114829.GR6219@nvidia.com> <20201021175146.GA92867@otc-nc-03>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <816799a0-49e4-a384-8990-eae9e67d4425@redhat.com>
Date:   Thu, 22 Oct 2020 10:55:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201021175146.GA92867@otc-nc-03>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/10/22 上午1:51, Raj, Ashok wrote:
> On Wed, Oct 21, 2020 at 08:48:29AM -0300, Jason Gunthorpe wrote:
>> On Tue, Oct 20, 2020 at 01:27:13PM -0700, Raj, Ashok wrote:
>>> On Tue, Oct 20, 2020 at 05:14:03PM -0300, Jason Gunthorpe wrote:
>>>> On Tue, Oct 20, 2020 at 01:08:44PM -0700, Raj, Ashok wrote:
>>>>> On Tue, Oct 20, 2020 at 04:55:57PM -0300, Jason Gunthorpe wrote:
>>>>>> On Tue, Oct 20, 2020 at 12:51:46PM -0700, Raj, Ashok wrote:
>>>>>>> I think we agreed (or agree to disagree and commit) for device types that
>>>>>>> we have for SIOV, VFIO based approach works well without having to re-invent
>>>>>>> another way to do the same things. Not looking for a shortcut by any means,
>>>>>>> but we need to plan around existing hardware though. Looks like vDPA took
>>>>>>> some shortcuts then to not abstract iommu uAPI instead :-)? When all
>>>>>>> necessary hardware was available.. This would be a solved puzzle.
>>>>>> I think it is the opposite, vIOMMU and related has outgrown VFIO as
>>>>>> the "home" and needs to stand alone.
>>>>>>
>>>>>> Apparently the HW that will need PASID for vDPA is Intel HW, so if
>>>>> So just to make this clear, I did check internally if there are any plans
>>>>> for vDPA + SVM. There are none at the moment.
>>>> Not SVM, SIOV.
>>> ... And that included.. I should have said vDPA + PASID, No current plans.
>>> I have no idea who set expectations with you. Can you please put me in touch
>>> with that person, privately is fine.
>> It was the team that aruged VDPA had to be done through VFIO - SIOV
>> and PASID was one of their reasons it had to be VFIO, check the list
>> archives
> Humm... I could search the arhives, but the point is I'm confirming that
> there is no forward looking plan!
>
> And who ever did was it was based on probably strawman hypothetical argument that wasn't
> grounded in reality.
>
>> If they didn't plan to use it, bit of a strawman argument, right?
> This doesn't need to continue like the debates :-) Pun intended :-)
>
> I don't think it makes any sense to have an abstract strawman argument
> design discussion. Yi is looking into for pasid management alone. Rest
> of the IOMMU related topics should wait until we have another
> *real* use requiring consolidation.
>
> Contrary to your argument, vDPA went with a half blown device only
> iommu user without considering existing abstractions like containers
> and such in VFIO is part of the reason the gap is big at the moment.
> And you might not agree, but that's beside the point.


Can you explain why it must care VFIO abstractions? vDPA is trying to 
hide device details which is fundamentally different with what VFIO 
wants to do. vDPA allows the parent to deal with IOMMU stuffs, and if 
necessary, the parent can talk with IOMMU drivers directly via IOMMU APIs.


>   
>
> Rather than pivot ourselves around hypothetical, strawman,
> non-intersecting, suggesting architecture without having done a proof of
> concept to validate the proposal should stop. We have to ground ourselves
> in reality.


The reality is VFIO should not be the only user for (v)SVA/SIOV/PASID. 
The kernel hard already had users like GPU or uacce.


>
> The use cases we have so far for SIOV, VFIO and mdev seem to be the right
> candidates and addresses them well. Now you might disagree, but as noted we
> all agreed to move past this.


The mdev is not perfect for sure, but it's another topic.

If you(Intel) don't have plan to do vDPA, you should not prevent other 
vendors from implementing PASID capable hardware through non-VFIO 
subsystem/uAPI on top of your SIOV architecture. Isn't it?

So if Intel has the willing to collaborate on the POC, I'd happy to 
help. E.g it's not hard to have a PASID capable virtio device through 
qemu, and we can start from there.

Thanks


>

