Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811D71221CD
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLQCEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:04:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:26146 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfLQCEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:04:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 18:04:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="227326453"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 16 Dec 2019 18:04:32 -0800
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over
 first level
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-5-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A1309A9@SHSMSX104.ccr.corp.intel.com>
 <acb93807-7a78-b81a-3b27-fde9ee4d7edb@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C9A@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b883602c-ecdf-11ea-c26c-4b221bf7634d@linux.intel.com>
Date:   Tue, 17 Dec 2019 10:03:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A132C9A@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 12/15/19 5:37 PM, Liu, Yi L wrote:
>> XD (bit 63) is only for the first level, and SNP (bit 11) is only for second level, right? I
>> think we need to always set XD bit for IOVA over FL case. thoughts?
> Oops, I made a mistake here. Please forget SNP bit, there is no way to control SNP
> with first level page table.:-)
> 
> Actually, it is execute (bit 1) of second level page table which I wanted to say.
> If software sets R/W/X permission to an IOVA, with IOVA over second level
> page table, it will set bit 1. However, if IOVA is over first level page table, it
> may need to clear XD bit. This is what I want to say here. If IOVA doesn’t allow
> execute permission, it's ok to always set XD bit for IOVA over FL case. But I
> would like to do it just as what we did for R/W permission. R/W permission
> relies on the permission configured by the page map caller. right?

Got your point.

Current driver always cleard X (bit 2) in the second level page table.
So we will always set XD bit (bit 63) in the first level page table.
If we decide to use the X permission, we need a separated patch, right?

Best regards,
baolu
