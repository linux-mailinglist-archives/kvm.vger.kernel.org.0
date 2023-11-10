Return-Path: <kvm+bounces-1490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A67B67E7D3E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 16:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD379B20EF5
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 15:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF471C6AA;
	Fri, 10 Nov 2023 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7g6Dehc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436FE19BD7
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:02:03 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC353A214
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 07:02:01 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-28035cf4306so2913873a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 07:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699628521; x=1700233321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mUJOBd/q/zD8P/9fxYVqe+7Mn835Ht5oRjEbFlzm6ss=;
        b=d7g6DehcfOXh0WImbji5j74arnOzVM1VpJbGkEfOo9q9ZAPDuQoC3TLLZPEzqJwtte
         bKm4LRgj0uCjtVy+rcSEurq81Ss5rC0eH/0244wO0RBAgA8bnAN8RyeE9ZpVaUc9Lcny
         OBho8P6xf/1gfwIEsWX6KRy7vhS1pMXU8q1tP3whCuljMLxGrVGp+zMkgeYn63cdR49W
         IsoOn1nQN291XTRlszSR2XxRKZSdtfcQ3lvgSzMlb1u3SslpL6aaoJm6yJvefTBXr7X5
         dt+3GpdPt8mtVDytxDQOxoLhHMiQ2uvRpEhXrVZI9JloCAnK7yM++AS861M6O/f7H/a9
         ubJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699628521; x=1700233321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mUJOBd/q/zD8P/9fxYVqe+7Mn835Ht5oRjEbFlzm6ss=;
        b=FlDsINlpaA8Pl9tM0xYBeM1wTMVu1VllhCDHCmPP9E44M3Ht/Sf1PECRYjGOka8U20
         EIAiJ1dXaeq3WxIfpStQPn3LHCjwNPiw0kMgLZk4nqD/oW+8XPP09tzRSlOteMFaBfOH
         9rh6+IA1tJqlfcfY1jQZrqNP4VXL90k2BD6B3HhUFTTqxD1BrRvcaVfVotURY5V2ShWy
         6vgl73MhzcUT7etf/RalAbt4S9D3vAjdIBu/HKgwTivrMRPUL+o2puwOKx8pbIX02K9M
         0JJ9kVZyiVjx9hOQ2LNufmAFOwA2Vhw21Wsr07JssEe/3aScYafHXfN7mi5OBDg02Pfv
         F5zg==
X-Gm-Message-State: AOJu0Yyfynr0b2B814itCXZsgmVnrsqrwZJXf4PWC1EB/s63ZPf7fVNi
	DPQpJFtiWK1cg3Eoi2K4VRzgSFksy0s=
X-Google-Smtp-Source: AGHT+IFHFXmPh2IP8eqRtqbtd5bg1yzaW0Y1DYymt0WnGq/mXyiUB5zukmj7/mdI/J660eypT96mt10mzSY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:896:b0:27d:2945:ad97 with SMTP id
 bj22-20020a17090b089600b0027d2945ad97mr745496pjb.2.1699628521096; Fri, 10 Nov
 2023 07:02:01 -0800 (PST)
Date: Fri, 10 Nov 2023 07:01:59 -0800
In-Reply-To: <SA1PR11MB6734B37AB5DDCD14A41A6ABBA8AEA@SA1PR11MB6734.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108183003.5981-1-xin3.li@intel.com> <20231108183003.5981-6-xin3.li@intel.com>
 <ZUyeATu4Fd2xI0+h@chao-email> <ZUz3cPmnqSq7Lol9@google.com> <SA1PR11MB6734B37AB5DDCD14A41A6ABBA8AEA@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZU5F58_KRIHzxrMp@google.com>
Subject: Re: [PATCH v1 05/23] KVM: VMX: Initialize FRED VM entry/exit controls
 in vmcs_config
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

On Fri, Nov 10, 2023, Xin3 Li wrote:
> > > >+	if (cpu_feature_enabled(X86_FEATURE_FRED) &&
> > > >+	    !(_vmentry_control & VM_ENTRY_LOAD_IA32_FRED)) {
> > > >+		pr_warn_once("FRED enabled but no VMX VM-Entry
> > LOAD_IA32_FRED control: %x\n",
> > > >+			     _vmentry_control);
> > >
> > > Can we just hide FRED from guests like what KVM does for other
> > > features which have similar dependencies? see vmx_set_cpu_caps().
> > 
> > Both of these warnings should simply be dropped.  The
> > error_on_inconsistent_vmcs_config stuff is for inconsistencies within the allowed
> > VMCS fields.  Having a feature that is supported in bare metal but not virtualized
> > is perfectly legal, if uncommon.
> 
> I deliberately keep it, at least for now, because these checks are helpful
> during the development of nVMX FRED.  It will be helpful for other VMMs
> being developed/tested on KVM.

No, remove it.  It's architecturally legal for a CPU to support a feature in bare
metal but not provide virtualization support.

> > What *is* needed is for KVM to refuse to virtualize FRED if the entry/exit controls
> > aren't consistent.  E.g. if at least one control is present, and at least one
> > control is missing.   I.e. KVM needs a version of vmcs_entry_exit_pairs that can
> > deal with SECONDAY_VM_EXIT controls.
> 
> I agree there are better ways.  But maybe after or before VMX FRED.

Uh, no.  This is not optional.  FRED is the first feature that uses SECONDAY_VM_EXIT
controls, so FRED gets the honor of adding the necessary infrastructure support.

