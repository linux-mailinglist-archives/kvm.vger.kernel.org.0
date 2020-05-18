Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80B31D6F49
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgERDSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:18:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2924 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgERDSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:18:16 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec1fe290000>; Sun, 17 May 2020 20:16:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 17 May 2020 20:18:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 17 May 2020 20:18:14 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 May
 2020 03:18:04 +0000
Subject: Re: [PATCH Kernel v21 0/8] Add UAPIs to support migration for VFIO
 devices
To:     Xiang Zheng <zhengxiang9@huawei.com>, <yan.y.zhao@intel.com>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, Wang Haibin <wanghaibin.wang@huawei.com>,
        <prime.zeng@hisilicon.com>
References: <1589577203-20640-1-git-send-email-kwankhede@nvidia.com>
 <689be011-4de4-6bfb-f2bb-8bb98046b9cb@huawei.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b8cea91e-df8c-41ba-323d-37793db25a8e@nvidia.com>
Date:   Mon, 18 May 2020 08:48:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <689be011-4de4-6bfb-f2bb-8bb98046b9cb@huawei.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589771817; bh=UjaixRgK+VgzjSZBMZoL6THdQ4iQ85fCXABC5EAKYl8=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UQdienXom0Epgme1lNXL6T0viozZtlsCHOLy5sX6lcC4YzbC4ItjFoIMjsqwXVoi9
         Ff21N/8YylOV+MVOdDxVRO3SpodH3Hi5PX0r5lxkq3FdPBVk2M4WD11ZoVMsZ0WhRZ
         H8oLziZEv4j14yjF6WvPn4+goeu0y0GGQ+3SdssCsKOHccHAH9sufuHpu2z+IL/FAU
         cJ0gs9NmMui+k8DjF0h74Yh4JkB+u/fsoetUyDpXlH9M3NGl3Hdy/CNMal7Jxr0vDr
         VbvxYK+kauWd8OtO6SKe6/JbR/XrfvSOPTtPS41o+pz1V2dh8wT+SZ1qnK4K4amyMk
         bpzao6ArXTOBQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/18/2020 8:09 AM, Xiang Zheng wrote:
> Hi Kirti and Yan,
>=20
> How can I test this patch series on my SR-IOV devices?
> I have looked through Yan's pathes for i40e VF live migration support=EF=
=BC=9A
>      https://patchwork.kernel.org/patch/11375177/
> =09
> However, I cannot find the detailed implementation about device state
> saving/restoring and dirty page logging.

Details of device state transitions, how user application should use=20
UAPI and how vendor driver should behave are mentioned in the comment of=20
UAPI:
https://lore.kernel.org/kvm/1589577203-20640-2-git-send-email-kwankhede@nvi=
dia.com/

> Has i40e hardware already supported
> these two features?
>=20
> And if once a device supports both features, how to implement live
> migration for this device via this series patch?
>=20

Here is the patch-set which adds migration support to mtty sample=20
device, you can refer to see how to implement on driver side:
https://lore.kernel.org/kvm/1588614860-16330-1-git-send-email-kwankhede@nvi=
dia.com/

I'm working on preparing QEMU patches for v21 and will be sending out soon.

Thanks,
Kirti

> On 2020/5/16 5:13, Kirti Wankhede wrote:
>> Hi,
>>
>> This patch set adds:
>> * IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
>>    respect to IOMMU container rather than per device. All pages pinned b=
y
>>    vendor driver through vfio_pin_pages external API has to be marked as
>>    dirty during  migration. When IOMMU capable device is present in the
>>    container and all pages are pinned and mapped, then all pages are mar=
ked
>>    dirty.
>>    When there are CPU writes, CPU dirty page tracking can identify dirti=
ed
>>    pages, but any page pinned by vendor driver can also be written by
>>    device. As of now there is no device which has hardware support for
>>    dirty page tracking. So all pages which are pinned should be consider=
ed
>>    as dirty.
>>    This ioctl is also used to start/stop dirty pages tracking for pinned=
 and
>>    unpinned pages while migration is active.
>>
>> * Updated IOCTL VFIO_IOMMU_UNMAP_DMA to get dirty pages bitmap before
>>    unmapping IO virtual address range.
>>    With vIOMMU, during pre-copy phase of migration, while CPUs are still
>>    running, IO virtual address unmap can happen while device still keepi=
ng
>>    reference of guest pfns. Those pages should be reported as dirty befo=
re
>>    unmap, so that VFIO user space application can copy content of those
>>    pages from source to destination.
>>
>> * Patch 8 detect if IOMMU capable device driver is smart to report pages
>>    to be marked dirty by pinning pages using vfio_pin_pages() API.
>>
>>
>> Yet TODO:
>> Since there is no device which has hardware support for system memmory
>> dirty bitmap tracking, right now there is no other API from vendor drive=
r
>> to VFIO IOMMU module to report dirty pages. In future, when such hardwar=
e
>> support will be implemented, an API will be required such that vendor
>> driver could report dirty pages to VFIO module during migration phases.
>>
>> Adding revision history from previous QEMU patch set to understand KABI
>> changes done till now
>>
>> v20 -> v21
>> - Added checkin for GET_BITMAP ioctl for vfio_dma boundaries.
>> - Updated unmap ioctl function - as suggested by Alex.
>> - Updated comments in DIRTY_TRACKING ioctl definition - as suggested by
>>    Cornelia.
>>
>> v19 -> v20
>> - Fixed ioctl to get dirty bitmap to get bitmap of multiple vfio_dmas
>> - Fixed unmap ioctl to get dirty bitmap of multiple vfio_dmas.
>> - Removed flag definition from migration capability.
>>
>> v18 -> v19
>> - Updated migration capability with supported page sizes bitmap for dirt=
y
>>    page tracking and  maximum bitmap size supported by kernel module.
>> - Added patch to calculate and cache pgsize_bitmap when iommu->domain_li=
st
>>    is updated.
>> - Removed extra buffers added in previous version for bitmap manipulatio=
n
>>    and optimised the code.
>>
>> v17 -> v18
>> - Add migration capability to the capability chain for VFIO_IOMMU_GET_IN=
FO
>>    ioctl
>> - Updated UMAP_DMA ioctl to return bitmap of multiple vfio_dma
>>
>> v16 -> v17
>> - Fixed errors reported by kbuild test robot <lkp@intel.com> on i386
>>
>> v15 -> v16
>> - Minor edits and nit picks (Auger Eric)
>> - On copying bitmap to user, re-populated bitmap only for pinned pages,
>>    excluding unmapped pages and CPU dirtied pages.
>> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>>    https://lkml.org/lkml/2020/3/12/1255
>>
>> v14 -> v15
>> - Minor edits and nit picks.
>> - In the verification of user allocated bitmap memory, added check of
>>     maximum size.
>> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>>    https://lkml.org/lkml/2020/3/12/1255
>>
>> v13 -> v14
>> - Added struct vfio_bitmap to kabi. updated structure
>>    vfio_iommu_type1_dirty_bitmap_get and vfio_iommu_type1_dma_unmap.
>> - All small changes suggested by Alex.
>> - Patches are on tag: next-20200318 and 1-3 patches from Yan's series
>>    https://lkml.org/lkml/2020/3/12/1255
>>
>> v12 -> v13
>> - Changed bitmap allocation in vfio_iommu_type1 to per vfio_dma
>> - Changed VFIO_IOMMU_DIRTY_PAGES ioctl behaviour to be per vfio_dma rang=
e.
>> - Changed vfio_iommu_type1_dirty_bitmap structure to have separate data
>>    field.
>>
>> v11 -> v12
>> - Changed bitmap allocation in vfio_iommu_type1.
>> - Remove atomicity of ref_count.
>> - Updated comments for migration device state structure about error
>>    reporting.
>> - Nit picks from v11 reviews
>>
>> v10 -> v11
>> - Fix pin pages API to free vpfn if it is marked as unpinned tracking pa=
ge.
>> - Added proposal to detect if IOMMU capable device calls external pin pa=
ges
>>    API to mark pages dirty.
>> - Nit picks from v10 reviews
>>
>> v9 -> v10:
>> - Updated existing VFIO_IOMMU_UNMAP_DMA ioctl to get dirty pages bitmap
>>    during unmap while migration is active
>> - Added flag in VFIO_IOMMU_GET_INFO to indicate driver support dirty pag=
e
>>    tracking.
>> - If iommu_mapped, mark all pages dirty.
>> - Added unpinned pages tracking while migration is active.
>> - Updated comments for migration device state structure with bit
>>    combination table and state transition details.
>>
>> v8 -> v9:
>> - Split patch set in 2 sets, Kernel and QEMU.
>> - Dirty pages bitmap is queried from IOMMU container rather than from
>>    vendor driver for per device. Added 2 ioctls to achieve this.
>>
>> v7 -> v8:
>> - Updated comments for KABI
>> - Added BAR address validation check during PCI device's config space lo=
ad
>>    as suggested by Dr. David Alan Gilbert.
>> - Changed vfio_migration_set_state() to set or clear device state flags.
>> - Some nit fixes.
>>
>> v6 -> v7:
>> - Fix build failures.
>>
>> v5 -> v6:
>> - Fix build failure.
>>
>> v4 -> v5:
>> - Added decriptive comment about the sequence of access of members of
>>    structure vfio_device_migration_info to be followed based on Alex's
>>    suggestion
>> - Updated get dirty pages sequence.
>> - As per Cornelia Huck's suggestion, added callbacks to VFIODeviceOps to
>>    get_object, save_config and load_config.
>> - Fixed multiple nit picks.
>> - Tested live migration with multiple vfio device assigned to a VM.
>>
>> v3 -> v4:
>> - Added one more bit for _RESUMING flag to be set explicitly.
>> - data_offset field is read-only for user space application.
>> - data_size is read for every iteration before reading data from migrati=
on,
>>    that is removed assumption that data will be till end of migration
>>    region.
>> - If vendor driver supports mappable sparsed region, map those region
>>    during setup state of save/load, similarly unmap those from cleanup
>>    routines.
>> - Handles race condition that causes data corruption in migration region
>>    during save device state by adding mutex and serialiaing save_buffer =
and
>>    get_dirty_pages routines.
>> - Skip called get_dirty_pages routine for mapped MMIO region of device.
>> - Added trace events.
>> - Split into multiple functional patches.
>>
>> v2 -> v3:
>> - Removed enum of VFIO device states. Defined VFIO device state with 2
>>    bits.
>> - Re-structured vfio_device_migration_info to keep it minimal and define=
d
>>    action on read and write access on its members.
>>
>> v1 -> v2:
>> - Defined MIGRATION region type and sub-type which should be used with
>>    region type capability.
>> - Re-structured vfio_device_migration_info. This structure will be place=
d
>>    at 0th offset of migration region.
>> - Replaced ioctl with read/write for trapped part of migration region.
>> - Added both type of access support, trapped or mmapped, for data sectio=
n
>>    of the region.
>> - Moved PCI device functions to pci file.
>> - Added iteration to get dirty page bitmap until bitmap for all requeste=
d
>>    pages are copied.
>>
>> Thanks,
>> Kirti
>>
>>
>>
>> Kirti Wankhede (8):
>>    vfio: UAPI for migration interface for device state
>>    vfio iommu: Remove atomicity of ref_count of pinned pages
>>    vfio iommu: Cache pgsize_bitmap in struct vfio_iommu
>>    vfio iommu: Add ioctl definition for dirty pages tracking
>>    vfio iommu: Implementation of ioctl for dirty pages tracking
>>    vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
>>    vfio iommu: Add migration capability to report supported features
>>    vfio: Selective dirty page tracking if IOMMU backed device pins pages
>>
>>   drivers/vfio/vfio.c             |  13 +-
>>   drivers/vfio/vfio_iommu_type1.c | 569 ++++++++++++++++++++++++++++++++=
++++----
>>   include/linux/vfio.h            |   4 +-
>>   include/uapi/linux/vfio.h       | 315 ++++++++++++++++++++++
>>   4 files changed, 842 insertions(+), 59 deletions(-)
>>
>=20
