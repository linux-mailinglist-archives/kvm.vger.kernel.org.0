Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB139BF44
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhFDSEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 14:04:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:34015 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230254AbhFDSEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 14:04:53 -0400
IronPort-SDR: JUBX1t0ImtMmd05/sxkSjR7aBdOVVZz855pq8Dw/hLZJhCcjDIENNPkZJkQeI1hU8e6L/l24pc
 nj0rAlJ/ogeA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="191450655"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="191450655"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 11:03:06 -0700
IronPort-SDR: BdAVPp7uqcrplg6o63MK5a9r3KtzhxadSqzeiSmXahtASlrILQNHhYH7dc8lWoYEFI10n+IoI8
 cbpPKxXHH9zg==
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="439267249"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 11:03:06 -0700
Date:   Fri, 4 Jun 2021 11:05:44 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604110544.31e6d255@jacob-builder>
In-Reply-To: <20210604162200.GA415775@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
        <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
        <ed4f6e57-4847-3ed2-75de-cea80b2fbdb8@huawei.com>
        <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
        <20210601173323.GN1002214@nvidia.com>
        <23a482f9-b88a-da98-3800-f3fd9ea85fbd@huawei.com>
        <20210603111914.653c4f61@jacob-builder>
        <1175ebd5-9d8e-2000-6d05-baa93e960915@redhat.com>
        <20210604092243.245bd0f4@jacob-builder>
        <20210604162200.GA415775@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Fri, 4 Jun 2021 13:22:00 -0300, Jason Gunthorpe <jgg@nvidia.com> wrote:

> > 
> > Yes, in that case we should support both. Give the device driver a
> > chance to handle the IOPF if it can.  
> 
> Huh?
> 
> The device driver does not "handle the IOPF" the device driver might
> inject the IOPF.
You are right, I got confused with the native case where device drivers can
handle the fault, or do something about it.

Thanks,

Jacob
