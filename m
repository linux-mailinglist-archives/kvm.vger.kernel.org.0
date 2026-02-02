Return-Path: <kvm+bounces-69845-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOivJHyhgGni/wIAu9opvQ
	(envelope-from <kvm+bounces-69845-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:07:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E460CC981
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 14:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2CDD305B2B6
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 13:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9233B366802;
	Mon,  2 Feb 2026 13:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kDVs+ZYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BE2D321B
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 13:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770037517; cv=none; b=pstK5PKjCNLd6ezj9GJ4iS1ePjZYn26XIAg/dvESs2zXSZ+nhleHYkUlh3bFEP6KnorCgRWZVgNAWgxqs5bKP8hFXkGjes9EaX1MhsE5/IcOhFzLWnR2IJaHgL3q1xs6Mrpb2q6KvhGGaQqLJKTmlK/wTzM3aZgJkwrT0/QGxK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770037517; c=relaxed/simple;
	bh=N5ZvmT0iIKACEc12ObQnujbtPmQ6zFf/rwBQv1kZPAc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BVRINMpgSk+ggiOwBWTD7kHM2lelHB7aDEYDgugYp+sZvh20JkbgeWoJk0DAEUvOvSc/kD/Fw7EnZb6NgTR/RjhNw3NhAGMx921L1e29qQBfcOsiz3G2jEAwSQYtqSRQvXP5vktgAdiN3VeX/3VstNVxZTUshEKWY7q3cojZK0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kDVs+ZYJ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-482eec44485so15079395e9.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 05:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770037515; x=1770642315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DaIRa8+hj7hUcUtCLpq5uVaY4q/WBE+WwNIl0Oyop/g=;
        b=kDVs+ZYJR03vB+WSU+jKtLnhoZQ/3IixkFNg/h+dyncgnbKHFkrZ55X48psx1VkMyx
         G6/8QlEaNShVUnAZXYJ2mac6ZHtynIHaTbW9mXA9kPxbmTtcJofpaamSKy4LOosrRQC7
         JPc8WJ3eLPmC2SMZqDs2jdPEpStVNDeMJFV3ORGnbPmftFQ4mSzFjyzNiMG5TnXcNNr6
         d/F8t8ivOKgelxlPT1rIsQjPWNJvsPpJcJZnVajbmGusaN/aowApTdZHsLtzFU1mFlOn
         5bhS2LEudxGZ9BnTqujtqT0B0y/23/cECzePJ3IGyYoDsLCO5wCMbZgueYNedCtoVIHU
         6/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770037515; x=1770642315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DaIRa8+hj7hUcUtCLpq5uVaY4q/WBE+WwNIl0Oyop/g=;
        b=vVeeeqh++gmXIyGX29kDBz6gRPdVEvJP/VLM7nMYeI6Gsfa6YdFhK6IqPG2SR0gHjC
         +nYDhL58ALhkGOWCuTjluUlKyOQOCE2FIWLqrw0tpH+eLyjUq+OqVkpt8MY4bsXXAk7K
         y4mGV+hXXsvyEx2e5+PWDU7Gzvea2GXuLl6Q6LDC/+JuhFE5HgJpgvwgIbUacjx5HY39
         Hre960ahxO2vJvXGSlzapeozrA/3K3g7syLtTniTrhvrbLku+wi0t7BXY0MSt0jIKdzc
         PRSyLYK68PtEeNdu0BJ3rxdGAdz3QLZc8409ymLyqf0PsakcQF7/Vd6tpI6Ufc8bEAIP
         skVg==
X-Gm-Message-State: AOJu0YwRcvOJF1U7N74cR8lbymfvMqTT1uhc+GMTCop7WSgTqdO7lWi+
	BLB8XxEOQCJTUUHSvSsdCAy1gye6c1rtW3iycYARrG+GYBWjpdbq4Q2/gsAB0HwGmrg/HIfj3tm
	00eSF7UjP4BDMmUDxSRwkT4NNdmNbXuc+k6ZdTNNX+vhSUZPE1Apq5vzzSejNqozW5BuccyWUDh
	sSL2BThJqNGjXH/XTjXT9nqxahg+g=
X-Received: from wmnv9.prod.google.com ([2002:a05:600c:4449:b0:477:9976:8214])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a00a:b0:480:69b6:dfed
 with SMTP id 5b1f17b1804b1-482db47d0d1mr157567225e9.24.1770037514308; Mon, 02
 Feb 2026 05:05:14 -0800 (PST)
Date: Mon,  2 Feb 2026 13:04:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202130513.49436-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: nv: Use kvm_phys_size() for VNCR invalidation range
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69845-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[12];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0E460CC981
X-Rspamd-Action: no action

KVM: arm64: nv: Use kvm_phys_size() for VNCR invalidation range

Protected mode uses `pkvm_mappings` of the union inside `struct kvm_pgtable`.
This aliases `ia_bits`, which is used in non-protected mode.

Attempting to use `pgt->ia_bits` in kvm_nested_s2_unmap() and
kvm_nested_s2_wp() results in reading mapping pointers or state as a
shift amount. This triggers a UBSAN shift-out-of-bounds error:

    UBSAN: shift-out-of-bounds in arch/arm64/kvm/nested.c:1127:34
    shift exponent 174565952 is too large for 64-bit type 'unsigned long'
    Call trace:
     __ubsan_handle_shift_out_of_bounds+0x28c/0x2c0
     kvm_nested_s2_unmap+0x228/0x248
     kvm_arch_flush_shadow_memslot+0x98/0xc0
     kvm_set_memslot+0x248/0xce0

Fix this by using kvm_phys_size() to determine the IPA size. This helper
is independent of the software page table representation and works
correctly for both protected and non-protected modes, as it derives the
size directly from VTCR_EL2.

Fixes: 7270cc9157f47 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on Linux 6.19-rc8
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e72..eb9666ba15b4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1108,7 +1108,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
 	}
 
-	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
+	kvm_invalidate_vncr_ipa(kvm, 0, kvm_phys_size(&kvm->arch.mmu));
 }
 
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
@@ -1124,7 +1124,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 	}
 
-	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
+	kvm_invalidate_vncr_ipa(kvm, 0, kvm_phys_size(&kvm->arch.mmu));
 }
 
 void kvm_nested_s2_flush(struct kvm *kvm)

base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.53.0.rc1.225.gd81095ad13-goog


