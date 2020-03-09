Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32D717DA01
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 08:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCIHrh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 9 Mar 2020 03:47:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3416 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbgCIHrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 03:47:37 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 53883F98019EDB6AB92C;
        Mon,  9 Mar 2020 15:46:49 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.227]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0439.000;
 Mon, 9 Mar 2020 15:46:48 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
CC:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ziye.yang@intel.com" <ziye.yang@intel.com>,
        "changpeng.liu@intel.com" <changpeng.liu@intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "yan.y.zhao@intel.com" <yan.y.zhao@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v12 Kernel 0/7] KABIs to support migration for VFIO
 devices
Thread-Topic: [PATCH v12 Kernel 0/7] KABIs to support migration for VFIO
 devices
Thread-Index: AQHV3fN6EE9vp3iTJEm7N/h8s2q+yahAEQaA
Date:   Mon, 9 Mar 2020 07:46:48 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3421FAFF@dggemm526-mbx.china.huawei.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
In-Reply-To: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kirti:

What kind of platform/IO are you using now to do the basic code
verification?

I just want to check if I can verify it on my platform, and if any open
IO cards available? 

Thanks.

Regards
Zengtao 

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> On Behalf Of Kirti Wankhede
> Sent: Saturday, February 08, 2020 3:42 AM
> To: alex.williamson@redhat.com; cjia@nvidia.com
> Cc: kevin.tian@intel.com; ziye.yang@intel.com;
> changpeng.liu@intel.com; yi.l.liu@intel.com; mlevitsk@redhat.com;
> eskultet@redhat.com; cohuck@redhat.com; dgilbert@redhat.com;
> jonathan.davies@nutanix.com; eauger@redhat.com; aik@ozlabs.ru;
> pasic@linux.ibm.com; felipe@nutanix.com;
> Zhengxiao.zx@Alibaba-inc.com; shuangtai.tst@alibaba-inc.com;
> Ken.Xue@amd.com; zhi.a.wang@intel.com; yan.y.zhao@intel.com;
> qemu-devel@nongnu.org; kvm@vger.kernel.org; Kirti Wankhede
> Subject: [PATCH v12 Kernel 0/7] KABIs to support migration for VFIO
> devices
> 
> Hi,
> 
> This patch set adds:
> * New IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
>   respect to IOMMU container rather than per device. All pages pinned
> by
>   vendor driver through vfio_pin_pages external API has to be marked
> as
>   dirty during  migration. When IOMMU capable device is present in
> the
>   container and all pages are pinned and mapped, then all pages are
> marked
>   dirty.
>   When there are CPU writes, CPU dirty page tracking can identify
> dirtied
>   pages, but any page pinned by vendor driver can also be written by
>   device. As of now there is no device which has hardware support for
>   dirty page tracking. So all pages which are pinned should be
> considered
>   as dirty.
>   This ioctl is also used to start/stop dirty pages tracking for pinned and
>   unpinned pages while migration is active.
> 
> * Updated IOCTL VFIO_IOMMU_UNMAP_DMA to get dirty pages bitmap
> before
>   unmapping IO virtual address range.
>   With vIOMMU, during pre-copy phase of migration, while CPUs are
> still
>   running, IO virtual address unmap can happen while device still
> keeping
>   reference of guest pfns. Those pages should be reported as dirty
> before
>   unmap, so that VFIO user space application can copy content of those
>   pages from source to destination.
> 
> * Patch 7 is proposed change to detect if IOMMU capable device driver is
>   smart to report pages to be marked dirty by pinning pages using
>   vfio_pin_pages() API.
> 
> 
> Yet TODO:
> Since there is no device which has hardware support for system
> memmory
> dirty bitmap tracking, right now there is no other API from vendor driver
> to VFIO IOMMU module to report dirty pages. In future, when such
> hardware
> support will be implemented, an API will be required such that vendor
> driver could report dirty pages to VFIO module during migration phases.
> 
> Adding revision history from previous QEMU patch set to understand
> KABI
> changes done till now
> 
> v11 -> v12
> - Changed bitmap allocation in vfio_iommu_type1.
> - Remove atomicity of ref_count.
> - Updated comments for migration device state structure about error
>   reporting.
> - Nit picks from v11 reviews
> 
> v10 -> v11
> - Fix pin pages API to free vpfn if it is marked as unpinned tracking page.
> - Added proposal to detect if IOMMU capable device calls external pin
> pages
>   API to mark pages dirty.
> - Nit picks from v10 reviews
> 
> v9 -> v10:
> - Updated existing VFIO_IOMMU_UNMAP_DMA ioctl to get dirty pages
> bitmap
>   during unmap while migration is active
> - Added flag in VFIO_IOMMU_GET_INFO to indicate driver support dirty
> page
>   tracking.
> - If iommu_mapped, mark all pages dirty.
> - Added unpinned pages tracking while migration is active.
> - Updated comments for migration device state structure with bit
>   combination table and state transition details.
> 
> v8 -> v9:
> - Split patch set in 2 sets, Kernel and QEMU.
> - Dirty pages bitmap is queried from IOMMU container rather than from
>   vendor driver for per device. Added 2 ioctls to achieve this.
> 
> v7 -> v8:
> - Updated comments for KABI
> - Added BAR address validation check during PCI device's config space
> load
>   as suggested by Dr. David Alan Gilbert.
> - Changed vfio_migration_set_state() to set or clear device state flags.
> - Some nit fixes.
> 
> v6 -> v7:
> - Fix build failures.
> 
> v5 -> v6:
> - Fix build failure.
> 
> v4 -> v5:
> - Added decriptive comment about the sequence of access of members
> of
>   structure vfio_device_migration_info to be followed based on Alex's
>   suggestion
> - Updated get dirty pages sequence.
> - As per Cornelia Huck's suggestion, added callbacks to VFIODeviceOps to
>   get_object, save_config and load_config.
> - Fixed multiple nit picks.
> - Tested live migration with multiple vfio device assigned to a VM.
> 
> v3 -> v4:
> - Added one more bit for _RESUMING flag to be set explicitly.
> - data_offset field is read-only for user space application.
> - data_size is read for every iteration before reading data from
> migration,
>   that is removed assumption that data will be till end of migration
>   region.
> - If vendor driver supports mappable sparsed region, map those region
>   during setup state of save/load, similarly unmap those from cleanup
>   routines.
> - Handles race condition that causes data corruption in migration region
>   during save device state by adding mutex and serialiaing save_buffer
> and
>   get_dirty_pages routines.
> - Skip called get_dirty_pages routine for mapped MMIO region of device.
> - Added trace events.
> - Split into multiple functional patches.
> 
> v2 -> v3:
> - Removed enum of VFIO device states. Defined VFIO device state with 2
>   bits.
> - Re-structured vfio_device_migration_info to keep it minimal and
> defined
>   action on read and write access on its members.
> 
> v1 -> v2:
> - Defined MIGRATION region type and sub-type which should be used
> with
>   region type capability.
> - Re-structured vfio_device_migration_info. This structure will be placed
>   at 0th offset of migration region.
> - Replaced ioctl with read/write for trapped part of migration region.
> - Added both type of access support, trapped or mmapped, for data
> section
>   of the region.
> - Moved PCI device functions to pci file.
> - Added iteration to get dirty page bitmap until bitmap for all requested
>   pages are copied.
> 
> Thanks,
> Kirti
> 
> 
> Kirti Wankhede (7):
>   vfio: KABI for migration interface for device state
>   vfio iommu: Remove atomicity of ref_count of pinned pages
>   vfio iommu: Add ioctl definition for dirty pages tracking.
>   vfio iommu: Implementation of ioctl to for dirty pages tracking.
>   vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before
> unmap
>   vfio iommu: Adds flag to indicate dirty pages tracking capability
>     support
>   vfio: Selective dirty page tracking if IOMMU backed device pins pages
> 
>  drivers/vfio/vfio.c             |  13 +-
>  drivers/vfio/vfio_iommu_type1.c | 435
> +++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h            |   4 +-
>  include/uapi/linux/vfio.h       | 267 +++++++++++++++++++++++-
>  4 files changed, 692 insertions(+), 27 deletions(-)
> 
> --
> 2.7.0

