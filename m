Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1AE55137F
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 10:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240320AbiFTIzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 04:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240303AbiFTIzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 04:55:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5D2E5E
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 01:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655715301; x=1687251301;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xdGFtnQ0kvd++DKDY/S4YsnLbZTTt8Yxa0zMPf9VGRA=;
  b=kY04GFGB/v9gImOFf/icUzYuSkVKf3d8mkivvzLRriuEawfhqidm74I/
   2ZPsC1RkWPiHT8VdPtkbRqbB7d+iAJ+iIXCOmGGLUqkfldVz69Ay56fpm
   P4eywcy1hEzpyCS8ewbQR9yJDN8gUNzskp8CDvs7MMRqp+NvK8PEMnEqM
   1c6srVgwFRBFq8/xaUajTeSqQAyDxz/reEYq1cidhymUeBy2dQqfvCsic
   ibh91kVM74ruxFF6ML0Mfh9/kSLIl08j3HkvOI8OduGE8OQhY//krqyeO
   3Fb2hLAzhNpGr4sBezv/S6mdnnjSBxTHOeRfoIHPtPu6uOQMes5X7YbQi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="277390701"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="277390701"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="913563630"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jun 2022 01:55:00 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com
Cc:     yi.l.liu@intel.com, kevin.tian@intel.com, kvm@vger.kernel.org,
        jgg@nvidia.com
Subject: [Patch 0/1] A bug fix to the error handling path in vfio_device_open()
Date:   Mon, 20 Jun 2022 01:54:58 -0700
Message-Id: <20220620085459.200015-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The open_count is unnecessarily placed in the group_rwsem in the error
handling path.

Yi Liu (1):
  vfio: Move "device->open_count--" out of group_rwsem in
    vfio_device_open()

 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.27.0

