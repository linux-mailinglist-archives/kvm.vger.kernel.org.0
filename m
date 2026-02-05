Return-Path: <kvm+bounces-70292-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2H+HIMUahGmyywMAu9opvQ
	(envelope-from <kvm+bounces-70292-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:21:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE17EE80E
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9142D3005158
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 04:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79982E9733;
	Thu,  5 Feb 2026 04:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PCtKr3Bl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4661DF258
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 04:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770265279; cv=pass; b=Qv8fxjGKp4sNPyupnX+GIC7hkihfjFw2kQ6c1IvZIveZmam+9WguLuoR9CO6YUEF8sUiXkiuYSAY4z13j4PenZOVEXnlZ5jv9HJmhdQ5I6+O+1T6ZMSnyxlnc3mJBSElNBIjxnuMBuvvrvH7YoLmYIpiItk574y9EpnlQJiPag8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770265279; c=relaxed/simple;
	bh=7yhThvn4bzIjdduhCJxS1FI1eCt8UDuoIfG/EznMXOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tD6CBQWzYgA46nQWW2KXUwdltaZM15ganRJIarCd15QDKwDEmRwqqg2hwzxMMHa+2ztO2XA+gd4UGD/aw1GnjBQFxDcdyfsSTUz1hHxziq1s0xWEaAqRFuDf1J2ImSYq/+JHvb8lk9cTwweCAZkromiY5efdO/6zxNbCo/87Ecc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PCtKr3Bl; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso3696a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 20:21:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770265277; cv=none;
        d=google.com; s=arc-20240605;
        b=bLCZH7+T0hbb8uOj4JMNTuhlJ77z4vRlu5e7Z3u5Zq0+cdRA7DPEov7UNvFrIGJpkC
         i9X7RewZng/mZjPlYjQyCUTasKqR6ZDXsDrINiUOM1ZBh9Ymp68etRHQ5D1ssJvT0wx6
         OV1Jd4NVN6Lhx/7bGzv6xHschfof0sK8Nv07WeU8MZEMymQWcg6Uyt+ETm5RgbXOt3W0
         D1/+YxV9TozMYSDetlD2996qwXW94VCDnQ0rBL3x2jb6PkO5eB6HmVdgun9t3tZyMBLe
         o90g7Bc2IPXJY0KtgbDDUkWHLFtkK4en02MTmxp63YOU5Z/MevO7lqrtMG3JcyX2iV9u
         muIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6m1freqtmLCwlZInU9XCUDzTqiVQQJw+wkmys497tIs=;
        fh=zoCWLi9wZp74Fx46kqqESbmT2ZvlqJsAMyExJtqr2Y0=;
        b=bHVMCISgTnk6HXC4tbI8iS+2jkuU4rVIkSejLvBKiMYW6om02c4AmouELWwLkY0Nnn
         FlU/hJsKMY3/xnpF0Ty5Do9mEg8QR3q5ZdyH4Ty0Lf9MjDS628V+QidaIRVssSHi9HZB
         kN3zsac4kGhqWxBIRg4s8evsj+UYls28SwowcAo5BBSHGLXP/duAPbgvrv6AWRzQYNsN
         4pMwBDwOHYCQQUPa3BQ6aJJDReLVmXW1AtlAj+U1n/+hs+4ywtLzqBegwTHPb9nnrPac
         s1UFGI56jCAdlv4fuX4DIxZgSHPu9D9ziqVq4tq5oqK+OZ4YlCMm6asp3/KwN7oRVaV7
         LuTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770265277; x=1770870077; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6m1freqtmLCwlZInU9XCUDzTqiVQQJw+wkmys497tIs=;
        b=PCtKr3Blswnc/Qn73l0iihMLyHP943jtdbze+EVLDk1JrKUQt8sfCaDFqHZBBDeZw/
         WoKKb5O4pADzSR9BNpihofIdINoCJHLkH9+RuUBCviHZZNWBa52L/tgNId5/m9LDxr9h
         gZ7VC6CaIZrozlDgFXEGHvW9dlhI3hhQWH+PP/ldY9WJ63CQBKgr+gGmai4KZQUo9M8r
         m8PZqdGRSrZ9lAUuOkCN3oh7LSCuMa0FlGP66mcGyLxzMKuuieBEfRdYzGCGm6iIoLvH
         io5QeueqChb6nwIL+ewkwd22DNCca1trIkStz2j+AHOqO+6EXt3tNJBaZF+DQRSyXRi9
         ovWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770265277; x=1770870077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6m1freqtmLCwlZInU9XCUDzTqiVQQJw+wkmys497tIs=;
        b=YMiOa00IpgTpBHfmfNrh3WW5Xy1ggVUr2PD0rF6lDDui0y17mYds+2BALI1m7+GL/H
         lVsOUzVQVMFWnup9zSvbniYQlnbBMO5L5pPb+11q8MABjnB4fi+zkkzcLHYdPFKDD1XI
         v+BrW8uBWxOO7VigWsrVQgtl3AUdwuwI8Le9y7r3iHuMgVuI1L/BhEHukj45GyQhyoF5
         bp1MWzywli60ILpQEtt6s/rBcGF+i3ugMWIUoGVOVhz+9xo/pNdnMU4XUXYNQDhh2D6I
         0tGZJdXdOWtQqYuCqN+YlK1qw8jKRlhK25WToLdoCNlGhpoyYK6RmJ58pa/w9UwkIK+7
         aVXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxj31NZnZaFiWt3o/CszRBkf7W15rTWrWsdsqz7oaB4js7a3yRnL5tBOY9wDIeK5sHZ2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOSJPJDuqGzBb8DB6SQg8XV04t65aHvKTqcLWEMbgd+GnV02Yu
	SANicGLUwSZxniu9sGDSgJc3vM4kyLaE1Aww/hs6TZFfDDCKh7OGPEPHLVED5lfMM9stjGTUiO7
	2iyWYvRvRDvcnXhcS5Ryiu3SmlmNu+twRluISQlll
X-Gm-Gg: AZuq6aKWo4p8lm0TDqXryqT1tB8ElVhra2oB+Z+IsaWJgVoSrikYE98S6vT3zbD8uCO
	vif37Ez2coesM9jpBaj/8Daw0is6d884we8TBfD3Yr50oCfAE4Z1tMAbiwyALjUthUZoeT0fG4/
	Vn+ogVxfiFrLocTysoABmw+8lX5ulU+XKOob4PEIyyiqdgmQvXsAlUje0URntQTlG2boATFhor5
	uw4EQGOsm+FQ+VZqPHmMeOsCrKkefwvyN3uiIDo6Qj6Uc4XCDW9YG1VgFA7Q8ATiB2mIxg=
X-Received: by 2002:a05:6402:1ed2:b0:658:eee:f21a with SMTP id
 4fb4d7f45d1cf-659635d0118mr29540a12.10.1770265276979; Wed, 04 Feb 2026
 20:21:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com> <20260203190711.458413-2-seanjc@google.com>
In-Reply-To: <20260203190711.458413-2-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 4 Feb 2026 20:21:04 -0800
X-Gm-Features: AZwV_Qh7dtAdQTWWR_uTZ9ih-Fy5xiDTl4uF2BN41SYMZgZKmzbjZrLPg8Y-bYE
Message-ID: <CALMp9eTkbZzgukskiU_Uo_aekXnnqBqjW5jAeS029VCB=f04gg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Initialize AVIC VMCB fields if AVIC is
 enabled with in-kernel APIC
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70292-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: ACE17EE80E
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 11:07=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Initialize all per-vCPU AVIC control fields in the VMCB if AVIC is enable=
d
> in KVM and the VM has an in-kernel local APIC, i.e. if it's _possible_ th=
e
> vCPU could activate AVIC at any point in its lifecycle.  Configuring the
> VMCB if and only if AVIC is active "works" purely because of optimization=
s
> in kvm_create_lapic() to speculatively set apicv_active if AVIC is enable=
d
> *and* to defer updates until the first KVM_RUN.  In quotes because KVM
> likely won't do the right thing if kvm_apicv_activated() is false, i.e. i=
f
> a vCPU is created while APICv is inhibited at the VM level for whatever
> reason.  E.g. if the inhibit is *removed* before KVM_REQ_APICV_UPDATE is
> handled in KVM_RUN, then __kvm_vcpu_update_apicv() will elide calls to
> vendor code due to seeing "apicv_active =3D=3D activate".
>
> Cleaning up the initialization code will also allow fixing a bug where KV=
M
> incorrectly leaves CR8 interception enabled when AVIC is activated withou=
t
> creating a mess with respect to whether AVIC is activated or not.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

