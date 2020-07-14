Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7221F736
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgGNQW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 12:22:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:61236 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgGNQWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 12:22:55 -0400
IronPort-SDR: +bdJ+EEC0RXOdTxFuL+XtAXPZ1heDfOzO4yefd+g2m5phmSl5Uhz8OS2wNK+fJ0od1vm2l5VRB
 Sf2/tLZ9G5Og==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="137090097"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="137090097"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 09:22:55 -0700
IronPort-SDR: XG9gv2O1W+1MwY9PC281NcQw4piXHodJVfXIVBKjQu/wCBp6LNT5cIevM+q9ASR0opidevLJZT
 uwGSUNRmtPdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="285805875"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2020 09:22:48 -0700
Date:   Tue, 14 Jul 2020 09:29:30 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group()
 APIs
Message-ID: <20200714092930.4b61b77c@jacob-builder>
In-Reply-To: <20200714082514.GA30622@infradead.org>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-5-baolu.lu@linux.intel.com>
        <20200714082514.GA30622@infradead.org>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 09:25:14 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jul 14, 2020 at 01:57:03PM +0800, Lu Baolu wrote:
> > Replace iommu_aux_at(de)tach_device() with
> > iommu_aux_at(de)tach_group(). It also saves the
> > IOMMU_DEV_FEAT_AUX-capable physcail device in the vfio_group data
> > structure so that it could be reused in other places.  
> 
> This removes the last user of iommu_aux_attach_device and
> iommu_aux_detach_device, which can be removed now.
it is still used in patch 2/4 inside iommu_aux_attach_group(), right?

> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

[Jacob Pan]
