Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7267D74FF23
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 08:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjGLGV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 02:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjGLGV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 02:21:57 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D129134
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 23:21:56 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R171Z4fXTzBR5lK
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 14:21:54 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689142914; x=1691734915; bh=3c4mTA8SwzHCTMbo7r/F3u9cBFi
        esSF7PLPijxDkWuE=; b=sVdW7CYwctBYa4eDIBU/VdH3tC9coxyFn/oSFlCoSfO
        6jarYYLQFv7O5Hyfm/RpbvDjOi6vz5L3pfAtYy5wk6AjOdJQ8DYXODX63TWpqlhY
        wWkFxuB4Na5fLlTWKwWwWVe99C/bNXjqRRAt9OioS5uPRdFTTAOOJa1elrKv8Akb
        hrQBlGQ00NUmR2l5PkImYGhcIUDcBobPKwi5ifws8/uguK2sHAdjQV3nkwOjQvTN
        Ag/cTaQKubAEi9s7Akb/DJGVYatF/kHvj0ITVfwhG0aC4ugQb09JXnu/HYweDXgc
        GZzpyrz95Q4BogcJLHkegdd2NswZX5oMFGfEMyG5LtA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MXaLn4bEInYd for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 14:21:54 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R171Z1HS4zBR5lL;
        Wed, 12 Jul 2023 14:21:54 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 14:21:54 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix errors & warnings in irq_comm.c
In-Reply-To: <tencent_63276CF92B7FBBDB6AACD9CB27A3C9B0ED07@qq.com>
References: <tencent_63276CF92B7FBBDB6AACD9CB27A3C9B0ED07@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <1b85fe6bf831ffd0b994a9703e8b06f7@208suo.com>
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

The following checkpatch errors & warnings are removed:
WARNING: Missing a blank line after declarations
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/irq_comm.c | 6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 16d076a1b91a..38a759606bef 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -32,6 +32,7 @@ static int kvm_set_pic_irq(struct 
kvm_kernel_irq_routing_entry *e,
                 bool line_status)
  {
      struct kvm_pic *pic = kvm->arch.vpic;
+
      return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
  }

@@ -40,6 +41,7 @@ static int kvm_set_ioapic_irq(struct 
kvm_kernel_irq_routing_entry *e,
                    bool line_status)
  {
      struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+
      return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, irq_source_id, 
level,
                  line_status);
  }
@@ -253,7 +255,7 @@ void kvm_unregister_irq_mask_notifier(struct kvm 
*kvm, int irq,
      synchronize_srcu(&kvm->irq_srcu);
  }

-void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, 
unsigned pin,
+void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned int irqchip, 
unsigned int pin,
                   bool mask)
  {
      struct kvm_irq_mask_notifier *kimn;
@@ -365,7 +367,7 @@ EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);

  #define PIC_ROUTING_ENTRY(irq) \
      { .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,    \
-      .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }
+      .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = ((irq) % 8) } }
  #define ROUTING_ENTRY2(irq) \
      IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
