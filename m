Return-Path: <kvm+bounces-69032-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO9fBP0bdGn82AAAu9opvQ
	(envelope-from <kvm+bounces-69032-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 02:10:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9D67BE20
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 02:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 970E130382B8
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 01:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAF11E9B12;
	Sat, 24 Jan 2026 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h76QzGy3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9E327732
	for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 01:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769217002; cv=pass; b=mdpQZ/3yv54cXbjiG671B0Z4JvNd92huFVCRWCLfMYLDov/okE8I/Kxsoj6ZPM6qUKYccEPQ32WRvaN6zI30pdnFetK9KSqd0BAI87sNmWPzu+DfWO5cYCBIR9ruaVmZOUt3ZBf6xRb80Dq/0PmvB5PXQXyVX8fWNtcc661pd8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769217002; c=relaxed/simple;
	bh=ik36GtNfwR73DWLryLS0LVZwCrhyeVu3jU+pknIlVJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oK9/ugkbzn7+6HDIGeeEU1sCm4IrlLeOKVG52SmTygmabgA4zm2610aJcM5Xa12QnkBH/2mHmrB4MEYfqp0T3hnLbqShA0orGJ7HSzmqWne99K4W0/UIVzZ6Flaq9ptu35zgI7fIUUwN/fVgreEQdGNXpm53pyrpKMlD9vvwZcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h76QzGy3; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so3954a12.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 17:09:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769216998; cv=none;
        d=google.com; s=arc-20240605;
        b=atepTa/sbQY/0wzFAOr4EbJxLc+jqPl5LsY/IKYNoT81TTh+PTbjHNcwWO5jtKo07t
         DK/anyjU9cKK3e0xxMb3K+P8BtJ6o4SqcV45uFplD9muWHxpxEBnmDCUbPt/v8ROybeu
         S0C2Aa9ge2fDcqTBwxEm+u1NZX40gKk549xMvkO6XYCo++7qvU0tb+PJizpv3x9RtDLF
         KkUIVW4FJU9FV6CAgGgxuO6cUOaGOf24YY4f3aLz1kWvLqw3tpl+cr9kpts5RJ4SKcYb
         x8eNFsEE132qVd+71jY7yGUUtUpYrlqSnr2kApnNdyyHAiNIpF6XV3v8J6QhsTYQVgEH
         bPvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4EFvfBCWbL1lQgpc/+fXouK4fB7VqTYve4/x//+dWzE=;
        fh=y30c21NSHSPT/BEqMSWhUU8wfYeMGY/4E2DiOaVa53Y=;
        b=N4DhTK02fVygUTCmBVXHLmfwrxdK7d/xzFz0J6usS8ZdsrVfWoyM3UehIkYgZp7LAw
         AcpLIYE2A00UPHn3iemMMSN0yGSpa387YbvjBXUbqXgPoowqKjF8KS4L6qjYihUWgtWL
         EAgY1OegvBoInedIGGdV1GjXRNaO3oh/K6srcTKj3m2orgnw0BVmuZ36XR7M15l8I0by
         QDh83uLsgxpxKCgUKZPH4P97J/d2Fk8bgf1taZR7E8ZdvJJhJUoCQWahmtLi5TZKqbVB
         mp4r4VgSL509TTNlvhFVxG3ntY/Uuw2EWfSEFeN7L55SebPbm38RkiPPO6773HsfpCat
         75jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769216998; x=1769821798; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4EFvfBCWbL1lQgpc/+fXouK4fB7VqTYve4/x//+dWzE=;
        b=h76QzGy3t1OJZLasGyM/4jMNq8Dck99KVeDz7NEIR1e9EG147UflQLGyuktTb18NJM
         KQuM4Rg9FyuQJ8afFQ6yrSaa3262hPh6ZEp8VI9gyJC05O4Lkn8AV6GT7XDp9+d9IMNi
         nn70OEeI0Vb5DpfcHIrT6SF/n+2ebK/WEkjVv4Dz0J4FYsGrdABvrHg1ysNN+g9h7EcL
         4dKD8ZFFymPCznT0ycoi+kpknwQGF3SUwXPx4f7T8n18zwtzYcAOevMBGXZv5ZP7QsrI
         213voPJ8CThXb5auKZ4vdszW7AjCLx3622Vhfs+rJsfPpN5pdcaTQSNYaI5Z1KXJC/M1
         NVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769216998; x=1769821798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4EFvfBCWbL1lQgpc/+fXouK4fB7VqTYve4/x//+dWzE=;
        b=NdxAF6SqTUgpnkAo6/9QmZqkFPk3g7obX4XHChhdSUpFSmEx1rbWf2mta5NDBiwChU
         BnzA9InQus6iUXXj8NWSe4MiL79YGKAnDAiovPFATd8g0WmYRaXbcegahPxlqQm+X//d
         MMr5/q6letkzbnJSeg7rVQv80CSfdYcrfjO99pdwjRGNcKhWWbkdv4Vo2CDMt0XANdcv
         5ZipDDE2SL4ebu20dbjNo12XxGAW8GwBJCKpBBdunmkOCuy6zoNr1PQ/JYanGFzz4PrY
         deiK/z54+RGTUyv1PXN/j0t6kArucC77kxSzbLaU9DEm8W7ZqlbVf+OE/SuHU/NoqeZG
         y1jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU8/1zDhxD8+/1DZnWLiB4S6bFttqHEBrNxRaqVGXg9Eo2iXuk4r+sricVoNzjH1GWjEY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+8Ln3B9LVxgDLZm9blmsCqK+KNz2F+NsHL20pQDszN8AgvpmK
	OmGMUVKRnoLNOjP2guLUoiBeT1/xRv//ae3SQYFbL++Ui3dCoJxovkd346Io2hkCnCfpvWC46+0
	1kxVbGkD3FpfEPOSDOAohfqyReG+z+9hTWczZpliS
X-Gm-Gg: AZuq6aJM7ORtjedqTDIN+r28OreFzs44T0SB8Uk7QkCuHrrDCZvYOx5KsI3fc5sK4lA
	y9IevkQOeBLlXqdXYNOX8wE65EK+1fD+78G6UQLz9Wn1gLCLd6yxBSkHWOsPanV56sUy/KWaQyp
	/vZp76fTD36TjE042atj4vryzaNIvgUR01DNNNnMQeOPedoL6yTL7g+EHVpZFpAp7kbG9VMN3sS
	buBgBqu7zTjQdk9oKZzpbxZi7WsZ76n/GfOOV/XYtlgImauKcVYTtEX/TLv88zP0Q0H5JI7Uiji
	4htW6g==
X-Received: by 2002:a05:6402:5356:10b0:658:ec8:ea96 with SMTP id
 4fb4d7f45d1cf-6585d65e4b8mr16080a12.12.1769216998384; Fri, 23 Jan 2026
 17:09:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-4-jmattson@google.com>
 <aXJVKFs54eVI1Mjo@google.com>
In-Reply-To: <aXJVKFs54eVI1Mjo@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 23 Jan 2026 17:09:46 -0800
X-Gm-Features: AZwV_QihxGhmlb0R1pQUUg5REU3nZJkQnS8K32xs5XyEnk2F66ZdZyLEPHxipk4
Message-ID: <CALMp9eSTzEZSUAF2hXQ17RqviAA2gWbnxEEzscxA3OuvqLDjVg@mail.gmail.com>
Subject: Re: [PATCH 3/6] KVM: x86/pmu: Track enabled AMD PMCs with Host-Only
 xor Guest-Only bits set
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69032-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7B9D67BE20
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 8:49=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 21, 2026, Jim Mattson wrote:
> > Add pmc_hostonly and pmc_guestonly bitmaps to struct kvm_pmu to track w=
hich
> > guest-enabled performance counters have just one of the Host-Only and
> > Guest-Only event selector bits set. PMCs that are disabled, have neithe=
r
> > HG_ONLY bit set, or have both HG_ONLY bits set are not tracked, because
> > they don't require special handling at vCPU state transitions.
>
> Why bother with bitmaps?  The bitmaps are basically just eliding the chec=
ks in
> amd_pmc_is_active() (my name), and those checks are super fast compared t=
o
> emulating transitions between L1 and L2.
>
> Can't we simply do:
>
>   void amd_pmu_refresh_host_guest_eventsels(struct kvm_vcpu *vcpu)
>   {
>         struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
>         struct kvm_pmc *pmc;
>         int i;
>
>         kvm_for_each_pmc(pmu, pmc, i, pmu->all_valid_pmc_idx)
>                 amd_pmu_set_eventsel_hw(pmc);
>
>   }
>
> And then call that helper on all transitions?
>
> > +static void amd_pmu_update_hg_bitmaps(struct kvm_pmc *pmc)
> > +{
> > +     struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
> > +     u64 eventsel =3D pmc->eventsel;
> > +
> > +     if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE)) {
> > +             bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
> > +             bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
> > +             return;
> > +     }
> > +
> > +     switch (eventsel & AMD64_EVENTSEL_HG_ONLY) {
> > +     case AMD64_EVENTSEL_HOSTONLY:
> > +             bitmap_set(pmu->pmc_hostonly, pmc->idx, 1);
> > +             bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
> > +             break;
> > +     case AMD64_EVENTSEL_GUESTONLY:
> > +             bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
> > +             bitmap_set(pmu->pmc_guestonly, pmc->idx, 1);
> > +             break;
> > +     default:
> > +             bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
> > +             bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
> > +             break;
> > +     }
> > +}
> > +
> >  static bool amd_pmu_dormant_hg_event(struct kvm_pmc *pmc)
> >  {
> >       u64 hg_only =3D pmc->eventsel & AMD64_EVENTSEL_HG_ONLY;
> > @@ -196,6 +223,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
> >               if (data !=3D pmc->eventsel) {
> >                       pmc->eventsel =3D data;
> >                       amd_pmu_set_eventsel_hw(pmc);
> > +                     amd_pmu_update_hg_bitmaps(pmc);
>
> If we're going to bother adding amd_pmu_set_eventsel_hw(), and not reuse =
it as
> suggested above, then it amd_pmu_set_eventsel_hw() should be renamed to j=
ust
> amd_pmu_set_eventsel() and it should be the one configuring the bitmaps. =
 Because
> KVM should never write to an eventsel without updating the bitmaps.  That=
 would
> also better capture the relationship between the bitmaps and eventsel_hw,=
 e.g.
>
>         pmc->eventsel_hw =3D (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
>                            AMD64_EVENTSEL_GUESTONLY;
>
>         if (!amd_pmc_is_active(pmc))
>                 pmc->eventsel_hw &=3D ~ARCH_PERFMON_EVENTSEL_ENABLE;
>
>         /*
>          * Update the host/guest bitmaps used to reconfigure eventsel_hw =
on
>          * transitions to/from an L2 guest, so that KVM can quickly refre=
sh
>          * the event selectors programmed into hardware, e.g. without hav=
ing
>          * to
>          */
>         if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE)) {
>                 bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
>                 bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
>                 return;
>         }
>
>         switch (eventsel & AMD64_EVENTSEL_HG_ONLY) {
>         case AMD64_EVENTSEL_HOSTONLY:
>                 bitmap_set(pmu->pmc_hostonly, pmc->idx, 1);
>                 bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
>                 break;
>         case AMD64_EVENTSEL_GUESTONLY:
>                 bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
>                 bitmap_set(pmu->pmc_guestonly, pmc->idx, 1);
>                 break;
>         default:
>                 bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
>                 bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
>                 break;
>         }
>
> But I still don't see any point in the bitmaps.

No problem. I will drop them in the next version.

