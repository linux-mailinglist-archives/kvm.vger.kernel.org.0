Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514592A885A
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 21:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgKEUwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 15:52:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbgKEUwB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 15:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604609520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1/9hAMj/ihEHlpI+S/GvjO7/yU7iXYK7gBElq3upyrE=;
        b=YTVB0KHBX3VPBgY3zgEk0lp+rf+VWWHU/66+NzWtLKYVzPQz1DkczMCLXzKshDI9BF2jDQ
        946z1E2uJ2J6e7ujQIJLGmqNfqPti94IMA22gKckwoadgkr4R/fRbdc4B0/jftYn3sote0
        Z6CdBAHwFZeQ1ZxDQHQfGKk+pjkxobE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-yPmPi2XSMt-F5vdNMcLh-A-1; Thu, 05 Nov 2020 15:51:58 -0500
X-MC-Unique: yPmPi2XSMt-F5vdNMcLh-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B36E58030A8;
        Thu,  5 Nov 2020 20:51:57 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B9F7508E8;
        Thu,  5 Nov 2020 20:51:57 +0000 (UTC)
Date:   Thu, 5 Nov 2020 13:51:57 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v5.10-rc3
Message-ID: <20201105135157.72abcadb@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 3cea11cd5e3b00d91caf0b4730194039b45c5891:

  Linux 5.10-rc2 (2020-11-01 14:43:51 -0800)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.10-rc3

for you to fetch changes up to e4eccb853664de7bcf9518fb658f35e748bf1f68:

  vfio/pci: Bypass IGD init in case of -ENODEV (2020-11-03 11:07:40 -0700)

----------------------------------------------------------------
VFIO fixes for v5.10-rc3

 - Remove code by using existing helper (Zenghui Yu)

 - fsl-mc copy-user return and underflow fixes (Dan Carpenter)

 - fsl-mc static function declaration (Diana Craciun)

 - Fix ioeventfd sleeping under spinlock (Alex Williamson)

 - Fix pm reference count leak in vfio-platform (Zhang Qilong)

 - Allow opening IGD device w/o OpRegion support (Fred Gao)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/pci: Implement ioeventfd thread handler for contended memory lock

Dan Carpenter (2):
      vfio/fsl-mc: return -EFAULT if copy_to_user() fails
      vfio/fsl-mc: prevent underflow in vfio_fsl_mc_mmap()

Diana Craciun (1):
      vfio/fsl-mc: Make vfio_fsl_mc_irqs_allocate static

Fred Gao (1):
      vfio/pci: Bypass IGD init in case of -ENODEV

Zenghui Yu (1):
      vfio/type1: Use the new helper to find vfio_group

Zhang Qilong (1):
      vfio: platform: fix reference leak in vfio_platform_open

 drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 10 +++++--
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c       |  2 +-
 drivers/vfio/pci/vfio_pci.c                  |  2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c             | 43 ++++++++++++++++++++++------
 drivers/vfio/platform/vfio_platform_common.c |  3 +-
 drivers/vfio/vfio_iommu_type1.c              | 17 ++++-------
 6 files changed, 50 insertions(+), 27 deletions(-)

