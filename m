Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28ADB98CF
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfITVM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfITVM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:12:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EE8518CB8FE;
        Fri, 20 Sep 2019 21:12:27 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2067F5D9C3;
        Fri, 20 Sep 2019 21:12:27 +0000 (UTC)
Date:   Fri, 20 Sep 2019 15:12:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.4-rc1
Message-ID: <20190920151226.541871fe@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Fri, 20 Sep 2019 21:12:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit e3fb13b7e47cd18b2bd067ea8a491020b4644baf:

  Merge tag 'modules-for-v5.3-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/jeyu/linux (2019-08-23 09:22:00 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.4-rc1

for you to fetch changes up to e6c5d727db0a86a3ff21aca6824aae87f3bc055f:

  Merge branches 'v5.4/vfio/alexey-tce-memory-free-v1', 'v5.4/vfio/connie-re-arrange-v2', 'v5.4/vfio/hexin-pci-reset-v3', 'v5.4/vfio/parav-mtty-uuid-v2' and 'v5.4/vfio/shameer-iova-list-v8' into v5.4/vfio/next (2019-08-23 11:26:24 -0600)

----------------------------------------------------------------
VFIO updates for v5.4-rc1

 - Fix spapr iommu error case case (Alexey Kardashevskiy)

 - Consolidate region type definitions (Cornelia Huck)

 - Restore saved original PCI state on release (hexin)

 - Simplify mtty sample driver interrupt path (Parav Pandit)

 - Support for reporting valid IOVA regions to user (Shameer Kolothum)

----------------------------------------------------------------
Alex Williamson (1):
      Merge branches 'v5.4/vfio/alexey-tce-memory-free-v1', 'v5.4/vfio/connie-re-arrange-v2', 'v5.4/vfio/hexin-pci-reset-v3', 'v5.4/vfio/parav-mtty-uuid-v2' and 'v5.4/vfio/shameer-iova-list-v8' into v5.4/vfio/next

Alexey Kardashevskiy (1):
      vfio/spapr_tce: Fix incorrect tce_iommu_group memory free

Cornelia Huck (1):
      vfio: re-arrange vfio region definitions

Parav Pandit (1):
      vfio-mdev/mtty: Simplify interrupt generation

Shameer Kolothum (6):
      vfio/type1: Introduce iova list and add iommu aperture validity check
      vfio/type1: Check reserved region conflict and update iova list
      vfio/type1: Update iova list on detach
      vfio/type1: check dma map request is within a valid iova range
      vfio/type1: Add IOVA range capability support
      vfio/type1: remove duplicate retrieval of reserved regions

hexin (1):
      vfio_pci: Restore original state on release

 drivers/vfio/pci/vfio_pci.c         |  17 +-
 drivers/vfio/vfio_iommu_spapr_tce.c |   9 +-
 drivers/vfio/vfio_iommu_type1.c     | 518 +++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h           |  71 +++--
 samples/vfio-mdev/mtty.c            |  39 +--
 5 files changed, 583 insertions(+), 71 deletions(-)
