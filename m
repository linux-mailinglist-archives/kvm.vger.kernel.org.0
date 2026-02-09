Return-Path: <kvm+bounces-70617-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIS+FBIPimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70617-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:45:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5724D112A22
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 537083007213
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D1038552C;
	Mon,  9 Feb 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="To2cRWNE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198E23815C5
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770655499; cv=pass; b=qCCijILtR3pSpOTAF7jC3jXRqr/l8GHMvPyhUjDspa4xoT74RmbPrae9GmNyvrzg+Mn0uDihqhNO3gkZms6NPdC8noxzdzQi6LtCuzhmPhGL6CM+sa+cPF8zehu18LQufrJLKBilzDObbQWQdtC8oUzOuKcsvmpQ3NasNXx/0UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770655499; c=relaxed/simple;
	bh=wrdplUFA6RKQnfr1gdqv3J36haYwyiXQ+Y3/DHl6WiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWf7pdwNkla+7OsQPXGa5aG5OTYsnWEiUYv8dwWieUkTOjuMrrG5YurKNQlxMXYlHCOHLuOPCDf+iQc8bKSj/bZoO+5jyRwcq0BjRr8xd77hAPWyrg0vjqIs4V0YuRsgO6qFLehzbVUna9FFWntdgHINIaOED3xwmCqN9+TnzNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=To2cRWNE; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so14377a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 08:44:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770655497; cv=none;
        d=google.com; s=arc-20240605;
        b=geK2Wt99XJf3dMqWCIl/oOV2wwpDBgLFpJh6AirgVJQgH+A40T+rFoDl2QeezX1IGJ
         FfeY9Sva9CLVDVVhyq6NBDVOQ1ywFfMmw+csHACpsW7+hTsOV22oHnPl6eGvU5ldZzzE
         FlODPsOR0UV0Ey0jd5Qo4PLfoJ3IPyL41hwtc4zLIlDBvTI5i2B3KS0DGg5IHGpA5+3a
         4lIHa/w9oEPFZnm6nOHo/i+Wi+HGg7k4/N0gqXcHOjyVjEm6sUKecD37uqVrwPmsltml
         JZG9Rm7mMRSSIMlFWZHOCso/zvMaeS/RM5RfhDeyvcnEsNI1mCkVelqGu4EaI1qGmaRL
         woCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tmyTl6q+tqeF975POxGfJcIFC8oCHkJvZ2/ujs9yNDE=;
        fh=RHEl9ny36dQs0duNVJnXM5m1t2j+Dz+8hTNch3QJRow=;
        b=DyHEvWSsuyjUt/Bci3r+O22TFsth/2EogbqS2zosiHz/uwsMzoXNKhWEE7NSp7AE2T
         VN0yHcBhG7YIK1/aXiNt/qrtl3AfmlmyeEFRVvjBeqRRSmC8aSgdVuxbw66EblMeWcMR
         UKmXP5BVP2UMa6DqNeeNLdWDc+YV8cCvBe2RxhpK8oZeRE4yqgurfO3wXvkg5OkEk+3X
         RW6ZaHFJnxJ/Y1Mkp0sGqgjJDe34bK3xR6/RvLEfe7FEL8oXmMv5xXisbAm4I7StmVq0
         FxXhQrAIdYf5/i4iOPEZJXRblmPSlRzC8pKDBpOyADJpnwq66oyj73in0iuqXrWrfQ+z
         7G5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770655497; x=1771260297; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmyTl6q+tqeF975POxGfJcIFC8oCHkJvZ2/ujs9yNDE=;
        b=To2cRWNE6e1wPUuwK+alUHmmPkgmsDFZNBNFUblIFSNZ+YQMKtWFDLiDHBDRqRr0sI
         ZlyOciUTc/AqGOZnglish7Ov6HHg6PtaO5pBWlxx9eHytl1gZWo5OPZ/U3WzLvYZN5qu
         ybHnZqGZoPO7sKU4+3Zj5HdlGKM1louIt/ZzOMFWh16/0YJYaLecSwHEBZHId+ksoAmA
         Udj8kSDFuuMCAijS4ulUMzM8hne+zhrWMjPEL4t44UdeMgwTAvLFgBNpNXb1mOiGLUj2
         uvFPL92zT6wBmWXE8GFNdhmVJ71bPNrPu4VTyY+CjksBdkBBJIITs/aCf1pE57gtTZv2
         bW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770655497; x=1771260297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tmyTl6q+tqeF975POxGfJcIFC8oCHkJvZ2/ujs9yNDE=;
        b=BCuCSxk0/9KF0XtD9ZK2utLiJL/CQf5VBmiWOsijOhxtQU1ebTq/ULMSvNgMuFUppr
         2OO+YuAYkFEl7ppQwJBsIE/nsU5Aeu/5YqYd9IMbQvHfiC0neomohsv7q7bkLUkM4q0R
         2iKERdG0ji4nn9EOBYthvYvIAp0NfPwpinRd7vINXqhU1z7KP0IRZ3sSS0F4WXxeneEH
         r2vv9pCNIuVuVAY/uz+Q3dUl+c1ZRriQYYhS8Zw3umvJZeVK3nPv1o/fk6YsjUVC4Gr6
         S0PpRZQbT//1kzmLD5RdC84jHDdEPwe8meEIqqw9/Vj9RPGx1VNuzBLeMCMwOv9b2zlT
         ZZBw==
X-Forwarded-Encrypted: i=1; AJvYcCV75h+W7XIlD1lJZrA8HJwwZ/8jr4YkR9Casox7RpTPO54AsYf4UGdg4BBIHhxr27kJ+Qs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPNPpXh/i32/mIu8el2SstjM1TBnq+Rn4cuAW+U4Y38zAnsLHk
	7C1nr8DJ2Ao7HVDwoLcAnYHCM6Ul+fatQwRFsKCfK/YnGqyZ4XFF6d81ZIc51PeVart0Le+bIrQ
	Sm1p/x1BX2ofx33/NBpDdN1FshUc4d+yTfZgzT275
X-Gm-Gg: AZuq6aLVQwbPw6If7SB3fMvRIrncekq+4Kl64ne48srcQ9Yq/XEFh92dZKg4SSrkskq
	R9prF/+J6Y3tZJfFK5jZwY5OkmCJUIiPTEQn0KDfQeeEn8Wf5TCBcrAJ6Z5dgOIRwmn25vwuZ1d
	KRjCUgtfT68/a311k8eOETEADF5Ba1v2uz5MXQcd12UkPZpMUmrWrqA1CLeXIA9hU1+z73iYmb/
	y72leeyBP3hTvp/kOAIENDnE39fq6BDD3QwkQAARtbNaGDOaphBQDEV7CaHPrTODobRLzY=
X-Received: by 2002:aa7:c617:0:b0:63e:447d:6aee with SMTP id
 4fb4d7f45d1cf-659a7265904mr60684a12.0.1770655497156; Mon, 09 Feb 2026
 08:44:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207012339.2646196-1-jmattson@google.com> <20260207012339.2646196-3-jmattson@google.com>
 <8e032a54-1444-46ce-8ddf-371ca74debc9@amd.com>
In-Reply-To: <8e032a54-1444-46ce-8ddf-371ca74debc9@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 9 Feb 2026 08:44:44 -0800
X-Gm-Features: AZwV_QjUWlKwn7roG1diwoLDEG8hWuwKopezzs7giHM4EoO_JkdZbGU4Y-mmfc0
Message-ID: <CALMp9eRpNxDz_AkeZ8GgfbLr1fnYRrKDUJY4SsZ97oJZGsGiuA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: x86/pmu: Disable Host-Only/Guest-Only events
 as appropriate for vCPU state
To: Sandipan Das <sandipan.das@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:email];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70617-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 5724D112A22
X-Rspamd-Action: no action

On Sun, Feb 8, 2026 at 11:46=E2=80=AFPM Sandipan Das <sandipan.das@amd.com>=
 wrote:
>
> On 2/7/2026 6:53 AM, Jim Mattson wrote:
> > Update amd_pmu_set_eventsel_hw() to clear the event selector's hardware
> > enable bit when the PMC should not count based on the guest's Host-Only=
 and
> > Guest-Only event selector bits and the current vCPU state.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/include/asm/perf_event.h |  2 ++
> >  arch/x86/kvm/svm/pmu.c            | 18 ++++++++++++++++++
> >  2 files changed, 20 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/p=
erf_event.h
> > index 0d9af4135e0a..4dfe12053c09 100644
> > --- a/arch/x86/include/asm/perf_event.h
> > +++ b/arch/x86/include/asm/perf_event.h
> > @@ -58,6 +58,8 @@
> >  #define AMD64_EVENTSEL_INT_CORE_ENABLE                       (1ULL << =
36)
> >  #define AMD64_EVENTSEL_GUESTONLY                     (1ULL << 40)
> >  #define AMD64_EVENTSEL_HOSTONLY                              (1ULL << =
41)
> > +#define AMD64_EVENTSEL_HOST_GUEST_MASK                       \
> > +     (AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY)
> >
> >  #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT            37
> >  #define AMD64_EVENTSEL_INT_CORE_SEL_MASK             \
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index d9ca633f9f49..8d451110a94d 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -149,8 +149,26 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, =
struct msr_data *msr_info)
> >
> >  static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
> >  {
> > +     struct kvm_vcpu *vcpu =3D pmc->vcpu;
> > +     u64 host_guest_bits;
> > +
> >       pmc->eventsel_hw =3D (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
> >                          AMD64_EVENTSEL_GUESTONLY;
> > +
> > +     if (!(pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE))
> > +             return;
> > +
> > +     if (!(vcpu->arch.efer & EFER_SVME))
> > +             return;
> > +
> > +     host_guest_bits =3D pmc->eventsel & AMD64_EVENTSEL_HOST_GUEST_MAS=
K;
> > +     if (!host_guest_bits || host_guest_bits =3D=3D AMD64_EVENTSEL_HOS=
T_GUEST_MASK)
> > +             return;
> > +
> > +     if (!!(host_guest_bits & AMD64_EVENTSEL_GUESTONLY) =3D=3D is_gues=
t_mode(vcpu))
> > +             return;
>
> This seems to disable the PMCs after exits from an L2 guest to the L0 hyp=
ervisor.
> For such transitions, the corresponding L1 vCPU's PMC has GuestOnly set b=
ut
> is_guest_mode() is false as this function is called at the very end of
> leave_guest_mode() after vcpu->stat.guest_mode is set to 0.
>
> Is this a correct interpretation of the condition above?

I think you are confusing the VMCB02 bits (that always have Guest-Only
set) and the VMCB12 bits (which are under the control of L1.

If L1 sets only Guest-Only, that indicates a desire to monitor only L2
execution. So, yes, after emulating an exit from L2 to L1, the PMC is
disabled.

> > +
> > +     pmc->eventsel_hw &=3D ~ARCH_PERFMON_EVENTSEL_ENABLE;
> >  }
> >
> >  static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr=
_info)
>

