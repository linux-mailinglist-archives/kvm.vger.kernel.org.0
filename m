Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80BE1CBB69
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgEHXxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:53:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:64968 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgEHXxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:53:00 -0400
IronPort-SDR: 7W/WTduQHh4K85ty3T1PLNfWOgf2BLuBED5nvJdgQNBYKcBO9G8s6i+NsBhOZfMxRTm9vquzR0
 SAhNCqSfhiwA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 16:53:00 -0700
IronPort-SDR: 5FbVbZSaevR+FLoYoAPBrA3ZoAmxaPh6wXWd08J2J9xWoH8Ncth6EK5vtLiKzZ6SJmrFoCzEkv
 NaihJWadQAzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="296299524"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.47.49]) ([10.209.47.49])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2020 16:52:58 -0700
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
References: <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com> <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com> <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03> <20200508231610.GO19158@mellanox.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <57296ad1-20fe-caf2-b83f-46d823ca0b5f@intel.com>
Date:   Fri, 8 May 2020 16:52:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508231610.GO19158@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/8/2020 4:16 PM, Jason Gunthorpe wrote:
> On Fri, May 08, 2020 at 01:47:10PM -0700, Raj, Ashok wrote:
> 
>> Even when uaccel was under development, one of the options
>> was to use VFIO as the transport, goal was the same i.e to keep
>> the user space have one interface.
> 
> I feel a bit out of the loop here, uaccel isn't in today's kernel is
> it? I've heard about it for a while, it sounds very similar to RDMA,
> so I hope they took some of my advice...

It went into 5.7 kernel. drivers/misc/uacce. It looks char device exported with 
SVM support.

> 
>> But the needs of generic user space application is significantly
>> different from exporting a more functional device model to guest,
>> which isn't full emulated device. which is why VFIO didn't make
>> sense for native use.
> 
> I'm not sure this is true. We've done these kinds of emulated SIOV
> like things already and there is a huge overlap between what a generic
> user application needs and what the VMM neds. Actually almost a
> perfect subset except for interrupt remapping (which is quite
> trivial).
> 
> The things vfio focuses on, like groups and managing a real config
> space just don't apply here.
> 
>> And when we move things from VFIO which is already established
>> as a general device model and accepted by multiple VMM's it gives
>> instant footing without a whole redesign.
> 
> Yes, I understand, but I think you need to get more people to support
> this idea. From my standpoint this is taking secure lean VMMs and
> putting emulation code back into them, except in a more dangerous
> kernel location. This does not seem like a net win to me.
> 
> You'd be much better to have some userspace library scheme instead of
> being completely tied to a kernel interface for modularity.
> 
>> When we move things from VFIO to uaccel to bolt on the functionality
>> like VFIO, I suspect we would be moving code/functionality from VFIO
>> to Uaccel. I don't know what the net gain would be.
> 
> Most of VFIO functionality is already decomposed inside the kernel,
> and you need most of it to do secure user access anyhow.
> 
>> For mdev, would you agree we can keep the current architecture,
>> and investigate moving some emulation code to user space (say even for
>> standard vfio_pci) and then expand scope later.
> 
> I won't hard NAK this, but I think you need more people to support
> this general idea of more emulation code in the kernel to go ahead -
> particularly since this is one of many future drivers along this
> design.
> 
> It would be good to hear from the VMM teams that this is what they
> want (and why), for instance.
> 
> Jason
> 
