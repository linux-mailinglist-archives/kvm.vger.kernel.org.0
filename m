Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8895423E009
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgHFR66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:58:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:7694 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbgHFR65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:58:57 -0400
IronPort-SDR: O/lRraiyaKOXjbXN4gVQdD8iXhurgoeaW2HABq2qiGhBadVHmmNsvtOJK3A6Zcq7fYzKuChkf7
 q+7+fAigCzyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="150621974"
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="150621974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 10:58:49 -0700
IronPort-SDR: WGC3D4nlVaLzrgypDWqqH6llZx5zTDC+SVvJHPfD0SSKh3/DpUU4NyjMhoZCXTcJkIstz1mvQy
 lsjwZ+NcGrcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="367666761"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 06 Aug 2020 10:58:49 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Aug 2020 10:58:49 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Aug 2020 10:58:49 -0700
Received: from [10.212.134.149] (10.212.134.149) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 6 Aug 2020 10:58:48 -0700
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
Date:   Thu, 6 Aug 2020 10:58:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.212.134.149]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 8/6/2020 10:10 AM, Thomas Gleixner wrote:
> Megha,
>
> "Dey, Megha" <megha.dey@intel.com> writes:
>
>>> -----Original Message-----
>>> From: Jason Gunthorpe <jgg@mellanox.com>
> <SNIP>
>>> Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
>>> irq domain
> can you please fix your mail client not to copy the whole header of the
> mail you are replying to into the mail body?

oops, i hope i have fixed it now..

>
>>>>> Well, I had suggested to pass in the parent struct device, but it
>>> Oops, I was thinking of platform_msi_domain_alloc_irqs() not
>>> create_device_domain()
>>>
>>> ie call it in the device driver that wishes to consume the extra MSIs.
>>>
>>> Is there a harm if each device driver creates a new irq_domain for its use?
>> Well, the only harm is if we want to reuse the irq domain.
> You cannot reuse the irq domain if you create a domain per driver. The
> way how hierarchical domains work is:
>
> vector --- DMAR-MSI
>         |
>         |-- ....
>         |
>         |-- IR-0 --- IO/APIC-0
>         |        |
>         |        |-- IO/APIC-1
>         |        |
>         |        |-- PCI/MSI-0
>         |        |
>         |        |-- HPET/MSI-0
>         |
>         |-- IR-1 --- PCI/MSI-1
>         |        |
>
> The outermost domain is what the actual device driver uses. I.e. for
> PCI-MSI it's the msi domain which is associated to the bus the device is
> connected to. Each domain has its own interrupt chip instance and its
> own data set.
>
> Domains of the same type share the code, but neither the data nor the
> interrupt chip instance.
>
> Also there is a strict parent child relationship in terms of resources.
> Let's look at PCI.
>
> PCI/MSI-0 depends on IR-0 which depends on the vector domain. That's
> reflecting both the flow of the interrupt and the steps required for
> various tasks, e.g. allocation/deallocation and also interrupt chip
> operations. In order to allocate a PCI/MSI interrupt in domain PCI/MSI-0
> a slot in the remapping unit and a vector needs to be allocated.
>
> If you disable interrupt remapping all the outermost domains in the
> scheme above become childs of the vector domain.
>
> So if we look at DEV/MSI as a infrastructure domain then the scheme
> looks like this:
>
> vector --- DMAR-MSI
>         |
>         |-- ....
>         |
>         |-- IR-0 --- IO/APIC-0
>         |        |
>         |        |-- IO/APIC-1
>         |        |
>         |        |-- PCI/MSI-0
>         |        |
>         |        |-- HPET/MSI-0
>         |        |
>         |        |-- DEV/MSI-0
>         |
>         |-- IR-1 --- PCI/MSI-1
>         |        |
>         |        |-- DEV/MSI-1
>
>
> But if you make it per device then you have multiple DEV/MSI domains per
> IR unit.
>
> What's the right thing to do?
>
> If the DEV/MSI domain has it's own per IR unit resource management, then
> you need one per IR unit.
>
> If the resource management is solely per device then having a domain per
> device is the right choice.

Thanks a lot Thomas for this detailed explanation!!

The dev-msi domain can be used by other devices if they too would want 
to follow the
vector->intel IR->dev-msi IRQ hierarchy.
I do create one dev-msi IRQ domain instance per IR unit. So I guess for 
this case,
it makes most sense to have a dev-msi IRQ domain per IR unit as opposed 
to create one
per individual driver..
>
> Thanks,
>
>          tglx
