Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FE5446C54
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 05:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhKFEay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Nov 2021 00:30:54 -0400
Received: from mout.gmx.net ([212.227.15.15]:45077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhKFEax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Nov 2021 00:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1636172870;
        bh=YZMVXFKTkjVrz80ezlaRYsqRt3UuPX6gr5RD1dEt9lE=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:In-Reply-To:References;
        b=V4U9AmwbWaIQURzNt7tBuj/aWnLEtI1n3fd5s9Og44TY1Jj2RQjsakUMo6A+cHsx1
         ZgLfrfakljXG6EaYqFTh2MALYdNlmNG4FYGW2HScI0HitzJlle1Yu1/sD22LTGaPJe
         j0OseXwV+G69tqDLTxLLozuXoKzDZuWcDmVeA4Oc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [127.0.0.1] ([88.152.144.157]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MuDc7-1mTCYa46SD-00uZ4n; Sat, 06
 Nov 2021 05:27:50 +0100
Date:   Sat, 06 Nov 2021 05:27:51 +0100
From:   Heinrich Schuchardt <xypron.glpk@gmx.de>
To:     Atish Patra <atish.patra@wdc.com>, linux-kernel@vger.kernel.org
CC:     Anup Patel <anup.patel@wdc.com>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/5=5D_RISC-V=3A_KVM=3A_Mark_?= =?US-ASCII?Q?the_existing_SBI_implementation_as_v01?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20211105235852.3011900-2-atish.patra@wdc.com>
References: <20211105235852.3011900-1-atish.patra@wdc.com> <20211105235852.3011900-2-atish.patra@wdc.com>
Message-ID: <DF82A93F-50CD-4A68-A8A6-0056E6248172@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ojJ5yr2d53Qu0JOZb+BzZFolZzHoY1m1khS9Ubejetc8WNJN4Gv
 WrivTCg5A5UkGNfUD+aZBPA221FPlfmuO94kQ8ixDDx+CK0/mXSwIdVTZ5UcSLkgHfLcoD1
 zaxHZ9L7on6PGRuBEyBewbejqFje/mxETSOxgHvfmxorPLt/Zqx9/xU3Bonv5QgZlC0KdPe
 C6rF2DIWkrjGY9JOAwVOw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q2YHUv3cTng=:bfsfNK5xRLXCDTjTkSYwq8
 Be+jfAX2zX4f1eFLWE4jYDUGWg/8nCATmHs9hSGjuwc7b/UqN9iT70vrvjMQ9KH2T72EAeYNE
 okzqEU5SU6xBuST46q+g7PWYdZTu30KuLc2LhKaEoLku8yi2UMzQkpdPf8LI3ymG+XtRoURyL
 JXIt2fb/th6af3Kf0yK17f5a7oCVoSvuCwVjETgWC++TD4zBbhZwqdxLpeuNlttthoDI/TCLb
 xEf79NL/pF5K80JrccGcrT3pEHfsMG2CA0CfCVLn8/GIBK8YHqviGxA9egC7ABQfpMYHUzax7
 1q8qul2PEGveahhSaeNe/pwXA1zUaYUQ+K78HtrJxOBB4XlUpp+F7tvrtHBoHOyzbf/Y850CW
 OlQb5LrJypcGNefw0ac6+FID9nZiC4YoqlSz6+AGgGubAiEt31lm/hb7E/M3FNdd7sedHPqmS
 jiXS8GR4ceBTA1E30dEK8cIiSEURBPI9FlNoWkS4EKEdXPAeDvF945p9L0KS9qawbZlh1JAjR
 K3NRnpvrm2UQeNE1lrjYsuvRKkq4YYjgwpN2XfUVWz+jK5XAjqkmA+ZtE6vL2owF0aaOwiNjU
 fVVa7BRfd0krKFN3E+aIbm1HscHRPS0Ea/T9t0hiyUFPtiKGe+qAN6Ex1rYfaVF5gbUa+6EHh
 yNycoYDu6k+tz06Bw07UcJMLE7clZiaRS1l4sBD9OBy+hcOzZdec0YUbNo4/IxO+IXZEB+di6
 rqOucbZ3KDDI/X/UurqQw1DPWVlnzzdQ7mgHsOsYhJp9cHMatOB5HlrCpgm7biSxgcOP4UsGb
 OJzuhzCWkKpJnGNdBfz6/0jKw6vEojnKel4KnfidFMlGodZi4HoRUWTn4P3A7pB0lLDKdbiPF
 4RREPRL5/FtyxEMKnkbkNeK58YUKY8/1u1bSec1aizx/ZfalERhSjoKtkOr7R9/81MfzD+SGB
 9PRcJbEhdqC13sWB9ih6Y8I6RUgCqZNyFWpG4kvisZEGGtbIunzoY21s7qMLEAfSQCyxNeKQm
 jO1LwTT3gsH4QcJy9jsV7kXvh/qRKB8v8tLL5Hg1ifvQwePM7cHzFsVtpcTZrHvfQ+QJFT/II
 7dwcYadydN3WY4=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 6=2E November 2021 00:58:48 MEZ schrieb Atish Patra <atish=2Epatra@wdc=
=2Ecom>:
>The existing SBI specification impelementation follows v0=2E1
>specification=2E The latest specification known as v0=2E2 allows more
>scalability and performance improvements=2E

Isn't 0=2E3 the current SBI specification version?

Especially the system reset extension would be valuable for KVM=2E

(This is not meant to stop merging this patch series=2E)

Best regards

Heinrich


>
>Rename the existing implementation as v01 and provide a way to allow
>future extensions=2E
>
>Signed-off-by: Atish Patra <atish=2Epatra@wdc=2Ecom>
>---
> arch/riscv/include/asm/kvm_vcpu_sbi=2Eh |  29 +++++
> arch/riscv/kvm/vcpu_sbi=2Ec             | 147 +++++++++++++++++++++-----
> 2 files changed, 147 insertions(+), 29 deletions(-)
> create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi=2Eh
>
>diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi=2Eh b/arch/riscv/include=
/asm/kvm_vcpu_sbi=2Eh
>new file mode 100644
>index 000000000000=2E=2E1a4cb0db2d0b
>--- /dev/null
>+++ b/arch/riscv/include/asm/kvm_vcpu_sbi=2Eh
>@@ -0,0 +1,29 @@
>+/* SPDX-License-Identifier: GPL-2=2E0-only */
>+/**
>+ * Copyright (c) 2021 Western Digital Corporation or its affiliates=2E
>+ *
>+ * Authors:
>+ *     Atish Patra <atish=2Epatra@wdc=2Ecom>
>+ */
>+
>+#ifndef __RISCV_KVM_VCPU_SBI_H__
>+#define __RISCV_KVM_VCPU_SBI_H__
>+
>+#define KVM_SBI_VERSION_MAJOR 0
>+#define KVM_SBI_VERSION_MINOR 2
>+
>+struct kvm_vcpu_sbi_extension {
>+	unsigned long extid_start;
>+	unsigned long extid_end;
>+	/**
>+	 * SBI extension handler=2E It can be defined for a given extension or =
group of
>+	 * extension=2E But it should always return linux error codes rather th=
an SBI
>+	 * specific error codes=2E
>+	 */
>+	int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
>+		       unsigned long *out_val, struct kvm_cpu_trap *utrap,
>+		       bool *exit);
>+};
>+
>+const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long=
 extid);
>+#endif /* __RISCV_KVM_VCPU_SBI_H__ */
>diff --git a/arch/riscv/kvm/vcpu_sbi=2Ec b/arch/riscv/kvm/vcpu_sbi=2Ec
>index eb3c045edf11=2E=2E05cab5f27eee 100644
>--- a/arch/riscv/kvm/vcpu_sbi=2Ec
>+++ b/arch/riscv/kvm/vcpu_sbi=2Ec
>@@ -12,9 +12,25 @@
> #include <asm/csr=2Eh>
> #include <asm/sbi=2Eh>
> #include <asm/kvm_vcpu_timer=2Eh>
>+#include <asm/kvm_vcpu_sbi=2Eh>
>=20
>-#define SBI_VERSION_MAJOR			0
>-#define SBI_VERSION_MINOR			1
>+static int kvm_linux_err_map_sbi(int err)
>+{
>+	switch (err) {
>+	case 0:
>+		return SBI_SUCCESS;
>+	case -EPERM:
>+		return SBI_ERR_DENIED;
>+	case -EINVAL:
>+		return SBI_ERR_INVALID_PARAM;
>+	case -EFAULT:
>+		return SBI_ERR_INVALID_ADDRESS;
>+	case -EOPNOTSUPP:
>+		return SBI_ERR_NOT_SUPPORTED;
>+	default:
>+		return SBI_ERR_FAILURE;
>+	};
>+}
>=20
> static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
> 				       struct kvm_run *run)
>@@ -72,16 +88,17 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *=
vcpu,
> 	run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
> }
>=20
>-int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>+static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run=
 *run,
>+				      unsigned long *out_val,
>+				      struct kvm_cpu_trap *utrap,
>+				      bool *exit)
> {
> 	ulong hmask;
>-	int i, ret =3D 1;
>+	int i, ret =3D 0;
> 	u64 next_cycle;
> 	struct kvm_vcpu *rvcpu;
>-	bool next_sepc =3D true;
> 	struct cpumask cm, hm;
> 	struct kvm *kvm =3D vcpu->kvm;
>-	struct kvm_cpu_trap utrap =3D { 0 };
> 	struct kvm_cpu_context *cp =3D &vcpu->arch=2Eguest_context;
>=20
> 	if (!cp)
>@@ -95,8 +112,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
> 		 * handled in kernel so we forward these to user-space
> 		 */
> 		kvm_riscv_vcpu_sbi_forward(vcpu, run);
>-		next_sepc =3D false;
>-		ret =3D 0;
>+		*exit =3D true;
> 		break;
> 	case SBI_EXT_0_1_SET_TIMER:
> #if __riscv_xlen =3D=3D 32
>@@ -104,47 +120,42 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu,=
 struct kvm_run *run)
> #else
> 		next_cycle =3D (u64)cp->a0;
> #endif
>-		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
>+		ret =3D kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> 		break;
> 	case SBI_EXT_0_1_CLEAR_IPI:
>-		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
>+		ret =3D kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> 		break;
> 	case SBI_EXT_0_1_SEND_IPI:
> 		if (cp->a0)
> 			hmask =3D kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
>-							   &utrap);
>+							   utrap);
> 		else
> 			hmask =3D (1UL << atomic_read(&kvm->online_vcpus)) - 1;
>-		if (utrap=2Escause) {
>-			utrap=2Esepc =3D cp->sepc;
>-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>-			next_sepc =3D false;
>+		if (utrap->scause)
> 			break;
>-		}
>+
> 		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> 			rvcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, i);
>-			kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
>+			ret =3D kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
>+			if (ret < 0)
>+				break;
> 		}
> 		break;
> 	case SBI_EXT_0_1_SHUTDOWN:
> 		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
>-		next_sepc =3D false;
>-		ret =3D 0;
>+		*exit =3D true;
> 		break;
> 	case SBI_EXT_0_1_REMOTE_FENCE_I:
> 	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> 	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
> 		if (cp->a0)
> 			hmask =3D kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
>-							   &utrap);
>+							   utrap);
> 		else
> 			hmask =3D (1UL << atomic_read(&kvm->online_vcpus)) - 1;
>-		if (utrap=2Escause) {
>-			utrap=2Esepc =3D cp->sepc;
>-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>-			next_sepc =3D false;
>+		if (utrap->scause)
> 			break;
>-		}
>+
> 		cpumask_clear(&cm);
> 		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> 			rvcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, i);
>@@ -154,22 +165,100 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu=
, struct kvm_run *run)
> 		}
> 		riscv_cpuid_to_hartid_mask(&cm, &hm);
> 		if (cp->a7 =3D=3D SBI_EXT_0_1_REMOTE_FENCE_I)
>-			sbi_remote_fence_i(cpumask_bits(&hm));
>+			ret =3D sbi_remote_fence_i(cpumask_bits(&hm));
> 		else if (cp->a7 =3D=3D SBI_EXT_0_1_REMOTE_SFENCE_VMA)
>-			sbi_remote_hfence_vvma(cpumask_bits(&hm),
>+			ret =3D sbi_remote_hfence_vvma(cpumask_bits(&hm),
> 						cp->a1, cp->a2);
> 		else
>-			sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
>+			ret =3D sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> 						cp->a1, cp->a2, cp->a3);
> 		break;
> 	default:
>+		ret =3D -EINVAL;
>+		break;
>+	}
>+
>+	return ret;
>+}
>+
>+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 =3D {
>+	=2Eextid_start =3D SBI_EXT_0_1_SET_TIMER,
>+	=2Eextid_end =3D SBI_EXT_0_1_SHUTDOWN,
>+	=2Ehandler =3D kvm_sbi_ext_v01_handler,
>+};
>+
>+static const struct kvm_vcpu_sbi_extension *sbi_ext[] =3D {
>+	&vcpu_sbi_ext_v01,
>+};
>+
>+const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long=
 extid)
>+{
>+	int i =3D 0;
>+
>+	for (i =3D 0; i < ARRAY_SIZE(sbi_ext); i++) {
>+		if (sbi_ext[i]->extid_start <=3D extid &&
>+		    sbi_ext[i]->extid_end >=3D extid)
>+			return sbi_ext[i];
>+	}
>+
>+	return NULL;
>+}
>+
>+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>+{
>+	int ret =3D 1;
>+	bool next_sepc =3D true;
>+	bool userspace_exit =3D false;
>+	struct kvm_cpu_context *cp =3D &vcpu->arch=2Eguest_context;
>+	const struct kvm_vcpu_sbi_extension *sbi_ext;
>+	struct kvm_cpu_trap utrap =3D { 0 };
>+	unsigned long out_val =3D 0;
>+	bool ext_is_v01 =3D false;
>+
>+	if (!cp)
>+		return -EINVAL;
>+
>+	sbi_ext =3D kvm_vcpu_sbi_find_ext(cp->a7);
>+	if (sbi_ext && sbi_ext->handler) {
>+		if (cp->a7 >=3D SBI_EXT_0_1_SET_TIMER &&
>+		    cp->a7 <=3D SBI_EXT_0_1_SHUTDOWN)
>+			ext_is_v01 =3D true;
>+		ret =3D sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit)=
;
>+	} else {
> 		/* Return error for unsupported SBI calls */
> 		cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
>-		break;
>+		goto ecall_done;
> 	}
>=20
>+	/* Handle special error cases i=2Ee trap, exit or userspace forward */
>+	if (utrap=2Escause) {
>+		/* No need to increment sepc or exit ioctl loop */
>+		ret =3D 1;
>+		utrap=2Esepc =3D cp->sepc;
>+		kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>+		next_sepc =3D false;
>+		goto ecall_done;
>+	}
>+
>+	/* Exit ioctl loop or Propagate the error code the guest */
>+	if (userspace_exit) {
>+		next_sepc =3D false;
>+		ret =3D 0;
>+	} else {
>+		/**
>+		 * SBI extension handler always returns an Linux error code=2E Convert
>+		 * it to the SBI specific error code that can be propagated the SBI
>+		 * caller=2E
>+		 */
>+		ret =3D kvm_linux_err_map_sbi(ret);
>+		cp->a0 =3D ret;
>+		ret =3D 1;
>+	}
>+ecall_done:
> 	if (next_sepc)
> 		cp->sepc +=3D 4;
>+	if (!ext_is_v01)
>+		cp->a1 =3D out_val;
>=20
> 	return ret;
> }

