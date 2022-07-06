Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4B6569042
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiGFRFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbiGFRFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:05:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4E62A701
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 178E3B81E4C
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2827C341C8;
        Wed,  6 Jul 2022 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657127131;
        bh=Eo9E4Nefyu/Kf+UJWebrylD0pKTMwvYjQaj9htsyQe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRmbHljJgJEVO+HqXEZGu487VsQfX7AGbih8FpxCRrSwrg7J7LdtqXQ12Nj6Bqn5B
         JAgziUhqyGutnTWVUmiO3iabG2VYhs/thU4Y5c2/ygtMPxCLszjYUtuCOc023yyE9W
         uExYCn0F293j4jmXKO6y1GtqOG7IJ8gGC+VDvmRjNbYAOUwwvy6YA4OBURZ9KFDaah
         A6sBEJjjORU6+FdQUnv6IQTNHhokEvC7whp/NN7wZIXO8mtCt6TrmcZZEHZsTKm0Nq
         l6b4HDvElmb9IxjZ2HVCQaKBVhvq5W3dBMFDHafYpg3OnPlr4W3nluL7yG9BxtOBAt
         alINKA+9NKIOw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o987O-005h9i-Oa;
        Wed, 06 Jul 2022 17:43:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH 19/19] KVM: arm64: Get rid or outdated comments
Date:   Wed,  6 Jul 2022 17:43:04 +0100
Message-Id: <20220706164304.1582687-20-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706164304.1582687-1-maz@kernel.org>
References: <20220706164304.1582687-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once apon a time, the 32bit KVM/arm port was the reference, while
the arm64 version was the new kid on the block, without a clear
future... This was a long time ago.

"The times, they are a-changing."

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d3ac0cd1c2e2..8dc93d372d4f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -34,11 +34,6 @@
 #include "trace.h"
 
 /*
- * All of this file is extremely similar to the ARM coproc.c, but the
- * types are different. My gut feeling is that it should be pretty
- * easy to merge, but that would be an ABI breakage -- again. VFP
- * would also need to be abstracted.
- *
  * For AArch32, we only take care of what is being trapped. Anything
  * that has to do with init and userspace access has to go via the
  * 64bit interface.
-- 
2.34.1

