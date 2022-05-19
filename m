Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE3552D44B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiESNnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbiESNm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31913EF03
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FCDD617A0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7076EC34117;
        Thu, 19 May 2022 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967768;
        bh=3z3t2BrkvfovB2h5pwI3p5yIYTZRtSIyBD74PPTs0Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G96M87Oxdl/MhNzXxjemh8P8hD9d+d9tOTeB1WXdxsMsH/EX7wiqHwKlO5j4HVvMB
         wppa1c+r5WyEKdbCnTaUShA+X7bXIr9pA2c6YB91FBoyEpHaDekbZd8KYShe9IjrIg
         BEZZBNvs+EiDogN8GOQi0dblPZK60+tPLi7j3z7IaA3DbWMh7En4SWPK8B5anJsFV5
         krURr+mlbzyq44nBBAoo4S+S2XsRIt/yn0eJGgr5gSgsNm9uP6SuTVVPf14nOrnRdL
         XgRvIlCY06gv78RiJd88/i8CdBGh5f/ctqmlqy0lkb8PIHLvHrCs5AihtV08LBnJvV
         YUJHDdmCFdWbQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/89] KVM: arm64: Drop stale comment
Date:   Thu, 19 May 2022 14:40:41 +0100
Message-Id: <20220519134204.5379-7-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

The layout of 'struct kvm_vcpu_arch' has evolved significantly since
the initial port of KVM/arm64, so remove the stale comment suggesting
that a prefix of the structure is used exclusively from assembly code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e3b25dc6c367..14ed7c7ad797 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -339,11 +339,6 @@ struct kvm_vcpu_arch {
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
 
-	/*
-	 * Anything that is not used directly from assembly code goes
-	 * here.
-	 */
-
 	/*
 	 * Guest registers we preserve during guest debugging.
 	 *
-- 
2.36.1.124.g0e6072fb45-goog

