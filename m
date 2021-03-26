Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A06349E63
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 02:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCZBE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 21:04:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:49260 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230120AbhCZBEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 21:04:01 -0400
IronPort-SDR: MwKBp9kxGzJ5/XUSh+tS4A8dbHBrO1Rpf5/ISIKPphhCbHAvBru+9yAyrohfz21ShnUckgpOVp
 lCYt6egJ8M+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="178604699"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="178604699"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 18:04:00 -0700
IronPort-SDR: i/t+GBh+pimmH2clQEO7DHHzuKyakP9WT7fBKDiAFncZY+OdlPgEH4JY3/F61NzvRWcFausUHX
 huRfojb5IuNw==
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="525855417"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.209.174.55]) ([10.209.174.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 18:03:58 -0700
Subject: Re: [Patch V2 12/13] irqchip: Add IMS (Interrupt Message Store)
 driver
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
 <1614370277-23235-13-git-send-email-megha.dey@intel.com>
 <87zgyrqgbm.wl-maz@kernel.org> <87eeg3vyph.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <cc98407b-877c-317b-04c6-514db2ea09a4@intel.com>
Date:   Thu, 25 Mar 2021 18:03:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87eeg3vyph.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas/Marc,

On 3/25/2021 12:07 PM, Thomas Gleixner wrote:
> On Thu, Mar 25 2021 at 17:43, Marc Zyngier wrote:
>> On Fri, 26 Feb 2021 20:11:16 +0000,
>> Megha Dey <megha.dey@intel.com> wrote:
>>> +
>>> +#include <linux/irqchip/irq-ims-msi.h>
>>> +
>>> +#ifdef CONFIG_IMS_MSI_ARRAY
>> Given that this covers the whole driver, what is this #defined used
>> for? You might as well make the driver depend on this config option.
> That's a leftover from the initial version I wrote which had also
> support for IMS_MSI_QUEUE to store the message in queue memory, but we
> have no use case yet for it.
>
> But yes, as things stand now it does not make any sense and IIRC at the
> end they do not share anything in the C file except for some includes at
> the very end.
Sure, I will make this change.
>
> Thanks,
>
>          tglx
>
>
