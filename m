Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582011F554E
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 15:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgFJNFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 09:05:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728792AbgFJNFH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 09:05:07 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AD30gC179798;
        Wed, 10 Jun 2020 09:04:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31k02cg3h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 09:04:56 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05AD3FsM181596;
        Wed, 10 Jun 2020 09:04:55 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31k02cg3ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 09:04:55 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05AD0bUM027556;
        Wed, 10 Jun 2020 13:04:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 31jqykderf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 13:04:54 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05AD4pF711141876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 13:04:51 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D00C97805E;
        Wed, 10 Jun 2020 13:04:52 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9481178064;
        Wed, 10 Jun 2020 13:04:51 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.146.208])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jun 2020 13:04:51 +0000 (GMT)
Subject: Re: [PATCH v4 02/21] vfio: Convert to ram_block_discard_disable()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20200610115419.51688-1-david@redhat.com>
 <20200610115419.51688-3-david@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8c71bfda-e958-56f8-ddaf-6a831fff2bc6@linux.ibm.com>
Date:   Wed, 10 Jun 2020 09:04:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200610115419.51688-3-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_08:2020-06-10,2020-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=4
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/10/20 7:54 AM, David Hildenbrand wrote:
> VFIO is (except devices without a physical IOMMU or some mediated devices)
> incompatible with discarding of RAM. The kernel will pin basically all VM
> memory. Let's convert to ram_block_discard_disable(), which can now
> fail, in contrast to qemu_balloon_inhibit().
>
> Leave "x-balloon-allowed" named as it is for now.
>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

See my two minor comments, other than that:
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

> ---
>   hw/vfio/ap.c                  | 10 +++----
>   hw/vfio/ccw.c                 | 11 ++++----
>   hw/vfio/common.c              | 53 +++++++++++++++++++----------------
>   hw/vfio/pci.c                 |  6 ++--
>   include/hw/vfio/vfio-common.h |  4 +--
>   5 files changed, 45 insertions(+), 39 deletions(-)
>
> diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
> index 95564c17ed..d0b1bc7581 100644
> --- a/hw/vfio/ap.c
> +++ b/hw/vfio/ap.c
> @@ -105,12 +105,12 @@ static void vfio_ap_realize(DeviceState *dev, Error **errp)
>       vapdev->vdev.dev = dev;
>   
>       /*
> -     * vfio-ap devices operate in a way compatible with
> -     * memory ballooning, as no pages are pinned in the host.
> -     * This needs to be set before vfio_get_device() for vfio common to
> -     * handle the balloon inhibitor.
> +     * vfio-ap devices operate in a way compatible discarding of memory in

s/compatible discarding/compatible with discarding/?

> +     * RAM blocks, as no pages are pinned in the host. This needs to be
> +     * set before vfio_get_device() for vfio common to handle
> +     * ram_block_discard_disable().
>        */
> -    vapdev->vdev.balloon_allowed = true;
> +    vapdev->vdev.ram_block_discard_allowed = true;
>   
>       ret = vfio_get_device(vfio_group, mdevid, &vapdev->vdev, errp);
>       if (ret) {
> diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
> index 63406184d2..82857f1615 100644
> --- a/hw/vfio/ccw.c
> +++ b/hw/vfio/ccw.c
> @@ -418,12 +418,13 @@ static void vfio_ccw_get_device(VFIOGroup *group, VFIOCCWDevice *vcdev,
>   
>       /*
>        * All vfio-ccw devices are believed to operate in a way compatible with
> -     * memory ballooning, ie. pages pinned in the host are in the current
> -     * working set of the guest driver and therefore never overlap with pages
> -     * available to the guest balloon driver.  This needs to be set before
> -     * vfio_get_device() for vfio common to handle the balloon inhibitor.
> +     * discarding of memory in RAM blocks, ie. pages pinned in the host are
> +     * in the current working set of the guest driver and therefore never
> +     * overlap e.g., with pages available to the guest balloon driver.  This
> +     * needs to be set before vfio_get_device() for vfio common to handle
> +     * ram_block_discard_disable().
>        */
> -    vcdev->vdev.balloon_allowed = true;
> +    vcdev->vdev.ram_block_discard_allowed = true;
>   
>       if (vfio_get_device(group, vcdev->cdev.mdevid, &vcdev->vdev, errp)) {
>           goto out_err;
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 0b3593b3c0..33357140b8 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -33,7 +33,6 @@
>   #include "qemu/error-report.h"
>   #include "qemu/main-loop.h"
>   #include "qemu/range.h"
> -#include "sysemu/balloon.h"
>   #include "sysemu/kvm.h"
>   #include "sysemu/reset.h"
>   #include "trace.h"
> @@ -1215,31 +1214,36 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>       space = vfio_get_address_space(as);
>   
>       /*
> -     * VFIO is currently incompatible with memory ballooning insofar as the
> +     * VFIO is currently incompatible with discarding of RAM insofar as the
>        * madvise to purge (zap) the page from QEMU's address space does not
>        * interact with the memory API and therefore leaves stale virtual to
>        * physical mappings in the IOMMU if the page was previously pinned.  We
> -     * therefore add a balloon inhibit for each group added to a container,
> +     * therefore set discarding broken for each group added to a container,
>        * whether the container is used individually or shared.  This provides
>        * us with options to allow devices within a group to opt-in and allow
> -     * ballooning, so long as it is done consistently for a group (for instance
> +     * discarding, so long as it is done consistently for a group (for instance
>        * if the device is an mdev device where it is known that the host vendor
>        * driver will never pin pages outside of the working set of the guest
> -     * driver, which would thus not be ballooning candidates).
> +     * driver, which would thus not be discarding candidates).
>        *
>        * The first opportunity to induce pinning occurs here where we attempt to
>        * attach the group to existing containers within the AddressSpace.  If any
> -     * pages are already zapped from the virtual address space, such as from a
> -     * previous ballooning opt-in, new pinning will cause valid mappings to be
> +     * pages are already zapped from the virtual address space, such as from
> +     * previous discards, new pinning will cause valid mappings to be
>        * re-established.  Likewise, when the overall MemoryListener for a new
>        * container is registered, a replay of mappings within the AddressSpace
>        * will occur, re-establishing any previously zapped pages as well.
>        *
> -     * NB. Balloon inhibiting does not currently block operation of the
> -     * balloon driver or revoke previously pinned pages, it only prevents
> -     * calling madvise to modify the virtual mapping of ballooned pages.
> +     * Especially virtio-balloon is currently only prevented from discarding
> +     * new memory, it will not yet set ram_block_discard_set_required() and
> +     * therefore, neither stops us here or deals with the sudden memory
> +     * consumption of inflated memory.
>        */
> -    qemu_balloon_inhibit(true);
> +    ret = ram_block_discard_disable(true);
> +    if (ret) {
> +        error_setg_errno(errp, -ret, "Cannot set discarding of RAM broken");
> +        return ret;
> +    }
>   
>       QLIST_FOREACH(container, &space->containers, next) {
>           if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd)) {
> @@ -1405,7 +1409,7 @@ close_fd_exit:
>       close(fd);
>   
>   put_space_exit:
> -    qemu_balloon_inhibit(false);
> +    ram_block_discard_disable(false);
>       vfio_put_address_space(space);
>   
>       return ret;
> @@ -1526,8 +1530,8 @@ void vfio_put_group(VFIOGroup *group)
>           return;
>       }
>   
> -    if (!group->balloon_allowed) {
> -        qemu_balloon_inhibit(false);
> +    if (!group->ram_block_discard_allowed) {
> +        ram_block_discard_disable(false);
>       }
>       vfio_kvm_device_del_group(group);
>       vfio_disconnect_container(group);
> @@ -1565,22 +1569,23 @@ int vfio_get_device(VFIOGroup *group, const char *name,
>       }
>   
>       /*
> -     * Clear the balloon inhibitor for this group if the driver knows the
> -     * device operates compatibly with ballooning.  Setting must be consistent
> -     * per group, but since compatibility is really only possible with mdev
> -     * currently, we expect singleton groups.
> +     * Set discarding of RAM as not broken for this group if the driver knows
> +     * the device operates compatibly with discarding.  Setting must be
> +     * consistent per group, but since compatibility is really only possible
> +     * with mdev currently, we expect singleton groups.
>        */
> -    if (vbasedev->balloon_allowed != group->balloon_allowed) {
> +    if (vbasedev->ram_block_discard_allowed !=
> +        group->ram_block_discard_allowed) {
>           if (!QLIST_EMPTY(&group->device_list)) {
> -            error_setg(errp,
> -                       "Inconsistent device balloon setting within group");
> +            error_setg(errp, "Inconsistent setting of support for discarding "
> +                       "RAM (e.g., balloon) within group");
>               close(fd);
>               return -1;
>           }
>   
> -        if (!group->balloon_allowed) {
> -            group->balloon_allowed = true;
> -            qemu_balloon_inhibit(false);
> +        if (!group->ram_block_discard_allowed) {
> +            group->ram_block_discard_allowed = true;
> +            ram_block_discard_disable(false);
>           }
>       }
>   
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index 342dd6b912..c33c11b7e4 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2796,7 +2796,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>       }
>   
>       /*
> -     * Mediated devices *might* operate compatibly with memory ballooning, but
> +     * Mediated devices *might* operate compatibly with discarding of RAM, but
>        * we cannot know for certain, it depends on whether the mdev vendor driver
>        * stays in sync with the active working set of the guest driver.  Prevent
>        * the x-balloon-allowed option unless this is minimally an mdev device.
> @@ -2809,7 +2809,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>   
>       trace_vfio_mdev(vdev->vbasedev.name, is_mdev);
>   
> -    if (vdev->vbasedev.balloon_allowed && !is_mdev) {
> +    if (vdev->vbasedev.ram_block_discard_allowed && !is_mdev) {
>           error_setg(errp, "x-balloon-allowed only potentially compatible "
>                      "with mdev devices");

Should this error message be changed?

>           vfio_put_group(group);
> @@ -3163,7 +3163,7 @@ static Property vfio_pci_dev_properties[] = {
>                       VFIO_FEATURE_ENABLE_IGD_OPREGION_BIT, false),
>       DEFINE_PROP_BOOL("x-no-mmap", VFIOPCIDevice, vbasedev.no_mmap, false),
>       DEFINE_PROP_BOOL("x-balloon-allowed", VFIOPCIDevice,
> -                     vbasedev.balloon_allowed, false),
> +                     vbasedev.ram_block_discard_allowed, false),
>       DEFINE_PROP_BOOL("x-no-kvm-intx", VFIOPCIDevice, no_kvm_intx, false),
>       DEFINE_PROP_BOOL("x-no-kvm-msi", VFIOPCIDevice, no_kvm_msi, false),
>       DEFINE_PROP_BOOL("x-no-kvm-msix", VFIOPCIDevice, no_kvm_msix, false),
> diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
> index fd564209ac..c78f3ff559 100644
> --- a/include/hw/vfio/vfio-common.h
> +++ b/include/hw/vfio/vfio-common.h
> @@ -108,7 +108,7 @@ typedef struct VFIODevice {
>       bool reset_works;
>       bool needs_reset;
>       bool no_mmap;
> -    bool balloon_allowed;
> +    bool ram_block_discard_allowed;
>       VFIODeviceOps *ops;
>       unsigned int num_irqs;
>       unsigned int num_regions;
> @@ -128,7 +128,7 @@ typedef struct VFIOGroup {
>       QLIST_HEAD(, VFIODevice) device_list;
>       QLIST_ENTRY(VFIOGroup) next;
>       QLIST_ENTRY(VFIOGroup) container_next;
> -    bool balloon_allowed;
> +    bool ram_block_discard_allowed;
>   } VFIOGroup;
>   
>   typedef struct VFIODMABuf {

