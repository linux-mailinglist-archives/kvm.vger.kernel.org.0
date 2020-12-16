Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFEE2DB8A2
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 02:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgLPBwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 20:52:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:46392 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgLPBwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 20:52:30 -0500
IronPort-SDR: Y21oJmEbqOJ70vq64bxOixpSPmPNQ64pEtyh51H2oPrFeQWmYQeIGc3CFkjGLx5PD+c0h6MpbQ
 8d2HXbxv/QmQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="172415251"
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="172415251"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 17:50:37 -0800
IronPort-SDR: cFGv00aXiJSneHIaymsNL0HdVpZyc+g3cbTyNfrD6C6N2Sh644XRJhR7zb7s0lqwLZmcoDLNag
 O2C504HU8Vzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="384063655"
Received: from allen-box.sh.intel.com (HELO [10.239.159.28]) ([10.239.159.28])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2020 17:50:30 -0800
Cc:     baolu.lu@linux.intel.com, alex.williamson@redhat.com,
        bhelgaas@google.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, jing.lin@intel.com,
        kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 1/1] platform-msi: Add platform check for subdevice
 irq domain
To:     David Woodhouse <dwmw2@infradead.org>, tglx@linutronix.de,
        ashok.raj@intel.com, kevin.tian@intel.com, dave.jiang@intel.com,
        megha.dey@intel.com
References: <20201210004624.345282-1-baolu.lu@linux.intel.com>
 <dad0bf6e271532badd84f2a811449be566f537a9.camel@infradead.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <7729a278-1734-5f3e-6183-50670ddb8820@linux.intel.com>
Date:   Wed, 16 Dec 2020 09:42:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dad0bf6e271532badd84f2a811449be566f537a9.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 12/10/20 4:22 PM, David Woodhouse wrote:
> On Thu, 2020-12-10 at 08:46 +0800, Lu Baolu wrote:
>> +/*
>> + * We want to figure out which context we are running in. But the hardware
>> + * does not introduce a reliable way (instruction, CPUID leaf, MSR, whatever)
>> + * which can be manipulated by the VMM to let the OS figure out where it runs.
>> + * So we go with the below probably_on_bare_metal() function as a replacement
>> + * for definitely_on_bare_metal() to go forward only for the very simple reason
>> + * that this is the only option we have.
>> + */
>> +static const char * const possible_vmm_vendor_name[] = {
>> +       "QEMU", "Bochs", "KVM", "Xen", "VMware", "VMW", "VMware Inc.",
>> +       "innotek GmbH", "Oracle Corporation", "Parallels", "BHYVE",
>> +       "Microsoft Corporation"
>> +};
> 
> People do use SeaBIOS ("Bochs") on bare metal.

Is there any unique way to distinguish between running on bare metal and
VM?

> 
> You'll also see "Amazon EC2" on virt instances as well as bare metal
> instances. Although in that case I believe the virt instances do have
> the 'virtual machine' flag set in bit 4 of the BIOS Characteristics
> Extension Byte 2, and the bare metal obviously don't.
> 

So for Amazon EC2 case, we can use this byte to distinguish. Can you
please point me to the references of this Extension Byte (reference
code/spec or anything else) ?

Best regards,
baolu
