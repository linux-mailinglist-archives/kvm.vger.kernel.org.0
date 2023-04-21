Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D7F6EA33B
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 07:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjDUFgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 01:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDUFgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 01:36:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD525B93
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 22:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682055376; x=1713591376;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NhCt+EYVUpWUVzRjr4GeM4lOUS2uNHE4d1pigP+kHH0=;
  b=cd6oqRIfVbDSuksfvsUE9iHzJJGGtCAGDHZ0nvoYw1HtgCx+gpL/dJ4D
   cKpBCmZ1EvJ6pRR+OEffiqJ4L68nNOO+Q+JffYCMLCFCXcWelVnMk4SZY
   J9ov2kUGyjQ+45WYia467u4gXGLO5/I9RQsoMrXhiENwpgGnukn4KPSuB
   l4/T9IeKJL3SgVTQaDRnOka6SMQS5SSoLUxhxBiLRoI4LjFnRD80zvETS
   JCSuPa4yWMX7goI07bx5FOc4L2Tg6hcN1HMiWFK3DgugeCq36zeRFF6sl
   0HQBD2rWKhxlAmkZrHM9lTWNt65eo6xvR6JZOwrpgWrqzP2S8Y3HZIpak
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="344674694"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344674694"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 22:36:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="761445893"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="761445893"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga004.fm.intel.com with ESMTP; 20 Apr 2023 22:36:15 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kevin.tian@intel.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, yi.l.liu@intel.com,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com
Subject: [PATCH v3] docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs VFIO_GROUP_GET_DEVICE_FD ordering
Date:   Thu, 20 Apr 2023 22:36:11 -0700
Message-Id: <20230421053611.55839-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

as some vfio_device's open_device op requires kvm pointer and kvm pointer
set is part of GROUP_ADD.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
v3:
 - Add r-b from Kevin
 - Remove "::" to fix "WARNING: Literal block expected; none found."
   "make htmldocs" looks good.
 - Rename the subject per Alex's suggestion

v2: https://lore.kernel.org/kvm/20230222022231.266381-1-yi.l.liu@intel.com/
 - Adopt Alex's suggestion

v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
---
 Documentation/virt/kvm/devices/vfio.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
index 2d20dc561069..08b544212638 100644
--- a/Documentation/virt/kvm/devices/vfio.rst
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
 	- @groupfd is a file descriptor for a VFIO group;
 	- @tablefd is a file descriptor for a TCE table allocated via
 	  KVM_CREATE_SPAPR_TCE.
+
+The GROUP_ADD operation above should be invoked prior to accessing the
+device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
+drivers which require a kvm pointer to be set in their .open_device()
+callback.
-- 
2.34.1

