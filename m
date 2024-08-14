Return-Path: <kvm+bounces-24204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D74F0952538
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57BD61F22B31
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE08149E05;
	Wed, 14 Aug 2024 22:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzeIAHSA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B46149C69;
	Wed, 14 Aug 2024 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723673128; cv=none; b=gkekwPqTAEir93b0h2UXRvVVovv046dZvcfBODB2ROSbdarCCORxHqS+5NWnHZrdKS1lkb7TXje+rqPcpucMPQFw5gAYOOoFmpw+EY3UC9JjfnPDmnh5XDNNoZYL2mrWwp1geECo6xCwxTQIZglEAp3R9k8iGxrgrjnVwe9YcY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723673128; c=relaxed/simple;
	bh=/eyLRLDlp8r8LXHVDKIuiOzcvlXLulclSteHEeFFbEk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=GX+r9XJ8SN0GD2wGASfZQb2+TNna5D5ftj9823PqOZEhpjOehCvWsk87cCn4V2lUKpUaR3waqlsJ0hVjBUz10AUHoCBCxWCBA/+j8bnPst9vgHYAS9Lvlz8tNiCx/oaQRq+40lR0m+4px15yoez2YHHaPFA9U/IHBRsSAD1FnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzeIAHSA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848A5C4AF10;
	Wed, 14 Aug 2024 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723673128;
	bh=/eyLRLDlp8r8LXHVDKIuiOzcvlXLulclSteHEeFFbEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=nzeIAHSAIeUOu02BjNNFIFm6Upe0RuxT1cxSHfjBQJCXHoNs0jqIHACwOCY1NDouJ
	 NRNoyDusZrPyWrIjhp7eAO2+HwBLp1teATcolC4q3h4mXvfsuT0JGDfKvU4jwkCOq9
	 KMELQizUwhjyGwC8w4wYk9DGfAB68Sz5FgZHDisNXZYiZi7inzQWTHoBf8e2+VN+94
	 R7CKisV5V6MH0n0Bls0f2f0lHIEpZnXn7pGGo/sZ3Nun58HDpM4/AUGZxr/wrns8kG
	 0nSVumqqUJCxDJannO8UUZfpARO94BGUTdvfOGezaoZk7RC4MO9OiBYdcq5ijQgN9M
	 d4Dck2DAtVszA==
Date: Wed, 14 Aug 2024 17:05:25 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Stewart Hildebrand <stewart.hildebrand@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 8/8] PCI: Align small BARs
Message-ID: <20240814220525.GA11399@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88b86f1a-76e2-491f-bbd8-5d9332659d01@amd.com>

[+cc Alex, kvm list since this topic is of general interest for
passthrough; thread begins at
https://lore.kernel.org/r/20240807151723.613742-1-stewart.hildebrand@amd.com]

On Wed, Aug 14, 2024 at 09:55:26AM -0400, Stewart Hildebrand wrote:
> On 8/8/24 17:53, Bjorn Helgaas wrote:
> > On Wed, Aug 07, 2024 at 11:17:17AM -0400, Stewart Hildebrand wrote:
> >> In this context, "small" is defined as less than max(SZ_4K, PAGE_SIZE).
> >>
> >> Issues observed when small BARs are not sufficiently aligned are:
> >>
> >> 1. Devices to be passed through (to e.g. a Xen HVM guest) with small
> >> BARs require each memory BAR to be page aligned. Currently, the only way
> >> to guarantee this alignment from a user perspective is to fake the size
> >> of the BARs using the pci=resource_alignment= option. This is a bad user
> >> experience, and faking the BAR size is not always desirable. For
> >> example, pcitest is a tool that is useful for PCI passthrough validation
> >> with Xen, but pcitest fails with a fake BAR size.
> > 
> > I guess this is the "money" patch for the main problem you're solving,
> > i.e., passthrough to a guest doesn't work as you want?
> 
> Haha, yup!
> 
> > Is it the case that if you have two BARs in the same page, a device
> > can't be passed through to a guest at all?
> 
> If the conditions are just right, passing through such a device could
> maybe work, but in practice it's problematic and unlikely to work
> reliably across different configurations.
> 
> Let me show example 1, from a real device that I'm working with.
> Scrubbed/partial output from lspci -vv, from the host's point of view:
> 
> 	Region 0: Memory at d1924600 (32-bit, non-prefetchable) [size=256]
> 	Region 1: Memory at d1924400 (32-bit, non-prefetchable) [size=512]
> 	Region 2: Memory at d1924000 (32-bit, non-prefetchable) [size=1K]
> 	Region 3: Memory at d1920000 (32-bit, non-prefetchable) [size=16K]
> 	Region 4: Memory at d1900000 (32-bit, non-prefetchable) [size=128K]
> 	Region 5: Memory at d1800000 (32-bit, non-prefetchable) [size=1M]
> 	Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
> 		Vector table: BAR=0 offset=00000080
> 		PBA: BAR=0 offset=00000090
> 	Capabilities: [200 v1] Single Root I/O Virtualization (SR-IOV)
> 		IOVCap:	Migration-, Interrupt Message Number: 000
> 		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy+
> 		IOVSta:	Migration-
> 		Initial VFs: 4, Total VFs: 4, Number of VFs: 0, Function Dependency Link: 00
> 		VF offset: 6, stride: 1, Device ID: 0100
> 		Supported Page Size: 00000553, System Page Size: 00000001
> 		Region 0: Memory at 00000000d0800000 (64-bit, non-prefetchable)
> 		VF Migration: offset: 00000000, BIR: 0
> 	Kernel driver in use: pci-endpoint-test
> 	Kernel modules: pci_endpoint_test
> 
> BARs 0, 1, and 2 are small, and the host firmware placed them on the
> same page. The host firmware did not page align the BARs.
> 
> The hypervisor can only map full pages. The hypervisor cannot map
> partial pages. It cannot map a guest page offset from a host page where
> the offset is smaller than PAGE_SIZE.
> 
> To pass this device through (physfn) as-is, the hypervisor would need to
> preserve the page offsets of each BAR and propagate them to the guest,
> taking translation into account. The guest (both firmware + OS)
> necessarily has to preserve the offsets as well. If the page offsets
> aren't preserved, the guest would be accessing the wrong data.
> 
> We can't reliably predict what the guest behavior will be.
> 
> SeaBIOS aligns BARs to 4k [1].
> 
> [1] https://review.coreboot.org/plugins/gitiles/seabios/+/refs/tags/rel-1.16.3/src/fw/pciinit.c#28
> 
> Xen's hvmloader does not align BARs to 4k. A patch was submitted to fix
> this, but it wasn't merged upstream [2].
> 
> [2] https://lore.kernel.org/xen-devel/20200117110811.43321-1-roger.pau@citrix.com/
> 
> Arm guests don't usually have firmware to initialize BARs, so it's
> usually up to the OS (which may or may not be Linux).
> 
> The point is that there is not a consistent BAR initialization
> strategy/convention in the ecosystem when it comes to small BARs.
> 
> The host doesn't have a way to enforce the guest always map the small
> BARs at the required offsets. IMO the most sensible thing to do is not
> impose any sort of arbitrary page offset requirements on guests because
> it happened to suit the host.
> 
> If the host were to use fake BAR sizes via the current
> pci=resource_alignment=... option, the fake BAR size would propagate to
> the guest (lying to the guest), pcitest would break, and the guest can't
> do anything about it.
> 
> To avoid these problems, small BARs should be predictably page aligned
> in both host and guest.

Right, all the above makes sense to me.  I was fishing to see if vfio,
etc., actually checked for two BARs in the same page and disallowed
passthrough if that happened, but it doesn't sound like it.  It sounds
like things will just break, e.g., guest accesses data at incorrect
offsets, etc.

> > Or is it just that all
> > devices with BARs that share a page have to be passed through to the
> > same guest, sort of like how lack of ACS can force several devices to
> > be in the same IOMMU isolation group?
> 
> This case is much worse. If two devices have BARs sharing a page in a
> passthrough scenario, it's a security issue because guest can access
> data of another device. See XSA-461 / CVE-2024-31146 [3]. Aside: I was
> unaware that there was a XSA/CVE associated with this until after the
> embargo was lifted.

Yes.  IIUC, vfio etc *could* check for devices sharing a page and
force them to be passed through together, which I suppose would
mitigate this CVE.  But they don't in fact check.

> [3] https://lore.kernel.org/xen-devel/E1seE0f-0001zO-Nj@xenbits.xenproject.org/
> 
> For completeness, see example 2:
> 
> 01:00.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
>         Subsystem: Red Hat, Inc. QEMU Virtual Machine
>         Flags: fast devsel
>         Memory at fe800000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at c000 [size=256]
>         Memory at 7050000000 (64-bit, prefetchable) [size=32]
> 
> 01:01.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
>         Subsystem: Red Hat, Inc. QEMU Virtual Machine
>         Flags: fast devsel
>         Memory at fe801000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at c100 [size=256]
>         Memory at 7050000020 (64-bit, prefetchable) [size=32]
> 
> 01:02.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
>         Subsystem: Red Hat, Inc. QEMU Virtual Machine
>         Flags: fast devsel
>         Memory at fe802000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at c200 [size=256]
>         Memory at 7050000040 (64-bit, prefetchable) [size=32]
> 
> 01:03.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
>         Subsystem: Red Hat, Inc. QEMU Virtual Machine
>         Flags: fast devsel
>         Memory at fe803000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at c300 [size=256]
>         Memory at 7040000000 (64-bit, prefetchable) [size=256M]
> 
> This example can reproduced with Qemu's pci-testdev and a SeaBIOS hack.
> Add this to your usual qemu-system-x86_64 args:
> 
>     -device pcie-pci-bridge,id=pcie.1 \
>     -device pci-testdev,bus=pcie.1,membar=32 \
>     -device pci-testdev,bus=pcie.1,membar=32 \
>     -device pci-testdev,bus=pcie.1,membar=32 \
>     -device pci-testdev,bus=pcie.1,membar=268435456
> 
> Apply this SeaBIOS hack:
> 
> diff --git a/src/fw/pciinit.c b/src/fw/pciinit.c
> index b3e359d7..769007a4 100644
> --- a/src/fw/pciinit.c
> +++ b/src/fw/pciinit.c
> @@ -25,7 +25,7 @@
>  #include "util.h" // pci_setup
>  #include "x86.h" // outb
> 
> -#define PCI_DEVICE_MEM_MIN    (1<<12)  // 4k == page size
> +#define PCI_DEVICE_MEM_MIN    (0)
>  #define PCI_BRIDGE_MEM_MIN    (1<<21)  // 2M == hugepage size
>  #define PCI_BRIDGE_IO_MIN      0x1000  // mandated by pci bridge spec
> 
> 
> If you want to trigger the bridge window realloc (where BAR alignments
> currently get lost), also apply this hack to SeaBIOS in the same file:
> 
> @@ -1089,6 +1089,7 @@ pci_region_map_one_entry(struct pci_region_entry *entry, u64 addr)
>          pci_config_writew(bdf, PCI_MEMORY_LIMIT, limit >> PCI_MEMORY_SHIFT);
>      }
>      if (entry->type == PCI_REGION_TYPE_PREFMEM) {
> +        limit = addr + PCI_BRIDGE_MEM_MIN - 1;
>          pci_config_writew(bdf, PCI_PREF_MEMORY_BASE, addr >> PCI_PREF_MEMORY_SHIFT);
>          pci_config_writew(bdf, PCI_PREF_MEMORY_LIMIT, limit >> PCI_PREF_MEMORY_SHIFT);
>          pci_config_writel(bdf, PCI_PREF_BASE_UPPER32, addr >> 32);
> 
> > I think the subject should mention the problem to help motivate this.
> > 
> > The fact that we address this by potentially reassigning every BAR of
> > every device, regardless of whether the admin even wants to pass
> > through a device to a guest, seems a bit aggressive to me.
> 
> Patch [7/8] should limit the impact somewhat, but yes, it's quite
> aggressive... Perhaps such a change in default should be paired with the
> ability to turn it off via pci=realloc=off (or similar), and/or Kconfig.

I'm frankly pretty scared about reassigning every BAR by default.
Maybe my fear is unfounded, but I suspect things will break.

I'd be more comfortable if users had to specify a new option to get
this behavior, because then they would be aware of what they changed
and would be able to change back if it didn't work.  Or maybe if we
checked for page sharing and prevented passthrough in that case.

> > Previously we haven't trusted our reassignment machinery enough to
> > enable it all the time, so we still have the "pci=realloc" parameter.
> > By default, I don't think we even move devices around to make space
> > for a BAR that we failed to allocate.
> 
> One exception is SR-IOV device resources when
> CONFIG_PCI_REALLOC_ENABLE_AUTO=y.
> 
> > I agree "pci=resource_alignment=" is a bit user-unfriendly, and I
> > don't think it solves the problem unless we apply it to every device
> > in the system.
> 
> Right.
> 
> >> 2. Devices with multiple small BARs could have the MSI-X tables located
> >> in one of its small BARs. This may lead to the MSI-X tables being mapped
> >> in the same 4k region as other data. The PCIe 6.1 specification (section
> >> 7.7.2 MSI-X Capability and Table Structure) says we probably should
> >> avoid that.
> > 
> > If you're referring to this:
> > 
> >   If a Base Address Register or entry in the Enhanced Allocation
> >   capability that maps address space for the MSI-X Table or MSI-X PBA
> >   also maps other usable address space that is not associated with
> >   MSI-X structures, locations (e.g., for CSRs) used in the other
> >   address space must not share any naturally aligned 4-KB address
> >   range with one where either MSI-X structure resides. This allows
> >   system software where applicable to use different processor
> >   attributes for MSI-X structures and the other address space.
> 
> Yes, that's the correct reference.
> 
> > I think this is technically a requirement about how space within a
> > single BAR should be organized, not about how multiple BARs should be
> > assigned.  I don't think this really adds to the case for what you're
> > doing, so we could just drop it.
> 
> I'm OK to drop the reference to the spec. For completeness, example 1
> above was what led me to mention it: This device has the MSI-X tables
> located in BAR 0, which is mapped in the same 4k region as other data.
> 
> >> To improve the user experience (i.e. don't require the user to specify
> >> pci=resource_alignment=), and increase conformance to PCIe spec, set the
> >> default minimum resource alignment of memory BARs to the greater of 4k
> >> or PAGE_SIZE.
> >>
> >> Quoting the comment in
> >> drivers/pci/pci.c:pci_request_resource_alignment(), there are two ways
> >> we can increase the resource alignment:
> >>
> >> 1) Increase the size of the resource.  BARs are aligned on their
> >>    size, so when we reallocate space for this resource, we'll
> >>    allocate it with the larger alignment.  This also prevents
> >>    assignment of any other BARs inside the alignment region, so
> >>    if we're requesting page alignment, this means no other BARs
> >>    will share the page.
> >>
> >>    The disadvantage is that this makes the resource larger than
> >>    the hardware BAR, which may break drivers that compute things
> >>    based on the resource size, e.g., to find registers at a
> >>    fixed offset before the end of the BAR.
> >>
> >> 2) Retain the resource size, but use IORESOURCE_STARTALIGN and
> >>    set r->start to the desired alignment.  By itself this
> >>    doesn't prevent other BARs being put inside the alignment
> >>    region, but if we realign *every* resource of every device in
> >>    the system, none of them will share an alignment region.
> >>
> >> Changing pcibios_default_alignment() results in the second method of
> >> alignment with IORESOURCE_STARTALIGN.
> >>
> >> The new default alignment may be overridden by arches by implementing
> >> pcibios_default_alignment(), or by the user on a per-device basis with
> >> the pci=resource_alignment= option (although this reverts to using
> >> IORESOURCE_SIZEALIGN).
> >>
> >> Signed-off-by: Stewart Hildebrand <stewart.hildebrand@amd.com>
> >> ---
> >> Preparatory patches in this series are prerequisites to this patch.
> >>
> >> v2->v3:
> >> * new subject (was: "PCI: Align small (<4k) BARs")
> >> * clarify 4k vs PAGE_SIZE in commit message
> >>
> >> v1->v2:
> >> * capitalize subject text
> >> * s/4 * 1024/SZ_4K/
> >> * #include <linux/sizes.h>
> >> * update commit message
> >> * use max(SZ_4K, PAGE_SIZE) for alignment value
> >> ---
> >>  drivers/pci/pci.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> >> index af34407f2fb9..efdd5b85ea8c 100644
> >> --- a/drivers/pci/pci.c
> >> +++ b/drivers/pci/pci.c
> >> @@ -31,6 +31,7 @@
> >>  #include <asm/dma.h>
> >>  #include <linux/aer.h>
> >>  #include <linux/bitfield.h>
> >> +#include <linux/sizes.h>
> >>  #include "pci.h"
> >>  
> >>  DEFINE_MUTEX(pci_slot_mutex);
> >> @@ -6484,7 +6485,12 @@ struct pci_dev __weak *pci_real_dma_dev(struct pci_dev *dev)
> >>  
> >>  resource_size_t __weak pcibios_default_alignment(void)
> >>  {
> >> -	return 0;
> >> +	/*
> >> +	 * Avoid MSI-X tables being mapped in the same 4k region as other data
> >> +	 * according to PCIe 6.1 specification section 7.7.2 MSI-X Capability
> >> +	 * and Table Structure.
> >> +	 */
> > 
> > I think this is sort of a "spec compliance" comment that is not the
> > *real* reason we want to do this, i.e., it doesn't say that by doing
> > this we can pass through more devices to guests.
> > 
> > Doing this in pcibios_default_alignment() ends up being a very
> > non-obvious way to make this happen.  We have to:
> > 
> >   - Know what the purpose of this is, and the current comment doesn't
> >     point to that.
> > 
> >   - Look at all the implementations of pcibios_default_alignment()
> >     (thanks, powerpc).
> > 
> >   - Trace up through pci_specified_resource_alignment(), which
> >     contains a bunch of code that is not relevant to this case and
> >     always just returns PAGE_SIZE.
> > 
> >   - Trace up again to pci_reassigndev_resource_alignment() to see
> >     where this finally applies to the resources we care about.  The
> >     comment here about "check if specified PCI is target device" is
> >     actively misleading for the passthrough usage.
> > 
> > I hate adding new kernel parameters, but I kind of think this would be
> > easier if we added one that mentioned passthrough or guests and tested
> > it directly in pci_reassigndev_resource_alignment().
> > 
> > This would also be a way to avoid the "Can't reassign resources to
> > host bridge" warning that I think we're going to see all the time.
> 
> I did actually prepare a pci=resource_alignment=all patch, but I
> hesitated to send it because of the discussion at [4]. I'll send it with
> the next revision of the series.
> 
> [4] https://lore.kernel.org/linux-pci/20160929115422.GA31048@localhost/
> 
> I'd like to also propose introducing a Kconfig option, e.g.
> CONFIG_PCI_PAGE_ALIGN_BARS, selectable by menuconfig or other usual
> means.
> 
> >> +	return max(SZ_4K, PAGE_SIZE);
> >>  }
> >>  
> >>  /*
> >> -- 
> >> 2.46.0
> >>
> 

