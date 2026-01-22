Return-Path: <kvm+bounces-68936-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MGNIM3adcmkFnAAAu9opvQ
	(envelope-from <kvm+bounces-68936-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 22:58:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 798326DFDB
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 22:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EFEE8301952E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 21:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F353A89B6;
	Thu, 22 Jan 2026 21:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="39uLLe/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF753C23CC
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 21:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769119081; cv=pass; b=c+9T4x8XSO8oC3EtdkQkbLYstCr2n5Kpt/LNchusiy2u92g1wv50fEmi1ErmgAGb/rNKRGSP3NBsaB4icAfe8r1RpX+Tksb1n97rKXIqqJOSSDt3VAReJ4V3oM9FJ1xt+ZvZi3EiO6+AJt5A6p1EUtM+qrak5G5N0R7+eLpTGPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769119081; c=relaxed/simple;
	bh=Jfl4dZTufIKAHIVFT8NRO4fD8XoSRUWOc0fet6SBpt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IIAUd4b+RdWdGPqI9Y/Fl4cKNNcV2D3Fo8yRKHQSAuWTjNeZ4DRwRLNs/XHYPNmfu6h6yTtvZ6Tlh48xqbtD/HtpGu6vh5SC8anB2B9uSrMiNvxSPM6RMpZoH3vYJlQb5lzokZcdL/BrPDWgKg9NLRflWgFx6UR5qA9yRpoDQg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=39uLLe/+; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso1688a12.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 13:57:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769119073; cv=none;
        d=google.com; s=arc-20240605;
        b=NyF/lFJgwTHO9k+SWuhk8GdYZvQS1UfAWo2YoY+kBdzgcIJfzcHPQhWX/uG5kz5a2e
         XStZazJX+EsAI9eUM1O8LOUtWQM7OgHQhDcZ66LNQJH6ZgqFQX00Ba3o2jeJfHFjXjjI
         yu1TYpiTO8+63cTDwhQtD7EQyQJC5Vmdk4xleVpAwPX13IQw0T3eF8EjnWx6hZiw66kT
         EH+1+iD032ONfB2KS8OLMRLnCA1GP1fzi0ATeIYLR+81Kyq9BmO6gOhewrKSqUwAOvk0
         cj9sktHmuonHgLE8eG3wcQ3sFAbqwzr+z8dXk0Vdo+QOAIuSo9HdTSj+oa7tuy17RdiE
         dZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uGwfZfWxv4dR3vjl/Vm+r9X4BJKxCk7dJgsJmeqfMnQ=;
        fh=wl7iitUt54mTl2ikA6IlxhmXFqIXm4qlCXx/ilTSwL8=;
        b=W6JdlQvYB97XpXEcbxAYDZfmR2PYIc0k/punlXW1vUnnzHNOneR3+ZxYz9Meb4aLTz
         2/vGhz1eKlQwmCdWK1ZC/0oK2YDnzuGnnhJr7a1TYt0BaDOtyRP1+WOv8WHDILD3I5zC
         sFmlSlf9htS0iFZIjRlztxcQhAi7ciHSCog+cTjz57HVyWXT4m09BkjbSO/IywVcTH9x
         L23todvdXzCs8/HlpOezW6rzJe5Ry3k1ILTetb470QslNynuXd3J9sr7cgYGCCBuderZ
         5sDe0RCROovhtUWr9dVFDHjHZMyRXL4AVe6EnRZdadQpPqrRBBTmd8BqxMdxZ9Op70W9
         aDwA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769119073; x=1769723873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGwfZfWxv4dR3vjl/Vm+r9X4BJKxCk7dJgsJmeqfMnQ=;
        b=39uLLe/+p2pOzi73YG645N+IWdxlxqq16hn7teaCcByjiyapwG5CLMk86v9UOsG37w
         tQJ7CR/icVELRs3rrW3eMLbsjKeL5uR0F681oe2+YaX7foHkmmwCOCZ+AUt6tKPYmw+x
         8fjsmlhcBOBI5XtN5RlBP0xCtGiZs8dvuuZhkoKn8X0Jjdm0yi1sC/1we9S5X8stEq+l
         xglNJVygfboE2zIoF3NeQhg9oQANS6+7r1TMpWapzhjduTElU8RAzNNW3GPS/v9Hv3sB
         LGUGgFkyd925k7csU0t2FlC/DC9S2LW5fAk2TPYS39fprHQ1Fn8uh2msMtXgVmSV9nK1
         Uogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769119073; x=1769723873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uGwfZfWxv4dR3vjl/Vm+r9X4BJKxCk7dJgsJmeqfMnQ=;
        b=pnW3wND0/AECYZbuWxQAFzYIWJ/RiL2M7VUeYY2AW9bpNiR6+eaSBDsPmMKFcbt3yq
         S7GwRbH+7OxE9AAGN9b4BGr7DirY/33y588Xh8PPKwYc2oS7WJK0DKyU6YX+lr8uqTI9
         9maaCFgeIq682XOexJMp6Vm38/0x6hd+xthFmr4jNUieyrcowg9tbJJqGk6SEwyeLouk
         Hzz4K10r/tNJ7Y1mGsrO/V8LN8B2RlzR19NiD7TuyosSvXFZBeLu1duEEEvVI3pQeZCI
         lxQKIvqxZIgNCj6u5XVce17c6f6mtX3/tBgFJ2qXLFj3+7parXq7fNFrxf7g1Ktbu1kF
         eXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXN+dG41taRE0/Yu3IdNrbE9Njut+GZZ7ln8VDCH1Yb+b3xy29MhDoGxA3YpUoSA9FJaSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YysACjevRqzictaIV86VKCh88BrGDzc4Q8vQ8EMtUCxThq9AQ62
	ZHZrWaDIzkkrpM6eCnwVHiCXjpKgTu8hKMVm11pT92LhPdu/fAKl9/IeOF+D3H9T+aPRlx6zLvR
	MvrHHLkE3WYf1toFuHspr4iuqwSi8wQRyJWFrduPw
X-Gm-Gg: AZuq6aJGvtj2VKAcd7O2W0opLh30xnEPaMr6hSgQTOIskD2gcpd7H8xqpxxp1+5rmpD
	7ASJJZbVib6GhzERLsMpiVLxotF7Qok418SLwa1MslcPSOOYjCJIfE0Sil2vgVVWrcMxbfKvmqs
	OCtNP+Kkvwq23yDhP5QpXuqXb6RUB1yIHQUBNrRfsq/mtDsuLbaIYbs3Df72WB+1/heNwPWH7JN
	vMf8jo38/994SWzEm2Fu2DTwfzr+HZFEX/Ksdi4a0QsFP7dXw2DvJe+rzXfiQDa2AhAOjZMDaSd
	WwRvMXdqwujSM82veO0Vgg62dt5xUJs2/w==
X-Received: by 2002:a05:6402:5144:b0:649:8aa1:e524 with SMTP id
 4fb4d7f45d1cf-6584eabef16mr2044a12.11.1769119072536; Thu, 22 Jan 2026
 13:57:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-2-jmattson@google.com>
 <aXJKdlJI3fg42gim@google.com>
In-Reply-To: <aXJKdlJI3fg42gim@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 22 Jan 2026 13:57:40 -0800
X-Gm-Features: AZwV_QgJymUgNy_50vQyL9SN8_pY8sRH-FZ0KRcWUNAUxqWJsSqINclPGSmR8dM
Message-ID: <CALMp9eSNqqgLN9dMzer9Cj3hQ64fB2T==hB_yjvNBK4W8Pn66A@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: x86/pmu: Introduce amd_pmu_set_eventsel_hw()
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68936-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 798326DFDB
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 8:04=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 21, 2026, Jim Mattson wrote:
> > Extract the computation of eventsel_hw from amd_pmu_set_msr() into a
> > separate helper function, amd_pmu_set_eventsel_hw().
> >
> > No functional change intended.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/svm/pmu.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index 7aa298eeb072..33c139b23a9e 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -147,6 +147,12 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> >       return 1;
> >  }
> >
> > +static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
> > +{
> > +     pmc->eventsel_hw =3D (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
> > +             AMD64_EVENTSEL_GUESTONLY;
>
> Align indentation.

Sure.

After wondering about how to configure emacs to do this for many
years, you have spurred me to action. In case anyone is wondering:

(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-offset 'statement-cont 'c-lineup-assignments)))

At least, this seems to work so far.

