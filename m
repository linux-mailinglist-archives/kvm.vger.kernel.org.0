Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6F71286B7
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 04:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLUDOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 22:14:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:11326 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLUDOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 22:14:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 19:14:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,338,1571727600"; 
   d="scan'208";a="222611031"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.239.195.247]) ([10.239.195.247])
  by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2019 19:14:35 -0800
Subject: Re: [PATCH v4 0/7] Use 1st-level for IOVA translation
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A13A364@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <434d7478-1ed3-1962-ff9d-1b37d0c44b9c@linux.intel.com>
Date:   Sat, 21 Dec 2019 11:14:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A13A364@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi again,

On 2019/12/20 19:50, Liu, Yi L wrote:
> 3) Per VT-d spec, FLPT has canonical requirement to the input
> addresses. So I'd suggest to add some enhance regards to it.
> Please refer to chapter 3.6:-).
> 
> 3.6 First-Level Translation
> First-level translation restricts the input-address to a canonical address (i.e., address bits 63:N have
> the same value as address bit [N-1], where N is 48-bits with 4-level paging and 57-bits with 5-level
> paging). Requests subject to first-level translation by remapping hardware are subject to canonical
> address checking as a pre-condition for first-level translation, and a violation is treated as a
> translation-fault.

It seems to be a conflict at bit 63. It should be the same as bit[N-1]
according to the canonical address requirement; but it is also used as
the XD control. Any thought?

Best regards,
baolu
