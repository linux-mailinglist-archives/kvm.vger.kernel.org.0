Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A160E74FEAB
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 07:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjGLFYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 01:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjGLFYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 01:24:38 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AFBF0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 22:24:33 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R15lC1mW7zBR5l9
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:24:23 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689139461; x=1691731462; bh=WK8J9dWxI+4aAEoTHQJfscjTnby
        xuTPgDNC5E/Kjg+E=; b=yn3w+DDp7mZQsf0OnehCBNyx6jw8HAt9jMiAv2MIHbE
        xRW5PYvKJCIRb5csC284dGfUmjAuYj3IbzrIJ7117GG9zWD9fA0fxk2p+W3CJ0o4
        NOJVMAjICb3VkSaZG9VjJf2lDXM7AYctyP0KLv1RIqA6yVITGuj3ktz5/v8OuH1L
        enJAZVsCq5ZwZGnfB765c9Sb6uR7tW1jCnCT3PqDGe2D8jz4DDwxmuGHCQRYyFwL
        Oc4nnN+iLZiUJ0cMPjy6R2vQdSuhdqxs3Xq5QkgpoLYAqDie5e6Il6y/1J5serB5
        BwOoH0seK3ibi9qJUfDU+nMOJymy1v1xVX5sTg1HJoA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XMZ65jrztlQf for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 13:24:21 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R15l91b4kzBR5l6;
        Wed, 12 Jul 2023 13:24:21 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 13:24:21 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix warnings in mtrr.c
In-Reply-To: <tencent_62384F83F25EFE76B71058AF970646526108@qq.com>
References: <tencent_62384F83F25EFE76B71058AF970646526108@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <e8ed03d11ad8e485a316649b487c1bf4@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warnings are removed:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Block comments should align the * on each line

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/mtrr.c | 14 +++++++-------
  1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 3eb6e7f47e96..cda5f79f3f2e 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -39,7 +39,7 @@ static struct kvm_mtrr_range 
*var_mtrr_msr_to_range(struct kvm_vcpu *vcpu,
      return &vcpu->arch.mtrr_state.var_ranges[index];
  }

-static bool msr_mtrr_valid(unsigned msr)
+static bool msr_mtrr_valid(unsigned int msr)
  {
      switch (msr) {
      case MTRRphysBase_MSR(0) ... MTRRphysMask_MSR(KVM_NR_VAR_MTRR - 1):
@@ -60,7 +60,7 @@ static bool msr_mtrr_valid(unsigned msr)
      return false;
  }

-static bool valid_mtrr_type(unsigned t)
+static bool valid_mtrr_type(unsigned int t)
  {
      return t < 8 && (1 << t) & 0x73; /* 0, 1, 4, 5, 6 */
  }
@@ -135,11 +135,11 @@ static u8 mtrr_disabled_type(struct kvm_vcpu 
*vcpu)
  }

  /*
-* Three terms are used in the following code:
-* - segment, it indicates the address segments covered by fixed MTRRs.
-* - unit, it corresponds to the MSR entry in the segment.
-* - range, a range is covered in one memory cache type.
-*/
+ * Three terms are used in the following code:
+ * - segment, it indicates the address segments covered by fixed MTRRs.
+ * - unit, it corresponds to the MSR entry in the segment.
+ * - range, a range is covered in one memory cache type.
+ */
  struct fixed_mtrr_segment {
      u64 start;
      u64 end;
