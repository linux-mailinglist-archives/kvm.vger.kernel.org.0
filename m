Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39286698B1
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241647AbjAMNge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241677AbjAMNfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:35:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C37DDD4
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 05:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2E2D61CCC
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 13:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E4CC433D2;
        Fri, 13 Jan 2023 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673616497;
        bh=p0imUzLtfN9VVvFHx51VODYdDfWqho2b57JiDvRO62k=;
        h=From:To:Cc:Subject:Date:From;
        b=tvkjA53rvtl38GhbLyIwUnmaBSUXtSQFTj6a8uhOgvm7kpJgxdiEEZMeWIB1kLC5I
         gRaDW+cRVyqO10K0ywxnrEk8XFPpFVpYGsl8/PhaK9aPvQYKsxmItukkwFi5iIfcFk
         vJNqOy+zEAgsan6p4IB9CerrCedRw7Ee0jVbdUvMR2gDbZuf0aK3Rzsj777AzuxK4i
         lvVpXa3LDf7oUDaLd3Y2vx1VfgdKNuOGXaX/Wn3mtSxiqMbLKvZpmqiqSy0N7k4Kg2
         1+1AMNE3HAmtIMtd3H8mOc5UCGhVj72TbJS/4giyyFTzzerVEdmuJJQEE3/NM+PheO
         JI0MnuKfgjdJQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pGK6P-001WXZ-9H;
        Fri, 13 Jan 2023 13:28:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Drop Columbia-hosted mailing list
Date:   Fri, 13 Jan 2023 13:28:09 +0000
Message-Id: <20230113132809.1979119-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After many years of awesome service, the kvmarm mailing list hosted by
Columbia is being decommissioned, and replaced by kvmarm@lists.linux.dev.

Many thanks to Columbia for having hosted us for so long, and to the
kernel.org folks for giving us a new home.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a0fc23455bd..d9a359a65d0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11361,7 +11361,6 @@ R:	Oliver Upton <oliver.upton@linux.dev>
 R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
-L:	kvmarm@lists.cs.columbia.edu (deprecated, moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 F:	arch/arm64/include/asm/kvm*
-- 
2.34.1

