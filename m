Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E627F26CD12
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgIPUxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:53:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:13136 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgIPQyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 12:54:12 -0400
IronPort-SDR: 8HqMQoiHwnKsKVk9c9Qg+y9Ko7Kywo5jJOh+sNapwxQ5KFCVV3CYlTbb8bjdm3+ZBDvHTF39Ps
 2r6eiYq8dozQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="156898385"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="156898385"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:33:47 -0700
IronPort-SDR: JwVurvYhdZ9tRNeyZ2bbSVR/msRNcTlCZbI75pYea8hcHpWEOxy1xzYyq7jZQ44LRp/Ad7T+y3
 RKc/qzoQ1Cbg==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="307104962"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 09:33:45 -0700
Date:   Wed, 16 Sep 2020 09:33:43 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        jacob.jun.pan@linux.intel.com, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916163343.GA76252@otc-nc-03>
References: <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03>
 <20200915113341.GW904879@nvidia.com>
 <20200915181154.GA70770@otc-nc-03>
 <20200915184510.GB1573713@nvidia.com>
 <20200915150851.76436ca1@jacob-builder>
 <20200915235126.GK1573713@nvidia.com>
 <20200915171319.00003f59@linux.intel.com>
 <20200916150754.GE6199@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916150754.GE6199@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 12:07:54PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun) wrote:
> > > If user space wants to bind page tables, create the PASID with
> > > /dev/sva, use ioctls there to setup the page table the way it wants,
> > > then pass the now configured PASID to a driver that can use it. 
> > 
> > Are we talking about bare metal SVA? 
> 
> What a weird term.

Glad you noticed it at v7 :-) 

Any suggestions on something less weird than 
Shared Virtual Addressing? There is a reason why we moved from SVM to SVA.
> 
> > If so, I don't see the need for userspace to know there is a
> > PASID. All user space need is that my current mm is bound to a
> > device by the driver. So it can be a one-step process for user
> > instead of two.
> 
> You've missed the entire point of the conversation, VDPA already needs
> more than "my current mm is bound to a device"

You mean current version of vDPA? or a potential future version of vDPA?

Cheers,
Ashok
