Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF96F3BBA
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 23:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfKGWtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 17:49:53 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38984 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfKGWtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 17:49:53 -0500
Received: by mail-pg1-f202.google.com with SMTP id 21so3069663pgt.6
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 14:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4mSbfnV86WhUg0ov7lHDDNrLNgfz2FACKhYcwdyo8BE=;
        b=GNiUHhZJlII5AiiX4TfdImST/8tffSXgfb79aU8yGDDSudy86tUQrZ7uw/yWlYfpxq
         oEbG3q6M8BWCwAoHIgjppxsta5hGEypRrm+EqKPnjtVAMGmsFWny9MwHbwEyv+aD+sEU
         mIz5CTiu2u0BmwA+jddnJ70SYsSYYfXcJVehkE4T3eeyHzYT5VvhYlScDAqrRui8Abkb
         06PNyGQ17QunRR4koAubXy8qeVHPlSXDOcj1i8+B+mVO/FFdBYD/H7MasW5a2igewLpH
         JYuCm3hb8tjxYonth5zDRoLvILshKx2VdbI+ddFBPaUfNr+cJN5EwghWg6vFMkG5Pxr/
         EyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4mSbfnV86WhUg0ov7lHDDNrLNgfz2FACKhYcwdyo8BE=;
        b=QXPuCijU+ZWqyjC3y8yfwajgWzjV3EI4akW7ewDFXcT6Vq2C/WHx9uW7jm/uOU/S1+
         7wC/KEaT3W6YvHG+AJsZCs1Bkfiad8IjzeRsd4g/5mbRCq8ZW4gd7v00dcI8C2+1B64R
         klj9NKTUP2FtMnDH6Tv0dgnNTJ9PFEIckpekP0p72ApovmLqhiAHL0IpyCGziiUdkOHF
         HSrmxcasCshY/fcrFAntxnLwk28ItGCF31GKmCLkV+O5YzonUtYO65hK5P1AfwuLWHCI
         4jpL/oSYqvRPoCZChNAr/VKvP2zPJJMhHFhvZyye2LMemXnAW65hlGpnswpQ8YKNMtui
         g7Dw==
X-Gm-Message-State: APjAAAUx8ygJSU+tuMOLBLIr3gObRawhxlNXv9bPaAbgpbpXMyztsGEB
        HPqLT3xfLP5jY2jsnYWpJuVfzPK9+wqVWzXG3oqsImuMTQHRBS2G+4WsIVQbgbLQRvXJzwag6Uj
        MYrmSp+V16VkdkMUdgDIq8SONuGU+diqBra3NwvR3cBB54zXNPvlPvtnwh4Ia3rfZgnV7
X-Google-Smtp-Source: APXvYqwiKk5bvB1+nhSN+mtQty8Lm04D2mrS8fnYfBDp0tRHKz3ukybAur1qyOQ+tW3vMzNDwV2BLm3BAR7ZQ3Br
X-Received: by 2002:a63:4a05:: with SMTP id x5mr7726694pga.6.1573166992143;
 Thu, 07 Nov 2019 14:49:52 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:49:38 -0800
In-Reply-To: <20191107224941.60336-1-aaronlewis@google.com>
Message-Id: <20191107224941.60336-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191107224941.60336-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v3 2/5] kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_LOADSTORE_MSRS
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename NR_AUTOLOAD_MSRS to NR_LOADSTORE_MSRS.  This needs to be done
due to the addition of the MSR-autostore area that will be added in a
future patch.  After that the name AUTOLOAD will no longer make sense.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/vmx/vmx.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7970a2e8eae..d9afafc0e399 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -940,8 +940,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	if (!entry_only)
 		j = find_msr(&m->host, msr);
 
-	if ((i < 0 && m->guest.nr == NR_AUTOLOAD_MSRS) ||
-		(j < 0 &&  m->host.nr == NR_AUTOLOAD_MSRS)) {
+	if ((i < 0 && m->guest.nr == NR_LOADSTORE_MSRS) ||
+		(j < 0 &&  m->host.nr == NR_LOADSTORE_MSRS)) {
 		printk_once(KERN_WARNING "Not enough msr switch entries. "
 				"Can't add msr %x\n", msr);
 		return;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bee16687dc0b..1dad8e5c8f86 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -22,11 +22,11 @@ extern u32 get_umwait_control_msr(void);
 
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
-#define NR_AUTOLOAD_MSRS 8
+#define NR_LOADSTORE_MSRS 8
 
 struct vmx_msrs {
 	unsigned int		nr;
-	struct vmx_msr_entry	val[NR_AUTOLOAD_MSRS];
+	struct vmx_msr_entry	val[NR_LOADSTORE_MSRS];
 };
 
 struct shared_msr_entry {
-- 
2.24.0.432.g9d3f5f5b63-goog

