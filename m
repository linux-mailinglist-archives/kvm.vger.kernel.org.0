Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8527619966D
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgCaM0F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 08:26:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:2276 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbgCaM0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:26:05 -0400
IronPort-SDR: 9PiCgj++VN9JLPY92jXxbjmyL/2gKSwaVlK+lpmg2nxF7cJIVN5VDP22Nhk+BcuJg9bQFAEHLd
 1srzrx3SXUAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 05:26:04 -0700
IronPort-SDR: nnRd3nWz2wwxzw5xsvy8i6hxIiUie4b+GlxMpReJPIIc0gHBU7cpP/G6fjypOYSEKxlFYEWI9P
 aWaUZzLaz2mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="328067933"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga001.jf.intel.com with ESMTP; 31 Mar 2020 05:26:04 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 05:26:04 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 05:26:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.89]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 20:26:00 +0800
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
        Yi Sun <yi.y.sun@linux.intel.com>,
        "Richard Henderson" <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: RE: [PATCH v2 07/22] intel_iommu: add set/unset_iommu_context
 callback
Thread-Topic: [PATCH v2 07/22] intel_iommu: add set/unset_iommu_context
 callback
Thread-Index: AQHWBkpjC0u1RP4NDUSzp1PXmPweUahhD5IAgAGPy7A=
Date:   Tue, 31 Mar 2020 12:25:59 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21AF24@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-8-git-send-email-yi.l.liu@intel.com>
 <a444318b-32c7-d43c-112a-d35a870b162d@redhat.com>
In-Reply-To: <a444318b-32c7-d43c-112a-d35a870b162d@redhat.com>
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
> Sent: Tuesday, March 31, 2020 4:24 AM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> Subject: Re: [PATCH v2 07/22] intel_iommu: add set/unset_iommu_context callback
> 
> Yi,
> 
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > This patch adds set/unset_iommu_context() impelementation in Intel
> This patch implements the set/unset_iommu_context() ops for Intel vIOMMU.
> > vIOMMU. For Intel platform, pass-through modules (e.g. VFIO) could
> > set HostIOMMUContext to Intel vIOMMU emulator.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Richard Henderson <rth@twiddle.net>
> > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/i386/intel_iommu.c         | 71
> ++++++++++++++++++++++++++++++++++++++++---
> >  include/hw/i386/intel_iommu.h | 21 ++++++++++---
> >  2 files changed, 83 insertions(+), 9 deletions(-)
> >
> > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> > index 4b22910..fd349c6 100644
> > --- a/hw/i386/intel_iommu.c
> > +++ b/hw/i386/intel_iommu.c
> > @@ -3354,23 +3354,33 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
> >      },
> >  };
> >
> > -VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
> > +/**
> > + * Fetch a VTDBus instance for given PCIBus. If no existing instance,
> > + * allocate one.
> > + */
> > +static VTDBus *vtd_find_add_bus(IntelIOMMUState *s, PCIBus *bus)
> >  {
> >      uintptr_t key = (uintptr_t)bus;
> >      VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
> > -    VTDAddressSpace *vtd_dev_as;
> > -    char name[128];
> >
> >      if (!vtd_bus) {
> >          uintptr_t *new_key = g_malloc(sizeof(*new_key));
> >          *new_key = (uintptr_t)bus;
> >          /* No corresponding free() */
> > -        vtd_bus = g_malloc0(sizeof(VTDBus) + sizeof(VTDAddressSpace *) * \
> > -                            PCI_DEVFN_MAX);
> > +        vtd_bus = g_malloc0(sizeof(VTDBus));
> >          vtd_bus->bus = bus;
> >          g_hash_table_insert(s->vtd_as_by_busptr, new_key, vtd_bus);
> >      }
> > +    return vtd_bus;
> > +}
> >
> > +VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
> > +{
> > +    VTDBus *vtd_bus;
> > +    VTDAddressSpace *vtd_dev_as;
> > +    char name[128];
> > +
> > +    vtd_bus = vtd_find_add_bus(s, bus);
> >      vtd_dev_as = vtd_bus->dev_as[devfn];
> >
> >      if (!vtd_dev_as) {
> > @@ -3436,6 +3446,55 @@ VTDAddressSpace
> *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
> >      return vtd_dev_as;
> >  }
> >
> > +static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
> > +                                     int devfn,
> > +                                     HostIOMMUContext *iommu_ctx)
> > +{
> > +    IntelIOMMUState *s = opaque;
> > +    VTDBus *vtd_bus;
> > +    VTDHostIOMMUContext *vtd_dev_icx;
> > +
> > +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
> > +
> > +    vtd_bus = vtd_find_add_bus(s, bus);
> > +
> > +    vtd_iommu_lock(s);
> > +
> > +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> > +
> > +    assert(!vtd_dev_icx);
> > +
> > +    vtd_bus->dev_icx[devfn] = vtd_dev_icx =
> > +                    g_malloc0(sizeof(VTDHostIOMMUContext));
> > +    vtd_dev_icx->vtd_bus = vtd_bus;
> > +    vtd_dev_icx->devfn = (uint8_t)devfn;
> > +    vtd_dev_icx->iommu_state = s;
> > +    vtd_dev_icx->iommu_ctx = iommu_ctx;
> > +
> > +    vtd_iommu_unlock(s);
> > +
> > +    return 0;
> > +}
> > +
> > +static void vtd_dev_unset_iommu_context(PCIBus *bus, void *opaque, int devfn)
> > +{
> > +    IntelIOMMUState *s = opaque;
> > +    VTDBus *vtd_bus;
> > +    VTDHostIOMMUContext *vtd_dev_icx;
> > +
> > +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
> > +
> > +    vtd_bus = vtd_find_add_bus(s, bus);
> > +
> > +    vtd_iommu_lock(s);
> > +
> > +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> > +    g_free(vtd_dev_icx);
> > +    vtd_bus->dev_icx[devfn] = NULL;
> > +
> > +    vtd_iommu_unlock(s);
> > +}
> > +
> >  static uint64_t get_naturally_aligned_size(uint64_t start,
> >                                             uint64_t size, int gaw)
> >  {
> > @@ -3731,6 +3790,8 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus
> *bus, void *opaque, int devfn)
> >
> >  static PCIIOMMUOps vtd_iommu_ops = {
> >      .get_address_space = vtd_host_dma_iommu,
> > +    .set_iommu_context = vtd_dev_set_iommu_context,
> > +    .unset_iommu_context = vtd_dev_unset_iommu_context,
> >  };
> >
> >  static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
> > diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> > index 3870052..b5fefb9 100644
> > --- a/include/hw/i386/intel_iommu.h
> > +++ b/include/hw/i386/intel_iommu.h
> > @@ -64,6 +64,7 @@ typedef union VTD_IR_TableEntry VTD_IR_TableEntry;
> >  typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
> >  typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
> >  typedef struct VTDPASIDEntry VTDPASIDEntry;
> > +typedef struct VTDHostIOMMUContext VTDHostIOMMUContext;
> >
> >  /* Context-Entry */
> >  struct VTDContextEntry {
> > @@ -112,10 +113,20 @@ struct VTDAddressSpace {
> >      IOVATree *iova_tree;          /* Traces mapped IOVA ranges */
> >  };
> >
> > +struct VTDHostIOMMUContext {
> 
> 
> > +    VTDBus *vtd_bus;
> > +    uint8_t devfn;
> > +    HostIOMMUContext *iommu_ctx;
> I don't get why we don't have standard QOM inheritance instead of this
> handle?
> VTDHostContext parent_obj;
> 
> like IOMMUMemoryRegion <- MemoryRegion <- Object

Here it is not inherit the object. It's just cache the HostIOMMUContext
pointer in vIOMMU. Just like AddressSpace, it has a MemoryRegion pointer.
Here is the same, VTDHostIOMMUContext is just a wrapper to better manage
it in vVT-d. It's not inheriting.

> > +    IntelIOMMUState *iommu_state;
> > +};
> > +
> >  struct VTDBus {
> > -    PCIBus* bus;		/* A reference to the bus to provide translation for
> */
> > +    /* A reference to the bus to provide translation for */
> > +    PCIBus *bus;
> >      /* A table of VTDAddressSpace objects indexed by devfn */
> > -    VTDAddressSpace *dev_as[];
> > +    VTDAddressSpace *dev_as[PCI_DEVFN_MAX];
> > +    /* A table of VTDHostIOMMUContext objects indexed by devfn */
> > +    VTDHostIOMMUContext *dev_icx[PCI_DEVFN_MAX];
> At this point of the review, it is unclear to me why the context is
> associated to a device.

HostIOMMUContext can be per-device or not. It depends on how vIOMMU
manage it. For vVT-d, it's per device as the container is per-device.

> Up to now you have not explained it should. If
> so why isn't it part of VTDAddressSpace?

Ah, I did have considered it. But I chose to use a separate one as
context is not really tied with an addresspace. It's better to mange
it with a separate structure.

Regards,
Yi Liu
