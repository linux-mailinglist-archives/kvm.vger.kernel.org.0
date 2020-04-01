Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86E419A3EF
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 05:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgDADUp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 23:20:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:5458 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731554AbgDADUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 23:20:45 -0400
IronPort-SDR: ZEba9ujtZdmRiSieUY9ygiUEc2SThuikKz4jAa7hTlQxOjQY0tU3uJodlU5S/Lv3+Ptfa0ty8W
 5D1jvnQfVe2Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 20:20:44 -0700
IronPort-SDR: DPK9gyQBnEe3V8YRFGyinPVh5PBvRNVxBeQIZ+D4NvjJv4fxznqQzxh6YPavIs5efZ9H7Ygq3b
 9kqc4lwjuDXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,330,1580803200"; 
   d="scan'208";a="450387728"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga006.fm.intel.com with ESMTP; 31 Mar 2020 20:20:44 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 20:20:44 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 31 Mar 2020 20:20:44 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 31 Mar 2020 20:20:44 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Wed, 1 Apr 2020 11:20:40 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v2 10/22] vfio/pci: set host iommu context to vIOMMU
Thread-Topic: [PATCH v2 10/22] vfio/pci: set host iommu context to vIOMMU
Thread-Index: AQHWBkpjlWASVTcKHUCJ2vYuB9rbdahiPwyAgAFDflA=
Date:   Wed, 1 Apr 2020 03:20:40 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21C0FB@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-11-git-send-email-yi.l.liu@intel.com>
 <564d1a55-04df-a3bd-5241-e30f958a4e89@redhat.com>
In-Reply-To: <564d1a55-04df-a3bd-5241-e30f958a4e89@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric，

> From: Auger Eric <eric.auger@redhat.com>
> Sent: Tuesday, March 31, 2020 10:30 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> Subject: Re: [PATCH v2 10/22] vfio/pci: set host iommu context to vIOMMU
> 
> Yi,
> 
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > For vfio-pci devices, it could use pci_device_set/unset_iommu() to
> > expose host iommu context to vIOMMU emulators. vIOMMU emulators could
> > make use the methods provided by host iommu context. e.g.
> > propagate requests to host iommu.
> I think I would squash this patch into the previous one.

sure, I can make it. :-)

> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/vfio/pci.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c index 5e75a95..c140c88
> > 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -2717,6 +2717,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
> >      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> >      VFIODevice *vbasedev_iter;
> >      VFIOGroup *group;
> > +    VFIOContainer *container;
> >      char *tmp, *subsys, group_path[PATH_MAX], *group_name;
> >      Error *err = NULL;
> >      ssize_t len;
> > @@ -3028,6 +3029,11 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
> >      vfio_register_req_notifier(vdev);
> >      vfio_setup_resetfn_quirk(vdev);
> >
> > +    container = vdev->vbasedev.group->container;
> > +    if (container->iommu_ctx.initialized) {
> Sin't it possible to dynamically allocate the iommu_ctx so that you can simply check
> container->iommu_ctx and discard the initialized field?

iommu_ctx is allocated along with container as it is not a pointer in VFIOContainer.
The only way to check it is to have flag. :-)

Regards,
Yi Liu
