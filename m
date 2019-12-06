Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A841157CE
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 20:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfLFTcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 14:32:16 -0500
Received: from mail-vs1-f73.google.com ([209.85.217.73]:43367 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfLFTcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 14:32:16 -0500
Received: by mail-vs1-f73.google.com with SMTP id j8so1072138vsm.10
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 11:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RcvscsMIfpYbjq4X9AKXrVogIUHEvrO+W/QnGXNMzfk=;
        b=dY6tBvjdFkIIUPknFq9Egln7Q7YL1nDQumi8uUcBlE25nlIKBDl7J7aCWu63hDSPrN
         TJupYGmuu3i5m1C8tiggIEKJSBycfPCC1X5jwbPK1Pj/qjV2t9h+XYyvuOOL42GHIxq3
         /6xVaDORXNPUqwAK8q6rhKrXSiof9A2GhSleesWZ1z2+VSbzmaZpqzpGsEBM5prIEx5T
         iDDORHjldDxLZAe95CDBQ4+nOuXxyfd9plHkBL3G9vWoGrhs/BeMCH2U5YIdbfKLz6J8
         F2qzt/ma2mQnjRummkeTxOu/12Mh30gSyzwR7Eby9+SgnfL/z73UHHXREFm+8rexYBiG
         Cwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RcvscsMIfpYbjq4X9AKXrVogIUHEvrO+W/QnGXNMzfk=;
        b=MsDrvHjkHSWxqIvWU/4xKVCkbDw0By2VslEFjTV9Cfr1+LhGFu9y7tI4dLFuOYf0mk
         8Q9g1Oyp560t8O1xSQoxfil+oKO89yO9a6Cs4N+A59wuVf+8kwJtCFn1rCYqVwirfkvK
         6lYB+PVp3ZQGbg/KVDjWwMUaqx75gyosEz68rohaIEgtBCujh8NZT7TapQG/yt1MM09R
         g9jNJzKGcaJq3t4OsM+1DyyospkXm6uFudC2jIf7Ze1/bUJaFIgp9lPVhdU7N/mifdPo
         +yHDI4n9rgUZVKW02EBlh8bsODkCKb6ObjjZ2our1DONhi65pFI1uBSlqYSSNZvrNV2l
         inLA==
X-Gm-Message-State: APjAAAWxx8ssIxpOGkC4qY8m0WY3JZHh2mXviIGFu5dn+LdSBIAJej9S
        ShTXuXrn37nAS1oi7FC4RvMGJokv/tbD5DR1e7DtPcoldB0siFzAgfoLGgWAlWaY45VrI2REGnW
        DM8XPguvpk9YEnTqTqoPmwl1f5+7REOWzga9dFri33hBJM7ytra+5W/Bmq6z0xOI=
X-Google-Smtp-Source: APXvYqz7Eih+OR7fAhDjKbiJOYcLSQIhIkDETCurItjNcVx1GTknFvvuChJsTrBxT10GzUSuCAuzlvLQb5CZow==
X-Received: by 2002:a1f:bf86:: with SMTP id p128mr13030403vkf.3.1575660734499;
 Fri, 06 Dec 2019 11:32:14 -0800 (PST)
Date:   Fri,  6 Dec 2019 11:31:44 -0800
In-Reply-To: <20191206193144.33209-1-jmattson@google.com>
Message-Id: <20191206193144.33209-3-jmattson@google.com>
Mime-Version: 1.0
References: <20191206193144.33209-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v2 3/3] kvm: nVMX: Aesthetic cleanup of handle_vmread and handle_vmwrite
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apply reverse fir tree declaration order, wrap long lines, reformat a
block comment, delete an extra blank line, and use BIT_ULL(10) instead
of (1u << 10i).

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 94ec089d6d1a..aff163192369 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4751,17 +4751,17 @@ static int handle_vmresume(struct kvm_vcpu *vcpu)
 
 static int handle_vmread(struct kvm_vcpu *vcpu)
 {
-	unsigned long field;
-	u64 field_value;
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	int len;
-	gva_t gva = 0;
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
+	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
+	unsigned long field;
+	u64 field_value;
+	gva_t gva = 0;
 	short offset;
+	int len;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4776,7 +4776,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return nested_vmx_failInvalid(vcpu);
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu,
+				   (((vmx_instruction_info) >> 28) & 0xf));
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
@@ -4794,7 +4795,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	 * Note that the number of bits actually copied is 32 or 64 depending
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
-	if (vmx_instruction_info & (1u << 10)) {
+	if (vmx_instruction_info & BIT_ULL(10)) {
 		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
 			field_value);
 	} else {
@@ -4803,7 +4804,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 				vmx_instruction_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
+		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
+						len, &e))
 			kvm_inject_page_fault(vcpu, &e);
 	}
 
@@ -4836,24 +4838,25 @@ static bool is_shadow_field_ro(unsigned long field)
 
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
-	unsigned long field;
-	int len;
-	gva_t gva;
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
+						    : get_vmcs12(vcpu);
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct x86_exception e;
+	unsigned long field;
+	short offset;
+	gva_t gva;
+	int len;
 
-	/* The value to write might be 32 or 64 bits, depending on L1's long
+	/*
+	 * The value to write might be 32 or 64 bits, depending on L1's long
 	 * mode, and eventually we need to write that into a field of several
 	 * possible lengths. The code below first zero-extends the value to 64
 	 * bit (field_value), and then copies only the appropriate number of
 	 * bits into the vmcs12 field.
 	 */
 	u64 field_value = 0;
-	struct x86_exception e;
-	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
-						    : get_vmcs12(vcpu);
-	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4867,7 +4870,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (vmx_instruction_info & (1u << 10))
+	if (vmx_instruction_info & BIT_ULL(10))
 		field_value = kvm_register_readl(vcpu,
 			(((vmx_instruction_info) >> 3) & 0xf));
 	else {
@@ -4881,8 +4884,8 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		}
 	}
 
-
-	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu,
+				   (((vmx_instruction_info) >> 28) & 0xf));
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
-- 
2.24.0.393.g34dc348eaf-goog

