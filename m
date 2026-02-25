Return-Path: <kvm+bounces-71732-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qB0WGgxPnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71732-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:23:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C275F18E9EC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA74D30CDE9A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0C52550D7;
	Wed, 25 Feb 2026 01:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1idEPnTE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25C1264628
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982459; cv=none; b=FfcC/BpSowN0C1Oh80uysxyNHL9HnIC6t7deQyJ2kFyamj0gt9WO0ypRybQlQboY69TSWmMWH1dcYLerrl9GD5ww/upj09Ciuto9zxxoKxIUwNK+AKGwHv2YVXXnnZCbVbEi1TB1ya/48gEj7On3mFEkuZ+ylpDFRQq3UFK79l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982459; c=relaxed/simple;
	bh=NEXZh6xUltoNADNu/zge14qIqr3iJw1QwwcpMaiHnHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OHm8W0FDskhYGrKn8Z4GMa937AV4HFNbQAduuGqh01FCT1sF9T5n/YVBZ4f3R22KxDVn73w/W5+bMSNHeqWbx5nOBmwA64DMvndaOT9tvgydrRRckcllHfNK19ht5/wYqYGVaw6/WhzPGjFisXbUEnBb3pu+i+PrK5i0tIQVW6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1idEPnTE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2add182f21eso2045255ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982457; x=1772587257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=47Wsj1dtKii3bX7J+O5CZp3t4E2O0GQAfD/mQfvdoX0=;
        b=1idEPnTE7gESp2YjGpbht+zPS2l02rprNBsFR8SmusKZDBW5lbNcSDmSnR43NdW0Mg
         kNmP1qIi+VMc9ZOwo7iwnVlVsod4nIcAbOczmPs1ykvxqAsDIkCTKGDxyJXTIK3fZu6l
         DPfGimbgr7o9oPDKuHBMbFqkLrq6NL2GoRURRY2ZVuWhJVC/3uvk9zMXucptswTCrHZ9
         2vZLaeBxnosd0xTP0I2e+h3oDDLooqZ8Rk6RCPV7jGZxVpF9zgLbbl4LX7NER5FTS1ai
         iWnw08x1D/e3q6z/ts5fk4o7aZj6EwB0psRKD1Rv1q1UWdVoL69WYUSjBLS0TX5bryPC
         6+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982457; x=1772587257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47Wsj1dtKii3bX7J+O5CZp3t4E2O0GQAfD/mQfvdoX0=;
        b=d8uxiC07o0fc9QtQo+Fn00S49NmPIt7zJQeXTJvfS0odi7AIWkeGRXA+yZ5LpqKYGC
         z3Rhx1Dm7m/VPxvDBL0AGtd850fyLOQ6SKxZI5sA+RdnE0wdvlWC2Rkyp5TTvhvGJUGA
         0ISIRSyvrPKgcP9FQvrD46ZQ/vmA6bIjrk6d1vwGqdtPx+3dbJjwPgj5WZSuJ5oC8nNc
         3O0eq07BBPjjJL2HvUQpev+5lJp/2XTzjykyob7/lIT5o0lQWTJuzHyYY2I4gikpoJEr
         /fQ0TDSM/slh6Z4OxGcNX8BFk9BwYBJgZQtgUfocrz1SYe8CcA+NoxDzA4jlpNruS9Dp
         jM+g==
X-Gm-Message-State: AOJu0YxKXb+kgfgCgpLMph1CQifaMMyaUQwTgv01oLmKasBgGXatO1z5
	MFEJ86wC63gJIPCoBzG8xjlcUcez/SQaGcU593sbs/jq+k0pY3QNCG4i0myo6ZWdcI/vtLIQEm2
	ejmeLqQ==
X-Received: from pjvh24.prod.google.com ([2002:a17:90a:db98:b0:359:c21:c138])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2352:b0:2a0:9d16:5fb4
 with SMTP id d9443c01a7336-2add11e8c96mr6365125ad.18.1771982457153; Tue, 24
 Feb 2026 17:20:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:38 -0800
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-4-seanjc@google.com>
Subject: [PATCH 03/14] KVM: x86: Trace unsatisfied MMIO reads on a per-page basis
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71732-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C275F18E9EC
X-Rspamd-Action: no action

Invoke the "unsatisfied MMIO reads" when KVM first detects that a
particular access "chunk" requires an exit to userspace instead of tracing
the entire access at the time KVM initiates the exit to userspace.  I.e.
precisely trace the first and/or second fragments of a page split instead
of tracing the entire access, as the GPA could be wrong on a page split
case.

Leave the completion tracepoint alone, at least for now, as fixing the
completion path would incur significantly complexity to track exactly which
fragment(s) of the overall access actually triggered MMIO, but add a
comment that the tracing for completed reads in is technically wrong.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b1f02cc8196..a74ae3a81076 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7808,6 +7808,9 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 		v += n;
 	} while (len);
 
+	if (len)
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, len, addr, NULL);
+
 	return handled;
 }
 
@@ -8139,7 +8142,6 @@ static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
 static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  void *val, int bytes)
 {
-	trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, bytes, gpa, NULL);
 	return X86EMUL_IO_NEEDED;
 }
 
@@ -8247,6 +8249,11 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 	 * is copied to the correct chunk of the correct operand.
 	 */
 	if (!ops->write && vcpu->mmio_read_completed) {
+		/*
+		 * For simplicity, trace the entire MMIO read in one shot, even
+		 * though the GPA might be incorrect if there are two fragments
+		 * that aren't contiguous in the GPA space.
+		 */
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
 			       vcpu->mmio_fragments[0].gpa, val);
 		vcpu->mmio_read_completed = 0;
-- 
2.53.0.414.gf7e9f6c205-goog


