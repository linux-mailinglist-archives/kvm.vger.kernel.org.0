Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA726E24D
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIQRZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 13:25:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:18415 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgIQRZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 13:25:36 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 13:24:40 EDT
IronPort-SDR: W8aiqw4mkzlHLXz5QxbMNIN05J7T7inNnDLPY+r2FgFiSMoUcA1Y36/e48I/GNoRaHtMjzoKWa
 OdSiv3spRsSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="139750307"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="139750307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 10:15:29 -0700
IronPort-SDR: RA7L5wTJFENSj9aj9zv5UwUQj1QaPo2BOH7baLD4WB+F7Jd8xCbwCzwwWSovervwInN7w1nizZ
 r8ga1TIhji0Q==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="287659895"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.200.158]) ([10.212.200.158])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 10:15:27 -0700
Subject: Re: [PATCH v3 00/18] Add VFIO mediated device support and DEV-MSI
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
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <20200917150641.GM3699@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <f4a085f1-f6de-2539-12fe-c7308d243a4a@intel.com>
Date:   Thu, 17 Sep 2020 10:15:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917150641.GM3699@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/17/2020 8:06 AM, Jason Gunthorpe wrote:
> On Tue, Sep 15, 2020 at 04:27:35PM -0700, Dave Jiang wrote:
>>   drivers/dma/idxd/idxd.h                            |   65 +
>>   drivers/dma/idxd/init.c                            |  100 ++
>>   drivers/dma/idxd/irq.c                             |    6
>>   drivers/dma/idxd/mdev.c                            | 1089 ++++++++++++++++++++
>>   drivers/dma/idxd/mdev.h                            |  118 ++
> 
> It is common that drivers of a subsystem will be under that
> subsystem's directory tree. This allows the subsystem community to
> manage pages related to their subsystem and it's drivers.
> 
> Should the mdev parts be moved there?

I personally don't have a preference. I'll defer to Alex or Kirti to provide 
that guidance. It may make certains things like dealing with dma fault regions 
and etc easier using vfio calls from vfio_pci_private.h later on for vSVM 
support. It also may be the better code review and maintenance domain and 
alleviate Vinod having to deal with that portion since it's not dmaengine domain.

> 
> Jason
> 
