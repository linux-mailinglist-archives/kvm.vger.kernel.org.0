Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D143D30A374
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhBAIjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:39:20 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:46615 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232577AbhBAIjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 03:39:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UNWymoB_1612168686;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNWymoB_1612168686)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Feb 2021 16:38:23 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] KVM: Replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
Date:   Mon,  1 Feb 2021 16:38:05 +0800
Message-Id: <1612168685-33799-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warning:

./arch/x86/kvm/debugfs.c:44:0-23: WARNING: vcpu_tsc_scaling_frac_fops
should be defined with DEFINE_DEBUGFS_ATTRIBUTE.

./arch/x86/kvm/debugfs.c:36:0-23: WARNING: vcpu_tsc_scaling_fops should
be defined with DEFINE_DEBUGFS_ATTRIBUTE.

./arch/x86/kvm/debugfs.c:27:0-23: WARNING: vcpu_tsc_offset_fops should
be defined with DEFINE_DEBUGFS_ATTRIBUTE.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 arch/x86/kvm/debugfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 7e818d6..9c0e29e 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -15,7 +15,7 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
 
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
@@ -24,7 +24,7 @@ static int vcpu_get_tsc_offset(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
 
 static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
 {
@@ -33,7 +33,7 @@ static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
 
 static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 {
@@ -41,7 +41,8 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits,
+			  NULL, "%llu\n");
 
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
-- 
1.8.3.1

