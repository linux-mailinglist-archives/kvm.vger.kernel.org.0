Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31986876F0
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjBBIC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBBICQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:02:16 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE92D83979
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675324929; x=1706860929;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a1J2CPibnh+obWKyBoHLAi2z0THInYbcDkixJGEHq6k=;
  b=Hq8+DyzkrMS4JvWLzGjJ1d51gdDpS8mrJqIcuEB1GCtuUGkexaakLaqK
   vwNSQfbGrkt6JjETqp6y9KxqtVz0CnFEBBvE7g0HWXt7NdYQmHJ3JoNyN
   RF95fFPS+F4LqRfjmhIH12KWOOybepg5eKFceJwLEI7hcDQYNeMYMEEvl
   eFHDlgd61a1Gtaq4qdaSRy25RMsDXbpXFpds+smCTcdSPdjbvDJ3nES1M
   vketv/wetNAlPibQhc1HMOZq8UnaYazYac1S+zgqeil9g9piLlOZrCfnx
   tn3StKbpIi7vpiE4Ca9P9tFwcqBs3P800XtZK19W8Rgu1t1oqRhF+VSy1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="355722223"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="355722223"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 00:02:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993990679"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="993990679"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2023 00:02:02 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, kvm@vger.kernel.org
Subject: [PATCH 0/2] Update VFIO doc
Date:   Thu,  2 Feb 2023 00:01:59 -0800
Message-Id: <20230202080201.338571-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two updates VFIO doc.

Yi Liu (2):
  vfio: Update the kdoc for vfio_device_ops
  docs: vfio: Update vfio.rst per latest interfaces

 Documentation/driver-api/vfio.rst | 71 +++++++++++++++++++++----------
 include/linux/vfio.h              |  4 ++
 2 files changed, 52 insertions(+), 23 deletions(-)

-- 
2.34.1

