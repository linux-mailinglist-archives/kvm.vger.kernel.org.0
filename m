Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF285F764
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfGDLsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 07:48:11 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:55180 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727635AbfGDLsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 07:48:11 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 7B9B0E408963C162CBD9;
        Thu,  4 Jul 2019 19:48:08 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x64BlpUZ061122;
        Thu, 4 Jul 2019 19:47:51 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070419482107-2086632 ;
          Thu, 4 Jul 2019 19:48:21 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn, up2wing@gmail.com,
        wang.liang82@zte.com.cn
Subject: [PATCH 1/2] kvm: x86: add likely to sched_info_on()
Date:   Thu, 4 Jul 2019 19:46:14 +0800
Message-Id: <1562240775-16086-2-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
References: <1562240775-16086-1-git-send-email-wang.yi59@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-04 19:48:21,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-04 19:47:56,
        Serialize complete at 2019-07-04 19:47:56
X-MAIL: mse-fl1.zte.com.cn x64BlpUZ061122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The condition to test is likely() to be true when make defconfig.
Add the hint.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4992e7c..64fff41 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -642,7 +642,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI);
 
-		if (sched_info_on())
+		if (likely(sched_info_on()))
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
 
 		entry->ebx = 0;
-- 
1.8.3.1

