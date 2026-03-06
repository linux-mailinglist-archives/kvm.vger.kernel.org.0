Return-Path: <kvm+bounces-72972-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNPuCxgyqmlvNAEAu9opvQ
	(envelope-from <kvm+bounces-72972-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:47:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0AB21A517
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 51FAA302B23D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 01:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1742FB08C;
	Fri,  6 Mar 2026 01:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dEHQOgxz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B7735943
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 01:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772761612; cv=pass; b=bWwn+udxn2JdpHxPkbosqyIZ5Pk3UuF9bynplAOe0whI/8Y5RAWddAK0o21tPrv0dVFQ4m2GsnfsJw1Qf5Mhcr+Fh0jXYlSSnc90OJ4mxVu7CUvvy2mHohVhzUQmyr14gggG5qEfGrV16iwieD9LDxp3ImB9ni6Yjsa4/dKDovM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772761612; c=relaxed/simple;
	bh=WkaP7zEezpVIyXWreLFCCACEAdtJ5IePGoJtuw1lMNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kvNGFIlXXmGnpINRO9ZYymeM2UtB4Rv6BIrOH9+o4dNUd4/9Oe0ToqJcwipoAINofMgIH0RTBtF6M2pwWzNcujbpgngDHFN8uzsjXRnablzduZPxy3Eq/K6tJZuQUw6DpVFU73AVAaox8NxcJED+FJlG3Alzky5Tfqp9bBGQdbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dEHQOgxz; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so3586a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 17:46:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772761610; cv=none;
        d=google.com; s=arc-20240605;
        b=NM9EgDYCqz60GXYLxiH69ZEjJJJQyecDzvFy9mP8ubnBNtLOCn8wCCpBBnb4DLg2+9
         YvxxCT8G1KNYrmC57C6csL/dADg+Zklk4DeGaiUiqA4QrM3JHHauHWwpasW7l2bZN98o
         Zju19hVGc0J4SBWAeDfjpj9gWXWlLZv9llxFPSM6P0Nh1NfeY1SED57Vr7VoBXgKibCz
         aMeIQt088kGejL23quXqOZUpkLVEeE9R5F+rzrN3VVEbZCuT6x6xw3Pz3DOPZdkGO1+g
         wzKmmFHz07CoizhV1DWhEimAIgelLqnq/DFe1Pxo+uxLV+mU5MLk40dtbA9cO3sCz7Bf
         77xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AaHSTv/EeMPuLl2B18Ue125V24xs7ygiuF+itv0d3U4=;
        fh=TopeXjTeqrjk+vbKfiqTGdZceMRKzrEYiGTwy7jqSuk=;
        b=M/UNc9CpDRLiuF4noMG2rHtaYhnxHwZNl2GIXmy5g5c6OVGFIiORNHS3p8v/ZdyNob
         MJyrhvQnv/KAdHqWcn0xO+gkBnJ1J1QKj9aU2UpMhbnkUlj0H6UnV07s9B/nRnj+kqGB
         TsmL8B1N+uHsAfJWtX89qEQY5tusB8sSAYQT0SVw73IbhrB5gzZScKQyC4SGAWQal8vM
         EBA32UjzD9K5uBeRk04fhPGBPzhWBnxya6hlammajC9wmFBqZTBZI/mYo1SQ6imMJzOI
         MLj918Td7IaUi+IxDUs8N2Xi0/6pJQccwXrzKWngtv7q5VmfKYf9mVZfnVm3KJ00fs/6
         0L4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772761610; x=1773366410; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AaHSTv/EeMPuLl2B18Ue125V24xs7ygiuF+itv0d3U4=;
        b=dEHQOgxzxusd5uZcATOazvXIQWHqA+HM/A0up6ngLlxKD7ya1w6WxLOgaCIH8UhAxf
         nI6X3sNA8ZX5kwHHwvQE6HeX37EFgJtnGN+lcHGt7gf01RkglNxHuw659HpneVFygTqd
         qAsx72D3TwOFybM4UmfBTrD2m1WmxnFPoy60/jJTuCQpTUnF6YwqPdysquFFXphus2wA
         GaCFcGuYspFd1WJDjcbyod4zp+9VvyTephxIFPPqCv7f5X5xOIUNvOfV1FynM0/O6Vp0
         Q4Wwy9G9MgJZYs4/KW4D4KEkaJdqt3+aTZHz0Q7IyWfrqfOltPp2pfbgmF8LUTxwLKiJ
         qARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772761610; x=1773366410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AaHSTv/EeMPuLl2B18Ue125V24xs7ygiuF+itv0d3U4=;
        b=k/Y5R31hcx8xVaB+aztJLkJuhpEp7DVhsTUNEEMP0cYGLpBUDBtKYfJF8H6VT4DqVO
         B//M5rv2oKrisOwgJzMJzbix6yUcWIvt9gZ2Iomr85I/NiRJrTq0Ekm6Th3QsSwRIFgB
         1lGbmk0IV8h94qLr/qInp4X/imLp53u/TxY6oUiKv/ZOXsf8CTvjT/hOb6PoOdtw/MT1
         aBe4bI86MB8gFeO1CrROQd9ATLQlSZkNy9a6Dd93+dJ/rz3n3l07zymyBZpCLA0OWk6v
         XASMGOUyd9tTBJunw8FHxqFw3jX3/wbnWmihjUDjiPml51C+GIRWpqdtzHxz/ge4uMq1
         7M5A==
X-Forwarded-Encrypted: i=1; AJvYcCVsxmV2PcuthbyNeQFa28+aEgVKRqT1Zi49qI96WUWSQBxcAuKpXK9I2ssHn6kX75Prx2I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1KrCYyhDA2rbV9+wSQNSEfNMZfP6F6KfXqTBM3o8pEqPnC+C1
	43iDsaVYPElbjt9mh7us/ZkoXqoNPMQWMa2BU5woblQckUllRcQx4ycHI+UwIuoEuORLWDm3W76
	ds0Wf6TTs24jmOmW+nbD4svPVPdEQYCmkFSedqca4
X-Gm-Gg: ATEYQzwVvtFwFkr0FRJgCpq4VRhePhWHvKWkIzc5mWm6D9ZOtV1PSm4T7WiVuDLhfJK
	z37PbGQZVcvZgRkNrmZ+Szbb/O6tcTYqn6FkSeUn4sj3l1GZKc8wvF1iSw0BfJbyy/UcdRPvh+7
	VenG2GX3aAqWBn2i/cHqP23gZcub/9pJIeTMMBfqzoBW0W+PY2h6yk5TLzN1UDI/UEfRqckNIeE
	QhVcWjs2U4DNzM4B9F2+NzDDvYFv55d33nQ4sEaht8wks3tVWSMtVw5sPZapdQuVnz3DS3OCmiy
	3ZxwEJk=
X-Received: by 2002:aa7:d65a:0:b0:660:c6b6:9976 with SMTP id
 4fb4d7f45d1cf-66194db73cbmr8461a12.11.1772761609584; Thu, 05 Mar 2026
 17:46:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
 <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
 <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com> <aaowUfyt7tu8g5fr@google.com>
In-Reply-To: <aaowUfyt7tu8g5fr@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Mar 2026 17:46:37 -0800
X-Gm-Features: AaiRm52vz8xWd7bRehhc76ce5Lf-XmEshK5PaVit01FjHWGenNn_XVYszcFOnM8
Message-ID: <CALMp9eSiN3gNYWO8eR7LyA74aLP=jc55byryOGM_EaGc9nAAXQ@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9D0AB21A517
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
	TAGGED_FROM(0.00)[bounces-72972-lists,kvm=lfdr.de];
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

On Thu, Mar 5, 2026 at 5:39=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Mar 05, 2026, Jim Mattson wrote:
> > On Thu, Mar 5, 2026 at 4:40=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > On Thu, Mar 5, 2026 at 4:05=E2=80=AFPM Jim Mattson <jmattson@google.c=
om> wrote:
> > > >
> > > > On Thu, Mar 5, 2026 at 2:52=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > > >
> > > > > On Thu, Mar 5, 2026 at 2:30=E2=80=AFPM Jim Mattson <jmattson@goog=
le.com> wrote:
> > > > > >
> > > > > > On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kerne=
l.org> wrote:
> > > > > > >
> > > > > > > Add a test that verifies that KVM correctly injects a #GP for=
 nested
> > > > > > > VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12=
 cannot be
> > > > > > > mapped.
> > > > > > >
> > > > > > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > > > > > > ...
> > > > > > > +       /*
> > > > > > > +        * Find the max legal GPA that is not backed by a mem=
slot (i.e. cannot
> > > > > > > +        * be mapped by KVM).
> > > > > > > +        */
> > > > > > > +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PR=
OPERTY_MAX_PHY_ADDR);
> > > > > > > +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> > > > > > > +       vcpu_alloc_svm(vm, &nested_gva);
> > > > > > > +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> > > > > > > +
> > > > > > > +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> > > > > > > +       vcpu_run(vcpu);
> > > > > > > +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > > > > > > +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> > > > > > > +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
> > > > > >
> > > > > > Why would this raise #GP? That isn't architected behavior.
> > > > >
> > > > > I don't see architected behavior in the APM for what happens if V=
MRUN
> > > > > fails to load the VMCB from memory. I guess it should be the same=
 as
> > > > > what would happen if a PTE is pointing to a physical address that
> > > > > doesn't exist? Maybe #MC?
> > > >
> > > > Reads from non-existent memory return all 1's
> > >
> > > Today I learned :) Do all x86 CPUs do this?
> >
> > Yes. If no device claims the address, reads return all 1s. I think you
> > can thank pull-up resistors for that.
>
> Ya, it's officially documented PCI behavior.  Writes are dropped, reads r=
eturn
> all 1s.

LOL! PCI bus?!? These semantics were cast in stone long before anyone
even dreamt of a PCI bus!

