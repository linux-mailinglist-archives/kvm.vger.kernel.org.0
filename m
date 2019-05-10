Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E581A4DC
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 23:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfEJVu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 17:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbfEJVu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 17:50:58 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37B6B301BE68;
        Fri, 10 May 2019 21:50:58 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0302608C2;
        Fri, 10 May 2019 21:50:57 +0000 (UTC)
Date:   Fri, 10 May 2019 15:50:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v5.2-rc1
Message-ID: <20190510155057.75cc97ba@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 10 May 2019 21:50:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 085b7755808aa11f78ab9377257e1dad2e6fa4bb:

  Linux 5.1-rc6 (2019-04-21 10:45:57 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.2-rc1

for you to fetch changes up to 15c80c1659f27364734a3938b04d1c67479aa11c:

  vfio: Add Cornelia Huck as reviewer (2019-05-08 11:41:26 -0600)

----------------------------------------------------------------
VFIO updates for v5.2-rc1

 - Improve dev_printk() usage (Bjorn Helgaas)

 - Fix issue with blocking in !TASK_RUNNING state while waiting for
   userspace to release devices (Farhan Ali)

 - Fix error path cleanup in nvlink setup (Greg Kurz)

 - mdev-core cleanups and fixes in preparation for more use cases
   (Parav Pandit)

 - Cornelia has volunteered as an official vfio reviewer (Cornelia Huck)

----------------------------------------------------------------
Bjorn Helgaas (1):
      vfio: Use dev_printk() when possible

Cornelia Huck (1):
      vfio: Add Cornelia Huck as reviewer

Farhan Ali (1):
      vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"

Greg Kurz (1):
      vfio-pci/nvlink2: Fix potential VMA leak

Parav Pandit (7):
      vfio/mdev: Avoid release parent reference during error path
      vfio/mdev: Removed unused kref
      vfio/mdev: Drop redundant extern for exported symbols
      vfio/mdev: Avoid masking error code to EBUSY
      vfio/mdev: Follow correct remove sequence
      vfio/mdev: Fix aborting mdev child device removal if one fails
      vfio/mdev: Avoid inline get and put parent helpers

 MAINTAINERS                                        |  1 +
 drivers/vfio/mdev/mdev_core.c                      | 18 +++----
 drivers/vfio/mdev/mdev_private.h                   |  1 -
 drivers/vfio/mdev/mdev_sysfs.c                     |  2 +-
 drivers/vfio/pci/vfio_pci.c                        | 23 ++++-----
 drivers/vfio/pci/vfio_pci_config.c                 | 29 +++++------
 drivers/vfio/pci/vfio_pci_nvlink2.c                |  2 +
 .../vfio/platform/reset/vfio_platform_amdxgbe.c    |  5 +-
 drivers/vfio/platform/vfio_platform_common.c       | 12 +++--
 drivers/vfio/vfio.c                                | 59 +++++++++-------------
 include/linux/mdev.h                               | 21 ++++----
 include/linux/pci.h                                |  3 ++
 12 files changed, 81 insertions(+), 95 deletions(-)
