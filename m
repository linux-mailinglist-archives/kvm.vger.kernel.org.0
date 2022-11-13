Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63930626DEC
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 07:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiKMGqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 01:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiKMGqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 01:46:50 -0500
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816C910FED;
        Sat, 12 Nov 2022 22:46:46 -0800 (PST)
X-QQ-mid: bizesmtp84t1668322001tmlelxc1
Received: from localhost.localdomain ( [182.148.14.167])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 13 Nov 2022 14:46:40 +0800 (CST)
X-QQ-SSF: 01000000000000C0F000B00A0000000
X-QQ-FEAT: ZdHcY4j9T+J5MIkIHbnfd5SmJxFuAH9aav3AFpo/nf5rXtfvwt/pqhrkHmcqL
        FToy5CIWZJ2VM9dzhPqOMoS5n6ayQnOJDNF2Z0lT967JDNK1e4TNQbulusW9GZ74Xnr/dl/
        Cx7LISSJAxPzpuJi0gt+eMufFmxtLjvzJEjNwlMlIDP0ZKZ5exJKPjfQ4lunKV8QUvSvzHY
        cTVCs2RYvpLl9VxsbQrHghzqs+m8ypFbW5uRYQ83JZhmGDcKCiingWJ5neEu3Ytw0EmtjVC
        Q94/dvaDRNcfKrXkNISnTw8WU7+xnMwDV+D54rB7b0DCec+60VDi5tCRnx2IYO3F8vRocok
        VfKh2VVMor47yOSWEU=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] virt/kvm: Replace "unsigned" with "unsigned int"
Date:   Sun, 13 Nov 2022 14:46:33 +0800
Message-Id: <20221113064633.32294-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace "unsigned" with "unsigned int"

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 virt/kvm/irqchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 58e4f88b2b9f..eefea6a650fb 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -38,7 +38,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
 	return n;
 }
 
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip, unsigned int pin)
 {
 	struct kvm_irq_routing_table *irq_rt;
 
-- 
2.36.1

