Return-Path: <kvm+bounces-46487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E20AB68EE
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 148E37AD91F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6052777E5;
	Wed, 14 May 2025 10:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKIW8hJw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788E427510A;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218909; cv=none; b=pMTDlr6XTZklVuodSLc0aJVfAt2CWtTGraB8IfbGlN0EbWTDqnUVd754iOvD/6prtcyLEjun4z7MO/8aJ3477/TsrO7zcYzofBB5hy7H1C56SGEYB8VT5ViVtjlbNdGF0m4Rg8lHCkvm6M6VUehdK5o+tvYjbRDdN25ytKA2n6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218909; c=relaxed/simple;
	bh=vh1PnLqh01yaQsVDCDR6nY6QiSEdl+vmMW6IVytRf4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QkO0wBRKfptL4pH5dX56/0gPLzocS8RQJvAzkIyuYsvXYM/H8cvI9jHC7tbZjgM+7fWyOqYWMNkN4qPNeA3ufIkbLQlgbntWTm10km5NrY6SZdvZu5wKBqXxd3E1X1UDMThvNNnmSUYh9csFh1MXblB95vSlbmhtkvLX9zOf5c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKIW8hJw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5753BC4CEFA;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218909;
	bh=vh1PnLqh01yaQsVDCDR6nY6QiSEdl+vmMW6IVytRf4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKIW8hJwcLKgKdKqARim4AvIqPOa7nkWhKcJaCtk4Q3oD3BP8hhmvoS8u2OgpsgjW
	 Qq2+w9uZTqcKC+TDWO2ETNDNK6EweKvceVyXPUmKEzAy81FK0Vh+LxcpUxIpo0ZEx6
	 M58LBfC9DgWn4ONPECqGjLUPwS7eV5SZewNR2RQ1WUYaHnZT0TUQi8z4LqN7Nh9aMq
	 HMiX3FH/JIp78rZm7/DRT6lUIgIIsIewV7nEQ2Yqs/+DkQaf38PUdQ0V0uT93e0Vz2
	 HVEWPcLRyqw4tQb5YZlyPE7oYGVN+Ez5eE41Sl2U5WSSVqeT2vIqNc/ForbFTSCfqz
	 DrblEr4i4FOQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S7-00Eos3-KQ;
	Wed, 14 May 2025 11:35:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 16/17] KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
Date: Wed, 14 May 2025 11:34:59 +0100
Message-Id: <20250514103501.2225951-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we're (almost) feature complete, let's allow userspace to
request KVM_ARM_VCPU_EL2* by bumping KVM_VCPU_MAX_FEATURES up.

We also now advertise the features to userspace with new capabilities.

It's going to be great...

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/arm.c              | 6 ++++++
 include/uapi/linux/kvm.h          | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b2c535036a06b..79e175a16d356 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 9
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5287435873609..b021ce1e42c5c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -368,6 +368,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
 		break;
+	case KVM_CAP_ARM_EL2:
+		r = cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
+		break;
+	case KVM_CAP_ARM_EL2_E2H0:
+		r = cpus_have_final_cap(ARM64_HAS_HCR_NV1);
+		break;
 	case KVM_CAP_GUEST_DEBUG_HW_BPS:
 		r = get_num_brps();
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b5..c9d4a908976e8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -930,6 +930,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_ARM_EL2 240
+#define KVM_CAP_ARM_EL2_E2H0 241
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.39.2


