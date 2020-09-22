Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B591E273A94
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 08:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgIVGQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 02:16:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:45065 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbgIVGQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 02:16:53 -0400
IronPort-SDR: ZsUj4qbAu/7JP6igfvIoYOLbe2cJ+YDR1P72npZn5vnMl2eLdpIh1IQPyoHc4kPF0V/H0LsLe7
 3hc3Ll7DFohQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="140023298"
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="140023298"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 23:16:53 -0700
IronPort-SDR: MRN1pkDHtVIp8X7IJS5GWx5rYmWiDE08UuKtxsPLLtqWw5ql7hbfKzxbhbczzbNIAFnIiY8+kw
 y7Nbta3zIyZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="334877182"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 21 Sep 2020 23:16:50 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 0/5] iommu aux-domain APIs extensions
Date:   Tue, 22 Sep 2020 14:10:37 +0800
Message-Id: <20200922061042.31633-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jorge and Alex,

A description of this patch series could be found here.

https://lore.kernel.org/linux-iommu/20200901033422.22249-1-baolu.lu@linux.intel.com/

This version adds some changes according to Alex's review comments.

- Add comments and naming rule for subdevices.
https://lore.kernel.org/linux-iommu/20200910160549.2b176ac5@w520.home/

- Continue detaching even no subdevice parent found.
https://lore.kernel.org/linux-iommu/20200910160547.0a8b9891@w520.home/

- Make subdev_link_device() and subdev_unlink_device() symmetrical.

Please help to review and merge.

Best regards,
baolu

Lu Baolu (5):
  iommu: Add optional subdev in aux_at(de)tach ops
  iommu: Add iommu_at(de)tach_subdev_group()
  iommu: Add iommu_aux_get_domain_for_dev()
  vfio/type1: Use iommu_aux_at(de)tach_group() APIs
  iommu/vt-d: Add is_aux_domain support

 drivers/iommu/intel/iommu.c     | 139 +++++++++++++++++-------
 drivers/iommu/iommu.c           | 184 ++++++++++++++++++++++++++++++--
 drivers/vfio/vfio_iommu_type1.c |  43 ++------
 include/linux/intel-iommu.h     |  17 +--
 include/linux/iommu.h           |  46 +++++++-
 5 files changed, 336 insertions(+), 93 deletions(-)

-- 
2.17.1

