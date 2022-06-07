Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4222854043F
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345341AbiFGRDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345224AbiFGRDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:16 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27939FF588
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5489814BF;
        Tue,  7 Jun 2022 10:03:14 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DBAC13F66F;
        Tue,  7 Jun 2022 10:03:12 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 01/24] virtio: Add NEEDS_RESET to the status mask
Date:   Tue,  7 Jun 2022 18:02:16 +0100
Message-Id: <20220607170239.120084-2-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
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

Not all toolchains used to know about VIRTIO_CONFIG_S_NEEDS_RESET, so we
left it out of the status mask. Now that we include our own version of
virtio_config.h and we'll need it for virtio 1.0, add it back.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index ad274acf..8a363632 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -35,6 +35,7 @@
 	 VIRTIO_CONFIG_S_DRIVER |	\
 	 VIRTIO_CONFIG_S_DRIVER_OK |	\
 	 VIRTIO_CONFIG_S_FEATURES_OK |	\
+	 VIRTIO_CONFIG_S_NEEDS_RESET |	\
 	 VIRTIO_CONFIG_S_FAILED)
 
 /* Kvmtool status bits */
-- 
2.36.1

