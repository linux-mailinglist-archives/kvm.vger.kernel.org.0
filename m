Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CAB79EF71
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjIMQ5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 12:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjIMQ47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 12:56:59 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Sep 2023 09:56:55 PDT
Received: from out-225.mta0.migadu.com (out-225.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8995919BB
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 09:56:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694624213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DhLfcFyA2+nmwrxML7Y1VzCvedGNaW1azCKlPa2eHPA=;
        b=Wrm8lyUbqvCT689fWDZ8Rgueah/pRGc2GQQUBs3ta7lginZ+YRMKIgBRUOcQccuwdrq2WB
        jKw+qsPL93uRDHUL4KF/dI3YamFyYrfc0Fi+scdGWfalqvAHws/uT2Wsw9BlDlaw+FeAbz
        MC8qsTk64BQ1mTqtz/PG8BF7dkGvE5w=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
Date:   Wed, 13 Sep 2023 16:56:44 +0000
Message-ID: <20230913165645.2319017-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A double-asterisk opening mark to the comment (i.e. '/**') indicates a
comment block is in the kerneldoc format. There's automation in place to
validate that kerneldoc blocks actually adhere to the formatting rules.

The function comment for arm64_check_features() isn't kerneldoc; use a
'regular' comment to silence automation warnings.

Link: https://lore.kernel.org/all/202309112251.e25LqfcK-lkp@intel.com/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..818a52e257ed 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1228,7 +1228,7 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 	return arm64_ftr_safe_value(&kvm_ftr, new, cur);
 }
 
-/**
+/*
  * arm64_check_features() - Check if a feature register value constitutes
  * a subset of features indicated by the idreg's KVM sanitised limit.
  *

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.42.0.459.ge4e396fd5e-goog

