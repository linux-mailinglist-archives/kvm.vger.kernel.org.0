Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266624CFD05
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbiCGLfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 06:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242109AbiCGLe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 06:34:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D832B27C;
        Mon,  7 Mar 2022 03:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F9F1B8111C;
        Mon,  7 Mar 2022 11:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A50C340F4;
        Mon,  7 Mar 2022 11:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646652820;
        bh=oJjvQRlXDIORZ45BctpR1F4Q9zXJHSu07f6PG8R9taY=;
        h=From:To:Cc:Subject:Date:From;
        b=YL23wSNCGKMk5wn4HZrbDDSDjOVT1fPgNXsaQVR0vMwzO8H6gtd65SL8Wcb+5vuh/
         E+py4FJwPp+KKw63KpETlZWT3RQu5fRTPV8xWS7rWqqPzgykq1KymBRx3amAZC2H7b
         DMqXm7MdEcp9v8AXA/XJz3WdgRkENdEEuWNVLqiQ/zNMDx0PMJBB1rpkU0cIM89AR/
         eCk0dcr6nDP2YBEr7uuIQAG4TKqHr/cquxz79GcbcmR6YmYroMmg4za5icivXxoJcP
         Y0QWtjW3f42g1I5R5yv1FbfyKhOjwaS0VnGQvfLKKqdu9wqv0u0i4vEgUJytSMvWFM
         rCAhTLh9gGqvQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH vfio-next] PCI/IOV: Fix wrong kernel-doc identifier
Date:   Mon,  7 Mar 2022 13:33:25 +0200
Message-Id: <8cecf7df45948a256dc56148cf9e87b2f2bb4198.1646652504.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Replace "-" to be ":" in comment section to be aligned with
kernel-doc format.

drivers/pci/iov.c:67: warning: Function parameter or member 'dev' not described in 'pci_iov_get_pf_drvdata'
drivers/pci/iov.c:67: warning: Function parameter or member 'pf_driver' not described in 'pci_iov_get_pf_drvdata'

Fixes: a7e9f240c0da ("PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/iov.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 28ec952e1221..952217572113 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -49,8 +49,8 @@ EXPORT_SYMBOL_GPL(pci_iov_vf_id);
 
 /**
  * pci_iov_get_pf_drvdata - Return the drvdata of a PF
- * @dev - VF pci_dev
- * @pf_driver - Device driver required to own the PF
+ * @dev: VF pci_dev
+ * @pf_driver: Device driver required to own the PF
  *
  * This must be called from a context that ensures that a VF driver is attached.
  * The value returned is invalid once the VF driver completes its remove()
-- 
2.35.1

