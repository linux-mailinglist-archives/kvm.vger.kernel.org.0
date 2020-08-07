Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA923F3D0
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHGUcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 16:32:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:27008 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgHGUcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 16:32:02 -0400
IronPort-SDR: NGilUrbjowMQpp2DWPYvoI6V3pDtDvC0Cnz82EXoRkh8JEjp+XmQB74WpKaquOyY+WRrQOpm4X
 BcOjdFhvd51A==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="171246252"
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="171246252"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:32:02 -0700
IronPort-SDR: IN18xFCKQgClrIUKzDHAPEBjhp7AvR9YSRvj0zUJoUoAQF6T8Ol2TBqri5Pua/0BehsckxirXX
 h7T7z+sPVV4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="307489966"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 13:32:01 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Aug 2020 13:32:01 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 7 Aug 2020 13:32:01 -0700
Received: from [10.254.183.24] (10.254.183.24) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 7 Aug
 2020 13:32:01 -0700
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>,
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
References: <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <20200807120650.GR16789@nvidia.com>
 <20200807123831.GA645281@kroah.com> <20200807133428.GT16789@nvidia.com>
 <87v9hufln7.fsf@nanos.tec.linutronix.de>
 <d4e3ce5a-c138-2ebb-06d1-52ef57d987e6@intel.com>
 <20200807183927.GY16789@nvidia.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <17351360-a880-f651-2a99-6f9817b99e03@intel.com>
Date:   Fri, 7 Aug 2020 13:31:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200807183927.GY16789@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.254.183.24]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/7/2020 11:39 AM, Jason Gunthorpe wrote:
> On Fri, Aug 07, 2020 at 10:54:51AM -0700, Dey, Megha wrote:
>
>> So from the hierarchical domain standpoint, we will have:
>> - For DSA device: vector->intel-IR->IDXD
>> - For Jason's device: root domain-> domain A-> Jason's device's IRQ domain
>> - For any other intel IMS device in the future which
>>      does not require interrupt remapping: vector->new device IRQ domain
>>      requires interrupt remapping: vector->intel-IR->new device IRQ domain
> I think you need a better classification than Jason's device or
> Intel's device :)
hehe yeah, for sure, just wanted to get my point across :)
>
> Shouldn't the two cases be either you take the parent domain from the
> IOMMU or you take the parent domain from the pci device?

Hmm yeah this makes sense..

Although in the case of DSA, we find the iommu corresponding to the 
parent PCI device.

>
> What other choices could a PCI driver make?
Currently I think based on the devices we have, I don't think there are 
any others
>
> Jason
