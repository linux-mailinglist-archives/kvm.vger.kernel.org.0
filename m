Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDC05B502
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 08:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfGAGYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 02:24:09 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:64346 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfGAGYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 02:24:09 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 65AF0CBDF847BFE650E2;
        Mon,  1 Jul 2019 14:24:07 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x616MhkY033824;
        Mon, 1 Jul 2019 14:22:43 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070114224626-1995716 ;
          Mon, 1 Jul 2019 14:22:46 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH 3/4] kvm: x86: replace MMU_DEBUG with CONFIG_KVM_DEBUG
Date:   Mon, 1 Jul 2019 14:21:10 +0800
Message-Id: <1561962071-25974-4-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-01 14:22:46,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-01 14:22:44,
        Serialize complete at 2019-07-01 14:22:44
X-MAIL: mse-fl1.zte.com.cn x616MhkY033824
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As CONFIG_KVM_DEBUG has been introduced in the former
patch, it's better to replace MMU_DEBUG with CONFIG_KVM_DEBUG.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e9ba81..d54214e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -68,9 +68,8 @@ enum {
 	AUDIT_POST_SYNC
 };
 
-#undef MMU_DEBUG
 
-#ifdef MMU_DEBUG
+#ifdef CONFIG_KVM_DEBUG
 static bool dbg = 0;
 module_param(dbg, bool, 0644);
 
@@ -1994,7 +1993,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
 }
 
-#ifdef MMU_DEBUG
+#ifdef CONFIG_KVM_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
 	u64 *pos;
-- 
1.8.3.1

