Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C568A19DE5B
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 21:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgDCTJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 15:09:27 -0400
Received: from foss.arm.com ([217.140.110.172]:56472 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbgDCTJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 15:09:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDF431FB;
        Fri,  3 Apr 2020 12:09:25 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA7393F71E;
        Fri,  3 Apr 2020 12:09:23 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 27/32] pci: Implement callbacks for toggling
 BAR emulation
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com,
        Alexandru Elisei <alexandru.elisei@gmail.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-28-alexandru.elisei@arm.com>
 <a04a7489-6660-aa7b-5391-2e49e6cabe0f@arm.com>
 <8e6b0d53-67c9-5341-0d88-a56e0d5bf759@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <49bb250c-2e50-f4da-d7a3-9d377cab180c@arm.com>
Date:   Fri, 3 Apr 2020 20:08:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8e6b0d53-67c9-5341-0d88-a56e0d5bf759@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/04/2020 19:14, Alexandru Elisei wrote:
> Hi,
> 
> On 4/3/20 12:57 PM, André Przywara wrote:
>> On 26/03/2020 15:24, Alexandru Elisei wrote:
>>
>> Hi,
>>
>>> From: Alexandru Elisei <alexandru.elisei@gmail.com>
>>>
>>> Implement callbacks for activating and deactivating emulation for a BAR
>>> region. This is in preparation for allowing a guest operating system to
>>> enable and disable access to I/O or memory space, or to reassign the
>>> BARs.
>>>
>>> The emulated vesa device framebuffer isn't designed to allow stopping and
>>> restarting at arbitrary points in the guest execution. Furthermore, on x86,
>>> the kernel will not change the BAR addresses, which on bare metal are
>>> programmed by the firmware, so take the easy way out and refuse to
>>> activate/deactivate emulation for the BAR regions. We also take this
>>> opportunity to make the vesa emulation code more consistent by moving all
>>> static variable definitions in one place, at the top of the file.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  hw/vesa.c         |  70 ++++++++++++++++++++------------
>>>  include/kvm/pci.h |  18 ++++++++-
>>>  pci.c             |  44 ++++++++++++++++++++
>>>  vfio/pci.c        | 100 ++++++++++++++++++++++++++++++++++++++--------
>>>  virtio/pci.c      |  90 ++++++++++++++++++++++++++++++-----------
>>>  5 files changed, 254 insertions(+), 68 deletions(-)
>>>
>>> diff --git a/hw/vesa.c b/hw/vesa.c
>>> index 8071ad153f27..31c2d16ae4de 100644
>>> --- a/hw/vesa.c
>>> +++ b/hw/vesa.c
>>> @@ -18,6 +18,31 @@
>>>  #include <inttypes.h>
>>>  #include <unistd.h>
>>>  
>>> +static struct pci_device_header vesa_pci_device = {
>>> +	.vendor_id	= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>>> +	.device_id	= cpu_to_le16(PCI_DEVICE_ID_VESA),
>>> +	.header_type	= PCI_HEADER_TYPE_NORMAL,
>>> +	.revision_id	= 0,
>>> +	.class[2]	= 0x03,
>>> +	.subsys_vendor_id = cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
>>> +	.subsys_id	= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
>>> +	.bar[1]		= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
>>> +	.bar_size[1]	= VESA_MEM_SIZE,
>>> +};
>>> +
>>> +static struct device_header vesa_device = {
>>> +	.bus_type	= DEVICE_BUS_PCI,
>>> +	.data		= &vesa_pci_device,
>>> +};
>>> +
>>> +static struct framebuffer vesafb = {
>>> +	.width		= VESA_WIDTH,
>>> +	.height		= VESA_HEIGHT,
>>> +	.depth		= VESA_BPP,
>>> +	.mem_addr	= VESA_MEM_ADDR,
>>> +	.mem_size	= VESA_MEM_SIZE,
>>> +};
>>> +
>>>  static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>>>  {
>>>  	return true;
>>> @@ -33,24 +58,19 @@ static struct ioport_operations vesa_io_ops = {
>>>  	.io_out			= vesa_pci_io_out,
>>>  };
>>>  
>>> -static struct pci_device_header vesa_pci_device = {
>>> -	.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>>> -	.device_id		= cpu_to_le16(PCI_DEVICE_ID_VESA),
>>> -	.header_type		= PCI_HEADER_TYPE_NORMAL,
>>> -	.revision_id		= 0,
>>> -	.class[2]		= 0x03,
>>> -	.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
>>> -	.subsys_id		= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
>>> -	.bar[1]			= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
>>> -	.bar_size[1]		= VESA_MEM_SIZE,
>>> -};
>>> -
>>> -static struct device_header vesa_device = {
>>> -	.bus_type	= DEVICE_BUS_PCI,
>>> -	.data		= &vesa_pci_device,
>>> -};
>>> +static int vesa__bar_activate(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>> +			      int bar_num, void *data)
>>> +{
>>> +	/* We don't support remapping of the framebuffer. */
>>> +	return 0;
>>> +}
>>>  
>>> -static struct framebuffer vesafb;
>>> +static int vesa__bar_deactivate(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>> +				int bar_num, void *data)
>>> +{
>>> +	/* We don't support remapping of the framebuffer. */
>>> +	return -EINVAL;
>>> +}
>>>  
>>>  struct framebuffer *vesa__init(struct kvm *kvm)
>>>  {
>>> @@ -73,6 +93,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>>  
>>>  	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
>>>  	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
>>> +	r = pci__register_bar_regions(kvm, &vesa_pci_device, vesa__bar_activate,
>>> +				      vesa__bar_deactivate, NULL);
>>> +	if (r < 0)
>>> +		goto unregister_ioport;
>>> +
>>>  	r = device__register(&vesa_device);
>>>  	if (r < 0)
>>>  		goto unregister_ioport;
>>> @@ -87,15 +112,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>>  	if (r < 0)
>>>  		goto unmap_dev;
>>>  
>>> -	vesafb = (struct framebuffer) {
>>> -		.width			= VESA_WIDTH,
>>> -		.height			= VESA_HEIGHT,
>>> -		.depth			= VESA_BPP,
>>> -		.mem			= mem,
>>> -		.mem_addr		= VESA_MEM_ADDR,
>>> -		.mem_size		= VESA_MEM_SIZE,
>>> -		.kvm			= kvm,
>>> -	};
>>> +	vesafb.mem = mem;
>>> +	vesafb.kvm = kvm;
>>>  	return fb__register(&vesafb);
>>>  
>>>  unmap_dev:
>> Those transformations look correct to me.
>>
>>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>>> index adb4b5c082d5..1d7d4c0cea5a 100644
>>> --- a/include/kvm/pci.h
>>> +++ b/include/kvm/pci.h
>>> @@ -89,12 +89,19 @@ struct pci_cap_hdr {
>>>  	u8	next;
>>>  };
>>>  
>>> +struct pci_device_header;
>>> +
>>> +typedef int (*bar_activate_fn_t)(struct kvm *kvm,
>>> +				 struct pci_device_header *pci_hdr,
>>> +				 int bar_num, void *data);
>>> +typedef int (*bar_deactivate_fn_t)(struct kvm *kvm,
>>> +				   struct pci_device_header *pci_hdr,
>>> +				   int bar_num, void *data);
>>> +
>>>  #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
>>>  #define PCI_DEV_CFG_SIZE	256
>>>  #define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>>  
>>> -struct pci_device_header;
>>> -
>>>  struct pci_config_operations {
>>>  	void (*write)(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>>  		      u8 offset, void *data, int sz);
>>> @@ -136,6 +143,9 @@ struct pci_device_header {
>>>  
>>>  	/* Private to lkvm */
>>>  	u32		bar_size[6];
>>> +	bar_activate_fn_t	bar_activate_fn;
>>> +	bar_deactivate_fn_t	bar_deactivate_fn;
>>> +	void *data;
>>>  	struct pci_config_operations	cfg_ops;
>>>  	/*
>>>  	 * PCI INTx# are level-triggered, but virtual device often feature
>>> @@ -162,6 +172,10 @@ void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data,
>>>  
>>>  void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
>>>  
>>> +int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>> +			      bar_activate_fn_t bar_activate_fn,
>>> +			      bar_deactivate_fn_t bar_deactivate_fn, void *data);
>>> +
>>>  static inline bool __pci__memory_space_enabled(u16 command)
>>>  {
>>>  	return command & PCI_COMMAND_MEMORY;
>>> diff --git a/pci.c b/pci.c
>>> index 611e2c0bf1da..4ace190898f2 100644
>>> --- a/pci.c
>>> +++ b/pci.c
>>> @@ -66,6 +66,11 @@ void pci__assign_irq(struct device_header *dev_hdr)
>>>  		pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
>>>  }
>>>  
>>> +static bool pci_bar_is_implemented(struct pci_device_header *pci_hdr, int bar_num)
>>> +{
>>> +	return pci__bar_size(pci_hdr, bar_num);
>>> +}
>>> +
>>>  static void *pci_config_address_ptr(u16 port)
>>>  {
>>>  	unsigned long offset;
>>> @@ -273,6 +278,45 @@ struct pci_device_header *pci__find_dev(u8 dev_num)
>>>  	return hdr->data;
>>>  }
>>>  
>>> +int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>> +			      bar_activate_fn_t bar_activate_fn,
>>> +			      bar_deactivate_fn_t bar_deactivate_fn, void *data)
>>> +{
>>> +	int i, r;
>>> +	bool has_bar_regions = false;
>>> +
>>> +	assert(bar_activate_fn && bar_deactivate_fn);
>>> +
>>> +	pci_hdr->bar_activate_fn = bar_activate_fn;
>>> +	pci_hdr->bar_deactivate_fn = bar_deactivate_fn;
>>> +	pci_hdr->data = data;
>>> +
>>> +	for (i = 0; i < 6; i++) {
>>> +		if (!pci_bar_is_implemented(pci_hdr, i))
>>> +			continue;
>>> +
>>> +		has_bar_regions = true;
>>> +
>>> +		if (pci__bar_is_io(pci_hdr, i) &&
>>> +		    pci__io_space_enabled(pci_hdr)) {
>>> +				r = bar_activate_fn(kvm, pci_hdr, i, data);
>>> +				if (r < 0)
>>> +					return r;
>>> +			}
>> Indentation seems to be off here, I think the last 4 lines need to have
>> one tab removed.
>>
>>> +
>>> +		if (pci__bar_is_memory(pci_hdr, i) &&
>>> +		    pci__memory_space_enabled(pci_hdr)) {
>>> +				r = bar_activate_fn(kvm, pci_hdr, i, data);
>>> +				if (r < 0)
>>> +					return r;
>>> +			}
>> Same indentation issue here.
> 
> Nicely spotted, I'll fix it.
> 
>>
>>> +	}
>>> +
>>> +	assert(has_bar_regions);
>> Is assert() here really a good idea? I see that it makes sense for our
>> emulated devices, but is that a valid check for VFIO?
>> From briefly looking I can't find a requirement for having at least one
>> valid BAR in general, and even if - I think we should rather return an
>> error than aborting the guest here - or ignore it altogether.
> 
> The assert here is to discover coding errors with devices, not with the PCI
> emulation. Calling pci__register_bar_regions and providing callbacks for when BAR
> access is toggled, but *without* any valid BARs looks like a coding error in the
> device emulation code to me.

As I said, I totally see the point for our emulated devices, but it
looks like we use this code also for VFIO? Where we are not in control
of what the device exposes.

> As for VFIO, I'm struggling to find a valid reason for someone to build a device
> that uses PCI, but doesn't have any BARs. Isn't that the entire point of PCI? I'm
> perfectly happy to remove the assert if you can provide an rationale for building
> such a device.

IIRC you have an AMD box, check the "Northbridge" PCI device there,
devices 0:18.x. They provide chipset registers via (extended) config
space only, they don't have any valid BARs. Also I found some SMBus
device without BARs.
Not the most prominent use case (especially for pass through), but
apparently valid.
I think the rationale for using this was to use a well established,
supported and discoverable interface.

>>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  int pci__init(struct kvm *kvm)
>>>  {
>>>  	int r;
>>> diff --git a/vfio/pci.c b/vfio/pci.c
>>> index 8b2a0c8dbac3..18e22a8c5320 100644
>>> --- a/vfio/pci.c
>>> +++ b/vfio/pci.c
>>> @@ -8,6 +8,8 @@
>>>  #include <sys/resource.h>
>>>  #include <sys/time.h>
>>>  
>>> +#include <assert.h>
>>> +
>>>  /* Wrapper around UAPI vfio_irq_set */
>>>  union vfio_irq_eventfd {
>>>  	struct vfio_irq_set	irq;
>>> @@ -446,6 +448,81 @@ out_unlock:
>>>  	mutex_unlock(&pdev->msi.mutex);
>>>  }
>>>  
>>> +static int vfio_pci_bar_activate(struct kvm *kvm,
>>> +				 struct pci_device_header *pci_hdr,
>>> +				 int bar_num, void *data)
>>> +{
>>> +	struct vfio_device *vdev = data;
>>> +	struct vfio_pci_device *pdev = &vdev->pci;
>>> +	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>>> +	struct vfio_pci_msix_table *table = &pdev->msix_table;
>>> +	struct vfio_region *region;
>>> +	bool has_msix;
>>> +	int ret;
>>> +
>>> +	assert((u32)bar_num < vdev->info.num_regions);
>>> +
>>> +	region = &vdev->regions[bar_num];
>>> +	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
>>> +
>>> +	if (has_msix && (u32)bar_num == table->bar) {
>>> +		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
>>> +					 table->size, false,
>>> +					 vfio_pci_msix_table_access, pdev);
>>> +		if (ret < 0 || table->bar != pba->bar)
>> I think this second expression deserves some comment.
>> If I understand correctly, this would register the PBA trap handler
>> separetely below if both the MSIX table and the PBA share a BAR?
> 
> The MSIX table and the PBA structure can share the same BAR for the base address
> (that's why the MSIX capability has an offset field for both of them), but we
> register different regions for mmio emulation because we don't want to have a
> generic handler and always check if the mmio access was to the MSIX table of the
> PBA structure. I can add a comment stating that, sure.

Yes, thanks for the explanation!

>>
>>> +			goto out;
>> Is there any particular reason you are using goto here? I find it more
>> confusing if the "out:" label has just a return statement, without any
>> cleanup or lock dropping. Just a "return ret;" here would be much
>> cleaner I think. Same for other occassions in this function and
>> elsewhere in this patch.
>>
>> Or do you plan on adding some code here later? I don't see it in this
>> series though.
> 
> The reason I'm doing this is because I prefer one exit point from the function,
> instead of return statements at arbitrary points in the function body. As a point
> of reference, the pattern is recommended in the MISRA C standard for safety, in
> section 17.4 "No more than one return statement", and is also used in the Linux
> kernel. I think it comes down to personal preference, so unless Will of Julien
> have a strong preference against it, I would rather keep it.

Fair enough, your decision. Just to point out that I can't find this
practice in the kernel, also:

Documentation/process/coding-style.rst, section "7) Centralized exiting
of functions":
"The goto statement comes in handy when a function exits from multiple
locations and some common work such as cleanup has to be done.  If there
is no cleanup needed then just return directly."


Thanks!
Andre.

> 
>>
>>> +	}
>>> +
>>> +	if (has_msix && (u32)bar_num == pba->bar) {
>>> +		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
>>> +					 pba->size, false,
>>> +					 vfio_pci_msix_pba_access, pdev);
>>> +		goto out;
>>> +	}
>>> +
>>> +	ret = vfio_map_region(kvm, vdev, region);
>>> +out:
>>> +	return ret;
>>> +}
>>> +
>>> +static int vfio_pci_bar_deactivate(struct kvm *kvm,
>>> +				   struct pci_device_header *pci_hdr,
>>> +				   int bar_num, void *data)
>>> +{
>>> +	struct vfio_device *vdev = data;
>>> +	struct vfio_pci_device *pdev = &vdev->pci;
>>> +	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>>> +	struct vfio_pci_msix_table *table = &pdev->msix_table;
>>> +	struct vfio_region *region;
>>> +	bool has_msix, success;
>>> +	int ret;
>>> +
>>> +	assert((u32)bar_num < vdev->info.num_regions);
>>> +
>>> +	region = &vdev->regions[bar_num];
>>> +	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
>>> +
>>> +	if (has_msix && (u32)bar_num == table->bar) {
>>> +		success = kvm__deregister_mmio(kvm, table->guest_phys_addr);
>>> +		/* kvm__deregister_mmio fails when the region is not found. */
>>> +		ret = (success ? 0 : -ENOENT);
>>> +		if (ret < 0 || table->bar!= pba->bar)
>>> +			goto out;
>>> +	}
>>> +
>>> +	if (has_msix && (u32)bar_num == pba->bar) {
>>> +		success = kvm__deregister_mmio(kvm, pba->guest_phys_addr);
>>> +		ret = (success ? 0 : -ENOENT);
>>> +		goto out;
>>> +	}
>>> +
>>> +	vfio_unmap_region(kvm, region);
>>> +	ret = 0;
>>> +
>>> +out:
>>> +	return ret;
>>> +}
>>> +
>>>  static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
>>>  			      u8 offset, void *data, int sz)
>>>  {
>>> @@ -805,12 +882,6 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>>>  		ret = -ENOMEM;
>>>  		goto out_free;
>>>  	}
>>> -	pba->guest_phys_addr = table->guest_phys_addr + table->size;
>>> -
>>> -	ret = kvm__register_mmio(kvm, table->guest_phys_addr, table->size,
>>> -				 false, vfio_pci_msix_table_access, pdev);
>>> -	if (ret < 0)
>>> -		goto out_free;
>>>  
>>>  	/*
>>>  	 * We could map the physical PBA directly into the guest, but it's
>>> @@ -820,10 +891,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>>>  	 * between MSI-X table and PBA. For the sake of isolation, create a
>>>  	 * virtual PBA.
>>>  	 */
>>> -	ret = kvm__register_mmio(kvm, pba->guest_phys_addr, pba->size, false,
>>> -				 vfio_pci_msix_pba_access, pdev);
>>> -	if (ret < 0)
>>> -		goto out_free;
>>> +	pba->guest_phys_addr = table->guest_phys_addr + table->size;
>>>  
>>>  	pdev->msix.entries = entries;
>>>  	pdev->msix.nr_entries = nr_entries;
>>> @@ -894,11 +962,6 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>>>  		region->guest_phys_addr = pci_get_mmio_block(map_size);
>>>  	}
>>>  
>>> -	/* Map the BARs into the guest or setup a trap region. */
>>> -	ret = vfio_map_region(kvm, vdev, region);
>>> -	if (ret)
>>> -		return ret;
>>> -
>>>  	return 0;
>>>  }
>>>  
>>> @@ -945,7 +1008,12 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
>>>  	}
>>>  
>>>  	/* We've configured the BARs, fake up a Configuration Space */
>>> -	return vfio_pci_fixup_cfg_space(vdev);
>>> +	ret = vfio_pci_fixup_cfg_space(vdev);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	return pci__register_bar_regions(kvm, &pdev->hdr, vfio_pci_bar_activate,
>>> +					 vfio_pci_bar_deactivate, vdev);
>>>  }
>>>  
>>>  /*
>>> diff --git a/virtio/pci.c b/virtio/pci.c
>>> index d111dc499f5e..598da699c241 100644
>>> --- a/virtio/pci.c
>>> +++ b/virtio/pci.c
>>> @@ -11,6 +11,7 @@
>>>  #include <sys/ioctl.h>
>>>  #include <linux/virtio_pci.h>
>>>  #include <linux/byteorder.h>
>>> +#include <assert.h>
>>>  #include <string.h>
>>>  
>>>  static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
>>> @@ -462,6 +463,64 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>>>  		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
>>>  }
>>>  
>>> +static int virtio_pci__bar_activate(struct kvm *kvm,
>>> +				    struct pci_device_header *pci_hdr,
>>> +				    int bar_num, void *data)
>>> +{
>>> +	struct virtio_device *vdev = data;
>>> +	u32 bar_addr, bar_size;
>>> +	int r = -EINVAL;
>>> +
>>> +	assert(bar_num <= 2);
>>> +
>>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>>> +	bar_size = pci__bar_size(pci_hdr, bar_num);
>>> +
>>> +	switch (bar_num) {
>>> +	case 0:
>>> +		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
>>> +				     bar_size, vdev);
>>> +		if (r > 0)
>>> +			r = 0;
>>> +		break;
>>> +	case 1:
>>> +		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
>>> +					virtio_pci__io_mmio_callback, vdev);
>>> +		break;
>>> +	case 2:
>>> +		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
>>> +					virtio_pci__msix_mmio_callback, vdev);
>> I think adding a break; here looks nicer.
> 
> Sure, it will make the function look more consistent.
> 
> Thanks,
> Alex
>>
>> Cheers,
>> Andre
>>
>>
>>> +	}
>>> +
>>> +	return r;
>>> +}
>>> +
>>> +static int virtio_pci__bar_deactivate(struct kvm *kvm,
>>> +				      struct pci_device_header *pci_hdr,
>>> +				      int bar_num, void *data)
>>> +{
>>> +	u32 bar_addr;
>>> +	bool success;
>>> +	int r = -EINVAL;
>>> +
>>> +	assert(bar_num <= 2);
>>> +
>>> +	bar_addr = pci__bar_address(pci_hdr, bar_num);
>>> +
>>> +	switch (bar_num) {
>>> +	case 0:
>>> +		r = ioport__unregister(kvm, bar_addr);
>>> +		break;
>>> +	case 1:
>>> +	case 2:
>>> +		success = kvm__deregister_mmio(kvm, bar_addr);
>>> +		/* kvm__deregister_mmio fails when the region is not found. */
>>> +		r = (success ? 0 : -ENOENT);
>>> +	}
>>> +
>>> +	return r;
>>> +}
>>> +
>>>  int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>  		     int device_id, int subsys_id, int class)
>>>  {
>>> @@ -476,23 +535,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>  	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>>>  
>>>  	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
>>> -	r = ioport__register(kvm, port_addr, &virtio_pci__io_ops, PCI_IO_SIZE,
>>> -			     vdev);
>>> -	if (r < 0)
>>> -		return r;
>>> -	port_addr = (u16)r;
>>> -
>>>  	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
>>> -	r = kvm__register_mmio(kvm, mmio_addr, PCI_IO_SIZE, false,
>>> -			       virtio_pci__io_mmio_callback, vdev);
>>> -	if (r < 0)
>>> -		goto free_ioport;
>>> -
>>>  	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
>>> -	r = kvm__register_mmio(kvm, msix_io_block, PCI_IO_SIZE * 2, false,
>>> -			       virtio_pci__msix_mmio_callback, vdev);
>>> -	if (r < 0)
>>> -		goto free_mmio;
>>>  
>>>  	vpci->pci_hdr = (struct pci_device_header) {
>>>  		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
>>> @@ -518,6 +562,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>  		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
>>>  	};
>>>  
>>> +	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
>>> +				      virtio_pci__bar_activate,
>>> +				      virtio_pci__bar_deactivate, vdev);
>>> +	if (r < 0)
>>> +		return r;
>>> +
>>>  	vpci->dev_hdr = (struct device_header) {
>>>  		.bus_type		= DEVICE_BUS_PCI,
>>>  		.data			= &vpci->pci_hdr,
>>> @@ -548,20 +598,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>>  
>>>  	r = device__register(&vpci->dev_hdr);
>>>  	if (r < 0)
>>> -		goto free_msix_mmio;
>>> +		return r;
>>>  
>>>  	/* save the IRQ that device__register() has allocated */
>>>  	vpci->legacy_irq_line = vpci->pci_hdr.irq_line;
>>>  
>>>  	return 0;
>>> -
>>> -free_msix_mmio:
>>> -	kvm__deregister_mmio(kvm, msix_io_block);
>>> -free_mmio:
>>> -	kvm__deregister_mmio(kvm, mmio_addr);
>>> -free_ioport:
>>> -	ioport__unregister(kvm, port_addr);
>>> -	return r;
>>>  }
>>>  
>>>  int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
>>>

