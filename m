Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF5923E400
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 00:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHFW2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 18:28:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:36351 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgHFW2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 18:28:00 -0400
IronPort-SDR: ZnEhlsh1lsBzpOXo/EGa+7XwGhav6cnFn2OT5slb7GKcBucUvZjr66bs3008nFPU/feAAlV6tF
 szNAZrWV4ZQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="150669248"
X-IronPort-AV: E=Sophos;i="5.75,443,1589266800"; 
   d="scan'208";a="150669248"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 15:27:59 -0700
IronPort-SDR: 7pIRHeDz2zm4c3qDcZtKcAy9UQTRcCaTH4mM+QrS6Ic4wZyuU7XbJ2w6Z0X7t48WtvqX5j7jms
 Mj6C0RSAwkhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,443,1589266800"; 
   d="scan'208";a="275207863"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 06 Aug 2020 15:27:59 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Aug 2020 15:27:58 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Aug 2020 15:27:58 -0700
Received: from [10.213.170.239] (10.213.170.239) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 6 Aug 2020 15:27:58 -0700
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
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <78a0cdd6-ba05-e153-b25e-2c0fe8c1e7b9@intel.com>
Date:   Thu, 6 Aug 2020 15:27:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87h7tfh6fc.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.213.170.239]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 8/6/2020 1:21 PM, Thomas Gleixner wrote:
> Megha,
>
> "Dey, Megha" <megha.dey@intel.com> writes:
>> On 8/6/2020 10:10 AM, Thomas Gleixner wrote:
>>> If the DEV/MSI domain has it's own per IR unit resource management, then
>>> you need one per IR unit.
>>>
>>> If the resource management is solely per device then having a domain per
>>> device is the right choice.
>> The dev-msi domain can be used by other devices if they too would want
>> to follow the vector->intel IR->dev-msi IRQ hierarchy.  I do create
>> one dev-msi IRQ domain instance per IR unit. So I guess for this case,
>> it makes most sense to have a dev-msi IRQ domain per IR unit as
>> opposed to create one per individual driver..
> I'm not really convinced. I looked at the idxd driver and that has it's
> own interrupt related resource management for the IMS slots and provides
> the mask,unmask callbacks for the interrupt chip via this crude platform
> data indirection.
>
> So I don't see the value of the dev-msi domain per IR unit. The domain
> itself does not provide much functionality other than indirections and
> you clearly need per device interrupt resource management on the side
> and a customized irq chip. I rather see it as a plain layering
> violation.
>
> The point is that your IDXD driver manages the per device IMS slots
> which is a interrupt related resource. The story would be different if
> the IMS slots would be managed by some central or per IR unit entity,
> but in that case you'd need IMS specific domain(s).
>
> So the obvious consequence of the hierarchical irq design is:
>
>     vector -> IR -> IDXD
>
> which makes the control flow of allocating an interrupt for a subdevice
> straight forward following the irq hierarchy rules.
>
> This still wants to inherit the existing msi domain functionality, but
> the amount of code required is small and removes all these pointless
> indirections and integrates the slot management naturally.
>
> If you expect or know that there are other devices coming up with IMS
> integrated then most of that code can be made a common library. But for
> this to make sense, you really want to make sure that these other
> devices do not require yet another horrible layer of indirection.
Yes Thomas, for now this may look odd since there is only one device 
using this
IRQ domain. But there will be other devices following suit, hence I have 
added
all the IRQ chip/domain bits in a separate file in drivers/irqchip in 
the next
version of patches. I'll submit the patches shortly and it will be great 
if I
can get more feedback on it.
> A side note: I just read back on the specification and stumbled over
> the following gem:
>
>   "IMS may also optionally support per-message masking and pending bit
>    status, similar to the per-vector mask and pending bit array in the
>    PCI Express MSI-X capability."
>
> Optionally? Please tell the hardware folks to make this mandatory. We
> have enough pain with non maskable MSI interrupts already so introducing
> yet another non maskable interrupt trainwreck is not an option.
>
> It's more than a decade now that I tell HW people not to repeat the
> non-maskable MSI failure, but obviously they still think that
> non-maskable interrupts are a brilliant idea. I know that HW folks
> believe that everything they omit can be fixed in software, but they
> have to finally understand that this particular issue _cannot_ be fixed
> at all.
hmm, I asked the hardware folks and they have informed me that all IMS 
devices
will support per vector masking/pending bit. This will be updated in the 
next SIOV
spec which will be published soon.
>
> Thanks,
>
>          tglx
