Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F604BBCDB
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 22:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502632AbfIWUbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 16:31:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:30585 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502627AbfIWUbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 16:31:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 13:31:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="363749806"
Received: from araj-mobl1.jf.intel.com ([10.24.10.67])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2019 13:31:02 -0700
Date:   Mon, 23 Sep 2019 13:31:02 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        sanjay.k.kumar@intel.com, jacob.jun.pan@linux.intel.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yi Sun <yi.y.sun@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190923203102.GB21816@araj-mobl1.jf.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923122454.9888-3-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 08:24:52PM +0800, Lu Baolu wrote:
> This adds functions to manipulate first level page tables
> which could be used by a scalale mode capable IOMMU unit.

s/scalale/scalable

> 
> intel_mmmap_range(domain, addr, end, phys_addr, prot)

Maybe think of a different name..? mmmap seems a bit weird :-)

>  - Map an iova range of [addr, end) to the physical memory
>    started at @phys_addr with the @prot permissions.
> 
> intel_mmunmap_range(domain, addr, end)
>  - Tear down the map of an iova range [addr, end). A page
>    list will be returned which will be freed after iotlb
>    flushing.
> 
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Liu Yi L <yi.l.liu@intel.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
