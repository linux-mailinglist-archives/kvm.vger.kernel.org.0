Return-Path: <kvm+bounces-68941-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGigGiu4cmlKowAAu9opvQ
	(envelope-from <kvm+bounces-68941-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 00:52:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 528336EA08
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 00:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 743D2300C488
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 23:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFAD3DC995;
	Thu, 22 Jan 2026 23:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Anddpwk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650BE3DA7EA
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 23:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769125918; cv=none; b=tC1QCQWsAvixjl97b+/BJbRlAG06+93z/SYe57S0MMhvDpCbDR5Yyj/wtBEa8e58aOLWKN4EZsD0HCwwMfqg/fpY+hLF25WyefAa1xEGrbikeGueAxnoMQPS9GEEl60d3n/Og9ywkjr4VuzvTFc69yIrncgd8+i7D3sDO+oa+KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769125918; c=relaxed/simple;
	bh=eg/uF2a/r4RV0wMUdb2r4rz1ahydy14nqiUDK71upgI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VQPBg86NeyscxpdRywLbr/s3GNNfQsCgd/Rvlqn0NHP/xkwo+HQFT93lxzbfJvRKubWqzyDvcdiO2CQ9zw4jEUHcN53wjeiAdGNXzYzf+fNF5EDUFrVrdtx7qQHMlxSxvf1AZagPSEyODXQk78WDgEf+iinxl3kArWjLsJRa9cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Anddpwk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so1379986a91.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 15:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769125905; x=1769730705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5JvuW//joH48qvnygxaY0rXMq+dLySISFF3AXf42AjY=;
        b=1Anddpwkmc3idNJUtqUmplnCmDgf2pUTKguk/Y/Eqdlu2aGPErJNcleORevZrR/N72
         JVUXDejWWwjoFWjxfqwkx+zbAhcl092M1zUYxQPxzG6jtkTv2HZ43giflBbQCDfxyqi3
         2iEItji2xkNdgWwwrFGNfc6xRwl0apLYd3is5lDwOLyecT0Fre5wIRjQ2I9F1PvynsVG
         5RW+OVn3ZYBeQQ5UgLxSh6+1bQ1sFzGJs2wqkCIO94qFG0Q4uiGg1DEZL9aActAegz42
         axBLeX7mUYpOSz315Py0jaHai+Rnl3nMY0IBqm/py3vwclYc07RIyOIQmOpEoxKkuXPm
         QQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769125905; x=1769730705;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5JvuW//joH48qvnygxaY0rXMq+dLySISFF3AXf42AjY=;
        b=SVgJmmPgTiLNRaUHakoCIM6n7loRElTcNts/EpL1TFAc9328L+HYxft7ZHSgsCfeqz
         7qq9dRtOTUPupL+LYYWN5H9GI2tYxEjXy9YQ1XgOgz2WhBEoyWj58j9EUP4EY9aGukmm
         XPW89Q6GOB7inz/mvFgvSKN3exqud8JszCR+GNFdCSKbpnTs8z1NqoE47rLs+u8ECYJd
         yjhXVtpk88rJ8Fe+pWmAkBkkzOBQ3bbgyWTHvumhwnglaB9iz9d5BDlNN9cjoxrfdCzc
         jfCPx/38TOOc43z53COaxe/857fMD0B1dQ11pvM9p02Tr7SsmcBAmm1A8Hdfcb9Gkpvh
         i/9A==
X-Forwarded-Encrypted: i=1; AJvYcCXRObN3YM9TPh5L9mSVgAtRomKX9/k8Xi0CT105g+lHCO/n/qRXDjdM5uTGgjqp58BTdLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFgMO1ljbRMCzWVVeJkqWPPTESSHmbSvBIfhlGJVe5we35AeWz
	IIyYfwlPZHDMOrdeFzaP6/lxQ7BKUY206PsBJldwI6lkkJQo9ufp3aI5QH+HrwddAQo8skXlBhZ
	e7Q6LAA==
X-Received: from pjbpv11.prod.google.com ([2002:a17:90b:3c8b:b0:34c:489a:f4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57e6:b0:34c:c866:81f2
 with SMTP id 98e67ed59e1d1-35367015003mr843153a91.4.1769125905538; Thu, 22
 Jan 2026 15:51:45 -0800 (PST)
Date: Thu, 22 Jan 2026 15:51:43 -0800
In-Reply-To: <CALMp9eRGj3rNeNN82H12f=XO5iXi5s2ri2K71CnjoVp9eKzz1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-3-jmattson@google.com>
 <aXJRWtdzjcb8_APA@google.com> <CALMp9eRGj3rNeNN82H12f=XO5iXi5s2ri2K71CnjoVp9eKzz1w@mail.gmail.com>
Message-ID: <aXK4DzweZLy9O8n1@google.com>
Subject: Re: [PATCH 2/6] KVM: x86/pmu: Disable HG_ONLY events as appropriate
 for current vCPU state
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68941-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 528336EA08
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Jim Mattson wrote:
> On Thu, Jan 22, 2026 at 8:33=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Wed, Jan 21, 2026, Jim Mattson wrote:
> > > Introduce amd_pmu_dormant_hg_event(), which determines whether an AMD=
 PMC
> > > should be dormant (i.e. not count) based on the guest's Host-Only and
> > > Guest-Only event selector bits and the current vCPU state.
> > >
> > > Update amd_pmu_set_eventsel_hw() to clear the event selector's enable=
 bit
> > > when the event is dormant.
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/include/asm/perf_event.h |  2 ++
> > >  arch/x86/kvm/svm/pmu.c            | 23 +++++++++++++++++++++++
> > >  2 files changed, 25 insertions(+)
> > >
> > > diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm=
/perf_event.h
> > > index 0d9af4135e0a..7649d79d91a6 100644
> > > --- a/arch/x86/include/asm/perf_event.h
> > > +++ b/arch/x86/include/asm/perf_event.h
> > > @@ -58,6 +58,8 @@
> > >  #define AMD64_EVENTSEL_INT_CORE_ENABLE                       (1ULL <=
< 36)
> > >  #define AMD64_EVENTSEL_GUESTONLY                     (1ULL << 40)
> > >  #define AMD64_EVENTSEL_HOSTONLY                              (1ULL <=
< 41)
> > > +#define AMD64_EVENTSEL_HG_ONLY                               \
> >
> > I would strongly prefer to avoid the HG acronym, as it's not immediatel=
y obvious
> > that it's HOST_GUEST, and avoiding long lines even with the full HOST_G=
UEST is
> > pretty easy.
>=20
> In this instance, I'm happy to make the suggested change, but I think
> your overall distaste for HG_ONLY is unwarranted.
> These bits are documented in the APM as:
>=20
> > HG_ONLY (Host/Guest Only)=E2=80=94Bits 41:40, read/write

Ugh, stupid APM.  That makes me hate it a little less, but still, ugh.

> > Maybe amd_pmc_is_active() or amd_pmc_counts_in_current_mode()?
>=20
> I think amd_pmc_is_active() is a much stronger statement, implying
> that both enable bits are also set.

Ooh, good point.

> Similarly, amd_pmc_counts_in_current_mode() sounds like it looks at
> OS/USR bits as well.

Yeah, I didn't like that collision either.  :-/

> I'll see if I can think of a better name that isn't misleading. I
> actually went with this polarity because of the naming problem. But, I
> agree that the reverse polarity is marginally better.
>=20
> > > +{
> > > +     u64 hg_only =3D pmc->eventsel & AMD64_EVENTSEL_HG_ONLY;
> > > +     struct kvm_vcpu *vcpu =3D pmc->vcpu;
> > > +
> > > +     if (hg_only =3D=3D 0)
> >
> > !hg_only
>=20
> Now, you're just being petty. But, okay.

Eh, that's a very standard kernel style thing.

> > In the spirit of avoiding the "hg" acronym, what if we do something lik=
e this?
> >
> >         const u64 HOST_GUEST_MASK =3D AMD64_EVENTSEL_HOST_GUEST_MASK;
>=20
> Ugh. No. You can't both prefer the longer name and yet avoid it like
> the plague. If you need to introduce a shorter alias, the longer name
> is a bad choice.

IMO, there's a big difference between a global macro that may be read in a =
variety
of contexts, and a variable that's scoped to a function and consumed within=
 a few
lines of its definition.

That said, I'm definitely open to other ways to write this code that don't =
require
a local const, it's HG_ONLY that I really dislike.

> >         struct kvm_vcpu *vcpu =3D pmc->vcpu;
> >         u64 eventsel =3D pmc->eventsel;
> >
> >         /*
> >          * PMCs count in both host and guest if neither {HOST,GUEST}_ON=
LY flags
> >          * are set, or if both flags are set.
> >          */
> >         if (!(eventsel & HOST_GUEST_MASK) ||
> >             ((eventsel & HOST_GUEST_MASK) =3D=3D HOST_GUEST_MASK))
> >                 return true;
> >
> >         /* {HOST,GUEST}_ONLY bits are ignored when SVME is clear. */
> >         if (!(vcpu->arch.efer & EFER_SVME))
> >                 return true;
> >
> >         return !!(eventsel & AMD64_EVENTSEL_GUESTONLY) =3D=3D is_guest_=
mode(vcpu);
> >
> > > +             /* Not an HG_ONLY event */
> >
> > Please don't put comments inside single-line if-statements.  99% of the=
 time
> > it's easy to put the comment outside of the if-statement, and doing so =
encourages
> > a more verbose comment and avoids a "does this if-statement need curly-=
braces"
> > debate.
>=20
> There is no debate. A comment is not a statement. But, okay.

LOL, dollars to donuts says I can find someone to debate you on the "correc=
t"
style. :-D

