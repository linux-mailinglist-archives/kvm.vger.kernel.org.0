Return-Path: <kvm+bounces-5699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A54824C40
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 01:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BB6B1C21AC0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 00:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92E61FB4;
	Fri,  5 Jan 2024 00:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AUB3Y+B1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59A1845
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28c35186b09so652646a91.1
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 16:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704416094; x=1705020894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ee/8DoVUu/+3ZRM6tajVkLwvVI4m4v9ZGKpZPXTQPEo=;
        b=AUB3Y+B1u/AgTlK4AZOl0VltHPrfeFkdx5MqSmME4OJ4OBGlEce0BODcj6e3p1VBcX
         0AwiDsuLasQPkYrfi5DyabgVfc9KHKuMpOtnnrOi+qXRE+UfcMWsGAIlUZNh1L9Wdo8q
         y3n90PXhUGS5erqFCkzU9dozEA47CIRswjewkRUhAb3HPAkbV5NzlfxjOdeQGx+AU1MK
         2Jv0viALWqSuKi4wZlN42P21sfe0uU6OoDRwitkzeS7qzGoTLy0Nqi5BCgyUvIaboKfJ
         wLjAfnjEeKJmzxHOTWyrTMYBfYfG91FiX9RP0bBNDnNaQx8WNykUlCjbcyQYi2LaXr3q
         CeIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704416094; x=1705020894;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ee/8DoVUu/+3ZRM6tajVkLwvVI4m4v9ZGKpZPXTQPEo=;
        b=J4f299SiAYGJkoZ/8WRlzY2gz9lmJhxiETuswtWmcjpKL8FsolE2bqNlhYp5tbOABW
         IPzMLr9rwXPIxgUn1SiL+VrGwg+1T9ddTPYiPWKwQ5/PiIo97tVk+gXHryJne8vJ+hrx
         sBfn+C8gsQSZVhGvsNc1Imrs6xueZY1eLOQmmcZSf5+yziPzSJiYIstrcie/WJO5oM9G
         praMDxuodMAuX5c1nmBIqlvuHTKYP2hiXK5VfleMLcTGh44YZ7AsHpryCdLGyflCVKnI
         ea6E/D94Rv1cU69SdKp3hDkNhNHvbP0sBSzoxkHGSP51sAziq5sGi+MBYgE0ARNPCc1S
         qdxA==
X-Gm-Message-State: AOJu0Yx8XDUqhGR6MKYf6RhTQrz502W7ci4oiyfayuotiyFMVMsRY2PQ
	72KpavGXvSAhD85Af61TLzYgOC49vi9RizLguQ==
X-Google-Smtp-Source: AGHT+IF6f0t2GPlj2yIG+6jI2DtC4qZK/Dt/Sz+kJOphtaSvbettwqJ3T7+DlfuI3bw9WNBRk0L/yn/u+Dc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:51e5:b0:28d:2d4:4f89 with SMTP id
 u92-20020a17090a51e500b0028d02d44f89mr1236pjh.4.1704416092912; Thu, 04 Jan
 2024 16:54:52 -0800 (PST)
Date: Thu, 4 Jan 2024 16:54:51 -0800
In-Reply-To: <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com> <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
 <ZZdLG5W5u19PsnTo@google.com> <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
Message-ID: <ZZdSSzCqvd-3sdBL@google.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Weijiang Yang <weijiang.yang@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-01-04 at 16:22 -0800, Sean Christopherson wrote:
> > No, the days of KVM making shit up from are done.=C2=A0 IIUC, you're ad=
vocating
> > that it's ok for KVM to induce a #CP that architecturally should not
> > happen.=C2=A0 That is not acceptable, full stop.
>=20
> Nope, not advocating that at all.

Heh, wrong "you".  That "you" was directed at Weijiang, who I *think* is sa=
ying
that clobbering the shadow stack by emulating CALL+RET and thus inducing a =
bogus
#CP in the guest is ok.

> I'm noticing that in this series KVM has special emulator behavior that
> doesn't match the HW when CET is enabled. That it *skips* emitting #CPs (=
and
> other CET behaviors SW depends on), and wondering if it is a problem.

Yes, it's a problem.  But IIUC, as is KVM would also induce bogus #CPs (whi=
ch is
probably less of a problem in practice, but still not acceptable).

> I'm worried that there is some way attackers will induce the host to
> emulate an instruction and skip CET enforcement that the HW would
> normally do.

Yep.  The best behavior for this is likely KVM's existing behavior, i.e. re=
try
the instruction in the guest, and if that doesn't work, kick out to userspa=
ce and
let userspace try to sort things out.

> > For CALL/RET (and presumably any branch instructions with IBT?) other
> > instructions that are directly affected by CET, the simplest thing woul=
d
> > probably be to disable those in KVM's emulator if shadow stacks and/or =
IBT
> > are enabled, and let KVM's failure paths take it from there.
>=20
> Right, that is what I was wondering might be the normal solution for
> situations like this.

If KVM can't emulate something, it either retries the instruction (with som=
e
decent logic to guard against infinite retries) or punts to userspace.

Or if the platform owner likes to play with fire and doesn't enable
KVM_CAP_EXIT_ON_EMULATION_FAILURE, KVM will inject a #UD (and still exit to
userspace if the emulation happened at CPL0).  And yes, that #UD is 100% KV=
M
making shit up, and yes, it has caused problems and confusion. :-)
=20
> > Then, *if* a use case comes along where the guest is utilizing CET and
> > "needs" KVM to emulate affected instructions, we can add the necessary
> > support the emulator.
> >=20
> > Alternatively, if teaching KVM's emulator to play nice with shadow stac=
ks
> > and IBT is easy-ish, just do that.
>=20
> I think it will not be very easy.

Yeah.  As Jim alluded to, I think it's probably time to admit that emulatin=
g
instructions for modern CPUs is a fools errand and KVM should simply stop t=
rying.

