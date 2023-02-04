Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA868AA9E
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjBDOmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDOmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:42:11 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8877433467
        for <kvm@vger.kernel.org>; Sat,  4 Feb 2023 06:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675521730; x=1707057730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kPeOQcVMtnCvSnNlnURhEYPVpdpsOaidTcnKfoxdd6M=;
  b=Cu3Ws9exduXW/QQMTWVmNMSqtGfFYrw0uKr4SaZLN25JkfNrqrI3LCW6
   bd8gpHkhWVDTsPOtWbsk0hVdzzHw/tuasmCWibhaYjQJpJFbmUueK+5T8
   noNFWvdytfo2smcBbJyU1CTRHzLcVxkcgZ5l/NFXgwtLfl2mDhJMFasnp
   x77MN0BtXEERMYHmANA8KQoi/JHL02koEaIpQHC4W/ZwFK0vlIe+ryObB
   7XYuDDcNhRvwpyqzr0+lx26Lf++uI5xh20fLYhWXN+HbMcqVgj7PvQtZA
   ubSp9SUOjjReT4uTW1VzC3wOOKgRVat/uJyYelueBFlCgBQcWk7viHlD5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="415163488"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="415163488"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 06:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="994809702"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="994809702"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 04 Feb 2023 06:42:09 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 0/2] Update VFIO doc
Date:   Sat,  4 Feb 2023 06:42:06 -0800
Message-Id: <20230204144208.727696-1-yi.l.liu@intel.com>
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

v3:
 - Fix issues reported by kernel test robot <lkp@intel.com>

v2: https://lore.kernel.org/kvm/20230203083345.711443-1-yi.l.liu@intel.com/
 - Add Kevin's r-b for patch 0001
 - Address comments from Alex and Kevin on the statements in patch 0002

v1: https://lore.kernel.org/kvm/20230202080201.338571-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (2):
  vfio: Update the kdoc for vfio_device_ops
  docs: vfio: Update vfio.rst per latest interfaces

 Documentation/driver-api/vfio.rst | 79 ++++++++++++++++++++++---------
 include/linux/vfio.h              |  4 ++
 2 files changed, 61 insertions(+), 22 deletions(-)

-- 
2.34.1

