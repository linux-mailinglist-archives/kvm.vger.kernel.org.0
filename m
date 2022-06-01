Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927FA53AB54
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351847AbiFAQwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343763AbiFAQww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:52:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16D2D33EBF
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:52:48 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA62D14BF;
        Wed,  1 Jun 2022 09:52:47 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 368E53F66F;
        Wed,  1 Jun 2022 09:52:47 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: [PATCH kvmtool 3/4] virtio/mmio: remove unneeded virtio_mmio_hdr members
Date:   Wed,  1 Jun 2022 17:51:37 +0100
Message-Id: <20220601165138.3135246-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601165138.3135246-1-andre.przywara@arm.com>
References: <20220601165138.3135246-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far "struct virtio_mmio_hdr" was modelled exactly like the virtio
MMIO protocol header, including reserved fields and members unused by
kvmtool.
Since we now no longer need to stay byte-for-byte compatible, drop those
members to clean up the code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/virtio-mmio.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index aa4cab3c..84848eee 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -22,22 +22,14 @@ struct virtio_mmio_hdr {
 	u32	vendor_id;
 	u32	host_features;
 	u32	host_features_sel;
-	u32	reserved_1[2];
 	u32	guest_features;
 	u32	guest_features_sel;
 	u32	guest_page_size;
-	u32	reserved_2;
 	u32	queue_sel;
 	u32	queue_num_max;
 	u32	queue_num;
 	u32	queue_align;
-	u32	queue_pfn;
-	u32	reserved_3[3];
-	u32	queue_notify;
-	u32	reserved_4[3];
 	u32	interrupt_state;
-	u32	interrupt_ack;
-	u32	reserved_5[2];
 	u32	status;
 };
 
-- 
2.25.1

