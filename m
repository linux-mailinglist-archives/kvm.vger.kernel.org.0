Return-Path: <kvm+bounces-5461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B58D822258
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 20:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA3971F23F50
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC58D16404;
	Tue,  2 Jan 2024 19:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jRF0FN1+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB42515EB7
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 19:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28c183f8205so9894899a91.3
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 11:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704225448; x=1704830248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=njEQfqTDOHQ3mkpR7k6hSJp5zE0iqNyPNbquK5SNR0M=;
        b=jRF0FN1+n7OYxeI4urt0nckVd0Sd5gPWACQthoTLXglvIZ0D5iNtaKdyUlFi2IvIOo
         XIQMwSS1xP2LUpcp0crit6GeqI8SBgdaapjPGtOMHWt11bfatEtK8qD4X36tX/o5qSF/
         /Y85IWQcG6qJqQaf43cfRrTmUfnhX6RJHmt8bzaF0Bqui3uSY3jXk3aSbQyVkzCWmgmg
         Hsf5OnRRNLN768LOBt27Nar1/omUq3pPtUpSpUBEMYHhZ9duuwdbn4VYOtl1t4suxw8m
         0vi4E72pRv/Y/dhaHUcWrt3bDd8jyGhFPsRevsEWaPK9nF7zbAqS+vBbPkk9DS0+pk9u
         lRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704225448; x=1704830248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njEQfqTDOHQ3mkpR7k6hSJp5zE0iqNyPNbquK5SNR0M=;
        b=st+OT3FPWYVXGn1nWcweeq4TMqSMyJHoVuCT99MLFCErApOFZNCozsuiHdyq2PLM8H
         u9iQDdPx4//d+DgN9YVEC1L/4B6rPIZUP3rod0RKMR7vvL0Mv9hl4lcAvHrGOOvzvrkI
         CF6CXavBiRdf3wjrl/UDRfIwwO18PWjhRq26AEI392ddVbRZznfCYc8wkPpYEZC8wdFO
         68c6NR8ELeHK2skvnlURO6Qf07EaEy2mpa64Sy0OfcQmITKsabEJZZYOoYyufIQwMC9V
         qpHG5ZgBy1+C+9vGRz708Siy4HjqOj+Csbiq//Se8eIV3Qq9GR+r9DzMl1Hfi+lu6iNx
         npWA==
X-Gm-Message-State: AOJu0YwYe6j9hXvrfoL9/MCs07QLpq62+tI6pyXKrDBSsMj+L9sAoiaK
	uofpHduVSyFl1yptStG9i1We4Xt40laJlsueBA==
X-Google-Smtp-Source: AGHT+IGuhjA01z4TN9JTlkEmlpyR3sMUEKJHAX1bgmdEw+wKMeoNbZ9BP5KroeMd81uY2oVB5AwC5p7d2k8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:86c7:b0:28c:59d:843a with SMTP id
 y7-20020a17090a86c700b0028c059d843amr1587931pjv.7.1704225448034; Tue, 02 Jan
 2024 11:57:28 -0800 (PST)
Date: Tue, 2 Jan 2024 11:57:26 -0800
In-Reply-To: <20231222164543.918037-1-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231222164543.918037-1-michal.wilczynski@intel.com>
Message-ID: <ZZRqptOaukCb7rO_@google.com>
Subject: Re: [PATCH v1] KVM: nVMX: Fix handling triple fault on RSM instruction
From: Sean Christopherson <seanjc@google.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhi.a.wang@intel.com, 
	artem.bityutskiy@linux.intel.com, yuan.yao@intel.com, 
	Zheyu Ma <zheyuma97@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+Maxim

On Fri, Dec 22, 2023, Michal Wilczynski wrote:
> Syzkaller found a warning triggered in nested_vmx_vmexit().
> vmx->nested.nested_run_pending is non-zero, even though we're in
> nested_vmx_vmexit(). Generally, trying  to cancel a pending entry is
> considered a bug. However in this particular scenario, the kernel
> behavior seems correct.
> 
> Syzkaller scenario:
> 1) Set up VCPU's
> 2) Run some code with KVM_RUN in L2 as a nested guest
> 3) Return from KVM_RUN
> 4) Inject KVM_SMI into the VCPU
> 5) Change the EFER register with KVM_SET_SREGS to value 0x2501
> 6) Run some code on the VCPU using KVM_RUN
> 7) Observe following behavior:
> 
> kvm_smm_transition: vcpu 0: entering SMM, smbase 0x30000
> kvm_entry: vcpu 0, rip 0x8000
> kvm_entry: vcpu 0, rip 0x8000
> kvm_entry: vcpu 0, rip 0x8002
> kvm_smm_transition: vcpu 0: leaving SMM, smbase 0x30000
> kvm_nested_vmenter: rip: 0x0000000000008002 vmcs: 0x0000000000007000
>                     nested_rip: 0x0000000000000000 int_ctl: 0x00000000
> 		    event_inj: 0x00000000 nested_ept=n guest
> 		    cr3: 0x0000000000002000
> kvm_nested_vmexit_inject: reason: TRIPLE_FAULT ext_inf1: 0x0000000000000000
>                           ext_inf2: 0x0000000000000000 ext_int: 0x00000000
> 			  ext_int_err: 0x00000000
> 
> What happened here is an SMI was injected immediately and the handler was
> called at address 0x8000; all is good. Later, an RSM instruction is
> executed in an emulator to return to the nested VM. em_rsm() is called,
> which leads to emulator_leave_smm(). A part of this function calls VMX/SVM
> callback, in this case vmx_leave_smm(). It attempts to set up a pending
> reentry to guest VM by calling nested_vmx_enter_non_root_mode() and sets
> vmx->nested.nested_run_pending to one. Unfortunately, later in
> emulator_leave_smm(), rsm_load_state_64() fails to write invalid EFER to
> the MSR. This results in em_rsm() calling triple_fault callback. At this
> point it's clear that the KVM should call the vmexit, but
> vmx->nested.nested_run_pending is left set to 1. To fix this reset the
> vmx->nested.nested_run_pending flag in triple_fault handler.
> 
> TL;DR (courtesy of Yuan Yao)
> Clear nested_run_pending in case of RSM failure on return from L2 SMM.

KVM doesn't emulate SMM for L2.  On an injected SMI, KVM forces a syntethic nested
VM-Exit to get from L2 to L1, and then emulates SMM in the context of L1.

> The pending VMENTRY to L2 should be cancelled due to such failure leads
> to triple fault which should be injected to L1.
> 
> Possible alternative approach:
> While the proposed approach works, the concern is that it would be
> simpler, and more readable to cancel the nested_run_pending in em_rsm().
> This would, however, require introducing new callback e.g,
> post_leave_smm(), that would cancel nested_run_pending in case of a
> failure to resume from SMM.
> 
> Additionally, while the proposed code fixes VMX specific issue, SVM also
> might suffer from similar problem as it also uses it's own
> nested_run_pending variable.
> 
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com

Fixes: 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM")

> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..44432e19eea6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4904,7 +4904,16 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  
>  static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
>  	kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
> +	/* In case of a triple fault, cancel the nested reentry. This may occur

	/*
	 * Multi-line comments should look like this.  Blah blah blab blah blah
	 * blah blah blah blah.
	 */

> +	 * when the RSM instruction fails while attempting to restore the state
> +	 * from SMRAM.
> +	 */
> +	vmx->nested.nested_run_pending = 0;

Argh.  KVM's handling of SMIs while L2 is active is complete garbage.  As explained
by the comment in vmx_enter_smm(), the L2<->SMM transitions should have a completely
custom flow and not piggyback/usurp nested VM-Exit/VM-Entry.

	/*
	 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
	 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
	 * SMI and RSM only modify state that is saved and restored via SMRAM.
	 * E.g. most MSRs are left untouched, but many are modified by VM-Exit
	 * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
	 */

The Fixes: commit above added a hack on top of the hack.  But it's not entirely
clear from the changelog exactly what was being fixed.

    While RSM induced VM entries are not full VM entries,
    they still need to be followed by actual VM entry to complete it,
    unlike setting the nested state.
    
    This patch fixes boot of hyperv and SMM enabled
    windows VM running nested on KVM, which fail due
    to this issue combined with lack of dirty bit setting.

My first guess would be event injection, but that shouldn't be relevant to RSM.
Architecturally, events (SMIs, NMIs, IRQs, etc.) are recognized at instruction
boundaries, but except for SMIs (see below), KVM naturally defers injection until
an instruction boundary by virtue of delivering events via the VMCS/VMCB, i.e. by
waiting to deliver events until successfully re-entering the guest.

Nested VM-Enter is a special snowflake because KVM needs to finish injecting events
from vmcs12 before injecting any synthetic events, i.e. nested_run_pending ensures
that KVM wouldn't clobber/override an L2 event coming from L1.  In other words,
nested_run_pending is much more specific than just needing to wait for an instruction
boundary.

So while the "wait until the CPU is at an instruction boundary" applies to RSM,
it's not immediately obvious to me why setting nested_run_pending is necessary.
And setting nested_run_pending *after* calling nested_vmx_enter_non_root_mode()
is nasty.  nested_vmx_enter_non_root_mode() and its helpers use nested_run_pending
to determine whether or not to enforce various consistency checks and other
behaviors.  And a more minor issue is that stat.nested_run will be incorrectly
incremented.

As a stop gap, something like this patch is not awful, though I would strongly
prefer to be more precise and not clear it on all triple faults.  We've had KVM
bugs where KVM prematurely synthesizes triple fault on an actual nested VM-Enter,
and those would be covered up by this fix.

But due to nested_run_pending being (unnecessarily) buried in vendor structs, it
might actually be easier to do a cleaner fix.  E.g. add yet another flag to track
that a hardware VM-Enter needs to be completed in order to complete instruction
emulation.

And as alluded to above, there's another bug lurking.  Events that are *emulated*
by KVM must not be emulated until KVM knows the vCPU is at an instruction boundary.
Specifically, enter_smm() shouldn't be invoked while KVM is in the middle of
instruction emulation (even if "emulation" is just setting registers and skipping
the instruction).  Theoretically, that could be fixed by honoring the existing
at_instruction_boundary flag for SMIs, but that'd be a rather large change and
at_instruction_boundary is nowhere near accurate enough to use right now.

Anyways, before we do anything, I'd like to get Maxim's input on what exactly was
addressed by 759cbd59674a.

