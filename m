Return-Path: <kvm+bounces-71556-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HKXKBT2nGlEMQQAu9opvQ
	(envelope-from <kvm+bounces-71556-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:51:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E2D180511
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 191DF3046B96
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D537239E9B;
	Tue, 24 Feb 2026 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kY13hAt/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0CDF59
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894276; cv=none; b=LIGAlnkWDVyqP45c/yGuyB5YC0KwYFPBChZW/raBKz3BCmYNnMX0AudnPVhRr67a7MkRQ/IT6448eQB1sk3+48yZ8vKBsqpdXRnN1Y6CeIIqQfE48rZDgFqMfKIEI7Rq0us9GaDd9MvuuBeU0P2kfpTZazxTTTpx4DeOnWabztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894276; c=relaxed/simple;
	bh=QyBeWgJTo9UA9GrHncoMlxJYBEa6ccrv4Man4D/b5I4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O94z+WUli23RiZjUkNt2VzNboHQp+0Wr75jxTZZRoFCnBcr0B2jzBitSiiRLkzNeQafQqSlc8GF+JrXa0+1aE+j6ZMWawOXInXUgDjoHynqpHjQH1Gdmkq+ECREDUOvQoUZU+7mjSQtYDZDEKLF9zODUYtp9XOMQsL4eV5v1cQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kY13hAt/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F16C2BC86
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771894276;
	bh=QyBeWgJTo9UA9GrHncoMlxJYBEa6ccrv4Man4D/b5I4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kY13hAt/LRgrT+LJxmzBEQZi7eT+DerHFe/7FHbQ2avnpzUXh+sWH4iWp8YWIWWc9
	 uyAXj80zAnqIFMNGM+G9Je9WhjVQsQHfnA6WoXIChwVBr9faF24STxdsS6RlI4Y4Eq
	 FcfKuX9U2byXotcv4dPp8blW3sq6Wky6/zXdiJzVfPW/GibkhmFGmkSSJ2sPAQKhBK
	 92r7MenqnmHukhkHYxvzt496rSvS1+H7RPTjt8bJ8tWSOaiWyBxVdmos6jC9ZUxBLV
	 2Gzn+eGct4NVjutv3JIOvQt8kefWmYuTmMnpa+A7+KoDFQPHnfuJjqFI9e9KD8Sb6v
	 3a+uazSEDurUw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8845cb580bso755596266b.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:51:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUFWt0cj503IZkLJGnHlqWrPMdRtVtNptqrlmOYR/WfbZAobsWtef7PEjNDHF+6r31nois=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr2N4L4LEBwYB8LyIBzPBtJ79pamqAyGzvJS5gbyBULw/x14jd
	FJq7G6mzcLnjkF6rhc8Nm023/uP3pmzpT/dO76oDw24QLpPAOYLu7wEswgnP8UBL60stiFd9gE4
	PTjdGQtFjQ2SlHCtIfL6SgeJcQoQI9ac=
X-Received: by 2002:a17:907:94cc:b0:b87:12d2:fa1a with SMTP id
 a640c23a62f3a-b908191f1d6mr627159866b.12.1771894275333; Mon, 23 Feb 2026
 16:51:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
 <20260206190851.860662-7-yosry.ahmed@linux.dev> <aZzyanOAcoAnh01A@google.com>
In-Reply-To: <aZzyanOAcoAnh01A@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Feb 2026 16:51:04 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMv6E5j7=c-1oqpOihWk0w6a0rexf5FRaP-7PZSwV4vBQ@mail.gmail.com>
X-Gm-Features: AaiRm52y2dulrFZMsHBcOpUK4cHWuIY5Yvz9WheIyyxhCE9Z1O45g3b-M2dxO24
Message-ID: <CAO9r8zMv6E5j7=c-1oqpOihWk0w6a0rexf5FRaP-7PZSwV4vBQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/26] KVM: nSVM: Triple fault if mapping VMCB12 fails
 on nested #VMEXIT
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71556-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 08E2D180511
X-Rspamd-Action: no action

> > @@ -1146,8 +1136,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >       /* in case we halted in L2 */
> >       kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
> >
> > +     svm->nested.vmcb12_gpa = 0;
> > +
> > +     if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
> > +             kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > +             return 1;
>
> Returning early isn't entirely correct.  In fact, I think it's worse than the
> current behavior in many aspects.
>
> By doing leave_guest_mode() and not switching back to vmcb01 and not putting
> vcpu->arch.mmu back to root_mmu, the vCPU will be in L1 but with vmcb02 and L2's
> MMU active.

Hmm yeah, the same problem also exists in
nested_svm_vmrun_error_vmexit() after "KVM: nSVM: Restrict mapping
VMCB12 on nested VMRUN". In that path, we only need to map vmcb12 to
zero event_inj in __nested_svm_vmexit(). We can probably move them to
the callers (nested_svm_vmrun_error_vmexit() and nested_svm_vmexit())
to make it easier to skip if mapping fails.

>
> The idea I can come up with is to isolate the vmcb12 writes (which is suprisingly
> straightforward), and then simply skip the vmcb12 updates.  E.g.
>
> ---
[..]
> @@ -1184,14 +1168,53 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>         if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                 vmcb12->control.next_rip  = vmcb02->control.next_rip;
>
> +       if (nested_vmcb12_has_lbrv(vcpu))
> +               svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
> +
>         vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
>         vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
>         vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
>
> +       trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
> +                                      vmcb12->control.exit_info_1,
> +                                      vmcb12->control.exit_info_2,
> +                                      vmcb12->control.exit_int_info,
> +                                      vmcb12->control.exit_int_info_err,
> +                                      KVM_ISA_SVM);
> +}
> +
> +int nested_svm_vmexit(struct vcpu_svm *svm)
> +{
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> +       struct vmcb *vmcb01 = svm->vmcb01.ptr;
> +       struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> +       struct vmcb *vmcb12;
> +       struct kvm_host_map map;
> +       int rc;
> +
> +       if (!kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map)) {
> +               vmcb12 = map.hva;

Maybe also kvm_vcpu_map() mapping call to
nested_svm_vmexit_update_vmcb12() and inject a tripe fault if it
fails? Probably plays nicer with "KVM: nSVM: Restrict mapping VMCB12
on nested VMRUN".

Otherwise it looks good to me.

Should I send a new version to add all the changes?

