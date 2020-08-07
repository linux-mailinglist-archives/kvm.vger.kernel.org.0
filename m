Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE1423F256
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 19:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHGRy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 13:54:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:14645 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgHGRyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 13:54:55 -0400
IronPort-SDR: N/1n8ICxbd3Pi/862YTt0n7zvUwkhEZKwvKZqgkJRPPGm3y36Y6dDMpa937BxwNwhc3Wjru4ZR
 79iRQFjg87UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="238009620"
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="238009620"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 10:54:55 -0700
IronPort-SDR: Ha8Ndz+CLfngTrmJMns8i3ZKIr4oDixdp2V5DKg+D3MjyI/mhmIKAIGIPW3XyyZuA7ck2WdHAZ
 iQbJN0GOzWqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="437975050"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 07 Aug 2020 10:54:55 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Aug 2020 10:54:54 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 7 Aug 2020 10:54:54 -0700
Received: from [10.254.183.24] (10.254.183.24) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 7 Aug
 2020 10:54:54 -0700
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
References: <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <20200807120650.GR16789@nvidia.com>
 <20200807123831.GA645281@kroah.com> <20200807133428.GT16789@nvidia.com>
 <87v9hufln7.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <d4e3ce5a-c138-2ebb-06d1-52ef57d987e6@intel.com>
Date:   Fri, 7 Aug 2020 10:54:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87v9hufln7.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.254.183.24]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 8/7/2020 9:47 AM, Thomas Gleixner wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
>> Though it is more of a rational and a cookbook on how to combine
>> existing technology pieces. (eg PASID, platform_msi, etc)
>>
>> The basic approach of SIOV's IMS is that there is no longer a generic
>> interrupt indirection from numbers to addr/data pairs like
>> IOAPIC/MSI/MSI-X owned by the common OS code.
>>
>> Instead the driver itself is responsible to set the addr/data pair
>> into the device in a device specific way, deal with masking, etc.
>>
>> This lets the device use an implementation that is not limited by the
>> harsh MSI-X semantics.
>>
>> In Linux we already have 'IMS' it is called platform_msi and a few
>> embedded drivers already work like this. The idea here is to bring it
>> to PCI.
> platform_msi as it exists today is a crutch and in hindsight I should
> have payed more attention back then and shoot it down before it got
> merged.
>
> IMS can be somehow mapped to platform MSI but the proposed approach to
> extend platform MSI with the extra bolts for IMS (valid for one
> particular incarnation) is just going into the wrong direction.
>
> We've been there and the main reason why hierarchical irq domains exist
> is that we needed to make a clear cut between the involved hardware
> pieces and their drivers. The pre hierarchy model was a maze of stuff
> calling back and forth between layers with lots of duct tape added to
> make it "work". This finally fell apart when Intel tried to support
> I/O-APIC hotplug. The ARM people had similar issues with all the special
> irq related SoC specific IP blocks which are placed between the CPU
> level interrupt controller and the device.
>
> The hierarchy strictly seperates the per layer resource management and
> each layer can work mostly independent of the actual available parent
> layer.
>
> Now looking at IMS. It's a subsystem inside a physical device. It has
> slot management (where to place the Message) and mask/unmask. Resource
> management at that level is what irq domains are for and mask/unmask is
> what a irq chip handles.
>
> So the right thing to do is to create shared infrastructure which is
> utilized by the device drivers by providing a few bog standard data
> structures and the handful of device specific domain and irq functions.
>
> That keeps the functionality common, but avoids that we end up with
>
>    - msi_desc becoming a dump ground for random driver data
>
>    - a zoo of platform callbacks
>    
>    - glued on driver specific resource management
>
> and all the great hacks which it requires to work on hundreds of
> different devices which all implement IMS differently.
>
> I'm all for sharing code and making the life of driver writers simple
> because that makes my life simple as well, but not by creating a layer
> at the wrong level and then hacking it into submission until it finally
> collapses.
>
> Designing the infrastructure following the clear layering rules of
> hierarchical domains so it works for IMS and also replaces the platform
> MSI hack is the only sane way to go forward, not the other way round.
 From what I've gathered, I need to:
1. Get rid of the mantra that "IMS" is an extension of platform-msi.
2. Make this new infra devoid of any platform-msi references
3. Come up with a ground up approach which adheres to the layering 
constraints of the IRQ subsystem
4. Have common code (drivers/irqchip maybe??) where we put in all the 
generic ims-specific bits for the IRQ chip and domain
which can be used by all device drivers belonging to this "IMS"class.
5. Have the device driver do the rest:
     create the chip/domain (one chip/domain per device?)
     provide device specific callbacks for masking, unmasking, write message

So from the hierarchical domain standpoint, we will have:
- For DSA device: vector->intel-IR->IDXD
- For Jason's device: root domain-> domain A-> Jason's device's IRQ domain
- For any other intel IMS device in the future which
     does not require interrupt remapping: vector->new device IRQ domain
     requires interrupt remapping: vector->intel-IR->new device IRQ 
domain (i.e. create a new domain even though IDXD is already present?)
Please let me know if my understanding is correct.

What I still don't understand fully is what if all the IMS devices need 
the same domain ops and chip callbacks, we will be creating various 
instances of the same IRQ chip and domain right? Is that ok?
Currently the creation of the IRQ domain happens at the IR level so that 
we can reuse the same domain but if it advisable to have a per device 
interrupt domain, I will shift this to the device driver.
>
> Thanks,
>
>          tglx
