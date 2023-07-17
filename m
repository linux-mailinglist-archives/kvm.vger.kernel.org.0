Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30D5755A11
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 05:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjGQD1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 23:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjGQD1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 23:27:07 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B5312E
        for <kvm@vger.kernel.org>; Sun, 16 Jul 2023 20:27:05 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R46vV26k2zBHXhQ
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 11:27:02 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689564422; x=1692156423; bh=bKsnKHfPXtzGohNC8T6IptNohj2
        07rb3bU8n49fAOEM=; b=mV8EyHFpz7UdKkfmhb1HGFpzIr5i6YVRylXxgPOcmmF
        5HNj6qxZUeKc+aEhr/d4WPQe3lRZIjawG9PBI99/M7gyYchjklPexHkEUZseWODg
        LNjBBgng+HyRzTPsvXFySNx6C6WnpdIpJDrLHchxmzD9ptKGnN+KZsXmQZbcR75K
        msk5/2PfYiB+xVv28L+PSjtaZveh0fvHiG0YVEeiz4j+fuSAluXqYYYWm2TyJr2L
        SvFqxAcMsqTveUlv9ZeaibgQ2mw8YRD/BK4MG+nUhAkK/bkmdxaS/279b8zevLAA
        A1/LTJgkvw8YkEbx8UfzJJTarw1FFFVNh6fu4MP0C4w==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EvKoMHN_TvgS for <kvm@vger.kernel.org>;
        Mon, 17 Jul 2023 11:27:02 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R46vV09vkzBHXR9;
        Mon, 17 Jul 2023 11:27:01 +0800 (CST)
MIME-Version: 1.0
Date:   Mon, 17 Jul 2023 11:27:01 +0800
From:   shijie001@208suo.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Fix warnings in irqchip.c
In-Reply-To: <tencent_E7FFD5AD20D6F7A59A915FD8CB1385FC8806@qq.com>
References: <tencent_E7FFD5AD20D6F7A59A915FD8CB1385FC8806@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <2ec15b819263c1b9e0ee08da6b605006@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warnings are removed:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
WARNING: Missing a blank line after declarations
WARNING: Block comments use * on subsequent lines
WARNING: Block comments use a trailing */ on a separate line
WARNING: Prefer __weak over __attribute__((weak))

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  virt/kvm/irqchip.c | 15 +++++++++------
  1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..33721848315f 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -37,7 +37,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
      return n;
  }

-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned 
pin)
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip, 
unsigned int pin)
  {
      struct kvm_irq_routing_table *irq_rt;

@@ -85,6 +85,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, 
u32 irq, int level,

      while (i--) {
          int r;
+
          r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level,
                     line_status);
          if (r < 0)
@@ -118,9 +119,11 @@ static void free_irq_routing_table(struct 
kvm_irq_routing_table *rt)

  void kvm_free_irq_routing(struct kvm *kvm)
  {
-    /* Called only during vm destruction. Nobody can use the pointer
-       at this stage */
+    /* Called only during vm destruction.
+     * Nobody can use the pointer at this stage.
+     */
      struct kvm_irq_routing_table *rt = 
rcu_access_pointer(kvm->irq_routing);
+
      free_irq_routing_table(rt);
  }

@@ -156,7 +159,7 @@ static int setup_routing_entry(struct kvm *kvm,
      return 0;
  }

-void __attribute__((weak)) kvm_arch_irq_routing_update(struct kvm *kvm)
+void __weak kvm_arch_irq_routing_update(struct kvm *kvm)
  {
  }

@@ -167,8 +170,8 @@ bool __weak kvm_arch_can_set_irq_routing(struct kvm 
*kvm)

  int kvm_set_irq_routing(struct kvm *kvm,
              const struct kvm_irq_routing_entry *ue,
-            unsigned nr,
-            unsigned flags)
+            unsigned int nr,
+            unsigned int flags)
  {
      struct kvm_irq_routing_table *new, *old;
      struct kvm_kernel_irq_routing_entry *e;
