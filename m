Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227E41159C1
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLFXq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:46:56 -0500
Received: from mail-ua1-f74.google.com ([209.85.222.74]:37702 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLFXq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:46:56 -0500
Received: by mail-ua1-f74.google.com with SMTP id q23so2765711uar.4
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 15:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Omb2N8rapJnlYgPKGBZO4Ry7yz4/k07W4Hzsyqy3ZaM=;
        b=lHwyLBJwhrr4gPxzXyzMccQQw9vsFkcOnXAogBbnAVAQm9rW4CNQWvuETiJ4xlYMoU
         WZ4aGisOTMrQQDFodmhpm5l8qo3f6pIfGKaGrJlzptnYfkVvS/wVsLbsYZRR+/9+8NuS
         /g816Vzc15F7t/Quu2dwtFT/2SumwOYT3l8JGCtMG6TX4qolxvEqH7EUijJa6E2YOtpt
         0GWNgTIvZo00T1RPb4ewCcOpUUtABiIZNN8iaDWoPBU6FwT7a2OIZ4LvYvLtXcg2q8c7
         uGZK/RcJNeCZJR1JDtKQjHZHRATmaTVZGnWs75jHdXNjMU9nANMvlSuqUR6YDJ1pABpT
         l+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Omb2N8rapJnlYgPKGBZO4Ry7yz4/k07W4Hzsyqy3ZaM=;
        b=tnD2ovJtVWgIniW4pEvW4uXtWc8Fviwi5JkUEn4yrgnCSP5bjLtaCwIAhsRf4RSpx1
         XqyqUJ81K2LEEZBA/D+oCsLPlu2JE/nSGS3lNHWByaKKfquXgoyQPZ5EfXBziAoqwY05
         at8bxE7+57M0dBjtogKXyLdXc0w+Xm9M/0wXI6mnsyyBfEsbKhDyrZRYQ405qnZK9rRB
         RXeYKwdiWHPfvkOBzTD+ZX2BPK0OjoLbCsSWsk7ItPYTIVQFU3dZ3nG8pjKUekXsC+ST
         40sadzrm7k0JbzJwUuqyaUByYgLdA4/F3hcAyikGvwJ2MrYn6ToS56Ntp2UclfMFUUn0
         C9Aw==
X-Gm-Message-State: APjAAAX6zQz/wiN1fo3vHZS5shvZYy4BO8nQEnW/F+dIO7pPPci2mheo
        a9G7relmUUhZzC6NkJgI3oSAMpv6Ok4o3kwwqxF4vF8DQ9ST+fR4jibUxYZNYudq/s0xIrYfZcy
        D/XY6jVAyYt+so/2edNwsTpqmfIg8CnCvz345t0cZPgO4TGf+aZuklhBpePThLRA=
X-Google-Smtp-Source: APXvYqyt2hiQ+CIvgYbjyO/iv0e6k7ndZqFly+crPeXSRzXTyzzO22OdhzyPtLQG4hkjZBEpsrjTDiL+XUqaIQ==
X-Received: by 2002:a9f:3e84:: with SMTP id x4mr14843414uai.83.1575676015004;
 Fri, 06 Dec 2019 15:46:55 -0800 (PST)
Date:   Fri,  6 Dec 2019 15:46:37 -0800
In-Reply-To: <20191206234637.237698-1-jmattson@google.com>
Message-Id: <20191206234637.237698-3-jmattson@google.com>
Mime-Version: 1.0
References: <20191206234637.237698-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v3 3/3] kvm: nVMX: Aesthetic cleanup of handle_vmread and handle_vmwrite
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apply reverse fir tree declaration order, shorten some variable names
to avoid line wrap, reformat a block comment, delete an extra blank
line, and use BIT(10) instead of (1u << 10).

Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
---
v1 -> v2:
 * New commit in v2.
v2 -> v3:
 * Shortened some variable names instead of wrapping long lines.
 * Changed BIT_ULL to BIT.

 arch/x86/kvm/vmx/nested.c | 70 +++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 94ec089d6d1a..336fe366a25f 100644
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
+	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
+	unsigned long field;
+	u64 value;
+	gva_t gva = 0;
 	short offset;
+	int len;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4776,7 +4776,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return nested_vmx_failInvalid(vcpu);
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
@@ -4786,24 +4786,23 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
 		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
-	/* Read the field, zero-extended to a u64 field_value */
-	field_value = vmcs12_read_any(vmcs12, field, offset);
+	/* Read the field, zero-extended to a u64 value */
+	value = vmcs12_read_any(vmcs12, field, offset);
 
 	/*
 	 * Now copy part of this value to register or memory, as requested.
 	 * Note that the number of bits actually copied is 32 or 64 depending
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
-	if (vmx_instruction_info & (1u << 10)) {
-		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
-			field_value);
+	if (instr_info & BIT(10)) {
+		kvm_register_writel(vcpu, (((instr_info) >> 3) & 0xf), value);
 	} else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-				vmx_instruction_info, true, len, &gva))
+					instr_info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
-		if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
+		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e))
 			kvm_inject_page_fault(vcpu, &e);
 	}
 
@@ -4836,24 +4835,25 @@ static bool is_shadow_field_ro(unsigned long field)
 
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
+	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
+						    : get_vmcs12(vcpu);
+	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct x86_exception e;
 	unsigned long field;
-	int len;
+	short offset;
 	gva_t gva;
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	int len;
 
-	/* The value to write might be 32 or 64 bits, depending on L1's long
+	/*
+	 * The value to write might be 32 or 64 bits, depending on L1's long
 	 * mode, and eventually we need to write that into a field of several
 	 * possible lengths. The code below first zero-extends the value to 64
-	 * bit (field_value), and then copies only the appropriate number of
+	 * bit (value), and then copies only the appropriate number of
 	 * bits into the vmcs12 field.
 	 */
-	u64 field_value = 0;
-	struct x86_exception e;
-	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
-						    : get_vmcs12(vcpu);
-	short offset;
+	u64 value = 0;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
@@ -4867,22 +4867,20 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (vmx_instruction_info & (1u << 10))
-		field_value = kvm_register_readl(vcpu,
-			(((vmx_instruction_info) >> 3) & 0xf));
+	if (instr_info & BIT(10))
+		value = kvm_register_readl(vcpu, (((instr_info) >> 3) & 0xf));
 	else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-				vmx_instruction_info, false, len, &gva))
+					instr_info, false, len, &gva))
 			return 1;
-		if (kvm_read_guest_virt(vcpu, gva, &field_value, len, &e)) {
+		if (kvm_read_guest_virt(vcpu, gva, &value, len, &e)) {
 			kvm_inject_page_fault(vcpu, &e);
 			return 1;
 		}
 	}
 
-
-	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
@@ -4914,9 +4912,9 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 * the stripped down value, L2 sees the full value as stored by KVM).
 	 */
 	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
-		field_value &= 0x1f0ff;
+		value &= 0x1f0ff;
 
-	vmcs12_write_any(vmcs12, field, offset, field_value);
+	vmcs12_write_any(vmcs12, field, offset, value);
 
 	/*
 	 * Do not track vmcs12 dirty-state if in guest-mode as we actually
@@ -4933,7 +4931,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			preempt_disable();
 			vmcs_load(vmx->vmcs01.shadow_vmcs);
 
-			__vmcs_writel(field, field_value);
+			__vmcs_writel(field, value);
 
 			vmcs_clear(vmx->vmcs01.shadow_vmcs);
 			vmcs_load(vmx->loaded_vmcs->vmcs);
-- 
2.24.0.393.g34dc348eaf-goog

