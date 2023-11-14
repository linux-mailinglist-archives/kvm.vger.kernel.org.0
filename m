Return-Path: <kvm+bounces-1649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CEC7EB133
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A8E02811D3
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 13:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC26405D6;
	Tue, 14 Nov 2023 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BpnOdNHq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E383FE53
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 13:48:54 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5B71A1
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 05:48:53 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6c337ce11ceso7423250b3a.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 05:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699969733; x=1700574533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pFdQG3p9z72GUR9QnqqKlBLqvN6b+KAcYKxrn93TTgc=;
        b=BpnOdNHqrJzAsVtywklbtLnGCLzrWGnDkix1d7iIxgyh40dl/UmcsJJgV3ef4hH8e5
         nfEIa9pwhMQfsJ0D6ZJ84SWq77yOWEZYDgW/ymr/g5b9U45VmajEeY470MgY+xOEV23R
         xV22P35IQXHKvxZ+9E2tAWFFqffHnCFHXj8qmSXIPyroxgnHn3EFUKOu0lCKwBXuqmaT
         phxQznTIZH3vzM2stA7t6lnA9T0LWtZrXT//n5LV1d1/Oog1EZp9bbAuN80mXsDsnruP
         hlJEoFUoQm7EA33Kq62eILm97L+ZpQrKxIWi1Hn1XUwd+2B9FhsbOOY1rOGdUHa3Qmb8
         usIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699969733; x=1700574533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFdQG3p9z72GUR9QnqqKlBLqvN6b+KAcYKxrn93TTgc=;
        b=GEaxIwwjmRKlCvqLTdvjtxnaacZmpRLZpkI9ZOkiE1A7blUlKVBhTITiLquWIWg5NM
         3xQQrP/UOjQ35J6FihkkOpnMSEL7fOSJKFbWlcMT5+GXACIeb55inu+g4N+NQFUuF1sK
         hdQ8c7BnwKwJjQFzFo4mu3pZIgf3ytjYok119c9MKYkv4SdqKld5nU+y4m5Uv0tcjUHc
         u1kIRQh7HRohxX2SgdG9aICswM1mm1gMGlgceiIJYUHFJ82WA1APUl14ucjm7UpczLYO
         Z/WQCBEEYhF9z9ksMI6zXYEW1WU0au8DPvTwsZnfIGnnJwGBOhcRCVHo2gtVKTqeFUNh
         Co/A==
X-Gm-Message-State: AOJu0YzYLBhNWPKRP/BF1l/p6uw28Rhh2PH09ruSiDvV9oiUiWw9zazq
	5rPuFEMRTSXu3awTBdOzYZLcqDMrc6s=
X-Google-Smtp-Source: AGHT+IFFusl9fVxC70wV1MT3ThExD44ZvazT84k66xxKcLEPPbou4Ki+x5mr083fJpTti0/5QJgyMvAcF+c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2809:b0:68f:f868:a4fb with SMTP id
 bl9-20020a056a00280900b0068ff868a4fbmr2306696pfb.5.1699969732796; Tue, 14 Nov
 2023 05:48:52 -0800 (PST)
Date: Tue, 14 Nov 2023 05:48:51 -0800
In-Reply-To: <ffec2e93-cdb1-25e2-06ec-deccf8727ce4@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-7-seanjc@google.com>
 <ffec2e93-cdb1-25e2-06ec-deccf8727ce4@gmail.com>
Message-ID: <ZVN6w2Kc2AUmIiJO@google.com>
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 13, 2023, Robert Hoo wrote:
> On 11/11/2023 7:55 AM, Sean Christopherson wrote:
> > When updating guest CPUID entries to emulate runtime behavior, e.g. when
> > the guest enables a CR4-based feature that is tied to a CPUID flag, also
> > update the vCPU's cpu_caps accordingly.  This will allow replacing all
> > usage of guest_cpuid_has() with guest_cpu_cap_has().
> > 
> > Take care not to update guest capabilities when KVM is updating CPUID
> > entries that *may* become the vCPU's CPUID, e.g. if userspace tries to set
> > bogus CPUID information.  No extra call to update cpu_caps is needed as
> > the cpu_caps are initialized from the incoming guest CPUID, i.e. will
> > automatically get the updated values.
> > 
> > Note, none of the features in question use guest_cpu_cap_has() at this
> > time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/cpuid.c | 48 +++++++++++++++++++++++++++++++-------------
> >   1 file changed, 34 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 36bd04030989..37a991439fe6 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -262,31 +262,48 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
> >   	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> >   }
> > +static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
> > +						       struct kvm_cpuid_entry2 *entry,
> > +						       unsigned int x86_feature,
> > +						       bool has_feature)
> > +{
> > +	if (entry)
> > +		cpuid_entry_change(entry, x86_feature, has_feature);
> > +
> > +	if (vcpu)
> > +		guest_cpu_cap_change(vcpu, x86_feature, has_feature);
> > +}
> > +
> >   static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
> >   				       int nent)
> >   {
> >   	struct kvm_cpuid_entry2 *best;
> > +	struct kvm_vcpu *caps = vcpu;
> 
> u32 *caps  = vcpu->arch.cpu_caps;
> and update guest_cpu_cap_set(), guest_cpu_cap_clear(),
> guest_cpu_cap_change() and guest_cpu_cap_restrict() to pass in
> vcpu->arch.cpu_caps instead of vcpu, since all of them merely refer to vcpu
> cap, rather than whole vcpu info.

No, because then every caller would need extra code to pass vcpu->cpu_caps, and
passing 'u32 *' provides less type safety than 'struct kvm_vcpu *'.  That tradeoff
isn't worth making this one path slightly easier to read.

> Or, for simple change, here rename variable name "caps" --> "vcpu", to less
> reading confusion.

@vcpu is already defined and needs to be used in this function.  See the comment
below.

I'm definitely open to a better name, though I would like to keep the name
relative short so that the line lengths of the callers is reasonable, e.g. would
prefer not to do vcpu_caps.

> > +	/*
> > +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> > +	 * are coming in from userspace!
> > +	 */
> > +	if (entries != vcpu->arch.cpuid_entries)
> > +		caps = NULL;
> >   	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> > -	if (best) {
> > -		/* Update OSXSAVE bit */
> > -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> > -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> > +
> > +	if (boot_cpu_has(X86_FEATURE_XSAVE))
> > +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
> >   					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
> > -		cpuid_entry_change(best, X86_FEATURE_APIC,
> > -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> > +	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
> > +				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);

