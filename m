Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E54E38FD19
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 10:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhEYIrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 04:47:25 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:55572 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231851AbhEYIrZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 04:47:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=chaowu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ua3XLTC_1621932333;
Received: from localhost.localdomain(mailfrom:chaowu@linux.alibaba.com fp:SMTPD_---0Ua3XLTC_1621932333)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 16:45:42 +0800
From:   Chao Wu <chaowu@linux.alibaba.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Chao Wu <chaowu@linux.alibaba.com>,
        Jiang Liu <gerry@linux.alibaba.com>
Subject: [PATCH 2/2] pvclock: remove EXPORT_SYMBOL_GPL for pvclock_get_pvti_cpu0_va
Date:   Tue, 25 May 2021 16:44:58 +0800
Message-Id: <5a337f71a316b4b2dc4661a358110dec9b6cff2e.1621505277.git.chaowu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <cover.1621505277.git.chaowu@linux.alibaba.com>
References: <cover.1621505277.git.chaowu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to avoid abusing the "pvclock_get_pvti_cpu0_va” interface, we
should remove EXPORT_SYMBOL_GPL for that function.

Signed-off-by: Chao Wu <chaowu@linux.alibaba.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
---
 arch/x86/kernel/pvclock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 637982efecd8..e26940c33d99 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -164,4 +164,3 @@ struct pvclock_vsyscall_time_info *pvclock_get_pvti_cpu0_va(void)
 {
 	return pvti_cpu0_va;
 }
-EXPORT_SYMBOL_GPL(pvclock_get_pvti_cpu0_va);
-- 
2.24.3 (Apple Git-128)

