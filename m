Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0FE1F67A5
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgFKMKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:10:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:41826 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728120AbgFKMJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:09:16 -0400
IronPort-SDR: ELf+8PttGbJalr1F61O5+aS6TMWOmaaxYa92LKeMlcK6Vbh7266zTGGVs60UUYb3GyN+/SGLgX
 ZVh8DAgUQ/Tg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:09:10 -0700
IronPort-SDR: zdJrmS05nqGvdCOFPSThSQmi8FAqZW48uSQ8cmjPhgjx2lPnU/4GQfi44jFm+5KANzVyxtEC1R
 w889JJzi9BCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="419082485"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga004.jf.intel.com with ESMTP; 11 Jun 2020 05:09:09 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/15] iommu/uapi: Add iommu_gpasid_unbind_data
Date:   Thu, 11 Jun 2020 05:15:26 -0700
Message-Id: <1591877734-66527-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existing iommu_gpasid_bind_data is used for binding guest page tables
to a specified PASID. While for unwind it, a unbind_data structure is
needed.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 include/uapi/linux/iommu.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 02eac73..46a7c57 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -332,6 +332,19 @@ struct iommu_gpasid_bind_data {
 	};
 };
 
+/**
+ * struct iommu_gpasid_unbind_data - Information about device and guest PASID
+ *				     unbinding
+ * @argsz:	User filled size of this data
+ * @flags:	Additional information on guest unbind request
+ * @pasid:	Process address space ID used for the guest mm in host IOMMU
+ */
+struct iommu_gpasid_unbind_data {
+	__u32 argsz;
+	__u64 flags;
+	__u64 pasid;
+};
+
 struct iommu_nesting_info {
 	__u32	size;
 	__u32	format;
-- 
2.7.4

