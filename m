Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069DBA133B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfH2IHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:07:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37754 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfH2IHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:07:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so1180413pgp.4
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 01:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=qbBqBGkJckcqB1diCJCu40l11ZpHBIyCgWcgtxo7+nc=;
        b=frfz1jt1HA0isGha/PigMoovrg8vW5zqo1fACN5baGYvpvRfnq/RVyi/IXVSNIUQWf
         sglTWL+kQCRV5rDj1HRyLPf73GrnlBDODZFz3oDkzJDtnoqSbNMfS+H/6cOET5onB1Se
         qbbJj67nJKHouwyi0RBV5ACC59kA19qYTew04txX9PM55PCr1+Yt7E1dKC4t9g54Dtxn
         r9SmsT3UA7ogEu27vPzm7N1HuJcSAXK78zVV2MeVfyTgt8pK1Blg9Or7Iizl6TnEVBkM
         RtC3jWcoiHrTNvUwMtORQzmxpDFMqaIYgz+9+g4zNDuBRJnUKqUPsjdF4eJXyFu9WiP+
         yXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=qbBqBGkJckcqB1diCJCu40l11ZpHBIyCgWcgtxo7+nc=;
        b=ndl1AoWkt/xa7xlYIPrsQurjXy1SJcbttdbNQHE4t/ZF9HWmFJjydTOgLvpQDut+83
         ZQxnio1Gmr8/Ce0Zbg8NeNjdLZttPusEgMLjEHVwuKno86xpUgz3c85dE85H1R2CPhHA
         0hGjVAHfhRsP3UsT9AVgO6vmA9piJwQXNBg2L1hvtPmxrMbas4Ujh8Ro882MrKIkfbgj
         kfRe9KwuewT+Hjn52ewILy1ijnJ2qCPwsbDpwj6knHol4gnz0eqMQrS8a89w95oaJabt
         QKdg8+4mXKZ+t0DpP+Wj0w0tdB17Nx4bAgJJpGZkaPalVqVeqIm6nlqh+4JrDJkmG2xl
         EixA==
X-Gm-Message-State: APjAAAU2rtiCTd/hDpGgSq8EsxAvAiFnibTFJUEicN8C4tXkVT90vK+a
        Mj412nayrUsuyRtZ3aDF1ll8zw==
X-Google-Smtp-Source: APXvYqxnvxTao30nKUlipsXd/D4j4LS4qf8bEV22zSBZB/4dWRBI8PsasqlbNVpz2ra20mYJwvKEUg==
X-Received: by 2002:a63:b10f:: with SMTP id r15mr7039460pgf.230.1567066027598;
        Thu, 29 Aug 2019 01:07:07 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id h17sm1962496pfo.24.2019.08.29.01.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 01:07:06 -0700 (PDT)
Date:   Thu, 29 Aug 2019 01:07:02 -0700
From:   Oliver Upton <oupton@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/7] KVM: nVMX: Use kvm_set_msr to load
 IA32_PERF_GLOBAL_CTRL on vmexit
Message-ID: <20190829080702.GA10002@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-2-oupton@google.com>
 <ed9ae8fc-d4d6-3dde-bac3-3c9068f0fc42@oracle.com>
 <20190829020241.GA186746@google.com>
 <10942c78-eb43-4373-79bb-b0c67a1a8744@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10942c78-eb43-4373-79bb-b0c67a1a8744@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 12:19:21AM -0700, Krish Sadhukhan wrote:
> 
> On 8/28/19 7:02 PM, Oliver Upton wrote:
> > On Wed, Aug 28, 2019 at 06:30:29PM -0700, Krish Sadhukhan wrote:
> > > 
> > > On 08/28/2019 04:41 PM, Oliver Upton wrote:
> > > > The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
> > > > on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
> > > > could cause this value to be overwritten. Instead, call kvm_set_msr()
> > > > which will allow atomic_switch_perf_msrs() to correctly set the values.
> > > > 
> > > > Suggested-by: Jim Mattson <jmattson@google.com>
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >    arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
> > > >    1 file changed, 10 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index ced9fba32598..b0ca34bf4d21 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> > > >    				   struct vmcs12 *vmcs12)
> > > >    {
> > > >    	struct kvm_segment seg;
> > > > +	struct msr_data msr_info;
> > > >    	u32 entry_failure_code;
> > > >    	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
> > > > @@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> > > >    		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
> > > >    		vcpu->arch.pat = vmcs12->host_ia32_pat;
> > > >    	}
> > > > -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> > > > -		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> > > > -			vmcs12->host_ia32_perf_global_ctrl);
> > > > +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> > > > +		msr_info.host_initiated = false;
> > > > +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
> > > > +		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
> > > > +		if (kvm_set_msr(vcpu, &msr_info))
> > > > +			pr_debug_ratelimited(
> > > > +				"%s cannot write MSR (0x%x, 0x%llx)\n",
> > > > +				__func__, msr_info.index, msr_info.data);
> > > > +	}
> > > >    	/* Set L1 segment info according to Intel SDM
> > > >    	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> > > These patches are what I am already working on. I sent the following:
> > > 
> > >          [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of nested
> > > guests
> > >          [PATCH 0/4][kvm-unit-test nVMX]: Test "load
> > > IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
> > > 
> > > a few months back. I got feedback from the alias and am working on v2 which
> > > I will send soon...
> > > 
> > Yes, I saw your previous mail for this feature. I started work on this
> > because of a need for this feature
> I understand. I know that I have been bit late on this...
No worries here! Glad I had a good starting point to go from :-)
> > + mentioned you in the cover letter.
> > However, it would be better to give codeveloper credit with your
> > permission.
> > 
> > May I resend this patchset with a 'Co-Developed-by' tag crediting you?
> 
> Sure. Thank you !

One last thing, need a Signed-off-by tag corresponding to this. Do I
have your permission to do so in the resend?
