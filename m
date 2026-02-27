Return-Path: <kvm+bounces-72205-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBU9FsX4oWknyAQAu9opvQ
	(envelope-from <kvm+bounces-72205-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:04:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B20701BD2EE
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76E9C304997E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4292645BD7C;
	Fri, 27 Feb 2026 20:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXL+km9v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772303451AB
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222646; cv=none; b=EvnkYZBuSLjPGsHKzAMo/V65aLgZXN4JNxL/3wb5+v+vyiE0tojIYq5RS5kptjPGz7bYJAVVTyKd9w2GqiY8+C45webqsNaSIRiTnxXwv6yjz8j/xxMur6n1GEt72SjOmIyr+0OPjMigMEXQ33bmceYPgi9oUZq9SrkoLr7u6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222646; c=relaxed/simple;
	bh=og54QudXPuFmQTZMNOTjb9RiAH0J5DA30/PQNOFIUm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OYOJD92WkAXBcmC9WU8IQ0IT3TSF2Um3S4AhONxYR4dAhV9xHzhzX5q5om46omiQfYh2qieCam/DCY8cHXdAOHg86S6In8pNzt9+ai+9ajDOVIJ2Vn8hnmQ7UormTQ+QUqT3fcSk4sogErZLNcEytte7XQEaqMPZhUno6P9t2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXL+km9v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B818C2BC87
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222646;
	bh=og54QudXPuFmQTZMNOTjb9RiAH0J5DA30/PQNOFIUm0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IXL+km9v1PvWlO/6/vuNy5XdNEZa/U6nc3wXJlq1h1UQ8/adIlxYQKYYKyb/maq9S
	 QUzR3qKA5ef7DRiIg4BRNr2N4s0YjsufHyxKWBjqUbd6KU1hHmQVmZjVF2oLTDWldG
	 18RYXDW9fkDJnytmrBiHvwCXhGf33qK17TXhM2Lj7K8bkIhpUMaVURJhMKXnkwng8T
	 3Ov7zghPfGbv4Zie5r3hjMBuJJH4QBYpeNrFftRsFRU3Bxkq+dWG3w/xw5zNqrZ2WJ
	 tqCfPKCjWph6lTYU8rZWftdxhUngzQYxxmCrw0adOX207nBHeowWOvM31pSkJeoArj
	 4tE9JmgJ3TZpQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9359c0ec47so260706766b.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 12:04:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU/MGQ7QHCETwcVD/DSRPlIGxv6rdT2h6m/qsj5vyYbEWyyNpD3196PI2fV0we6B4P3MC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNPDKEgjljW7UP0uubddH/Su0hruk9nnjPHfS2pCEFIgiPFwGf
	8LttFFOQNNVt9VrOhEnomSlCVaWIGkRC4LsdgwkwEb3qAh3G4mF8SFalb2wznGJxjGrHyE9bc9i
	QpRmrxu1hlF69WXvLW6mlM/+6U/uW8l4=
X-Received: by 2002:a17:907:6d0b:b0:b8f:deff:a019 with SMTP id
 a640c23a62f3a-b937615c4a5mr239003466b.0.1772222644883; Fri, 27 Feb 2026
 12:04:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
 <20260209195142.2554532-2-yosry.ahmed@linux.dev> <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
 <aaCO62eQiZX5pvSk@google.com>
In-Reply-To: <aaCO62eQiZX5pvSk@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 12:03:53 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOcBbgtNzy6FizPe8Xm8W=jg3CR8pmdByfszfEM3rqzsA@mail.gmail.com>
X-Gm-Features: AaiRm53OsienD7rPNs2oKD-h8V5YxISqMIOTYz7g2mCS9es2uFKwbgY2cs_Vj9E
Message-ID: <CAO9r8zOcBbgtNzy6FizPe8Xm8W=jg3CR8pmdByfszfEM3rqzsA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: Triple fault L1 on unintercepted
 EFER.SVME clear by L2
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-72205-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B20701BD2EE
X-Rspamd-Action: no action

> > > @@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> > >
> > >     if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
> > >             if (!(efer & EFER_SVME)) {
> > > +                   /*
> > > +                    * Architecturally, clearing EFER.SVME while a guest is
> > > +                    * running yields undefined behavior, i.e. KVM can do
> > > +                    * literally anything.  Force the vCPU back into L1 as
> > > +                    * that is the safest option for KVM, but synthesize a
> > > +                    * triple fault (for L1!) so that KVM at least doesn't
> > > +                    * run random L2 code in the context of L1.
> > > +                    */
> > > +                   if (is_guest_mode(vcpu))
> > > +                           kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > +
> >
> > Sigh, I think this is not correct in all cases:
> >
> > 1. If userspace restores a vCPU with EFER.SVME=0 to a vCPU with
> > EFER.SVME=1 (e.g. restoring a vCPU running to a vCPU running L2).
> > Typically KVM_SET_SREGS is done before KVM_SET_NESTED_STATE, so we may
> > set EFER.SVME = 0 before leaving guest mode.
> >
> > 2. On vCPU reset, we clear EFER. Hmm, this one is seemingly okay tho,
> > looking at kvm_vcpu_reset(), we leave nested first:
> >
> >       /*
> >        * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
> >        * possible to INIT the vCPU while L2 is active.  Force the vCPU back
> >        * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
> >        * bits), i.e. virtualization is disabled.
> >        */
> >       if (is_guest_mode(vcpu))
> >               kvm_leave_nested(vcpu);
> >
> >       ...
> >
> >       kvm_x86_call(set_efer)(vcpu, 0);
> >
> > So I think the only problematic case is (1). We can probably fix this by
> > plumbing host_initiated through set_efer? This is getting more
> > complicated than I would have liked..
>
> What if we instead hook WRMSR interception?  A little fugly (well, more than a
> little), but I think it would minimize the chances of a false-positive.  The
> biggest potential flaw I see is that this will incorrectly triple fault if KVM
> synthesizes a #VMEXIT while emulating the WRMSR.  But that really shouldn't
> happen, because even a #GP=>#VMEXIT needs to be queued but not synthesized until
> the emulation sequence completes (any other behavior would risk confusing KVM).

What if we key off vcpu->wants_to_run?

It's less protection against false positives from things like
kvm_vcpu_reset() if it didn't leave nested before clearing EFER, but
more protection against the #VMEXIT case you mentioned. Also should be
much lower on the fugliness scale imo.

