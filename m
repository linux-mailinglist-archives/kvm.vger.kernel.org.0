Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B2E3BA45E
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhGBTfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 15:35:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230404AbhGBTfs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Jul 2021 15:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625254395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ot20SRDzyxog6lyEGT+mgyL9waVUPOY7StPOnX4riLg=;
        b=avBNegWDxiI6KtKWrKPr1freeRxl6L9ErjJcJNmiUQydA8c3lfh5dUJ+0hSy718I+27vHm
        nEu+A3OT/PBnY0ilKurjmfY23Lf+RoazhKl4G2XsaNk9pS+RxqkjQwmrWyKZ6DU5xU1RNE
        Y+hYf7x35dTJrehED1jeTgMd9BfCBkU=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-22QLSDIAObesI7vlx4Iz7Q-1; Fri, 02 Jul 2021 15:33:14 -0400
X-MC-Unique: 22QLSDIAObesI7vlx4Iz7Q-1
Received: by mail-oo1-f69.google.com with SMTP id y7-20020a4ac4070000b029024c017e61d4so6068794oop.14
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 12:33:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ot20SRDzyxog6lyEGT+mgyL9waVUPOY7StPOnX4riLg=;
        b=QIX8gyQK2YQAfZ//PPKyV4h8FKXPacvEAtkSUsJPwSqJVw6GxFcLxBCiETuX7yhTw9
         jwwXyAr/ZkjNNnlO0lIBHP2RebBmqU/w+b54bNR1ZUBYOEVussAYsEyCNUdLF2rChyPq
         K18MzRhpx83nB9srZv8VxP+fcnGpBqpi/z8uYozrdQnctEpEi1jzV35WdmQIgW/V2YD2
         vHKopIV/3jgecPdKITZHjUyHTpodwvTGq34Xsb3se0D8QIzstNGFc8YqGHTNRToWFRiN
         6UnP90tcifMIORV0mK8H32OLIxbLtFdCMsyCI669CBL6eONdz25maQImIgdaUZiuWJJ5
         W5jA==
X-Gm-Message-State: AOAM531zLdtTTg1UxpkzAy1Fi+q+X05z2xt96+rkyi/0XCwu32MNUn7Q
        5JWsVre9B1Q9fGVvRAmiQwW42F8Gyw2Q1RXl6HnqfTYIKM2ZvIPZPPiDc1ojn3ocJhTM7z3P1BS
        NzxFct2FM23M/
X-Received: by 2002:a4a:b917:: with SMTP id x23mr1004560ooo.58.1625254393573;
        Fri, 02 Jul 2021 12:33:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSysrsoqZ+0hH+i6z8lVDJieU+Y2cpNlfjg67RGKJ9Qm7eYtd4xL+oGs3LKVH5OSShqZ4Y+g==
X-Received: by 2002:a4a:b917:: with SMTP id x23mr1004550ooo.58.1625254393346;
        Fri, 02 Jul 2021 12:33:13 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l3sm925194oif.49.2021.07.02.12.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 12:33:13 -0700 (PDT)
Date:   Fri, 2 Jul 2021 13:33:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.14-rc1
Message-ID: <20210702133312.61fe06aa.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 009c9aa5be652675a06d5211e1640e02bbb1c33d:

  Linux 5.13-rc6 (2021-06-13 14:43:10 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.14-rc1

for you to fetch changes up to 6a45ece4c9af473555f01f0f8b97eba56e3c7d0d:

  vfio/pci: Handle concurrent vma faults (2021-06-30 13:55:53 -0600)

----------------------------------------------------------------
VFIO update for v5.14-rc1

 - Module reference fixes, structure renaming (Max Gurtovoy)

 - Export and use common pci_dev_trylock() (Luis Chamberlain)

 - Enable direct mdev device creation and probing by parent
   (Christoph Hellwig & Jason Gunthorpe)

 - Fix mdpy error path leak (Colin Ian King)

 - Fix mtty list entry leak (Jason Gunthorpe)

 - Enforce mtty device limit (Alex Williamson)

 - Resolve concurrent vfio-pci mmap faults (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (3):
      Merge branch 'hch-mdev-direct-v4' into v5.14/vfio/next
      vfio/mtty: Enforce available_instances
      vfio/pci: Handle concurrent vma faults

Christoph Hellwig (3):
      driver core: Better distinguish probe errors in really_probe
      driver core: Flow the return code from ->probe() through to sysfs bind
      driver core: Don't return EPROBE_DEFER to userspace during sysfs bind

Colin Ian King (1):
      vfio/mdpy: Fix memory leak of object mdev_state->vconfig

Jason Gunthorpe (8):
      driver core: Pull required checks into driver_probe_device()
      driver core: Export device_driver_attach()
      vfio/mdev: Remove CONFIG_VFIO_MDEV_DEVICE
      vfio/mdev: Allow the mdev_parent_ops to specify the device driver to bind
      vfio/mtty: Convert to use vfio_register_group_dev()
      vfio/mdpy: Convert to use vfio_register_group_dev()
      vfio/mbochs: Convert to use vfio_register_group_dev()
      vfio/mtty: Delete mdev_devices_list

Luis Chamberlain (2):
      PCI: Export pci_dev_trylock() and pci_dev_unlock()
      vfio: use the new pci_dev_trylock() helper to simplify try lock

Max Gurtovoy (3):
      vfio: centralize module refcount in subsystem layer
      vfio/platform: remove unneeded parent_module attribute
      vfio/iommu_type1: rename vfio_group struck to vfio_iommu_group

 Documentation/driver-api/vfio-mediated-device.rst |  35 ++--
 Documentation/s390/vfio-ap.rst                    |   1 -
 arch/s390/Kconfig                                 |   2 +-
 drivers/base/base.h                               |   1 -
 drivers/base/bus.c                                |   8 +-
 drivers/base/dd.c                                 | 192 ++++++++++---------
 drivers/gpu/drm/i915/Kconfig                      |   2 +-
 drivers/pci/pci.c                                 |   6 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                 |  16 +-
 drivers/vfio/mdev/Kconfig                         |   7 -
 drivers/vfio/mdev/Makefile                        |   3 +-
 drivers/vfio/mdev/mdev_core.c                     |  46 ++++-
 drivers/vfio/mdev/mdev_driver.c                   |  10 +
 drivers/vfio/mdev/mdev_private.h                  |   2 +
 drivers/vfio/mdev/vfio_mdev.c                     |  37 +---
 drivers/vfio/pci/vfio_pci.c                       |  47 ++---
 drivers/vfio/platform/vfio_amba.c                 |   1 -
 drivers/vfio/platform/vfio_platform.c             |   1 -
 drivers/vfio/platform/vfio_platform_common.c      |   6 -
 drivers/vfio/platform/vfio_platform_private.h     |   1 -
 drivers/vfio/vfio.c                               |  10 +
 drivers/vfio/vfio_iommu_type1.c                   |  34 ++--
 include/linux/device.h                            |   2 +
 include/linux/mdev.h                              |   2 +
 include/linux/pci.h                               |   3 +
 samples/Kconfig                                   |   6 +-
 samples/vfio-mdev/mbochs.c                        | 163 +++++++++-------
 samples/vfio-mdev/mdpy.c                          | 160 +++++++++-------
 samples/vfio-mdev/mtty.c                          | 219 ++++++++++------------
 29 files changed, 522 insertions(+), 501 deletions(-)

