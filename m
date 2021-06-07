Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF30E39E644
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 20:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFGSPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 14:15:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:42931 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFGSPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 14:15:00 -0400
IronPort-SDR: kbd/gQAzlRg1JA/4B2nWs+C93cFgZUw5RcWdh+diQdRM8Y2xs8bHtYnxMwusLpu487wtyXPOJP
 K9d90jD2LRRg==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="265829732"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="265829732"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 11:13:07 -0700
IronPort-SDR: wtR2fYWE5JseIRz4cHWWznciS2BtWxi0Wg6Q1fbUHif2u2USJlGDbkh9vPeuypSZcakMIzA4xS
 mRrVcl+Yi5uQ==
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="440146197"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.188.150]) ([10.213.188.150])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 11:13:05 -0700
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
 <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603214009.68fac0c4.alex.williamson@redhat.com>
 <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <168ee05a-faf4-3fce-e278-d783104fc442@intel.com>
Date:   Mon, 7 Jun 2021 11:13:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/6/2021 11:22 PM, Tian, Kevin wrote:
> Hi, Alex,
>
> Thanks for sharing your thoughts.
>
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Friday, June 4, 2021 11:40 AM
>>
>> On Thu, 3 Jun 2021 05:52:58 +0000
>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>
>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>> Sent: Thursday, June 3, 2021 9:50 AM
>>>>
>>>> On Thu, Jun 03, 2021 at 01:11:37AM +0000, Tian, Kevin wrote:
>>>>
>>>>> Jason, can you clarify your attitude on mdev guid stuff? Are you
>>>>> completely against it or case-by-case? If the former, this is a big
>>>>> decision thus it's better to have consensus with Alex/Kirti. If the
>>>>> latter, would like to hear your criteria for when it can be used
>>>>> and when not...
>>>> I dislike it generally, but it exists so <shrug>. I know others feel
>>>> more strongly about it being un-kernely and the wrong way to use sysfs.
>>>>
>>>> Here I was remarking how the example in the cover letter made the mdev
>>>> part seem totally pointless. If it is pointless then don't do it.
>>> Is your point about that as long as a mdev requires pre-config
>>> through driver specific sysfs then it doesn't make sense to use
>>> mdev guid interface anymore?
>> Can you describe exactly what step 1. is doing in this case from the
>> original cover letter ("Enable wq with "mdev" wq type")?  That does
>> sound a bit like configuring something to use mdev then separately
>> going to the trouble of creating the mdev.  As Jason suggests, if a wq
>> is tagged for mdev/vfio, it could just register itself as a vfio bus
>> driver.
> I'll leave to Dave to explain the exact detail in step 1.

So in step 1, we 'tag' the wq to be dedicated to guest usage and put the 
hardware wq into enable state. For a dedicated mode wq, we can 
definitely just register directly and skip the mdev step. For a shared 
wq mode, we can have multiple mdev running on top of a single wq. So we 
need some way to create more mdevs. We can either go with the existing 
established creation path by mdev, or invent something custom for the 
driver as Jason suggested to accomodate additional virtual devices for 
guests. We implemented the mdev path originally with consideration of 
mdev is established and has a known interface already.

>
>> But if we want to use mdev, why doesn't available_instances for your
>> mdev type simply report all unassigned wq and the `echo $UUID > create`
>> grabs a wq for mdev?  That would remove this pre-config contention,
>> right?
> This way could also work. It sort of changes pre-config to post-config,
> i.e. after an unassigned wq is grabbed for mdev, the admin then
> configures additional vendor specific parameters (not initialized by
> parent driver) before this mdev is assigned to a VM. Looks this is also
> what NVIDIA is doing for their vGPU, with a cmdline tool (nvidia-smi)
> and nvidia sysfs node for setting plugin parameters:
>
>          https://docs.nvidia.com/grid/latest/pdf/grid-vgpu-user-guide.pdf
>
> But I'll leave to Dave again as there must be a reason why they choose
> pre-config in the first place.

I think things become more complicated when we go from a dedicated wq to 
shared wq where the relationship of wq : mdev is 1 : 1 goes to 1 : N. 
Also needing to keep a consistent user config experience is desired, 
especially we already have such behavior since kernel 5.6 for host 
usages. So we really need try to avoid doing wq configuration 
differently just for "mdev" wqs. In the case suggested above, we 
basically just flipped the configuration steps. Mdev is first created 
through mdev sysfs interface. And then the device paramters are 
configured. Where for us, we configure the device parameter first, and 
then create the mdev. But in the end, it's still the hybrid mdev setup 
right?


>>> The value of mdev guid interface is providing a vendor-agnostic
>>> interface for mdev life-cycle management which allows one-
>>> enable-fit-all in upper management stack. Requiring vendor
>>> specific pre-config does blur the boundary here.
>> We need to be careful about using work-avoidance in the upper
>> management stack as a primary use case for an interface though.
> ok
>
>>> Alex/Kirt/Cornelia, what about your opinion here? It's better
>>> we can have an consensus on when and where the existing
>>> mdev sysfs could be used, as this will affect every new mdev
>>> implementation from now on.
>> I have a hard time defining some fixed criteria for using mdev.  It's
>> essentially always been true that vendors could write their own vfio
>> "bus driver", like vfio-pci or vfio-platform, specific to their device.
>> Mdevs were meant to be a way for the (non-vfio) driver of a device to
>> expose portions of the device through mediation for use with vfio.  It
>> seems like that's largely being done here.
>>
>> What I think has changed recently is this desire to make it easier to
>> create those vendor drivers and some promise of making module binding
>> work to avoid the messiness around picking a driver for the device.  In
>> the auxiliary bus case that I think Jason is working on, it sounds like
>> the main device driver exposes portions of itself on an auxiliary bus
>> where drivers on that bus can integrate into the vfio subsystem.  It
>> starts to get pretty fuzzy with what mdev already does, but it's also a
>> more versatile interface.  Is it right for everyone?  Probably not.
> idxd is also moving toward this model per Jason's suggestion. Although
> auxiliar bus is not directly used, idxd driver has its own bus for exposing
> portion of its resources. From this angle, all the motivation around mdev
> bus does get fuzzy...
>
>> Is the pre-configuration issue here really a push vs pull problem?  I
>> can see the requirement in step 1. is dedicating some resources to an
>> mdev use case, so at that point it seems like the argument is whether we
>> should just create aux bus devices that get automatically bound to a
>> vendor vfio-pci variant and we avoid the mdev lifecycle, which is both
>> convenient and ugly.  On the other hand, mdev has more of a pull
>> interface, ie. here are a bunch of device types and how many of each we
>> can support, use create to pull what you need.
> I see your point. Looks what idxd is toward now is a mixed model. The
> parent driver uses a push interface to initialize a pool of instances
> which are then managed through mdev in a pull mode.
>
>>>> Remember we have stripped away the actual special need to use
>>>> mdev. You don't *have* to use mdev anymore to use vfio. That is a
>>>> significant ideology change even from a few months ago.
>>>>
>>> Yes, "don't have to" but if there is value of doing so  it's
>>> not necessary to blocking it? One point in my mind is that if
>>> we should minimize vendor-specific contracts for user to
>>> manage mdev or subdevice...
>> Again, this in itself is not a great justification for using mdev,
>> we're creating vendor specific device types with vendor specific
>> additional features, that could all be done via some sort of netlink
>> interface too.  The thing that pushes this more towards mdev for me is
>> that I don't think each of these wqs appear as devices to the host,
>> they're internal resources of the parent device and we want to compose
>> them in ways that are slightly more amenable to traditional mdevs... I
>> think.  Thanks,
>>
> Yes, this is one reason going toward mdev.
>
> btw I'm not clear what the netlink interface will finally be, especially
> about whether any generic cmd should be defined cross devices given
> that subdevice management still has large generality. Jason, do you have
> an example somewhere which we can take a look regarding to mlx
> netlink design?
>
> Thanks
> Kevin
