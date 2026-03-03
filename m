Return-Path: <kvm+bounces-72483-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHmkF3UvpmkrLwAAu9opvQ
	(envelope-from <kvm+bounces-72483-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:46:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD611E759F
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C54003033E4F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7EC21BD9CE;
	Tue,  3 Mar 2026 00:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIxPOCCH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB7F19C546
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498333; cv=none; b=RtAeVcS4VDDX20AaMRnf6wyqDbT2MZbmUOCDzOO3GlSl8jkginC5aN6b9+0w6cqPUvVzusbDC9lVjIkHalxckj6uFT9Cwy5nmErDMjWsxGfynuQz6lDT9EGK1aBZZUaFW2xZ2YpzNvBSWHh0VFwlNFiylfubBsuL2Mi6R5zlbeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498333; c=relaxed/simple;
	bh=OxpVU2IyrLmzkC21htZ+OnzAs6pNP/joTCxdnf5Fcx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hlpHPBu5putS07wlZwN7Q9fvj6vy7swwCcaDAO+ZFk3aTT8rOSqO+CqFksA/VqrzPKQTVgwu9VMgXnumCVKTzCnFOoLFPU+69NYt5Vt7XlMyhhMH13H6JXINoLvItPuQFdK0r5PMa1o6lEMWOD5XmNqVJTek80PMpZs/7MLidLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIxPOCCH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C6DC2BCAF
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498332;
	bh=OxpVU2IyrLmzkC21htZ+OnzAs6pNP/joTCxdnf5Fcx0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gIxPOCCH777t244LX0OqEC0eOP6fH6Ph+oTHV8IDUfEo2CXI1TGL+L3dBxyiczUGu
	 +IBeg4ekIEceIbhrnH++FQgRUuRh8BXrDBieWi2/iuYts64ZclVnfe7PariJ0X4gPO
	 NuhkrdzUbk8e7tRxhZVsMWJNNGnQpplE0/vYMOyr42xLvSKpoO4snamTSB9dcGTPWx
	 PzD+3J63bi8i53jfh48E+qMPXwClG8UpUT7L2nnDt53dW+LE179ZYtsOvHLfysEoA/
	 ATyvCyaO/kdzHjLmQsWSlPe8bE+IIo/5LpKreMTUi+tWH82ws8us/vWRj+I9A/K+GD
	 Xr6XTBWakYHOA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so605467866b.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:38:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVw2jFrwvcT/mFwQWwdyyoxEGhfdb0zswOIa28Bs5t/YL3755ewbrkQbmKYolHsSpCbGkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkJ7fZK1qTHLf2c6h6uczm2f2oJs4156VeMk+plN82sJvtHqUE
	lU1VmYfH7KH60rKx6/mC0O8dKAK9vaRiJ9Fjssfk36snguYg93kMiGB8v4LkgyV31LHwHRMo1cs
	CK7FeQhtDRjhSUcrHCbbh6BrHIMEeujA=
X-Received: by 2002:a17:907:25c2:b0:b8e:7dcb:7f1b with SMTP id
 a640c23a62f3a-b93763af8f8mr931263566b.21.1772498331545; Mon, 02 Mar 2026
 16:38:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227213849.3653331-1-jmattson@google.com> <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
 <CALMp9eRP7-u+6r8-RoVru6PLSPr6fu+EuRgtsNLJE_1EpMJq8Q@mail.gmail.com>
 <CAO9r8zNe9_vhspg4T=zswZ3Hr31XJGPz8=aDbqVvL1Wa9_mrAQ@mail.gmail.com> <aaYqzgO_Il2Pqixm@google.com>
In-Reply-To: <aaYqzgO_Il2Pqixm@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 16:38:39 -0800
X-Gmail-Original-Message-ID: <CAO9r8zN3XnwXWpkAM4KdNXEU0sOyTc72XnYckKNqfmRhOW8d-A@mail.gmail.com>
X-Gm-Features: AaiRm50Qr5aLE8YWy3lI-_0JMDw0nodugMQj6erU1eeKEuHXv0jsUKe0k4mIb7o
Message-ID: <CAO9r8zN3XnwXWpkAM4KdNXEU0sOyTc72XnYckKNqfmRhOW8d-A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Add retry loop to advanced RTM
 debugging subtest
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7CD611E759F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72483-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 4:26=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > On Mon, Mar 2, 2026 at 4:08=E2=80=AFPM Jim Mattson <jmattson@google.com=
> wrote:
> > > > IIUC this will be in the order of 100s of milliseconds. Do we need =
to
> > > > wait that long between retries? If the CPU is in a state where it w=
ill
> > > > always abort RTM, 30 retries will end up taking seconds or 10s of
> > > > seconds, right?
> > >
> > > I tried reducing the delay by a factor of 10. At 200 retries, I still
> > > see a 2% skip rate on a Skylake Xeon E5 @ 2GHz. I'd like to get the
> > > skip rate under 1%. But, maybe others don't care as much?
> > >
> > > Yes, 30 billion cycles is going to be on the order of 10 seconds.
> >
> > I personally care more about the test time than the fact that it won't
> > test RTM 2% of the time, but my opinion doesn't really matter :P
>
> I generally care more about runtime too, but isn't 10 seconds only the wo=
rst
> case scenario, and only on these fubar CPUs?  E.g. if there's no perf act=
ivity
> in the host, or the CPU isn't one of these oddballs, isn't XBEGIN going t=
o succeed
> ~100% of the time?
>
> If this were a choice between "eat N seconds every time" and "skip the te=
st",
> I'd be a-ok with a skip rate of 50% if it meant reducing N.  But, assumin=
g this
> requires perf activity and a Skylake-era CPU, odds are good this will onl=
y be hit
> in CI environments, at which point adding ~10 seconds to the worst case s=
cenario
> isn't a bad tradeoff (so long as it doesn't push the total runtime close =
to the
> timeout).

Good point. We can always revisit if we get really unlucky :)

