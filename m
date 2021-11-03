Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BECE444952
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhKCUFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 16:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhKCUFf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 16:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635969778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PDzHlSA8HJOcvdJ6Ikgc/3R++Q/IujB1uaRuJDGsXrk=;
        b=gSlCJObKClPe6ySZRGkPlm3xiS6zSo018uk7jImeQ00jVehHcQhZtbWIbSDKEjBfSyRdcj
        B5hNGpIdIBJ2DMUQsnyfoo94HJCQnRcSnYJLkny4eGZo1nHICTe5q17RNZsfMq/4HATtCM
        EgvaJUCbkT7mQJEmI6PW5GqJaWa2jy4=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-w_DrPRJ9PXyTGEnDXdD2tg-1; Wed, 03 Nov 2021 16:02:57 -0400
X-MC-Unique: w_DrPRJ9PXyTGEnDXdD2tg-1
Received: by mail-ot1-f72.google.com with SMTP id k17-20020a056830151100b0055ae9b0ec3dso670602otp.18
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=PDzHlSA8HJOcvdJ6Ikgc/3R++Q/IujB1uaRuJDGsXrk=;
        b=Z+nZ3K4RSG3Hfl9UZA6dOyavbpEaBD01RJKymJozjLUS1hkYgtlqvBJbHWK8A/yXNW
         xMZKzH7b/kM5Xw8wNtwzHIbzkTMzQjHBLM6OVyipjlAXOv4X5kHVVnIagQNdt+aooEog
         5vSKiDKhRsQwYLscbVQzgW8Qnzo40IRwBzZmY+55krJ7SgbD/a7YhMF7mgqHS16IbrZh
         AQsbo99Z5URzMKCU08kVJWgBvaT1Uci5SuvCqbOHOKAoAqlM6Z42jcUKWjd/xJ5sChiD
         M88302Fkm8dtVJjZYCMLCoXWUcMPxaZkFXdopZzonGIt6uOK8ZbJnycezB9otMpCZTcM
         h/Dg==
X-Gm-Message-State: AOAM532DoH1rFtJ89O5n0QRg7Xcn/D1x4OJrwhLI0bKZdyQQfSMISWG5
        JawouqKyCjw2GOq7DPDtuEUIyQbDooNk8FMct9HQofm57ZVNpyWP31MG2tC35jgTVqP4UEPMjaG
        VUU5L31rYEvPH
X-Received: by 2002:aca:4bcf:: with SMTP id y198mr3599733oia.32.1635969776830;
        Wed, 03 Nov 2021 13:02:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOR/LhVVokLXN2MJxb6zGRgWI/Rv0oWjVrOdyYqu2iZk6TWe0N+V1HO7+J419yZmv90z7Hbw==
X-Received: by 2002:aca:4bcf:: with SMTP id y198mr3599717oia.32.1635969776648;
        Wed, 03 Nov 2021 13:02:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bi40sm982174oib.51.2021.11.03.13.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:02:56 -0700 (PDT)
Date:   Wed, 3 Nov 2021 14:02:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Colin Xu <colin.xu@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [GIT PULL] VFIO updates for v5.16-rc1
Message-ID: <20211103140252.475e4543.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 02d5e016800d082058b3d3b7c3ede136cdc6ddcb:

  Merge tag 'sound-5.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2021-09-29 07:48:00 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.16-rc1

for you to fetch changes up to 3bf1311f351ef289f2aee79b86bcece2039fa611:

  vfio/ccw: Convert to use vfio_register_emulated_iommu_dev() (2021-10-28 11:06:31 -0600)

----------------------------------------------------------------
VFIO updates for v5.16-rc1

 - Cleanup vfio iommu_group creation (Christoph Hellwig)

 - Add individual device reset for vfio/fsl-mc (Diana Craciun)

 - IGD OpRegion 2.0+ support (Colin Xu)

 - Use modern cdev lifecycle for vfio_group (Jason Gunthorpe)

 - Use new mdev API in vfio_ccw (Jason Gunthorpe)

----------------------------------------------------------------
Alex Williamson (3):
      Merge branch 'v5.16/vfio/hch-cleanup-vfio-iommu_group-creation-v6' into v5.16/vfio/next
      Merge branch 'v5.16/vfio/diana-fsl-reset-v2' into v5.16/vfio/next
      Merge branch 'v5.16/vfio/colin_xu_igd_opregion_2.0_v8' into v5.16/vfio/next

Christoph Hellwig (14):
      vfio: factor out a vfio_iommu_driver_allowed helper
      vfio: remove the iommudata check in vfio_noiommu_attach_group
      vfio: factor out a vfio_group_find_or_alloc helper
      vfio: refactor noiommu group creation
      vfio: remove the iommudata hack for noiommu groups
      vfio: simplify iommu group allocation for mediated devices
      vfio: remove unused method from vfio_iommu_driver_ops
      vfio: move the vfio_iommu_driver_ops interface out of <linux/vfio.h>
      vfio: remove the unused mdev iommu hook
      vfio: clean up the check for mediated device in vfio_iommu_type1
      vfio/spapr_tce: reject mediated devices
      vfio/iommu_type1: initialize pgsize_bitmap in ->open
      vfio/iommu_type1: remove the "external" domain
      vfio/iommu_type1: remove IS_IOMMU_CAP_DOMAIN_IN_CONTAINER

Colin Xu (1):
      vfio/pci: Add OpRegion 2.0+ Extended VBT support.

Diana Craciun (2):
      bus/fsl-mc: Add generic implementation for open/reset/close commands
      vfio/fsl-mc: Add per device reset support

Jason Gunthorpe (10):
      vfio: Move vfio_iommu_group_get() to vfio_register_group_dev()
      vfio: Delete vfio_get/put_group from vfio_iommu_group_notifier()
      vfio: Do not open code the group list search in vfio_create_group()
      vfio: Don't leak a group reference if the group already exists
      vfio: Use a refcount_t instead of a kref in the vfio_group
      vfio: Use cdev_device_add() instead of device_create()
      vfio/ccw: Remove unneeded GFP_DMA
      vfio/ccw: Use functions for alloc/free of the vfio_ccw_private
      vfio/ccw: Pass vfio_ccw_private not mdev_device to various functions
      vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()

 drivers/bus/fsl-mc/Makefile                  |   3 +-
 drivers/bus/fsl-mc/fsl-mc-private.h          |  39 +-
 drivers/bus/fsl-mc/obj-api.c                 | 103 +++++
 drivers/s390/cio/vfio_ccw_drv.c              | 136 +++---
 drivers/s390/cio/vfio_ccw_ops.c              | 142 +++---
 drivers/s390/cio/vfio_ccw_private.h          |   5 +
 drivers/s390/crypto/vfio_ap_ops.c            |   2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  62 +--
 drivers/vfio/mdev/mdev_driver.c              |  45 +-
 drivers/vfio/mdev/vfio_mdev.c                |   2 +-
 drivers/vfio/pci/vfio_pci_core.c             |  13 +-
 drivers/vfio/pci/vfio_pci_igd.c              | 234 +++++++---
 drivers/vfio/platform/vfio_platform_common.c |  13 +-
 drivers/vfio/vfio.c                          | 622 +++++++++++----------------
 drivers/vfio/vfio.h                          |  72 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c          |   6 +-
 drivers/vfio/vfio_iommu_type1.c              | 256 ++++-------
 include/linux/fsl/mc.h                       |  14 +
 include/linux/mdev.h                         |  20 -
 include/linux/vfio.h                         |  53 +--
 samples/vfio-mdev/mbochs.c                   |   2 +-
 samples/vfio-mdev/mdpy.c                     |   2 +-
 samples/vfio-mdev/mtty.c                     |   2 +-
 23 files changed, 945 insertions(+), 903 deletions(-)
 create mode 100644 drivers/bus/fsl-mc/obj-api.c
 create mode 100644 drivers/vfio/vfio.h

