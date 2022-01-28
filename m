Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B362A49F01A
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbiA1AyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344780AbiA1Axy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:54 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C6FC0613EB
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:46 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r13-20020a638f4d000000b0034c8f73f9efso2389191pgn.4
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=mGxZxg+g6ZaiMksJn+F0cEkCwSeLYT2PlHc8NO118xQ=;
        b=ezC+K2ZYCIk9me/dNtwvfb2XW3fnw1r9FEKqNmkCovZKeu9Y4XQZwUnyPgd8zaVWiY
         rqceTjEgJ1f9SbGM0rmPTX0ooK3yPBzwjmQf20/svRVrsfOGbIHd/xTszFesiOc5iETr
         S+dZT8Er+/CQHPDrTTqKoS64RWDIGobFJvXLSlzWJQFmGJP8tAJXxtPzp87Dg20beE71
         eZFxZUagQvST3G8gahu4dP1EdWo1Td6ZQ4s8E/1ivMC++BDNu6wkB3ERaCVwXtjrQbqX
         6gF82+BnRkDCfKFeKhYEsoqmFrpN74o680AUKI3wFxAaMTy99qVeSs8oMrf0/Vsw9CDc
         Ld7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=mGxZxg+g6ZaiMksJn+F0cEkCwSeLYT2PlHc8NO118xQ=;
        b=nFuJILNNgV7gYXHhCB/Jo8egPNUAID2PYmapnEkAG0jgPsJ/H0IUL3zB+ZUPHUnjKI
         prip4T3MlUgC6KOZPAY0VFsSZQsdai3t6lqBEpJh9Pf2O1Mgnj0an4lmo68ZutQEE7bV
         9SZB5BgjRzwKLXRMo1NWuCVdcCW70nLcALZHQQiZhbQwyqlKHbyKtcrWEKEh/G/mTVfk
         57x7etwa3G40IlLEnzPPBzjKA1T5V/f4f9vLXsJ9lteUaZkUS8qKvlewV+I2msSI+bZb
         EoQgZ6JBfCNoPYlxnfOQFzJlb/0Vzad1ArXQqw/AKwr9Q0b51lcExdSAu5dzGCKqXzw1
         2sSw==
X-Gm-Message-State: AOAM5323LRbO8jZ+bnwERyuWBAfyyF4z6GRcf0yrcBOGSKXRAyqw1QOr
        L7YdrdgOKm8Kmlq1jcQ4cuMOFxJe+yQ=
X-Google-Smtp-Source: ABdhPJx37jAKEAyH5yJrrcF9yjUwqYBFYpjRCzYxoevRZNpimIGXPkTMRDvWujLO9d1nIcU/qycuTykCIOM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bd0a:: with SMTP id
 p10mr6216610pls.159.1643331225540; Thu, 27 Jan 2022 16:53:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:05 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 19/22] KVM: x86: Use more verbose names for mem encrypt
 kvm_x86_ops hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use slightly more verbose names for the so called "memory encrypt",
a.k.a. "mem enc", kvm_x86_ops hooks to bridge the gap between the current
super short kvm_x86_ops names and SVM's more verbose, but non-conforming
names.  This is a step toward using kvm-x86-ops.h with KVM_X86_CVM_OP()
to fill svm_x86_ops.

Opportunistically rename mem_enc_op() to mem_enc_ioctl() to better
reflect its true nature, as it really is a full fledged ioctl() of its
own.  Ideally, the hook would be named confidential_vm_ioctl() or so, as
the ioctl() is a gateway to more than just memory encryption, and because
its underlying purpose to support Confidential VMs, which can be provided
without memory encryption, e.g. if the TCB of the guest includes the host
kernel but not host userspace, or by isolation in hardware without
encrypting memory.  But, diverging from KVM_MEMORY_ENCRYPT_OP even
further is undeseriable, and short of creating alises for all related
ioctl()s, which introduces a different flavor of divergence, KVM is stuck
with the nomenclature.

Defer renaming SVM's functions to a future commit as there are additional
changes needed to make SVM fully conforming and to match reality (looking
at you, svm_vm_copy_asid_from()).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  6 +++---
 arch/x86/include/asm/kvm_host.h    |  6 +++---
 arch/x86/kvm/svm/sev.c             |  2 +-
 arch/x86/kvm/svm/svm.c             |  6 +++---
 arch/x86/kvm/svm/svm.h             |  2 +-
 arch/x86/kvm/x86.c                 | 18 ++++++++++++------
 6 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cb3af3a55317..efc4d5da45ad 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -133,9 +133,9 @@ KVM_X86_HYPERV_OP(tlb_remote_flush)
 KVM_X86_HYPERV_OP(tlb_remote_flush_with_range)
 KVM_X86_HYPERV_OP(enable_direct_tlbflush)
 
-KVM_X86_CVM_OP(mem_enc_op)
-KVM_X86_CVM_OP(mem_enc_reg_region)
-KVM_X86_CVM_OP(mem_enc_unreg_region)
+KVM_X86_CVM_OP(mem_enc_ioctl)
+KVM_X86_CVM_OP(mem_enc_register_region)
+KVM_X86_CVM_OP(mem_enc_unregister_region)
 KVM_X86_CVM_OP(vm_copy_enc_context_from)
 KVM_X86_CVM_OP(vm_move_enc_context_from)
 KVM_X86_CVM_OP(post_set_cr3)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f97d155810ac..6228c12fc6c3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1475,9 +1475,9 @@ struct kvm_x86_ops {
 	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
-	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
-	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
-	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
+	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b82eeef89a3e..7f346ddcae0a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1761,7 +1761,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
-int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
+int svm_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
 	int r;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a6ddc8b7c63b..4b9041e931a8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4581,9 +4581,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.leave_smm = svm_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
 
-	.mem_enc_op = svm_mem_enc_op,
-	.mem_enc_reg_region = svm_register_enc_region,
-	.mem_enc_unreg_region = svm_unregister_enc_region,
+	.mem_enc_ioctl = svm_mem_enc_ioctl,
+	.mem_enc_register_region = svm_register_enc_region,
+	.mem_enc_unregister_region = svm_unregister_enc_region,
 
 	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
 	.vm_move_enc_context_from = svm_vm_migrate_from,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 096abbf01969..7cf81e029f9c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -598,7 +598,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 extern unsigned int max_sev_asid;
 
 void sev_vm_destroy(struct kvm *kvm);
-int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
+int svm_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int svm_register_enc_region(struct kvm *kvm,
 			    struct kvm_enc_region *range);
 int svm_unregister_enc_region(struct kvm *kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b151db419590..01f68b3da5ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6444,8 +6444,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_op)
-			r = static_call(kvm_x86_mem_enc_op)(kvm, argp);
+		if (!kvm_x86_ops.mem_enc_ioctl)
+			goto out;
+
+		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_REG_REGION: {
@@ -6456,8 +6458,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_reg_region)
-			r = static_call(kvm_x86_mem_enc_reg_region)(kvm, &region);
+		if (!kvm_x86_ops.mem_enc_register_region)
+			goto out;
+
+		r = static_call(kvm_x86_mem_enc_register_region)(kvm, &region);
 		break;
 	}
 	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
@@ -6468,8 +6472,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = -ENOTTY;
-		if (kvm_x86_ops.mem_enc_unreg_region)
-			r = static_call(kvm_x86_mem_enc_unreg_region)(kvm, &region);
+		if (!kvm_x86_ops.mem_enc_unregister_region)
+			goto out;
+
+		r = static_call(kvm_x86_mem_enc_unregister_region)(kvm, &region);
 		break;
 	}
 	case KVM_HYPERV_EVENTFD: {
-- 
2.35.0.rc0.227.g00780c9af4-goog

