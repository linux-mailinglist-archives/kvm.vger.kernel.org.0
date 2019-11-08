Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA87F3F87
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 06:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKHFOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 00:14:52 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:34279 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKHFOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 00:14:51 -0500
Received: by mail-pg1-f202.google.com with SMTP id w9so3846089pgl.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 21:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4mSbfnV86WhUg0ov7lHDDNrLNgfz2FACKhYcwdyo8BE=;
        b=ZyTwqLk198xJ9tUzBV4NkJAH6A40D+S7auCTlZq63PemHSIlFsgVkNIV5eJ/BEBMTA
         Wn8KPVnfBOWOTkc72GTqjpF2OFXGo728ziiHTZGOITP3YVbVpc6LFfakD9uC5MmmO7Y9
         b5MT1mOFzdSREfQB1Uarn8H5eZxJ3LYaMWVYgk1HRrClguaaFcTD3QJ3vzmOALQlptw8
         3s3TFQ2GQ5U752uKx2PIPg77MAuArwoZkvoMbZSpYrqEpF5B0UP1M8iusaeX0TC85uXP
         oq6ckGs2RQZIj5KYLMasrgxA2fak9lX+2I/y+nSbGayo2Wqg7msHuLRpmh+HPT+COdhY
         1sgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4mSbfnV86WhUg0ov7lHDDNrLNgfz2FACKhYcwdyo8BE=;
        b=LJIkkYdQDFWUuzVek2u+FWLm4DUruf0XVJKYnuGlpd1fH5bpL7rWkc0+Poovfc+i2z
         Wb6aDhHjsYu4V+J6hcMyxY0Gh/voa/k7kFj0E/4e+RPnOqXBQPP5A8jvvQqClsemwKZX
         XSYpOHPnTX1QV0mEXEMOMPvlgJS7VEby6nClRxeWWFOSnJpdWWgUSqq6IhbNvv1jOtfj
         9xWiA8s9/4ZwrZ5uZAk+STFANmcfySOKU8UQ4lWeAqzZqvixRJciXRPh9nAn74E1LKzX
         KBWEXWJFM5/lndsehxumUSDOoMb9+Etwxt8gRIA/30DYD5aUFM7Q1hDD/5ZIQD7sfYRA
         xeow==
X-Gm-Message-State: APjAAAVKip75vJISPtsSoEMBd7Fyf+gPzGIpCnH3xuWSNE9CvKkEydxb
        HbpexIepEE6XibEeTUtL5VK7gCcrhPTgm7LSmJ7TpHTd4kCifeRZqMSHJNhF/WASMR4sHhSlpLs
        QKCTqh8LQfzRRM3LPpoNt4qaEU5i6ehIS/+UFRSKt9DGzqqpfeC69+Maqpbf0X9fqOh9s
X-Google-Smtp-Source: APXvYqwdrXHGdnO0ZMpUDBKpMINXBFA5c0PdI89KpN9rgD6G/qP6jwuDBF7F0hSWh4wPG707Kv01fh/hdz9MoTtc
X-Received: by 2002:a63:fb15:: with SMTP id o21mr9391038pgh.193.1573190090832;
 Thu, 07 Nov 2019 21:14:50 -0800 (PST)
Date:   Thu,  7 Nov 2019 21:14:37 -0800
In-Reply-To: <20191108051439.185635-1-aaronlewis@google.com>
Message-Id: <20191108051439.185635-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191108051439.185635-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v4 2/4] kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_LOADSTORE_MSRS
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

