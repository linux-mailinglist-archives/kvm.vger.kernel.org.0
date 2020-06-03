Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1953C1ED4E7
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 19:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgFCRXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 13:23:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41103 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725961AbgFCRXK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 13:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591204988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BBwgQMLjQcT93l5oHgQ0C5n6kW+0rnqW19ugaGnZwA4=;
        b=JFZ7B1cb6WChq+gNPNtQ8gBxWb7eEq7sHPmbQc4JQ222ELKOvPRnWDp/0LOYp0+Oqz4GXD
        nGzjo4VfsZSUunXuYYwZuAg/QCUzDqgerWyNTxogoBSGaCbku0s4qcR311w6gUsfyKUwga
        X4LXWpp+xClKqSeUjvSGwy/ONLwnaG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-1De3qDeVNDChGHbvHaG4Xg-1; Wed, 03 Jun 2020 13:23:06 -0400
X-MC-Unique: 1De3qDeVNDChGHbvHaG4Xg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 763921856941;
        Wed,  3 Jun 2020 17:23:05 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DB8D10013D0;
        Wed,  3 Jun 2020 17:23:05 +0000 (UTC)
Date:   Wed, 3 Jun 2020 11:23:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.8-rc1
Message-ID: <20200603112304.017a7954@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 9cb1fd0efd195590b828b9b865421ad345a4a145:

  Linux 5.7-rc7 (2020-05-24 15:32:54 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.8-rc1

for you to fetch changes up to 4f085ca2f5a8047845ab2d6bbe97089daed28655:

  Merge branch 'v5.8/vfio/kirti-migration-fixes' into v5.8/vfio/next (2020-06-02 13:53:00 -0600)

----------------------------------------------------------------
VFIO updates for v5.8-rc1

 - Block accesses to disabled MMIO space (Alex Williamson)

 - VFIO device migration API (Kirti Wankhede)

 - type1 IOMMU dirty bitmap API and implementation (Kirti Wankhede)

 - PCI NULL capability masking (Alex Williamson)

 - Memory leak fixes (Qian Cai)

 - Reference leak fix (Qiushi Wu)

----------------------------------------------------------------
Alex Williamson (7):
      vfio/type1: Support faulting PFNMAP vmas
      vfio-pci: Fault mmaps to enable vma tracking
      vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
      vfio-pci: Mask cap zero
      Merge branches 'v5.8/vfio/alex-block-mmio-v3', 'v5.8/vfio/alex-zero-cap-v2' and 'v5.8/vfio/qian-leak-fixes' into v5.8/vfio/next
      Merge branch 'qiushi-wu-mdev-ref-v1' into v5.8/vfio/next
      Merge branch 'v5.8/vfio/kirti-migration-fixes' into v5.8/vfio/next

Kirti Wankhede (10):
      vfio: UAPI for migration interface for device state
      vfio iommu: Remove atomicity of ref_count of pinned pages
      vfio iommu: Cache pgsize_bitmap in struct vfio_iommu
      vfio iommu: Add ioctl definition for dirty pages tracking
      vfio iommu: Implementation of ioctl for dirty pages tracking
      vfio iommu: Update UNMAP_DMA ioctl to get dirty bitmap before unmap
      vfio iommu: Add migration capability to report supported features
      vfio: Selective dirty page tracking if IOMMU backed device pins pages
      vfio iommu: Use shift operation for 64-bit integer division
      vfio iommu: typecast corrections

Qian Cai (2):
      vfio/pci: fix memory leaks in alloc_perm_bits()
      vfio/pci: fix memory leaks of eventfd ctx

Qiushi Wu (1):
      vfio/mdev: Fix reference count leak in add_mdev_supported_type

 drivers/vfio/mdev/mdev_sysfs.c      |   2 +-
 drivers/vfio/pci/vfio_pci.c         | 353 +++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c  |  50 ++-
 drivers/vfio/pci/vfio_pci_intrs.c   |  14 +
 drivers/vfio/pci/vfio_pci_private.h |  15 +
 drivers/vfio/pci/vfio_pci_rdwr.c    |  24 +-
 drivers/vfio/vfio.c                 |  13 +-
 drivers/vfio/vfio_iommu_type1.c     | 609 ++++++++++++++++++++++++++++++++----
 include/linux/vfio.h                |   4 +-
 include/uapi/linux/vfio.h           | 319 +++++++++++++++++++
 10 files changed, 1301 insertions(+), 102 deletions(-)

