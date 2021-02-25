Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD4232435E
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 18:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhBXRwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 12:52:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234202AbhBXRvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 12:51:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614189018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X9cy0F4zcJr85qheHgGEfaSe+Yv6NngaYwEOKPQ/d5U=;
        b=VrPGu/6vKGF8jSgsnW9cy6rj8iVT/K7Hi/kfgdP0aQi6nmeg97qlj0CdYaBmMAxFBPvVA/
        99HIRkGyLlIYTkuI8RbewtV2gzFsUQBvErPkNcdYoIwocGcRb0Rgb/7p/lffZlsMiF0yZy
        9244hkzW6ukQVCBxYnk893omae66xOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-w0kKXsMvP2ujtHkiVK0RtA-1; Wed, 24 Feb 2021 12:50:15 -0500
X-MC-Unique: w0kKXsMvP2ujtHkiVK0RtA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D58FF180E469;
        Wed, 24 Feb 2021 17:50:13 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E58110016F0;
        Wed, 24 Feb 2021 17:50:13 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:50:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.12-rc1
Message-ID: <20210224105013.03713eb6@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 3e10585335b7967326ca7b4118cada0d2d00a2ab:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2021-02-21 13:31:43 -0800)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.12-rc1

for you to fetch changes up to 4d83de6da265cd84e74c19d876055fa5f261cde4:

  vfio/type1: Batch page pinning (2021-02-22 16:30:47 -0700)

----------------------------------------------------------------
VFIO updates for v5.12-rc1

 - Virtual address update handling (Steve Sistare)

 - s390/zpci fixes and cleanups (Max Gurtovoy)

 - Fixes for dirty bitmap handling, non-mdev page pinning,
   and improved pinned dirty scope tracking (Keqian Zhu)

 - Batched page pinning enhancement (Daniel Jordan)

 - Page access permission fix (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (3):
      Merge branch 'v5.12/vfio/next-vaddr' into v5.12/vfio/next
      Merge commit '3e10585335b7967326ca7b4118cada0d2d00a2ab' into v5.12/vfio/next
      vfio/type1: Use follow_pte()

Daniel Jordan (3):
      vfio/type1: Change success value of vaddr_get_pfn()
      vfio/type1: Prepare for batched pinning with struct vfio_batch
      vfio/type1: Batch page pinning

Heiner Kallweit (1):
      vfio/pci: Fix handling of pci use accessor return codes

Keqian Zhu (3):
      vfio/iommu_type1: Populate full dirty when detach non-pinned group
      vfio/iommu_type1: Fix some sanity checks in detach group
      vfio/iommu_type1: Mantain a counter for non_pinned_groups

Max Gurtovoy (3):
      vfio-pci/zdev: remove unused vdev argument
      vfio-pci/zdev: fix possible segmentation fault issue
      vfio/pci: remove CONFIG_VFIO_PCI_ZDEV from Kconfig

Steve Sistare (9):
      vfio: option to unmap all
      vfio/type1: unmap cleanup
      vfio/type1: implement unmap all
      vfio: interfaces to update vaddr
      vfio/type1: massage unmap iteration
      vfio/type1: implement interfaces to update vaddr
      vfio: iommu driver notify callback
      vfio/type1: implement notify callback
      vfio/type1: block on invalid vaddr

Tian Tao (1):
      vfio/iommu_type1: Fix duplicate included kthread.h

 drivers/vfio/pci/Kconfig            |  12 -
 drivers/vfio/pci/Makefile           |   2 +-
 drivers/vfio/pci/vfio_pci.c         |  12 +-
 drivers/vfio/pci/vfio_pci_igd.c     |  10 +-
 drivers/vfio/pci/vfio_pci_private.h |   2 +-
 drivers/vfio/pci/vfio_pci_zdev.c    |  24 +-
 drivers/vfio/vfio.c                 |   5 +
 drivers/vfio/vfio_iommu_type1.c     | 564 ++++++++++++++++++++++++++----------
 include/linux/vfio.h                |   7 +
 include/uapi/linux/vfio.h           |  27 ++
 10 files changed, 475 insertions(+), 190 deletions(-)

