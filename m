Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A164B13301
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfECRP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:15:57 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37640 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfECRP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:15:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA26515BF;
        Fri,  3 May 2019 10:15:56 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 009DE3F557;
        Fri,  3 May 2019 10:15:55 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 2/4] vfio: remove unneeded test
Date:   Fri,  3 May 2019 18:15:42 +0100
Message-Id: <20190503171544.260901-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503171544.260901-1-andre.przywara@arm.com>
References: <20190503171544.260901-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang complained that the comparison of an u8 variable against 256 is
somewhat pointless.

Just remove the check, as the condition will never hit.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 vfio/pci.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 10aa87b1..a4086326 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -557,11 +557,6 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
 	pdev->hdr.capabilities = 0;
 
 	for (; pos; pos = next) {
-		if (pos >= PCI_DEV_CFG_SIZE) {
-			vfio_dev_warn(vdev, "ignoring cap outside of config space");
-			return -EINVAL;
-		}
-
 		cap = PCI_CAP(&pdev->hdr, pos);
 		next = cap->next;
 
-- 
2.17.1

