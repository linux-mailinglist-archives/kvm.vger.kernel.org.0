Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556B163D63E
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 14:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiK3ND4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 08:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiK3NDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 08:03:40 -0500
X-Greylist: delayed 187 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Nov 2022 05:02:32 PST
Received: from cmccmta3.chinamobile.com (cmccmta3.chinamobile.com [221.176.66.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4C9563C6
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 05:02:32 -0800 (PST)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9])
        by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb638753aa292-73599;
        Wed, 30 Nov 2022 20:59:23 +0800 (CST)
X-RM-TRANSID: 2eeb638753aa292-73599
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.98])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee5638753a2e34-1cfa8;
        Wed, 30 Nov 2022 20:59:22 +0800 (CST)
X-RM-TRANSID: 2ee5638753a2e34-1cfa8
From:   liujing <liujing@cmss.chinamobile.com>
To:     pbonzini@redhat.com
Cc:     mingo@redhat.com, dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] KVM: x86: Redundant variable assignments can be merged
Date:   Wed, 30 Nov 2022 07:59:13 -0500
Message-Id: <20221130125913.4605-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When reading kvm code, find the 'r' variable declaration
and then assign the value in kvm_vm_ioctl_get_irqchip and
kvm_vm_ioctl_set_irqchip function, It can be combined into one sentence.

Signed-off-by: liujing <liujing@cmss.chinamobile.com>
---
 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2835bd796639..4be353d5c09d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6002,9 +6002,8 @@ static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
-	int r;
+	int r = 0;
 
-	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
 		memcpy(&chip->chip.pic, &pic->pics[0],
@@ -6027,9 +6026,8 @@ static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
-	int r;
+	int r = 0;
 
-	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
 		spin_lock(&pic->lock);
-- 
2.18.2



