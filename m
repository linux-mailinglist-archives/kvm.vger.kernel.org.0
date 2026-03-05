Return-Path: <kvm+bounces-72959-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHW1NwsEqmliJgEAu9opvQ
	(envelope-from <kvm+bounces-72959-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:30:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C68C218EA4
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3D7730FF29C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99930365A02;
	Thu,  5 Mar 2026 22:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSj/KVfw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D86364E89
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749626; cv=none; b=DT35Aq9vF/XUv8u7ZU9f1RNMJb47PXDZ/2R7UApi+EiboiryoQiKKjKTAdhF8r//iW8vvqk4WY58s+YO1nBMjy/tygegbmzkOJ+cEtVbYolFLUOxh7vJqiurD0HeGjOx8P6Bxdc5ISaRIqsGrC4BI7958RFCO61PTtiGPxCmOiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749626; c=relaxed/simple;
	bh=QYpfE9Bp+VZ43WxgiWmgZ8DPxnJQhn/XjQ9FpmT4AHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pkm47WlpXm028gcPtN7fom3RMYMJjWNYOcKdp2SpKEyNp3oLSUJDoq8L+WMf5J6dmwizHu41fZYytcwev1YyaaHw31DalbeOyYPlHwiGO3LAcYIa4VPAwUBWnTIy6XAvY1V2ZCSYZ8gV6pfTx4KwQ0IBR+FOi03BEaN65VPk1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSj/KVfw; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d194b631d6so71337767a34.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772749621; x=1773354421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwFpu8D3VQ5vH2ngB7YkgvdL0e7mIaS+4lfFZO8V8nI=;
        b=cSj/KVfwaguuIYi0WT+WmKj8d4s1DQVE+2B7PbSKx202YY+PkK5SmDOYeqdQAIQeM3
         2OIXFbX8jZIp/jUyjV13T9nQa8KaNGM8LeWVdBmRwD3wWLt/+v5yiaMEh7h0ZngYh3z4
         f0wp6d9YDBSMUskUAzT42VjViWDFvoeOJzuRydGe0pSzi8bv0g+ULg08/MNQFqzot2lB
         3glIvBSLPtxrW7S8fRcJFOb7SimrMl5Ip9Q7x6w+yiUwBtk1BWG5Ad8Rot9hAcLLrWjk
         Na4ejN0LcPcyMhgM07r1xbcMtAGJh9nGKRFGe1Laa6uhNIi6Cgogkm6wa6TsAwYB45Fl
         P3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772749621; x=1773354421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwFpu8D3VQ5vH2ngB7YkgvdL0e7mIaS+4lfFZO8V8nI=;
        b=Aw5NVgI25+ngz8kc+VvjLgK/h0oljYutdbxtOvskiB+pB+ScmoLRdGKYluoyDGDQbf
         fcvBoui1Dy3PsxHXBX9O3SYJyyZ7boQViNm3JULtoa54vsOUkN8wxiqgmku00wPZCXRs
         ROHsaybQ2wOtJPfROJJKoUsFhJt9+GFhSgDUIZ89ULL2VdJo2hL8h9m3jYnTcxB3C9YR
         h7jnLlYmakcflMNzNVJrEFv8kgqRLXvHOFhggP+NHDQp77AWwtNMbrLfECXvzPajKhXi
         TyfJT1HG6YjrM9hFghimeiee0Bo/n20+I59F3A6LsAQVAdfY3TlOA/jMvpGkm33FY9C6
         qN9w==
X-Forwarded-Encrypted: i=1; AJvYcCVixch112EhVPK2mLhw3JNMHtg7niY+n5NV51npe3JM0OiMG3wfrClazwvo5MpmsC5BCSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOdO8KZDF2zXm0gdhV7MejsdemoULJgGqyEoLuo4Wq/CpaP7eG
	dAt2KbZ8v6lgTYKvvjGin77e7Tbv/akLZgWYlAdQG97irinkEcYXNC3jrYby6AK38FvLKuldhlm
	t3g==
X-Received: from jagg2-n2.prod.google.com ([2002:a05:6638:c702:20b0:5ce:ce5a:92a8])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:179b:b0:67a:4fe9:a4b0
 with SMTP id 006d021491bc7-67b9bc6ad75mr110144eaf.15.1772749620561; Thu, 05
 Mar 2026 14:27:00 -0800 (PST)
Date: Thu,  5 Mar 2026 22:26:27 +0000
In-Reply-To: <20260305222627.4193305-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260305222627.4193305-1-sagis@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260305222627.4193305-3-sagis@google.com>
Subject: [PATCH v4 2/2] KVM: SEV: Restrict userspace return codes for KVM_HC_MAP_GPA_RANGE
From: Sagi Shahar <sagis@google.com>
To: Vishal Annapurve <vannapurve@google.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3C68C218EA4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72959-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

To align with the updated TDX api that allows userspace to request
that guests retry MAP_GPA operations, make sure that userspace is only
returning EINVAL or EAGAIN as possible error codes.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f9c1aa39a0a..04076262f087 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3718,9 +3718,13 @@ static int snp_rmptable_psmash(kvm_pfn_t pfn)
 
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
+	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (vcpu->run->hypercall.ret)
+	if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
+		return -EINVAL;
+
+	if (hypercall_ret)
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 	else
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
@@ -3811,10 +3815,14 @@ static void __snp_complete_one_psc(struct vcpu_svm *svm)
 
 static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
 {
+	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
-	if (vcpu->run->hypercall.ret) {
+	if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
+		return -EINVAL;
+
+	if (hypercall_ret) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1; /* resume guest */
 	}
-- 
2.53.0.473.g4a7958ca14-goog


