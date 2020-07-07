Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6610216373
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 03:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGGBog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 21:44:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:40649 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgGGBof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 21:44:35 -0400
IronPort-SDR: lXTP9Mb1/OvcMrzJk7R7z7kIaaslSUq1eXnrawBCINmHY+O2TGjFsKQRMjpQ7DhzXQUSPp+kyo
 1SZ9ijSsQkeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="147536122"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="147536122"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 18:44:35 -0700
IronPort-SDR: HFLhQnGpMHKamOHZBRQ+F+vBuVPMBcUnf+p3xHf4IHlvImkUA3ScTysnJAuTevgcGcP2WaYAEb
 hzRXtwRh7few==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="266688906"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jul 2020 18:44:32 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 0/2] iommu_aux_at(de)tach_device() enhancement
Date:   Tue,  7 Jul 2020 09:39:55 +0800
Message-Id: <20200707013957.23672-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims to enhance the iommu_aux_at(de)tach_device() api's
so that some generic iommu api's like iommu_get_domain_for_dev() could
also work for vfio/mdev device.

The initial version of this series was post at

https://lkml.org/lkml/2020/6/26/1118

This version is evolved according to Robin's feedback.

Your comments are very appreciated.

Best regards,
baolu

Lu Baolu (2):
  iommu: iommu_aux_at(de)tach_device() extension
  iommu: Add aux_domain_attached flag to iommu_group

 drivers/iommu/iommu.c           | 98 +++++++++++++++++++++++++++++----
 drivers/vfio/vfio_iommu_type1.c |  5 +-
 include/linux/iommu.h           | 12 ++--
 3 files changed, 99 insertions(+), 16 deletions(-)

-- 
2.17.1

