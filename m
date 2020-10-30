Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B94C2A0FD3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbgJ3VAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:00:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:32555 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3VAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 17:00:00 -0400
IronPort-SDR: S2DaGEK3/ky/qmCbeZzsq/gFlizJXKIypHJiKQE5XXgwg2CMUSFs2FBpyfeHAn6Hkr3wopH21c
 gIxqRjJA/Cjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="186480721"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="186480721"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 13:59:59 -0700
IronPort-SDR: WOuCnB6z/vixUqU6DOU8AuXfxBTwkTHr/qas0/VMtwNEackb2rVWrkIjghZqtBj5/Pc55Phihb
 P+bAw3V20zVA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="362556466"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.46.60]) ([10.209.46.60])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 13:59:57 -0700
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     Megha Dey <megha.dey@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <878sbnmodd.fsf@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <9430e488-e6fc-0101-85dc-b3d8a1a40899@intel.com>
Date:   Fri, 30 Oct 2020 13:59:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <878sbnmodd.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/2020 1:48 PM, Thomas Gleixner wrote:
> On Fri, Oct 30 2020 at 11:50, Dave Jiang wrote:
>> The code has dependency on Thomas’s MSI restructuring patch series:
>> https://lore.kernel.org/lkml/20200826111628.794979401@linutronix.de/
> 
> which is outdated and not longer applicable.

Yes.... I wasn't sure how to point to these patches from you as a dependency.

irqdomain/msi: Provide msi_alloc/free_store() callbacks
platform-msi: Add device MSI infrastructure
genirq/msi: Provide and use msi_domain_set_default_info_flags()
genirq/proc: Take buslock on affinity write
platform-msi: Provide default irq_chip:: Ack
x86/msi: Rename and rework pci_msi_prepare() to cover non-PCI MSI
x86/irq: Add DEV_MSI allocation type

Do I need to include these patches in my series? Thanks!

> 
> Thanks,
> 
>          tglx
> 
