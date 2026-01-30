Return-Path: <kvm+bounces-69753-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJL6Gj4/fWmoRAIAu9opvQ
	(envelope-from <kvm+bounces-69753-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:31:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C52F0BF5F8
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5043303F7DD
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 23:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16D2378817;
	Fri, 30 Jan 2026 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LGUoB9dD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0F92652BD
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769815856; cv=pass; b=HD9KGZwRDAFsQe5DJAkqyYrTrmYuvxulg7p2FZwlkrGLg+GO5O0sweCqT+tjszYiSrCdxi4s9KC37HQh/Leva2tYT9IN2xHKJa181WU/0Z+g8Q07vOOGlGGV/UbIxaJYPwIVg542tlh57Q6b4M5eLwIZBAjRNFULKpTTwl82hcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769815856; c=relaxed/simple;
	bh=uP3AnfWxksp7Fq17hXZgZwEtBM8hOyGlJYnoXXxtPoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VDhiXTJm6zfzszdjxQJ0OCO4S0btRZHO3hCmBUI3eNEVkkI1AXqcM+jJa0dQe07yAwnmLOvguEkvmt4dueSbdB9EPx9Ci6oewIULtwJGUtwnYH9yoiYQNdGrUrnyhBBVUXJGZryCALVF5IaJVhr2kS24Qko50nzInXlB4dD4eUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LGUoB9dD; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so1815a12.0
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 15:30:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769815853; cv=none;
        d=google.com; s=arc-20240605;
        b=gmiMoSzgh5gbmmA7SHOFTH8LhEXggQdy20wxtn9A/08MrSmA+/SgGHsHeNRB2KgdJM
         gHfeOH3u7k4tOOjRF6j9iNmHUW2yYi5WX7aSMq7CRdCBpF1TdzyTxtPFmgixxrtS5hwv
         +T0Tl9txEjj6sik2XPMvfX2A0OsDNNCGO4liRrMmVlXLwbMaxkvoB34KIwPfP0jScA3d
         RSLBmCF3/IIl2Og9PvnE+oUyhBp4hueCaW9zjmMVpjDEAMTVB+C9u3jUCxE+VpkghL6Y
         XwjDmRbnnMq+Uib0lkpkcNPbwZ06t00plu5YJpB3iSeMmGx0/qgsql/YJzvY+G7orifF
         5qxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OWGbD3Q1oYxtbYVSNos0BG2kmeyuKAEZoyrEWcfmjO8=;
        fh=AHAHHyXSNTBwtfGJUTiSFG/J8XoDGxT9CRDG1AnAIj0=;
        b=kkCLn21DwvHya9DNE6jlT4/vxvot+YPMBO/vr0ogoM2VwJ3FcjFyWE9KsWC69Upptl
         Bfq3PM6tChryncisx9MP7m6q7zvA/5usuH9vXEdxfKgIz4cuWFm5QiCRcTZwcyp+5Dgc
         OKNai2ap1jF+r59lVDMtOEKS0ticugRHgc4WzOU1mTGpqCLUtoEkSQShav9NHzDhj3k3
         6cJ52Tu87zVU2Q4mBTmUOQrHNtsUfWqGDZFR8Va/YrkOrfWxnlwNAI5MG0yTS9Co8Zo7
         P7ALNtenEGi2a2yK69nvBZ5mFoPtFfSf16Zxb3JeLB+8JEGiZPxvkJnDzkQthMXZufaa
         8I1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769815853; x=1770420653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWGbD3Q1oYxtbYVSNos0BG2kmeyuKAEZoyrEWcfmjO8=;
        b=LGUoB9dD9y23kkeGF6qyeo0n3Ir84ufMDaVQNwJAQRRYgFfC5UGI3UZI7zQ4yY2++u
         /LZSVMRsJkE3rdNvN50O3eWJArx05s+8Nufw/8pRtuMraTyLHfilPVIILi0JRk5jkqyh
         zYI88PnJiIrzEwW0Ljw5JyCLyDs9M6iPW5LYbQkUZunQLbAY7jrdxFRGXD6iunRKK6Cp
         m9JgnbAm009iodgRdrONT3RfwhnocFL8tDucmoN6WoUUVwAaTebxcIq3GdSG49aUXFGg
         RQRhTTO+6ybI3jMnmEGT3F5q5EA/kCm6IEOIIdpkXSrWMdxLO9ZcLyCsJnkRCXR7S+Aa
         Vbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769815853; x=1770420653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OWGbD3Q1oYxtbYVSNos0BG2kmeyuKAEZoyrEWcfmjO8=;
        b=My3zEvlLBwp5apedJfpLHNLHizybylxJ3tGj07Zap17D1KgUfQsaO41BQXQcGWfK3X
         3W+ytSeR+7+1YNIaNTHm4R3ibqaEPq4NoaM4xy3dxygooOUEtGOVAjneDFKa46c8ehvN
         X9Ad4JQqC050TIrLxRYaL2pblavHLjCz8+j20p2HiJ+gH4WjilPNEUzOKD4LGj9W7Rr9
         vPHhYuzVLfrmpkh0UuJqBYz8qVkfx3arlgHtTQXOnKxBSF+oPfPEEYog4G8QcKzbyw5O
         bIaRN6Bykm5jQivshPW8Cy2zCf+G/QZ9NocyTr6wBPJ0gjSBzU/CVg+0KNImiaYvIOkr
         ekgg==
X-Forwarded-Encrypted: i=1; AJvYcCUHQcUZQcrHjwdpdTcHSE1Fk8fQBlbNJUkPTQ6oPw9OfoXTRYhjZX/b2xqKoqxjGCCZudI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/5Ubm8L1b6UZzYN+VGuzQwlxCGBINra8/NnELolPjRX05NmI+
	ZLDSd518sN3thC1cECHxI29UUNDCsBOGn5V2bBeEV2Y7P5QO4pou4ZT0GvME27HbPX+HcnDTD/t
	BpT4m4UO//jOR8zIotbIQu0qUF68I3CQU/xzCRPZ9
X-Gm-Gg: AZuq6aIkBzKLJDzJf2zun3w0A2DfQk6M08B2PvZk+wiXEnSJWW0fLNDuXBY4vfCcH48
	M/IZKWW6Egv+HwbIrcfWxGcSylgb0+/810r4cPIbTm/mx0feRDTU19XOlN0AY/VBbJVtk/qVj70
	kfP4CAoGmzo6u7clThMZ5SvNU219Muee+zFSYh6dSENkwJmaNekg1CrZRbWcQf2XjucvOhfaBpj
	mXtHIJCfDI/IivUa0QlZTRroXSYCuUzPvX8l/HqYp5slFqUTMnEGeLh4V4MnQpJ/6/NbDA=
X-Received: by 2002:aa7:ccc6:0:b0:658:a54c:d6f3 with SMTP id
 4fb4d7f45d1cf-658f6c75eaemr14062a12.6.1769815852677; Fri, 30 Jan 2026
 15:30:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129232835.3710773-1-jmattson@google.com> <20260129232835.3710773-4-jmattson@google.com>
 <zzgnirkreq5r57favstiuxuc66ep3npassqgcymntrttgttt3c@g4pi4l2bvi6q>
In-Reply-To: <zzgnirkreq5r57favstiuxuc66ep3npassqgcymntrttgttt3c@g4pi4l2bvi6q>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 30 Jan 2026 15:30:40 -0800
X-Gm-Features: AZwV_QjGWdMQTuDf_firyiB8uJrobAc3g0L2GOgNb852oEYE3viONZnLUBrlkRc
Message-ID: <CALMp9eS7Za_vFdh8YBzycV2g87gZ9uj_S1MOYrgJ1+ShwVVWZw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only
 eventsel at nested transitions
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mizhang@google.com, sandipan.das@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69753-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C52F0BF5F8
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 7:26=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Thu, Jan 29, 2026 at 03:28:08PM -0800, Jim Mattson wrote:
> > Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel_hw=
 for
> > all PMCs based on the current vCPU state. This is needed because Host-O=
nly
> > and Guest-Only counters must be enabled/disabled at:
> >
> >   - SVME changes: When EFER.SVME is modified, counters with Guest-Only =
bits
> >     need their hardware enable state updated.
> >
> >   - Nested transitions: When entering or leaving guest mode, Host-Only
> >     counters should be disabled/enabled and Guest-Only counters should =
be
> >     enabled/disabled accordingly.
> >
> > Introduce svm_enter_guest_mode() and svm_leave_guest_mode() wrappers th=
at
> > call enter_guest_mode()/leave_guest_mode() followed by the PMU refresh,
> > ensuring the PMU state stays synchronized with guest mode transitions.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/svm/nested.c |  6 +++---
> >  arch/x86/kvm/svm/pmu.c    | 12 ++++++++++++
> >  arch/x86/kvm/svm/svm.c    |  2 ++
> >  arch/x86/kvm/svm/svm.h    | 17 +++++++++++++++++
> >  4 files changed, 34 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd..a7d1901f256b 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -757,7 +757,7 @@ static void nested_vmcb02_prepare_control(struct vc=
pu_svm *svm,
> >       nested_svm_transition_tlb_flush(vcpu);
> >
> >       /* Enter Guest-Mode */
> > -     enter_guest_mode(vcpu);
> > +     svm_enter_guest_mode(vcpu);
>
> FWIW, I think this name is a bit confusing because we also have
> enter_svm_guest_mode(). So we end up with:
>
> enter_svm_guest_mode() -> nested_vmcb02_prepare_control() ->
> svm_enter_guest_mode() -> enter_guest_mode()
>
> I actually have another proposed change [1] that moves
> enter_guest_mode() directly into enter_svm_guest_mode(), so the sequence
> would end up being:
>
> enter_svm_guest_mode() -> svm_enter_guest_mode() -> enter_guest_mode()

Yes, that is confusing. What if I renamed the existing function to
something like svm_nested_switch_to_vmcb02()?

Alternatively, I could go back to introducing a new PMU_OP, call it
from {enter,leave}_guest_mode(), and drop the wrappers.

> [1] https://lore.kernel.org/kvm/20260115011312.3675857-9-yosry.ahmed@linu=
x.dev/

