Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D2E156355
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 08:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgBHHqd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 8 Feb 2020 02:46:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:60934 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgBHHqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Feb 2020 02:46:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 23:46:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,416,1574150400"; 
   d="scan'208";a="431096976"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2020 23:46:31 -0800
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 23:46:31 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 7 Feb 2020 23:46:31 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.98]) with mapi id 14.03.0439.000;
 Sat, 8 Feb 2020 15:46:29 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v1 0/2] vfio/pci: expose device's PASID capability to VMs
Thread-Topic: [RFC v1 0/2] vfio/pci: expose device's PASID capability to VMs
Thread-Index: AQHV1p2L6Ox9Ls63fUG3sLdpayIPaagQ+k+g
Date:   Sat, 8 Feb 2020 07:46:28 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1B57BC@SHSMSX104.ccr.corp.intel.com>
References: <1580300325-86259-1-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1580300325-86259-1-git-send-email-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjExNjc0ZWMtMWU1NS00YTIyLTgwMTMtODkwYWExMjBhODg0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRUtqNWlmRmZBa1VrZFVtS2x3emNaRUJLYjd2azQ2U0NjRm5sdVMwY0xuQjkwUkZRV0Jxa0lJTlV4d25TZ1R6SyJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Any comment on this series?

Regards,
Yi Liu

> From: Liu, Yi L
> Sent: Wednesday, January 29, 2020 8:19 PM
> To: alex.williamson@redhat.com; eric.auger@redhat.com
> Subject: [RFC v1 0/2] vfio/pci: expose device's PASID capability to VMs
> 
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on Intel
> platforms allows address space sharing between device DMA and applications. SVA
> can reduce programming complexity and enhance security.
> 
> To enable SVA, device needs to have PASID capability, which is a key capability for
> SVA. This patchset exposes the device's PASID capability to guest instead of hiding it
> from guest.
> 
> The second patch emulates PASID capability for VFs (Virtual Function) since VFs don't
> implement such capability per PCIe spec. This patch emulates such capability and
> expose to VM if the capability is enabled in PF (Physical Function).
> 
> However, there is an open for PASID emulation. If PF driver disables PASID capability
> at runtime, then it may be an issue. e.g. PF should not disable PASID capability if
> there is guest using this capability on any VF related to this PF. To solve it, may need
> to introduce a generic communication framework between vfio-pci driver and PF
> drivers. Please feel free to give your suggestions on it.
> 
> Liu Yi L (2):
>   vfio/pci: Expose PCIe PASID capability to guest
>   vfio/pci: Emulate PASID/PRI capability for VFs
> 
>  drivers/vfio/pci/vfio_pci_config.c | 321
> ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 318 insertions(+), 3 deletions(-)
> 
> --
> 2.7.4

