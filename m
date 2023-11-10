Return-Path: <kvm+bounces-1399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C58F37E75D7
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B20AB21172
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AC8643;
	Fri, 10 Nov 2023 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iNGqdTwS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360D17F
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:18:25 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDE72D5E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:18:24 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2806501f8efso1569625a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 16:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699575504; x=1700180304; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JDBX34Ax+xCPEejy7csuMsB+4xNqzo0HFpIJ9s7abJ8=;
        b=iNGqdTwS334kCvkpGmB01FdlxQ61ywgdjF5fCNtxQqU43MAfj/xr1kvBT8WQ4VtZx1
         bggRL/qWdVsfZpciqnIN050vwtp/GKzWNH0D96BmNHUDE7hmLtauk9Yi5Lw/yzwANNic
         8Pkomd30z/G1jg2AnTactcLd62ca+//x/OYDlKtmNujkZUK9cwXzumFPM54lJVkMXB2y
         BkXMP2BHx6lnp1X1mjCuVv72byU0nBwoTdoQ0uYbxFvtPWlfpQ4v1JhEAIinlopX5tNT
         8OLwc/bx6SIxDyg1NVliFXWmmSg9QtyvWfVZe4/Mg6xK3h1xK3U701JowNPGax/IMRsm
         m1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699575504; x=1700180304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JDBX34Ax+xCPEejy7csuMsB+4xNqzo0HFpIJ9s7abJ8=;
        b=C3SyiHUyyVuqMXClkbNzqBMJlW/lScr99LaQXKAsaCfN1R4dg8Jmu94Dq2mbfltAyN
         SZywaROk6rW5Bskf/c2ud4sRYevFpcQQV+5wX4EAtlXClTpKhPqT4lGiYtOHymLk+vpG
         62hieYU/tAGJrqDbv8DbqJacLE7ykZP1i7YdGUdkLIYBvRIgthv2WTuluIpYYqEyw9LS
         r0dkB/6Ah10+guPdgrm3ZiEXOGNVbjQLXr9pJdMCjuj6hqFdDcuX6ZSLECDSC5LXhnMj
         KlGp15ZuVxMEnzqMrTiUR2MjITseQSXI2A00NOUtDIwUviKPgmPLiHMMIO1SGZ2EpNR0
         1h+A==
X-Gm-Message-State: AOJu0Yz6y1C54yB+4vdI+Tx++hcuOprPqONKq9PVgk1c3Kb3ipA29CIR
	BMfxXi0kAfN/l0f082Ry1fzV49rdAUo=
X-Google-Smtp-Source: AGHT+IEwtMfwxGAR0B/H7IXPZ3vu/xybKiPnMknwG6Vs4SXQgsDZzBSqz7NL72vzZ/dKNEKuDabRDt2Rgms=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:738e:b0:281:1c2e:9e6c with SMTP id
 j14-20020a17090a738e00b002811c2e9e6cmr829740pjg.5.1699575504122; Thu, 09 Nov
 2023 16:18:24 -0800 (PST)
Date: Thu, 9 Nov 2023 16:18:22 -0800
In-Reply-To: <SA1PR11MB67347A31E38D604FDF2BD606A8AFA@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108183003.5981-1-xin3.li@intel.com> <20231108183003.5981-7-xin3.li@intel.com>
 <ZUyjPtaxOgDQQUwA@chao-email> <SA1PR11MB67347A31E38D604FDF2BD606A8AFA@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZU12zoH8VtcZ_USh@google.com>
Subject: Re: [PATCH v1 06/23] KVM: VMX: Defer enabling FRED MSRs save/load
 until after set CPUID
From: Sean Christopherson <seanjc@google.com>
To: Xin3 Li <xin3.li@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"kys@microsoft.com" <kys@microsoft.com>, "haiyangz@microsoft.com" <haiyangz@microsoft.com>, 
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, Ravi V Shankar <ravi.v.shankar@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, Xin3 Li wrote:
> > >+static void vmx_vcpu_config_fred_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >+{
> > >+	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > >+
> > >+	if (!cpu_feature_enabled(X86_FEATURE_FRED) ||
> > >+	    !guest_cpuid_has(vcpu, X86_FEATURE_FRED))
> > >+		return;
> > >+
> > >+	/* Enable loading guest FRED MSRs from VMCS */
> > >+	vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_FRED);
> > >+
> > >+	/*
> > >+	 * Enable saving guest FRED MSRs into VMCS and loading host FRED MSRs
> > >+	 * from VMCS.
> > >+	 */
> > >+	vm_exit_controls_setbit(vmx,
> > VM_EXIT_ACTIVATE_SECONDARY_CONTROLS);
> > >+	secondary_vm_exit_controls_setbit(vmx,
> > >+					  SECONDARY_VM_EXIT_SAVE_IA32_FRED
> > |
> > >+
> > SECONDARY_VM_EXIT_LOAD_IA32_FRED);
> > 
> > all above vmcs controls need to be cleared if guest doesn't enumerate FRED, see
> > 
> > https://lore.kernel.org/all/ZJYzPn7ipYfO0fLZ@google.com/
> 
> Good point, the user space could set cpuid multiple times...
>  
> > Clearing VM_EXIT_ACTIVATE_SECONDARY_CONTROLS may be problematic when
> > new bits are added to secondary vmcs controls. Why not keep
> > VM_EXIT_ACTIVATE_SECONDARY_CONTROLS always on if it is supported? or you
> > see any perf impact?
> 
> I think it from the other way, why keeps hw loading it on every vmentry
> even if it's not used by a guest?

Oh, yeesh, this is clearing the activation control.  Yeah, NAK to that, just
leave it set.  If it weren't for the fact that there is apparently a metrict ton
of FRED state (I thought the whole point of FRED was to kill off legacy crap like
CPL1 and CPL2 stacks?) _and_ that KVM needs to toggle MSR intercepts, I'd probably
push back on toggling even the FRED controls.

> Different CPUs may implement it in different ways, which we can't assume.

Implement what in a different way?  The VMCS fields and FRED are architectural.
The internal layout of the VMCS is uarch specific, but the encodings and semantics
absolutely cannot change without breaking software.  And if Intel does something
asinine like make a control active-low then we have far, far bigger problems.

> Other features needing it should set it separately, say with a refcount.

Absolutely not.  Unless Intel screwed up the implementation, the cost of leaving
VM_EXIT_ACTIVATE_SECONDARY_CONTROLS set when it's supported shouldn't even be
measurable.

