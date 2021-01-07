Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2490B2ED617
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbhAGRxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:53:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbhAGRxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 12:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610041906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkDwbK8IfmJF0Hr3Qh558ED/UuHRGCr75d2VK7D/Q/s=;
        b=ZcSqUrhCvLVFNRIQNDW+TpGgJ9YdiXfwSBHjzzqgLt0akTsdCHJfxlMtdXCWNlqu6WT4Mw
        xiEI/qssExLYTYxqiGuEOBtK98hKHmfxHbLl6ghiFeCvu7gscir7RBPOIAC7OE6Fz0fvWw
        mGYHuV3rej/xZwzTkki6gl8Y9aPE79c=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-ZaBi9Gk0NAaJAGAeiSLOnQ-1; Thu, 07 Jan 2021 12:51:45 -0500
X-MC-Unique: ZaBi9Gk0NAaJAGAeiSLOnQ-1
Received: by mail-ej1-f70.google.com with SMTP id k3so2666085ejr.16
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 09:51:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OkDwbK8IfmJF0Hr3Qh558ED/UuHRGCr75d2VK7D/Q/s=;
        b=BQBRDAeuU6JVw/eLWpBuTxc7XLMD7XG7WQL4fqJIRupmbbJvgqb0zatFegD8m4jwbb
         GZt1bkSGDlyknyJsPUr/P+uQBFfOHvDysrGEkfC6h827jWRCRLvbPq0+Vxfhj09G/v49
         SNLTWelsShERqCl0QHy5YTv3FJi3xhDA15SHXpnkuQJz24lnpS8cSHaAM9crqK3dq9wP
         K0Ra7EXMVdsRsl3dy598noDLQVq8m5zhotgAoxnAbmS4AzyPXnQSmmAvx4ieJ/02tmsy
         A/A0Ggt1FoM4wzgilnihsPB2dd+pRIjVvJs1qeTHCRpXjGwYFnTGprtIN4Y6DUBZgt6g
         6m5Q==
X-Gm-Message-State: AOAM532JzccpgXl8PgMw1Nas8OuQm+e4bop1MPPN3I4Cb+TT3bL8uwhH
        3jcBE7J9v2IAQkZLhOd3suiu1O5oIzFy2OhjbTN//nTqtzxTq8L85L9hY6z3q1EZtDGDW7X31ZV
        3AGnsQd9Sw/oT
X-Received: by 2002:aa7:c1c6:: with SMTP id d6mr2479095edp.275.1610041903719;
        Thu, 07 Jan 2021 09:51:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxN/p5/M7sj/WcIDyEcNEVUJOA95N29zcxUhH2LnQL60mF6K3LnmeFxFKqOoK++QenuSVjG9w==
X-Received: by 2002:aa7:c1c6:: with SMTP id d6mr2479087edp.275.1610041903539;
        Thu, 07 Jan 2021 09:51:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lr24sm2688040ejb.41.2021.01.07.09.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 09:51:42 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-2-mlevitsk@redhat.com> <X/c+FzXGfk/3LUC2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/4] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
 on nested vmexit
Message-ID: <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
Date:   Thu, 7 Jan 2021 18:51:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/c+FzXGfk/3LUC2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 18:00, Sean Christopherson wrote:
> Ugh, I assume this is due to one of the "premature" nested_ops->check_events()
> calls that are necessitated by the event mess?  I'm guessing kvm_vcpu_running()
> is the culprit?
> 
> If my assumption is correct, this bug affects nVMX as well.

Yes, though it may be latent.  For SVM it was until we started 
allocating svm->nested on demand.

> Rather than clear the request blindly on any nested VM-Exit, what
> about something like the following?

I think your patch is overkill, KVM_REQ_GET_NESTED_STATE_PAGES is only 
set from KVM_SET_NESTED_STATE so it cannot happen while the VM runs.

Something like this is small enough and works well.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a622e63739b4..cb4c6ee10029 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -595,6 +596,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
  	svm->nested.vmcb12_gpa = 0;
  	WARN_ON_ONCE(svm->nested.nested_run_pending);

+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, &svm->vcpu);
+
  	/* in case we halted in L2 */
  	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e2f26564a12d..0fbb46990dfc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4442,6 +4442,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 
vm_exit_reason,
  	/* trying to cancel vmlaunch/vmresume is a bug */
  	WARN_ON_ONCE(vmx->nested.nested_run_pending);

+	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
  	/* Service the TLB flush request for L2 before switching to L1. */
  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
  		kvm_vcpu_flush_tlb_current(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..b7e784b5489c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8789,7 +8789,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)

  	if (kvm_request_pending(vcpu)) {
  		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
+			if (WARN_ON_ONCE(!is_guest_mode(&svm->vcpu)))
+				;
+			else if 
(unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
  				r = 0;
  				goto out;
  			}

