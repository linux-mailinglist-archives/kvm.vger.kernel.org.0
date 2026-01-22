Return-Path: <kvm+bounces-68938-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIOtIyepcmn8oQAAu9opvQ
	(envelope-from <kvm+bounces-68938-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 23:48:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A766E496
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 23:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D7ED3300C8D9
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 22:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5423B531C;
	Thu, 22 Jan 2026 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oTc4FjNs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB273A7844
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769122072; cv=pass; b=tmT2T/Drpg2wFp5qFMPfxYNDjO7SaeWvE7yR8JyQlP4Vo3SLo0E28pnPqKvtws/t7UjdFKUdo4zdjMjDMEbGbfwC62OFCX+G1+NrrqOHdHKrwkAAF3ZXabmrjVLK+27FC+jILQNZTvHmmR0KNQiKDoKknN9utI2G8MY6UfJfDhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769122072; c=relaxed/simple;
	bh=TND/Si/DRcSfUhMVT1qeEyIBuM6pXmd6mhIdRalzdww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OThObFJXeLR4C/k/lOiPpq7abPGT1ZlO5Y7KYKSCaAi8EpYzbttYWIdO7bbCsRUcA9YfoutYAkAjna/if6/W1VQ6DIzzQiZJEA/I4V3gvOwRS6Y0cCkwNuNm6kjQ3/5QMbsrv/6c+fQzuNGlkvJfYJajJN2jDZujFEeOt2V9qP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oTc4FjNs; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so5137a12.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 14:47:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769122057; cv=none;
        d=google.com; s=arc-20240605;
        b=lSoZcXk16nAdCXJBsRuKE43Z00kIutHxn2Z9ZiVFyt3WA91kYI50Vh0L9a4Z8CnaGy
         QY0dslw5OeeugVZ62Lk7gv0WluIupB2QVnDHPIQtYxv2Cu8JBFDQJcUo3d/fduav6QHf
         Rxun4ObxyqCsHeu+nOiW50nU5NA6+srpRVeew6U3Rh9LEXKFhokDBZHIQtdBCAp5tEzu
         crjAbd0xwWbX8lWszEglJcbhqE2WPeV1ggMDa36Jfv77yHnYsTJI662/rXB0IYOB8Crc
         TQHyW60VpBIWEnx/ZElAuJDbT0vgYinARIErYTSG9tKZP2XfZDZ5wilsR1Ips5fBREN0
         RU8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=73p/P7bLELYiLT0M410lIGTK80iJQLNo9oAfsXMKpaQ=;
        fh=bIwwBRxVhUFC8FyQ/uyNwDaA2Ejg1qhKtilC/z/s+1k=;
        b=WLlDfTAnPXtRfB8meh6rvmI/5VGBqqkIco9Ri5gg4O30vcB+UpPa3OS+WmrAFqrQyi
         iAsVSrIe0EeQm/zj7qLXDgEiBsXyO4bhLt2fbR/E8zSlL/EWINwONCNUf2NJuPFOl2a+
         NGnw1ytRuDHkZfOd+uHRaDznBAadSDBjX7OQvZggS43O77kmEyjDSXQVe0d84jp2rQ6E
         DM3pw8IVubCwo5kPrvj6X3M2OBnSthrNGq2lKAXyPNxCO2eYV06aaCRt9P+kS63mKGj1
         wgeWeoLgOJgoU8FDkwvf4T0JfBomNzAsjeWh31q3/OFGIrtj2dOvp1suEobcVru17Wmi
         D6bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769122057; x=1769726857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73p/P7bLELYiLT0M410lIGTK80iJQLNo9oAfsXMKpaQ=;
        b=oTc4FjNsVXElVl6/m5w70zuzsF/zfCyadF3V/eeM2FNDZHKfjCq8gScaWvQDvnCq3y
         XfnA+qNAljNJrdyDS8EQDu5VO8ZrP9FwhhwYb94lxU+hEyhbnlvRqrPK1n8fydaqIaWx
         fmDAigGuNYm26BgIMB4cT5k6Cj2V2SMjKwghDE8NA7hDkPXahHklom8zthGgtAoF3plZ
         Ac7tcIWpayyQqJ8aZpecrdmD2vxBAt5n4/ep7CrXYMs2iSB2Dj8gGsBMgFPnbavc67+d
         IvEVD2udYxbeDP8D3P9Z1Z2PymoC2zgyZxIIlxBMWAUfvN2kSH0opbH/GKNPAgVz677Q
         lu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122057; x=1769726857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=73p/P7bLELYiLT0M410lIGTK80iJQLNo9oAfsXMKpaQ=;
        b=ErV/jCmRFEIDLvz5jVwcU2fS0ZJxPelLR5VbsLCbLF9Nk1rRXZucoejKKVZmrEyfVz
         5l6ThzvJJJQd+W0mjKK6/fj0HFmgjxZEinoIIvC7CsV1ojcpGdPPT1oOFUAlq/XWWpuY
         DYyXBubTtl+hsxUf4hQ/kGY/IO7YkDQmtghPFDS8/5SeJKcxXvHZiSknVNbhV+mBpaDN
         N6XHl/LC7+QToCl2cMRUCdInj6js2zwd8Cxs+a+1qPw5WquY1tnYun2+CBRvoMQrLaRg
         QUsUfFzlFFFWy7hBxvL3a5wzXbrdbvQ+JjBYA/B0QxSlSoov/bw80ISVlYBkl/LxK15Y
         VOig==
X-Forwarded-Encrypted: i=1; AJvYcCWj5tTHE/spcnVD4u012WQTeLg9HIbHMSk3yeKBb9/G0pk4jx2k1szEtPy2+d2aE+ywDPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxng43/mXuY2qhYNjbI09n6DXXSCjDhI5AVgC8FwSpvngAVfZwu
	pp+Vp9zhAGYYcnkofLsI9zKAzHLIJxqyT2adTdqfU3tK33c9GFCqwTQsIf4DYfxsSMGuHz5A6Rh
	zaS2vWL7EAxX/cuufboizHSjwj53jo4nyOQaqBi/Q
X-Gm-Gg: AZuq6aIWry6J6KKVaQkCDHaRd02kdCT5aO/kke9vexZYKZEUos6plb30ji4U6gAr+jo
	l/pcgte41W2WLhg62akmIra0n3Rh0da3+34Tj8XQl/DiveAyS85MXLCRei27V/469BdYGXuGYld
	yXCPObfqstsdfl3hBuquJGeTzfkgd5jO6RzCaF/Ml0yNQKPEmWzGtY7WOrL7lkfIfsS+pet/wWM
	aLIIB2/AyW+qkaf0Gzp+G+XEX4r4bdC/vTuWUjX3pvN0hCre8hgKtuaSxqbCeM0jOroHWMEGLLS
	KNVvwvFhV+Lm3r63bKt7BeY=
X-Received: by 2002:aa7:c74f:0:b0:658:909:511 with SMTP id 4fb4d7f45d1cf-6584eaa7e3dmr3822a12.3.1769122057232;
 Thu, 22 Jan 2026 14:47:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-3-jmattson@google.com>
 <aXJRWtdzjcb8_APA@google.com>
In-Reply-To: <aXJRWtdzjcb8_APA@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 22 Jan 2026 14:47:25 -0800
X-Gm-Features: AZwV_QgLJNlpwnESIOnJyOjuyzAXTUsC4-1Gsi8ldMfpGFY9pFyZtqFYo2yuOLw
Message-ID: <CALMp9eRGj3rNeNN82H12f=XO5iXi5s2ri2K71CnjoVp9eKzz1w@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86/pmu: Disable HG_ONLY events as appropriate
 for current vCPU state
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68938-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 53A766E496
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 8:33=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 21, 2026, Jim Mattson wrote:
> > Introduce amd_pmu_dormant_hg_event(), which determines whether an AMD P=
MC
> > should be dormant (i.e. not count) based on the guest's Host-Only and
> > Guest-Only event selector bits and the current vCPU state.
> >
> > Update amd_pmu_set_eventsel_hw() to clear the event selector's enable b=
it
> > when the event is dormant.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/asm/perf_event.h |  2 ++
> >  arch/x86/kvm/svm/pmu.c            | 23 +++++++++++++++++++++++
> >  2 files changed, 25 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/p=
erf_event.h
> > index 0d9af4135e0a..7649d79d91a6 100644
> > --- a/arch/x86/include/asm/perf_event.h
> > +++ b/arch/x86/include/asm/perf_event.h
> > @@ -58,6 +58,8 @@
> >  #define AMD64_EVENTSEL_INT_CORE_ENABLE                       (1ULL << =
36)
> >  #define AMD64_EVENTSEL_GUESTONLY                     (1ULL << 40)
> >  #define AMD64_EVENTSEL_HOSTONLY                              (1ULL << =
41)
> > +#define AMD64_EVENTSEL_HG_ONLY                               \
>
> I would strongly prefer to avoid the HG acronym, as it's not immediately =
obvious
> that it's HOST_GUEST, and avoiding long lines even with the full HOST_GUE=
ST is
> pretty easy.

In this instance, I'm happy to make the suggested change, but I think
your overall distaste for HG_ONLY is unwarranted.
These bits are documented in the APM as:

> HG_ONLY (Host/Guest Only)=E2=80=94Bits 41:40, read/write

> The name should also have "MASK" at the end to make it more obvious this =
is a
> multi-flag macro, i.e. not a single-flag value.  Otherwise the intent and=
 thus
> correctness of code like this isn't obvious:
>
>         if (eventsel & AMD64_EVENTSEL_HG_ONLY)
>
> How about AMD64_EVENTSEL_HOST_GUEST_MASK?

Sure.

> > +     (AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY)
> >
> >  #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT            37
> >  #define AMD64_EVENTSEL_INT_CORE_SEL_MASK             \
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index 33c139b23a9e..f619417557f9 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -147,10 +147,33 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu,=
 struct msr_data *msr_info)
> >       return 1;
> >  }
> >
> > +static bool amd_pmu_dormant_hg_event(struct kvm_pmc *pmc)
>
> I think I would prefer to flip the polarity, even though the only caller =
would
> then need to invert the return value.  Partly because I think we can come=
 up with
> a more intuitive name, partly because it'll make the last check in partic=
ular
> more intutive, i.e. IMO, checking "guest =3D=3D guest"
>
>         return !!(hg_only & AMD64_EVENTSEL_GUESTONLY) =3D=3D is_guest_mod=
e(vcpu);
>
> is more obvious than checking "host =3D=3D guest":
>
>         return !!(hg_only & AMD64_EVENTSEL_GUESTONLY) =3D=3D is_guest_mod=
e(vcpu);
>
> Maybe amd_pmc_is_active() or amd_pmc_counts_in_current_mode()?

I think amd_pmc_is_active() is a much stronger statement, implying
that both enable bits are also set.

Similarly, amd_pmc_counts_in_current_mode() sounds like it looks at
OS/USR bits as well.

I'll see if I can think of a better name that isn't misleading. I
actually went with this polarity because of the naming problem. But, I
agree that the reverse polarity is marginally better.

> > +{
> > +     u64 hg_only =3D pmc->eventsel & AMD64_EVENTSEL_HG_ONLY;
> > +     struct kvm_vcpu *vcpu =3D pmc->vcpu;
> > +
> > +     if (hg_only =3D=3D 0)
>
> !hg_only

Now, you're just being petty. But, okay.

> In the spirit of avoiding the "hg" acronym, what if we do something like =
this?
>
>         const u64 HOST_GUEST_MASK =3D AMD64_EVENTSEL_HOST_GUEST_MASK;

Ugh. No. You can't both prefer the longer name and yet avoid it like
the plague. If you need to introduce a shorter alias, the longer name
is a bad choice.

>         struct kvm_vcpu *vcpu =3D pmc->vcpu;
>         u64 eventsel =3D pmc->eventsel;
>
>         /*
>          * PMCs count in both host and guest if neither {HOST,GUEST}_ONLY=
 flags
>          * are set, or if both flags are set.
>          */
>         if (!(eventsel & HOST_GUEST_MASK) ||
>             ((eventsel & HOST_GUEST_MASK) =3D=3D HOST_GUEST_MASK))
>                 return true;
>
>         /* {HOST,GUEST}_ONLY bits are ignored when SVME is clear. */
>         if (!(vcpu->arch.efer & EFER_SVME))
>                 return true;
>
>         return !!(eventsel & AMD64_EVENTSEL_GUESTONLY) =3D=3D is_guest_mo=
de(vcpu);
>
> > +             /* Not an HG_ONLY event */
>
> Please don't put comments inside single-line if-statements.  99% of the t=
ime
> it's easy to put the comment outside of the if-statement, and doing so en=
courages
> a more verbose comment and avoids a "does this if-statement need curly-br=
aces"
> debate.

There is no debate. A comment is not a statement. But, okay.

> > +             return false;
> > +
> > +     if (!(vcpu->arch.efer & EFER_SVME))
> > +             /* HG_ONLY bits are ignored when SVME is clear */
> > +             return false;
> > +
> > +     /* Always active if both HG_ONLY bits are set */
> > +     if (hg_only =3D=3D AMD64_EVENTSEL_HG_ONLY)
>
> I vote to check this condition at the same time !hg_only is checked.  Fro=
m a
> *very* pedantic perspective, one could argue it's "wrong" to check the bi=
ts when
> SVME=3D0, but the purpose of the helper is to detect if the PMC is active=
 or not.
> Precisely following the architectural behavior is unnecessary.

Even I am not that pedantic.

> > +             return false;
> > +
> > +     return !!(hg_only & AMD64_EVENTSEL_HOSTONLY) =3D=3D is_guest_mode=
(vcpu);
> > +}
> > +
> >  static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
> >  {
> >       pmc->eventsel_hw =3D (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
> >               AMD64_EVENTSEL_GUESTONLY;
> > +
> > +     if (amd_pmu_dormant_hg_event(pmc))
> > +             pmc->eventsel_hw &=3D ~ARCH_PERFMON_EVENTSEL_ENABLE;
> >  }
> >
> >  static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr=
_info)
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

