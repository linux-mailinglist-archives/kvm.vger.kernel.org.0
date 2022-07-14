Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542405751F2
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbiGNPfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240354AbiGNPff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:35:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BCD491D0
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:35:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1A9261F35
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 15:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32182C3411C;
        Thu, 14 Jul 2022 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657812933;
        bh=cjEJJ+tICPXcomBqvfwVOb8VeczOy4va3hJvn5AgE1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7yEei5g2NQKRLAboRSC5hlT9zP8nF8cCAQ7RDl/+9HlnGBJEA2Qk5XUljJRJynf6
         yCmNOw7laNWrVNZo/0zaGtqROxAHYOXWw4Z9DMCBqMj12uPEB0XZ89TI8ci3smUKF0
         rCrbDNoiX3btCpBwfdMPBkGSfE0t42D3YqQnLeXtseUXRrf86l9gwkOLP3045n5N5b
         s3gxUD8I8ShENVEHIAl23m8SDZr5Vl0gNTF1qFQoXRRzL30ouEqUlOhJPd8dp6Hy/G
         sJSQzDGz7dim4LrHtPAwAlWzghsCDb6XcBbLdLoaRLeSu06jy1lVGSDFGtgbsw4Lee
         CMi0HSymIoB7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oC0dl-007UVL-C2;
        Thu, 14 Jul 2022 16:20:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
Subject: [PATCH v2 20/20] KVM: arm64: Get rid or outdated comments
Date:   Thu, 14 Jul 2022 16:20:24 +0100
Message-Id: <20220714152024.1673368-21-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 7ab67a7fc0d8..b4fda04413f2 100644
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

