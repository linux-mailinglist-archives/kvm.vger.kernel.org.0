Return-Path: <kvm+bounces-5895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6868288BF
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 16:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B6801F23892
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B8339FD3;
	Tue,  9 Jan 2024 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L6Hzum1N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3236039AEA
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9a003ad63so1572904b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 07:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704813046; x=1705417846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ylzsLrKUHQNcq0YsobTPwM7oLV0ySb7Z86Oi7b0IPw=;
        b=L6Hzum1NTMbd0B0ayEY0+MIu5ugyDPwASja34+AZTePAP6kw3Z7tT2viOn2iz1Q8LS
         EQ834g/PsDNFr1S+PjlfCrT8DRoTJQFLtwUTI+GJVJlYQMcM6ik7/3YzeJNNXtF6LxMH
         CG34//YAx+NTUZFv5iZcSizOtly/AzlBjtKA8DHSaUuA7oc/DyWsh70Qeu2dYGEUf0sE
         BFgTUSSDIJSBrwc+DZNeWAQtCAi+2uaXh9PeKwLEUCH1OUC9qdPAEsD0zJ5TT+2AWzNb
         W1NmKEuh/oeRrhWXc6z7C9lH/9eihZd0oUV0FCjfgYIsIzHPmnUXBOgyWBdy7dbREtvJ
         Bgnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704813046; x=1705417846;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ylzsLrKUHQNcq0YsobTPwM7oLV0ySb7Z86Oi7b0IPw=;
        b=LHv403tnS9Nj+O8wA4v7QMjNNc0CzyPoV9R1an1QGgzy/+pgyZI/U6h3nFEZo/OTZg
         Ac/L5RNL//G5eWoZJ+qAna9eiF+ORkXmSSASTMtgy/vAzr9H5f3T6gGQwZUz8oYpNBK1
         ZSImghLNX9TCP7JwV9PkIQubZnJVFPPS7wMerTHOE1zbGC/UyobGTXXrdkLO9Z5uJInu
         T+FOUdMzvh2ut7vnuxuG7uAPHAjD6JjlrvjGS0/GacZQR9SWvQkJOlc9/m//Q9cYStD0
         FrfRVwni5C0Lattp5Btebebsc3pFDhGQHPkn8ioQpOshy9UXr9kgch8XqADMsklfxHhQ
         xx4Q==
X-Gm-Message-State: AOJu0YwT1Ne5hFVZlJHIPx5dxE/hXmIUyQnnDg0ydnHVhgOaCeGVegPL
	XhVr/zcwvYNF9iB5FpyCJYU4HNqeUl3D9Fd1og==
X-Google-Smtp-Source: AGHT+IE/xvqBNs0r0t/c46uJkAlBiNBDis11Iuiql7kFyteTbaSCdcuVoFmq4nkjKlTdQokAqQmvg0YXa/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2447:b0:6d9:a74f:9b49 with SMTP id
 d7-20020a056a00244700b006d9a74f9b49mr392672pfj.4.1704813046283; Tue, 09 Jan
 2024 07:10:46 -0800 (PST)
Date: Tue, 9 Jan 2024 07:10:44 -0800
In-Reply-To: <06fdd362-cb7f-47df-9d1a-9b85d2ed05b5@intel.com>
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
 <ZZdSSzCqvd-3sdBL@google.com> <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
 <ZZgsipXoXTKyvCZT@google.com> <06fdd362-cb7f-47df-9d1a-9b85d2ed05b5@intel.com>
Message-ID: <ZZ1h9GW93ckc3FlE@google.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"john.allen@amd.com" <john.allen@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 08, 2024, Weijiang Yang wrote:
> On 1/6/2024 12:21 AM, Sean Christopherson wrote:
> > On Fri, Jan 05, 2024, Weijiang Yang wrote:
> > > On 1/5/2024 8:54 AM, Sean Christopherson wrote:
> > > > On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
> > > > > > For CALL/RET (and presumably any branch instructions with IBT?)=
 other
> > > > > > instructions that are directly affected by CET, the simplest th=
ing would
> > > > > > probably be to disable those in KVM's emulator if shadow stacks=
 and/or IBT
> > > > > > are enabled, and let KVM's failure paths take it from there.
> > > > > Right, that is what I was wondering might be the normal solution =
for
> > > > > situations like this.
> > > > If KVM can't emulate something, it either retries the instruction (=
with some
> > > > decent logic to guard against infinite retries) or punts to userspa=
ce.
> > > What kind of error is proper if KVM has to punt to userspace?
> > KVM_INTERNAL_ERROR_EMULATION.  See prepare_emulation_failure_exit().
> >=20
> > > Or just inject #UD into guest on detecting this case?
> > No, do not inject #UD or do anything else that deviates from architectu=
rally
> > defined behavior.
>=20
> Thanks!
> But based on current KVM implementation and patch 24, seems that if CET i=
s exposed
> to guest, the emulation code or shadow paging mode couldn't be activated =
at the same time:

No, requiring unrestricted guest only disables the paths where KVM *delibea=
tely*
emulates the entire guest code stream.  In no way, shape, or form does it p=
revent
KVM from attempting to emulate arbitrary instructions.

> In vmx.c,
> hardware_setup(void):
> if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enable_unrestricted_guest =3D =
0;
>=20
> in vmx_set_cr0():
> [...]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (enable_unrestricted_guest)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 hw_cr0 |=3D KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 hw_cr0 |=3D KVM_VM_CR0_ALWAYS_ON;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!enable_ept)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hw_cr0 |=
=3D X86_CR0_WP;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (vmx->rmode.vm86_active && (cr0 & X86_CR0_PE))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enter_pm=
ode(vcpu);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!vmx->rmode.vm86_active && !(cr0 & X86_CR0_PE))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enter_rm=
ode(vcpu);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> [...]
>=20
> And in patch 24:
>=20
> +=C2=A0=C2=A0 if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest =
||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !cpu_has_vmx_basic_no_hw_errcode())=
 {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_cpu_cap_clear(X86_FEATURE_SHSTK=
);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +=C2=A0=C2=A0 }
>=20
> Not sure if I missed anything.
>=20
>=20

