Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBCC1996E4
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgCaM5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:57:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45439 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730710AbgCaM5m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 08:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585659460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6JMjvAf9MgeR+kO4xS912mPPXk3cw/VuCauhh/9zl8=;
        b=VGaUe9QXx3rUJtxHeHruxDrI8xhcc/lae8436CieIH++EE6aIeArh7TZqhXIHkC71VKqSN
        oALRMwRAM8nhoKCd+iNR2VPirgk2GCbEtGXYDyu49aW+MX53wYrh1UvhwK/RN2A1jeGx3i
        6slHe77cU+NHhWxrc/0oF4D5K+kwnk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-38MoiPtnOQan7yypvdaTTQ-1; Tue, 31 Mar 2020 08:57:38 -0400
X-MC-Unique: 38MoiPtnOQan7yypvdaTTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AC2418C8C03;
        Tue, 31 Mar 2020 12:57:36 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F17919C58;
        Tue, 31 Mar 2020 12:57:24 +0000 (UTC)
Subject: Re: [PATCH v2 07/22] intel_iommu: add set/unset_iommu_context
 callback
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-8-git-send-email-yi.l.liu@intel.com>
 <a444318b-32c7-d43c-112a-d35a870b162d@redhat.com>
 <A2975661238FB949B60364EF0F2C25743A21AF24@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0c9ed7c3-6d09-adac-a478-52bff476f804@redhat.com>
Date:   Tue, 31 Mar 2020 14:57:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A21AF24@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 3/31/20 2:25 PM, Liu, Yi L wrote:
> Hi Eric,
> 
>> From: Auger Eric < eric.auger@redhat.com>
>> Sent: Tuesday, March 31, 2020 4:24 AM
>> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
>> Subject: Re: [PATCH v2 07/22] intel_iommu: add set/unset_iommu_context callback
>>
>> Yi,
>>
>> On 3/30/20 6:24 AM, Liu Yi L wrote:
>>> This patch adds set/unset_iommu_context() impelementation in Intel
>> This patch implements the set/unset_iommu_context() ops for Intel vIOMMU.
>>> vIOMMU. For Intel platform, pass-through modules (e.g. VFIO) could
>>> set HostIOMMUContext to Intel vIOMMU emulator.
>>>
>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> Cc: Peter Xu <peterx@redhat.com>
>>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Richard Henderson <rth@twiddle.net>
>>> Cc: Eduardo Habkost <ehabkost@redhat.com>
>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>> ---
>>>  hw/i386/intel_iommu.c         | 71
>> ++++++++++++++++++++++++++++++++++++++++---
>>>  include/hw/i386/intel_iommu.h | 21 ++++++++++---
>>>  2 files changed, 83 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
>>> index 4b22910..fd349c6 100644
>>> --- a/hw/i386/intel_iommu.c
>>> +++ b/hw/i386/intel_iommu.c
>>> @@ -3354,23 +3354,33 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
>>>      },
>>>  };
>>>
>>> -VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
>>> +/**
>>> + * Fetch a VTDBus instance for given PCIBus. If no existing instance,
>>> + * allocate one.
>>> + */
>>> +static VTDBus *vtd_find_add_bus(IntelIOMMUState *s, PCIBus *bus)
>>>  {
>>>      uintptr_t key = (uintptr_t)bus;
>>>      VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
>>> -    VTDAddressSpace *vtd_dev_as;
>>> -    char name[128];
>>>
>>>      if (!vtd_bus) {
>>>          uintptr_t *new_key = g_malloc(sizeof(*new_key));
>>>          *new_key = (uintptr_t)bus;
>>>          /* No corresponding free() */
>>> -        vtd_bus = g_malloc0(sizeof(VTDBus) + sizeof(VTDAddressSpace *) * \
>>> -                            PCI_DEVFN_MAX);
>>> +        vtd_bus = g_malloc0(sizeof(VTDBus));
>>>          vtd_bus->bus = bus;
>>>          g_hash_table_insert(s->vtd_as_by_busptr, new_key, vtd_bus);
>>>      }
>>> +    return vtd_bus;
>>> +}
>>>
>>> +VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
>>> +{
>>> +    VTDBus *vtd_bus;
>>> +    VTDAddressSpace *vtd_dev_as;
>>> +    char name[128];
>>> +
>>> +    vtd_bus = vtd_find_add_bus(s, bus);
>>>      vtd_dev_as = vtd_bus->dev_as[devfn];
>>>
>>>      if (!vtd_dev_as) {
>>> @@ -3436,6 +3446,55 @@ VTDAddressSpace
>> *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
>>>      return vtd_dev_as;
>>>  }
>>>
>>> +static int vtd_dev_set_iommu_context(PCIBus *bus, void *opaque,
>>> +                                     int devfn,
>>> +                                     HostIOMMUContext *iommu_ctx)
>>> +{
>>> +    IntelIOMMUState *s = opaque;
>>> +    VTDBus *vtd_bus;
>>> +    VTDHostIOMMUContext *vtd_dev_icx;
>>> +
>>> +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
>>> +
>>> +    vtd_bus = vtd_find_add_bus(s, bus);
>>> +
>>> +    vtd_iommu_lock(s);
>>> +
>>> +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
>>> +
>>> +    assert(!vtd_dev_icx);
>>> +
>>> +    vtd_bus->dev_icx[devfn] = vtd_dev_icx =
>>> +                    g_malloc0(sizeof(VTDHostIOMMUContext));
>>> +    vtd_dev_icx->vtd_bus = vtd_bus;
>>> +    vtd_dev_icx->devfn = (uint8_t)devfn;
>>> +    vtd_dev_icx->iommu_state = s;
>>> +    vtd_dev_icx->iommu_ctx = iommu_ctx;
>>> +
>>> +    vtd_iommu_unlock(s);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void vtd_dev_unset_iommu_context(PCIBus *bus, void *opaque, int devfn)
>>> +{
>>> +    IntelIOMMUState *s = opaque;
>>> +    VTDBus *vtd_bus;
>>> +    VTDHostIOMMUContext *vtd_dev_icx;
>>> +
>>> +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
>>> +
>>> +    vtd_bus = vtd_find_add_bus(s, bus);
>>> +
>>> +    vtd_iommu_lock(s);
>>> +
>>> +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
>>> +    g_free(vtd_dev_icx);
>>> +    vtd_bus->dev_icx[devfn] = NULL;
>>> +
>>> +    vtd_iommu_unlock(s);
>>> +}
>>> +
>>>  static uint64_t get_naturally_aligned_size(uint64_t start,
>>>                                             uint64_t size, int gaw)
>>>  {
>>> @@ -3731,6 +3790,8 @@ static AddressSpace *vtd_host_dma_iommu(PCIBus
>> *bus, void *opaque, int devfn)
>>>
>>>  static PCIIOMMUOps vtd_iommu_ops = {
>>>      .get_address_space = vtd_host_dma_iommu,
>>> +    .set_iommu_context = vtd_dev_set_iommu_context,
>>> +    .unset_iommu_context = vtd_dev_unset_iommu_context,
>>>  };
>>>
>>>  static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
>>> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
>>> index 3870052..b5fefb9 100644
>>> --- a/include/hw/i386/intel_iommu.h
>>> +++ b/include/hw/i386/intel_iommu.h
>>> @@ -64,6 +64,7 @@ typedef union VTD_IR_TableEntry VTD_IR_TableEntry;
>>>  typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
>>>  typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
>>>  typedef struct VTDPASIDEntry VTDPASIDEntry;
>>> +typedef struct VTDHostIOMMUContext VTDHostIOMMUContext;
>>>
>>>  /* Context-Entry */
>>>  struct VTDContextEntry {
>>> @@ -112,10 +113,20 @@ struct VTDAddressSpace {
>>>      IOVATree *iova_tree;          /* Traces mapped IOVA ranges */
>>>  };
>>>
>>> +struct VTDHostIOMMUContext {
>>
>>
>>> +    VTDBus *vtd_bus;
>>> +    uint8_t devfn;
>>> +    HostIOMMUContext *iommu_ctx;
>> I don't get why we don't have standard QOM inheritance instead of this
>> handle?
>> VTDHostContext parent_obj;
>>
>> like IOMMUMemoryRegion <- MemoryRegion <- Object
> 
> Here it is not inherit the object. It's just cache the HostIOMMUContext
> pointer in vIOMMU. Just like AddressSpace, it has a MemoryRegion pointer.
> Here is the same, VTDHostIOMMUContext is just a wrapper to better manage
> it in vVT-d. It's not inheriting.

Yep I've got it now ;-)
> 
>>> +    IntelIOMMUState *iommu_state;
>>> +};
>>> +
>>>  struct VTDBus {
>>> -    PCIBus* bus;		/* A reference to the bus to provide translation for
>> */
>>> +    /* A reference to the bus to provide translation for */
>>> +    PCIBus *bus;
>>>      /* A table of VTDAddressSpace objects indexed by devfn */
>>> -    VTDAddressSpace *dev_as[];
>>> +    VTDAddressSpace *dev_as[PCI_DEVFN_MAX];
>>> +    /* A table of VTDHostIOMMUContext objects indexed by devfn */
>>> +    VTDHostIOMMUContext *dev_icx[PCI_DEVFN_MAX];
>> At this point of the review, it is unclear to me why the context is
>> associated to a device.
> 
> HostIOMMUContext can be per-device or not. It depends on how vIOMMU
> manage it. For vVT-d, it's per device as the container is per-device.
> 
>> Up to now you have not explained it should. If
>> so why isn't it part of VTDAddressSpace?
> 
> Ah, I did have considered it. But I chose to use a separate one as
> context is not really tied with an addresspace. It's better to mange
> it with a separate structure.

OK

Thanks

Eric
> 
> Regards,
> Yi Liu
> 

