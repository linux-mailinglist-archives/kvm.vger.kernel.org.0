Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5B822ADB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 06:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfETE0A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 20 May 2019 00:26:00 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:55494 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfETEZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 00:25:59 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 128A0A7E7B54D04269F2;
        Mon, 20 May 2019 12:25:55 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x4K4PpWE081937;
        Mon, 20 May 2019 12:25:51 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019052012255471-9980 ;
          Mon, 20 May 2019 12:25:54 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wang.yi59@zte.com.cn
Subject: [PATCH] kvm: vmx: Fix -Wmissing-prototypes warnings
Date:   Mon, 20 May 2019 12:27:47 +0800
Message-Id: <1558326467-48530-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-05-20 12:25:54,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-05-20 12:25:50
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-MAIL: mse-fl1.zte.com.cn x4K4PpWE081937
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We get a warning when build kernel W=1:
arch/x86/kvm/vmx/vmx.c:6365:6: warning: no previous prototype for ‘vmx_update_host_rsp’ [-Wmissing-prototypes]
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)

Add the missing declaration to fix this.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/kvm/vmx/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f879529..9cd72de 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -314,6 +314,7 @@ struct kvm_vmx {
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
+void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
1.8.3.1

