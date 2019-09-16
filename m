Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11C9B42DE
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 23:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbfIPVRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 17:17:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37967 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbfIPVRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 17:17:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id x10so704200pgi.5
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 14:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DUEm44CJ4MKeIi+5HtpZQadj3xFULJmnpjD5XuqmloQ=;
        b=KgzW5qxAyMtZJa12o2aGJGsvvNx8f61seMcyiOiN52mP18PFxAv6VNnJOVCdqYKfok
         xAszVeiJDUEuyfOw3Hhclrw0pJ0SEpB3FbScC6rbYw35i/VhJycqKOrpy159TBDO5vAJ
         bxqQxAuIBCuWpAA+DC9G3E7vBv1GhQ+Fe/TNxLf0yAd98D+mOXC/vViehsFdH+0kqSmF
         69qbmrnwk1ESOK1gzRNyayfZlHBprhUxOAEMZ+PXMbyqYanZDcleA6+cz25cOjr6WFa2
         AoKqzkqwSRLOwXEvnZGLZhygfkASCI8BLk6S3Scb2BEkeUKjdc5xgBgIrAGmAYTL4N/u
         zpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DUEm44CJ4MKeIi+5HtpZQadj3xFULJmnpjD5XuqmloQ=;
        b=jTXOl8SIFfATEab9+EKvB2O2XgkeU/R/Q87h56vv2M44d+M3BLkaNbiq/qZ4prwfi3
         SQdQO5SA4aAWmHE2RAg+Cy/mW0EGYOIUOPpvQcoi9Sgj+oCbMvxOMvvJDFA1R7kOqGpH
         tl0zY+DM7CYIWKaFdI4IOppbXSJkYBAENUJ3tQIxzghg1K95XrwbO/q9uOzHWwyADmBd
         RgXeRR4rNXH8lcZADywmV3vBCB0Ka3Y5N85MwJnKhK5EJyQbtE7QEXQ/t98YLK9s7zqE
         LUFP5MRJPu2OB9pcxXlo6ULEtnGmQmSF3FQch5GqJp8y/9xKd0kzTSifG9CgU2QeDOss
         Z+Vw==
X-Gm-Message-State: APjAAAUS/eOeiGJf/aIMyQiWUbonWDX66cL3t/8wGwGRPSAi6Jm1DSh3
        BD7csykyWMgetuDKvMTWv5GMtw==
X-Google-Smtp-Source: APXvYqyRIjlMfj91qphmULZ06gB7ijwvAUv+DkkE8r4gyoTACfmYaFk8KxWc1F66X9jLAQ3Ec8vwpw==
X-Received: by 2002:a17:90a:21a9:: with SMTP id q38mr1271896pjc.23.1568668666871;
        Mon, 16 Sep 2019 14:17:46 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id h14sm20700pfo.15.2019.09.16.14.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 14:17:46 -0700 (PDT)
Date:   Mon, 16 Sep 2019 14:17:42 -0700
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 2/9] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR
 on vm-entry
Message-ID: <20190916211742.GA221782@google.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-3-oupton@google.com>
 <20190916180614.GF18871@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916180614.GF18871@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 11:06:14AM -0700, Sean Christopherson wrote:
> On Fri, Sep 06, 2019 at 02:03:06PM -0700, Oliver Upton wrote:
> > Add condition to prepare_vmcs02 which loads IA32_PERF_GLOBAL_CTRL on
> > VM-entry if the "load IA32_PERF_GLOBAL_CTRL" bit on the VM-entry control
> > is set. Use kvm_set_msr() rather than directly writing to the field to
> > avoid overwrite by atomic_switch_perf_msrs().
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index b0ca34bf4d21..9ba90b38d74b 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2281,6 +2281,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >  	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
> > +	struct msr_data msr_info;
> >  	bool load_guest_pdptrs_vmcs12 = false;
> >  
> >  	if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
> > @@ -2404,6 +2405,16 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> >  	if (!enable_ept)
> >  		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
> >  
> > +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> > +		msr_info.host_initiated = false;
> > +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
> > +		msr_info.data = vmcs12->guest_ia32_perf_global_ctrl;
> > +		if (kvm_set_msr(vcpu, &msr_info))
> > +			pr_debug_ratelimited(
> > +				"%s cannot write MSR (0x%x, 0x%llx)\n",
> > +				__func__, msr_info.index, msr_info.data);
> 
> Same comment on printing the name.  Might be work adding a helper function
> or macro?  That'd also avoid blasting past the 80-column guideline.

Thanks for the review, Sean. I believe that in one of the prior sets I
mailed out you had mentioned a macro for this as well, but was a fix
throughout KVM. Shall I introduce the macro as part of this series, but
only apply it to my changes (and fix other call sites later on)?

> > +	}
> > +
> >  	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
> >  	kvm_rip_write(vcpu, vmcs12->guest_rip);
> >  	return 0;
> > -- 
> > 2.23.0.187.g17f5b7556c-goog
> > 
