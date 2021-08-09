Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CCE3E42CC
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhHIJer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbhHIJeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:34:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840EDC0613CF;
        Mon,  9 Aug 2021 02:34:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso662982pjb.1;
        Mon, 09 Aug 2021 02:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5jB8CoTWK2C4ziZeKzeYIfYXklUI9UOSANjF0ttEBWc=;
        b=cMfv9a7/zeSchOm6rgA2iBCzcCgPawm058zZmliElUjw5rfCx1RPivisNphQdRG+Uc
         Q91I1bbBdEBbaTUSdPLC66kCYFSt152lag39+XBxEOFYuVSD5TbTMpYHUJfwLSzHm2q5
         PaBFuAmsKFGMOOCtemxvd45P4s8pCl5wmyb/PkbQ/hiYWYkSLbWifhzVtKDE5+CfpM19
         ynvXXmkgayhsyHHq//bdNN6uMrYjUX9CdNyhYcDMDgrP1HpH5YElkCsMvmS0amPoX4ok
         pvB/qymyx0koxABC1I57r04A1+bMsh4SLZ53z6DHtDCxc7/5uBYepYddvFlEkiWKrhC1
         K8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5jB8CoTWK2C4ziZeKzeYIfYXklUI9UOSANjF0ttEBWc=;
        b=qOF9WdeUzg9F9G6J2Ueq8pfrHdvmwI/ZB0BeGFPsl7IPcI8xhNS/HFEWrdpNI9+yjN
         cKhf0IKdjtuRSJWbtf9InVN22XWqAKM4kswGKpH56vE8ZFO3FGqavtOLjmR0X9We/p/4
         uf3VtE656aULc7dHsPoLhhVFvZTM15ianYQIzep1rsBhx6xflF8gQ/XotkLejUDGvYYN
         ak8+EKQl9BSLozoDxYTvi0WDOSNNvBcquK9uLd6tGFeelytkz5oeRHGNyfvXPst37FaB
         VN/vnBw7DHUdD+gcM2cwCvGovpPPesgTc5VrUsAT6DG/0pe3ANaTBjUe1XUZVmIhL3YV
         AH5Q==
X-Gm-Message-State: AOAM532COthiJLqqYKAMUv+Zs9DT+zfBIXoxAVZQdcqf/wFXRUhBp+Rn
        owIn599YammmLYmCkvMMuf4=
X-Google-Smtp-Source: ABdhPJxOHWdPCzmG+3XrWMpK6NGltR81LX3pHqFBvsFSGhlXxJ43yuht5ggjYdMn2UIRFpW757ijjg==
X-Received: by 2002:a17:90a:d702:: with SMTP id y2mr3014220pju.127.1628501665087;
        Mon, 09 Aug 2021 02:34:25 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h188sm10839982pfg.45.2021.08.09.02.34.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:34:24 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: x86: Clean up redundant CC macro definition
Date:   Mon,  9 Aug 2021 17:34:07 +0800
Message-Id: <20210809093410.59304-3-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809093410.59304-1-likexu@tencent.com>
References: <20210809093410.59304-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With the exception of drivers/dma/pl330.c, the CC macro is defined and used
in {svm, vmx}/nested.c, and the KVM_NESTED_VMENTER_CONSISTENCY_CHECK
macro it refers to is defined in x86.h, so it's safe to move it into x86.h
without intended functional changes.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/nested.c | 2 --
 arch/x86/kvm/vmx/nested.c | 2 --
 arch/x86/kvm/x86.h        | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e13357da21e..57c288ba6ef0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -29,8 +29,6 @@
 #include "lapic.h"
 #include "svm.h"
 
-#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
-
 static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 				       struct x86_exception *fault)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0d0dd6580cfd..404db7c854d2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -22,8 +22,6 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 static bool __read_mostly nested_early_check = 0;
 module_param(nested_early_check, bool, S_IRUGO);
 
-#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
-
 /*
  * Hyper-V requires all of these, so mark them as supported even though
  * they are just treated the same as all-context.
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6aac4a901b65..b8a024b0f91c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -67,6 +67,8 @@ static __always_inline void kvm_guest_exit_irqoff(void)
 	failed;								\
 })
 
+#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
+
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
 #define KVM_DEFAULT_PLE_WINDOW_GROW	2
-- 
2.32.0

