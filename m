Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA61BAA12
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 18:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgD0Q0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 12:26:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:63947 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgD0Q0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 12:26:03 -0400
IronPort-SDR: Wg5Jf+8g2xsColPpoqLAZ5bVnZZ7/bds3PqOY+QrMGl59ffbKZ8WGhE+DUOrxESyq+MqFe4+sS
 mQC/LQFj9lQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 09:26:02 -0700
IronPort-SDR: kOdgCf+VvD2U+8+05JkhvCxBcCXLYvUX3hluIRiCFSsJ8Uhkef83MmD472PSiHHC97bOYikDcj
 +h6Cxdb3YypA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,324,1583222400"; 
   d="scan'208";a="246196130"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.181.12]) ([10.213.181.12])
  by orsmga007.jf.intel.com with ESMTP; 27 Apr 2020 09:26:00 -0700
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com> <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com> <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com> <20200427081841.18c4a994@x1.home>
 <20200427142553.GH13640@mellanox.com> <20200427094137.4801bfb6@w520.home>
 <20200427161625.GI13640@mellanox.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <e2cbba8b-e204-42bc-44cd-ebdb6be211e3@intel.com>
Date:   Mon, 27 Apr 2020 09:25:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427161625.GI13640@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/27/2020 9:16 AM, Jason Gunthorpe wrote:
> On Mon, Apr 27, 2020 at 09:41:37AM -0600, Alex Williamson wrote:
>> On Mon, 27 Apr 2020 11:25:53 -0300
>> Jason Gunthorpe <jgg@mellanox.com> wrote:
>>
>>> On Mon, Apr 27, 2020 at 08:18:41AM -0600, Alex Williamson wrote:
>>>> On Mon, 27 Apr 2020 10:22:18 -0300
>>>> Jason Gunthorpe <jgg@mellanox.com> wrote:
>>>>    
>>>>> On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:
>>>>>    
>>>>>>> It is not trivial masking. It is a 2000 line patch doing comprehensive
>>>>>>> emulation.
>>>>>>
>>>>>> Not sure what you're referring to, I see about 30 lines of code in
>>>>>> vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
>>>>>> config space and maybe a couple hundred lines of code in total handling
>>>>>> config space emulation.  Thanks,
>>>>>
>>>>> Look around vidxd_do_command()
>>>>>
>>>>> If I understand this flow properly..
>>>>
>>>> I've only glanced at it, but that's called in response to a write to
>>>> MMIO space on the device, so it's implementing a device specific
>>>> register.
>>>
>>> It is doing emulation of the secure BAR. The entire 1000 lines of
>>> vidxd_* functions appear to be focused on this task.
>>
>> Ok, we/I need a terminology clarification, a BAR is a register in
>> config space for determining the size, type, and setting the location
>> of a I/O or memory region of a device.  I've been asserting that the
>> emulation of the BAR itself is trivial, but are you actually focused on
>> emulation of the region described by the BAR?
> 
> Yes, BAR here means the actually MMIO memory window - not the config
> space part. Config space emulation is largely trivial.
> 
>>>> Are you asking that PCI config space be done in userspace
>>>> or any sort of device emulation?
>>>
>>> I'm concerned about doing full emulation of registers on a MMIO BAR
>>> that trigger complex actions in response to MMIO read/write.
>>
>> Maybe what you're recalling me say about mdev is that its Achilles
>> heel is that we rely on mediation provider (ie. vendor driver) for
>> security, we don't necessarily have an piece of known, common hardware
>> like an IOMMU to protect us when things go wrong.  That's true, but
>> don't we also trust drivers in the host kernel to correctly manage and
>> validate their own interactions with hardware, including the APIs
>> provided through other user interfaces.  Is the assertion then that
>> device specific, register level API is too difficult to emulate?
> 
> No, it is a reflection on the standard Linux philosophy that if it can
> be done in user space it should be done in userspace. Ie keep minimal
> work in the monolithic kernel.
> 
> Also to avoid duplication, ie idxd proposes to have a char dev with a
> normal kernel driver interface and then an in-kernel emulated MMIO BAR
> version of that same capability for VFIO consumption.

The char dev interface serves user apps on host (which we will deprecate 
and move to the UACCE framework in near future). The mdev interface will 
be servicing guests only. I'm not sure where the duplication of 
functionality comes into play.

> 
> Jason
> 
