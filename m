Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91E210F508
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 03:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfLCCh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 21:37:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:25569 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfLCCh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 21:37:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 18:37:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,271,1571727600"; 
   d="scan'208";a="222658134"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 02 Dec 2019 18:37:24 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v2 5/8] iommu/vt-d: Add first level page table interfaces
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
 <20191128022550.9832-6-baolu.lu@linux.intel.com>
 <20191202152732.3d9c6589@jacob-builder>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <cf76308c-e021-61d1-de74-01acc657c61c@linux.intel.com>
Date:   Tue, 3 Dec 2019 10:36:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191202152732.3d9c6589@jacob-builder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/3/19 7:27 AM, Jacob Pan wrote:
> On Thu, 28 Nov 2019 10:25:47 +0800
> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> 
>> This adds functions to manipulate first level page tables
>> which could be used by a scalale mode capable IOMMU unit.
>>
> FL and SL page tables are very similar, and I presume we are not using
> all the flag bits in FL paging structures for DMA mapping. Are there
> enough relevant differences to warrant a new set of helper functions
> for FL? Or we can merge into one.
> 

I ever thought about this and I am still open for this suggestion.

We had a quick compare on these two page tables. The only concern is the
read/write/present encoding. The present bit in first level implies read
permission while second level page table explicitly has a READ bit.
(recalled from memory, correct me if it's bad. :-)).

Anyway, let's listen to more opinions.

Best regards,
baolu
