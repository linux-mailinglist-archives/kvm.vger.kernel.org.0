Return-Path: <kvm+bounces-70245-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGjMBCN1g2mFmwMAu9opvQ
	(envelope-from <kvm+bounces-70245-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:34:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E89EA4DF
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A0A9630445ED
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 16:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1316D427A07;
	Wed,  4 Feb 2026 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lpgnz8s5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0333A8FE0
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 16:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770222150; cv=pass; b=LUZOS7yNp17gX+Ihyo1sl23qQB/1JgnCxCuTQF7740g0mSGvGcXY8UH8AHyEAEE/saOWII7lUj9YqMu7Ikbzmtb48rcL0l5IyoFSfQopVNrkAioqoIZ7ltu503I/XgXHNbCX70GEwXkSCplX2f7NIhj5HkvO/Y5/MyWcb9DW0CI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770222150; c=relaxed/simple;
	bh=pUtol5eaIeTn0uM3Bn9V2flw3Bw0p4Gjmxvuqr05MW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mgJ1CJwWbjgXZjLVh593uHTc6xM3Wqq9Wv8UsuRoFNwBoMZx31WyB5VUt0IMoPaBZN/wlDo6c+cWM8DDaxij4VAFE7qXN13sy0MDSMacwiZ7rEJjDW2wZJlAh04G3OZXzdAnUUVGwTbPbBa+4fd2WvTv+TNBJo64pwPo/xmR3wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lpgnz8s5; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8887ac841e2so64580456d6.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 08:22:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770222149; cv=none;
        d=google.com; s=arc-20240605;
        b=dk/1u0mdrh6nL08aY+MwvVsntoUAQzri2TN06YFvf2g7SLvdtyX36LOgzNonhiUmpb
         D6Xa+hP/qhlDbRbvVpaLAb06Wgrp7bcd+ZyASAMXbx0ILiu0eKmTFS81fcYvUpWEu2MK
         GUdVXzc6+BpP8/y1Jx5tLjFEUSq/orvAQXMH+FtQrrpXXMbwXuzJJaPEkSRQeLUR6AZC
         9CPGzd7hoyqKGDKD09Hb3j2KIZ9B+8Cajfhl7pbtu21GU2/a/jQ4owI+fw5WM9kLY3fQ
         IPYrKSlcNxEw50wDB3KeSIBgBV5Ov9AYKICjZtPKJ+7qFEnm8YeifQAxQ+QJJgLCmDDj
         KjsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ddqXC4NQboI88tKP0R6qEYEEVvuGsZ52bcVcC2gy5wk=;
        fh=QwlIhdCBhh+iCQ4wlEuJ99E/x+UHJ8ecJ/PFwcP6x0E=;
        b=ZTPRHf+0qRyLcihNmS+ai/YO8v3I1kQmVHEtEhw4oqKAhJ4pOAkTQByRa0j3zUKSYQ
         h2VaWm5odmckjjnmy8G3mxPr6ajql+o9rMQ/qNEOoV1p7IFAhlTZJyHDOZ7G/JnYkXsx
         0ClMBLW1mnJCXT82BSp1uhcgNb8lUceUyydevSQtqKtjr4lRyJtNgzcWgqXv07k/r+Om
         PBi+9bYmcCb1s4FJ0skGH9yR4h9e/spvxnI9abYiKG5fhd6jOAcdgwy3Xg/S+jceQZG3
         5pbAzZBrbANUkmGLEQcGl0nNpPHeE2Ihs/fQqLYUal1xmE/Wqlq/hJfDqbujKRO+bSGy
         QXvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770222149; x=1770826949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddqXC4NQboI88tKP0R6qEYEEVvuGsZ52bcVcC2gy5wk=;
        b=lpgnz8s5egSZ1FN9CSCylcdZx4KOBMHYi9ScZHRxL3UTKqJ2Q2qSdI/Z5j0oV0SWk4
         Wv10CpWDht4DtGe4TRCgYgrHxmtxo/Z1alGCU5kLhzGFUNgEfOMK9oZyu28ohn93ryGN
         VVVboDRgZXv9Y+wu6RxGOioGFjLHumwdJZQf15lFKy/fDbD6OPiu6T6cbWTJsv571VlY
         m6iH+or9U8RJYrU+RdELbiZlye4FeW3dhk+qkNb/4raivv/+z/cliPqLOBRUBLtOBoDR
         Trfnj+7Xx2oBu7vcBnKM64VvXod+QiqEWXairFmhZg6UzZiGiTOsOP/7O4am6jWbX0Ky
         H8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770222149; x=1770826949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ddqXC4NQboI88tKP0R6qEYEEVvuGsZ52bcVcC2gy5wk=;
        b=JdFEzWOGpq4kzi9HTHAxy4yXv2Z5NOiVWorif4PxjLfeo3UkQvJhGGSc2fL+Y+pOqA
         1f/ZQBh36PVEm7cJO5Yjn9Ug7NSpnrtBZgg1BsSBarG6v5fbCgKG15zol/5msammFNs7
         dQFI0aTu8vDYX2yIALexfHOmyJd76ssHW3bGZ6AUi1PmOHDoKvEJQ4KunNUN+rJXF109
         GJqMVjh8m7oY4cClDLqP0dG2kX12Qb0xHZzsn9P4HnYw1+5LmogZ+FOHJLlK7Xe3AJJC
         Ayf1SU6C7P4WIOxHy1zqDJuZUoWnwquRYv4nNDSPd3s1Mbk1GafoKc+WU1muobsYbWff
         lNow==
X-Forwarded-Encrypted: i=1; AJvYcCXmassWczc0Wx8AIq242Y/BR/R/VX3gPs9wImATjxYAFgYK5u+Yc05r/k6Ecf3u5J0NeGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG6Yjj6Vo6jLV0SA7Js8RPbAHetND2qKFY7McjbyY1RfX0RK4g
	yF6JJaipDHB5exR6s3CRmwBec54qNYo28V0VCXhIfbjVMFeef6Jn9t0L7vNEAH0Mhz9dLB+UpHG
	1Oc9SKtNMvCncExQj/RJlBCRPhzW41xSd0cbYxIxz
X-Gm-Gg: AZuq6aKN0E2MXTUZIILfxwQvVdDurmNUyTkFrGI3vPIMdm58GWZb5WiCF+GsoX7/2fV
	83w9/7i0ShkaUNB8KP64cbKasVxFodpt5M7cqlKYsybPklaRwdstodofsqZUOkEJkpkE6azOt/w
	34If+KqZyVZnbUGAOMNk1oYuOZc92WFpA2RJDPa8PvFIY324XuvOhMQSV5+icuDQvN8TWrQiwGN
	CblEM2hyGmDwQN/uylyYmvqbiDxSkUOEETwcmkT5sMVfj9chzsqXzNceAiIGebGJXj9g45vYLXU
	urxdMTTYTNmspV7hbUpqCPnQo9JGEQ==
X-Received: by 2002:a05:6214:1c8a:b0:895:1d59:5aa6 with SMTP id
 6a1803df08f44-89522133a7dmr47418696d6.24.1770222148338; Wed, 04 Feb 2026
 08:22:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com> <20260121004906.2373989-2-chengkev@google.com>
 <aXFOPP3P-HE6YbEZ@google.com> <sdyb3l4ihmcd7uxb6wivkyknmzy4bcctqyyidxq7hr2d2jfs6e@iz3fhfp6t4ss>
 <aXov3WWozd2UIFXw@google.com>
In-Reply-To: <aXov3WWozd2UIFXw@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Wed, 4 Feb 2026 11:22:17 -0500
X-Gm-Features: AZwV_QjNW9_6ij7DtwGROPIT-ToBvW8jJnQ8zpy7Sj9cym0DpWqPFbTEOgoaewY
Message-ID: <CAE6NW_YexKSp19uATMQschZbbvon=Cdhv4EH6tRf-FNzgtL6ew@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70245-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 33E89EA4DF
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 10:48=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Jan 22, 2026, Yosry Ahmed wrote:
> > On Wed, Jan 21, 2026 at 02:07:56PM -0800, Sean Christopherson wrote:
> > > On Wed, Jan 21, 2026, Kevin Cheng wrote:
> > > > When KVM emulates an instruction for L2 and encounters a nested pag=
e
> > > > fault (e.g., during string I/O emulation), nested_svm_inject_npf_ex=
it()
> > > > injects an NPF to L1. However, the code incorrectly hardcodes
> > > > (1ULL << 32) for exit_info_1's upper bits when the original exit wa=
s
> > > > not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the f=
ault
> > > > occurred on a page table page, preventing L1 from correctly identif=
ying
> > > > the cause of the fault.
> > > >
> > > > Set PFERR_GUEST_PAGE_MASK in the error code when a nested page faul=
t
> > > > occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK w=
hen
> > > > the fault occurs on the final GPA-to-HPA translation.
> > > >
> > > > Widen error_code in struct x86_exception from u16 to u64 to accommo=
date
> > > > the PFERR_GUEST_* bits (bits 32 and 33).
> > >
> > > Please do this in a separate patch.  Intel CPUs straight up don't sup=
port 32-bit
> > > error codes, let alone 64-bit error codes, so this seemingly innocuou=
s change
> > > needs to be accompanied by a lengthy changelog that effectively audit=
s all usage
> > > to "prove" this change is ok.
> >
> > Semi-jokingly, we can add error_code_hi to track the high bits and
> > side-step the problem for Intel (dejavu?).
>
> Technically, it would require three fields: u16 error_code, u16 error_cod=
e_hi,
> and u32 error_code_ultra_hi.  :-D
>
> Isolating the (ultra) hi flags is very tempting, but I worry that it woul=
d lead
> to long term pain, e.g. because inevitably we'll forget to grab the hi fl=
ags at
> some point.  I'd rather audit the current code and ensure that KVM trunca=
tes the
> error code as needed.
>
> VMX is probably a-ok, e.g. see commit eba9799b5a6e ("KVM: VMX: Drop bits =
31:16
> when shoving exception error code into VMCS").  I'd be more worred SVM, w=
here
> it's legal to shove a 32-bit value into the error code, i.e. where KVM mi=
ght not
> have existing explicit truncation.

As I understand it, intel CPUs don't allow for setting bits 31:16 of
the error code, but AMD CPUs allow bits 31:16 to be set. The
86_exception error_code field is u16 currently so it is always
truncated to u16 by default. In that case, after widening the error
code to 64 bits, do I have to ensure that any usage of the error that
isn't for NPF, has to truncate it to 16 bits? Or do I just need to
verify that all SVM usages of the error_code for exceptions truncate
the 64 bits down to 32 bits and all VMX usages truncate to 16 bits?

Just wanted to clarify because I think the wording of that statement
is confusing me into thinking that maybe there is something wrong with
32 bit error codes for SVM?

If the only usage of the widened field is NPF, wouldn't it be better
to go with an additional field like Yosry suggested (I see that VMX
has the added exit_qualification field in the struct)?

>
> > > > Update nested_svm_inject_npf_exit() to use fault->error_code direct=
ly
> > > > instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if ne=
ither
> > > > PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this wo=
uld
> > > > indicate a bug in the page fault handling code.
> > > >
> > > > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > [..]
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index de90b104a0dd5..f8dfd5c333023 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -40,18 +40,17 @@ static void nested_svm_inject_npf_exit(struct k=
vm_vcpu *vcpu,
> > > >   struct vmcb *vmcb =3D svm->vmcb;
> > > >
> > > >   if (vmcb->control.exit_code !=3D SVM_EXIT_NPF) {
> > > > -         /*
> > > > -          * TODO: track the cause of the nested page fault, and
> > > > -          * correctly fill in the high bits of exit_info_1.
> > > > -          */
> > > > -         vmcb->control.exit_code =3D SVM_EXIT_NPF;
> > > > -         vmcb->control.exit_info_1 =3D (1ULL << 32);
> > > > +         vmcb->control.exit_info_1 =3D fault->error_code;
> > > >           vmcb->control.exit_info_2 =3D fault->address;
> > > >   }
> > > >
> > > > + vmcb->control.exit_code =3D SVM_EXIT_NPF;
> > > >   vmcb->control.exit_info_1 &=3D ~0xffffffffULL;
> > > >   vmcb->control.exit_info_1 |=3D fault->error_code;
> > >
> > > So... what happens when exit_info_1 already has PFERR_GUEST_PAGE_MASK=
, and then
> > > @fault sets PFERR_GUEST_FINAL_MASK?  Presumably that can't/shouldn't =
happen,
> > > but nothing in the changelog explains why such a scenario is
> > > impossible, and nothing in the code hardens KVM against such goofs.
> >
> > I guess we can update the WARN below to check for that as well, and
> > fallback to the current behavior (set PFERR_GUEST_FINAL_MASK):
> >
> >       fault_stage =3D vmcb->control.exit_info_1 &
> >                       (PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK);
> >       if (WARN_ON_ONCE(fault_stage !=3D PFERR_GUEST_FINAL_MASK &&
> >                        fault_stage !=3D PFERR_GUEST_PAGE_MASK))
> >               vmcb->control.exit_info_1 |=3D PFERR_GUEST_FINAL_MASK;
>
> Except that doesn't do the right thing if both bits are set.  And we can =
use
> hweight64(), which is a single POPCNT on modern CPUs.
>
> Might be easiest to add something like PFERR_GUEST_FAULT_STAGE_MASK, then=
 do:
>
>         /*
>          * All nested page faults should be annotated as occuring on the =
final
>          * translation *OR* the page walk.  Arbitrarily choose "final" if=
 KVM
>          * is buggy and enumerated both or none.
>          */
>         if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
>                                    PFERR_GUEST_FAULT_STAGE_MASK) !=3D 1))=
 {
>                 vmcb->control.exit_info_1 &=3D ~PFERR_GUEST_FAULT_STAGE_M=
ASK;
>                 vmcb->control.exit_info_1 |=3D PFERR_GUEST_FINAL_MASK;
>         }

