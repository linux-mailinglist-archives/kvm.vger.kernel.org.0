Return-Path: <kvm+bounces-67834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B07AED15519
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97D0A302E706
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5009C3382E8;
	Mon, 12 Jan 2026 20:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aGbwHWhh"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02166310620
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 20:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768251012; cv=none; b=TwFDZUO/VhqTZphoJmMvKfJAAy6cmaZNTZFHbJu1AB02zKmACJ25LD2OlTj+E9TjHTfrR80gewWxUYfne4luq00CdC/HOum1sBoAa9D8p/vdel/cUrBMIctJ4bHipiJkTQhW5ms/awf8zU2Izgn1gcHwXnw/dbRAPJ6sNuy69w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768251012; c=relaxed/simple;
	bh=GKQNqpmikCymvM5A9/GkhsAh3j2xS9pzmsOELyOL/NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A12BZVuAtnwsWm97WVb72jr0uAFLfRhNBnniSvZdU+RysJWZoz9zqLWCgHdXMtdg99PEuIzBLalptwD0LkiaYHuyNjylXuFPPAi8lcYciw6iEqKKMlNeOBo4bt8a/0qPub9N+Gey1t84XFTnDaHG4CQ+wzLUJpdB4UUMY9np35k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aGbwHWhh; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Jan 2026 20:50:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768251008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eXR6DeWduxE3Ysmh46BTNeIJKspct1aGyvEHfN1xGPs=;
	b=aGbwHWhhe00vaZv0yk/SqmgGQcCKz3XJDBFZtazSCQWlp7wfV/VDeZJq3GwmsIlJMlZcZY
	UfRZUbEHzV0uxDy3UX5xfvMxkM5bnRDUGmtCDbSn7Zwi/eibH9OfGP8SoitO3/Gqueo53o
	QFrVpNgyRoiceNqEZ7A3kNrJnzq4MKI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and
 SVM Lock and DEV are not available
Message-ID: <23l6bxew3cbnsgl6zagqz6qqtkb7mwfeqcl4opp2ulk3cu5fmq@hqfnuptmaiti>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-3-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112174535.3132800-3-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 12, 2026 at 05:45:32PM +0000, Kevin Cheng wrote:
> The AMD APM states that STGI causes a #UD if SVM is not enabled and
> neither SVM Lock nor the device exclusion vector (DEV) are supported.

Might be useful to also mention the following part "Support for DEV is
part of the SKINIT architecture".

> Fix the STGI exit handler by injecting #UD when these conditions are
> met.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6373a25d85479..557c84a060fc6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2271,8 +2271,18 @@ static int stgi_interception(struct kvm_vcpu *vcpu)
>  {
>  	int ret;
>  
> -	if (nested_svm_check_permissions(vcpu))
> +	if ((!(vcpu->arch.efer & EFER_SVME) &&
> +	     !guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) &&
> +	     !guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT)) ||
> +	    !is_paging(vcpu)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
> +	}
> +
> +	if (to_svm(vcpu)->vmcb->save.cpl) {
> +		kvm_inject_gp(vcpu, 0);
>  		return 1;
> +	}

Not a big fan of open-coding nested_svm_check_permissions() here. The
checks could get out of sync.

How about refactoring nested_svm_check_permissions() like so:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f295a41ec659..7f53c54b9d39 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1520,9 +1520,10 @@ int nested_svm_exit_handled(struct vcpu_svm *svm)
        return vmexit;
 }

-int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
+static int __nested_svm_check_permissions(struct kvm_vcpu *vcpu,
+                                         bool insn_allowed)
 {
-       if (!(vcpu->arch.efer & EFER_SVME) || !is_paging(vcpu)) {
+       if (!insn_allowed || !is_paging(vcpu)) {
                kvm_queue_exception(vcpu, UD_VECTOR);
                return 1;
        }
@@ -1535,6 +1536,11 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
        return 0;
 }

+int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
+{
+       return __nested_svm_check_permissions(vcpu, vcpu->arch.efer & EFER_SVME);
+}
+
 static bool nested_svm_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector,
                                           u32 error_code)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7041498a8091..6340c4ce323c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2333,9 +2333,19 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)

 static int stgi_interception(struct kvm_vcpu *vcpu)
 {
+       bool insn_allowed;
        int ret;

-       if (nested_svm_check_permissions(vcpu))
+       /*
+        * According to the APM, STGI is allowed even with SVM disabled if SVM
+        * Lock or device exclusion vector (DEV) are supported. DEV is part of
+        * the SKINIT architecture.
+        */
+       insn_allowed = (vcpu->arch.efer & EFER_SVME) ||
+               guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) ||
+               guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT);
+
+       if (__nested_svm_check_permissions(vcpu, insn_allowed))
                return 1;

        ret = kvm_skip_emulated_instruction(vcpu);

---

We may also want to rename nested_svm_check_permissions() to
nested_svm_insn_check_permissions() or something. Sean, WDYT?

>  
>  	ret = kvm_skip_emulated_instruction(vcpu);
>  	svm_set_gif(to_svm(vcpu), true);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

