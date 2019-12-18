Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC12124883
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 14:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLRNfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 08:35:36 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:43398 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbfLRNfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 08:35:36 -0500
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ihZU8-0004Uz-Ll; Wed, 18 Dec 2019 13:35:28 +0000
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1ihZU6-00Awcg-Pc; Wed, 18 Dec 2019 13:35:26 +0000
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     ben.dooks@codethink.co.uk
Cc:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Allison Randal <allison@lohutok.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: platform: fix __iomem in vfio_platform_amdxgbe.c
Date:   Wed, 18 Dec 2019 13:35:25 +0000
Message-Id: <20191218133525.2608583-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ioaddr should have __iomem marker on it, so add that to fix
the following sparse warnings:

drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:33:44: warning: incorrect type in argument 2 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:33:44:    expected void volatile [noderef] <asn:2> *addr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:33:44:    got void *
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:34:33: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:34:33:    expected void const volatile [noderef] <asn:2> *addr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:34:33:    got void *
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:44:44: warning: incorrect type in argument 2 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:44:44:    expected void volatile [noderef] <asn:2> *addr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:44:44:    got void *
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:45:33: warning: incorrect type in argument 2 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:45:33:    expected void volatile [noderef] <asn:2> *addr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:45:33:    got void *
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:69:41: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:69:41:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:69:41:    got void [noderef] <asn:2> *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:71:30: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:71:30:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:71:30:    got void [noderef] <asn:2> *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:76:49: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:76:49:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:76:49:    got void [noderef] <asn:2> *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:85:37: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:85:37:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:85:37:    got void [noderef] <asn:2> *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:87:30: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:87:30:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:87:30:    got void [noderef] <asn:2> *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:90:30: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:90:30:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:90:30:    got void [noderef] <asn:2> *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:93:30: warning: incorrect type in argument 1 (different address spaces)
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:93:30:    expected void *ioaddr
drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:93:30:    got void [noderef] <asn:2> *ioaddr

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
index 2d2babe21b2f..ecfc908de30f 100644
--- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -24,7 +24,7 @@
 #define MDIO_AN_INT		0x8002
 #define MDIO_AN_INTMASK		0x8001
 
-static unsigned int xmdio_read(void *ioaddr, unsigned int mmd,
+static unsigned int xmdio_read(void __iomem *ioaddr, unsigned int mmd,
 			       unsigned int reg)
 {
 	unsigned int mmd_address, value;
@@ -35,7 +35,7 @@ static unsigned int xmdio_read(void *ioaddr, unsigned int mmd,
 	return value;
 }
 
-static void xmdio_write(void *ioaddr, unsigned int mmd,
+static void xmdio_write(void __iomem *ioaddr, unsigned int mmd,
 			unsigned int reg, unsigned int value)
 {
 	unsigned int mmd_address;
-- 
2.24.0

