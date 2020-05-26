Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9619E104
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 00:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgDCWWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 18:22:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727879AbgDCWWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 18:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585952566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=s4frkIsjfdUlJtqzclZG3qUK/GnNSIuQZIcCJzVIQcI=;
        b=PZepwGBxGiVZO2EmgMLywISLJeyfENQ3E2dvJr0eLrJOrVLF714JihNAc0kmxNfh27pRcS
        AKr6PSCuf3INKQXwfpGAiph8rCynXGd3guX4Vw+JdcMniwwV1KpXZ9LwQYfAdRxIhkHM40
        sL3JDQm2xyDadVQWSAUMEGY7q9Ez6PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-i3sFbb7LNTGRZIWfJgx-SQ-1; Fri, 03 Apr 2020 18:22:44 -0400
X-MC-Unique: i3sFbb7LNTGRZIWfJgx-SQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA63E18CA240;
        Fri,  3 Apr 2020 22:22:43 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BB37114810;
        Fri,  3 Apr 2020 22:22:43 +0000 (UTC)
Date:   Fri, 3 Apr 2020 16:22:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.7-rc1
Message-ID: <20200403162242.5e4f9afa@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 16fbf79b0f83bc752cee8589279f1ebfe57b3b6e:

  Linux 5.6-rc7 (2020-03-22 18:31:56 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.7-rc1

for you to fetch changes up to f44efca0493ddc1e8731047c234ec8e475943077:

  vfio: Ignore -ENODEV when getting MSI cookie (2020-04-01 13:51:51 -0600)

----------------------------------------------------------------
VFIO updates for v5.7-rc1

 - vfio-pci SR-IOV support (Alex Williamson)

 - vfio DMA read/write interface (Yan Zhao)

 - Fix vfio-platform erroneous IRQ error log (Eric Auger)

 - Fix shared ATSD support for NVLink on POWER (Sam Bobroff)

 - Fix init error without CONFIG_IOMMU_DMA (Andre Przywara)

----------------------------------------------------------------
Alex Williamson (8):
      vfio: Include optional device match in vfio_device_ops callbacks
      vfio/pci: Implement match ops
      vfio/pci: Introduce VF token
      vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
      vfio/pci: Add sriov_configure support
      vfio/pci: Remove dev_fmt definition
      vfio/pci: Cleanup .probe() exit paths
      Merge branches 'v5.7/vfio/alex-sriov-v3' and 'v5.7/vfio/yan-dma-rw-v4' into v5.7/vfio/next

Andre Przywara (1):
      vfio: Ignore -ENODEV when getting MSI cookie

Eric Auger (1):
      vfio: platform: Switch to platform_get_irq_optional()

Sam Bobroff (1):
      vfio-pci/nvlink2: Allow fallback to ibm,mmio-atsd[0]

Yan Zhao (3):
      vfio: allow external user to get vfio group from device
      vfio: introduce vfio_dma_rw to read/write a range of IOVAs
      vfio: avoid inefficient operations on VFIO group in vfio_pin/unpin_pages

 drivers/vfio/pci/vfio_pci.c           | 390 +++++++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_nvlink2.c   |  10 +-
 drivers/vfio/pci/vfio_pci_private.h   |  10 +
 drivers/vfio/platform/vfio_platform.c |   2 +-
 drivers/vfio/vfio.c                   | 198 ++++++++++++++++-
 drivers/vfio/vfio_iommu_type1.c       |  78 ++++++-
 include/linux/vfio.h                  |  17 ++
 include/uapi/linux/vfio.h             |  37 ++++
 8 files changed, 710 insertions(+), 32 deletions(-)

