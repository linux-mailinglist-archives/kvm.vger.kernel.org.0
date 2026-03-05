Return-Path: <kvm+bounces-72929-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEnjHjHQqWmYFgEAu9opvQ
	(envelope-from <kvm+bounces-72929-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:49:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C1912171E5
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5DDD23029A42
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 18:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71FC2DC35C;
	Thu,  5 Mar 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ynk6jH5H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C6F27FD52
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 18:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772736557; cv=pass; b=Hy6YyBDlK1ID94TR3s9ykzDDz93pou8EPyXniHTYDOg+kVIBAH9xHa16XyUA7vvvVOx4sqlt/+ZBcIs8dTDjAPSPj+JKavx5MJYmRIkWe8K9Pyny+vSvz3kGsTopxFNCe0iRnAugwkBaTMD34/0rFsjZO3GqURT2XJxngoUtDrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772736557; c=relaxed/simple;
	bh=eAk+jD9Rcem2AMZY6UAt3WgRdXjAWpdgOQGbMet11qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWdyqFBgKL0Gl3EJ50Rl0D3fMv7FElmKi1MONSxTjOi+JU+BNrbbfZ4ZwkYELh9GcuLIQ/8T5dRV/yn/xkT4ruC7jz74AMcIG8d/Brm0CbAbVTf9fwFnBMkF8JygbQMvQqYRLZ/OQhpirLR1VDWHYwsSypRxYm+kGb0XQgWld38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ynk6jH5H; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so1045a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 10:49:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772736554; cv=none;
        d=google.com; s=arc-20240605;
        b=YehHBWIcGYHkhkaZji5SzXVIcwgfcPIlbquDe6xLPuWBTfn100IqXh7NQiFA4ZL3po
         e7NveKF3Xm7fI1ynRye8cSWXG7okryrDeRbdZkN9p6SseCokCX0PhbZIncApwVQTCBOf
         Ku6BfVJ6rp/O/2HB197b0xjZ2cwh0mbrTKC4vjj42fMI+ToLUoh9nTaJ6/4cOI/kWYgP
         3Y7Nwi0tU2EKF4A+51OisIhzi3hICF33C2ull8uTil9sOaYJjv8tJbwXdaijQjBoiF0W
         xel9YcHbgXQmDeYDQLwbcappOUSWIRj2egrCRyOKWS38tMFBczAjTxCjuOjiFPwjm0OE
         +5FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3NngYta4vdsWAWIxQPmUbWutCRgra+ifU7R7mQBuGRQ=;
        fh=8bCB+Qfc+fvydz/0Jn/6PwJPignilqnBO4Zc4y4/kpg=;
        b=bTAdio6HtOysne2Gc2vNCx59p1R1CHZymFBkQhToVAXhUPAkNKrk8l4fnVAlXybwmL
         S8lb1sGilMjCf0w0LuhTEACDEqLlcLJ8+LqrynFKLpeBTCZguDIP72jer+8B/lTNqob/
         VMvBsqtaTcboo5pLeBhNVH1BJEZ9HOYr07rvf9ryFY1cF5uD6/1ZwxDaZKE1F4p+5x5+
         bvYCqgJ9b5Geh6Zu/YhlxhMvodn21KCcLnkSI1yZBB1FgpewMdUflG0ZJ9y75sfF/9OQ
         MM9CgPOZGlQ9OzbSTHdq65oFRj9XpBzMrHinaNeQsMGfaqbM2CgnzclE0EaRdENBThev
         c7uQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772736554; x=1773341354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NngYta4vdsWAWIxQPmUbWutCRgra+ifU7R7mQBuGRQ=;
        b=Ynk6jH5Hwm1P1VxoyaKyXWalxr2MrTSy7RJ9mwO63D0ENhsEY7LkyE7UPUsz71VAI0
         W7vd9L//7S325Biuj082DGqm51dH50+4YTqcth2Of16iRrCpeysD8FWvzgO88zGJA1zo
         nWjTtr2FIcibiHGdJ0yahdm2ML1DiKTIX8+ORIHyOmEZcAgf7HoqDdOKOAYAMIcoArhA
         eRNR6xOmy88wtDpM+73lH1Zd6NGNqntIaqOeEkrYfxnMQsERXdNp47h4MsdOQ9iaRijQ
         1AqkezKPGauc+CwW3yThcDFiA7ATLKe84+1kVTiR3Klja5Tnhy3Ihu6jOq5fzD3CIOS3
         YogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772736554; x=1773341354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3NngYta4vdsWAWIxQPmUbWutCRgra+ifU7R7mQBuGRQ=;
        b=xVUPGYSGF0u/V3oBTyx5IBt1wNhWQv0+YMmN0tsDm670U8XePrBPdz2qoMci/gaepw
         IW/QIbBBDnZOOs3pdGw3Z+mxpUsTZWvrLjD6NWG21ObNfABBBjO/TUQ4pow/Bq5pKX7G
         8cJFoRl+3Jo9d+LaAYVxM4AkIl0lyQsvMiK6LcjgFYLavP1rUY6PPDAO/ZoWCX5RWbA+
         T7WRoWNsWIj4WvA1gX/Y1mRO2dFDTWsqzvKITdL+lg/qMnBTJAzTpz/wlxJO/MBti/zZ
         LvLgcvjkKhV/g6IeKOHV5+OTsIUq0Fh08kosEYM9AJnJeBKRhteyCP+Uec06Dt6lu1Ve
         hqxg==
X-Forwarded-Encrypted: i=1; AJvYcCW6PdALSCf93aExQF1UJ7/j7mPZnP9AcAeTZ592zVu6MQuo3M7YomKlLtrw2Q8TBaBo8HE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKNWO1kSayrVed5Je5dXYBgQF/8jRe3zlyig4um3s/lO6SuxTG
	tbXdd9Mu9jxRxXqqz6xeY3NNVfBqa6bVfnZ+xXj24TkShAOvA9lUPpXLhnMxCr7jUWNExEGU7yW
	m/2Hat4tpZ1uHs94xqf2YEuIRxzKLhEMARCLUQWLR
X-Gm-Gg: ATEYQzzkcSjsuhhbt2oyhfCqzuefwbIWq+1Xg/PDTXskk3aHO+XAUH1N5zpPnPHLxUY
	033lrivUpqoLM6bFIDFtAXFfyd1AeaFFCyY3E1emk7zZdsKTFwfT1Q20S01iPyhOFWtciyHWi27
	1uABeZcMehV3cWRxVIALF3tliA6EE72gTRjp097tohCOlQInyZMzKyDcz1z+mkGmegDt2lcTGQj
	BXq3SEpRdRCErjROrU7XzTUA57EWU6hOl2dfmtJEshc8wAUiyjmqWUoC9RT+xmzl8Ngq9hY1PHD
	zAMtnVs=
X-Received: by 2002:a05:6402:794:b0:65f:7099:bc8c with SMTP id
 4fb4d7f45d1cf-6618dc4a4b7mr2986a12.8.1772736553564; Thu, 05 Mar 2026 10:49:13
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-9-jmattson@google.com>
 <aahn2ZfDAJTj-Afn@google.com> <CALMp9eR7gKWp8M2Q8Q7vA5hGx5bc12KCh1NZMK33A1dpiKNt+Q@mail.gmail.com>
 <aaiD0k-BE4RZJPfv@google.com> <CAO9r8zP+tdUtDwxzDVKbtCk7Ui5y=Zw_aZ+ptL4-H6-R5vXWTQ@mail.gmail.com>
 <aaiOQKHoSrpPNR9b@google.com>
In-Reply-To: <aaiOQKHoSrpPNR9b@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Mar 2026 10:49:01 -0800
X-Gm-Features: AaiRm53Cb21BdMl5XJu3HttHkszR5QTije8R4B0bcLgCFedybvlXLo3WaDLb-sw
Message-ID: <CALMp9eQ5e_Gdvj=Cc00Puba=-A6rZ-VrV=gkvf_O3_fm9vA=6Q@mail.gmail.com>
Subject: Re: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3C1912171E5
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
	TAGGED_FROM(0.00)[bounces-72929-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
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
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 11:55=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Mar 04, 2026, Yosry Ahmed wrote:
> > On Wed, Mar 4, 2026 at 11:11=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Wed, Mar 04, 2026, Jim Mattson wrote:
> > > > On Wed, Mar 4, 2026 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.=
c
> > > > > index 991ee4c03363..099bf8ac10ee 100644
> > > > > --- a/arch/x86/kvm/svm/nested.c
> > > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > > @@ -1848,7 +1848,7 @@ static int svm_get_nested_state(struct kvm_=
vcpu *vcpu,
> > > > >         if (is_guest_mode(vcpu)) {
> > > > >                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_=
gpa;
> > > > >                 if (nested_npt_enabled(svm)) {
> > > > > -                       kvm_state.hdr.svm.flags |=3D KVM_STATE_SV=
M_VALID_GPAT;
> > > > > +                       kvm_state->flags |=3D KVM_STATE_NESTED_GP=
AT_VALID;
> > > > >                         kvm_state.hdr.svm.gpat =3D svm->vmcb->sav=
e.g_pat;
> > > > >                 }
> > > > >                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZ=
E;
> > > > > @@ -1914,7 +1914,8 @@ static int svm_set_nested_state(struct kvm_=
vcpu *vcpu,
> > > > >
> > > > >         if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
> > > > >                                  KVM_STATE_NESTED_RUN_PENDING |
> > > > > -                                KVM_STATE_NESTED_GIF_SET))
> > > > > +                                KVM_STATE_NESTED_GIF_SET |
> > > > > +                                KVM_STATE_NESTED_GPAT_VALID))
> > > > >                 return -EINVAL;
> > > >
> > > > Unless I'm missing something, this breaks forward compatibility
> > > > completely. An older kernel will refuse to accept a nested state bl=
ob
> > > > with GPAT_VALID set.
> > >
> > > Argh, so we've painted ourselves into an impossible situation by rest=
ricting the
> > > set of valid flags.  I.e. VMX's omission of checks on unknown flags i=
s a feature,
> > > not a bug.
> > >
> > > Chatted with Jim offlist, and he pointed out that KVM's standard way =
to deal with
> > > this is to make setting the flag opt-in, e.g. KVM_CAP_X86_TRIPLE_FAUL=
T_EVENT and
> > > KVM_CAP_EXCEPTION_PAYLOAD.
> > >
> > > As much as I want to retroactively change KVM's documentation to stat=
e doing
> > > KVM_SET_NESTED_STATE with data that didn't come from KVM_GET_NESTED_S=
TATE is
> > > unsupported, that feels too restrictive and could really bite us in t=
he future.
> > > And it doesn't help if there's already userspace that's putting garba=
ge into the
> > > header.
> > >
> > > So yeah, I don't see a better option than adding yet another capabili=
ty.

Capability or quirk?

/me ducks.

