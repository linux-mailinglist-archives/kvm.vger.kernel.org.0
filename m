Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D9926AB9E
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgIOSOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 14:14:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:21918 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727615AbgIOSMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 14:12:10 -0400
IronPort-SDR: rFbjTPCsgmDpmMqoMXqaHSrnrFS4xdxzQvh4YnREosiH1RrmtwCaLGE/nIlyoOw4NyFZqNkQxO
 SuuTNubS91DA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147011333"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147011333"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 11:12:04 -0700
IronPort-SDR: 2yevVxUIuGFyPzj89k9XlKLqqnFeOyatylM4vAZa8uoq5I1vHjwJQ+dbt9lOq5K3P0Qgvog9+S
 su5Dl2Zc8U9Q==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="507676675"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 11:12:02 -0700
Date:   Tue, 15 Sep 2020 11:11:54 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Jacon Jun Pan <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915181154.GA70770@otc-nc-03>
References: <20200914133113.GB1375106@myrica>
 <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03>
 <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03>
 <20200915113341.GW904879@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915113341.GW904879@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 08:33:41AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 14, 2020 at 03:44:38PM -0700, Raj, Ashok wrote:
> > Hi Jason,
> > 
> > I thought we discussed this at LPC, but still seems to be going in
> > circles :-(.
> 
> We discused mdev at LPC, not PASID.
> 
> PASID applies widely to many device and needs to be introduced with a
> wide community agreement so all scenarios will be supportable.

True, reading some of the earlier replies I was clearly confused as I
thought you were talking about mdev again. But now that you stay it, you
have moved past mdev and its the PASID interfaces correct?

> 
> > As you had suggested earlier in the mail thread could Jason Wang maybe
> > build out what it takes to have a full fledged /dev/sva interface for vDPA
> > and figure out how the interfaces should emerge? otherwise it appears
> > everyone is talking very high level and with that limited understanding of
> > how things work at the moment. 
> 
> You want Jason Wang to do the work to get Intel PASID support merged?
> Seems a bit of strange request.

I was reading mdev in my head. Not PASID, sorry.

For the native user applications have just 1 PASID per process. There is no
need for a quota management. VFIO being the one used for guest where there
is more PASID's per guest is where this is enforced today. 

IIUC, you are asking that part of the interface to move to a API interface
that potentially the new /dev/sva and VFIO could share? I think the API's
for PASID management themselves are generic (Jean's patchset + Jacob's
ioasid set management). 

Possibly what you need is already available, but not in a specific way that
you expect maybe? 

Let me check with Jacob and let him/Jean pick that up.

Cheers,
Ashok

