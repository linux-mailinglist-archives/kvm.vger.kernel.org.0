Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28F774B61
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbjHHUqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbjHHUpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:45:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF2B145B5
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:37:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C91624F7
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D2CC433D9;
        Tue,  8 Aug 2023 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495237;
        bh=v5iH5FTyEpyHMdqXE1ha5bdSz0FgSx4VbyMF9ixrvDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgRFK0ptG1ERD1TX77TFDwKBpe+d7jZu0ORf3YmnB3geXyhu9ThMCoq8Bc8aGOw0D
         3JDvolzRUCGqyNSJx4eyTesWoSWhBw33GONu+ETJeMLxDUYF4xRpNVxdnAOTd84DdG
         9XAcgVMvR16R0tL4oqurSnPXcYtcQET94QYP/8OZW6/8Ae+cpMopSfQSF++2GBqwSp
         zZ8D9lQeHAF/e8FZt930Gey3s7kXiAzeZXvYnQev4H2x9qO+Db15i2exPXPYAdWjqS
         sn7u3sgFENZK3rKJrzVS6pguHD8J8g8Go9zo4T4fmgvlxuYXUoG9Nt6aNLj98KOExC
         qqwlZoeOC5KBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBD-0037Ph-BW;
        Tue, 08 Aug 2023 12:47:15 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 02/27] arm64: Add missing ERX*_EL1 encodings
Date:   Tue,  8 Aug 2023 12:46:46 +0100
Message-Id: <20230808114711.2013842-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We only describe a few of the ERX*_EL1 registers. Add the missing
ones (ERXPFGF_EL1, ERXPFGCTL_EL1, ERXPFGCDN_EL1, ERXMISC2_EL1 and
ERXMISC3_EL1).

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 85447e68951a..ed2739897859 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -229,8 +229,13 @@
 #define SYS_ERXCTLR_EL1			sys_reg(3, 0, 5, 4, 1)
 #define SYS_ERXSTATUS_EL1		sys_reg(3, 0, 5, 4, 2)
 #define SYS_ERXADDR_EL1			sys_reg(3, 0, 5, 4, 3)
+#define SYS_ERXPFGF_EL1			sys_reg(3, 0, 5, 4, 4)
+#define SYS_ERXPFGCTL_EL1		sys_reg(3, 0, 5, 4, 5)
+#define SYS_ERXPFGCDN_EL1		sys_reg(3, 0, 5, 4, 6)
 #define SYS_ERXMISC0_EL1		sys_reg(3, 0, 5, 5, 0)
 #define SYS_ERXMISC1_EL1		sys_reg(3, 0, 5, 5, 1)
+#define SYS_ERXMISC2_EL1		sys_reg(3, 0, 5, 5, 2)
+#define SYS_ERXMISC3_EL1		sys_reg(3, 0, 5, 5, 3)
 #define SYS_TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
 #define SYS_TFSRE0_EL1			sys_reg(3, 0, 5, 6, 1)
 
-- 
2.34.1

