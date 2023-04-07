Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9216DB521
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjDGUUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjDGUUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:20:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596061737
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:20:05 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5131897b5e3so84586a12.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898804; x=1683490804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GgRFXdpbsewXFN8nfe13N4oAoHTkIOTXjaNF6DLenHQ=;
        b=bUPKu4nhvU6AIpMyXIiHt43tbAVl8CQ5zUEZSFuYtVCkd015VQ7DKPwcFXmkmH17As
         lVLq79uj/NQdWNkY26hN2EggIFXZpzKO7MNJr65yXQcHcpHpQeTfnrxw50qg9C4gx8RL
         iy6eCReaQSIdPkYWlJzdeM1yXiqFLrTJzBWQ+KyLOH2z0fuAXahHqDM3ShgTW6UQ8eiS
         71szTjXJlV/MBpQ6pN2g2pLgUqRonwbez8iewZcmNKFaJDdvBEolIbXNt2Ioa/Qw1pE1
         lRrvA7nz+YB0FqnzFEDqCWuFkMZ4mLINvwECc8AohsUCtkcFdtPYhDRkIHP8oomf5Drr
         OrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898804; x=1683490804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GgRFXdpbsewXFN8nfe13N4oAoHTkIOTXjaNF6DLenHQ=;
        b=j22LGqAJMNRSQz7CC8Yep6qpcb7L+wvR0ky1T/MSiDhBUeK4cJv8IlRyosKPSv4RwR
         wuG5C5R8AtxmbEWnAi11CXxrWJFvHyhsjZZLCcFzg3lyO/aLSMjq+0zze3qQBs76EhhZ
         7xsBW8mXfSttQxKpxcpoRG3SxnOWnFKLAoMtMlbEY0XGZo6I/SsT3gfsJuL7qwM79FbO
         EF5xynip0VNLGw2sGGNKlP/jP/r4ZYvgRWIROtH5ENVh9nO7C86mY5Lp5FbPr/egSFPJ
         1nerpoL3+armeR7Ms9ZNAOc1OzPdpVrDhEhAe/em+7XP7ipPzzC/GIjU69AtyeEpoFod
         l2nw==
X-Gm-Message-State: AAQBX9f5JkplpcAt+m3i3iAACq6obdo56C7sDqAa8o26hikLvgtSu0iT
        3ekoi56pkp6B4VdmQH8oJFKXfDgYNO4Yv3g8qpKT+biK7KMUwhsYDKY/irxakvcpgv7XEDBqBlJ
        G5Yq4CHKgXf14cNBPbRNA+hR//s/0cEg2DCT3O2LzJQBq9/FJiSXNPTg=
X-Google-Smtp-Source: AKy350YGEe2C15q4jyE6p1UWvUniafEfLkgm3j9s60Y8u1yQ+nOtXj2Cpevyz/K7PO+ujyOfnnjwJVut0g==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a05:6a00:2d20:b0:627:d4fa:6a9c with SMTP id
 fa32-20020a056a002d2000b00627d4fa6a9cmr1663271pfb.6.1680898803826; Fri, 07
 Apr 2023 13:20:03 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:19:19 +0000
In-Reply-To: <20230407201921.2703758-1-sagis@google.com>
Mime-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407201921.2703758-4-sagis@google.com>
Subject: [RFC PATCH 3/5] KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
From:   Sagi Shahar <sagis@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This should mostly match the logic in sev_vm_move_enc_context_from.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/vmx/main.c    | 10 +++++++
 arch/x86/kvm/vmx/tdx.c     | 56 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  2 ++
 arch/x86/kvm/vmx/x86_ops.h |  5 ++++
 4 files changed, 73 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5b64fe5404958..9d5d0ac465bf6 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -979,6 +979,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
+static int vt_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_move_enc_context_from(kvm, source_fd);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS		       \
 (						       \
        BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
@@ -1141,6 +1149,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
 	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
+
+	.vm_move_enc_context_from = vt_move_enc_context_from,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8af7e4e81c860..0999a6d827c99 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2826,3 +2826,59 @@ int __init tdx_init(void)
 		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
 	return 0;
 }
+
+static __always_inline bool tdx_guest(struct kvm *kvm)
+{
+	struct kvm_tdx *tdx_kvm = to_kvm_tdx(kvm);
+
+	return tdx_kvm->finalized;
+}
+
+static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
+{
+	return -EINVAL;
+}
+
+int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
+{
+	struct kvm_tdx *dst_tdx = to_kvm_tdx(kvm);
+	struct file *src_kvm_file;
+	struct kvm_tdx *src_tdx;
+	struct kvm *src_kvm;
+	int ret;
+
+	src_kvm_file = fget(source_fd);
+	if (!file_is_kvm(src_kvm_file)) {
+		ret = -EBADF;
+		goto out_fput;
+	}
+	src_kvm = src_kvm_file->private_data;
+	src_tdx = to_kvm_tdx(src_kvm);
+
+	ret = pre_move_enc_context_from(kvm, src_kvm,
+					&dst_tdx->migration_in_progress,
+					&src_tdx->migration_in_progress);
+	if (ret)
+		goto out_fput;
+
+	if (tdx_guest(kvm) || !tdx_guest(src_kvm)) {
+		ret = -EINVAL;
+		goto out_post;
+	}
+
+	ret = tdx_migrate_from(kvm, src_kvm);
+	if (ret)
+		goto out_post;
+
+	kvm_vm_dead(src_kvm);
+	ret = 0;
+
+out_post:
+	post_move_enc_context_from(kvm, src_kvm,
+				 &dst_tdx->migration_in_progress,
+				 &src_tdx->migration_in_progress);
+out_fput:
+	if (src_kvm_file)
+		fput(src_kvm_file);
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 71818c5001862..21b7e710be1fd 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -24,6 +24,8 @@ struct kvm_tdx {
 	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
+
+	atomic_t migration_in_progress;
 };
 
 union tdx_exit_reason {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d049e0c72ed0c..275f5d75e9bf1 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -187,6 +187,8 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 void tdx_flush_tlb(struct kvm_vcpu *vcpu);
 int tdx_sept_tlb_remote_flush(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
+
+int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 #else
 static inline int tdx_init(void) { return 0; };
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
@@ -241,6 +243,9 @@ static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { ret
 static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
 static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
+
+static inline int tdx_vm_move_enc_context_from(struct kvm *kvm, u
+					       nsigned int source_fd) { return -EOPNOTSUPP; }
 #endif
 
 #if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)
-- 
2.40.0.348.gf938b09366-goog

