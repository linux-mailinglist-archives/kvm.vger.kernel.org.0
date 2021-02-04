Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4614330EC20
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 06:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhBDFfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 00:35:47 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:38831 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhBDFfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 00:35:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612416932; x=1643952932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hAGw3mc5c81wiYWE6AxTQ0aXDt7RC+LEa6RwXEaS5ec=;
  b=QusDtWaNKZhTVdbc+poNVDBzP6XdNq8m9pyN1zOWTNvbmADInKLW+Th2
   o8mr59ewYNwbUgVk3UdDc5kUx7zJZb9QHRN13p7UCWG+BSCUPfMkJF6ey
   SvRKJjzliOrK1El2QSmHEJpVKYzu9p4+yn+G5sU1Hvv7UiZMXSbhTAXPE
   I7MUMbT1LQgn3pL/x47PM6/ixcRsIa7UPl3fjjEPHQs721o+okjT4zWEs
   /gyCyTz+gkpnrMpBggTp5UF8gqMxq5nq7KDlgZ0axYC1aqJhUZWm08UY9
   M3/psvITBl738H/rKzwOwhEDkOyHHpwOVO9+mkz0W13VtE4twNa2c48+/
   w==;
IronPort-SDR: Ha8m41EzsbbtAn+2II8esIthTyks8Oc7JngHmyqcl/2CBTvIRg2JdGeV3u8QV0qow3JVISJbna
 VF+1PAe20kSiaqD+s55Kppp1caoRDLQsoggckJtGZDL+zIq4YJz0t35QAGejYQ2OqBLlM1KctB
 E+ZJjqjH6xougCLGryGGWEklUlGywrmJ7pkUdoljp8/Zew7pQbtwVU7PC6WD90zCgJsy6d1YxC
 NzvKjCiZL/PQhu023eOkMfpkwekYojUXzgzp7rL18EXWgWk+M7EbJWqSSjYblSuVo2FuDVzKha
 6aQ=
X-IronPort-AV: E=Sophos;i="5.79,400,1602518400"; 
   d="scan'208";a="159086451"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2021 13:32:55 +0800
IronPort-SDR: amaC/XNSArn65TQ5yCVnsRhLNBsOWBIfHpcsjYrbLZuPNODWJz9f4nX+XRzcSMRniPSaLrBios
 gq9RZc66ImPJeQCEIpIj7kdxoN3kGabCrZAT9t4ixNfrecWpXAX/rqf6OyQwSPwqKPbfI/8Bd4
 6D7Z7g4obpw9rHPy7FSsaMG7vYF+Oy6fu+NL9lGEu/d8aYK34XzEx0J0d0RSpyHuWRIvsUUzk2
 IwjgK76IpmzIoNHi3FeTpk/BS0Y7PjYxhb5NpxCgibbYwiAEdFM7UoDqtAzyTJN0QJEhewQCdX
 6l/R//hmTFP7vVu6iQMaPlWe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 21:16:55 -0800
IronPort-SDR: ObOo8zL6/WOxtdUYwrJVpJCxxHnhG5Dn0G/P4QVyky7k7hnsjmnjgCudZBupjhxWFenHBJO2LW
 d0DKvbeIZ6PLUZE6me+CW57MSnxdogA1bq4NGFVxoKR7n4gOF/FFUZX9L+B6e3XA7Ngwfcc+88
 7nIBqNTgUeeKA98mbcdaT49+2W6mtwDR40xn2jzOt/+9hA+NsFHIfh882MoLxmoXOOVkEoFm4j
 cHNZzj3hmD2AL0J8NgWzM02Nu/izgk9erzRtSP83IW2ADxH5FmTSjYlFUeuTrk5805lFnV/USM
 s8Y=
WDCIronportException: Internal
Received: from cnf008142.ad.shared (HELO jedi-01.hgst.com) ([10.86.63.165])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Feb 2021 21:32:55 -0800
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v2 6/6] RISC-V: Add SBI RESET extension in KVM
Date:   Wed,  3 Feb 2021 21:32:39 -0800
Message-Id: <20210204053239.1609558-7-atish.patra@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204053239.1609558-1-atish.patra@wdc.com>
References: <20210204053239.1609558-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI RESET extension allows OS to initiate a system wide reboot or shutdown.

Implement the SBI RESET extension so that guests can issue shutdown/reset
requests as well.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
 arch/riscv/kvm/vcpu_sbi.c             | 17 +++++++++++
 arch/riscv/kvm/vcpu_sbi_legacy.c      | 17 +----------
 arch/riscv/kvm/vcpu_sbi_replace.c     | 44 +++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index e208c8ac57fe..4f08bb45d8ce 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -29,4 +29,5 @@ struct kvm_vcpu_sbi_extension {
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
+void kvm_sbi_system_event(struct kvm_vcpu *vcpu, struct kvm_run *run, u32 type);
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 20ef59ed83a6..858203b46700 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -38,6 +38,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
 
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_legacy,
@@ -46,8 +47,24 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_ipi,
 	&vcpu_sbi_ext_rfence,
 	&vcpu_sbi_ext_hsm,
+	&vcpu_sbi_ext_srst,
 };
 
+void kvm_sbi_system_event(struct kvm_vcpu *vcpu,
+			  struct kvm_run *run, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off = true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&run->system_event, 0, sizeof(run->system_event));
+	run->system_event.type = type;
+	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
diff --git a/arch/riscv/kvm/vcpu_sbi_legacy.c b/arch/riscv/kvm/vcpu_sbi_legacy.c
index 126d97b1292d..9fd7ea386d5f 100644
--- a/arch/riscv/kvm/vcpu_sbi_legacy.c
+++ b/arch/riscv/kvm/vcpu_sbi_legacy.c
@@ -14,21 +14,6 @@
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_sbi.h>
 
-static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
-				    struct kvm_run *run, u32 type)
-{
-	int i;
-	struct kvm_vcpu *tmp;
-
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
-	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
-
-	memset(&run->system_event, 0, sizeof(run->system_event));
-	run->system_event.type = type;
-	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-}
-
 static int kvm_sbi_ext_legacy_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				      unsigned long *out_val,
 				      struct kvm_cpu_trap *utrap,
@@ -83,7 +68,7 @@ static int kvm_sbi_ext_legacy_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		}
 		break;
 	case SBI_EXT_0_1_SHUTDOWN:
-		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		kvm_sbi_system_event(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
 		*exit = true;
 		break;
 	case SBI_EXT_0_1_REMOTE_FENCE_I:
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index dffb1930cada..7504e36ededb 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -134,3 +134,47 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
 	.extid_end = SBI_EXT_RFENCE,
 	.handler = kvm_sbi_ext_rfence_handler,
 };
+
+static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				      unsigned long *out_val,
+				      struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long reset_type = cp->a0;
+	unsigned long reset_reason = cp->a1;
+	unsigned long funcid = cp->a6;
+
+	if (!cp)
+		return -EINVAL;
+
+	if ((((u32)-1U) <= ((u64)reset_type)) ||
+	    (((u32)-1U) <= ((u64)reset_reason)))
+		return -EINVAL;
+
+	if ((funcid != SBI_EXT_SRST_RESET) ||
+	    (reset_reason > SBI_SRST_RESET_REASON_SYS_FAILURE))
+		ret = -EOPNOTSUPP;
+
+	switch (reset_type) {
+	case SBI_SRST_RESET_TYPE_SHUTDOWN:
+		kvm_sbi_system_event(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		*exit = true;
+		break;
+	case SBI_SRST_RESET_TYPE_COLD_REBOOT:
+	case SBI_SRST_RESET_TYPE_WARM_REBOOT:
+		kvm_sbi_system_event(vcpu, run, KVM_SYSTEM_EVENT_RESET);
+		*exit = true;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	};
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
+	.extid_start = SBI_EXT_SRST,
+	.extid_end = SBI_EXT_SRST,
+	.handler = kvm_sbi_ext_srst_handler,
+};
-- 
2.25.1

