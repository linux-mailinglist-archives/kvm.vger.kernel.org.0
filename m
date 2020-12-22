Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D1D2DC74B
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 20:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgLPTii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 14:38:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbgLPTii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 14:38:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608147431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YSOn/k1Hw3PBV10RiB9kjk1aQ7QyRB3qI+j4unC73oI=;
        b=XmwrndeU3pBY4WoT0oCKwaLkau8Wg1V20NOgcgw57braFsmvJD3lPDEENJB1XAp8ircIbB
        7i41UCqwjlzibq3z7FN7l1nElBBStFDvDsK7WzYD4iHpTNzANiQrwZctzhiHoFdgxz9UIL
        3uy/WnZARnaEPDgxKASDqQkYtrUaRy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-p0hO15rhNR-TlnjQbwOxFA-1; Wed, 16 Dec 2020 14:37:07 -0500
X-MC-Unique: p0hO15rhNR-TlnjQbwOxFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64071180A086;
        Wed, 16 Dec 2020 19:37:06 +0000 (UTC)
Received: from omen.home (ovpn-112-193.phx2.redhat.com [10.3.112.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1817177F8;
        Wed, 16 Dec 2020 19:37:01 +0000 (UTC)
Date:   Wed, 16 Dec 2020 12:37:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, eric.auger@redhat.com,
        jgg@nvidia.com, aik@ozlabs.ru, farman@linux.ibm.com,
        baolu.lu@linux.intel.com
Subject: [GIT PULL] VFIO updates for v5.11-rc1
Message-ID: <20201216123701.00517b52@omen.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit b65054597872ce3aefbc6a666385eabdf9e288da:

  Linux 5.10-rc6 (2020-11-29 15:50:50 -0800)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.11-rc1

for you to fetch changes up to bdfae1c9a913930eae5ea506733aa7c285e12a06:

  vfio/type1: Add vfio_group_iommu_domain() (2020-12-10 14:47:56 -0700)

----------------------------------------------------------------
VFIO updates for v5.11-rc1

 - Fix uninitialized list walk in error path (Eric Auger)

 - Use io_remap_pfn_range() (Jason Gunthorpe)

 - Allow fallback support for NVLink on POWER8 (Alexey Kardashevskiy)

 - Enable mdev request interrupt with CCW support (Eric Farman)

 - Enable interface to iommu_domain from vfio_group (Lu Baolu)

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      vfio/pci/nvlink2: Do not attempt NPU2 setup on POWER8NVL NPU

Eric Auger (1):
      vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Eric Farman (2):
      vfio-mdev: Wire in a request handler for mdev parent
      vfio-ccw: Wire in the request callback

Jason Gunthorpe (1):
      vfio-pci: Use io_remap_pfn_range() for PCI IO memory

Lu Baolu (1):
      vfio/type1: Add vfio_group_iommu_domain()

 drivers/s390/cio/vfio_ccw_ops.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  4 ++++
 drivers/vfio/mdev/mdev_core.c       |  4 ++++
 drivers/vfio/mdev/vfio_mdev.c       | 13 +++++++++++++
 drivers/vfio/pci/vfio_pci.c         |  7 +++----
 drivers/vfio/pci/vfio_pci_nvlink2.c |  7 +++++--
 drivers/vfio/vfio.c                 | 18 ++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c     | 24 ++++++++++++++++++++++++
 include/linux/mdev.h                |  4 ++++
 include/linux/vfio.h                |  4 ++++
 include/uapi/linux/vfio.h           |  1 +
 11 files changed, 106 insertions(+), 6 deletions(-)

