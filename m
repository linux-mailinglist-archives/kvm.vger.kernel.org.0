Return-Path: <kvm+bounces-457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E917DFD63
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 00:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9F8E281DD2
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 23:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3386225A6;
	Thu,  2 Nov 2023 23:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e3EsYydG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77B821376
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 23:58:52 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E632C1A1
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:58:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afa86b8d66so20485477b3.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 16:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698969527; x=1699574327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h4tjnGpFWX0ueNFeTtSdnMph2gJgcBhqin9rkQkui7U=;
        b=e3EsYydG6yaGIayNWhO3ouzjLRrFKXmG23KlGGNFWCMA8edSX5FBz/5wbSpdFMSX21
         PMqk2RhfC4eNUIY1bKmWc1L3O8xk5EbyuvcuaukMTZuFr8NnTX8cdLP+DFc2AMAhvlHW
         JVHwdsmDDj8h5tSk7fDKDYKcaDdk/HQlIuUjpdT114n70cCzf1GHL0Fh1Eq2BF33JS+G
         dFP4410zrZmlyinqKXETV94QRYpHVHgUA/FlI0RIpShsAGH2bCue17+ld2QncBCUdMEj
         0gsKmhHFtoetQuQKirVwa5ULFfzUMP0aCkgAtveeIGDRv1za4gcaEY8TnlIWC6pT1iA/
         +pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698969527; x=1699574327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h4tjnGpFWX0ueNFeTtSdnMph2gJgcBhqin9rkQkui7U=;
        b=k4FCngZvWebum6CyRavAa7RRCZGXkWKTHV0Cl0gpdFh7in31S2MyCDyiJfWIlvpaEG
         6XAlbBXvc1l9arF/z+Xb4jAlfLb7T0gd0fAhynr4cvgG1Uhwf0RIERyna7+ZYvy6VONo
         Xhq2qd3NfkKHjhxW0x1+DWcXpc1wN6sGtFo5GT6g0If8SXvryteHa7ZEVs6Rg/MzyjJo
         TvqW4zX5KK2NaWSkPtvQN9rNdrWd28zUDaCZxAHyxv6ECp/++HWrMsQXe+DzKbPcAXGa
         RfOx1AVcsV2lEHyV56MNrOx6p03RQjG0u5/NGWPOyC/1c8eRtZD0c6b86N2w8d2BBNgc
         bA0w==
X-Gm-Message-State: AOJu0YwmzqluHOCwjFRZP9vlMP+yzVKxHa4Gnlv5GfUwCI4lu7mttroC
	yiPMcg3d9mb8gIWZCu3PPfK0Y06y7i4=
X-Google-Smtp-Source: AGHT+IF7dwAAbp+cysYu4Z3itG12L4BxhEAvLhk5APpsVVgEVmCTWLw6MkXUOKe9rJcmC12wneai/pg0D5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f8f:0:b0:5a8:170d:45a9 with SMTP id
 d137-20020a814f8f000000b005a8170d45a9mr20253ywb.8.1698969527017; Thu, 02 Nov
 2023 16:58:47 -0700 (PDT)
Date: Thu, 2 Nov 2023 16:58:45 -0700
In-Reply-To: <ff6b7e9d90d80feb9dcabb0fbd3808c04db3ff94.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-20-weijiang.yang@intel.com> <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
 <ZUJ9fDuQUNe9BLUA@google.com> <ff6b7e9d90d80feb9dcabb0fbd3808c04db3ff94.camel@redhat.com>
Message-ID: <ZUQ3tcuAxYQ5bWwC@google.com>
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> On Wed, 2023-11-01 at 09:31 -0700, Sean Christopherson wrote:
> > On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > > Add emulation interface for CET MSR access. The emulation code is split
> > > > into common part and vendor specific part. The former does common check
> > > > for MSRs and reads/writes directly from/to XSAVE-managed MSRs via the
> > > > helpers while the latter accesses the MSRs linked to VMCS fields.
> > > > 
> > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > ---
> > 
> > ...
> > 
> > > > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > > > +	case MSR_KVM_SSP:
> > > > +		if (host_msr_reset && kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > > > +			break;
> > > > +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > > > +			return 1;
> > > > +		if (index == MSR_KVM_SSP && !host_initiated)
> > > > +			return 1;
> > > > +		if (is_noncanonical_address(data, vcpu))
> > > > +			return 1;
> > > > +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
> > > > +			return 1;
> > > > +		break;
> > > Once again I'll prefer to have an ioctl for setting/getting SSP, this will
> > > make the above code simpler (e.g there will be no need to check that write
> > > comes from the host/etc).
> > 
> > I don't think an ioctl() would be simpler overall, especially when factoring in
> > userspace.  With a synthetic MSR, we get the following quite cheaply:
> > 
> >  1. Enumerating support to userspace.
> >  2. Save/restore of the value, e.g. for live migration.
> >  3. Vendor hooks for propagating values to/from the VMCS/VMCB.
> > 
> > For an ioctl(), 
> > #1 would require a capability, #2 (and #1 to some extent) would
> > require new userspace flows, and #3 would require new kvm_x86_ops hooks.
> > 
> > The synthetic MSR adds a small amount of messiness, as does bundling 
> > MSR_IA32_INT_SSP_TAB with the other shadow stack MSRs.  The bulk of the mess comes
> > from the need to allow userspace to write '0' when KVM enumerated supported to
> > userspace.
> 
> Let me put it this way - all hacks start like that, and in this case this is API/ABI hack
> so we will have to live with it forever.

Eh, I don't view it as a hack, at least the kind of hack that has a negative
connotation.  KVM effectively has ~240 MSR indices reserved for whatever KVM
wants.  The only weird thing about this one is that it's not accessible from the
guest.  Which I agree is quite weird, but from a code perspective I think it
works quite well.

> Once there is a precedent, trust me there will be 10s of new 'fake' msrs added, and the
> interface will become one big mess.

That suggests MSRs aren't already one big mess. :-)  I'm somewhat joking, but also
somewhat serious.  I really don't think that adding one oddball synthetic MSR is
going to meaningfully move the needle on the messiness of MSRs.

Hmm, there probably is a valid slippery slope argument though.  As you say, at
some point, enough state will get shoved into hardware that KVM will need an ever
growing number of synthetic MSRs to keep pace.

> As I suggested, if you don't want to add new capability/ioctl and vendor
> callback per new x86 arch register, then let's implement
> KVM_GET_ONE_REG/KVM_SET_ONE_REG and then it will be really easy to add new
> regs without confusing users, and without polluting msr namespace with msrs
> that don't exist.

I definitely don't hate the idea of KVM_{G,S}ET_ONE_REG, what I don't want is to
have an entirely separate path in KVM for handling the actual get/set.

What if we combine the approaches?  Add KVM_{G,S}ET_ONE_REG support so that the
uAPI can use completely arbitrary register indices without having to worry about
polluting the MSR space and making MSR_KVM_SSP ABI.

Ooh, if we're clever, I bet we can extend KVM_{G,S}ET_ONE_REG to also work with
existing MSRs, GPRs, and other stuff, i.e. not force userspace through the funky
KVM_SET_MSRS just to set one reg, and not force a RMW of all GPRs just to set
RIP or something.  E.g. use bits 39:32 of the id to encode the register class,
bits 31:0 to hold the index within a class, and reserve bits 63:40 for future
usage.

Then for KVM-defined registers, we can route them internally as needed, e.g. we
can still define MSR_KVM_SSP so that internal it's treated like an MSR, but its
index isn't ABI and so can be changed at will.  And future KVM-defined registers
wouldn't _need_ to be treated like MSRs, i.e. we could route registers through
the MSR APIs if and only if it makes sense to do so.

Side topic, why on earth is the data value of kvm_one_reg "addr"?

