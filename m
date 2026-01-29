Return-Path: <kvm+bounces-69491-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEJ+I/K3emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69491-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:29:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DB9AAC2F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A85E630B26C9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3E6378801;
	Thu, 29 Jan 2026 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="paUTCwqr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB50A3783B1
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649405; cv=none; b=IF7TLPbKWSI1BUwWKTelEiGsc7OInEHywZNjdSfPCKpEOKnHAgeNTkEQfTduj4N2qM9QgHKA0WUVlmaR4qKVcB3YIxe9QjEEbbb9rI5cyJzMdXKWMC/dYCiilhNmWlPhGF7WdhqwRwow+hFIGNBaPx0gI7x6vTPVN1hgyjwaaEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649405; c=relaxed/simple;
	bh=MaC+fCO7g1By3J/qOTxfjL/79GFuNBOpVwOO27+9vUE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aCsIDCjq39uobUoMrhalHk/yZ+kMicr88vCR0XalMWecPnym24Q5xWn2LmMTYLtaD6uav1k/L1sKYiy7+15TvgRCXqJp9ip3Ii8/Wf6uS8fQJG3CurglkE9m2iyoUmSM1o5p+R9wQhqJv989fifqna/sqGER3jxlPmHf+zCsZxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=paUTCwqr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352b6ad49ddso282171a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649403; x=1770254203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cCcD265cxmmVZ0UcKWxh2iCOGhqGhkNB0SavdcofzbU=;
        b=paUTCwqrRbNpS5BvaZ6238ym2ADiolbeNS1rSuK054wMak7iMmC1rXWvCnG8ev0i0w
         aYKDDEPuhgw+qKX9KFqVBqrPwXcDdjdoeykarvB2wBrXlSrkCLgsu6erZlSB9esCY3CZ
         rRwAH7nDRTjMY7c5ywdofRy/dWHaVbXu4F4E3EkVryzQl5ZpCLOJCzj1rrsDmYOB2dYG
         FfqRMOks6IJf07V1mlzoQ+K3MJP5aF0f4N1gC1N8rrJuoxa5Cfkj27VrH+BpJ2NqR+/S
         RgIUPS+nObnt2zGR1UOE5VRGqhIgQlC7apuCkr2WgFjCVFBvfUQlebx6YoB5G+IazjwH
         FQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649403; x=1770254203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cCcD265cxmmVZ0UcKWxh2iCOGhqGhkNB0SavdcofzbU=;
        b=AhkfUCeZZRqmaJTqJ46LOMV5hIVKFpvPXid9mNbI86TBSSxFL+jfeTrZy8g2/nPR56
         utPr5sd1bQlr/z//g+6PnxJQQ5e9t/xk5kpVC6qKrRoMDqECfvtjxfnVyI2dx90rr+lt
         OK9sjwB47DCsUvLPk7jkEi0Ej3PI16i8FOwzLctNUFBg518IynE8tlFS8VcBzODiJNmf
         +eE6sJ+f0dHM1v0HrxOQO2WPRiddCcFkWjGTyPZvSgSGStjputM9ZPev7GFqEKsxTCvf
         uMEOvARwfejlYoEouuG+ZcX9xeHkYuGN8DwOm5lkcHoGeAZtYPxWKOOgUSbZnEHrb3Kv
         QOSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxkV9b0/+EF+gqEVgF4EcqgWk7w3umMzkoRsisPq8s6vAipD2PEC8slpW9f+YORmgsJy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFoRiXYT0J7Zd49rGrxR+nT86NPYqB1DwL41WmA2cauZwiUdHo
	P5E68SxXd2UeJZwKOMtcOtqiM4h4JqLZD6pBCBkxYCQLksEfs2VMhxF2qg7svpADMK0rB6u+9Gh
	9cC0IZw==
X-Received: from pjbbf7.prod.google.com ([2002:a17:90b:b07:b0:34a:b3a0:78b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d008:b0:32d:e780:e9d5
 with SMTP id 98e67ed59e1d1-353fed6ebffmr5150167a91.22.1769649403000; Wed, 28
 Jan 2026 17:16:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:12 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-41-seanjc@google.com>
Subject: [RFC PATCH v5 40/45] KVM: x86: Introduce hugepage_set_guest_inhibit()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69491-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 12DB9AAC2F
X-Rspamd-Action: no action

From: Yan Zhao <yan.y.zhao@intel.com>

TDX requires guests to accept S-EPT mappings created by the host KVM. Due
to the current implementation of the TDX module, if a guest accepts a GFN
at a lower level after KVM maps it at a higher level, the TDX module will
emulate an EPT violation VMExit to KVM instead of returning a size mismatch
error to the guest. If KVM fails to perform page splitting in the VMExit
handler, the guest's accept operation will be triggered again upon
re-entering the guest, causing a repeated EPT violation VMExit.

To facilitate passing the guest's accept level information to the KVM MMU
core and to prevent the repeated mapping of a GFN at different levels due
to different accept levels specified by different vCPUs, introduce the
interface hugepage_set_guest_inhibit(). This interface specifies across
vCPUs that mapping at a certain level is inhibited from the guest.

Intentionally don't provide an API to clear KVM_LPAGE_GUEST_INHIBIT_FLAG
for the time being, as detecting that it's ok to (re)install a hugepage is
tricky (and costly if KVM wants to be 100% accurate), and KVM doesn't
currently support hugepage promotion (only direct installation of
hugepages) for S-EPT.

As a result, the only scenario where clearing the flag would likely allow
KVM to install a hugepage is when an entire 2MiB / 1GiB range is converted
to shared or private.  But if the guest is accepting at 4KiB granulairty,
odds are good the guest is using the memory for something "special" and
will never convert the entire range to shared (and/or back to private).
Punt that optimization to the future, if it's ever needed.

Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com [1]
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: explain *why* the flag is never cleared]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h     |  4 ++++
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 830f46145692..fa6a8daf4b05 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -322,4 +322,8 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn & kvm_gfn_direct_bits(kvm);
 }
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 45650f70eeab..c2765bfc8492 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -718,12 +718,14 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
 }
 
 /*
- * The most significant bit in disallow_lpage tracks whether or not memory
- * attributes are mixed, i.e. not identical for all gfns at the current level.
+ * The most 2 significant bits in disallow_lpage tracks whether or not memory
+ * attributes are mixed, i.e. not identical for all gfns at the current level,
+ * or whether or not guest inhibits the current level of hugepage at the gfn.
  * The lower order bits are used to refcount other cases where a hugepage is
  * disallowed, e.g. if KVM has shadow a page table at the gfn.
  */
 #define KVM_LPAGE_MIXED_FLAG	BIT(31)
+#define KVM_LPAGE_GUEST_INHIBIT_FLAG   BIT(30)
 
 static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 					    gfn_t gfn, int count)
@@ -736,7 +738,8 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 
 		old = linfo->disallow_lpage;
 		linfo->disallow_lpage += count;
-		WARN_ON_ONCE((old ^ linfo->disallow_lpage) & KVM_LPAGE_MIXED_FLAG);
+		WARN_ON_ONCE((old ^ linfo->disallow_lpage) &
+			     (KVM_LPAGE_MIXED_FLAG | KVM_LPAGE_GUEST_INHIBIT_FLAG));
 	}
 }
 
@@ -1648,6 +1651,18 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(hugepage_test_guest_inhibit);
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(hugepage_set_guest_inhibit);
+
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
-- 
2.53.0.rc1.217.geba53bf80e-goog


