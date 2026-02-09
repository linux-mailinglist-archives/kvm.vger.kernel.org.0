Return-Path: <kvm+bounces-70600-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EK0TB534iWn5FAAAu9opvQ
	(envelope-from <kvm+bounces-70600-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:09:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF04C1119E6
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A0F483023E3F
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D2737D122;
	Mon,  9 Feb 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QLOZVTfJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED48A21CA0D
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770649599; cv=none; b=FplinwukDCtYM2MUZq1az2aDCjsbUs576bsCc9etdWsRvoqxrpyjfJaRknA5lGST+ryIqDvtwJ8UG+rYC7DbFrCSyZ0pt+pYdpsEQiR4mUE+T3x/2ei0aDlOsOCL5hoiOKfDPuIP6usKL9ikTCEWJGlMS0mzJjScMw7Qgaj6o/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770649599; c=relaxed/simple;
	bh=Gts1Ng9MjaplRBeyctmjPBUYdESDzVMN/Nq+GrTb/eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gYn33+5GksKaT/x6M7RGB0E87b5x+8Uor1+JXPG1juWuVazL5xiWdCcLfLOqCLMYWw6tPzhycjiwtaTroeHBiBuy6ouOFHZ+RbW8VoJ8igYCJJLcG7iev2W4wiNuUK1j2TFmIO1gitIRYVB/SVO1JrPpx35OMYoESUe7q6NxV+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QLOZVTfJ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6187bdadcdso2886374a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 07:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770649598; x=1771254398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emQ4N3VMon9pGtGOQvwqAYXNUvoy4vRVfNiTFhHBt90=;
        b=QLOZVTfJkG/Xqnn25TwIjszhUjzgGZpUmu0mvvFjMeocUzEomBgaUvA9h/W/HTGg18
         euAaFT7XlEHatOl27q8L88joKrJDNYWnWetdEP5lBf19R7MJMMldRttiSB7SQHaVQnNI
         I+/06pqfhqhuFJwtLVwDgWKAG+O+H4RrVgb8aYgy6HHoPPOMSM1cm4R0oLuKcyrRecvF
         UTl2shWTQPAoulOptxchKvqyyyH6UPAsd68J8y+/TeP3WL+nCJQKMS3MbYLKIYsQTScf
         PbMyea+uWW3BpvX+dcowBBedsWTzBEJxHR+H9OrkFgPKNx8bDTL0oIatTKxt6g3FG0/p
         Lh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770649598; x=1771254398;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=emQ4N3VMon9pGtGOQvwqAYXNUvoy4vRVfNiTFhHBt90=;
        b=wsYA92nsnIxVUDhwfdswqF2kNkYTUniR4o2rFMRbYAt6PvB3BxqznqOdVU2tUQx+4Z
         UfksKvz5H/50jp6KoN82maWeWj2AyLDDC4S98m2XAQ8ReR2z/0mlBPLY03pohkCPYlgF
         YKICXe32I81Al2kxpimRt8NGNfZQkHBz5UQku1qFyOtBSm3MZ2rWHbSJzQ0ugWO/oiS5
         bVfaAWiGehfW2z4iVuznyIyzZqysnkD+iA5E6dI1gPfu0Eqv6CWyPycVseg05duVQ2I+
         UyZdHYUxw3GP4jeKYRW5h7rUAOhGpDJx3dvtsfYu8eNY8GktqhOUSZSPioKte4aPQNYL
         JhsA==
X-Forwarded-Encrypted: i=1; AJvYcCUUSa68wE5VX2p4KyW0aRTQidKAmXC4h11fWWGy0KlV00FP6pwyLwpJPbrINySnP6Hv5KU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx39N0v86EUe+LzGnSGTntP9/9W0fkgRUyvhrf19Md/2ykmZDj4
	8Oz2aA9cZV/brKae1v8kot7TEZPxecKgOEmDipfTWMGexyoRQBHN9AoMKt3xNz3H/fpY04F/FQ9
	NOHjMmA==
X-Received: from pjbds12.prod.google.com ([2002:a17:90b:8cc:b0:354:c5cd:9f73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:670f:b0:304:313a:4bcd
 with SMTP id adf61e73a8af0-393ad002d22mr10233501637.30.1770649598223; Mon, 09
 Feb 2026 07:06:38 -0800 (PST)
Date: Mon, 9 Feb 2026 07:06:36 -0800
In-Reply-To: <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260208164233.30405-1-clopez@suse.de> <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local> <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
Message-ID: <aYn3_PhRvHPCJTo7@google.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
From: Sean Christopherson <seanjc@google.com>
To: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>
Cc: Jim Mattson <jmattson@google.com>, Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>, Babu Moger <bmoger@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70600-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,alien8.de:email]
X-Rspamd-Queue-Id: CF04C1119E6
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Carlos L=C3=B3pez wrote:
> Hi,
>=20
> On 2/9/26 6:48 AM, Jim Mattson wrote:
> > On Sun, Feb 8, 2026 at 1:14=E2=80=AFPM Borislav Petkov <bp@alien8.de> w=
rote:
> >>
> >> On Sun, Feb 08, 2026 at 12:50:18PM -0800, Jim Mattson wrote:
> >>>> /*
> >>>>  * Synthesized Feature - For features that are synthesized into boot=
_cpu_data,
> >>>>  * i.e. may not be present in the raw CPUID, but can still be advert=
ised to
> >>>>  * userspace.  Primarily used for mitigation related feature flags.
> >>>>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >>>>  */
> >>>> #define SYNTHESIZED_F(name)
> >>>>
> >>>>> +             SCATTERED_F(TSA_SQ_NO),
> >>>>> +             SCATTERED_F(TSA_L1_NO),
> >>>>
> >>>> And scattered are of the same type.
> >>>>
> >>>> Sean, what's the subtle difference here?
> >>>
> >>> SYNTHESIZED_F() sets the bit unconditionally. SCATTERED_F() propagate=
s
> >>> the bit (if set) from the host's cpufeature flags.

As noted below, SYNTHESIZED_F() isn't entirely unconditional.  kvm_cpu_cap_=
init()
factors in boot_cpu_data.x86_capability, the problem here is that SYNTHESIZ=
ED_F()
is now being used for KVM-only leafs, and so the common code doesn't work a=
s
intended.

> >> Yah, and I was hinting at the scarce documentation.

Maybe I could add a table showing how the XXX_F() macros map to various con=
trols?

> >> SYNTHESIZED_F() is "Primarily used for mitigation related feature flag=
s."
> >> SCATTERED_F() is "For features that are scattered by cpufeatures.h."
> >=20
> > Ugh. I have to rescind my Reviewed-by. IIUC, SCATTERED_F() implies a
> > logical and with hardware CPUID, which means that the current proposal
> > will never set the ITS_NO bits.
>=20
> Right, I see what you mean now. SCATTERED_F() will set kvm_cpu_caps
> correctly, but then this will clear the bits, because
> kvm_cpu_cap_synthesized is now 0:
>=20
>     kvm_cpu_caps[leaf] &=3D (raw_cpuid_get(cpuid) |
>         kvm_cpu_cap_synthesized);
>=20
> So to me it seems like SYNTHESIZED_F() is just wrong,

It was right when I wrote it :-)=20

> since it always enables bits for KVM-only leafs.

Yes, I didn't anticipate synthesizing flags into KVM-only leafs. =20

> So how about the following
> (I think Binbin Wu suggests this in his other email):
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 819c176e02ff..5e863e213f54 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -769,7 +769,8 @@ do {                                                 =
                       \
>   */
>  #define SYNTHESIZED_F(name)                                    \
>  ({                                                             \
> -       kvm_cpu_cap_synthesized |=3D feature_bit(name);           \
> +       if (boot_cpu_has(X86_FEATURE_##name))                   \
> +               kvm_cpu_cap_synthesized |=3D feature_bit(name);          =
 \

I would rather do this:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..5f41924987c7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -770,7 +770,10 @@ do {                                                  =
                     \
 #define SYNTHESIZED_F(name)                                    \
 ({                                                             \
        kvm_cpu_cap_synthesized |=3D feature_bit(name);           \
-       F(name);                                                \
+                                                               \
+       BUILD_BUG_ON(X86_FEATURE_##name >=3D MAX_CPU_FEATURES);   \
+       if (boot_cpu_has(X86_FEATURE_##name))                   \
+               F(name);                                        \
 })
=20
 /*

because I'd like to keep kvm_cpu_cap_synthesized unconditional and have
kvm_cpu_cap_features reflect what is supported.  And with

  Fixes: 31272abd5974 ("KVM: SVM: Advertise TSA CPUID bits to guests")

because everything was fine before that commit (though it was set up to fai=
l).

>         F(name);                                                \
>  })
>=20

