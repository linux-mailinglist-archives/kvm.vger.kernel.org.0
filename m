Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1BE57834D0
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjHUVWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjHUVWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:22:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AED4C7
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-565e78b8b31so4069883a12.2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 14:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652969; x=1693257769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2B7Qy6Kw5j/nTo/++b4jHC7ZtOMGC89Nxbhsckocxfk=;
        b=bJhawE4Uhw56ASBDjFYeOUlLqMZlQeCKQIJ7UYtdJOCDTJd68Ir9e9VfvRLfnTgX6H
         VLShYlvLVCw1aq4fZu3uTxVWGWpQhT/H9tK0L0FX9+6SuZTdn35543bhQtizWC3xXzyd
         lBqn+TNEyxr4YAHP5PGaYKvUst+Thd0/VOBSPWvgl6XyTD8ud+pwSCb2MjENzFhN3CJ9
         ualZc/+6TGm2R3NBNYPsvpxrEVvndkOhqWQvdYkuBQg9zr9y9CkoAgM4XrEFzYCK+tTA
         q5zeXbOCB2GKlHamZFmpTdLZYyDFc8BGf9uRieUSWHRr+Bs5X9HJyAjNacuj2q3hbGpD
         LFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652969; x=1693257769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2B7Qy6Kw5j/nTo/++b4jHC7ZtOMGC89Nxbhsckocxfk=;
        b=D9VpI/WTDBlQUmdrQWlXqt3tlp1i9DmITQtT4lnpQFfb0/ZW/pPZeAVTubPsMP09+o
         hs9ZmpMwAegl46A8hTzrVAmngo319j+aXQVLoZDKC5kCJ1H1N+ViZ2inlTeztGsvP9X+
         IIgVFLeboSYZksCUDpwvShuJ24XTUzC6NJKcc4rK3NNMpc4uMWCsOu8kSyDdMv1YV4/b
         cVdg/7+DZ+SPdCVy8Z6b7a/awun//2qglhFvtXHs5/pe3hXZbkufsZXiUHleX+tIlsno
         3VR+JG9KHMRIuOs23FE64DZxOApdoHg3WaFcPfipjhBmyvZcxwrSVRmxAqQksOHQlDOv
         pCXA==
X-Gm-Message-State: AOJu0Yy1JlJL9mM4ChnPxXxkWdor3OiPGU3F8ojDtMfM5Ch82JeYMtuf
        rP03CNvEx/MOcrqj4yJPqHPCY0dyjPufAckGQhyku/mKjapNctoNZTWpI8/61Nph+OgNGa+vN2L
        qdcVvtwbgI4drVcWr/1N57eQg7NFH4Rr0gS6qkJzfvj+X44pLyUN9UT60vYzPG3w7uMt6YtU=
X-Google-Smtp-Source: AGHT+IFSEGdu2t4zwctottOZyfhvKMdc+9pCmvEQUmekmWTsy2kBSMFlsqmqWUe4mc3/Ykgfegb5kfjn1Y36WAIpIw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2d87:b0:67e:86c0:6bd3 with
 SMTP id fb7-20020a056a002d8700b0067e86c06bd3mr4675455pfb.1.1692652968987;
 Mon, 21 Aug 2023 14:22:48 -0700 (PDT)
Date:   Mon, 21 Aug 2023 14:22:33 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-2-jingzhangos@google.com>
Subject: [PATCH v9 01/11] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
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
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a VM ioctl to allow userspace to get writable masks for feature ID
registers in below system register space:
op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
This is used to support mix-and-match userspace and kernels for writable
ID registers, where userspace may want to know upfront whether it can
actually tweak the contents of an idreg or not.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h | 26 ++++++++++++++
 arch/arm64/kvm/arm.c              |  7 ++++
 arch/arm64/kvm/sys_regs.c         | 57 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 5 files changed, 93 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..a328d362df5a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			       struct kvm_arm_copy_mte_tags *copy_tags);
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
+int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm,
+					struct reg_mask_range *range);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..7a21bbb8a0f7 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,32 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/* Get feature ID registers userspace writable mask. */
+/*
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all R/O registers that indicate anything useful feature
+ * wise, including the ID registers.
+ */
+#define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+struct reg_mask_range {
+	__u64 addr;		/* Pointer to mask array */
+	__u64 reserved[7];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d1cb298a58a0..cfb5e9ef43c4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1630,6 +1630,13 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
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
index 2ca2973abe66..216905840c92 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3560,6 +3560,63 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
+	/* Only feature id range is supported, reserved[7] must be zero. */
+	if (memcmp(range->reserved, zero_page, sizeof(range->reserved)))
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
+			if (!reg->val)
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
index f089ab290978..424b6d00440b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1555,6 +1555,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.42.0.rc1.204.g551eb34607-goog

