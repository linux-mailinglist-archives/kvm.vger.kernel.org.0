Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFB568925D
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjBCIdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjBCIdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:33:50 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688EE70D7C
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 00:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675413227; x=1706949227;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kMMrIxIMuTISc8yfRxDIxDjxe6Q96bP8hvQjAhquBJw=;
  b=S711XVTCyKf6yw66lfhfj/jQX3Yvh4DoIMio4cfKN3Fnf8D8Alf/tz0r
   1XJ/8E+2dvf325tm9pVJ0Jlzy7qrNBoCSDWiUFido3MJYQaHvjVJ6rjwB
   2hoHSKGHnHXf2qc0+42ZbRmwTQyUOiYt2gcH48jt0no5rkDTQrQ7/VdBD
   uQEJybe8Y0hggult3RF76IOlhrWVzE0oLlwowtDYR6tyZcsUVEDt0XgGD
   tZkNjCx04Bq+0PMzoyW2x03h1ZeLwBIYOv6J0dKqoNzcY+QbEyloWIt1l
   wWYNSb+wQ/iKE67K4g3sPDGLIZwjZOEpbxBHomG4w4mYq7kcbmy3DXuG4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="391089866"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="391089866"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:33:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="667581565"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="667581565"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 03 Feb 2023 00:33:46 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH v2 0/2] Update VFIO doc
Date:   Fri,  3 Feb 2023 00:33:43 -0800
Message-Id: <20230203083345.711443-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two updates for VFIO doc.

v2:
 - Add Kevin's r-b for patch 0001
 - Address comments from Alex and Kevin on the statements in patch 0002

v1: https://lore.kernel.org/kvm/20230202080201.338571-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (2):
  vfio: Update the kdoc for vfio_device_ops
  docs: vfio: Update vfio.rst per latest interfaces

 Documentation/driver-api/vfio.rst | 70 +++++++++++++++++++++----------
 include/linux/vfio.h              |  4 ++
 2 files changed, 51 insertions(+), 23 deletions(-)

-- 
2.34.1

