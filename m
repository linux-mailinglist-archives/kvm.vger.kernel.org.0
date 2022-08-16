Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA017596117
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbiHPR2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 13:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbiHPR2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 13:28:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1310D2BF2;
        Tue, 16 Aug 2022 10:28:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8497106F;
        Tue, 16 Aug 2022 10:28:11 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0C37E3F67D;
        Tue, 16 Aug 2022 10:28:08 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     joro@8bytes.org
Cc:     will@kernel.org, catalin.marinas@arm.com, jean-philippe@linaro.org,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, tglx@linutronix.de, maz@kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/3] iommu/dma: Some housekeeping
Date:   Tue, 16 Aug 2022 18:28:02 +0100
Message-Id: <cover.1660668998.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.36.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

It's been a while now since iommu-dma grew from a library of DMA ops
helpers for arch code into something more abstracted and closely coupled
to the IOMMU API core, so it seemed about time to do some housekeeping
in the more neglected areas to reflect that.

The header reorganisation does touch a range of areas (a couple of which
seemingly had no reason to be involved anyway), but hopefully these are
all low-impact changes that nobody minds going through the IOMMU tree.

Now for the build-bots to tell me what I've missed...

Thanks,
Robin.


Robin Murphy (3):
  iommu/dma: Clean up Kconfig
  iommu/dma: Move public interfaces to linux/iommu.h
  iommu/dma: Make header private

 arch/arm64/Kconfig                          |  1 -
 arch/arm64/mm/dma-mapping.c                 |  2 +-
 drivers/acpi/viot.c                         |  1 -
 drivers/gpu/drm/exynos/exynos_drm_dma.c     |  1 -
 drivers/iommu/Kconfig                       |  3 +-
 drivers/iommu/amd/Kconfig                   |  1 -
 drivers/iommu/amd/iommu.c                   |  2 +-
 drivers/iommu/apple-dart.c                  |  3 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  2 +-
 drivers/iommu/dma-iommu.c                   | 18 +++-
 drivers/iommu/dma-iommu.h                   | 38 +++++++++
 drivers/iommu/intel/Kconfig                 |  1 -
 drivers/iommu/intel/iommu.c                 |  2 +-
 drivers/iommu/iommu.c                       |  3 +-
 drivers/iommu/virtio-iommu.c                |  3 +-
 drivers/irqchip/irq-gic-v2m.c               |  2 +-
 drivers/irqchip/irq-gic-v3-its.c            |  2 +-
 drivers/irqchip/irq-gic-v3-mbi.c            |  2 +-
 drivers/irqchip/irq-ls-scfg-msi.c           |  2 +-
 drivers/vfio/vfio_iommu_type1.c             |  1 -
 include/linux/dma-iommu.h                   | 93 ---------------------
 include/linux/iommu.h                       | 36 ++++++++
 23 files changed, 105 insertions(+), 116 deletions(-)
 create mode 100644 drivers/iommu/dma-iommu.h
 delete mode 100644 include/linux/dma-iommu.h

-- 
2.36.1.dirty

