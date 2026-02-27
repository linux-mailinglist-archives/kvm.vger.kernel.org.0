Return-Path: <kvm+bounces-72144-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aItWASuKoWnAuAQAu9opvQ
	(envelope-from <kvm+bounces-72144-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:12:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8FB1B6F6E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7AB4305AD6C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BD73A0E97;
	Fri, 27 Feb 2026 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="S74YdDl1"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5CD313E31;
	Fri, 27 Feb 2026 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772194308; cv=none; b=rfs1w36J4hdLOldAH1IHwHFgttaPF648fhu6bGzTZLnm3jFRTaHeXzfS8emEOCCSJZ3NJ3kgUVaCwLE/6ASPve6MAwUQKeOSS14OA8zPjJ62Ng0k+81PTRBqpMiULLrL3P8nTLn2/2WY8uTPCkQkadmz5K6rwjopG9YpYKLwd7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772194308; c=relaxed/simple;
	bh=lUmIH9P06/f8YYDl2R0khEjkKIyf+E/x0FpkPt6xBdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hskuL9yemieDFETo8amJttp+Ut+dpQa3BVlipfQGYmDtMcu4D0iXWwl97dKZG1yUfq9zCGD44TSrNhIf9GY+n/9YzGKCMgtpzYNasLjLsuXJRJPF2F45SUfxF8TIz7NxJGEbN5b7LAkb8JnwRO9Ho/OqcH+cu4Tv5UUcyzJwM9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=S74YdDl1; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=8iDo/0xU8qVfX4Rja6Bpm07m0MbBXBOZXTSs1djqASE=;
	b=S74YdDl1LP2swdSWiTIyHn9qhB6XQquUN9bOWwfW5iczYS6T6Ge4K5z5BD5+0t
	QjzUYQ1Fl7YJt1sZN7oKMbCDBCOv7m/gjuIT/erwbzJDYc9ETXUfRLLklUpR/LSd
	8X4LkshsrZVY0MP8Sj6VM8EM/GCcuhBJ3W9fugBOd4nNs=
Received: from whoami-MS-7D95.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgBHozGjiaFpa3wHQw--.562S2;
	Fri, 27 Feb 2026 20:10:14 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH v7] KVM: riscv: Skip CSR restore if VCPU is reloaded on the same core
Date: Fri, 27 Feb 2026 20:10:08 +0800
Message-ID: <20260227121008.442241-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgBHozGjiaFpa3wHQw--.562S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3WrWxAw1xCFWDury7ur4UArb_yoWxJF1xpF
	W7CFnYgw48Gry3G343Ar4v9r4YgrZYgw13X34UZ3ySyr45try5AFs5KFyUAFyDGFWkZFyS
	yF1DtF10kFn0vaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRdpnQUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/xtbC0AZOxmmhiaai6AAA3z
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[oss.qualcomm.com,brainfault.org,linux.dev,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[163.com];
	TAGGED_FROM(0.00)[bounces-72144-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tjytimi@163.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,163.com];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DKIM_TRACE(0.00)[163.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5A8FB1B6F6E
X-Rspamd-Action: no action

Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs,
HGATP, and AIA state. However, when a VCPU is loaded back on the same
physical CPU, and no other KVM VCPU has run on this CPU since it was
last put, the hardware CSRs and AIA registers are still valid.

This patch optimizes the vcpu_load path by skipping the expensive CSR
and AIA writes if all the following conditions are met:
1. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu == cpu).
2. The CSRs are not dirty (!vcpu->arch.csr_dirty).
3. No other VCPU used this CPU (vcpu == __this_cpu_read(kvm_former_vcpu)).

To ensure this fast-path doesn't break corner cases:
- Live migration and VCPU reset are naturally safe. KVM initializes
  last_exit_cpu to -1, which guarantees the fast-path won't trigger.
- The 'csr_dirty' flag tracks runtime userspace interventions. If
  userspace modifies guest configurations (e.g., hedeleg via
  KVM_SET_GUEST_DEBUG, or CSRs including AIA via KVM_SET_ONE_REG),
  the flag is set to skip the fast path.

With the 'csr_dirty' safeguard proven effective, it is safe to
include kvm_riscv_vcpu_aia_load() inside the skip logic now.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
---
 v6 -> v7:
 - Moved kvm_riscv_vcpu_aia_load() into the fast-path skip logic, as
   suggested by Radim Krčmář.
 - Verified the fix for the IMSIC instability issue reported in v3.
   Testing was conducted on QEMU 10.0.2 with explicitly enabled AIA
   (`-machine virt,aia=aplic-imsic`). The guest boots successfully 
   using virtio-mmio devices like virtio-blk and virtio-net.

 v5 -> v6:
 As suggested by Andrew Jones, checking 'last_exit_cpu' first (most
 likely to fail on busy hosts) and placing the expensive
 __this_cpu_read() last, skipping __this_cpu_write() in kvm_arch_vcpu_put()
 if kvm_former_vcpu is already set to the current VCPU.

 v4 -> v5:
 - Dropped the 'vcpu->scheduled_out' check as Andrew Jones pointed out,
   relying on 'last_exit_cpu', 'former_vcpu', and '!csr_dirty'
   is sufficient and safe. This expands the optimization to cover many
   userspace exits (e.g., MMIO) as well.
 - Added a block comment in kvm_arch_vcpu_load() to warn future
   developers about maintaining the 'csr_dirty' dependency, as Andrew's
   suggestion to reduce fragility.
 - Removed unnecessary single-line comments and fixed indentation nits.

 v3 -> v4:
 - Addressed Anup Patel's review regarding hardware state inconsistency.
 - Introduced 'csr_dirty' flag to track dynamic userspace CSR/CONFIG
   modifications (KVM_SET_ONE_REG, KVM_SET_GUEST_DEBUG), forcing a full
   restore when debugging or modifying states at userspace.
 - Kept kvm_riscv_vcpu_aia_load() out of the skip block to resolve IMSIC
   VS-file instability.

 v2 -> v3:
 v2 was missing a critical check because I generated the patch from my
 wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.

 v1 -> v2:
 Apply the logic to aia csr load. Thanks for Andrew Jones's advice.
---
 arch/riscv/include/asm/kvm_host.h |  3 +++
 arch/riscv/kvm/vcpu.c             | 24 ++++++++++++++++++++++--
 arch/riscv/kvm/vcpu_onereg.c      |  2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 24585304c..7ee47b83c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -273,6 +273,9 @@ struct kvm_vcpu_arch {
 	/* 'static' configurations which are set only once */
 	struct kvm_vcpu_config cfg;
 
+	/* Indicates modified guest CSRs */
+	bool csr_dirty;
+
 	/* SBI steal-time accounting */
 	struct {
 		gpa_t shmem;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index a55a95da5..2e4dfff07 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -24,6 +24,8 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
@@ -537,6 +539,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 		vcpu->arch.cfg.hedeleg |= BIT(EXC_BREAKPOINT);
 	}
 
+	vcpu->arch.csr_dirty = true;
+
 	return 0;
 }
 
@@ -581,6 +585,21 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	/*
+	 * If VCPU is being reloaded on the same physical CPU and no
+	 * other KVM VCPU has run on this CPU since it was last put,
+	 * we can skip the expensive CSR and HGATP writes.
+	 *
+	 * Note: If a new CSR is added to this fast-path skip block,
+	 * make sure that 'csr_dirty' is set to true in any
+	 * ioctl (e.g., KVM_SET_ONE_REG) that modifies it.
+	 */
+	if (vcpu != __this_cpu_read(kvm_former_vcpu))
+		__this_cpu_write(kvm_former_vcpu, vcpu);
+	else if (vcpu->arch.last_exit_cpu == cpu && !vcpu->arch.csr_dirty)
+		goto csr_restore_done;
+
+	vcpu->arch.csr_dirty = false;
 	if (kvm_riscv_nacl_sync_csr_available()) {
 		nsh = nacl_shmem();
 		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
@@ -624,6 +643,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_mmu_update_hgatp(vcpu);
 
+	kvm_riscv_vcpu_aia_load(vcpu, cpu);
+
+csr_restore_done:
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
 	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
@@ -633,8 +655,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
 					    vcpu->arch.isa);
 
-	kvm_riscv_vcpu_aia_load(vcpu, cpu);
-
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
 	vcpu->cpu = cpu;
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index e7ab6cb00..fc08bf833 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -652,6 +652,8 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	if (rc)
 		return rc;
 
+	vcpu->arch.csr_dirty = true;
+
 	return 0;
 }
 
-- 
2.43.0


