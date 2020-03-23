Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7C4190043
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 22:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCWV3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 17:29:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38753 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgCWV3Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 17:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584998961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7WWTe2Ledqtg2EV1DJLnUZw7ctgYMxsmuQiDXwMgqRg=;
        b=Zn/M13RHTGpEDxHihEJ83mXH4+UGpH+rQufNx1R9CflPr/n+HFehLvHeBkdnHFeLxT0oRa
        Y3rCIrWom8VIQzhwdssX5W6cERAIYLhXnFmj8WJ1tqTmTxJYaCwJDtf9ApnPoHe8v1im6G
        XGgc/UlmOU6Mr1pC6GQ6a5ZFt6N56hc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-w6dlpG2dN5myPhPcvaZdNw-1; Mon, 23 Mar 2020 17:29:17 -0400
X-MC-Unique: w6dlpG2dN5myPhPcvaZdNw-1
Received: by mail-wr1-f69.google.com with SMTP id q18so8080827wrw.5
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 14:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7WWTe2Ledqtg2EV1DJLnUZw7ctgYMxsmuQiDXwMgqRg=;
        b=QQp55X4QL5g/d4+V1GWkrKZAfFB/fZTnJ3ObVsi8qge88HNUOy0s9NkpSEYYO6yKg+
         5/QjZXqZWeaGTWZsXtMx0p0GB0a5XFimfr8YvjPufrA/lXocqQLjFpngH0wDDgCfy/WQ
         3TTUW65xkjKpbTnu80FwKdMQWCPN1ixIjKEdj/nSkNsF2gbdRmWfJibrXX+YgZ20Oyxr
         wLDYLZ03twsO5NqlXb39qKCNxnSzQr7tIXGWgJIOStVYPWfRv0SSlnquZPQXpi1iEJgq
         KiE87Aua5ky08a/5QCCyswo3O9jKWbMvLpiugyMQKr2IASdtPNe5EVj/S7ZOTnx6eiJ8
         nIwg==
X-Gm-Message-State: ANhLgQ3lQwpQ1/gO7qvSyAL00X1YxDRkRjIK0xiPCaOaY8mXUrrI8Pax
        xKarzhMvHAaHF7UdCVVAen6EuVJ/p0P1ndxqA59W5AT4DxGBc071nbpuSvfwIxxOSeD+DOT/h7k
        k/AHLsbHwaMlp
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr1459703wma.122.1584998956573;
        Mon, 23 Mar 2020 14:29:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vssZHuLhIG36CGn4z9obg1vcL570yDxmFjr9wBkFe0tlIZ4dsIUqa/D1XE8Vasz2qGwGGZBFA==
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr1459672wma.122.1584998956241;
        Mon, 23 Mar 2020 14:29:16 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id g7sm25817035wrq.21.2020.03.23.14.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 14:29:15 -0700 (PDT)
Date:   Mon, 23 Mar 2020 17:29:11 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v1 07/22] intel_iommu: add set/unset_iommu_context
 callback
Message-ID: <20200323212911.GQ127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-8-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-8-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:04AM -0700, Liu Yi L wrote:
> This patch adds set/unset_iommu_context() impelementation in Intel
> vIOMMU. For Intel platform, pass-through modules (e.g. VFIO) could
> set HostIOMMUContext to Intel vIOMMU emulator.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/i386/intel_iommu.c         | 70 +++++++++++++++++++++++++++++++++++++++----
>  include/hw/i386/intel_iommu.h | 17 +++++++++--
>  2 files changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 4b22910..8d9204f 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3354,23 +3354,35 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
>      },
>  };
>  
> -VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
> +/**
> + * Fetch a VTDBus instance for given PCIBus. If no existing instance,
> + * allocate one.
> + */
> +static VTDBus *vtd_find_add_bus(IntelIOMMUState *s, PCIBus *bus)
>  {
>      uintptr_t key = (uintptr_t)bus;
>      VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
> -    VTDAddressSpace *vtd_dev_as;
> -    char name[128];
>  
>      if (!vtd_bus) {
>          uintptr_t *new_key = g_malloc(sizeof(*new_key));
>          *new_key = (uintptr_t)bus;
>          /* No corresponding free() */
> -        vtd_bus = g_malloc0(sizeof(VTDBus) + sizeof(VTDAddressSpace *) * \
> -                            PCI_DEVFN_MAX);
> +        vtd_bus = g_malloc0(sizeof(VTDBus) + PCI_DEVFN_MAX * \
> +                            (sizeof(VTDAddressSpace *) + \
> +                             sizeof(VTDHostIOMMUContext *)));

IIRC I commented on this before...  Shouldn't sizeof(VTDBus) be
enough?

>          vtd_bus->bus = bus;
>          g_hash_table_insert(s->vtd_as_by_busptr, new_key, vtd_bus);
>      }
> +    return vtd_bus;
> +}
> +
> +VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
> +{
> +    VTDBus *vtd_bus;
> +    VTDAddressSpace *vtd_dev_as;
> +    char name[128];
>  
> +    vtd_bus = vtd_find_add_bus(s, bus);
>      vtd_dev_as = vtd_bus->dev_as[devfn];
>  
>      if (!vtd_dev_as) {
> @@ -3436,6 +3448,52 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
>      return vtd_dev_as;
>  }
>  
> +static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
> +                                     int devfn,
> +                                     HostIOMMUContext *host_icx)
> +{
> +    IntelIOMMUState *s = opaque;
> +    VTDBus *vtd_bus;
> +    VTDHostIOMMUContext *vtd_dev_icx;
> +
> +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
> +
> +    vtd_bus = vtd_find_add_bus(s, bus);
> +
> +    vtd_iommu_lock(s);
> +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> +
> +    if (!vtd_dev_icx) {

We can assert this directly I think, in case we accidentally set the
context twice without notice.

> +        vtd_bus->dev_icx[devfn] = vtd_dev_icx =
> +                    g_malloc0(sizeof(VTDHostIOMMUContext));
> +        vtd_dev_icx->vtd_bus = vtd_bus;
> +        vtd_dev_icx->devfn = (uint8_t)devfn;
> +        vtd_dev_icx->iommu_state = s;
> +        vtd_dev_icx->host_icx = host_icx;
> +    }
> +    vtd_iommu_unlock(s);
> +
> +    return 0;
> +}
> +
> +static void vtd_dev_unset_iommu_context(PCIBus *bus, void *opaque, int devfn)
> +{
> +    IntelIOMMUState *s = opaque;
> +    VTDBus *vtd_bus;
> +    VTDHostIOMMUContext *vtd_dev_icx;
> +
> +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
> +
> +    vtd_bus = vtd_find_add_bus(s, bus);
> +
> +    vtd_iommu_lock(s);
> +
> +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> +    g_free(vtd_dev_icx);

Better set it as NULL, and can also drop vtd_dev_icx which seems
meaningless..

       g_free(vtd_bus->dev_icx[devfn]);
       vtd_bus->dev_icx[devfn] = NULL;

> +
> +    vtd_iommu_unlock(s);
> +}
> +
>  static uint64_t get_naturally_aligned_size(uint64_t start,
>                                             uint64_t size, int gaw)
>  {
> @@ -3731,6 +3789,8 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
>  
>  static PCIIOMMUOps vtd_iommu_ops = {
>      .get_address_space = vtd_host_dma_iommu,
> +    .set_iommu_context = vtd_dev_set_iommu_context,
> +    .unset_iommu_context = vtd_dev_unset_iommu_context,
>  };
>  
>  static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> index 3870052..9b4fc0a 100644
> --- a/include/hw/i386/intel_iommu.h
> +++ b/include/hw/i386/intel_iommu.h
> @@ -64,6 +64,7 @@ typedef union VTD_IR_TableEntry VTD_IR_TableEntry;
>  typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
>  typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
>  typedef struct VTDPASIDEntry VTDPASIDEntry;
> +typedef struct VTDHostIOMMUContext VTDHostIOMMUContext;
>  
>  /* Context-Entry */
>  struct VTDContextEntry {
> @@ -112,10 +113,20 @@ struct VTDAddressSpace {
>      IOVATree *iova_tree;          /* Traces mapped IOVA ranges */
>  };
>  
> +struct VTDHostIOMMUContext {
> +    VTDBus *vtd_bus;
> +    uint8_t devfn;
> +    HostIOMMUContext *host_icx;
> +    IntelIOMMUState *iommu_state;
> +};
> +
>  struct VTDBus {
> -    PCIBus* bus;		/* A reference to the bus to provide translation for */
> +    /* A reference to the bus to provide translation for */
> +    PCIBus *bus;
>      /* A table of VTDAddressSpace objects indexed by devfn */
> -    VTDAddressSpace *dev_as[];
> +    VTDAddressSpace *dev_as[PCI_DEVFN_MAX];
> +    /* A table of VTDHostIOMMUContext objects indexed by devfn */
> +    VTDHostIOMMUContext *dev_icx[PCI_DEVFN_MAX];
>  };
>  
>  struct VTDIOTLBEntry {
> @@ -271,6 +282,8 @@ struct IntelIOMMUState {
>      /*
>       * Protects IOMMU states in general.  Currently it protects the
>       * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
> +     * Protect the update/usage of HostIOMMUContext pointer cached in
> +     * VTDBus->dev_icx array as array elements may be updated by hotplug

I think the context update does not need to be updated, because they
should always be with the BQL, right?

Thanks,

>       */
>      QemuMutex iommu_lock;
>  };
> -- 
> 2.7.4
> 

-- 
Peter Xu

