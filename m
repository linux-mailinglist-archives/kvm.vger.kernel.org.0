Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68ADC2937E5
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 11:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392750AbgJTJUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 05:20:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730684AbgJTJUk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 05:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603185639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZrTt3RPheBVTMDXVvDc/OXdQNtnIu9P2NzODgtsSV0=;
        b=OfvaBT0PZZS7/kQrFN4iChq5kmUH/pPQbdz0rKlhmKq0whLVC25jFl3fNSEVplNh+KwJ4P
        YQu3P6NZcKExLx38gEFPwuKRk0IfYT54YnxW6NG9kQQR+dL/Ec4ttzsq/lkwwKb5wPi3Un
        /E6ZHyi57an3e+LwX4HNUGnBSHuJkP0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-aRgYslQlN8CC3xuq29C9PA-1; Tue, 20 Oct 2020 05:20:35 -0400
X-MC-Unique: aRgYslQlN8CC3xuq29C9PA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 436289CC1C;
        Tue, 20 Oct 2020 09:20:33 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05AEC6EF6E;
        Tue, 20 Oct 2020 09:19:57 +0000 (UTC)
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Cc:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <45faf89a-0a40-2a7a-0a76-d7ba76d0813b@redhat.com>
 <MWHPR11MB1645CF252CF3493F4A9487508C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <9c10b681-dd7e-2e66-d501-7fcc3ff1207a@redhat.com>
 <MWHPR11MB164501E77BDB0D5AABA8487F8C020@MWHPR11MB1645.namprd11.prod.outlook.com>
 <21a66a96-4263-7df2-3bec-320e6f38a9de@redhat.com>
 <DM5PR11MB143531293E4D65028801FDA1C3020@DM5PR11MB1435.namprd11.prod.outlook.com>
 <a43d47f5-320b-ef60-e2be-a797942ea9f2@redhat.com>
 <DM5PR11MB1435D55CAE858CC8EC2AFA47C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6e478a9e-2051-c0cd-b6fd-624ff5ef0f53@redhat.com>
Date:   Tue, 20 Oct 2020 17:19:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB1435D55CAE858CC8EC2AFA47C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi:

On 2020/10/20 下午4:19, Liu, Yi L wrote:
>> Yes, but since PASID is a global identifier now, I think kernel should
>> track the a device list per PASID?
> We have such track. It's done in iommu driver. You can refer to the
> struct intel_svm. PASID is a global identifier, but it doesn’t affect that
> the PASID table is per-device.
>
>> So for such binding, PASID should be
>> sufficient for uAPI.
> not quite get it. PASID may be bound to multiple devices, how do
> you figure out the target device if you don’t provide such info.


I may miss soemthing but is there any reason that userspace need to 
figure out the target device? PASID is about address space not a 
specific device I think.


>
>>>>> The binding request is initiated by the virtual IOMMU, when capturing
>>>>> guest attempt of binding page table to a virtual PASID entry for a
>>>>> given device.
>>>> And for L2 page table programming, if PASID is use by both e.g VFIO and
>>>> vDPA, user need to choose one of uAPI to build l2 mappings?
>>> for L2 page table mappings, it's done by VFIO MAP/UNMAP. for vdpa, I guess
>>> it is tlb flush. so you are right. Keeping L1/L2 page table management in
>>> a single uAPI set is also a reason for my current series which extends VFIO
>>> for L1 management.
>> I'm afraid that would introduce confusing to userspace. E.g:
>>
>> 1) when having only vDPA device, it uses vDPA uAPI to do l2 management
>> 2) when vDPA shares PASID with VFIO, it will use VFIO uAPI to do the l2
>> management?
> I think vDPA will still use its own l2 for the l2 mappings. not sure why you
> need vDPA use VFIO's l2 management. I don't think it is the case.


See previous discussion with Kevin. If I understand correctly, you 
expect a shared L2 table if vDPA and VFIO device are using the same PASID.

In this case, if l2 is still managed separately, there will be 
duplicated request of map and unmap.

Thanks


>
> Regards,
> Yi Liu
>

