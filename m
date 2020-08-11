Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DFF241FE5
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 20:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHKSqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 14:46:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:5951 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgHKSqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 14:46:15 -0400
IronPort-SDR: LSPeF3B+LX4vl1lWNcYbpxjiqfmUgbs8wZ3K+hnR5DBfFwT8i0THNRsVvdfyKuZ7cTnccptevQ
 i0BGJ/a6AXXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="151236838"
X-IronPort-AV: E=Sophos;i="5.76,301,1592895600"; 
   d="scan'208";a="151236838"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 11:46:13 -0700
IronPort-SDR: 5aAcR8S72zxamrk1GkqcpkTcLHD6X+V0Qd8VhcPMwxe6NQm/ajJO1T7QBs6tN6/S8h9BEKMK9n
 htpZpANtoRxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,301,1592895600"; 
   d="scan'208";a="294806955"
Received: from orsmsx602-2.jf.intel.com (HELO ORSMSX602.amr.corp.intel.com) ([10.22.229.82])
  by orsmga006.jf.intel.com with ESMTP; 11 Aug 2020 11:46:13 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 11:46:13 -0700
Received: from orsmsx101.amr.corp.intel.com (10.22.225.128) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 11:46:13 -0700
Received: from [10.212.86.9] (10.212.86.9) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 11 Aug
 2020 11:46:12 -0700
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
References: <87h7tcgbs2.fsf@nanos.tec.linutronix.de> <87ft8uxjga.fsf@nanos>
 <87d03x5x0k.fsf@nanos.tec.linutronix.de>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <8a8a853c-cbe6-b19c-f6ba-c8cdeda84a36@intel.com>
Date:   Tue, 11 Aug 2020 11:46:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87d03x5x0k.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.212.86.9]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

On 8/11/2020 2:53 AM, Thomas Gleixner wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>
> CC+: XEN folks
>
>> Thomas Gleixner <tglx@linutronix.de> writes:
>>> The infrastructure itself is not more than a thin wrapper around the
>>> existing msi domain infrastructure and might even share code with
>>> platform-msi.
>> And the annoying fact that you need XEN support which opens another can
>> of worms...

hmm I am not sure why we need Xen support... are you referring to idxd 
using xen?

> which needs some real cleanup first.
>
> x86 still does not associate the irq domain to devices at device
> discovery time, i.e. the device::msi_domain pointer is never populated.
>
> So to support this new fangled device MSI stuff we'd need yet more
> x86/xen specific arch_*msi_irqs() indirection and hackery, which is not
> going to happen.
>
> The right thing to do is to convert XEN MSI support over to proper irq
> domains. This allows to populate device::msi_domain which makes a lot of
> things simpler and also more consistent.

do you think this cleanup is to be a precursor to my patches? I could 
look into it but I am not familiar with the background of Xen

and this stuff. Can you please provide further guidance on where to look?

> Thanks,
>
>          tglx
