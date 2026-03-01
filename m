Return-Path: <kvm+bounces-72304-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AGpLtuZo2kwIAUAu9opvQ
	(envelope-from <kvm+bounces-72304-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:43:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EFD1CB7B9
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 02:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 547183054B92
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C697C2DC350;
	Sun,  1 Mar 2026 01:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpkIhPNI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E3382899;
	Sun,  1 Mar 2026 01:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329254; cv=none; b=uyAReRua9T1ERqZ/qYzq4A0O4l7P7kdnymBcbeVHIVgD6rCrMr8IARJEBXgLMbZS7MZH2rnqX4YmoE8ap5vjrVoIG8tgLX/ElJNTSJAc9t055apr/6dRnOzpXKZSS2VZCVRrdCJ3wRZRCBVtdn3GKJphiA5pZ7CZIGPsmmeJANU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329254; c=relaxed/simple;
	bh=K0h5u0+9bt+IYO+4kCHg5th4UH55uH2vPs9AEvltGoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iI369pZbDg9AFqDl+fm14AreoLCWpju5F0+eTeyL3d4UtYz1iEFYnDbxMrHkrVS3dBsyVaYQuueBeUYN4NYcJuFluulpZ/pNzBTx142f2DCom1UjjoLg9jwBbj1r5RHt/z4rXzZ+XETBAAPd5szBXRZxqA4wB5KVVhgMOeZoBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpkIhPNI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B461C19421;
	Sun,  1 Mar 2026 01:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329253;
	bh=K0h5u0+9bt+IYO+4kCHg5th4UH55uH2vPs9AEvltGoA=;
	h=From:To:Cc:Subject:Date:From;
	b=dpkIhPNIQ5UY20sAKnDfbDGh/n+kUupNACHDZRDQ+Uoc4QYAr3pGUQ6/Ltcdc2aVW
	 EBnfiy9s7CfU+xcFfKhd3t1RA78ZaJUpEhWHN+OVGFSJluxMQbLQ2aYggPbyy0pHBw
	 oYmA5TgXASrhJq7M29iyQDvbb/vfrQOJdzo1LgP/P925g3tCgiMT8M8JI2WHT7504X
	 Q8OG2unjqKWii8z5tOlpAdZice34bsqdvPTUZ30GkyVhV2fkzk17CYopAzVQfJJBy+
	 dvd9ybzd9BJ2y5oU6I3GllEk1ZALciMv+DvQAJGMU3fTxUaXO963XGoP9WZHyj1V4A
	 l9FvqV/FkzlGw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	seanjc@google.com
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3() succeeding" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:40:52 -0500
Message-ID: <20260301014052.1702275-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72304-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,msgid.link:url]
X-Rspamd-Queue-Id: 61EFD1CB7B9
X-Rspamd-Action: no action

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From fc3ba56385d03501eb582e4b86691ba378e556f9 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 16 Dec 2025 08:17:54 -0800
Subject: [PATCH] KVM: nSVM: Remove a user-triggerable WARN on
 nested_svm_load_cr3() succeeding

Drop the WARN in svm_set_nested_state() on nested_svm_load_cr3() failing
as it is trivially easy to trigger from userspace by modifying CPUID after
loading CR3.  E.g. modifying the state restoration selftest like so:

  --- tools/testing/selftests/kvm/x86/state_test.c
  +++ tools/testing/selftests/kvm/x86/state_test.c
  @@ -280,7 +280,16 @@ int main(int argc, char *argv[])

                 /* Restore state in a new VM.  */
                  vcpu = vm_recreate_with_one_vcpu(vm);
  -               vcpu_load_state(vcpu, state);
  +
  +               if (stage == 4) {
  +                       state->sregs.cr3 = BIT(44);
  +                       vcpu_load_state(vcpu, state);
  +
  +                       vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, 36);
  +                       __vcpu_nested_state_set(vcpu, &state->nested);
  +               } else {
  +                       vcpu_load_state(vcpu, state);
  +               }

                  /*
                   * Restore XSAVE state in a dummy vCPU, first without doing

generates:

  WARNING: CPU: 30 PID: 938 at arch/x86/kvm/svm/nested.c:1877 svm_set_nested_state+0x34a/0x360 [kvm_amd]
  Modules linked in: kvm_amd kvm irqbypass [last unloaded: kvm]
  CPU: 30 UID: 1000 PID: 938 Comm: state_test Tainted: G        W           6.18.0-rc7-58e10b63777d-next-vm
  Tainted: [W]=WARN
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:svm_set_nested_state+0x34a/0x360 [kvm_amd]
  Call Trace:
   <TASK>
   kvm_arch_vcpu_ioctl+0xf33/0x1700 [kvm]
   kvm_vcpu_ioctl+0x4e6/0x8f0 [kvm]
   __x64_sys_ioctl+0x8f/0xd0
   do_syscall_64+0x61/0xad0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Simply delete the WARN instead of trying to prevent userspace from shoving
"illegal" state into CR3.  For better or worse, KVM's ABI allows userspace
to set CPUID after SREGS, and vice versa, and KVM is very permissive when
it comes to guest CPUID.  I.e. attempting to enforce the virtual CPU model
when setting CPUID could break userspace.  Given that the WARN doesn't
provide any meaningful protection for KVM or benefit for userspace, simply
drop it even though the odds of breaking userspace are minuscule.

Opportunistically delete a spurious newline.

Fixes: b222b0b88162 ("KVM: nSVM: refactor the CR3 reload on migration")
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251216161755.1775409-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372b..9be67040e94d9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1870,10 +1870,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * thus MMU might not be initialized correctly.
 	 * Set it again to fix this.
 	 */
-
 	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
 				  nested_npt_enabled(svm), false);
-	if (WARN_ON_ONCE(ret))
+	if (ret)
 		goto out_free;
 
 	svm->nested.force_msr_bitmap_recalc = true;
-- 
2.51.0





