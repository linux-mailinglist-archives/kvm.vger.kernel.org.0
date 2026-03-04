Return-Path: <kvm+bounces-72639-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uONkE2SJp2nliAAAu9opvQ
	(envelope-from <kvm+bounces-72639-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:22:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEBE1F931B
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 06F7E306DD91
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 01:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF65430C610;
	Wed,  4 Mar 2026 01:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1wmjElM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B33043DB
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 01:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772587359; cv=none; b=A+uyzjiNDrDvrZxzjyh5LOdtf02OH/L2BqPJotDYHfp8/sB8WBop4HBq9U5WNa9qcCIoVGgz6HzIrwD9NSsZabf3pclFv6R0hTg/Fatx0iKEd/Gd+GbMBl/bIZ7XXCtsH8XmMKNrBumHDNl4v21HQoSUS3LLE53wIzHYMKX2BGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772587359; c=relaxed/simple;
	bh=bV4dz/5cgTgUZ6qjCuFz06R6YL75lTLNkKHNAehY1xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZvYLbcVKICh4MYyRc9GsDE5C28fuaKVWm0HM4eIBvfW9kCW2XEVrAX2+N+JvXz1IG09BpOpknoBRIwHFRlzVoUfYesXpm3F2YOKmhpQPg4EotkUsCukTaXn/LffY9I9w11CRcM2sVcf3mOKwKNMHbgNZqPreJ3+GY8TNJNNqHdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1wmjElM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ECAC19422
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 01:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772587358;
	bh=bV4dz/5cgTgUZ6qjCuFz06R6YL75lTLNkKHNAehY1xw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m1wmjElMdeRVgCHVOmrwRzbhiOrDjeGMAdxuADmsJI95RIXH59MvGvzvG2OLPexA9
	 S6Uqjk5dcpTN8HjzkdA1ITLFAfz760jDibdLQyQ8go9nSufh3rclfwleTERWp4l1wo
	 agsB9U/q2uSp4xR3Js1QH26juhUyp13vBBPQSySU3aRRBJIRwjLt73AsnFMOJ0a7YK
	 4F5yyk3Kjb3Z55fqHaNanmPOZ2YV4XIY4y8oSxaMopzMvSgUIdQFpQh23ORCxtFIsh
	 buDfhApv0+9Rf8MpNVRhL7FP3Vp3N++L2mu9G41Vb0GF2Q76uzemIIxMp1SsXXz6Iw
	 LrdEf7t7tfXLw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9361c771e9so1012063666b.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 17:22:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVjcHXGpBDlYTDOaZjX+1U0BxvUZGtcnG175tQ996ZcZBpnt868IEwdTy/PR8LHJYZ2mmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb6ZWOnO6HBWUNCSX8Z0JdQg8kJQk7BAlIR/dWtOS2Vvmg5yq3
	tpRzAMSsCgBWGZxg00wrEm8MMeZM4Sm474jtRaALV9WL59Hvqv6tqdhFfx2foGXiWZA4eiZuih1
	9rIC7PMST5EOHFRUPdPDaJekZqE3nkGY=
X-Received: by 2002:a17:907:1c9f:b0:b87:1839:2600 with SMTP id
 a640c23a62f3a-b93f143416bmr8474866b.33.1772587357660; Tue, 03 Mar 2026
 17:22:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304002223.1105129-1-seanjc@google.com> <20260304002223.1105129-3-seanjc@google.com>
 <j4t4v6n6hg5d7qxz722yecwtafphf55xgyrs5bnyowwa7emzfp@ceajjnpem4vk> <aaeIxLBM1rUeSPs3@google.com>
In-Reply-To: <aaeIxLBM1rUeSPs3@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Mar 2026 17:22:26 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOFQmYG=icrF62qQFiL_+jryM=DJopdjuUGDPLXxyyUUA@mail.gmail.com>
X-Gm-Features: AaiRm53YQweULnefBcltvxshIjNphW5T3MoPdqdAhaB1_NCO1H3oO6H17PdkcoM
Message-ID: <CAO9r8zOFQmYG=icrF62qQFiL_+jryM=DJopdjuUGDPLXxyyUUA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] KVM: nSVM: Always intercept VMMCALL when L2 is active
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BDEBE1F931B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72639-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 5:20=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Mar 04, 2026, Yosry Ahmed wrote:
> > On Tue, Mar 03, 2026 at 04:22:23PM -0800, Sean Christopherson wrote:
> > > Always intercept VMMCALL now that KVM properly synthesizes a #UD as
> > > appropriate, i.e. when L1 doesn't want to intercept VMMCALL, to avoid
> > > putting L2 into an infinite #UD loop if KVM_X86_QUIRK_FIX_HYPERCALL_I=
NSN
> > > is enabled.
> > >
> > > By letting L2 execute VMMCALL natively and thus #UD, for all intents =
and
> > > purposes KVM morphs the VMMCALL intercept into a #UD intercept (KVM a=
lways
> > > intercepts #UD).  When the hypercall quirk is enabled, KVM "emulates"
> > > VMMCALL in response to the #UD by trying to fixup the opcode to the "=
right"
> > > vendor, then restarts the guest, without skipping the VMMCALL.  As a
> > > result, the guest sees an endless stream of #UDs since it's already
> > > executing the correct vendor hypercall instruction, i.e. the emulator
> > > doesn't anticipate that the #UD could be due to lack of interception,=
 as
> > > opposed to a truly undefined opcode.
> > >
> > > Fixes: 0d945bd93511 ("KVM: SVM: Don't allow nested guest to VMMCALL i=
nto host")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/hyperv.h | 4 ----
> > >  arch/x86/kvm/svm/nested.c | 7 -------
> > >  2 files changed, 11 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> > > index 9af03970d40c..f70d076911a6 100644
> > > --- a/arch/x86/kvm/svm/hyperv.h
> > > +++ b/arch/x86/kvm/svm/hyperv.h
> > > @@ -51,10 +51,6 @@ static inline bool nested_svm_is_l2_tlb_flush_hcal=
l(struct kvm_vcpu *vcpu)
> > >  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *=
vcpu);
> > >  #else /* CONFIG_KVM_HYPERV */
> > >  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *v=
cpu) {}
> > > -static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *=
vcpu)
> > > -{
> > > -   return false;
> > > -}
> >
> > Why is this dropped? We still need it for vmmcall_interception under
> > !CONFIG_KVM_HYPERV, right?
>
> Nope, because vmmcall_interception() uses nested_svm_is_l2_tlb_flush_hcal=
l(), and
> the previous patch created a stub for that one.  I.e. only the non-stub
> CONFIG_KVM_HYPERV=3Dy version references nested_svm_l2_tlb_flush_enabled(=
).

Oh I thought we were removing the stub for
nested_svm_is_l2_tlb_flush_hcall(), these names are too similar :P

Sorry for the noise.

Feel free to add:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

