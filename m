Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C47116C84
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 12:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfLILt0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Dec 2019 06:49:26 -0500
Received: from mga04.intel.com ([192.55.52.120]:9885 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbfLILt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 06:49:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 03:49:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="215071935"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2019 03:49:25 -0800
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Dec 2019 03:49:24 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Dec 2019 03:49:24 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.109]) with mapi id 14.03.0439.000;
 Mon, 9 Dec 2019 19:49:22 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 00/10] vfio_pci: wrap pci device as a mediated device
Thread-Topic: [PATCH v3 00/10] vfio_pci: wrap pci device as a mediated device
Thread-Index: AQHVoSnnPAUPlFDoLUWP4k6NXkkQUaexRcCQ
Date:   Mon, 9 Dec 2019 11:49:21 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A12A846@SHSMSX104.ccr.corp.intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDZhNTkzNmQtYTM3Ni00M2MwLWI2OTAtOTI5MTIwMTEzY2Y2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiK01hV0F5Qm1wenE0YTNuNno2YWVDNGtoUmNid3JOZ2hmU3hJU1lNN0hhaVwvcVwvRzdVT0t1RWs2MnVZVjV6RFdTIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Any comments on this version? If any, please feel free let me know.

Regards,
Yi Liu

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 21, 2019 7:24 PM
> To: alex.williamson@redhat.com; kwankhede@nvidia.com
> Subject: [PATCH v3 00/10] vfio_pci: wrap pci device as a mediated device
> 
> This patchset aims to add a vfio-pci-like meta driver as a demo
> user of the vfio changes introduced in "vfio/mdev: IOMMU aware
> mediated device" patchset from Baolu Lu. Besides the test purpose,
> per Alex's comments, it could also be a good base driver for
> experimenting with device specific mdev migration.
> 
> Specific interface tested in this proposal:
>  *) int mdev_set_iommu_device(struct device *dev,
>  				struct device *iommu_device)
>     introduced in the patch as below:
>     "[PATCH v5 6/8] vfio/mdev: Add iommu related member in mdev_device"
> 
> Patch Overview:
>  *) patch 1 ~ 7: code refactor for existing vfio-pci module
>                  move the common codes from vfio_pci.c to
>                  vfio_pci_common.c
>  *) patch 8: add protection to perm_bits alloc/free
>  *) patch 9: add vfio-mdev-pci sample driver
>  *) patch 10: refine the sample driver
> 
> Links:
>  *) Link of "vfio/mdev: IOMMU aware mediated device"
>          https://lwn.net/Articles/780522/
>  *) Previous versions:
>          Patch v2: https://lkml.org/lkml/2019/9/6/115
>          Patch v1: https://www.spinics.net/lists/kvm/msg188952.html
>          RFC v3: https://lkml.org/lkml/2019/4/24/495
>          RFC v2: https://lkml.org/lkml/2019/3/13/113
>          RFC v1: https://lkml.org/lkml/2019/3/4/529
>  *) may try it with the codes in below repo
>     https://github.com/luxis1999/vfio-mdev-pci-sample-driver.git : v5.4-rc7-pci-mdev
> 
> Please feel free give your comments.
> 
> Thanks,
> Yi Liu
> 
> Change log:
>   patch v2 -> patch v3:
>   - refresh the disable_idle_d3, disable_vga and nointxmask config
>     according to user config in device open.
>   - add a semaphore around the vfio-pci cap/ecap perm bits allocation/free
>   - drop the non-singleton iommu group support to keep it simple as it's
>     a sample driver for now.
> 
>   patch v1 -> patch v2:
>   - the sample driver implementation refined
>   - the sample driver can work on non-singleton iommu groups
>   - the sample driver can work with vfio-pci, devices from a non-singleton
>     group can either be bound to vfio-mdev-pci or vfio-pci, and the
>     assignment of this group still follows current vfio assignment rule.
> 
>   RFC v3 -> patch v1:
>   - split the patchset from 3 patches to 9 patches to better demonstrate
>     the changes step by step
> 
>   rfc v2->v3:
>   - use vfio-mdev-pci instead of vfio-pci-mdev
>   - place the new driver under drivers/vfio/pci while define
>     Kconfig in samples/Kconfig to clarify it is a sample driver
> 
>   rfc v1->v2:
>   - instead of adding kernel option to existing vfio-pci
>     module in v1, v2 follows Alex's suggestion to add a
>     separate vfio-pci-mdev module.
>   - new patchset subject: "vfio/pci: wrap pci device as a mediated device"
> 
> 
> Alex Williamson (1):
>   samples: refine vfio-mdev-pci driver
> 
> Liu Yi L (9):
>   vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header
>   vfio_pci: refine user config reference in vfio-pci module
>   vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
>   vfio_pci: make common functions be extern
>   vfio_pci: duplicate vfio_pci.c
>   vfio_pci: shrink vfio_pci_common.c
>   vfio_pci: shrink vfio_pci.c
>   vfio/pci: protect cap/ecap_perm bits alloc/free
>   samples: add vfio-mdev-pci driver
> 
>  drivers/vfio/pci/Makefile           |    9 +-
>  drivers/vfio/pci/vfio_mdev_pci.c    |  430 ++++++++++
>  drivers/vfio/pci/vfio_pci.c         | 1460 +---------------------------------
>  drivers/vfio/pci/vfio_pci_common.c  | 1471
> +++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_config.c  |   33 +-
>  drivers/vfio/pci/vfio_pci_private.h |   39 +
>  samples/Kconfig                     |   11 +
>  7 files changed, 2000 insertions(+), 1453 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_mdev_pci.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_common.c
> 
> --
> 2.7.4

