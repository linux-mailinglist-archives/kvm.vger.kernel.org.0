Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFAE3945CE
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 18:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhE1QZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 12:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbhE1QZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 12:25:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CD3C06174A
        for <kvm@vger.kernel.org>; Fri, 28 May 2021 09:23:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id f11so3890583wrq.1
        for <kvm@vger.kernel.org>; Fri, 28 May 2021 09:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wYE+uy4fqjzh0FabDI1OaNUi4O4pTiL3a78MiERsKfk=;
        b=F/lh18+D+v2Wc+xRGhb9R10y7tpBgLSFXd272O8YLR6MiuZXK+yf2jGz/YHQt8bq5u
         YKnGhGuPcCUeLV7rqks826/CoERT0mI2z0hksmWtJJAU03vWCgYPjFAWMMYw2VlcGHRQ
         Bk1aJFd/ByflxIsWuSgiGWZowQCC4fUrnm/2SMk+uiKgHKYBcH+V2t/iX7tlpvJZRmvi
         irtn7MqBzXSPnSzr3SARgA/RQz2NXQ3NKfuV8KCKJjAgSZaMVeiHpF+U56QASLHsHR1n
         YROmR8hIOOACRHXxkUh8Y0awyuCwbgHU2Go7j/qehzp74ZE3q9bysi7w6KlHg4V8JmoB
         OrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wYE+uy4fqjzh0FabDI1OaNUi4O4pTiL3a78MiERsKfk=;
        b=LRwJHBbU3S0bxlgDSUpUr9B6ddMIw34VUOi/6AiUuwiIp0KlysU4E8b1RhU0RKVAHo
         7kVswJNRbv5Hu/nDSTEyeh8TUPGNpnKEgGEVi+jN5drwKxiZ6+5Y0LwJEMSS4HqkB0TW
         hFVx+TR/X6oooPsfpLuPGyqy150YPxgR1CLUt3Sj2CtUpb50EMr8nb56f42xwwWS9oiv
         9MqHudBkTPGOydO2zg7S5eBo0GKoYQ02Qt4tZ+BKrX1pUVVisYFzfqcjSJkAenJaE728
         zHuOZ0MWqGU5WBrLPhB5nSOeKqy0/yTS4DDLV36k2jdwg/y4V1etYeY1RiOI/jfuiFBD
         ZnwQ==
X-Gm-Message-State: AOAM532GDcr4hJTc4YF+kG1DWdnr0QOHNM9jqu7wDRRa7NNXRDulWpAX
        Mb1wAHRqmo/qc2Nbdj2UfeTxPg==
X-Google-Smtp-Source: ABdhPJylZV7BPQmllXDDSehinOUXuhv7QOgV6qyByqopbZz4Sn3x0me6lMgWyFJWjr3gxZDMHK/jqg==
X-Received: by 2002:adf:ebc4:: with SMTP id v4mr9505965wrn.217.1622219007367;
        Fri, 28 May 2021 09:23:27 -0700 (PDT)
Received: from myrica (adsl-84-226-106-126.adslplus.ch. [84.226.106.126])
        by smtp.gmail.com with ESMTPSA id 89sm2482621wri.94.2021.05.28.09.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 09:23:26 -0700 (PDT)
Date:   Fri, 28 May 2021 18:23:07 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YLEY6yAF1osdtS3e@myrica>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> /dev/ioasid provides an unified interface for managing I/O page tables for 
> devices assigned to userspace. Device passthrough frameworks (VFIO, vDPA, 
> etc.) are expected to use this interface instead of creating their own logic to 
> isolate untrusted device DMAs initiated by userspace. 
> 
> This proposal describes the uAPI of /dev/ioasid and also sample sequences 
> with VFIO as example in typical usages. The driver-facing kernel API provided 
> by the iommu layer is still TBD, which can be discussed after consensus is 
> made on this uAPI.
> 
> It's based on a lengthy discussion starting from here:
> 	https://lore.kernel.org/linux-iommu/20210330132830.GO2356281@nvidia.com/ 
> 
> It ends up to be a long writing due to many things to be summarized and
> non-trivial effort required to connect them into a complete proposal.
> Hope it provides a clean base to converge.

Firstly thanks for writing this up and for your patience. I've not read in
detail the second half yet, will take another look later.

> 1. Terminologies and Concepts
> -----------------------------------------
> 
> IOASID FD is the container holding multiple I/O address spaces. User 
> manages those address spaces through FD operations. Multiple FD's are 
> allowed per process, but with this proposal one FD should be sufficient for 
> all intended usages.
> 
> IOASID is the FD-local software handle representing an I/O address space. 
> Each IOASID is associated with a single I/O page table. IOASIDs can be 
> nested together, implying the output address from one I/O page table 
> (represented by child IOASID) must be further translated by another I/O 
> page table (represented by parent IOASID).
> 
> I/O address space can be managed through two protocols, according to 
> whether the corresponding I/O page table is constructed by the kernel or 
> the user. When kernel-managed, a dma mapping protocol (similar to 
> existing VFIO iommu type1) is provided for the user to explicitly specify 
> how the I/O address space is mapped. Otherwise, a different protocol is 
> provided for the user to bind an user-managed I/O page table to the 
> IOMMU, plus necessary commands for iotlb invalidation and I/O fault 
> handling. 
> 
> Pgtable binding protocol can be used only on the child IOASID's, implying 
> IOASID nesting must be enabled. This is because the kernel doesn't trust 
> userspace. Nesting allows the kernel to enforce its DMA isolation policy 
> through the parent IOASID.
> 
> IOASID nesting can be implemented in two ways: hardware nesting and 
> software nesting. With hardware support the child and parent I/O page 
> tables are walked consecutively by the IOMMU to form a nested translation. 
> When it's implemented in software, the ioasid driver is responsible for 
> merging the two-level mappings into a single-level shadow I/O page table. 
> Software nesting requires both child/parent page tables operated through 
> the dma mapping protocol, so any change in either level can be captured 
> by the kernel to update the corresponding shadow mapping.

Is there an advantage to moving software nesting into the kernel?
We could just have the guest do its usual combined map/unmap on the child
fd

> 
> An I/O address space takes effect in the IOMMU only after it is attached 
> to a device. The device in the /dev/ioasid context always refers to a 
> physical one or 'pdev' (PF or VF). 
> 
> One I/O address space could be attached to multiple devices. In this case, 
> /dev/ioasid uAPI applies to all attached devices under the specified IOASID.
> 
> Based on the underlying IOMMU capability one device might be allowed 
> to attach to multiple I/O address spaces, with DMAs accessing them by 
> carrying different routing information. One of them is the default I/O 
> address space routed by PCI Requestor ID (RID) or ARM Stream ID. The 
> remaining are routed by RID + Process Address Space ID (PASID) or 
> Stream+Substream ID. For simplicity the following context uses RID and
> PASID when talking about the routing information for I/O address spaces.
> 
> Device attachment is initiated through passthrough framework uAPI (use
> VFIO for simplicity in following context). VFIO is responsible for identifying 
> the routing information and registering it to the ioasid driver when calling 
> ioasid attach helper function. It could be RID if the assigned device is 
> pdev (PF/VF) or RID+PASID if the device is mediated (mdev). In addition, 
> user might also provide its view of virtual routing information (vPASID) in 
> the attach call, e.g. when multiple user-managed I/O address spaces are 
> attached to the vfio_device. In this case VFIO must figure out whether 
> vPASID should be directly used (for pdev) or converted to a kernel-
> allocated one (pPASID, for mdev) for physical routing (see section 4).
> 
> Device must be bound to an IOASID FD before attach operation can be
> conducted. This is also through VFIO uAPI. In this proposal one device 
> should not be bound to multiple FD's. Not sure about the gain of 
> allowing it except adding unnecessary complexity. But if others have 
> different view we can further discuss.
> 
> VFIO must ensure its device composes DMAs with the routing information
> attached to the IOASID. For pdev it naturally happens since vPASID is 
> directly programmed to the device by guest software. For mdev this 
> implies any guest operation carrying a vPASID on this device must be 
> trapped into VFIO and then converted to pPASID before sent to the 
> device. A detail explanation about PASID virtualization policies can be 
> found in section 4. 
> 
> Modern devices may support a scalable workload submission interface 
> based on PCI DMWr capability, allowing a single work queue to access
> multiple I/O address spaces. One example is Intel ENQCMD, having 
> PASID saved in the CPU MSR and carried in the instruction payload 
> when sent out to the device. Then a single work queue shared by 
> multiple processes can compose DMAs carrying different PASIDs. 
> 
> When executing ENQCMD in the guest, the CPU MSR includes a vPASID 
> which, if targeting a mdev, must be converted to pPASID before sent
> to the wire. Intel CPU provides a hardware PASID translation capability 
> for auto-conversion in the fast path. The user is expected to setup the 
> PASID mapping through KVM uAPI, with information about {vpasid, 
> ioasid_fd, ioasid}. The ioasid driver provides helper function for KVM 
> to figure out the actual pPASID given an IOASID.
> 
> With above design /dev/ioasid uAPI is all about I/O address spaces. 
> It doesn't include any device routing information, which is only 
> indirectly registered to the ioasid driver through VFIO uAPI. For 
> example, I/O page fault is always reported to userspace per IOASID, 
> although it's physically reported per device (RID+PASID). If there is a 
> need of further relaying this fault into the guest, the user is responsible 
> of identifying the device attached to this IOASID (randomly pick one if 
> multiple attached devices)

We need to report accurate information for faults. If the guest tells
device A to DMA, it shouldn't receive a fault report for device B. This is
important if the guest needs to kill a misbehaving device, or even just
for statistics and debugging. It may also simplify routing the page
response, which has to be fast.

> and then generates a per-device virtual I/O 
> page fault into guest. Similarly the iotlb invalidation uAPI describes the 
> granularity in the I/O address space (all, or a range), different from the 
> underlying IOMMU semantics (domain-wide, PASID-wide, range-based).
> 
> I/O page tables routed through PASID are installed in a per-RID PASID 
> table structure. Some platforms implement the PASID table in the guest 
> physical space (GPA), expecting it managed by the guest. The guest
> PASID table is bound to the IOMMU also by attaching to an IOASID, 
> representing the per-RID vPASID space. 
> 
> We propose the host kernel needs to explicitly track  guest I/O page 
> tables even on these platforms, i.e. the same pgtable binding protocol 
> should be used universally on all platforms (with only difference on who 
> actually writes the PASID table).

This adds significant complexity for Arm (and AMD). Userspace will now
need to walk the PASID table, serializing against invalidation. At least
the SMMU has caching mode for PASID tables so there is no need to trap,
but I'd rather avoid this. I really don't want to make virtio-iommu
devices walk PASID tables unless absolutely necessary, they need to stay
simple.

> One opinion from previous discussion 
> was treating this special IOASID as a container for all guest I/O page 
> tables i.e. hiding them from the host. However this way significantly 
> violates the philosophy in this /dev/ioasid proposal.

It does correspond better to the underlying architecture and hardware
implementation, of which userspace is well aware since it has to report
them to the guest and deal with different descriptor formats.

> It is not one IOASID 
> one address space any more. Device routing information (indirectly 
> marking hidden I/O spaces) has to be carried in iotlb invalidation and 
> page faulting uAPI to help connect vIOMMU with the underlying 
> pIOMMU.

As above, I think it's essential that we carry device information in fault
reports. In addition to the two previous reasons, on these platforms
userspace will route all faults through the same channel (vIOMMU event
queue) regardless of the PASID, so we do not need them split and tracked
by PASID. Given that IOPF will be a hot path we should make sure there is
no unnecessary indirection.

Regarding the invalidation, I think limiting it to IOASID may work but it
does bother me that we can't directly forward all invalidations received
on the vIOMMU: if the guest sends a device-wide invalidation, do we
iterate over all IOASIDs and issue one ioctl for each?  Sure the guest is
probably sending that because of detaching the PASID table, for which the
kernel did perform the invalidation, but we can't just assume that and
ignore the request, there may be a different reason. Iterating is going to
take a lot time, whereas with the current API we can send a single request
and issue a single command to the IOMMU hardware.

Similarly, if the guest sends an ATC invalidation for a whole device (in
the SMMU, that's an ATC_INV without SSID), we'll have to transform that
into multiple IOTLB invalidations?  We can't just send it on IOASID #0,
because it may not have been created by the guest.

Maybe we could at least have invalidation requests on the parent fd for
this kind of global case?  But I'd much rather avoid the PASID tracking
altogether and keep the existing cache invalidate API, let the pIOMMU
driver decode that stuff.

> This is one design choice to be confirmed with ARM guys.
> 
> Devices may sit behind IOMMU's with incompatible capabilities. The
> difference may lie in the I/O page table format, or availability of an user
> visible uAPI (e.g. hardware nesting). /dev/ioasid is responsible for 
> checking the incompatibility between newly-attached device and existing
> devices under the specific IOASID and, if found, returning error to user.
> Upon such error the user should create a new IOASID for the incompatible
> device. 
> 
> There is no explicit group enforcement in /dev/ioasid uAPI, due to no 
> device notation in this interface as aforementioned. But the ioasid driver 
> does implicit check to make sure that devices within an iommu group 
> must be all attached to the same IOASID before this IOASID starts to
> accept any uAPI command. Otherwise error information is returned to 
> the user.
> 
> There was a long debate in previous discussion whether VFIO should keep 
> explicit container/group semantics in its uAPI. Jason Gunthorpe proposes 
> a simplified model where every device bound to VFIO is explicitly listed 
> under /dev/vfio thus a device fd can be acquired w/o going through legacy
> container/group interface. In this case the user is responsible for 
> understanding the group topology and meeting the implicit group check 
> criteria enforced in /dev/ioasid. The use case examples in this proposal 
> are based on the new model.
> 
> Of course for backward compatibility VFIO still needs to keep the existing 
> uAPI and vfio iommu type1 will become a shim layer connecting VFIO 
> iommu ops to internal ioasid helper functions.
> 
> Notes:
> -   It might be confusing as IOASID is also used in the kernel (drivers/
>     iommu/ioasid.c) to represent PCI PASID or ARM substream ID. We need
>     find a better name later to differentiate.

Yes this isn't just about allocating PASIDs anymore. /dev/iommu or
/dev/ioas would make more sense.

> 
> -   PPC has not be considered yet as we haven't got time to fully understand
>     its semantics. According to previous discussion there is some generality 
>     between PPC window-based scheme and VFIO type1 semantics. Let's 
>     first make consensus on this proposal and then further discuss how to 
>     extend it to cover PPC's requirement.
> 
> -   There is a protocol between vfio group and kvm. Needs to think about
>     how it will be affected following this proposal.

(Arm also needs this, obtaining the VMID allocated by KVM and write it to
the SMMU descriptor when installing the PASID table
https://lore.kernel.org/linux-iommu/20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com/)

> 
> -   mdev in this context refers to mediated subfunctions (e.g. Intel SIOV) 
>     which can be physically isolated in-between through PASID-granular
>     IOMMU protection. Historically people also discussed one usage by 
>     mediating a pdev into a mdev. This usage is not covered here, and is 
>     supposed to be replaced by Max's work which allows overriding various 
>     VFIO operations in vfio-pci driver.
> 
> 2. uAPI Proposal
> ----------------------
[...]

> /*
>   * Get information about an I/O address space
>   *
>   * Supported capabilities:
>   *	- VFIO type1 map/unmap;
>   *	- pgtable/pasid_table binding
>   *	- hardware nesting vs. software nesting;
>   *	- ...
>   *
>   * Related attributes:
>   * 	- supported page sizes, reserved IOVA ranges (DMA mapping);
>   *	- vendor pgtable formats (pgtable binding);
>   *	- number of child IOASIDs (nesting);
>   *	- ...
>   *
>   * Above information is available only after one or more devices are
>   * attached to the specified IOASID. Otherwise the IOASID is just a
>   * number w/o any capability or attribute.
>   *
>   * Input parameters:
>   *	- u32 ioasid;
>   *
>   * Output parameters:
>   *	- many. TBD.

We probably need a capability format similar to PCI and VFIO.

>   */
> #define IOASID_GET_INFO	_IO(IOASID_TYPE, IOASID_BASE + 5)
[...]

> 2.2. /dev/vfio uAPI
> ++++++++++++++++
> 
> /*
>   * Bind a vfio_device to the specified IOASID fd
>   *
>   * Multiple vfio devices can be bound to a single ioasid_fd, but a single 
>   * vfio device should not be bound to multiple ioasid_fd's. 
>   *
>   * Input parameters:
>   *	- ioasid_fd;

How about adding a 32-bit "virtual RID" at this point, that the kernel can
provide to userspace during fault reporting?

Thanks,
Jean

>   *
>   * Return: 0 on success, -errno on failure.
>   */
> #define VFIO_BIND_IOASID_FD		_IO(VFIO_TYPE, VFIO_BASE + 22)
> #define VFIO_UNBIND_IOASID_FD	_IO(VFIO_TYPE, VFIO_BASE + 23)

