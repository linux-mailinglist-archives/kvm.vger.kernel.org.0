Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F36B242449
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 05:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgHLD2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 23:28:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726473AbgHLD2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 23:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597202923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+AS7Kge0pM+bEArqAEDXssI6szpmV4WhiwYSaipqxiU=;
        b=B3/gTjjSCgOE/p05RUYC721QgdtF4jp0xFEY55qQx77A3dGNrqfNpr8Bqhq7Pst3Rww+pg
        TK53f89fRqcIEjiXiTVKvDFFi+YIZvT17eFycK1TsreuGfLpLjuagYMUzoM6dB2pBsziBc
        Ys8bES3PzFdwRbAAJiOjiSXR4ruSG5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-Qmblxh4hMV-GBzs8Mry_hw-1; Tue, 11 Aug 2020 23:28:38 -0400
X-MC-Unique: Qmblxh4hMV-GBzs8Mry_hw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9578017FB;
        Wed, 12 Aug 2020 03:28:34 +0000 (UTC)
Received: from [10.72.12.118] (ovpn-12-118.pek2.redhat.com [10.72.12.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D23C5F1EF;
        Wed, 12 Aug 2020 03:28:15 +0000 (UTC)
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
Date:   Wed, 12 Aug 2020 11:28:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/10 下午3:32, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Friday, August 7, 2020 8:20 PM
>>
>> On Wed, Aug 05, 2020 at 07:22:58PM -0600, Alex Williamson wrote:
>>
>>> If you see this as an abuse of the framework, then let's identify those
>>> specific issues and come up with a better approach.  As we've discussed
>>> before, things like basic PCI config space emulation are acceptable
>>> overhead and low risk (imo) and some degree of register emulation is
>>> well within the territory of an mdev driver.
>> What troubles me is that idxd already has a direct userspace interface
>> to its HW, and does userspace DMA. The purpose of this mdev is to
>> provide a second direct userspace interface that is a little different
>> and trivially plugs into the virtualization stack.
> No. Userspace DMA and subdevice passthrough (what mdev provides)
> are two distinct usages IMO (at least in idxd context). and this might
> be the main divergence between us, thus let me put more words here.
> If we could reach consensus in this matter, which direction to go
> would be clearer.
>
> First, a passthrough interface requires some unique requirements
> which are not commonly observed in an userspace DMA interface, e.g.:
>
> - Tracking DMA dirty pages for live migration;
> - A set of interfaces for using SVA inside guest;
> 	* PASID allocation/free (on some platforms);
> 	* bind/unbind guest mm/page table (nested translation);
> 	* invalidate IOMMU cache/iotlb for guest page table changes;
> 	* report page request from device to guest;
> 	* forward page response from guest to device;
> - Configuring irqbypass for posted interrupt;
> - ...
>
> Second, a passthrough interface requires delegating raw controllability
> of subdevice to guest driver, while the same delegation might not be
> required for implementing an userspace DMA interface (especially for
> modern devices which support SVA). For example, idxd allows following
> setting per wq (guest driver may configure them in any combination):
> 	- put in dedicated or shared mode;
> 	- enable/disable SVA;
> 	- Associate guest-provided PASID to MSI/IMS entry;
> 	- set threshold;
> 	- allow/deny privileged access;
> 	- allocate/free interrupt handle (enlightened for guest);
> 	- collect error status;
> 	- ...
>
> We plan to support idxd userspace DMA with SVA. The driver just needs
> to prepare a wq with a predefined configuration (e.g. shared, SVA,
> etc.), bind the process mm to IOMMU (non-nested) and then map
> the portal to userspace. The goal that userspace can do DMA to
> associated wq doesn't change the fact that the wq is still *owned*
> and *controlled* by kernel driver. However as far as passthrough
> is concerned, the wq is considered 'owned' by the guest driver thus
> we need an interface which can support low-level *controllability*
> from guest driver. It is sort of a mess in uAPI when mixing the
> two together.


So for userspace drivers like DPDK, it can use both of the two uAPIs?


>
> Based on above two reasons, we see distinct requirements between
> userspace DMA and passthrough interfaces, at least in idxd context
> (though other devices may have less distinction in-between). Therefore,
> we didn't see the value/necessity of reinventing the wheel that mdev
> already handles well to evolve an simple application-oriented usespace
> DMA interface to a complex guest-driver-oriented passthrough interface.
> The complexity of doing so would incur far more kernel-side changes
> than the portion of emulation code that you've been concerned about...
>   
>> I don't think VFIO should be the only entry point to
>> virtualization. If we say the universe of devices doing user space DMA
>> must also implement a VFIO mdev to plug into virtualization then it
>> will be alot of mdevs.
> Certainly VFIO will not be the only entry point. and This has to be a
> case-by-case decision.


The problem is that if we tie all controls via VFIO uAPI, the other 
subsystem like vDPA is likely to duplicate them. I wonder if there is a 
way to decouple the vSVA out of VFIO uAPI?


>   If an userspace DMA interface can be easily
> adapted to be a passthrough one, it might be the choice.


It's not that easy even for VFIO which requires a lot of new uAPIs and 
infrastructures(e.g mdev) to be invented.


> But for idxd,
> we see mdev a much better fit here, given the big difference between
> what userspace DMA requires and what guest driver requires in this hw.


A weak point for mdev is that it can't serve kernel subsystem other than 
VFIO. In this case, you need some other infrastructures (like [1]) to do 
this.

(For idxd, you probably don't need this, but it's pretty common in the 
case of networking or storage device.)

Thanks

[1] https://patchwork.kernel.org/patch/11280547/


>
>> I would prefer to see that the existing userspace interface have the
>> extra needed bits for virtualization (eg by having appropriate
>> internal kernel APIs to make this easy) and all the emulation to build
>> the synthetic PCI device be done in userspace.
> In the end what decides the direction is the amount of changes that
> we have to put in kernel, not whether we call it 'emulation'. For idxd,
> adding special passthrough requirements (guest SVA, dirty tracking,
> etc.) and raw controllability to the simple userspace DMA interface
> is for sure making kernel more complex than reusing the mdev
> framework (plus some degree of emulation mockup behind). Not to
> mention the merit of uAPI compatibility with mdev...
>
> Thanks
> Kevin
>

