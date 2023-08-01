Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7625576B873
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjHAPUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjHAPUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:21 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BF61BFD
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:15 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6870e364e74so3001437b3a.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903214; x=1691508014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=747YuA1Dx3SnOAWlrzcy+YkCaluTCLGvH8CPu7tzkC4=;
        b=4Fjv36NP8lCVIwsx0PzaNTkiNwo5hPlerQW1QsOJfYMtkV047Ll/r0RtmkZzhJalek
         I/KJmhiLZAC8fHFHn2YLO4WE0ovMwSxTJbzQJ16vnei+1rmckS6dmJNGRTXV14Eth9DN
         MTm4UbXHLhRm6vmxrdWEtASp/ef6HYG8si3LboTezWGQd4WonZ5Xi7eYVZ4R6nV2CTuv
         lCUadlN3DdlZOXQoqO8wyz273H2r+J5QShIbm85cBhUGn0u/21rNOLFiwMNUYYyww1rD
         ycBZ3ghYM7nsRvAxar4Ihvo7MpPR6ZU/CuhvXtDwIQ0oDYYfOx3hz4yz5evIYEkG91Tq
         pVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903214; x=1691508014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=747YuA1Dx3SnOAWlrzcy+YkCaluTCLGvH8CPu7tzkC4=;
        b=a2h8EkaLM5jWcwyCLatSG3uMDZEkxsJPe7A1E+zRb2cZepIEwgzsn5Zd5gkjWsO8x5
         0+VmAq2bkR6yRt7Rxx0Q4K0PfovNxkmW+dXWPzT/TA0FLWkCKBYMGifZJnpsA8R/Inks
         76bpkNSrwYEuQup8oFRYo1iV8dqCfskKSIKPs29Rzrx2R7lY0l5kZ8OtZmZ2Y8D4FlMd
         9VzG75HkNQBaVCh1HNWGViW3BI4immk1UBr7/FwCvOZqxWk2DXcirmjdOoF4+B852Pc6
         LQLjmeSPMtT8QaJkGStT8JeMt/sOCNbmmYn6eXnlfLb7n5INa1O/IrrvejVb8c3bL4Y2
         xjew==
X-Gm-Message-State: ABy/qLbV5EmU6zXkei+Zv/O3vX2IKfGiAnBbmHVVhZ8ImLU2UKeyGvFA
        6BsKNjPJVKgsiJGJ61IBvcVGwCrk6BhcCdtn1R2sOYFDsRXwFFyqRGxdPpn2bFBPR3ElYdOEG5T
        Zbbdkoq9QuxbQ8Q5Ibm74TawgA+ZVtuNctWpB9SV+3fcNCoEM4hauw3c7HDUrSwHu/XSJIzs=
X-Google-Smtp-Source: APBJJlFYIduNuYy0wvIby8yBJwkrjNp6LvpOSugL72WbrXU69i6bGxB5cmDBygkjJXCN14JhWaFyNL7KmMaDXCMNOw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:21c3:b0:66a:4525:8264 with
 SMTP id t3-20020a056a0021c300b0066a45258264mr97688pfj.1.1690903213191; Tue,
 01 Aug 2023 08:20:13 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:19:57 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-2-jingzhangos@google.com>
Subject: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
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
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm64/include/uapi/asm/kvm.h | 25 +++++++++++++++
 arch/arm64/kvm/arm.c              |  3 ++
 arch/arm64/kvm/sys_regs.c         | 51 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 83 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d3dd05bbfe23..3996a3707f4e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			       struct kvm_arm_copy_mte_tags *copy_tags);
 int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 				    struct kvm_arm_counter_offset *offset);
+int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm,
+					       u64 __user *masks);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..2970c0d792ee 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,31 @@ struct kvm_smccc_filter {
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
+struct feature_id_writable_masks {
+	__u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..c9cd14057c58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1630,6 +1630,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 		return kvm_vm_set_attr(kvm, &attr);
 	}
+	case KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS: {
+		return kvm_vm_ioctl_get_feature_id_writable_masks(kvm, argp);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ca2973abe66..d9317b640ba5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3560,6 +3560,57 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
+int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm, u64 __user *masks)
+{
+	/* Wipe the whole thing first */
+	for (int i = 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
+		if (put_user(0, masks + i))
+			return -EFAULT;
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
index f089ab290978..86ffdf134eb8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1555,6 +1555,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS \
+			_IOR(KVMIO,  0xb6, struct feature_id_writable_masks)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.41.0.585.gd2178a4bd4-goog

