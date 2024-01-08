Return-Path: <kvm+bounces-5838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B48A82747D
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:53:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CADC1C22E92
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3846951C4D;
	Mon,  8 Jan 2024 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ScUJdTf6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2075C51037
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5eb6dba1796so33118997b3.1
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 07:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704729184; x=1705333984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LXpfvDdR25mi61ZRv+hUGYfziJrbv6+q0uR9W3pdtgw=;
        b=ScUJdTf6pY1EyzXXhTCOXHjVT97d9to7GQ83OVVOdFBTRhGje7AGwchBSTlrSGUrYQ
         VFbN4vMFF6Hla0gcX4RSkXf6EB87oabE/uJ0REVkG1YoQnSO9DHgfBiIqpjFeVPpYgzK
         HXHrCrHGNHHUcptvmkPg86uQDGNIfA4Fh/ldNw7mjAzVqIsfH6Lfsq5tLDEKfe/MjSVD
         Ejfo41gQFHZtoLFYZpVLtvZAUILVJCvSpfdWYL5sbxmnQCSYpM4snT6X7Do0wUrHWdlt
         SDtLaa4/o7/jEn/nOJYlnSZIvd4GiuE5MFW8M3iYnzZS699H8VSVAX1CKzzhaTLXF02A
         Cn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704729184; x=1705333984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXpfvDdR25mi61ZRv+hUGYfziJrbv6+q0uR9W3pdtgw=;
        b=YAtrrvx9r8cE4AE6vUoaw0GPgWf7JiHU4aqKMPcgK9mTGM/FzMYr7fT2oqAipV6J76
         mAZeD+jQcqEZVgyHo9Zvaz2oMqql86y6yuVyOeriUvAHZ1ULm/o/UxQx7IszaVnWBvp8
         Tu+88cGSeWPUyc00LwbKmRflhXFmPsN3bDMYmymQVZzMKzGLE11uXsc457EbFHZT1LHW
         q5r7qVPDggH/EI4pYM1xmhE/SIasUs3RbenTFrvbX+Je0BgF4Vo43on0jVt34Q8JyI9i
         Ncc66wjkXuYhBA+XwB9NroBjGcIyncL65I4mZA53sim5RgZ6cZl1ym2cgscFGRBBZrr3
         XcSA==
X-Gm-Message-State: AOJu0YxfD3nnRA0Uvb3CyQUJWnNP/mMxvGb96fqqN2IVKdoRMphpH8Ns
	SoXFU+eF3KYkjaPMjVRQWgI6DdhkIYrmwlEciw==
X-Google-Smtp-Source: AGHT+IH6tgug6GZXuthKAIt2m3rWLQls/sRxvnIhe9rTO176GAtStoSNma4aHNycx8stxCAgF2wzux11TeA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:83d0:0:b0:dbe:a20a:6330 with SMTP id
 v16-20020a2583d0000000b00dbea20a6330mr1497318ybm.9.1704729184054; Mon, 08 Jan
 2024 07:53:04 -0800 (PST)
Date: Mon, 8 Jan 2024 07:53:02 -0800
In-Reply-To: <CAJ5mJ6hpSSVhZ5hbPZ8vfSnmNU6W+g4e=PeLrG7fG2u8KptfHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-27-michael.roth@amd.com>
 <CAJ5mJ6hpSSVhZ5hbPZ8vfSnmNU6W+g4e=PeLrG7fG2u8KptfHQ@mail.gmail.com>
Message-ID: <ZZwaXo62DpiBJiWN@google.com>
Subject: Re: [PATCH v11 26/35] KVM: SEV: Support SEV-SNP AP Creation NAE event
From: Sean Christopherson <seanjc@google.com>
To: Jacob Xu <jacobhxu@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com, 
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com, 
	pgonda@google.com, peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Adam Dunlap <acdunlap@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 05, 2024, Jacob Xu wrote:
> > +       if (kick) {
> > +               if (target_vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
> > +                       target_vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > +
> > +               kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
> 
> I think we should  switch the order of these two statements for
> setting mp_state and for making the request for
> KVM_REQ_UPDATE_PROTECTED_GUEST_STATE.
> There is a race condition I observed when booting with SVSM where:
> 1. BSP sets target vcpu to KVM_MP_STATE_RUNNABLE
> 2. AP thread within the loop of arch/x86/kvm.c:vcpu_run() checks
> vm_vcpu_running()
> 3. AP enters the guest without having updated the VMSA state from
> KVM_REQ_UPDATE_PROTECTED_GUEST_STATE
> 
> This results in the AP executing on a bad RIP and then crashing.
> If we set the request first, then we avoid the race condition.

That just introducs a different race, e.g. if this task gets delayed and the
target vCPU processes KVM_REQ_UPDATE_PROTECTED_GUEST_STATE before its marked
RUNNABLE, then the target vCPU could end up stuck in the UNINITIALIZED loop.

Reading and writing arch.mp_state across vCPUs is simply not safe.  There's a
reason why KVM atomically manages INITs and SIPIs and only modifies mp_state when
processing events on the target vCPU.

> > +               kvm_vcpu_kick(target_vcpu);

...

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 87b78d63e81d..df9ec357d538 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10858,6 +10858,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >
> >                 if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
> >                         static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
> > +
> > +               if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
> > +                       kvm_vcpu_reset(vcpu, true);
> > +                       if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE) {
> > +                               r = 1;
> > +                               goto out;
> > +                       }
> > +               }
> >         }
> >
> >         if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> > @@ -13072,6 +13080,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
> >         if (kvm_test_request(KVM_REQ_PMI, vcpu))
> >                 return true;
> >
> > +       if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
> > +               return true;
> > +
> >         if (kvm_arch_interrupt_allowed(vcpu) &&
> >             (kvm_cpu_has_interrupt(vcpu) ||
> >             kvm_guest_apic_has_interrupt(vcpu)))
> > --
> > 2.25.1
> >
> >

