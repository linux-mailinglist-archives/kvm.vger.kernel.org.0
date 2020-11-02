Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF42C2A32BE
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKBSSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:18:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:63800 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgKBSSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:18:39 -0500
IronPort-SDR: xY1G/DZLIXKRoMPcAdqRbHuosu0AV3eybq/tXjhiWxU/vp41MCqHnowrHEoomex8b+WoYSlzik
 f3mQv6QVBk3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="169031274"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="169031274"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 10:18:38 -0800
IronPort-SDR: oF/i1SsSGRxUOiA/dJwiaQ613OylcyOSVl+zRFb5481okUHsRV9ukA6+E8pJLLe59VdJEhq+iD
 ILHDq33gOVfw==
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="336254810"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.251.132.252]) ([10.251.132.252])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 10:18:36 -0800
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com> <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com> <20201030204307.GA683@otc-nc-03>
 <87h7qbkt18.fsf@nanos.tec.linutronix.de>
 <20201031235359.GA23878@araj-mobl1.jf.intel.com>
 <20201102132036.GX2620339@nvidia.com> <20201102162043.GB20783@otc-nc-03>
 <20201102171909.GF2620339@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <20d7c5fc-91b0-d673-d41a-335d91ca2dce@intel.com>
Date:   Mon, 2 Nov 2020 11:18:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102171909.GF2620339@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/2/2020 10:19 AM, Jason Gunthorpe wrote:
> On Mon, Nov 02, 2020 at 08:20:43AM -0800, Raj, Ashok wrote:
>> Creating these private interfaces for intra-module are just 1-1 and not
>> general purpose and every accelerator needs to create these instances.
> 
> This is where we are going, auxillary bus should be merged soon which
> is specifically to connect these kinds of devices across subsystems

I think this resolves the aux device probe/remove issue via a common bus. But it 
does not help with the mdev device needing a lot of the device handling calls 
from the parent driver as it share the same handling as the parent device. My 
plan is to export all the needed call via EXPORT_SYMBOL_NS() so the calls can be 
shared in its own namespace between the modules. Do you have any objection with 
that?

> 
> Jason
> 
