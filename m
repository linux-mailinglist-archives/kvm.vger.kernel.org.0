Return-Path: <kvm+bounces-72966-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHkNF08aqmkqLQEAu9opvQ
	(envelope-from <kvm+bounces-72966-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:05:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 970B2219AC9
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 01:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6B8B93028125
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 00:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2896D20B810;
	Fri,  6 Mar 2026 00:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cs6xfU8B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC146221275
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 00:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772755530; cv=pass; b=Lcjx1NDmcpQpcx2x6ADt5QQ6bGpZyoppQqEVkr0AHZ7GAjf/iJlBsmKZERkknyvuPc09qn0DSy0j4XU2vJoB/4sOUV5OtuGaH7jhQIbdpmbngYMFyWQ8gOTlhhRCYW/R3YmJ892IfgVMeA8UQI39UB8+p678WNF9tdqLT44XmMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772755530; c=relaxed/simple;
	bh=Ai/i/8M/yGrY9CqCstlcnhQgqkpBw7Hv1Vwf24WYdtI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JhDts/sfCPQo9xC9WXPkqa7kASVpWJi9aCCFN5u4DIHIQ7QRHLQbPhK8jb1Lh2mAYMILYTaCH/fnPmk2h1xN7cl3DNwKiraJBscXz2KTZ2IDWUEeRnh1i9RokyaEX2ONch9bo26LpGhYX2TWrRVT3CWNWVKIiZYx0HjADPyq7Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cs6xfU8B; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so2631a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 16:05:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772755526; cv=none;
        d=google.com; s=arc-20240605;
        b=JrnG8zoik3lDAl2KILBt/tWMu0GpAnI8oNSTCXJViXyGiyK01dtpY+v2EwZoXyospp
         16S6BHIj7nj1W6N/ArBWMyENTxZsBO7vnbVrNodL4GLq1vRDmGBlzpasit6Sehs64k/q
         Gv3CQlQUuemldUWPuplNj6eb9opPMjxyWqJABbW0l+6VWCC6yKAfLeXyiNcNbjJAcvdh
         riLGA4cxMNkYhu/Jew5ikq7kp3ZQ+aH56hOClBmuLqDUkpV5kKa6FCvtGXKa69LsgQIn
         kRdkFOgSxO0dct7up/Dp4DN0kb6pRTXWv6KbmYWBllFPevVrCT7ncZs536N9AqXxNg7n
         gyQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dG6HV+RqSVnjKBjCoY7wFe8G+mOmY+WOXjDpb83bWFE=;
        fh=l5mkBSJB80wVfyXd7DxX1L4nwfMVQqvrJ5XZE3LkkJE=;
        b=ZaA+V+cJ09PsE/Ax+ZYga1E7mgb6OgJsYkOReFEBD3fuTbfnLhx/0+db9mMLSaNNMZ
         vq6QGH+EifigRXbbu6IMhzerkfJ2to8FVCImkA93/loBmhH3STz5bBMzLOFhaGOpKgfs
         WDpdOvbtLrsTizq/GOpqla6W7HhgBNtgCHoLqpiqygoOelp4+J77m98RW9H9EsMKOUTU
         STLXFm9D59vMebhcm6RF9zeOeCusQCQXNfS2z1bAgC/euUK00NurRpbyk7HPk7pOTpno
         agbXXJGBKlv2kYzSetlJdXiXU7ZCb471sUvNCUWTl181v4hXUK2DVNzgVJ0PeGt0p6Ik
         HHeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772755526; x=1773360326; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dG6HV+RqSVnjKBjCoY7wFe8G+mOmY+WOXjDpb83bWFE=;
        b=cs6xfU8BQKeZVxSxM3HytjJpuibh8HXDTr7OQ7Cf7/ms5ZRXWVjKVGCLLvJUOwGiEa
         mNADoLmRv0ZWsuSSjr7pbQpvWS2b+zKpr286N4vB+kYvAJzJGjzdhLPwu+IA7g6E8oqM
         ztIwC9FFKoXwXgA1p7gODuuAFco8L3F9qyX23nAehboR9dB+dreusocqaL0CtYn0x6LN
         PZs9AnCkprVXsVYb4WvO8C8LABX1elBf6UeU36RoAKWp4bLsSagCgelLt/wbEK2VErSe
         XvNe2qc0SBkpvhYrkgpDJ9Bxp3J8fgbm3KGVunWgXct9uCr9FK31hs82HpRww/rcCtHZ
         oAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772755526; x=1773360326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dG6HV+RqSVnjKBjCoY7wFe8G+mOmY+WOXjDpb83bWFE=;
        b=iDzZx4lyXPu0ajqtAFUOE/diwOLpWLnZtUcoZ4UDK2J2qgAgl4PyILW4lNrCk/9kJ9
         ow7TWkSIEMZzFwDDvBTC6d1YbIbxMWI+sjckX0nydkXuOe0sSv0Cfy1HQTW8RsPiowGt
         oaNiqZGPLgHf2lozWOXu5t5iUF948ZDEw92a6X6O6GOeL3i/HTSC9aoxCCXkVp/48ees
         a0GJjk0dR73mVz7Q1mfyG+enfBP+slBlsxwn+7ysoEseL0gs5vsOMAEcmELii14BJyIU
         M6M1deoKQ5mEh6OHpMSDGh1aIeM7eL/cri6VfgC/ET4GY92Ay1XA5IYks9C0qPO7HeZe
         1dfg==
X-Forwarded-Encrypted: i=1; AJvYcCVi3lG1Ph+zWpbIOHkeTWE1srwRQK4B+jmwTX/Qx62jkrS5vuhehZJeh22OVeNe4J3mJVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJgvmHPkIf8b9JTq23bWDmJmNcbGYnmNGHwEGonr735E8Dgos8
	TbrzZOuyUhAyzSgBP3p9pFTvYcp0Sn03acdXCX1IIZLowBm0zsF1EA4PCOsYjv1cgx/fg+IfXwc
	oEzbvkPT/pmAPPHInmXsiv5KbaVLg7TqS0jZlkBOs
X-Gm-Gg: ATEYQzwowxoCBkTtX9PTkDXk/+hQN0tU2PKEvBafjxnTvwPJav6TRZ4R9qutPpvmbeW
	l+HCMVZW/RYISK1fqalJy29eHx6GQzaPukLLAVUVwnR9818/7EYahebrj1LhAIICBoQxEe9Z3Xn
	GVLZq3YXBVDtQ6Jm9FiTn2D89Qns3vb1FhOpxDpce6Y+aZrnPwd6+RmPUEezuejLM6Q4nDL6TcF
	ea8m/YGrRKSNjq4IS4ZJSICNoB8JBMpsasDIKm0n5ih14W9Jcscdv+zAIAUvSTvgmgrqOCviCjV
	cltPWZHMsNXF85ctMA==
X-Received: by 2002:a05:6402:2755:b0:661:169e:acd3 with SMTP id
 4fb4d7f45d1cf-66194dae11cmr10582a12.9.1772755525736; Thu, 05 Mar 2026
 16:05:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com> <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
In-Reply-To: <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Mar 2026 16:05:13 -0800
X-Gm-Features: AaiRm53zeDwiR28gvqXNnz17vtEpxjLWGcDVG-awhmEK6Mc0TLfLgUpsR76OK4M
Message-ID: <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 970B2219AC9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72966-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 2:52=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Thu, Mar 5, 2026 at 2:30=E2=80=AFPM Jim Mattson <jmattson@google.com> =
wrote:
> >
> > On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > Add a test that verifies that KVM correctly injects a #GP for nested
> > > VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 cannot =
be
> > > mapped.
> > >
> > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > > ...
> > > +       /*
> > > +        * Find the max legal GPA that is not backed by a memslot (i.=
e. cannot
> > > +        * be mapped by KVM).
> > > +        */
> > > +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY_M=
AX_PHY_ADDR);
> > > +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> > > +       vcpu_alloc_svm(vm, &nested_gva);
> > > +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> > > +
> > > +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> > > +       vcpu_run(vcpu);
> > > +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > > +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> > > +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
> >
> > Why would this raise #GP? That isn't architected behavior.
>
> I don't see architected behavior in the APM for what happens if VMRUN
> fails to load the VMCB from memory. I guess it should be the same as
> what would happen if a PTE is pointing to a physical address that
> doesn't exist? Maybe #MC?

Reads from non-existent memory return all 1's, so I would expect a
#VMEXIT with exitcode VMEXIT_INVALID.

