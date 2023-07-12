Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8789E75018B
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbjGLIbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjGLIbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:31:09 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293352702
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 01:26:17 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R19n228kvzBS5qp
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:26:14 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689150374; x=1691742375; bh=oltV5Rd5AD0T6xUiH4VHdUcjoRX
        Ryw0tUkvVw8Y4vQY=; b=l0IWnV4ACmHpyX7cI2eWSd4hZuu4q+WvuoJl5Vf0ExK
        fImaInY2EcoSrQ8NhfTm+6xQHPYEEFNNuw6ztno++J0WaPkCphQrAsRUt2a6xKkM
        X75ttgsMd5e83BjOcpTsGpeM36bBB1Lu1yXti+h1sBGq1WNFz/sy2B35e0D4FHqO
        OPa6Iu3DN20plWLY76/lAnJ/mkThpoMv3yclxlDu+SZDENSOBD9CWqeYBVNqshVY
        0gMjCb64NB9W1G79xz+SP2I+UVG6RkWrVZMEp8cSdOMdB7kM/T9o9ZS6FDiBB5gZ
        ZpEPbiS+zarATEeE14eblkJnrFB9mUAYwmFn+EszG6A==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LR4RsT7fcuh2 for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 16:26:14 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R19n16GhtzBR5lP;
        Wed, 12 Jul 2023 16:26:13 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 16:26:13 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Fix warnings in pmu.h
In-Reply-To: <tencent_C12CFA09493ED8DFE9D60EEBEE92C7E82605@qq.com>
References: <tencent_C12CFA09493ED8DFE9D60EEBEE92C7E82605@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <9ffeb53096b6caf0323e4d7bd452ef76@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warning is removed:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/pmu.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..dbc131b378f2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -249,7 +249,7 @@ static inline bool pmc_is_globally_enabled(struct 
kvm_pmc *pmc)

  void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
-int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
+int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned int pmc, u64 *data);
  bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int 
idx);
  bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
  int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
