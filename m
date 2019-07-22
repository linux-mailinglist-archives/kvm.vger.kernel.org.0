Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0326FA6F
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 09:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGVHhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 03:37:04 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:50030 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfGVHhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 03:37:04 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 8DEAFB8D5B9EA263227B;
        Mon, 22 Jul 2019 15:36:58 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x6M7alam028721;
        Mon, 22 Jul 2019 15:36:47 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019072215365173-2482797 ;
          Mon, 22 Jul 2019 15:36:51 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH] kvm: x86: Use DEFINE_DEBUGFS_ATTRIBUTE for debugfs files
Date:   Mon, 22 Jul 2019 15:33:59 +0800
Message-Id: <1563780839-14739-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-22 15:36:51,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-22 15:36:48,
        Serialize complete at 2019-07-22 15:36:48
X-MAIL: mse-fl2.zte.com.cn x6M7alam028721
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We got these coccinelle warning:
./arch/x86/kvm/debugfs.c:23:0-23: WARNING: vcpu_timer_advance_ns_fops
should be defined with DEFINE_DEBUGFS_ATTRIBUTE
./arch/x86/kvm/debugfs.c:32:0-23: WARNING: vcpu_tsc_offset_fops should
be defined with DEFINE_DEBUGFS_ATTRIBUTE
./arch/x86/kvm/debugfs.c:41:0-23: WARNING: vcpu_tsc_scaling_fops should
be defined with DEFINE_DEBUGFS_ATTRIBUTE
./arch/x86/kvm/debugfs.c:49:0-23: WARNING: vcpu_tsc_scaling_frac_fops
should be defined with DEFINE_DEBUGFS_ATTRIBUTE

Use DEFINE_DEBUGFS_ATTRIBUTE() rather than DEFINE_SIMPLE_ATTRIBUTE()
to fix this.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/debugfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 329361b..24016fb 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -20,7 +20,7 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
 
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
@@ -29,7 +29,7 @@ static int vcpu_get_tsc_offset(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
 
 static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
 {
@@ -38,7 +38,7 @@ static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
 
 static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 {
@@ -46,20 +46,20 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
 int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	struct dentry *ret;
 
-	ret = debugfs_create_file("tsc-offset", 0444,
+	ret = debugfs_create_file_unsafe("tsc-offset", 0444,
 							vcpu->debugfs_dentry,
 							vcpu, &vcpu_tsc_offset_fops);
 	if (!ret)
 		return -ENOMEM;
 
 	if (lapic_in_kernel(vcpu)) {
-		ret = debugfs_create_file("lapic_timer_advance_ns", 0444,
+		ret = debugfs_create_file_unsafe("lapic_timer_advance_ns", 0444,
 								vcpu->debugfs_dentry,
 								vcpu, &vcpu_timer_advance_ns_fops);
 		if (!ret)
@@ -67,12 +67,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	}
 
 	if (kvm_has_tsc_control) {
-		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
+		ret = debugfs_create_file_unsafe("tsc-scaling-ratio", 0444,
 							vcpu->debugfs_dentry,
 							vcpu, &vcpu_tsc_scaling_fops);
 		if (!ret)
 			return -ENOMEM;
-		ret = debugfs_create_file("tsc-scaling-ratio-frac-bits", 0444,
+		ret = debugfs_create_file_unsafe("tsc-scaling-ratio-frac-bits", 0444,
 							vcpu->debugfs_dentry,
 							vcpu, &vcpu_tsc_scaling_frac_fops);
 		if (!ret)
-- 
1.8.3.1

