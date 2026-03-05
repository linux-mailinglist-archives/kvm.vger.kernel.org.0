Return-Path: <kvm+bounces-72778-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHuJIJH9qGmD0AAAu9opvQ
	(envelope-from <kvm+bounces-72778-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 04:50:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D852E20AAAE
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 04:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B9603046539
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 03:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303DF285C88;
	Thu,  5 Mar 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aageIljE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04444125A0
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 03:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772682628; cv=pass; b=INAq8kKAF0zF0m+aF8fKJp2AfX78yjG7R4vbKAO5JrRFE+zl7OTGzR1UYP9V+pzHVdyTaWm4O7uUFqK5Qe1STocnExJwsCPqiE/wlDM0H8lebEzEhnOY3m2bxASEybkiJYVS+qDqVMR4zM8buNsFylkYIuqtIwrJlSih3zT+CSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772682628; c=relaxed/simple;
	bh=BO5i/YR2ZuddhG4rAZFNZ0SnYozz5plMGuJ7lqwoqnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQ7LxH2XlTb/zKqUxGkQxo4n52HO4XZfreJR3zLvwjJdIQa4UM/SV51NCSp8EIpDcY6gkdW+nHMtI+hGmeiPzDkhi1gHOejewANPY8VdyMu9urhfwy+ZOPjMZWHkOyVRLGQeFIu5gs18qGHLWwGvVtAIY7Odc+HjP0YCVfh/enw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aageIljE; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-89a0ece9f14so34453786d6.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 19:50:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772682626; cv=none;
        d=google.com; s=arc-20240605;
        b=IC7wsYgD/VhpXD7MilDmu8llSoHBLEKVqJlKgtcwcJHY7zb4uW3/cEI3lNyDmLwROl
         L7FJCO9YxBbtM18ij/QArl19BrDA/EwsptBa8VZ++dKBJElP1IxEOBZ/b3zqpmXgmSxW
         W+4TMdFpgR+GYrC9UBRR0X7J3BWEX6pLUcHD9VPn5VLl0mfVZlbDzs+MJPcGAiT5sLw7
         /W9uw6ARfKUxshWHEgF0B+655CnatU4oHEWN08tEFZ12G7QyVw6vJn2MT4LzOrl7xvvR
         /hbDHlxKsExfutkev1o8Cp0WwAcr16SwGgknS86Irgx1Ts3C69EhVoBu/x6aZN/p7wQd
         xqBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pAjqS9exVY2knZ5sc+jeODH/qiWdi8LmdRRzMrXpJFs=;
        fh=/FG2jwDrN1shw3sKtrS2x1h1DkdPS2wYAVIYS+HBm2k=;
        b=ZUle+64Wj+Q/D3BJQmIG7HMWrzPyoaiK+ZOecNKYoChtLFhHmaW2fx/zP23Y36n33X
         8cUbgE/4CWrxjxtZRVHQrEALHbXnMfi49FV3dAsu6sgNjBVQQiAdf/QSCAU40I5BHf0l
         cDfBKjXwDCPGUFwiJSCqei+cV2OJAdxZbmOcXs4NVtLmi0Qd45UWSqQ4w/zPIYxfWf1r
         50sZWOMRm5lkIs9oSWWMEf68QEI5UY4s0oZLPbpSwpXJYx7KrXIq8+oK/duKw7HsSE/+
         WmNUCdH14dj3Pu1mpedCn3Djg7ZPOqBuB/GN6p3892ODDhghhA479afknCxfyUULJIW0
         vwFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772682626; x=1773287426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAjqS9exVY2knZ5sc+jeODH/qiWdi8LmdRRzMrXpJFs=;
        b=aageIljEtnChPuWYJCzlNEbUinAiEmWHOAxDJPLZGqe6t6wTa/EtYBXdalwOMkJ1vi
         +apQwpzzseQ0q6sfq7DaI8FCPZUEff0Bo1khFL9IQar/9DqKv0kP1ziH5vF/2jAAGgdj
         HlOyvVT8aosnHsz+1ls17Z1hITXHII5xXkK546gvP9PEWwXyyUTXXDPknOfhIIcDsXoR
         atKpNjXY9cTKpeuCUijUlUa8ka3Sj87CEAzcWp13P2RaOxYskiMzcu8nwAOztx/DVO4H
         oV2h34Sf0TxZbhjC8L2cAi+dC6r6p6/T/gobMu4CSVuyzGv6l1kK9SAd8fRmSJfd4dgn
         uEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772682626; x=1773287426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pAjqS9exVY2knZ5sc+jeODH/qiWdi8LmdRRzMrXpJFs=;
        b=NIWA/DAseKbQ6g5JcEPtF1Xn2pp1JfehWYqxVONdG8RpyAMP3fZrLce1Ol8l3IA4lu
         8mengw2MX4w1J9/JykDG7h1bqvpSvfLBjC5wvyDP0glMnEyF/wkEejrmgCmCcjvDjGC+
         pZGYQYRcti0OORAFARR0P+fdGb/t2PVKkugaUi7lCpa3T+r7s5NMVAhL0VOHccZxQTkn
         bLKFdUivyvLtXzlePaKcXBmqAy4779FZOL6OIwJOVBo8FFpIAYShFEH7/VntVszRDQRR
         LwFYjVk7O+EThWbtotZNvgJsqm420hNur7OBkl5TRWRARh+szd+xhzvxrFPVT8D8F2+j
         56YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmuyukrgC+78yzy2yjzJUs0+2gyTyFqkZQIlBZscAIxJNDviV7BtZLFg3Vs0BFoYZy2fU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyYupNGEEaDokvlwsXp+dPEmBdCm/socu+MJLvRy2e2rvVBBQ3
	zdmBY7tL5AueMcIF1gLCC6u+IiqJUZ+V+/3eD5mryhKP+LB2zH7+ky+Hry3ZimDKut2nW5yYeD0
	lSOJ2VCwbrmEX6F7g5PzBBZSFvyeu76t1ZYaRH8hR
X-Gm-Gg: ATEYQzwplBQdC+usMyBftuoLxgcZNeyrgwTiqa6/+CbwzpOirAlUERnmK6epQbNez6V
	yuyrGDFD4BUEvrRjx3Hmdquh8FO/jKJmJ7/IME7jo2gh+0ez1gXPpd8T++WHWHKRiYBPotDAopA
	NW60Nsnag/ePPFxCA0y7BCvb9EucNWtI+cRxgPZ5DGh7agLrZ9N8qZcDI1mcX67OZ7YW/H/q1yT
	oCI0fwOFL9iyjlqUPZCUT8ChAJjAWR07aZwHJRDCvN/SBpdJS/cxLM4YMeZxpxpfcm0AgV6t4RG
	sJNONRjPBCTeu8cbyIONaBAW6daTy50/FdWqHCMpcQ==
X-Received: by 2002:a05:6214:1d22:b0:89a:954:c06 with SMTP id
 6a1803df08f44-89a19d1e7a6mr65068256d6.44.1772682625506; Wed, 04 Mar 2026
 19:50:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-3-chengkev@google.com>
 <aZ3VCq4s7l9f4JTw@google.com>
In-Reply-To: <aZ3VCq4s7l9f4JTw@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Wed, 4 Mar 2026 22:50:14 -0500
X-Gm-Features: AaiRm53tY21A3AUFgBNOeAfWcqOpTnmkIqFEtwzMUrG-i3EYI7YH8exENx80h7Y
Message-ID: <CAE6NW_a0dAS9j+erHzZgVT5zXcqAi=kxBt7=5m4JSxBSVvvbFA@mail.gmail.com>
Subject: Re: [PATCH V2 2/4] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D852E20AAAE
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
	TAGGED_FROM(0.00)[bounces-72778-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 11:42=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Feb 24, 2026, Kevin Cheng wrote:
> > When KVM emulates an instruction for L2 and encounters a nested page
> > fault (e.g., during string I/O emulation), nested_svm_inject_npf_exit()
> > injects an NPF to L1. However, the code incorrectly hardcodes
> > (1ULL << 32) for exit_info_1's upper bits when the original exit was
> > not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the fault
> > occurred on a page table page, preventing L1 from correctly identifying
> > the cause of the fault.
> >
> > Set PFERR_GUEST_PAGE_MASK in the error code when a nested page fault
> > occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK when
> > the fault occurs on the final GPA-to-HPA translation.
> >
> > Widen error_code in struct x86_exception from u16 to u64 to accommodate
> > the PFERR_GUEST_* bits (bits 32 and 33).
>
> Stale comment as this was moved to a separate patch.
>
> > Update nested_svm_inject_npf_exit() to use fault->error_code directly
> > instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if neithe=
r
> > PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this would
> > indicate a bug in the page fault handling code.
> >
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/mmu/paging_tmpl.h  | 22 ++++++++++------------
> >  arch/x86/kvm/svm/nested.c       | 19 +++++++++++++------
> >  3 files changed, 25 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index ff07c45e3c731..454f84660edfc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -280,6 +280,8 @@ enum x86_intercept_stage;
> >  #define PFERR_GUEST_RMP_MASK BIT_ULL(31)
> >  #define PFERR_GUEST_FINAL_MASK       BIT_ULL(32)
> >  #define PFERR_GUEST_PAGE_MASK        BIT_ULL(33)
> > +#define PFERR_GUEST_FAULT_STAGE_MASK \
> > +     (PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)
> >  #define PFERR_GUEST_ENC_MASK BIT_ULL(34)
> >  #define PFERR_GUEST_SIZEM_MASK       BIT_ULL(35)
> >  #define PFERR_GUEST_VMPL_MASK        BIT_ULL(36)
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_t=
mpl.h
> > index 37eba7dafd14f..f148c92b606ba 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -385,18 +385,12 @@ static int FNAME(walk_addr_generic)(struct guest_=
walker *walker,
> >               real_gpa =3D kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(tabl=
e_gfn),
> >                                            nested_access, &walker->faul=
t);
> >
> > -             /*
> > -              * FIXME: This can happen if emulation (for of an INS/OUT=
S
> > -              * instruction) triggers a nested page fault.  The exit
> > -              * qualification / exit info field will incorrectly have
> > -              * "guest page access" as the nested page fault's cause,
> > -              * instead of "guest page structure access".  To fix this=
,
> > -              * the x86_exception struct should be augmented with enou=
gh
> > -              * information to fix the exit_qualification or exit_info=
_1
> > -              * fields.
> > -              */
> > -             if (unlikely(real_gpa =3D=3D INVALID_GPA))
> > +             if (unlikely(real_gpa =3D=3D INVALID_GPA)) {
> > +#if PTTYPE !=3D PTTYPE_EPT
>
> I would rather swap the order of patches two and three, so that we end up=
 with
> a "positive" if-statement.  I.e. add EPT first so that we get (spoiler al=
ert):
>
> #if PTTYPE =3D=3D PTTYPE_EPT
>                         walker->fault.exit_qualification |=3D EPT_VIOLATI=
ON_GVA_IS_VALID;
> #else
>                         walker->fault.error_code |=3D PFERR_GUEST_PAGE_MA=
SK;
> #endif
>
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd5..1013e814168b5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -40,18 +40,25 @@ static void nested_svm_inject_npf_exit(struct kvm_v=
cpu *vcpu,
> >       struct vmcb *vmcb =3D svm->vmcb;
> >
> >       if (vmcb->control.exit_code !=3D SVM_EXIT_NPF) {
> > -             /*
> > -              * TODO: track the cause of the nested page fault, and
> > -              * correctly fill in the high bits of exit_info_1.
> > -              */
> > -             vmcb->control.exit_code =3D SVM_EXIT_NPF;
> > -             vmcb->control.exit_info_1 =3D (1ULL << 32);
> > +             vmcb->control.exit_info_1 =3D fault->error_code;
> >               vmcb->control.exit_info_2 =3D fault->address;
> >       }
> >
> > +     vmcb->control.exit_code =3D SVM_EXIT_NPF;
> >       vmcb->control.exit_info_1 &=3D ~0xffffffffULL;
> >       vmcb->control.exit_info_1 |=3D fault->error_code;
> >
> > +     /*
> > +      * All nested page faults should be annotated as occurring on the
> > +      * final translation *or* the page walk. Arbitrarily choose "fina=
l"
> > +      * if KVM is buggy and enumerated both or neither.
> > +      */
> > +     if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
> > +                                PFERR_GUEST_FAULT_STAGE_MASK) !=3D 1))=
 {
> > +             vmcb->control.exit_info_1 &=3D ~PFERR_GUEST_FAULT_STAGE_M=
ASK;
> > +             vmcb->control.exit_info_1 |=3D PFERR_GUEST_FINAL_MASK;
> > +     }
>
> This is all kinds of messy.  KVM _appears_ to still rely on the hardware-=
reported
> address + error_code
>
>         if (vmcb->control.exit_code !=3D SVM_EXIT_NPF) {
>                 vmcb->control.exit_info_1 =3D fault->error_code;
>                 vmcb->control.exit_info_2 =3D fault->address;
>         }
>
> But then drops bits 31:0 in favor of the fault error code.  Then even mor=
e
> bizarrely, bitwise-ORs bits 63:32 and WARNs if multiple bits in
> PFERR_GUEST_FAULT_STAGE_MASK are set.  In practice, the bitwise-OR of 63:=
32 is
> _only_ going to affect PFERR_GUEST_FAULT_STAGE_MASK, because the other de=
fined
> bits are all specific to SNP, and KVM doesn't support nested virtualizati=
on for
> SEV+.
>
> So I don't understand why this isn't simply:
>
>         vmcb->control.exit_code =3D SVM_EXIT_NPF;
>         vmcb->control.exit_info_1 =3D fault->error_code;
>

Hmmm yes I do think it can be replaced by this but we would also need
to grab the address from the walker. So

        vmcb->control.exit_code =3D SVM_EXIT_NPF;
        vmcb->control.exit_info_1 =3D fault->error_code;
        vmcb->control.exit_info_2 =3D fault->address;

For example, in the selftest that I wrote we should be populating the
exit_info_2 with the faulting address from the walker, not the
original hardware reported address which is related to IO.

>         /*
>          * All nested page faults should be annotated as occurring on the
>          * final translation *or* the page walk. Arbitrarily choose "fina=
l"
>          * if KVM is buggy and enumerated both or neither.
>          */
>         if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
>                                    PFERR_GUEST_FAULT_STAGE_MASK) !=3D 1))=
 {
>                 vmcb->control.exit_info_1 &=3D ~PFERR_GUEST_FAULT_STAGE_M=
ASK;
>                 vmcb->control.exit_info_1 |=3D PFERR_GUEST_FINAL_MASK;
>         }
>
> Which would more or less align with the proposed nEPT handling.
>
> > +
> >       nested_svm_vmexit(svm);
> >  }
> >
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >

