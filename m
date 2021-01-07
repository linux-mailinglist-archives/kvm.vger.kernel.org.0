Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC822EC7E8
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 03:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhAGCEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 21:04:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:49782 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbhAGCEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 21:04:55 -0500
IronPort-SDR: RDo+Mx/OtYC2dFG17EqGT7QI7R1c4bWYUYTxgr0x6Jc/xke1b3spqHZIG8wmC7rBr+w39UwOzQ
 DOg4Si9B24Rw==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="157144509"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="157144509"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 18:03:09 -0800
IronPort-SDR: n7P5Mq/oH8n/P6xpdUTkl4TlvjA9soP50rLbD+bSq6KWCK64WUnr40vtcFN1TADUSIK2rTRo5I
 A3impTlyBmRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="462867708"
Received: from allen-box.sh.intel.com (HELO [10.239.159.28]) ([10.239.159.28])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jan 2021 18:03:02 -0800
Cc:     baolu.lu@linux.intel.com, tglx@linutronix.de, ashok.raj@intel.com,
        kevin.tian@intel.com, dave.jiang@intel.com, megha.dey@intel.com,
        dwmw2@infradead.org, alex.williamson@redhat.com,
        bhelgaas@google.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v2 1/1] platform-msi: Add platform check for subdevice
 irq domain
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
 <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
 <20210106104017.GV31158@unreal> <20210106152339.GA552508@nvidia.com>
 <20210106160158.GX31158@unreal>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <e2881bb1-4690-c665-923f-ff711432cc85@linux.intel.com>
Date:   Thu, 7 Jan 2021 09:55:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106160158.GX31158@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/21 12:01 AM, Leon Romanovsky wrote:
> On Wed, Jan 06, 2021 at 11:23:39AM -0400, Jason Gunthorpe wrote:
>> On Wed, Jan 06, 2021 at 12:40:17PM +0200, Leon Romanovsky wrote:
>>
>>> I asked what will you do when QEMU will gain needed functionality?
>>> Will you remove QEMU from this list? If yes, how such "new" kernel will
>>> work on old QEMU versions?
>>
>> The needed functionality is some VMM hypercall, so presumably new
>> kernels that support calling this hypercall will be able to discover
>> if the VMM hypercall exists and if so superceed this entire check.
> 
> Let's not speculate, do we have well-known path?

All these (hypercall detect and invoke) will be done in
pci_subdevice_msi_create_irq_domain(). It will be transparent to the
callers.

> Will such patch be taken to stable@/distros?

It will not be taken to stable. For distros, it depends. They can
backport if they want to support the feature.

Best regards,
baolu
