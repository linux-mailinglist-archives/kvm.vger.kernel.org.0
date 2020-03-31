Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFF11996AC
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgCaMjb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 08:39:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:34738 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730436AbgCaMjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:39:31 -0400
IronPort-SDR: HQV7RznpuKrHH4KuKcrDFjE1A3dngekuAaMMzMY18I6AnKn2g12aWbBz3+pZdwmfKUD2Ddr/2C
 yJhAHP9HDLng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 05:14:40 -0700
IronPort-SDR: c/jlAASeeo0D7kvxdr2lVtRZVL9ME7VTbiviH+twBhyeGW5bh/L6Rctv5SYK1q1Zy4PcaYbWo0
 OnwnjyEdy7Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="448652713"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2020 05:14:39 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 05:14:39 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 05:14:39 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 20:14:35 +0800
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
Subject: RE: [PATCH v2 06/22] hw/pci: introduce
 pci_device_set/unset_iommu_context()
Thread-Topic: [PATCH v2 06/22] hw/pci: introduce
 pci_device_set/unset_iommu_context()
Thread-Index: AQHWBkpmHXYvTlvRRkmnYpsj2ZFsFqhg3xyAgAG8g4A=
Date:   Tue, 31 Mar 2020 12:14:35 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21AE8C@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-7-git-send-email-yi.l.liu@intel.com>
 <01381db5-6f5f-8022-6891-e1a8dd7c3e65@redhat.com>
In-Reply-To: <01381db5-6f5f-8022-6891-e1a8dd7c3e65@redhat.com>
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

Hi Eric,

> From: Auger Eric < eric.auger@redhat.com>
> Sent: Tuesday, March 31, 2020 1:30 AM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> Subject: Re: [PATCH v2 06/22] hw/pci: introduce
> pci_device_set/unset_iommu_context()
> 
> Yi,
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > This patch adds pci_device_set/unset_iommu_context() to set/unset
> > host_iommu_context for a given device. New callback is added in
> > PCIIOMMUOps. As such, vIOMMU could make use of host IOMMU capability.
> > e.g setup nested translation.
> 
> I think you need to explain what this practically is supposed to do.
> such as: by attaching such context to a PCI device (for example VFIO
> assigned?), you tell the host that this PCIe device is protected by a FL
> stage controlled by the guest or something like that - if this is
> correct understanding (?) -

I'd like to say by attaching such context to a PCI device (for
example VFIO assigned), this PCIe device is protected by a host
IOMMU w/ nested-translation capability. Its DMA would be protected
either through the FL stage controlled by the guest together with
a SL stage page table owned by host or a single stage page table
owned by host (e.g. shadow solution). It depends on the choice of
vIOMMU the pci_device_set/unset_iommu_context() finally pass the
context to vIOMMU. If vIOMMU binds guest FL stage page table to host,
then it is prior case. If vIOMMU doesn't, do bind, then it is the
latter case.

Regards,
Yi Liu

