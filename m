Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBFD54DDAB
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376457AbiFPIzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376458AbiFPIzD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:55:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016409FEF
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 01:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FF5CCE2420
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2088C34114;
        Thu, 16 Jun 2022 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655369603;
        bh=pFsQnxa2DjpyX/4z7Qk7RS/OvZLPS/MVPEtG62duvmE=;
        h=From:To:Cc:Subject:Date:From;
        b=XSBCdmMMDMl4BJbZEqkhUGxU1QwrA7qSLluqX1cIk8k2utKGj/rIZc71GEiTtvd8W
         hXZMPmyoTtQh4VcEEzCGLPnvc1795pTCKKOvER17SZBUNjnNqZKy3GiXD6TBFyAf+z
         UgWsPzLjklBOfi5jKecCSEE3/NIVc+igt7zplb4pzWwcbx5qeQ/gYIwlvNogODZWBU
         cjfG0PtursmT3clBUGcu3ZAASjpGDy64I2jIrgzT6Xfn7V2q4kdnH2vSYhUnYeSsTa
         2Niu/5LvCVrIL4UGu5lnFbMhA9KRXHVSinN17CWVvGUShglWmPta3fXdfEr4fYKepW
         ut8tETsTgUT4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o1lFh-0010oa-CV;
        Thu, 16 Jun 2022 09:53:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: Add Oliver as a reviewer
Date:   Thu, 16 Jun 2022 09:53:18 +0100
Message-Id: <20220616085318.1303657-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
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

Oliver Upton has agreed to help with reviewing the KVM/arm64
patches, and has been doing so for a while now, so adding him
as to the reviewer list.

Note that Oliver is using a different email address for this
purpose, rather than the one his been using for his other
contributions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6d3bd9d2a8d..7192d1277558 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10821,6 +10821,7 @@ M:	Marc Zyngier <maz@kernel.org>
 R:	James Morse <james.morse@arm.com>
 R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
+R:	Oliver Upton <oliver.upton@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu (moderated for non-subscribers)
 S:	Maintained
-- 
2.34.1

