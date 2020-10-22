Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4AD29575A
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 06:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502444AbgJVEjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 00:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502339AbgJVEjR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 00:39:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603341556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siwhUMxivlmLeH5TYIGXWvfv+mhOu6A9HUz7iMu8arY=;
        b=JSKciWcxELgegAi0ZQjOeCC1dohOvWZUz2ssZEj4pcNhPdSd9nfqpy95smH2y2Ftv42/4t
        UDrP5h6wq/XoVMWmcs9qBbLs8SjlQv50XOJRPG1D0DFJwSCSsZSQeGwCJeBIgFcNWGNym0
        dK1CL6SzQP5U5ZdDhMF4dplcxQqrGPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495--A9e5AmfMW2W1pglcPqElA-1; Thu, 22 Oct 2020 00:39:12 -0400
X-MC-Unique: -A9e5AmfMW2W1pglcPqElA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A47CA1007462;
        Thu, 22 Oct 2020 04:39:09 +0000 (UTC)
Received: from [10.72.13.119] (ovpn-13-119.pek2.redhat.com [10.72.13.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7700B60C04;
        Thu, 22 Oct 2020 04:38:44 +0000 (UTC)
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
 <816799a0-49e4-a384-8990-eae9e67d4425@redhat.com>
 <DM5PR11MB14351121729909028D6EB365C31D0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <047c28cb-95f5-5b58-d5b5-153c069818fc@redhat.com>
Date:   Thu, 22 Oct 2020 12:38:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB14351121729909028D6EB365C31D0@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/10/22 上午11:54, Liu, Yi L wrote:
> Hi Jason,
>
>> From: Jason Wang <jasowang@redhat.com>
>> Sent: Thursday, October 22, 2020 10:56 AM
>>
> [...]
>> If you(Intel) don't have plan to do vDPA, you should not prevent other vendors
>> from implementing PASID capable hardware through non-VFIO subsystem/uAPI
>> on top of your SIOV architecture. Isn't it?
> yes, that's true.
>
>> So if Intel has the willing to collaborate on the POC, I'd happy to help. E.g it's not
>> hard to have a PASID capable virtio device through qemu, and we can start from
>> there.
> actually, I'm already doing a poc to move the PASID allocation/free interface
> out of VFIO. So that other users could use it as well. I think this is also
> what you replied previously. :-) I'll send out when it's ready and seek for
> your help on mature it. does it sound good to you?


Yes, fine with me.

Thanks


>
> Regards,
> Yi Liu
>
>> Thanks
>>
>>

