Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A941417F8
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 15:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgAROXu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 18 Jan 2020 09:23:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:65194 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgAROXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 09:23:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 06:23:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,334,1574150400"; 
   d="scan'208";a="219207823"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 18 Jan 2020 06:23:48 -0800
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 18 Jan 2020 06:23:48 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 18 Jan 2020 06:23:47 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.202]) with mapi id 14.03.0439.000;
 Sat, 18 Jan 2020 22:23:46 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: RE: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Thread-Topic: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
Thread-Index: AQHVxVUACBwDAx59j0yR27cHCInk46frLluAgAIeFUD//8rdgIADcc5w
Date:   Sat, 18 Jan 2020 14:23:45 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A18878E@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-12-git-send-email-yi.l.liu@intel.com>
        <20200115133027.228452fd.cohuck@redhat.com>
        <A2975661238FB949B60364EF0F2C25743A184041@SHSMSX104.ccr.corp.intel.com>
 <20200116184027.2954c3f5.cohuck@redhat.com>
In-Reply-To: <20200116184027.2954c3f5.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODBhMTNiNTctNmQ0Ny00NzMyLTlkOWItZDAxYjE1M2NhNzgwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOHhteGJnb25Ub1FFbTZyU29hVllzQThESTdGVXcxMUZaYlY3M0V4bWJ6SHI1TU1XMGxcL1pJd0hWdUphWDN3Q04ifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Cornelia Huck [mailto:cohuck@redhat.com]
> Sent: Friday, January 17, 2020 1:40 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> 
> On Thu, 16 Jan 2020 13:23:28 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Cornelia Huck [mailto:cohuck@redhat.com]
> > > Sent: Wednesday, January 15, 2020 8:30 PM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v4 11/12] samples: add vfio-mdev-pci driver
> > >
> > > On Tue,  7 Jan 2020 20:01:48 +0800
> > > Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > > > diff --git a/samples/Kconfig b/samples/Kconfig index
> > > > 9d236c3..50d207c 100644
> > > > --- a/samples/Kconfig
> > > > +++ b/samples/Kconfig
> > > > @@ -190,5 +190,15 @@ config SAMPLE_INTEL_MEI
> > > >  	help
> > > >  	  Build a sample program to work with mei device.
> > > >
> > > > +config SAMPLE_VFIO_MDEV_PCI
> > > > +	tristate "Sample driver for wrapping PCI device as a mdev"
> > > > +	select VFIO_PCI_COMMON
> > > > +	select VFIO_PCI
> > >
> > > Why does this still need to select VFIO_PCI? Shouldn't all needed
> > > infrastructure rather be covered by VFIO_PCI_COMMON already?
> >
> > VFIO_PCI_COMMON is supposed to be the dependency of both VFIO_PCI and
> > SAMPLE_VFIO_MDEV_PCI. However, the source code of VFIO_PCI_COMMON are
> > under drivers/vfio/pci which is compiled per the configuration of VFIO_PCI.
> > Besides of letting SAMPLE_VFIO_MDEV_PCI select VFIO_PCI, I can also
> > add a line in drivers/vfio/Makefile to make the source code under
> > drivers/vfio/pci to be compiled when either VFIO_PCI or
> > VFIO_PCI_COMMON are configed. But I'm afraid it is a bit ugly. So I
> > choose to let SAMPLE_VFIO_MDEV_PCI select VFIO_PCI. If you have other
> > idea, I would be pleased to know it. :-)
> 
> Shouldn't building drivers/vfio/pci/ for CONFIG_VFIO_PCI_COMMON already be
> enough (the Makefile changes look fine to me)? Or am I missing something obvious?

The problem is in the drivers/vfio/Makefile. If CONFIG_VFIO_PCI is not
selected then the pci/ directory is not compiled. Even CONFIG_VFIO_PCI=M,
it will throw error if SAMPLE_VFIO_MDEV_PCI=y. So I let SAMPLE_VFIO_MDEV_PCI
select CONFIG_VFIO_PCI all the same. I'm not sure if this is good. Or maybe
there is better way to ensure pci/ is compiled.

# SPDX-License-Identifier: GPL-2.0
vfio_virqfd-y := virqfd.o

obj-$(CONFIG_VFIO) += vfio.o
obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
obj-$(CONFIG_VFIO_PCI) += pci/
obj-$(CONFIG_VFIO_PLATFORM) += platform/
obj-$(CONFIG_VFIO_MDEV) += mdev/

Thanks,
Yi Liu

