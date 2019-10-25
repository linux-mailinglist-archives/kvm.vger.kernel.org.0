Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3ACBE4674
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438224AbfJYI7E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 25 Oct 2019 04:59:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:17970 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407620AbfJYI7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 04:59:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 01:59:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="373495942"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga005.jf.intel.com with ESMTP; 25 Oct 2019 01:59:03 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 01:59:02 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 01:59:02 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.96]) with mapi id 14.03.0439.000;
 Fri, 25 Oct 2019 16:59:01 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>
Subject: RE: [RFC v2 0/3] vfio: support Shared Virtual Addressing
Thread-Topic: [RFC v2 0/3] vfio: support Shared Virtual Addressing
Thread-Index: AQHVimn0xqxsZsa/L0O4OV3WQFai5qdrD9Rw
Date:   Fri, 25 Oct 2019 08:59:00 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D5D0413@SHSMSX104.ccr.corp.intel.com>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2VlOTczMzktYzNmNS00NTc1LWEwNTQtZGMwYWRmMTBlZjVkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN2tlaGxSTjBZQWJ3WnNIdkZyWnNMNWxlOFc0aHo4MUdWWlhUcTNGTUpWN05rOG5nTW1XMm5RSHp3bWl0bGdpQiJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu Yi L
> Sent: Thursday, October 24, 2019 8:26 PM
> 
> Shared virtual address (SVA), a.k.a, Shared virtual memory (SVM) on Intel
> platforms allow address space sharing between device DMA and
> applications.
> SVA can reduce programming complexity and enhance security.
> This series is intended to expose SVA capability to VMs. i.e. shared guest
> application address space with passthru devices. The whole SVA
> virtualization
> requires QEMU/VFIO/IOMMU changes. This series includes the VFIO
> changes, for
> QEMU and IOMMU changes, they are in separate series (listed in the
> "Related
> series").
> 
> The high-level architecture for SVA virtualization is as below:
> 
>     .-------------.  .---------------------------.
>     |   vIOMMU    |  | Guest process CR3, FL only|
>     |             |  '---------------------------'
>     .----------------/
>     | PASID Entry |--- PASID cache flush -
>     '-------------'                       |
>     |             |                       V
>     |             |                CR3 in GPA
>     '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>       v        v                          v
> Host
>     .-------------.  .----------------------.
>     |   pIOMMU    |  | Bind FL for GVA-GPA  |
>     |             |  '----------------------'
>     .----------------/  |
>     | PASID Entry |     V (Nested xlate)
>     '----------------\.------------------------------.
>     |             |   |SL for GPA-HPA, default domain|
>     |             |   '------------------------------'
>     '-------------'
> Where:
>  - FL = First level/stage one page tables
>  - SL = Second level/stage two page tables
> 
> There are roughly three parts in this patchset which are
> corresponding to the basic vSVA support for PCI device
> assignment
>  1. vfio support for PASID allocation and free from VMs
>  2. vfio support for guest PASID binding from VMs
>  3. vfio support for IOMMU cache invalidation from VMs
> 
> The complete vSVA upstream patches are divided into three phases:
>     1. Common APIs and PCI device direct assignment
>     2. Page Request Services (PRS) support
>     3. Mediated device assignment
> 
> This RFC patchset is aiming for the phase 1, and works together with the
> VT-d driver[1] changes and QEMU changes[2]. Complete set for vSVA can
> be
> found in:
> https://github.com/jacobpan/linux.git:siov_sva.
> 
> And this patchset doesn't include the patch to expose PASID capability to
> guest. This is expected to be in another series.
> 
> Related series:
> [1] [PATCH v6 00/10] Nested Shared Virtual Address (SVA) VT-d support:
> https://lkml.org/lkml/2019/10/22/953
> <This series is based on this kernel series from Jacob Pan>
> 
> [2] [RFC v2 00/20] intel_iommu: expose Shared Virtual Addressing to VM
> from Yi Liu

there is no link, and should be [RFC v2 00/22]

> 
> Changelog:
> 	- RFC v1 -> v2:
> 	  Dropped vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE.
> 	  RFC v1: https://patchwork.kernel.org/cover/11033699/
> 
> Liu Yi L (3):
>   vfio: VFIO_IOMMU_CACHE_INVALIDATE
>   vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
>   vfio/type1: bind guest pasid (guest page tables) to host
> 
>  drivers/vfio/vfio_iommu_type1.c | 305
> ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  82 +++++++++++
>  2 files changed, 387 insertions(+)
> 
> --
> 2.7.4
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
