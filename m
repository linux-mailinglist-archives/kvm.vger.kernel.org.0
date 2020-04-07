Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0101A05DD
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 06:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgDGEmI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 Apr 2020 00:42:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:17836 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgDGEmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 00:42:08 -0400
IronPort-SDR: hUa8O12FfDkETebE29P0A0Lp6Dk8cIsy5l7z3Szq9FB/rg42W0SUvP2TCiAtw41m5d8viJb4GG
 ra+cDHT9pkow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 21:42:08 -0700
IronPort-SDR: 4wrchvln1lQFNDC1/x6Jh7XDy16JIOWo1Y1Q8iiWViMp1DfJ4gs5bM6IOxf6z16mrLg5Es3a11
 hEVmoXmvDIaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,353,1580803200"; 
   d="scan'208";a="248295728"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga008.jf.intel.com with ESMTP; 06 Apr 2020 21:42:07 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 21:42:06 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 6 Apr 2020 21:42:06 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 6 Apr 2020 21:42:06 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Tue, 7 Apr 2020 12:42:03 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHWAEUbvuzF5+3jpEaYhihTFzMRG6hlp7CAgAFQhyCAABZAAIAGGnZw
Date:   Tue, 7 Apr 2020 04:42:02 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D80E1AD@SHSMSX104.ccr.corp.intel.com>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
        <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
        <20200402115017.0a0f55e2@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D807BB9@SHSMSX104.ccr.corp.intel.com>
 <20200403091424.39383958@w520.home>
In-Reply-To: <20200403091424.39383958@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson
> Sent: Friday, April 3, 2020 11:14 PM
> 
> On Fri, 3 Apr 2020 05:58:55 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, April 3, 2020 1:50 AM
> > >
> > > On Sun, 22 Mar 2020 05:31:58 -0700
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > From: Liu Yi L <yi.l.liu@intel.com>
> > > >
> > > > For a long time, devices have only one DMA address space from
> platform
> > > > IOMMU's point of view. This is true for both bare metal and directed-
> > > > access in virtualization environment. Reason is the source ID of DMA in
> > > > PCIe are BDF (bus/dev/fnc ID), which results in only device granularity
> > > > DMA isolation. However, this is changing with the latest advancement in
> > > > I/O technology area. More and more platform vendors are utilizing the
> > > PCIe
> > > > PASID TLP prefix in DMA requests, thus to give devices with multiple
> DMA
> > > > address spaces as identified by their individual PASIDs. For example,
> > > > Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> > > > let device access multiple process virtual address space by binding the
> > > > virtual address space with a PASID. Wherein the PASID is allocated in
> > > > software and programmed to device per device specific manner.
> Devices
> > > > which support PASID capability are called PASID-capable devices. If such
> > > > devices are passed through to VMs, guest software are also able to bind
> > > > guest process virtual address space on such devices. Therefore, the
> guest
> > > > software could reuse the bare metal software programming model,
> which
> > > > means guest software will also allocate PASID and program it to device
> > > > directly. This is a dangerous situation since it has potential PASID
> > > > conflicts and unauthorized address space access. It would be safer to
> > > > let host intercept in the guest software's PASID allocation. Thus PASID
> > > > are managed system-wide.
> > >
> > > Providing an allocation interface only allows for collaborative usage
> > > of PASIDs though.  Do we have any ability to enforce PASID usage or can
> > > a user spoof other PASIDs on the same BDF?
> >
> > An user can access only PASIDs allocated to itself, i.e. the specific IOASID
> > set tied to its mm_struct.
> 
> A user is only _supposed_ to access PASIDs allocated to itself.  AIUI
> the mm_struct is used for managing the pool of IOASIDs from which the
> user may allocate that PASID.  We also state that programming the PASID
> into the device is device specific.  Therefore, are we simply trusting
> the user to use a PASID that's been allocated to them when they program
> the device?  If a user can program an arbitrary PASID into the device,
> then what prevents them from attempting to access data from another
> user via the device?   I think I've asked this question before, so if
> there's a previous explanation or spec section I need to review, please
> point me to it.  Thanks,
> 

There are two scenarios:

(1) for PF/VF, the iommu driver maintains an individual PASID table per
PDF. Although the PASID namespace is global, the per-BDF PASID table
contains only valid entries for those PASIDs which are allocated to the
mm_struct. The user is free to program arbitrary PASID into the assigned
device, but using invalid PASIDs simply hit iommu fault.

(2) for mdev, multiple mdev instances share the same PASID table of
the parent BDF. However, PASID programming is a privileged operation
in multiplexing usage, thus must be mediated by mdev device driver. 
The mediation logic will guarantee that only allocated PASIDs are 
forwarded to the device. 

Thanks
Kevin
