Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662B2396A98
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 03:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhFAB2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 21:28:06 -0400
Received: from mga06.intel.com ([134.134.136.31]:46622 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhFAB2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 21:28:06 -0400
IronPort-SDR: lpTGoGBVGUM9poQk/cmuUYvIPSkoOzSNOgNxF5Xfn6d848uOCw/HgGJVcq8BnRxqas6yddK+Vw
 jn/UbTTEYtHg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="264636450"
X-IronPort-AV: E=Sophos;i="5.83,238,1616482800"; 
   d="scan'208";a="264636450"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 18:26:23 -0700
IronPort-SDR: 3ISgzlIM9qswXjZQDHBeANiitu0fX8s7d+7JTlBEqDv2NaJfFaUxOX4F6EkXR8+6aF44ke+Lvp
 1iqskwpkwaAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,238,1616482800"; 
   d="scan'208";a="632703400"
Received: from allen-box.sh.intel.com (HELO [10.239.159.105]) ([10.239.159.105])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2021 18:26:19 -0700
Cc:     baolu.lu@linux.intel.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Liu Yi L <yi.l.liu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com> <20210531193157.5494e6c6@yiliu-dev>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <576ab03b-3f2b-512f-7c29-f489ed9576f6@linux.intel.com>
Date:   Tue, 1 Jun 2021 09:25:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210531193157.5494e6c6@yiliu-dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/21 7:31 PM, Liu Yi L wrote:
> On Fri, 28 May 2021 20:36:49 -0300, Jason Gunthorpe wrote:
> 
>> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
>>
>>> 2.1. /dev/ioasid uAPI
>>> +++++++++++++++++

[---cut for short---]

>>> /*
>>>    * Allocate an IOASID.
>>>    *
>>>    * IOASID is the FD-local software handle representing an I/O address
>>>    * space. Each IOASID is associated with a single I/O page table. User
>>>    * must call this ioctl to get an IOASID for every I/O address space that is
>>>    * intended to be enabled in the IOMMU.
>>>    *
>>>    * A newly-created IOASID doesn't accept any command before it is
>>>    * attached to a device. Once attached, an empty I/O page table is
>>>    * bound with the IOMMU then the user could use either DMA mapping
>>>    * or pgtable binding commands to manage this I/O page table.
>> Can the IOASID can be populated before being attached?
> perhaps a MAP/UNMAP operation on a gpa_ioasid?
> 

But before attaching to any device, there's no connection between an
IOASID and the underlying IOMMU. How do you know the supported page
sizes and cache coherency?

The restriction of iommu_group is implicitly expressed as only after all
devices belonging to an iommu_group are attached, the operations of the
page table can be performed.

Best regards,
baolu
