Return-Path: <kvm+bounces-72964-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILuEIlMJqmmVJwEAu9opvQ
	(envelope-from <kvm+bounces-72964-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:53:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7F62191AD
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:53:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F1FE63013C87
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2EB364E99;
	Thu,  5 Mar 2026 22:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ropu0rFs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47443644AD
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772751174; cv=none; b=eZhitOPF2pxxbcHTibU9zsOkWDmUMoAWn8T/SqrviiiDdLcIaPUi4eFpKCSMA2z7rF+CFWvHC2ZwjKnXDR54Ehm4JNthXwKRvb8B+agxK3T2ntgRPzNFXyIdMS8tBfyjvrRNT6HSPfMZH79KNd4LIOgr1W316yfLGCxfv6a1Au8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772751174; c=relaxed/simple;
	bh=uI9gfBRgvz874vhK2JA8QTHhzQhUNsEejAl3Na7gqUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RE8q66GZhlVr5ZdzVrXOCxr0Fe/OLMAXebbXZqJ0Tg0xRi4VzxLfSkMkSj/oNw+ej8chrzsiiWJVRPOvUMY8bHy1SvP9QVt0gMummVrvfPlbxmtL9mDJEsWGBvGroS0DPW8Qy6OITkWcdqzcQMdYx/Kb+4dKLbdigndq3Cu4TiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ropu0rFs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E727C19423
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772751174;
	bh=uI9gfBRgvz874vhK2JA8QTHhzQhUNsEejAl3Na7gqUQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ropu0rFsp0FWmeuKhs4G0YBfsgzwA9ErPwkdS8R1RFEqF/Lfhi0fKDBTa5cY2tpEm
	 LtMF+E3CeEEoINghZlmYSkUQ4rru3FKBAluuyGc5sv6dDyQtr2fGgpRG/7SfogMTIx
	 lsBiDnewcb4TTbCbyNcdVc42a4jPDZM29pBwSXy0YQtS9PDeKg1/uXsGI40Hp0jAJc
	 y6zoTeua4V+BWdhdoTy+tn1FoT1331hAnhAKq2GiR14ScsPwV6Yy6rEHo/rvUAcnAW
	 Yn2A9PtM/dW/8WlIkM+XiL4UI+z12U15jfozjjWpU/4WO4G+i7JUbNrvlSCt4rStwh
	 pPtkavrGbNRXw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b942424d231so48109966b.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:52:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXYqnP9PTPA4JhLT9o/HX4EX3OW4X8WAyuIIrUGxPLPVztqPkQXNymHZ4IRg4xCzNfQ0AU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi9slVNU5VYqWGufbvMwBm6fOzMQHWgc9v2NCv6qv///3jV1Fg
	bJO7J1lUOS3VLkpqCPY2LLVguAyyBh0U8gUEMIcMhogYFFnmRqY9NWJG60yf66M4UCDULTjr45l
	SqPZQre3jKo9gNEAECfkRcVbB/Nhf0K4=
X-Received: by 2002:a17:907:d0a:b0:b94:244b:2bc1 with SMTP id
 a640c23a62f3a-b94244b319emr61482566b.43.1772751173339; Thu, 05 Mar 2026
 14:52:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
In-Reply-To: <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 5 Mar 2026 14:52:42 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
X-Gm-Features: AaiRm50yWHEcEX1pWhUIh3GHB3Z9xG4URUMACsORdAMBu0gv3Gkg7UpN4o8B-Ik
Message-ID: <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D7F62191AD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72964-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 2:30=E2=80=AFPM Jim Mattson <jmattson@google.com> wr=
ote:
>
> On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > Add a test that verifies that KVM correctly injects a #GP for nested
> > VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 cannot be
> > mapped.
> >
> > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > ...
> > +       /*
> > +        * Find the max legal GPA that is not backed by a memslot (i.e.=
 cannot
> > +        * be mapped by KVM).
> > +        */
> > +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY_MAX=
_PHY_ADDR);
> > +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> > +       vcpu_alloc_svm(vm, &nested_gva);
> > +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> > +
> > +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> > +       vcpu_run(vcpu);
> > +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> > +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
>
> Why would this raise #GP? That isn't architected behavior.

I don't see architected behavior in the APM for what happens if VMRUN
fails to load the VMCB from memory. I guess it should be the same as
what would happen if a PTE is pointing to a physical address that
doesn't exist? Maybe #MC?

