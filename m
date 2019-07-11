Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831AB656D5
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfGKM1a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 11 Jul 2019 08:27:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:39917 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfGKM13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 08:27:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 05:27:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,478,1557212400"; 
   d="scan'208";a="168007903"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2019 05:27:29 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 05:27:29 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jul 2019 05:27:28 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.109]) with mapi id 14.03.0439.000;
 Thu, 11 Jul 2019 20:27:26 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: RE: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Thread-Topic: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Thread-Index: AQHVHsiVLTtm/WvGlEKSmQ2lKcl2F6ajfRGAgAC0NOCAAGOFgIABGcaQgAAh3QCABKzV8IAGRYaAgAfjTqCAAB3wAIABIjgQgAHqLACACa6T4A==
Date:   Thu, 11 Jul 2019 12:27:26 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F931F8@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
        <20190620150757.7b2fa405@x1.home>
        <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
        <20190621095740.41e6e98e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F05415@SHSMSX104.ccr.corp.intel.com>
        <20190628090741.51e8d18e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1E9EC@SHSMSX104.ccr.corp.intel.com>
        <20190703112212.146ac71c@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1FF4E@SHSMSX104.ccr.corp.intel.com>
 <20190705095520.548331c2@x1.home>
In-Reply-To: <20190705095520.548331c2@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmFjNjk0YmEtNDA2Ny00MDg3LTkxM2EtOWU4YmI0NmMzMzcyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNVU5WXU3ckhvUTZNVG5kb1VTOEhLNE9pUllaUVhCUFkyQWxVVGI4WHhmR2RNaXVVOEd2M3dcL1hLVXBaaXVOQlYifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
> Of Alex Williamson
> Sent: Friday, July 5, 2019 11:55 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> 
> On Thu, 4 Jul 2019 09:11:02 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Thursday, July 4, 2019 1:22 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
[...]
> >
> > > It's really unfortunate that we don't have the mdev inheriting the
> > > iommu group of the iommu_device so that userspace can really understand
> > > this relationship.  A separate group makes sense for the aux-domain
> > > case, and is (I guess) not a significant issue in the case of a
> > > singleton iommu_device group, but it's pretty awkward here.  Perhaps
> > > this is something we should correct in design of iommu backed mdevs.
> >
> > Yeah, for aux-domain case, it is not significant issue as aux-domain essentially
> > means singleton iommu_devie group. And in early time, when designing the
> support
> > for wrap pci as a mdev, we also considered to let vfio-mdev-pci to reuse
> > iommu_device group. But this results in an iommu backed group includes mdev and
> > physical devices, which might also be strange. Do you think it is valuable to
> reconsider
> > it?
> 
> From a group perspective, the cleanest solution would seem to be that
> IOMMU backed mdevs w/o aux domain support should inherit the IOMMU
> group of the iommu_device,

A confirm here. Regards to inherit the IOMMU group of iommu_device, do
you mean mdev device should be added to the IOMMU group of iommu_device
or maintain a parent and inheritor relationship within vfio? I guess you mean the
later one? :-)

> but I think the barrier here is that we have
> a difficult time determining if the group is "viable" in that case.
> For example a group where one devices is bound to a native host driver
> and the other device bound to a vfio driver would typically be
> considered non-viable as it breaks the isolation guarantees.  However

yes, this is how vfio guarantee the isolation before allowing user to further
add a group to a vfio container and so on.

> I think in this configuration, the parent device is effectively
> participating in the isolation and "donating" its iommu group on behalf
> of the mdev device.  I don't think we can simultaneously use that iommu
> group for any other purpose. 

Agree. At least host cannot make use of the iommu group any more in such
configuration.

> I'm sure we could come up with a way for
> vifo-core to understand this relationship and add it to the white list,

The configuration is host driver still exists while we want to let mdev device
to somehow "own" the iommu backed DMA isolation capability. So one possible
way may be calling vfio_add_group_dev() which will creates a vfio_device instance
for the iommu_device in vfio.c when creating a iommu backed mdev. Then the
iommu group is fairly viable.

> I wonder though how confusing this might be to users who now understand
> the group/driver requirement to be "all endpoints bound to vfio
> drivers".  This might still be the best approach regardless of this.

Yes, another thing I'm considering is how to prevent such a host driver from
issuing DMA. If we finally get a device bound to vfio-pci and another device
wrapped as mdev and passthru them to VM, the host driver is still capable to
issue DMA. Though IOMMU can block some DMAs, but not all of them. If a
DMA issued by host driver happens to have mapping in IOMMU side, then
host is kind of doing things on behalf on VM. Though we may trust the host
driver, but it looks to be a little bit awkward to me. :-(

> Thanks,
> 
> Alex

Regards,
Yi Liu
