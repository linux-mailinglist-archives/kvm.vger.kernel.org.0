Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B5FBD67D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 04:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633758AbfIYCue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 22:50:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:25296 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404590AbfIYCud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 22:50:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 19:50:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,546,1559545200"; 
   d="scan'208";a="201100050"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 24 Sep 2019 19:50:29 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
Date:   Wed, 25 Sep 2019 10:48:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 9/24/19 3:00 PM, Tian, Kevin wrote:
>>>>       '-----------'
>>>>       '-----------'
>>>>
>>>> This patch series only aims to achieve the first goal, a.k.a using
> first goal? then what are other goals? I didn't spot such information.
> 

The overall goal is to use IOMMU nested mode to avoid shadow page table
and VMEXIT when map an gIOVA. This includes below 4 steps (maybe not
accurate, but you could get the point.)

1) GIOVA mappings over 1st-level page table;
2) binding vIOMMU 1st level page table to the pIOMMU;
3) using pIOMMU second level for GPA->HPA translation;
4) enable nested (a.k.a. dual stage) translation in host.

This patch set aims to achieve 1).

> Also earlier you mentioned the new approach (nested) is more secure
> than shadowing. why?
> 

My bad! After reconsideration, I realized that it's not "more secure".

Thanks for pointing this out.

Best regards,
Baolu
