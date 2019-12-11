Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B811A0EC
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 02:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfLKB5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 20:57:41 -0500
Received: from mga04.intel.com ([192.55.52.120]:51942 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfLKB5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 20:57:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 17:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="225349071"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 10 Dec 2019 17:57:37 -0800
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
Message-ID: <8fd5d2fe-51c7-3ee7-fcda-625082e23040@linux.intel.com>
Date:   Wed, 11 Dec 2019 09:56:53 +0800
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

Hi Jacob,

On 12/3/19 7:27 AM, Jacob Pan wrote:
> On Thu, 28 Nov 2019 10:25:47 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> This adds functions to manipulate first level page tables
>> which could be used by a scalale mode capable IOMMU unit.
>>
> FL and SL page tables are very similar, and I presume we are not using
> all the flag bits in FL paging structures for DMA mapping. Are there
> enough relevant differences to warrant a new set of helper functions
> for FL? Or we can merge into one.

I evaluated your suggestion these days. It turned out that your
suggestion make code simpler and easier for maintainence. Thank you for
the comment and I will send out a new version for review soon.

Best regards,
baolu
