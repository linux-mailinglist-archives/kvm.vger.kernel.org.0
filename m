Return-Path: <kvm+bounces-72311-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CF7BHsaro2myJgUAu9opvQ
	(envelope-from <kvm+bounces-72311-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 04:00:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D55CC1CE200
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 04:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2424C33E1765
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06733309F1C;
	Sun,  1 Mar 2026 01:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxkZgl2G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A47C2D838A;
	Sun,  1 Mar 2026 01:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329751; cv=none; b=HMl2OWpWWjAxllK7NFr6ShmDZRVyWsljkSI/O2D6eXVIkhVR14rcs57xjXoPewOPvG59Bc3hcBdPftz2E3UKo+4Sgc3K50RWkhijNM5yLN0hN/S3QEPS1RZjLroRGH1HtaWzQG0sT9qDksVnVBVFouP72aSP6sHexBRdvTp6J2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329751; c=relaxed/simple;
	bh=Crm2DzV5ZRLDP0lpvNgwHhx72Dh443SKSFzyDVBju4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GA4ZBwssQcV8/4R9JRnVHBgzHzrgI04NSUCQwHA7vMa0Cum7T9yBNXW8jhSvpsdE/1hUycXXKRTiIINm6wr0Lms2lh8JTMls99c2xhbXO9S5ru66+d19zpi02yMhi++E0WALxw7k9BiCUQ6e+b6y9shFMU9KVzB0In6qpUbK6lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxkZgl2G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B7AC2BCAF;
	Sun,  1 Mar 2026 01:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329750;
	bh=Crm2DzV5ZRLDP0lpvNgwHhx72Dh443SKSFzyDVBju4c=;
	h=From:To:Cc:Subject:Date:From;
	b=QxkZgl2GZHnrH9f9pE/n9S4nb0SGvJeRoHuL3oHqDLXWohrqYUfVSd+LY2VqbaU/1
	 5sxpPMMT7E73ayLu1R3QvZPAd8VCD2sqkL+yoLZo7/+XeWYnRVVh41JbmSins8/SSR
	 bM8AD83cwtx3ZDv9v9wsmrC7TLzPp718d7SLJLICtZlsVzK3IO4X0fcowMTQNt1qxZ
	 WPZqFPX7jPbPHjfAo9aGKOM7OfRvpbitCqaX9n7T/kbjm5zL8jGbFLOiCLSJoorLns
	 Sd7y491lzZPtbb50lyCXvKxZ7CPNb3A4jmHEQgu6fxQjpEwc6Tp1dtlcDZpdLe7HoT
	 CG51rbxKtvI+g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	seanjc@google.com
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3() succeeding" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:49:09 -0500
Message-ID: <20260301014909.1713524-1-sashal@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72311-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: D55CC1CE200
X-Rspamd-Action: no action

The patch below does not apply to the 5.15-stable tree.
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





