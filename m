Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F598FDB7A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfKOKgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:36:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38427 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKOKgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:36:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so9831110wmk.3;
        Fri, 15 Nov 2019 02:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=frWZkSD6sy+8xeYJ3Z3Dvc1ltroH4PVNYqHO9zC/gkU=;
        b=oAaeCX6Lw4vTyv0tC3MmzjWCZ0wJwGhNiup8LtPqlbMwl4Tz0ld9uF9kAdkXbv0j1m
         F/3MQx4qpNlS1NE/4ZuukATOeEbUzu+9ESR0W86lDELqojpGB7Ocsodi97F+PbTN4Ls7
         5io2PJ2RgWlEThI3Yoh/Pcxe6cEN9tSmgOSaun0R3G0Mo5jBNK+NPU4XkWu6X4LztwJO
         I4qtJYHR1ggCeMx9tUvzUXOAknQk7ogN7QcRf0yp553OqA8i8MmhHDIdK4kTokmxN0Ym
         qliw4KqyhB0i8W9dsat0p9Wlin6ravgfbVCu7ekv/uXV71d+ffavN1IBZCSpKpI3SSpp
         5BiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=frWZkSD6sy+8xeYJ3Z3Dvc1ltroH4PVNYqHO9zC/gkU=;
        b=RfCsLMhR7qjgGCZDyr5ML9ZD1byy49AYIJyG241QniH4wAMH/gHHeyjZTppAwsDm/W
         2i5zMsau9wxc5k08h/0gIlMD7PBcFzEfrJcky5kvcECk9AYaFroWXrjJ+VecHAP4hvV0
         LY1pDiwmzm/dmUwttxp3LVR/IxRiZJyhRSzCBAods9McmGOel+QPc5G8/1e/dN1vQzOM
         y4FJ/sertNVQedEgyACMVWoLHr/7cbZuRGXQu4XjKZuuEm9wwF2yVIAKg2IZQ0TjBlhP
         sxailiprI+j/Kbg8DjznClGyJgpTrfqaGh5NfnsC7JlwHUGZPhRZyMRqlKQRxKAZ65g9
         Pv/Q==
X-Gm-Message-State: APjAAAURzzYOwLGKBahtFwX4l6cOk2KnlT/G7pIgImF8kdW/kQcuP03e
        y5OwjakZ2BDgPqQEA2zyIENbd6rf
X-Google-Smtp-Source: APXvYqwR8q3zsqox2ep5AOsJj1majxWGrUKLw6Izp+EvrWGnzP7gzmSEyY6YmaYXu6FJDq4UwXpgnQ==
X-Received: by 2002:a1c:4e1a:: with SMTP id g26mr14110733wmh.138.1573814178104;
        Fri, 15 Nov 2019 02:36:18 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b186sm8801138wmb.21.2019.11.15.02.36.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 02:36:17 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: nVMX: mark functions in the header as "static inline"
Date:   Fri, 15 Nov 2019 11:36:16 +0100
Message-Id: <1573814176-28536-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correct a small inaccuracy in the shattering of vmx.c, which becomes
visible now that pmu_intel.c includes nested.h.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 19e6015722a9..b9e519840f28 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -246,7 +246,7 @@ static inline bool fixed_bits_valid(u64 val, u64 fixed0, u64 fixed1)
 	return ((val & fixed1) | fixed0) == val;
 }
 
-static bool nested_guest_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
+static inline bool nested_guest_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	u64 fixed0 = to_vmx(vcpu)->nested.msrs.cr0_fixed0;
 	u64 fixed1 = to_vmx(vcpu)->nested.msrs.cr0_fixed1;
@@ -260,7 +260,7 @@ static bool nested_guest_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	return fixed_bits_valid(val, fixed0, fixed1);
 }
 
-static bool nested_host_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
+static inline bool nested_host_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	u64 fixed0 = to_vmx(vcpu)->nested.msrs.cr0_fixed0;
 	u64 fixed1 = to_vmx(vcpu)->nested.msrs.cr0_fixed1;
@@ -268,7 +268,7 @@ static bool nested_host_cr0_valid(struct kvm_vcpu *vcpu, unsigned long val)
 	return fixed_bits_valid(val, fixed0, fixed1);
 }
 
-static bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
+static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	u64 fixed0 = to_vmx(vcpu)->nested.msrs.cr4_fixed0;
 	u64 fixed1 = to_vmx(vcpu)->nested.msrs.cr4_fixed1;
-- 
1.8.3.1

