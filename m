Return-Path: <kvm+bounces-5760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59253825CFA
	for <lists+kvm@lfdr.de>; Sat,  6 Jan 2024 00:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE7DF284C09
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB75360B0;
	Fri,  5 Jan 2024 23:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhghbr+s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BA036091
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 23:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-28cbd4aaf29so61499a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 15:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704495914; x=1705100714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eRvWPDCG4JAZwBNK/6G5GN/cR0tx6Hok+T3LJaZP40Y=;
        b=dhghbr+s/EyCX2tjONOYAoxmW7JmbqwbBmnY1/KB1UFBry35gTQzxVOe6K+gELbazp
         a84ZngirZPY6jir7RsODN8p9jCl1na6NO03obzaxZBV04D/v5v/E1620X8dIJqA9T+kj
         e332/vW81rArpfQ7ERNo16briM+Loxyda1Pp8Vzr5LmEUnf/bgtVBxFKWyTckbi50JWV
         llRqZP9/tg2mC6Y2YTEZBaegV0o0b8Gf5hasYJ0dOgRA7VJlioW5eK1mLViHIwNARu6M
         fP3sBaxO+DnAZEE5VOHKMZRuuaCADMvBhgPgqhBDqApgJ/JxU0CBGPavcV/eYqIs1IKZ
         T+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704495914; x=1705100714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eRvWPDCG4JAZwBNK/6G5GN/cR0tx6Hok+T3LJaZP40Y=;
        b=VnSJKK8TPWA0fdglR6Ni4sI9RoojLLyC+XICPnkyVosxgTxKO0u0e+99YZDTKmhaYT
         T40jwcY+1Qy9JdEqwgQ4H8kAGfV0BYAs+UedS6Kk2GgyFRGaEvbUHnkTjDjE6IdFRgO9
         8r4o27HB0WJZk9gXZmdp8Y6PTTCLHmPh2Uq700q9vnBfuViI69jSfVyuscUiz9yvwfbb
         oJJtUpLvvvtt3IQ7wKwIF8A43v0wHJ72HuLqopQYwDHVYmC1k6Py7OfaddfzSvkbsInP
         crosv9Q7pDMwHa2TchQTFQLscjMHDYqCcaLwG9eJyF4GSBySVo1lTd52csS7Lry3a/LF
         fcAw==
X-Gm-Message-State: AOJu0YxRy0y59YY8Dlsx6QAOjksywvp2kjbJVUnHVHQM8CkqA4YbdCQ0
	zkzp8BeHepa3LUUH050dfrrlaxvZyKVRJfjRUw==
X-Google-Smtp-Source: AGHT+IF/JJByZNwRSzKYk26DF9evJInmWnBhl5gImcO/3d/1Jq4H8t2sm5XmXOpBcIdrUVDpFHDJkzxEV2w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b82:b0:28b:7cfa:a8c with SMTP id
 pc2-20020a17090b3b8200b0028b7cfa0a8cmr1255pjb.2.1704495913633; Fri, 05 Jan
 2024 15:05:13 -0800 (PST)
Date: Fri, 5 Jan 2024 15:05:12 -0800
In-Reply-To: <7ca4b7af33646e3f5693472b4394ba0179b550e1.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1699368322.git.isaku.yamahata@intel.com> <7ca4b7af33646e3f5693472b4394ba0179b550e1.1699368322.git.isaku.yamahata@intel.com>
Message-ID: <ZZiLKKobVcmvrPmb@google.com>
Subject: Re: [PATCH v17 092/116] KVM: TDX: Handle TDX PV HLT hypercall
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 07, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire up TDX PV HLT hypercall to the KVM backend function.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h |  3 +++
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3a1fe74b95c3..4e48989d364f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -662,7 +662,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  {
> -	return pi_has_pending_interrupt(vcpu);
> +	bool ret = pi_has_pending_interrupt(vcpu);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> +		return true;
> +
> +	if (tdx->interrupt_disabled_hlt)
> +		return false;
> +
> +	/*
> +	 * This is for the case where the virtual interrupt is recognized,
> +	 * i.e. set in vmcs.RVI, between the STI and "HLT".  KVM doesn't have
> +	 * access to RVI and the interrupt is no longer in the PID (because it
> +	 * was "recognized".  It doesn't get delivered in the guest because the
> +	 * TDCALL completes before interrupts are enabled.
> +	 *
> +	 * TDX modules sets RVI while in an STI interrupt shadow.
> +	 * - TDExit(typically TDG.VP.VMCALL<HLT>) from the guest to TDX module.
> +	 *   The interrupt shadow at this point is gone.
> +	 * - It knows that there is an interrupt that can be delivered
> +	 *   (RVI > PPR && EFLAGS.IF=1, the other conditions of 29.2.2 don't
> +	 *    matter)
> +	 * - It forwards the TDExit nevertheless, to a clueless hypervisor that
> +	 *   has no way to glean either RVI or PPR.

WTF.  Seriously, what in the absolute hell is going on.  I reported this internally
four ***YEARS*** ago.  This is not some obscure theoretical edge case, this is core
functionality and it's completely broken garbage.

NAK.  Hard NAK.  Fix the TDX module, full stop.

Even worse, TDX 1.5 apparently _already_ has the necessary logic for dealing with
interrupts that are pending in RVI when handling NESTED VM-Enter.  Really!?!?!
Y'all went and added nested virtualization support of some kind, but can't find
the time to get the basics right?

