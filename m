Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2BD7A6A29
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjISRus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 13:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjISRum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 13:50:42 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB1D132
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:26 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-690bbc5fabaso1596966b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 10:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145826; x=1695750626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nc9IhLzKfLsRQeYUmIOlUXC0AFKZ1OL0TidKJ4UxU6g=;
        b=tc7UppjrMPGvlTNR5c+mNW/bklLZmi4LXq4pvUJs6TCWTA6vxQWrGr4bxBJn9J2sU9
         l5cT2hUkqijNBsGqFjdNVhG5rW8z0U9X24/gBJIuzHXMw9IfG0JdJyM/LuGsNsW47o70
         DSW9SQuy51gD6BD7VMIVAd+24u+s4DuDwbATlkncwaAReFgE0LhL6r9jkfv7LHxA7zWW
         qu/mLy4f+ycZYxtcFjGHlbFr4xeFywaGFTV7ZJyRLytmESweerWSvGeXpcPQ1Pg/X7vy
         +RbzFWgRniqSVNGbOLtZ1JUw2bZ0rVsBVW/J3Y2Owr297q7F7/Q+o/ALl7ANNrKB6Om2
         wAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145826; x=1695750626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nc9IhLzKfLsRQeYUmIOlUXC0AFKZ1OL0TidKJ4UxU6g=;
        b=huxmsioixZm5UOClwi6AtlrdF3HVdlPxxh3MLDw1whsgusl+QJgzUalflQLExy3VCn
         pMUuvh+7qOiDiu4W3+q0mhjSWhkER+UZKJ/N3q/w4hhBLTsR9aQwcXI85rVMqPCaLGfR
         6lmEPhc3+y7CAIqD5N5JSpw789/NbaCloUaXjNfNCghUhrnQ1ztaErlExMhZo0rGcQbE
         OX7ZBnPXAbo5lYLSbpvS40uAlogGKUJPJ5KDBZAH897sMyN4F0cSYZT+UIt/iX+MIB8q
         u1nVPYmHOmtWaVQKrOTD3s7MW8LEP2R+PVhrLuwlYkQ5XfDWZGZI8QvASBWElYIYzc9g
         YrRg==
X-Gm-Message-State: AOJu0YyGGGRi8Zzo0S5kC3kAkgyFh9/lJ9cyxXPsL6ynwz/zX89Lq0Jw
        B2A4xoHplbbZ9HQRDeh50jy6oFXXNYiT388FRwA9nfXdQ+8UnvUPOPvqVxIivihPeLiK7v40+Sj
        jmeRiAI+Yu33bFEkcZBLigW1vLdoReGKJQRGkVFR4rhSxlm7NvNhGU3g3m87YXrsMJ5ol4Ms=
X-Google-Smtp-Source: AGHT+IEzgFYHWoI5Y3ME7mliKGcMaRUOApa6TvADiOKyCMaHRzNyZfIVjUxH+iPvlizVJNpMNCc2HZAFY/N/OxlUeQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2289:b0:68f:fa41:4e94 with
 SMTP id f9-20020a056a00228900b0068ffa414e94mr9025pfe.0.1695145825464; Tue, 19
 Sep 2023 10:50:25 -0700 (PDT)
Date:   Tue, 19 Sep 2023 10:50:13 -0700
In-Reply-To: <20230919175017.538312-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230919175017.538312-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-2-jingzhangos@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Allow userspace to get the writable masks
 for feature ID registers
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While the Feature ID range is well defined and pretty large, it isn't
inconceivable that the architecture will eventually grow some other
ranges that will need to similarly be described to userspace.

Add a VM ioctl to allow userspace to get writable masks for feature ID
registers in below system register space:
op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
This is used to support mix-and-match userspace and kernels for writable
ID registers, where userspace may want to know upfront whether it can
actually tweak the contents of an idreg or not.

Add a new capability (KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES) that
returns a bitmap of the valid ranges, which can subsequently be
retrieved, one at a time by setting the index of the set bit as the
range identifier.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++
 arch/arm64/kvm/arm.c              | 10 +++++
 arch/arm64/kvm/sys_regs.c         | 66 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 +
 5 files changed, 112 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..5e3f778f81db 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1078,6 +1078,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			       struct kvm_arm_copy_mte_tags *copy_tags);
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm,
+					struct reg_mask_range *range);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..01242274db87 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,38 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/*
+ * Get feature ID registers userspace writable mask.
+ *
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all currently known R/O registers that indicate
+ * anything useful feature wise, including the ID registers.
+ *
+ * If we ever need to introduce a new range, it will be described as
+ * such in the range field.
+ */
+#define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+#define ARM64_FEATURE_ID_RANGE_IDREGS	BIT(0)
+
+struct reg_mask_range {
+	__u64 addr;		/* Pointer to mask array */
+	__u32 range;		/* Requested range */
+	__u32 reserved[13];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..1c4017a253fd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -317,6 +317,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
 		r = kvm_supported_block_sizes();
 		break;
+	case KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES:
+		r = ARM64_FEATURE_ID_RANGE_IDREGS;
+		break;
 	default:
 		r = 0;
 	}
@@ -1629,6 +1632,13 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 		return kvm_vm_set_attr(kvm, &attr);
 	}
+	case KVM_ARM_GET_REG_WRITABLE_MASKS: {
+		struct reg_mask_range range;
+
+		if (copy_from_user(&range, argp, sizeof(range)))
+			return -EFAULT;
+		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..cdb9976d8091 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1373,6 +1373,13 @@ static inline bool is_id_reg(u32 id)
 		sys_reg_CRm(id) < 8);
 }
 
+static inline bool is_aa32_id_reg(u32 id)
+{
+	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
+		sys_reg_CRm(id) <= 3);
+}
+
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
 				  const struct sys_reg_desc *r)
 {
@@ -3572,6 +3579,65 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+#define ARM64_FEATURE_ID_SPACE_INDEX(r)			\
+	ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(r),	\
+		sys_reg_Op1(r),				\
+		sys_reg_CRn(r),				\
+		sys_reg_CRm(r),				\
+		sys_reg_Op2(r))
+
+static bool is_feature_id_reg(u32 encoding)
+{
+	return (sys_reg_Op0(encoding) == 3 &&
+		(sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) == 3) &&
+		sys_reg_CRn(encoding) == 0 &&
+		sys_reg_CRm(encoding) <= 7);
+}
+
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *range)
+{
+	const void *zero_page = page_to_virt(ZERO_PAGE(0));
+	u64 __user *masks = (u64 __user *)range->addr;
+
+	/* Only feature id range is supported, reserved[13] must be zero. */
+	if (range->range != ARM64_FEATURE_ID_RANGE_IDREGS ||
+	    memcmp(range->reserved, zero_page, sizeof(range->reserved)))
+		return -EINVAL;
+
+	/* Wipe the whole thing first */
+	if (clear_user(masks, ARM64_FEATURE_ID_SPACE_SIZE * sizeof(__u64)))
+		return -EFAULT;
+
+	for (int i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
+		const struct sys_reg_desc *reg = &sys_reg_descs[i];
+		u32 encoding = reg_to_encoding(reg);
+		u64 val;
+
+		if (!is_feature_id_reg(encoding) || !reg->set_user)
+			continue;
+
+		/*
+		 * For ID registers, we return the writable mask. Other feature
+		 * registers return a full 64bit mask. That's not necessary
+		 * compliant with a given revision of the architecture, but the
+		 * RES0/RES1 definitions allow us to do that.
+		 */
+		if (is_id_reg(encoding)) {
+			if (!reg->val ||
+			    (is_aa32_id_reg(encoding) && !kvm_supports_32bit_el0()))
+				continue;
+			val = reg->val;
+		} else {
+			val = ~0UL;
+		}
+
+		if (put_user(val, (masks + ARM64_FEATURE_ID_SPACE_INDEX(encoding))))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	struct sys_reg_params params;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 13065dd96132..2102df261f1b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1192,6 +1192,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES 230
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1562,6 +1563,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.42.0.459.ge4e396fd5e-goog

