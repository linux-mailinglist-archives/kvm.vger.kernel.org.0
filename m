Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D133FF59A
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347017AbhIBV1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:27:38 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59366
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245379AbhIBV1i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 17:27:38 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 4927D3F112;
        Thu,  2 Sep 2021 21:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630617992;
        bh=E0+rjETp1q3bF8ZXs+1AdT+BHFcfxbmgeeVYX//s5wE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=MkRRkl08bMgIfGvpGCeikhiC1LBLteA04+O8lK+1IjhGyLbwS8lBHyX1iuvHyl8QE
         65XKOtGSGaQpipZBucZKrwcYgPkigcJwq6T79FyBRa0SYjl6IQOf5CZvova+nvYJKS
         gREk0bWrL9Q6KrdQjxMSq1FqZK588z7iOhqaKSIP6t1Z+v77sSBNAqvsB2CMDFzCVb
         AdEwg+1cBk6kAFxqy2z7kDm78JzmuvtNvOJ5OxA6NNEiN1LCmgvY/TleHuEkw5Hqq8
         JJcA6nkXeu4hEVJDTB4hnkbLkDL84ih2cnsXGusn8w63JZPwCc1EcXrcB6iPRW9IFU
         lsuDC6SAWKOSA==
From:   Colin King <colin.king@canonical.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] vfio/pci: add missing identifier name in argument of function prototype
Date:   Thu,  2 Sep 2021 22:26:31 +0100
Message-Id: <20210902212631.54260-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The function prototype is missing an identifier name. Add one.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 68198e0f2a63..a03b5a99c2da 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -565,7 +565,7 @@ static bool vfio_pci_dev_below_slot(struct pci_dev *pdev, struct pci_slot *slot)
 }
 
 struct vfio_pci_walk_info {
-	int (*fn)(struct pci_dev *, void *data);
+	int (*fn)(struct pci_dev *pdev, void *data);
 	void *data;
 	struct pci_dev *pdev;
 	bool slot;
-- 
2.32.0

