Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B114A0F59
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 04:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfH2CCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 22:02:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41693 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfH2CCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 22:02:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so701444pgg.8
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 19:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ts19oFAWduI/Ro+x2B0pw1mI+2dCY8S0OmC9YK4lPVI=;
        b=hHSTbPKW1+Hj8bdJdLqXTiT1yIusbFsZ+zDc3ndvB7OVz6uBZm8R2p7mEHoAYFic3m
         GPyhP8ppWeoE1f5AC19WMasz2ykMjhErnDs721h6C3lzbmMQtZ5/Ns7ucaFHRKweKD52
         OL2H6MeM/nf5Z6dm7IRrAuJkJanfcJkeYXD2zUcE5gSqhc2FRWalbJ6bE8CKIfT4Iz17
         ZcolQWGZ4AuO0P1VLwFLJAMNTWe8zbopp9UIeQYowB/Triol2V0XSmqlg7U078qCcDS2
         r32ORpIFCQJzS2ermXjE37PBce3wUZLTMC6Mgz8PDtSzBDNqYq3hKRmPDxcslZRsJ8jY
         JPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ts19oFAWduI/Ro+x2B0pw1mI+2dCY8S0OmC9YK4lPVI=;
        b=EamI1ErXY4QJT9Gjp/bBDprs9M/LCxAYeCdDn+arRNoldC637c4HrmHp3TlOln1hKa
         No/XVKO0/d3jRG0EFKKSjfy6bcLQeTOHd+1YtebhjH+zn+DPq5hP9vZdSB3pgL7GRa+1
         8eCgn6qEB70W8ntSMVK+meP80s3tuduQ+43v7E4e9F5jUrqfQdkMRayau5K5sxIHazwk
         pEoIzu32/KLVvKd91Dl2o/tWwaKYxyODl89kwWosuSjlOi1XSODZuBZAPTty9ndAGaIW
         +EJ36G9TakCHQBVMh5W5RVYNlpJVrR7EKOADydF7tXW/T/sKIceTo4Ok8gfxlaR1m5U0
         b4Ng==
X-Gm-Message-State: APjAAAUFiZMfnW6KKy7dtfnDbuYMSrknvww0qNpxswi8XzqoKCjXtIOZ
        cBlLluADhJE7nPNgiSPxhgoQ6u5M6E46bTmA
X-Google-Smtp-Source: APXvYqyKuOnbsYm2rgPAWfW3rVmv19m+U8k5sbcPzE4f2yoa65ByrevFgvb5hDFuGtMmhQPuqc1Edg==
X-Received: by 2002:a65:638c:: with SMTP id h12mr5995649pgv.436.1567044165886;
        Wed, 28 Aug 2019 19:02:45 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id 6sm774823pfa.7.2019.08.28.19.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 19:02:45 -0700 (PDT)
Date:   Wed, 28 Aug 2019 19:02:41 -0700
From:   Oliver Upton <oupton@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/7] KVM: nVMX: Use kvm_set_msr to load
 IA32_PERF_GLOBAL_CTRL on vmexit
Message-ID: <20190829020241.GA186746@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-2-oupton@google.com>
 <ed9ae8fc-d4d6-3dde-bac3-3c9068f0fc42@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed9ae8fc-d4d6-3dde-bac3-3c9068f0fc42@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 06:30:29PM -0700, Krish Sadhukhan wrote:
> 
> 
> On 08/28/2019 04:41 PM, Oliver Upton wrote:
> > The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
> > on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
> > could cause this value to be overwritten. Instead, call kvm_set_msr()
> > which will allow atomic_switch_perf_msrs() to correctly set the values.
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >   arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
> >   1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index ced9fba32598..b0ca34bf4d21 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> >   				   struct vmcs12 *vmcs12)
> >   {
> >   	struct kvm_segment seg;
> > +	struct msr_data msr_info;
> >   	u32 entry_failure_code;
> >   	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
> > @@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> >   		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
> >   		vcpu->arch.pat = vmcs12->host_ia32_pat;
> >   	}
> > -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> > -		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> > -			vmcs12->host_ia32_perf_global_ctrl);
> > +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> > +		msr_info.host_initiated = false;
> > +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
> > +		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
> > +		if (kvm_set_msr(vcpu, &msr_info))
> > +			pr_debug_ratelimited(
> > +				"%s cannot write MSR (0x%x, 0x%llx)\n",
> > +				__func__, msr_info.index, msr_info.data);
> > +	}
> >   	/* Set L1 segment info according to Intel SDM
> >   	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> 
> These patches are what I am already working on. I sent the following:
> 
>         [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of nested
> guests
>         [PATCH 0/4][kvm-unit-test nVMX]: Test "load
> IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
> 
> a few months back. I got feedback from the alias and am working on v2 which
> I will send soon...
>
Yes, I saw your previous mail for this feature. I started work on this
because of a need for this feature + mentioned you in the cover letter.
However, it would be better to give codeveloper credit with your
permission.

May I resend this patchset with a 'Co-Developed-by' tag crediting you?
