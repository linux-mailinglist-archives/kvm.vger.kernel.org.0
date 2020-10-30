Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1762A0E5F
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 20:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgJ3TNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 15:13:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:24463 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgJ3TNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 15:13:52 -0400
IronPort-SDR: a7mewWF+bPyYXdmuyqloFOfFJodQ/TOMPOxM309smcyV+5at1cUR8M7v/DXGsV8KxCl2QLnSL/
 dhlylJvJzsiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="232832674"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="232832674"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 12:13:51 -0700
IronPort-SDR: zOr0fSasaC4DcyXQU/yBP5MHlOwXIXCsiiZWgjwCWDZ8Vhti87QAzM1VQo5D2EJXLWyPuahCkV
 z8kprBo+a+2w==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="362533982"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.46.60]) ([10.209.46.60])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 12:13:49 -0700
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
Date:   Fri, 30 Oct 2020 12:13:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201030185858.GI2620339@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/2020 11:58 AM, Jason Gunthorpe wrote:
> On Fri, Oct 30, 2020 at 11:50:47AM -0700, Dave Jiang wrote:
>>   .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
>>   Documentation/driver-api/vfio/mdev-idxd.rst   |  404 ++++++
>>   MAINTAINERS                                   |    1 +
>>   drivers/dma/Kconfig                           |    9 +
>>   drivers/dma/idxd/Makefile                     |    2 +
>>   drivers/dma/idxd/cdev.c                       |    6 +-
>>   drivers/dma/idxd/device.c                     |  294 ++++-
>>   drivers/dma/idxd/idxd.h                       |   67 +-
>>   drivers/dma/idxd/init.c                       |   86 ++
>>   drivers/dma/idxd/irq.c                        |    6 +-
>>   drivers/dma/idxd/mdev.c                       | 1121 +++++++++++++++++
>>   drivers/dma/idxd/mdev.h                       |  116 ++
> 
> Again, a subsytem driver belongs in the directory hierarchy of the
> subsystem, not in other random places. All this mdev stuff belongs
> under drivers/vfio

Alex seems to have disagreed last time....
https://lore.kernel.org/dmaengine/20200917113016.425dcde7@x1.home/

And I do agree with his perspective. The mdev is an extension of the PF driver. 
It's a bit awkward to be a stand alone mdev driver under vfio/mdev/.

> 
> Jason
> 
