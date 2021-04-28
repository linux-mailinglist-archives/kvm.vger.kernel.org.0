Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC936DFC9
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhD1TlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231312AbhD1TlA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 15:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619638814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aNKxH/tYvIoxwT8T/p02EbXbtq/qDBC33gmsPEeKMqA=;
        b=IpGUzQ3soxsIDSyIuzwh2nybiobJYr2+Sdtvn7wSLnkpXmh8hzR9td/D/DRdYWFNT8cy+J
        07iOwSAeDH73NMXeMVYLf6ZBE3zUFmPUioZ2ubEzAEUwu/ZZuaONHPM8KHvti0510jxiM/
        UpnoonR/jvXNg+V7Mk9axK0wCfzoPSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-ToNQa1A6Pf2g_QfUKgHEQw-1; Wed, 28 Apr 2021 15:40:10 -0400
X-MC-Unique: ToNQa1A6Pf2g_QfUKgHEQw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84FAF107F97F;
        Wed, 28 Apr 2021 19:39:19 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAA2410A33C4;
        Wed, 28 Apr 2021 19:39:17 +0000 (UTC)
Date:   Wed, 28 Apr 2021 13:39:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.13-rc1
Message-ID: <20210428133917.1c039eac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

There's a conflict versus Dave's drm tree that was just merged in this
one.  Stephen noted the resolution vs linux-next here[1], essentially
dropping the function contents from HEAD and using the new body.  Thanks,

Alex

[1] https://lore.kernel.org/lkml/20210415164734.1143f20d@canb.auug.org.au/

The following changes since commit e49d033bddf5b565044e2abe4241353959bc9120:

  Linux 5.12-rc6 (2021-04-04 14:15:36 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.13-rc1

for you to fetch changes up to adaeb718d46f6b42a3fc1dffd4f946f26b33779a:

  vfio/gvt: fix DRM_I915_GVT dependency on VFIO_MDEV (2021-04-27 13:36:54 -0600)

----------------------------------------------------------------
VFIO updates for v5.13-rc1

 - Embed struct vfio_device into vfio driver structures (Jason Gunthorpe)

 - Make vfio_mdev type safe (Jason Gunthorpe)

 - Remove vfio-pci NVLink2 extensions for POWER9 (Christoph Hellwig)

 - Update vfio-pci IGD extensions for OpRegion 2.1+ (Fred Gao)

 - Various spelling/blank line fixes (Zhen Lei, Zhou Wang, Bhaskar Chowdhury)

 - Simplify unpin_pages error handling (Shenming Lu)

 - Fix i915 mdev Kconfig dependency (Arnd Bergmann)

 - Remove unused structure member (Keqian Zhu)

----------------------------------------------------------------
Alex Williamson (1):
      Merge branches 'v5.13/vfio/embed-vfio_device', 'v5.13/vfio/misc' and 'v5.13/vfio/nvlink' into v5.13/vfio/next

Arnd Bergmann (1):
      vfio/gvt: fix DRM_I915_GVT dependency on VFIO_MDEV

Bhaskar Chowdhury (1):
      vfio: pci: Spello fix in the file vfio_pci.c

Christoph Hellwig (1):
      vfio/pci: remove vfio_pci_nvlink2

Fred Gao (1):
      vfio/pci: Add support for opregion v2.1+

Jason Gunthorpe (32):
      vfio: Remove extra put/gets around vfio_device->group
      vfio: Simplify the lifetime logic for vfio_device
      vfio: Split creation of a vfio_device into init and register ops
      vfio/platform: Use vfio_init/register/unregister_group_dev
      vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
      vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
      vfio/pci: Move VGA and VF initialization to functions
      vfio/pci: Re-order vfio_pci_probe()
      vfio/pci: Use vfio_init/register/unregister_group_dev
      vfio/mdev: Use vfio_init/register/unregister_group_dev
      vfio/mdev: Make to_mdev_device() into a static inline
      vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of 'void *'
      vfio/pci: Replace uses of vfio_device_data() with container_of
      vfio: Remove device_data from the vfio bus driver API
      vfio/mdev: Fix missing static's on MDEV_TYPE_ATTR's
      vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer
      vfio/mdev: Add missing typesafety around mdev_device
      vfio/mdev: Simplify driver registration
      vfio/mdev: Use struct mdev_type in struct mdev_device
      vfio/mdev: Expose mdev_get/put_parent to mdev_private.h
      vfio/mdev: Add missing reference counting to mdev_type
      vfio/mdev: Reorganize mdev_device_create()
      vfio/mdev: Add missing error handling to dev_set_name()
      vfio/mdev: Remove duplicate storage of parent in mdev_device
      vfio/mdev: Add mdev/mtype_get_type_group_id()
      vfio/mtty: Use mdev_get_type_group_id()
      vfio/mdpy: Use mdev_get_type_group_id()
      vfio/mbochs: Use mdev_get_type_group_id()
      vfio/gvt: Make DRM_I915_GVT depend on VFIO_MDEV
      vfio/gvt: Use mdev_get_type_group_id()
      vfio/mdev: Remove kobj from mdev_parent_ops->create()
      vfio/mdev: Correct the function signatures for the mdev_type_attributes

Keqian Zhu (1):
      vfio/iommu_type1: Remove unused pinned_page_dirty_scope in vfio_iommu

Shenming Lu (1):
      vfio/type1: Remove the almost unused check in vfio_iommu_type1_unpin_pages

Zhen Lei (4):
      vfio/type1: fix a couple of spelling mistakes
      vfio/mdev: Fix spelling mistake "interal" -> "internal"
      vfio/pci: fix a couple of spelling mistakes
      vfio/platform: Fix spelling mistake "registe" -> "register"

Zhou Wang (1):
      vfio/pci: Remove an unnecessary blank line in vfio_pci_enable

 Documentation/driver-api/vfio-mediated-device.rst  |   9 +-
 Documentation/driver-api/vfio.rst                  |  48 +-
 drivers/gpu/drm/i915/Kconfig                       |   1 +
 drivers/gpu/drm/i915/gvt/gvt.c                     |  41 +-
 drivers/gpu/drm/i915/gvt/gvt.h                     |   4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   7 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |  17 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |  14 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  | 127 ++++--
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h          |   1 +
 drivers/vfio/mdev/mdev_core.c                      | 174 +++-----
 drivers/vfio/mdev/mdev_driver.c                    |  19 +-
 drivers/vfio/mdev/mdev_private.h                   |  39 +-
 drivers/vfio/mdev/mdev_sysfs.c                     |  59 ++-
 drivers/vfio/mdev/vfio_mdev.c                      |  80 ++--
 drivers/vfio/pci/Kconfig                           |   6 -
 drivers/vfio/pci/Makefile                          |   1 -
 drivers/vfio/pci/vfio_pci.c                        | 274 ++++++------
 drivers/vfio/pci/vfio_pci_config.c                 |   2 +-
 drivers/vfio/pci/vfio_pci_igd.c                    |  53 +++
 drivers/vfio/pci/vfio_pci_nvlink2.c                | 490 ---------------------
 drivers/vfio/pci/vfio_pci_private.h                |  15 +-
 .../platform/reset/vfio_platform_calxedaxgmac.c    |   2 +-
 drivers/vfio/platform/vfio_amba.c                  |   8 +-
 drivers/vfio/platform/vfio_platform.c              |  20 +-
 drivers/vfio/platform/vfio_platform_common.c       |  56 +--
 drivers/vfio/platform/vfio_platform_private.h      |   5 +-
 drivers/vfio/vfio.c                                | 210 +++------
 drivers/vfio/vfio_iommu_type1.c                    |  40 +-
 include/linux/mdev.h                               |  80 +++-
 include/linux/vfio.h                               |  37 +-
 include/uapi/linux/vfio.h                          |  38 +-
 samples/vfio-mdev/mbochs.c                         |  55 ++-
 samples/vfio-mdev/mdpy.c                           |  56 ++-
 samples/vfio-mdev/mtty.c                           |  66 +--
 35 files changed, 793 insertions(+), 1361 deletions(-)
 delete mode 100644 drivers/vfio/pci/vfio_pci_nvlink2.c

