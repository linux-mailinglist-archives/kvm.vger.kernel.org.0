Return-Path: <kvm+bounces-69011-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AUNB3ezc2liyAAAu9opvQ
	(envelope-from <kvm+bounces-69011-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:44:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7482479283
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB4F8307C517
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA4B2C11DD;
	Fri, 23 Jan 2026 17:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KhaG+DGL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EF326F47D
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769190153; cv=none; b=FX/3YKwh1Bv1ebV0C8HAP1GeE6iUejM4o+0vuWlt3F0ZAP7Yar5iqP6wGOS5FttE6sXyqpoRPsuFNZM1L2KyGkYqPUlgupoEvjKNKofaZtVJrqEivEt7RVc+2p1daI3O6tCghH3ralATkQWSW/9cNPUyXzga2LwNa5Jya76x9lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769190153; c=relaxed/simple;
	bh=pDqjwTznlf7G4jbZbCDrzV5uUZT9Xe21g8FzhaPSO/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GevGK+gD33cj/cNyjK6XHcaKguuYMBzriq53RRuHjCDoLXCy/4sqebHEIi0Bqf7/+cSF+0neXNutZ7PAzfrbD+K3ldMleVg62xczG6CgL7LcdKXRiY6NaSinRc+GSABFp3vsYwBXsotFZcYmK/fc9Pk3CMG8PjruDlvTqrj+eAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KhaG+DGL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0bae9acd4so16768245ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 09:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769190151; x=1769794951; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xslJk3NRPMAES7JTcVbRena/Yn0EFJt/rU4p/+v3QFA=;
        b=KhaG+DGLQeHeiFncGaNZSJr56XmFYORmNuQLBi5P3P3D3rnRfE9HsiI4OksJp/c6uq
         GY5R0AKjL5m9Jf2Wtkk1cPlGS/k4Q9ZidAN5oFO4ClyqnsADG6M6MsO0kkMSwkaJmfQG
         +zTcpOlLY+whV6Qom/rnD3ugq2yXYqnufoue5AUHUdnm+w9wChs88h9RQNTRSByostdJ
         KwqUyqwvubHdCHyI8NtZxUQNsDnMgYdiATFqhG5xIKjGkMv0gTeiTn54jU4pAc9f21XK
         Kr33ZhC/jNxklqh+JA2b69EXlsJOr4IXE9BGGLZimC2DCSRQSGRI40DI6+67RiC8zr4J
         84rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769190151; x=1769794951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xslJk3NRPMAES7JTcVbRena/Yn0EFJt/rU4p/+v3QFA=;
        b=EE13ALFwilHBo/MjIp0pZBFRJ8xPEFm+g6VWkFpyJYFL0iyRuYfCW6RqzDqmEojcrM
         sgcUCTmd20bvt0CK4sKRDTh1DeVhcjnb6TWYkqVTMN0aODUmstcjNZJwUaGHHnDruT50
         ++YR973wWqxTJPDV4beZ5fDfLkBPCOibOXCB6ikyzT+LEAZPal+1X8+nG6OIYMfT6Wvr
         3c1SEXviM7hRL0sdyHEJzvkbK7VIeNwX4CNKF3frd+yNoYGkmNntP+MZjjiXYkc1K2Av
         WM6JtIWEqbUryL+rIbVa8MuBTjGCIbqA52qmTPg9yulA0X//hzwPwxqP7KBNjEsDK7fb
         AkfA==
X-Forwarded-Encrypted: i=1; AJvYcCV0Tt+O7wo45IhzEW0v822sBagfwsNbwqQ5EzlUbiEZZ5su2DvudSJxGpDoq2/niYOaIqY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp5c9HDDI2u9kOJkPqcWvr7LclOCUssIb1Q2BquQXySRUwA+wz
	NoPG0deLPd4ricUo4uhlVE17+nGPXI8P8yJPkjJmm+8OeyORSwHXEJ2rjJmdwh8LoIvBymAfxpZ
	+aNqQqw==
X-Received: from plhx14.prod.google.com ([2002:a17:903:2c0e:b0:29f:23e4:703d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecd1:b0:297:f0a8:e84c
 with SMTP id d9443c01a7336-2a7fe75c2c5mr32609105ad.52.1769190150888; Fri, 23
 Jan 2026 09:42:30 -0800 (PST)
Date: Fri, 23 Jan 2026 09:42:29 -0800
In-Reply-To: <20260115225238.2837449-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115225238.2837449-1-sagis@google.com>
Message-ID: <aXOzBXt4UOuP1Hh7@google.com>
Subject: Re: [PATCH v2] KVM: TDX: Allow userspace to return errors to guest
 for MAPGPA
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>, Michael Roth <michael.roth@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69011-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7482479283
X-Rspamd-Action: no action

+Mike and Tom

On Thu, Jan 15, 2026, Sagi Shahar wrote:
> From: Vishal Annapurve <vannapurve@google.com>
> 
> MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
> of userspace exits until the complete range is handled.
> 
> In some cases userspace VMM might decide to break the MAPGPA operation
> and continue it later. For example: in the case of intrahost migration
> userspace might decide to continue the MAPGPA operation after the
> migration is completed.
> 
> Allow userspace to signal to TDX guests that the MAPGPA operation should
> be retried the next time the guest is scheduled.
> 
> This is potentially a breaking change since if userspace sets
> hypercall.ret to a value other than EBUSY or EINVAL an EINVAL error code
> will be returned to userspace. As of now QEMU never sets hypercall.ret
> to a non-zero value after handling KVM_EXIT_HYPERCALL so this change
> should be safe.
> 
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sagi Shahar <sagis@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2d7a4d52ccfb..9bd4ffbdfecf 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1189,7 +1189,13 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  
>  	if (vcpu->run->hypercall.ret) {
> -		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> +		if (vcpu->run->hypercall.ret == EAGAIN)
> +			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> +		else if (vcpu->run->hypercall.ret == EINVAL)
> +			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> +		else
> +			return -EINVAL;
> +

Because no good deed goes unpunished, please update the KVM_CAP_EXIT_HYPERCALL
section in Documentation/virt/kvm/api.rst.

We also need to give snp_complete_psc_msr() and snp_complete_one_psc() similar
treatment (and update docs accordingly, too).  AFAICT, SNP doesn't have a "retry"
error code, so I think all we can do is restrict userspace to EAGAIN and EINVAL?
(Restricting SNP guests to EINVAL seems like it would create unnecessary pain for
userspace)

E.g. something like this?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f9aad5c1447e..14ad4daefaf7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3732,9 +3732,13 @@ static int snp_rmptable_psmash(kvm_pfn_t pfn)
 
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
+       u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
        struct vcpu_svm *svm = to_svm(vcpu);
 
-       if (vcpu->run->hypercall.ret)
+       if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
+               return -EINVAL;
+
+       if (hypercall_ret)
                set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
        else
                set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
@@ -3825,10 +3829,14 @@ static void __snp_complete_one_psc(struct vcpu_svm *svm)
 
 static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
 {
+       u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
        struct vcpu_svm *svm = to_svm(vcpu);
        struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
-       if (vcpu->run->hypercall.ret) {
+       if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
+               return -EINVAL;
+
+       if (hypercall_ret) {
                snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
                return 1; /* resume guest */
        }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..4aa1edfef698 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1186,10 +1186,19 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
 
 static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 {
+       u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
        struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-       if (vcpu->run->hypercall.ret) {
-               tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+       if (hypercall_ret) {
+               if (hypercall_ret == EAGAIN) {
+                       tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
+               } else if (vcpu->run->hypercall.ret == EINVAL) {
+                       tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+               } else {
+                       WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
+                       return -EINVAL;
+               }
+
                tdx->vp_enter_args.r11 = tdx->map_gpa_next;
                return 1;
        }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..5c2c1924addf 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -706,6 +706,13 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
                         unsigned int port, void *data,  unsigned int count,
                         int in);
 
+static inline bool kvm_is_valid_map_gpa_range_ret(u64 hypercall_ret)
+{
+       return !hypercall_ret ||
+              hypercall_ret == EINVAL ||
+              hypercall_ret == EAGAIN;
+}
+
 static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
 {
        return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);

