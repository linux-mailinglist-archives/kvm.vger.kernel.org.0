Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1755129467A
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 04:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439967AbgJUCVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 22:21:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411203AbgJUCVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 22:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603246894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9TkyuGjKr+kwj2xGR5gaQwUSE1E+WWGHEGXKN2z7MA=;
        b=HcH6VbtOXlP6M3msGAdkY6d8CU0WvShsRbhKunpvBpnsMjG80yq77KvwSiLAb6g9waT3Iy
        apBdk6RLPsZ915ve+eidUv5N23Kl933EOKrdhB9f3EgVMk3Rt+TeIUdfks3YEWGSpvFaR+
        FW5MMMw/rxE2+3U/L8WYRQYAqfPom/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-0OdzJi54ObuK2Rah01BLug-1; Tue, 20 Oct 2020 22:21:30 -0400
X-MC-Unique: 0OdzJi54ObuK2Rah01BLug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13B79803F4D;
        Wed, 21 Oct 2020 02:21:28 +0000 (UTC)
Received: from [10.72.13.199] (ovpn-13-199.pek2.redhat.com [10.72.13.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00F665B4A1;
        Wed, 21 Oct 2020 02:21:09 +0000 (UTC)
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
References: <MWHPR11MB1645CFB0C594933E92A844AC8C070@MWHPR11MB1645.namprd11.prod.outlook.com>
 <MWHPR11MB1645AE971BD8DAF72CE3E1198C050@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201016153632.GM6219@nvidia.com>
 <DM5PR11MB1435A3AEC0637C4531F2FE92C31E0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201019142526.GJ6219@nvidia.com>
 <DM5PR11MB14354A8A126E686A5F20FEC2C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20201020140217.GI6219@nvidia.com>
 <DM5PR11MB1435CCC75952FA94EC050CD7C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2bac0dde-21aa-2dc8-8f12-0736de9044ce@redhat.com>
Date:   Wed, 21 Oct 2020 10:21:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB1435CCC75952FA94EC050CD7C31F0@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/10/20 下午10:19, Liu, Yi L wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Tuesday, October 20, 2020 10:02 PM
> [...]
>>>> Whoever provides the vIOMMU emulation and relays the page fault to the
>> guest
>>>> has to translate the RID -
>>> that's the point. But the device info (especially the sub-device info) is
>>> within the passthru framework (e.g. VFIO). So page fault reporting needs
>>> to go through passthru framework.
>>>
>>>> what does that have to do with VFIO?
>>>>
>>>> How will VPDA provide the vIOMMU emulation?
>>> a pardon here. I believe vIOMMU emulation should be based on IOMMU
>> vendor
>>> specification, right? you may correct me if I'm missing anything.
>> I'm asking how will VDPA translate the RID when VDPA triggers a page
>> fault that has to be relayed to the guest. VDPA also has virtual PCI
>> devices it creates.
> I've got a question. Does vDPA work with vIOMMU so far? e.g. Intel vIOMMU
> or other type vIOMMU.


The kernel code is ready. Note that vhost suppport for vIOMMU is even 
earlier than VFIO.

The API is designed to be generic is not limited to any specific type of 
vIOMMU.

For qemu, it just need a patch to implement map/unmap notifier as what 
VFIO did.

Thanks



>
> Regards,
> Yi Liu
>

