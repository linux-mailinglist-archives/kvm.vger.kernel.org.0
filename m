Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747D274FEC6
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 07:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjGLFlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 01:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjGLFlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 01:41:06 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DAD1712
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 22:41:05 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R166P33SFzBR5lL
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 13:41:01 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689140461; x=1691732462; bh=XszHPDJxLEHyVbzTGHsyGKBpXpb
        FM90vWehMLONLATI=; b=yaxtP7EREcWmhPcvqSy+gqL/ABWM7/ZrEhNgLprBxf6
        4LjjQ0pa0uSTIJDZXsN2q7Qq0QFjkwb7+aIAEsg2f1Fri22nyU3eq00ovpcYLRtG
        YN6XimQuL3zNKfH0pyWquSnZ4d22tohPYb7/jQsydsEAioHYjlSiDOF2wYe328bL
        M5/OBqkEh9Ti/G/1KGf7RiPGijJPlvtEm7Nji47PCRuAUhZtpI1eRoj8qZVFZWhd
        ilt0IuQrxMgrM1CHGRqJ/pgMUO0KAala0nuAvwHGbim5oeM+gZDPPW8XIJskNkOv
        3mnL+Tn9ZUGeRtD5oum3r3Yhg2W6+N5LtjKVd3eQMrA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9ptCkRE0DYlX for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 13:41:01 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R166P02KgzBR5l9;
        Wed, 12 Jul 2023 13:41:00 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 13:41:00 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: x86: Fix warning in irq.h
In-Reply-To: <tencent_D4F207FEB4B79458E5971F46ED61A94F5708@qq.com>
References: <tencent_D4F207FEB4B79458E5971F46ED61A94F5708@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <499102fc61234c78997cc80e24b0573b@208suo.com>
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

The following checkpatch warning is removed:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/irq.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index c2d7cfe82d00..2c87183fe4e0 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -49,7 +49,7 @@ struct kvm_kpic_state {
  struct kvm_pic {
      spinlock_t lock;
      bool wakeup_needed;
-    unsigned pending_acks;
+    unsigned int pending_acks;
      struct kvm *kvm;
      struct kvm_kpic_state pics[2]; /* 0 is master pic, 1 is slave pic 
*/
      int output;        /* intr from master PIC */
