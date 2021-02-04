Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FA930F3CE
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 14:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhBDNYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 08:24:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:26482 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235605AbhBDNYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 08:24:42 -0500
IronPort-SDR: oKV57lPw9LVzUIMZmYRJb2PPmHx4fbj0pAPcLSd7U3E2SgvZxPcoG05Bu0+okrPHkL2CLvpXKx
 cU9/l3HH0OSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="178673518"
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="178673518"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 05:22:56 -0800
IronPort-SDR: a47xo9b31R3FLVNucSjlh/sN3LbSlBGDYTa8LHuvBSCf/agDgcXtOXZMHKsoMb7MtFaZRahtAE
 QjA42NzipnGQ==
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="393165401"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.214.206]) ([10.254.214.206])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 05:22:50 -0800
Cc:     baolu.lu@linux.intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com, bhelgaas@google.com, maz@kernel.org,
        linux-pci@vger.kernel.org, ravi.v.shankar@intel.com,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 11/12] platform-msi: Add platform check for subdevice irq
 domain
To:     Jason Gunthorpe <jgg@nvidia.com>, Megha Dey <megha.dey@intel.com>
References: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
 <1612385805-3412-12-git-send-email-megha.dey@intel.com>
 <20210204121431.GH4247@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <3082871a-32d7-8472-bd66-eae535ef2c3e@linux.intel.com>
Date:   Thu, 4 Feb 2021 21:22:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204121431.GH4247@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2021/2/4 20:14, Jason Gunthorpe wrote:
> On Wed, Feb 03, 2021 at 12:56:44PM -0800, Megha Dey wrote:
>> +bool arch_support_pci_device_ims(struct pci_dev *pdev)
>> +{
> 
> Consistent language please, we are not using IMS elsewhere, this
> feature is called device_msi in Linux.
> 

Thanks for pointing this out. I will correct it.

> Jason
> 

Best regards,
baolu
