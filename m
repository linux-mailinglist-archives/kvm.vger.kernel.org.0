Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B156BBD88D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 08:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442391AbfIYGy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 02:54:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:14063 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436671AbfIYGy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 02:54:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 23:54:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="201155117"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 24 Sep 2019 23:54:23 -0700
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
To:     Peter Xu <peterx@redhat.com>, "Tian, Kevin" <kevin.tian@intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190923203102.GB21816@araj-mobl1.jf.intel.com>
 <9cfe6042-f0fb-ea5e-e134-f6f5bb9eb7b0@linux.intel.com>
 <20190925043050.GK28074@xz-x1>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F018@SHSMSX104.ccr.corp.intel.com>
 <20190925052402.GM28074@xz-x1>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <1713f03c-4d47-34ad-f36d-882645c36389@linux.intel.com>
Date:   Wed, 25 Sep 2019 14:52:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925052402.GM28074@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter and Kevin,

On 9/25/19 1:24 PM, Peter Xu wrote:
> On Wed, Sep 25, 2019 at 04:38:31AM +0000, Tian, Kevin wrote:
>>> From: Peter Xu [mailto:peterx@redhat.com]
>>> Sent: Wednesday, September 25, 2019 12:31 PM
>>>
>>> On Tue, Sep 24, 2019 at 09:38:53AM +0800, Lu Baolu wrote:
>>>>>> intel_mmmap_range(domain, addr, end, phys_addr, prot)
>>>>>
>>>>> Maybe think of a different name..? mmmap seems a bit weird :-)
>>>>
>>>> Yes. I don't like it either. I've thought about it and haven't
>>>> figured out a satisfied one. Do you have any suggestions?
>>>
>>> How about at least split the word using "_"?  Like "mm_map", then
>>> apply it to all the "mmm*" prefixes.  Otherwise it'll be easily
>>> misread as mmap() which is totally irrelevant to this...
>>>
>>
>> what is the point of keeping 'mm' here? replace it with 'iommu'?
> 
> I'm not sure of what Baolu thought, but to me "mm" makes sense itself
> to identify this from real IOMMU page tables (because IIUC these will
> be MMU page tables).  We can come up with better names, but IMHO
> "iommu" can be a bit misleading to let people refer to the 2nd level
> page table.

"mm" represents a CPU (first level) page table;

vs.

"io" represents an IOMMU (second level) page table.

Best regards,
Baolu
