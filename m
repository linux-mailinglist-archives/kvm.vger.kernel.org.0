Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE654559B8
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343630AbhKRLNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343624AbhKRLMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:12:10 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544E0C06120A;
        Thu, 18 Nov 2021 03:08:35 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id g28so5032329pgg.3;
        Thu, 18 Nov 2021 03:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Etx4Iv9+9jA1gDNW2CzF9nm1X7mKnJqCJON8r7DMYUk=;
        b=L0I+oavX4SYk+9SOpNvDZAf0ki0NgMAK19UaXb3GJiteI/VKeUIzSxcES8MALnHQdd
         Lb5e+/mQHzlznsnMOB+A+o2Zcjbt8WM3ZNkhb2WLzToOjzd1jixfA9zmXU19Ym1DdZqE
         7tCuOjxT1FPpuInTqklSGJZzpDjvGOhGcw7zTEn/d0i45XV+XKP4HucXhSPKgtVTgAtm
         0YVn1cHR3jOotdrPnTcsKIUQHeB/DQONdM/hlzsCIfZYFaoDrASXwfQhmH4Yi++yQaEy
         BeQ0KZ31VJHO04r+RTu7mJ7wpu2/ZBfuTytEnNfvk626HW1/z+ryXLsMY33dCyiDrhjt
         qQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Etx4Iv9+9jA1gDNW2CzF9nm1X7mKnJqCJON8r7DMYUk=;
        b=0LIabbRI6EIQ2mCT1i1EsT1+FHkAGgJiJ+KRpfy97UsCT6zloyA+3SkpbBW9i1+roI
         Ci5ZD8qkK731/pELPgIVZGfhL8U8M70NHeguOpWA2nfcHOS2+Ra+WSYvngnQ2DIMTo3C
         R1T1Yg3gLFzAxpYTymJo+xFZOQLKX1PgpJp2YI+oyhbtI9rsLgZn61zeSJhaJrZsh/kx
         z9MAAW3WAuy7noH6jVeVCmyOzSMsmG9LVoCwjKE46+zM8orYB4iyjhlPUIKtZqoBxXYr
         3P0AOPzxB774jTR7mLL6DK+9gVUaky0uIPnCv3Wt+2WRjkl4ii6vUJHNjAX/iypitPka
         RRHw==
X-Gm-Message-State: AOAM5323jA5P1iwqnZ+suFGCby2ihcx/KR/X4yf0y15EkO8bjMkaiG5x
        TXt3kgwZm42Sd7eQqPWzyUikl+ogzeI=
X-Google-Smtp-Source: ABdhPJyXLYdaEOn8/gAMIkq2OBAxshu/aMYi61rnloV3BChnrsCgjWSyiB8JA+0HQZSyfK/UtAgbrg==
X-Received: by 2002:aa7:8151:0:b0:480:9d40:8e38 with SMTP id d17-20020aa78151000000b004809d408e38mr54582074pfn.72.1637233714790;
        Thu, 18 Nov 2021 03:08:34 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id ot18sm2787450pjb.14.2021.11.18.03.08.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:34 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/15] KVM: VMX: Add document to state that write to uret msr should always be intercepted
Date:   Thu, 18 Nov 2021 19:08:04 +0800
Message-Id: <20211118110814.2568-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

And adds a corresponding sanity check code.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8a41fdc3c4d..cd081219b668 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3703,13 +3703,21 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+	/*
+	 * Write to uret msr should always be intercepted due to the mechanism
+	 * must know the current value.  Santity check to avoid any inadvertent
+	 * mistake in coding.
+	 */
+	if (WARN_ON_ONCE(vmx_find_uret_msr(vmx, msr) && (type & MSR_TYPE_W)))
+		return;
+
 	if (static_branch_unlikely(&enable_evmcs))
 		evmcs_touch_msr_bitmap();
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filters change.
-	*/
+	 */
 	if (is_valid_passthrough_msr(msr)) {
 		int idx = possible_passthrough_msr_slot(msr);
 
-- 
2.19.1.6.gb485710b

