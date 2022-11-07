Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D5D61EF4A
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKGJmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiKGJmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:42:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E13B87D
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 01:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667814138; x=1699350138;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fiKv0pdnXdluc73wvAqeI7JGHQLm9IbFYrJKBmjYOz4=;
  b=RR4azR14lU782ioU9tz8Vq5/nafp8Jyu3J/GYSgorxu0OSHn0mL1ESNa
   1HUC+2oi2n8wnIb8NBpUSTI7RBWrT+jKq1in69qAqvk93qnP41bmHO3mz
   nwSnTI2NkzTCH26Kzgh1vcWGkTOghJMc4iRdomdsVJXGUiQq7aIVraPdx
   l4ndFxgnhKE8t1jaKoLtAmk19BG2ecVgGGDSnFlKvEmBLEbig2Cqhcs3N
   cFYLraroW1sOWj7ZQ+ukSnL8NfgwMJE5eral5Hn65ROhE9DJmPsLP1nMU
   JG+sr8uWJafasN0UHdj+k9xrZ9WSMWfM0/AFZYnRB/uZB/O09vyQDaynO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="310370498"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="310370498"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:42:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704810795"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704810795"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:42:16 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/4] ifcvf/vDPA implement features provisioning
Date:   Mon,  7 Nov 2022 17:33:41 +0800
Message-Id: <20221107093345.121648-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements features provisioning for ifcvf.
By applying this series, we allow userspace to create
a vDPA device with selected (management device supported)
feature bits and mask out others.

Please help review

Thanks

Zhu Lingshan (4):
  vDPA/ifcvf: ifcvf base layer interfaces work on struct ifcvf_hw
  vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
  vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
  vDPA/ifcvf: implement features provisioning

 drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
 drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
 drivers/vdpa/ifcvf/ifcvf_main.c | 156 +++++++++++++++-----------------
 3 files changed, 89 insertions(+), 109 deletions(-)

-- 
2.31.1

