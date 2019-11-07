Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8ECF3BBC
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 23:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfKGWuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 17:50:01 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:34312 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfKGWuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 17:50:01 -0500
Received: by mail-vk1-f201.google.com with SMTP id r16so1841951vkd.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 14:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a4CIljDdvkHl1ogbtcZjf6TC/OiDGj7XTi1C8LhO2/M=;
        b=jhf/LkyDtnHhL12H6g4qt5F5/ESFFCDVBMyEgQ5NIgpe49ZPMNTaQkf/i63zj/AYIa
         59Dcy0966Ql5yX4KBuIPC6v0VMrmlwFGcwqARVNJdFY/4aQwjqvRK0jvhMOL2xRdOLQF
         GqU28H1xn8qU+pTqsLlwdtdzFGXUGqeBLhZvkpxDRrT6fnO7t3ORqzfho1mOvzN9GDqh
         0wo83nwpDdmvW4EmRAtYuQkjR/IKRbHoetrB5Jo6sKngxv5WXuugG0aLx3J9mTPsTl+5
         iOuUBW4/eg0BhlgxQ/Fa1FeG/pnxY6nNsQ4II5ik9ffKuK3pEzKa+8UlgfuxPUdQag+q
         4bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a4CIljDdvkHl1ogbtcZjf6TC/OiDGj7XTi1C8LhO2/M=;
        b=maeTWTnOZUjRlG7rDjQIQt1PHMYOPojauNa2LCo8Ds+ijxagR6sV6Mus2vpuu/Cx23
         z3poUxsdR/TW2+eE3JFO8lCWj9WoZuBxA/HyRXS9cJKSTTv7G994aPzLvnXBG0Eerzhy
         D7lkDkQx+5FDdP5UETbYNltmdC+4HWosjOfFlyRKTI8SBgMz2brMHjVof76mTaKy4mfY
         8JOXipe2ZaWaCy8RcanfnIAkgR0bNFktTW3F4f3cmvTp2+exDj6v0sKd/jkH1DygugTO
         BNxL5E/dbG7JFGWauLTEbRQY+LUgJ4vUmfdDewfABY6ijHWSVpzDpiARzaKoJVsy+C7T
         DuTQ==
X-Gm-Message-State: APjAAAWOdc5EVQHs6t4sZK1P6cPoMiI4zp9xs/05cJhs6FzD/8i/JZEz
        Vq/sXaO7TPDYJFp63lT/HXewFBtKoRZNF/O0cD4KfUeLoixCZ/OelzqBD2FtrOMS+pPChrzKrOv
        SKMrTUOraST28gQEyqJsZWAY9hcN8rKv0VDKfihivAQp6yIOPt0tKzBJzTD4Gq2mhyVob
X-Google-Smtp-Source: APXvYqzCzAkkrKssucP+MzRc/ugee5aNFGNZ14IIWvXySdfr/gZL55DxmbbZ2wy0sWHQCX2AbBbaIWYcz8Y0t11d
X-Received: by 2002:ab0:77da:: with SMTP id y26mr4298565uar.137.1573166998621;
 Thu, 07 Nov 2019 14:49:58 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:49:40 -0800
In-Reply-To: <20191107224941.60336-1-aaronlewis@google.com>
Message-Id: <20191107224941.60336-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191107224941.60336-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v3 4/5] KVM: nVMX: Prepare MSR-store area
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

Prepare the MSR-store area to be used in a follow up patch.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/nested.c | 17 ++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h    |  4 ++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7b058d7b9fcc..c249be43fff2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -982,6 +982,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return 0;
 }
 
+static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
+
+	autostore->nr = 0;
+}
+
 static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	unsigned long invalid_mask;
@@ -2027,7 +2035,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	 * addresses are constant (for vmcs02), the counts can change based
 	 * on L2's behavior, e.g. switching to/from long mode.
 	 */
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
 
@@ -2294,6 +2302,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
 	}
 
+	/*
+	 * Make sure the msr_autostore list is up to date before we set the
+	 * count in the vmcs02.
+	 */
+	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
+
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr);
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1dad8e5c8f86..2616f639cf50 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -230,6 +230,10 @@ struct vcpu_vmx {
 		struct vmx_msrs host;
 	} msr_autoload;
 
+	struct msr_autostore {
+		struct vmx_msrs guest;
+	} msr_autostore;
+
 	struct {
 		int vm86_active;
 		ulong save_rflags;
-- 
2.24.0.432.g9d3f5f5b63-goog

