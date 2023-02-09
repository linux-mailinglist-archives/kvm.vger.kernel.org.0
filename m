Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445626901EE
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 09:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBIIMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 03:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBIIMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 03:12:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E2737F39
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 00:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675930334; x=1707466334;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nHOfETEjUEaTqgx0nvMiXsnanEq8nFIG88m/mLu98WE=;
  b=UWCxPtiD+BI7W3LjJ0jjqGxc/c8SRg1/oDuY3lF8/E/Ck6W1JugH6qwZ
   UkkFR06dUKxswa6dR28xCJ5gAl9Kpkh+34aMPlNIvYQtn4jhGMR9E22gH
   sfjG7VkzbA+k3bFMxFrnhaHEluzRLYkyqjdsdw4tkfBVa0K6g/ZuVP9hn
   8HZjenPCU5HFJ7R0wGPwmbGD5qUL3J8KswbHjUGWHNkhYnKJBQnjE6Hdx
   EDlo85ExLH3qJENOIKIIJZTr0J3jvEMnpk2X4LiPib1chK2cWCDfNX7SF
   mpkCB8MzkHlS5JQ9t6UlVW3PsiWzGWAXnyI+xLSQUVJxoXs4BZi9EY+7G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309694706"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="309694706"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 00:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667553948"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="667553948"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 09 Feb 2023 00:12:11 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [PATCH v4 0/2] Update VFIO doc
Date:   Thu,  9 Feb 2023 00:12:08 -0800
Message-Id: <20230209081210.141372-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two updates for VFIO doc.

v4:
 - Refine patch 02 per Alex's suggestion.

v3: https://lore.kernel.org/kvm/20230204144208.727696-1-yi.l.liu@intel.com/
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

 Documentation/driver-api/vfio.rst | 82 ++++++++++++++++++++++---------
 include/linux/vfio.h              |  4 ++
 2 files changed, 64 insertions(+), 22 deletions(-)

-- 
2.34.1

