Return-Path: <kvm+bounces-72969-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CESLBYQiqmnMLwEAu9opvQ
	(envelope-from <kvm+bounces-72969-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:40:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D5C219E4F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DFBBD3028347
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 00:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6574C2E62C3;
	Fri,  6 Mar 2026 00:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/4Nm48j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959312E173B
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 00:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772757623; cv=none; b=V70Ah5uvKMvrwlvMtIBoJuOduz4q0IPMQp054oeK51scyrGK5ax7MhbcTGD7H73lHL/eGnR5rQeE+4onI5GFAtz/CJonsLNLC7YpdV22JGkgfXP+AcZ1+BzZDccNsYUJoYg+nxz22IsvLV34SbQcjYU3XF9YJYQFQnPQu1igtTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772757623; c=relaxed/simple;
	bh=Hmu7ac4D6F7jU7ImssJ7l4Qi4KJBqpAIqKRXxv1q9Vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LK9awribCaoRpemrAaPV8g72SZzgrMo/EwOO1clqf+dwMaZnnDCDKko+ExQzRQwpDti9CPDr2CqZnjq85+7ra7+GJfKq52jVUxBbVJUNk4ZH3CuVj9RBUP44XbeEzy9jqftaWGKQcx3P1JhWTfrYB/RXut+Xc8I3NJ43oE9O2Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/4Nm48j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BF0C2BC9E
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 00:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772757623;
	bh=Hmu7ac4D6F7jU7ImssJ7l4Qi4KJBqpAIqKRXxv1q9Vc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A/4Nm48jrTau+okrsz6niVToRoQhd6Qfy3vtPlao5lMvAC0uMLvbII+jtp0+FHjo1
	 8Pm3gPB50m7klS/aNVOHCzMzKLOMV7Kv3nrW6zVes0F93hx+nNRXZEfeZqtEr3BzBf
	 YK3nD3uRlGIy5cCKiFwtifU/y+urOt++1kK8nTknSVB1IZF2QQUOJFdb3uL7sK4Wzx
	 OO857chz+IZxPCMeGZYQgMzhh1D6I5+mANFSo8H1orcE8vVWvA/ewdzIBfFrmjJkH5
	 /oIwwbhzWwwr0CYFZO3Cl17ljbdi5ApqjQu85uW8+/BypynZwofwLnrbYcoAB31S5x
	 lyyo7V5NJvhzg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b942a41c5fcso21345466b.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 16:40:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXoHpFXk3NDy9A0RkeawpH5KdvHCA+8JsXqV85JpaH1+t372CupzK0h9K48BFHFLWX567w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1KcT2HsgUd2LvYuHwzli5x6MJftI+J0iL0fljK0bIBaIpaNww
	Lk9nBJYXtosbyAJ/RELEh5KE7Ela90TUVPUOwBi0S8+Iy+8F/fpmXvB8ShdgxITcvwFPvMTf5vh
	PaFbzq4Dpxu6RcqbaWG1vY2q/KA5S+Mo=
X-Received: by 2002:a17:906:2081:b0:b8f:a729:2393 with SMTP id
 a640c23a62f3a-b942e0f4e57mr5081466b.40.1772757622181; Thu, 05 Mar 2026
 16:40:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com> <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
In-Reply-To: <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 5 Mar 2026 16:40:10 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
X-Gm-Features: AaiRm50Zn2LezQKqRC_hx1xDy5Q29_kpOlwxVTbkeL2gWYCUmv9fTkyf5l1cttk
Message-ID: <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 81D5C219E4F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72969-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 4:05=E2=80=AFPM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Thu, Mar 5, 2026 at 2:52=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Thu, Mar 5, 2026 at 2:30=E2=80=AFPM Jim Mattson <jmattson@google.com=
> wrote:
> > >
> > > On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > > >
> > > > Add a test that verifies that KVM correctly injects a #GP for neste=
d
> > > > VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 canno=
t be
> > > > mapped.
> > > >
> > > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > > > ...
> > > > +       /*
> > > > +        * Find the max legal GPA that is not backed by a memslot (=
i.e. cannot
> > > > +        * be mapped by KVM).
> > > > +        */
> > > > +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY=
_MAX_PHY_ADDR);
> > > > +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> > > > +       vcpu_alloc_svm(vm, &nested_gva);
> > > > +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> > > > +
> > > > +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> > > > +       vcpu_run(vcpu);
> > > > +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > > > +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> > > > +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
> > >
> > > Why would this raise #GP? That isn't architected behavior.
> >
> > I don't see architected behavior in the APM for what happens if VMRUN
> > fails to load the VMCB from memory. I guess it should be the same as
> > what would happen if a PTE is pointing to a physical address that
> > doesn't exist? Maybe #MC?
>
> Reads from non-existent memory return all 1's

Today I learned :) Do all x86 CPUs do this?

> so I would expect a #VMEXIT with exitcode VMEXIT_INVALID.

This would actually simplify the logic, as it would be the same
failure mode as failed consistency checks. That being said, KVM has
been injecting a #GP when it fails to map vmcb12 since the beginning.

It also does the same thing for VMSAVE/VMLOAD, which seems to also not
be architectural. This would be more annoying to handle correctly
because we'll need to copy all 1's to the relevant fields in vmcb12 or
vmcb01.

Sean, what do you want us to do here?

