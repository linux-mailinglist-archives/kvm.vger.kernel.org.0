Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD416128D22
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2019 08:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfLVHBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 02:01:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:45872 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfLVHBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Dec 2019 02:01:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2019 23:01:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,342,1571727600"; 
   d="scan'208";a="416946691"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga005.fm.intel.com with ESMTP; 21 Dec 2019 23:01:33 -0800
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>
Subject: Re: [PATCH v4 0/7] Use 1st-level for IOVA translation
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A13A364@SHSMSX104.ccr.corp.intel.com>
 <434d7478-1ed3-1962-ff9d-1b37d0c44b9c@linux.intel.com>
Message-ID: <46169833-6fae-d37e-89c3-c3abcdd31d79@linux.intel.com>
Date:   Sun, 22 Dec 2019 15:00:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <434d7478-1ed3-1962-ff9d-1b37d0c44b9c@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 12/21/19 11:14 AM, Lu Baolu wrote:
> Hi again,
> 
> On 2019/12/20 19:50, Liu, Yi L wrote:
>> 3) Per VT-d spec, FLPT has canonical requirement to the input
>> addresses. So I'd suggest to add some enhance regards to it.
>> Please refer to chapter 3.6:-).
>>
>> 3.6 First-Level Translation
>> First-level translation restricts the input-address to a canonical 
>> address (i.e., address bits 63:N have
>> the same value as address bit [N-1], where N is 48-bits with 4-level 
>> paging and 57-bits with 5-level
>> paging). Requests subject to first-level translation by remapping 
>> hardware are subject to canonical
>> address checking as a pre-condition for first-level translation, and a 
>> violation is treated as a
>> translation-fault.
> 
> It seems to be a conflict at bit 63. It should be the same as bit[N-1]
> according to the canonical address requirement; but it is also used as
> the XD control. Any thought?

Ignore this please. It makes no sense. :-) I confused.

Best regards,
baolu
