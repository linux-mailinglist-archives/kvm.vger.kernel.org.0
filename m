Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA212D4BE7
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgLIUbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:31:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:64821 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgLIUbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 15:31:00 -0500
IronPort-SDR: FainkkfyZHrCTKH65VHQjJOLtS7U6cYfS5o8NkPbcE/0g2pG0ae+A/uKNSN3IFG425QE2USmyT
 4FdzGSz2d3Fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="173383197"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="173383197"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 12:29:11 -0800
IronPort-SDR: OWkzm9C0bxeDUxcMr0BM9sPClVzq9KjA/tYUzOTRk6jgqAV6Qj2bc0Slp8OaPaWAHq0BABFsDY
 AJv/bGpAnx7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="552771422"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 09 Dec 2020 12:29:10 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 831801C8; Wed,  9 Dec 2020 22:29:09 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] vfio: platform: enable compile test
Date:   Wed,  9 Dec 2020 22:29:08 +0200
Message-Id: <20201209202908.61658-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable compile test of the VFIO platform code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/vfio/platform/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index dc1a3c44f2c6..d19051b68952 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
-	depends on VFIO && EVENTFD && (ARM || ARM64)
+	depends on (ARM || ARM64) || COMPILE_TEST
+	depends on VFIO && EVENTFD
 	select VFIO_VIRQFD
 	help
 	  Support for platform devices with VFIO. This is required to make
-- 
2.29.2

