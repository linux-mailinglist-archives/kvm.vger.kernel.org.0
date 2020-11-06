Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A882A91A0
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 09:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgKFIjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 03:39:37 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56903 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgKFIjh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 03:39:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UEPYmPR_1604651973;
Received: from aliy80.localdomain(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEPYmPR_1604651973)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 16:39:33 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
To:     hpa@zytor.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvm: remove unused macro HV_CLOCK_SIZE
Date:   Fri,  6 Nov 2020 16:39:23 +0800
Message-Id: <1604651963-10067-1-git-send-email-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This macro is useless, and could cause gcc warning:
arch/x86/kernel/kvmclock.c:47:0: warning: macro "HV_CLOCK_SIZE" is not
used [-Wunused-macros]
Let's remove it.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Sean Christopherson <sean.j.christopherson@intel.com> 
Cc: Vitaly Kuznetsov <vkuznets@redhat.com> 
Cc: Wanpeng Li <wanpengli@tencent.com> 
Cc: Jim Mattson <jmattson@google.com> 
Cc: Joerg Roedel <joro@8bytes.org> 
Cc: Thomas Gleixner <tglx@linutronix.de> 
Cc: Ingo Molnar <mingo@redhat.com> 
Cc: Borislav Petkov <bp@alien8.de> 
Cc: x86@kernel.org 
Cc: "H. Peter Anvin" <hpa@zytor.com> 
Cc: kvm@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
---
 arch/x86/kernel/kvmclock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 34b18f6eeb2c..aa593743acf6 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -44,7 +44,6 @@ static int __init parse_no_kvmclock_vsyscall(char *arg)
 early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
 
 /* Aligned to page sizes to match whats mapped via vsyscalls to userspace */
-#define HV_CLOCK_SIZE	(sizeof(struct pvclock_vsyscall_time_info) * NR_CPUS)
 #define HVC_BOOT_ARRAY_SIZE \
 	(PAGE_SIZE / sizeof(struct pvclock_vsyscall_time_info))
 
-- 
1.8.3.1

