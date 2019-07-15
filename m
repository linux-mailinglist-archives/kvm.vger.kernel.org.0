Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2568304
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 06:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfGOEhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 00:37:39 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:18860 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfGOEhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 00:37:39 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id D529DF892833B90D37C6;
        Mon, 15 Jul 2019 12:37:36 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x6F4bFC2019355;
        Mon, 15 Jul 2019 12:37:15 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019071512371737-2348121 ;
          Mon, 15 Jul 2019 12:37:17 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH] kvm: vmx: fix coccinelle warnings
Date:   Mon, 15 Jul 2019 12:35:17 +0800
Message-Id: <1563165317-5996-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-15 12:37:17,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-15 12:37:17,
        Serialize complete at 2019-07-15 12:37:17
X-MAIL: mse-fl1.zte.com.cn x6F4bFC2019355
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes the following coccinelle warning:

WARNING: return of 0/1 in function 'vmx_need_emulation_on_page_fault'
with return type bool

Return false instead of 0.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98eac3..8b5f352 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7418,7 +7418,7 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
 
 static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 {
-	return 0;
+	return false;
 }
 
 static __init int hardware_setup(void)
-- 
1.8.3.1

