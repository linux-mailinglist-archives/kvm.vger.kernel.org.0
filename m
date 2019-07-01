Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978BE5B52E
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 08:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfGAGjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 02:39:46 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:53544 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfGAGjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 02:39:46 -0400
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2019 02:39:45 EDT
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 9393B81F830A4B267BC5;
        Mon,  1 Jul 2019 14:24:07 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x616MhkX033824;
        Mon, 1 Jul 2019 14:22:43 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070114224481-1995713 ;
          Mon, 1 Jul 2019 14:22:44 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH 1/4] kvm: x86: Add CONFIG_KVM_DEBUG
Date:   Mon, 1 Jul 2019 14:21:08 +0800
Message-Id: <1561962071-25974-2-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
References: <1561962071-25974-1-git-send-email-wang.yi59@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-01 14:22:44,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-01 14:22:44,
        Serialize complete at 2019-07-01 14:22:44
X-MAIL: mse-fl1.zte.com.cn x616MhkX033824
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some *_debug functions in KVM, it may be
better to introduce CONFIG_DEBUG_KVM to replace the
*_debug macro, which can avoid bloating and slowing KVM,
as Sean suggested.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fc04241..7e76eb2 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -95,6 +95,14 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_DEBUG
+	bool "Enable KVM debugging"
+	default n
+	depends on KVM
+	---help---
+	Say Y here if you want to enable verbose KVM debug output.
+
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source "drivers/vhost/Kconfig"
-- 
1.8.3.1

