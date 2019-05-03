Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98F7132FF
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfECRP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:15:56 -0400
Received: from foss.arm.com ([217.140.101.70]:37636 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfECRP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:15:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B54C315AD;
        Fri,  3 May 2019 10:15:55 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFD853F557;
        Fri,  3 May 2019 10:15:54 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 1/4] vfio: remove spurious ampersand
Date:   Fri,  3 May 2019 18:15:41 +0100
Message-Id: <20190503171544.260901-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503171544.260901-1-andre.przywara@arm.com>
References: <20190503171544.260901-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As clang rightfully pointed out, the ampersand in front of this member
looks wrong.

Remove it so we actually really compare against the count being 0.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 vfio/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index f17498ea..10aa87b1 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -952,7 +952,7 @@ static int vfio_pci_init_msis(struct kvm *kvm, struct vfio_device *vdev,
 	size_t nr_entries = msis->nr_entries;
 
 	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &msis->info);
-	if (ret || &msis->info.count == 0) {
+	if (ret || msis->info.count == 0) {
 		vfio_dev_err(vdev, "no MSI reported by VFIO");
 		return -ENODEV;
 	}
-- 
2.17.1

