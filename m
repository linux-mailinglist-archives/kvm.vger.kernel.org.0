Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2165B49CF8A
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbiAZQWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242228AbiAZQWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 11:22:42 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C4FC06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:22:42 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c9so22928463plg.11
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NY+C6y4G8qU1CRk5iVyOeizvQ6wJwLZPr41cAmRlU/c=;
        b=CfvpmP9QFac6WoFtwKmxiy0vyGG7J+8yACLIWAhItxQkVr9dmXBvXrfGh4wIp/BJx9
         G7J1i7jjGzcv9eKBw+vEsZApW2qYJ48RMi/48KhR5KxTUjL9gchGDXBd8RuIPhEhD/Fh
         atl5DyPiQUS3DDgmx7w19GltMar4YMxEZViFS0GowCmxUVf1SPTmhlkTm1m6h3Cio21e
         9tJ1aQsd3e4KCpyrTMuU7MEeptddqv7xjmiKnt3GhsHe0ElEaBZzvbAtx3dxAp236ady
         85YBHXc680x02b4olMXZg1rEz0XAoltIKnM6Mt1XSq14EZFPKYWVm1ypYhy2D7AZov1W
         3WHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NY+C6y4G8qU1CRk5iVyOeizvQ6wJwLZPr41cAmRlU/c=;
        b=Q4Lgg2PS169lbv/FVspewwpkMWj8hSMXAuUKjPbzj9UqCF+ACgVDmBOxOkx/nfhwWG
         gB7HXynJfq6JHewqQbvIAONT1YHTJWf9Gd1lyIrMCsnW3l2mhmPSgdkrm5Bg4TxSru/T
         iKBdX9y8t3xxgtv0ZIUwiC4+yptoISeCHnYPzyYxbIk0SUqqBOe1/GbrsbuFWwKKVufM
         rPquxF6Ej3CTe98BtYwu6ma4vUdQclmnWY/W6JXP3QB63/3extVMCIlMtSeFLCtPKrAU
         yLvQIyeClu0lRD5pVRx2TPSQgnmZnj4kvDOOAVIwotv3LEiFGYDKKIkk1E7dqxelYySK
         7Kxg==
X-Gm-Message-State: AOAM531ggQHNlNdVt0E3v4LmV+UfDKhUpb3WBIhrDf54gvwCSx4DUwgJ
        ll124dKKfwr4NzMBrL1ovNeY+Q==
X-Google-Smtp-Source: ABdhPJxx25mQna4sBuaGXcBDc5b3yuqCFqCXt/w0J615roqibv0gpcKrAJHj0KBiiJYrrTZpJKCh/A==
X-Received: by 2002:a17:90b:1d0a:: with SMTP id on10mr9237096pjb.167.1643214161933;
        Wed, 26 Jan 2022 08:22:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w4sm16932422pgs.28.2022.01.26.08.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:22:41 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:22:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS
 for vmcs02
Message-ID: <YfF1TQx/vsV5OepU@google.com>
References: <20220125220527.2093146-1-seanjc@google.com>
 <87r18uh4of.fsf@redhat.com>
 <053bb241-ea71-abf8-262b-7b452dc49d37@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <053bb241-ea71-abf8-262b-7b452dc49d37@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Paolo Bonzini wrote:
> On 1/26/22 16:56, Vitaly Kuznetsov wrote:
> > > -	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
> > > +	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
> > > +		return loaded_vmcs->shadow_vmcs;
> > Stupid question: why do we want to care about 'loaded_vmcs' at all,
> > i.e. why can't we hardcode 'vmx->vmcs01' in alloc_shadow_vmcs()?

Not a stupid question, I strongly considered doing exactly that, but elected to
keep the WARN only because of the reason Paolo stated below.

> > The only caller is enter_vmx_operation() and AFAIU 'loaded_vmcs' will
> > always be pointing to 'vmx->vmcs01' (as enter_vmx_operation() allocates
> > &vmx->nested.vmcs02 so 'loaded_vmcs' can't point there!).
> > 
> 
> Well, that's why the WARN never happens.  The idea is that if shadow VMCS
> _virtualization_ (not emulation, i.e. running L2 VMREAD/VMWRITE without even
> a vmexit to L0) was supported, then you would need a non-NULL shadow_vmcs in
> vmx->vmcs02.
> 
> Regarding the patch, the old WARN was messy but it was also trying to avoid
> a NULL pointer dereference in the caller.

But the sole caller does:

	if (enable_shadow_vmcs && !alloc_shadow_vmcs(vcpu))
		goto out_shadow_vmcs;

> What about:
> 
> 	if (WARN_ON(loaded_vmcs->shadow_vmcs))
> 		return loaded_vmcs->shadow_vmcs;
> 
> 	/* Go ahead anyway.  */
> 	WARN_ON(loaded_vmcs != &vmx->vmcs01);
> 
> ?

I don't like preceeding, because that will likely lead to a crash and/or WARNs if
KVM call the helper at the right time but with the wrong VMCS loaded, i.e. if
vmcs01.shadow_vmcs is left NULL, as many paths assumes vmcs01 is allocated if they
are reached with VMCS shadowing enabled.  At the very least, it will leak memory
because vmcs02.shadow_vmcs is never freed.

Maybe this to try and clarify things?  Compile tested only...

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Jan 2022 12:14:42 -0800
Subject: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS for
 vmcs02

WARN if KVM attempts to allocate a shadow VMCS for vmcs02 and mark the VM
as dead.  KVM emulates VMCS shadowing but doesn't virtualize it, i.e. KVM
should never allocate a "real" shadow VMCS for L2.  Many downstream flows
assume vmcs01.shadow_vmcs is non-NULL when VMCS shadowing is enabled, and
vmcs02.shadow_vmcs is (rightly) never freed, so continuing on in this
case is dangerous.

Opportunistically return an error code instead of a pointer to make it
more obvious that the helper sets the correct pointer in vmcs01, and that
the return value needs to be checked/handled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f235f77cbc03..ccc10b92a92a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4845,25 +4845,29 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
  * VMCS, unless such a shadow VMCS already exists. The newly allocated
  * VMCS is also VMCLEARed, so that it is ready for use.
  */
-static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
+static int alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct loaded_vmcs *loaded_vmcs = vmx->loaded_vmcs;

 	/*
-	 * We should allocate a shadow vmcs for vmcs01 only when L1
-	 * executes VMXON and free it when L1 executes VMXOFF.
-	 * As it is invalid to execute VMXON twice, we shouldn't reach
-	 * here when vmcs01 already have an allocated shadow vmcs.
+	 * KVM allocates a shadow VMCS only when L1 executes VMXON and frees it
+	 * when L1 executes VMXOFF or the vCPU is forced out of nested
+	 * operation.  VMXON faults if the CPU is already post-VMXON, so it
+	 * should be impossible to already have an allocated shadow VMCS.  KVM
+	 * doesn't support virtualization of VMCS shadowing, so vmcs01 should
+	 * always be the loaded VMCS.
 	 */
-	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
+	if (KVM_BUG_ON(loaded_vmcs != &vmx->vmcs01, vcpu->kvm))
+		return -EIO;

-	if (!loaded_vmcs->shadow_vmcs) {
+	if (!WARN_ON_ONCE(!loaded_vmcs->shadow_vmcs)) {
 		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
 		if (loaded_vmcs->shadow_vmcs)
 			vmcs_clear(loaded_vmcs->shadow_vmcs);
 	}
-	return loaded_vmcs->shadow_vmcs;
+
+	return 0;
 }

 static int enter_vmx_operation(struct kvm_vcpu *vcpu)
@@ -4872,7 +4876,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	int r;

 	r = alloc_loaded_vmcs(&vmx->nested.vmcs02);
-	if (r < 0)
+	if (r)
 		goto out_vmcs02;

 	vmx->nested.cached_vmcs12 = kzalloc(VMCS12_SIZE, GFP_KERNEL_ACCOUNT);
@@ -4881,11 +4885,16 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)

 	vmx->nested.shadow_vmcs12_cache.gpa = INVALID_GPA;
 	vmx->nested.cached_shadow_vmcs12 = kzalloc(VMCS12_SIZE, GFP_KERNEL_ACCOUNT);
-	if (!vmx->nested.cached_shadow_vmcs12)
+	if (!vmx->nested.cached_shadow_vmcs12) {
+		r = -ENOMEM;
 		goto out_cached_shadow_vmcs12;
+	}

-	if (enable_shadow_vmcs && !alloc_shadow_vmcs(vcpu))
-		goto out_shadow_vmcs;
+	if (enable_shadow_vmcs) {
+		r = alloc_shadow_vmcs(vcpu);
+		if (r)
+			goto out_shadow_vmcs;
+	}

 	hrtimer_init(&vmx->nested.preemption_timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS_PINNED);
@@ -4913,7 +4922,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(&vmx->nested.vmcs02);

 out_vmcs02:
-	return -ENOMEM;
+	return r;
 }

 /* Emulate the VMXON instruction. */
--



