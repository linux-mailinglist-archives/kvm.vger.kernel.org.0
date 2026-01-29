Return-Path: <kvm+bounces-69588-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Dm9BDOie2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69588-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:08:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC02B363B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5AC1630177AB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4C3356A01;
	Thu, 29 Jan 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vpqYTqEP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3D32D46B3
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769710124; cv=pass; b=stFjJ0wt5yAPGahGEzF5qvyFmcMcFZxhhUOT9zGfeu31oKQhXzFhu5+5t+gru6EcG2K9FSz2XtlLq6CXZTsYPIAn6zbYqonfREIQ1C5sR5HPznRxkQ54ZW7E6qx/yJZ0N6hRCFdPr6wpKkIa/EJcgjy/9uSNp98O7TmTf0WNxwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769710124; c=relaxed/simple;
	bh=BwQzo46Gk7bS/VjSAeVKq+SmnZ308X+zYRWSk0T1+Hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RwanDnvPfFFHZghq1MGlzmPGldfHU//sSMOPlnhYlzR8W5f2G95MGaaX8se6PWzieogb7d6Ny9JQfWLs+7gbfrSiRWYggaFDm9cz+hhqXj2Lu+6xGGIrJ2xuMvBTCVl2Umrv3LlAfFswNxituarkJeGLJclP2krbSa6yQvBNTDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vpqYTqEP; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso392a12.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 10:08:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769710121; cv=none;
        d=google.com; s=arc-20240605;
        b=WeEUXVLTaQ9Yy9f8u6CSNzz7EXixpu7st97ZmUgdNapOebxxPEcArm7L1EsPiMmsZ3
         gYRPpWpiGOR83yplblUoGoVazxEcEwDIInclEQzUosy7GQo750j+VEZVlxagiTzM5TqZ
         e/7H0IEMCVwR10LhA4ITHB7IBfQoEsnm1KmQigK04J1pyNcz4Oa8vHtZLz3J8RfM082f
         q2SDgGigkilENwNapJa3DuVXVTqsFV6/ZkBPh8+w4Ay67Kbvzlaj+UjoOXQi3G1YXpg1
         JYbQazoPxHUlOc9IDCrA7oYs9dbvNfmmyOao0AF8nSB7lQlcryNZ9AK3cWImW0URQAj5
         qxbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3gMeLrc0kfCIp5iiLsgNdlUxrpKtjQ3FyJ13fmaichA=;
        fh=sL+zcdSRt1JUpsuwLRXL5Itcj2vlUc0TJc6ma95KvVk=;
        b=BBUddAwB9OatNUQuqPXHuLNtpI5TR0twZC3VVQKaQd0zdwG7LEiZRKlMJcZydq2pBf
         tgS8zLbTFBkSCc9TRzpgfDPsQgjV0FjKBwQI85x8eEQjrd60KhtgwzVED3l3kdvql2G/
         LpQNon2Ljg26ajvbNdCmV1ZlaEHK+Q946OWfuTkzAdyLY9HQBb7UgcM6/oG/TW2ajI1+
         2WRvUPDai4i7U+yiQ5H2Cb+hLJzZanRSsgNHryALrPF4paVqDGf78JyBxP8WXgzQEMqY
         H58zpbX/KxMzpsT7Jh403kRFev/1Qz8C+KEz87m90wsBlaGwarDVzItcCsbw2H2eptuW
         PuOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769710121; x=1770314921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gMeLrc0kfCIp5iiLsgNdlUxrpKtjQ3FyJ13fmaichA=;
        b=vpqYTqEPm+WuRkMIpr67ngmH4SqktnHq+tliw8C3uvvfa3BUnkqBb+I4HArEmlY9BH
         RinMTaQoit4q+gY1VaJ1jmjDl8uKPu1IQ0pFweWn5N3eXalsi8rSalW1zi5UQFkH6Pp5
         g8uoHrBhk2srf4e0LBmCAHbMFcJjWVwzQ2HQg86Bfx5n4SX8XD6Y5s2Ith7mm1CgePH/
         M4HGDIfeq7KgV/x1pbc1+gqULZ9pI2p0yk+9n7QObgNEVXB27oScM/uy148y4ubay18h
         unbKNG2yWZ4DuQgYadZnE8rIlyhXIBES5pVZSzJyMPMdE4V75NJ6eiZso/5q3lba8T9W
         7m9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769710121; x=1770314921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3gMeLrc0kfCIp5iiLsgNdlUxrpKtjQ3FyJ13fmaichA=;
        b=Ntnk8kPIlYeK+j6MeUIG7e3dPNujA42RLrsyqfm/4R9uNaeEzTDDgyx5bd2lvSiH8Q
         EtDPFB32RvabGq6qZg7vPujR+8HV+0SS1H/AZJzFOHi9z0I3EwJ0k1YnLQhv+1Khzdl5
         ONzsuBA7DZy41mJfBBjMvAtPt9iqwGLFsKpOCx/y++jPL+sMXzF6bjgLU2Nz5CbsSZqO
         X4MIpbZuvsO5Zqckj8hMGKrhPg5tjQOLt095yZfdogtNISeT0AMrtpduavtvOJ0cQTxu
         1v/cuUhqcNSdav2Kk2GfcGfhLrM/LzBEpejnzDPDCky748DcSW27DYue9cpTM2f/vmz5
         cziw==
X-Gm-Message-State: AOJu0Ywd/NMqH/pBFXTPDdCr+GvPcaTG7YQfI+NFpqNFDtt9wqIPYRrR
	9CLPFQYEeDF59K8Jy2s+UdSCV+mI0GhZufXjW0AGtcZt8Y8XNhdJwmPMsg5j5Lr5IKYJBWadJt6
	F6XHWQHSh8WJVgNiSgf4FwmIj3GlrC41lh57gpQJOXCDRQ/vYleK06JY7P+w=
X-Gm-Gg: AZuq6aJ+nQy4FMeWMVGTjyH+LRXPHhlm50XxueLHCc30EXbQR8S44TA0vVVYPw6GJUy
	B3AY+UO5GAx+T2dRwuZJ+Gn69h2VkkxBv0sxSCcss6ARjGdQAe8HtoFwH3UfVTj+uaOCp+2Wncs
	l2l2l6SEqaJLURFJ6cTDFQpePm0BE8NxJKG7hVWLvzZDV6Wp4pFxsCNrGcFFDxVvjRAIjWwhgks
	z0Jht1bBjFZJxlMe5J660zeoxdwILuvmR4K8ZwJB6SsRDZGcOW/7NkObCCCThieBad6GC4=
X-Received: by 2002:a05:6402:1204:b0:64b:4674:9386 with SMTP id
 4fb4d7f45d1cf-658e2ed56dcmr87a12.14.1769710120573; Thu, 29 Jan 2026 10:08:40
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
 <CALMp9eRPNGwTKTv9VQ6O5U=KsNz73iF14+=QZvqHx4JbQKCLfQ@mail.gmail.com> <DG18AARFFER8.3POV7WD7KQKUU@amd.com>
In-Reply-To: <DG18AARFFER8.3POV7WD7KQKUU@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 29 Jan 2026 10:08:28 -0800
X-Gm-Features: AZwV_QgRVCMoCuhWipLfRvBV1BOos5dCdUPka103jLh4O8OzkP0MRfTQYZsiQQM
Message-ID: <CALMp9eQYZM2kk6Dxy1dAL5XeXWg2-y_2RP8EpBeUsUU1eyGiGQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nSVM: Expose SVM DecodeAssists to guest hypervisors
To: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
Cc: kvm@vger.kernel.org, Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69588-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6CC02B363B
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 8:54=E2=80=AFAM Alejandro Vallejo
<alejandro.garciavallejo@amd.com> wrote:
>
> Hi,
>
> I've been busy with other matters and didn't have time to push this throu=
gh,
> but I very definitely intend to.
>
> On Thu Jan 29, 2026 at 12:15 AM CET, Jim Mattson wrote:
> > On Thu, Jan 15, 2026 at 5:26=E2=80=AFAM Alejandro Vallejo
> > <alejandro.garciavallejo@amd.com> wrote:
> >>
> >> Enable exposing DecodeAssists to guests. Performs a copyout of
> >> the insn_len and insn_bytes fields of the VMCB when the vCPU has
> >> the feature enabled.
> >>
> >> Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
> >> ---
> >> I wrote a little smoke test for kvm-unit-tests too. I'll send it short=
ly in
> >> reply to this email.
> >> ---
> >>  arch/x86/kvm/cpuid.c      | 1 +
> >>  arch/x86/kvm/svm/nested.c | 6 ++++++
> >>  arch/x86/kvm/svm/svm.c    | 3 +++
> >>  3 files changed, 10 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index 88a5426674a10..da9a63c8289e5 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -1181,6 +1181,7 @@ void kvm_set_cpu_caps(void)
> >>                 VENDOR_F(FLUSHBYASID),
> >>                 VENDOR_F(NRIPS),
> >>                 VENDOR_F(TSCRATEMSR),
> >> +               VENDOR_F(DECODEASSISTS),
> >>                 VENDOR_F(V_VMSAVE_VMLOAD),
> >>                 VENDOR_F(LBRV),
> >>                 VENDOR_F(PAUSEFILTER),
> >> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> >> index ba0f11c68372b..dc8a8e67a22c2 100644
> >> --- a/arch/x86/kvm/svm/nested.c
> >> +++ b/arch/x86/kvm/svm/nested.c
> >> @@ -1128,6 +1128,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >>                 vmcb12->save.ssp        =3D vmcb02->save.ssp;
> >>         }
> >>
> >> +       if (guest_cpu_cap_has(vcpu, X86_FEATURE_DECODEASSISTS)) {
> >> +               memcpy(vmcb12->control.insn_bytes, vmcb02->control.ins=
n_bytes,
> >> +                      ARRAY_SIZE(vmcb12->control.insn_bytes));
> >> +               vmcb12->control.insn_len =3D vmcb02->control.insn_len;
> >> +       }
> >
> > This only works if the #VMEXIT is being forwarded from vmcb02. This
> > does not work if the #VMEXIT is synthesized by L0 (e.g. via
> > nested_svm_inject_npf_exit() or nested_svm_inject_exception_vmexit()
> > for #PF).
>
> I very definitely didn't consider that. Subtle. Thanks for bringing it up=
.
>
> >
> >>         vmcb12->control.int_state         =3D vmcb02->control.int_stat=
e;
> >>         vmcb12->control.exit_code         =3D vmcb02->control.exit_cod=
e;
> >>         vmcb12->control.exit_code_hi      =3D vmcb02->control.exit_cod=
e_hi;
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index 24d59ccfa40d9..8cf6d7904030e 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void)
> >>                 if (nrips)
> >>                         kvm_cpu_cap_set(X86_FEATURE_NRIPS);
> >>
> >> +               if (boot_cpu_has(X86_FEATURE_DECODEASSISTS))
> >> +                       kvm_cpu_cap_set(X86_FEATURE_DECODEASSISTS);
> >> +
> >>                 if (npt_enabled)
> >>                         kvm_cpu_cap_set(X86_FEATURE_NPT);
> >>
> >>
> >> base-commit: 0499add8efd72456514c6218c062911ccc922a99
> >
> > DECODEASSISTS consists of more than instruction bytes and instruction
> > length. There is also EXITINFO1 for MOV CRx, MOV DRx, INTn, and
> > INVLPG.
>
> Right, I didn't do anything about those because exit_info_1 is unconditio=
nally
> copied anyway when forwarding from vmcb02 to vmcb12. Of course that doesn=
't
> account for the emulation paths you mentioned before.
>
> > Since L2 typically gets dibs on a #VMEXIT (in
> > nested_svm_intercept()), these typically fall into the "forwarded
> > #VMEXIT" category. However, these instructions can also be emulated,
> > in which case the vmcb12 intercepts are checked and a #VMEXIT may be
> > synthesized. In that case, svm_check_intercept() needs to populate
> > EXITINFO1 appropriately.
>
> I'm trying to think of ways to test this.
>
> It's really quite subtle. So testing MOVs to/from CR/DR would be...
>
>   1. Take a page L0 always does trap-and-emulate on (IOAPIC? LAPIC? HPET?=
)
>   2. Map it on L2.
>   3. Have L1 intercept MOV to/from CR/DR
>   4. Have L2 do a MOV to/from CR/DR from/to that region.
>   5. Ensure the VMCB at the L1 has exit_info_1 correctly populated.
>
> INVLPG and INTn presumably would always be in the intercept union, so the=
se are
> unaffected.

Any of these instructions can be emulated. I think the easiest way to
test is FEP (force emulation prefix), which will result in a #UD
#VMEXIT to L0. Then, during emulation, if L0 finds the intercept bit
set in vmcb12, it will synthesize the appropriate #VMEXIT to L1.

> As for #PF and NPT intercepts... I don't _THINK_ they are affected either=
? I
> don't see which L1/L2 configs might make the L0 emulator execute an instr=
uction
> on behalf of the L2 and THEN exit to L1 with an exit code of #PF/NPT.

MOVBE on Bulldozer? (I don't actually have a Bulldozer to check.) KVM
is happy to emulate MOVBE on hardware that doesn't support it. See
KVM_GET_EMULATED_CPUID.

> Even considering FEP, that ought to affect L1, and not L2. And even if L2=
 had
> FEP enabled that would materialise as a forwarded #UD and not something e=
mulated
> by L0.

The #UD is handled by the host first. See nested_svm_exit_special().
Hence, FEP should result in emulation by L0. The main reason for this
is that if L0 advertises an instruction to L0 that hardware doesn't
support (e.g. MOVBE), then L0 is responsible for emulating that
instruction for both L1 and L2.

> So, unless I'm missing something (which I may very well be, seeing how I =
missed
> this already), synthesising exit_info_1 for the MOV to/from CR/DR ought t=
o
> suffice. Which is far less annoying than teaching the emulator to fetch m=
ore
> data than the current instruction, so I really hope I'm not wrong.
>
> Let me know otherwise, and thanks again for the review.
>
> Cheers,
> Alejandro

