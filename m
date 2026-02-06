Return-Path: <kvm+bounces-70512-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FFGFX5VhmlzMAQAu9opvQ
	(envelope-from <kvm+bounces-70512-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 21:56:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7691034D9
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 21:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C71133012504
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 20:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D4E311959;
	Fri,  6 Feb 2026 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RJ/DHXBU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E283101C6
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 20:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770411383; cv=pass; b=Fii4QV97hBZR9bYN0SRYJhgm3rW5D4CMs1HutMuFuqRj3n1t+ygWIEYZY6PqsCeCfJXaDCECxK8CSfxepmpsXAp3xrudaKWCqxkWqhMy1zZ9mKvgit59hL5i6idhbv9FGApPBb4JMeG2mCSUg8LyP6C3F1pkX86vHp6GJUzt8lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770411383; c=relaxed/simple;
	bh=p8aJ9pW1lVnYvcyjbp369lh6J5rkJu/fNUaQ22AfWbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oOduEDeZEn9y2AS+if6NbeyWf52RDCW0NcGvBr35+k73FbsQZamINn9j9t0+5k9tZ4iClt6eYkowsiNQ7VSIQRJrhSnoso+8Rp1Ja5uMx/XVtbmudcluznKcYeYOlckQe/sFzHZi7j8qQP3ipGthlGs4RJhCHdqVfoFZRWSmNQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RJ/DHXBU; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so372a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 12:56:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770411381; cv=none;
        d=google.com; s=arc-20240605;
        b=i5zscJZhN2NrmRVfMXaLLhR0Js4PqK5eu+KtYzfDY5yy6dGOk+JHXqUXsx/XF4iwH6
         RWgMBhIAAHxx19lUNQrzwQj36BXFoHU6GjOBxUggOstWo7pE9tOIg94/JOIvsPh5BqhK
         Ejy5wWiQSC+8z5FdpUq44UMrOqi5RVZwII1cUNW5fhU0a0k18w5nnOfW2uR68HvE+EoC
         3xoIaahhgovLhpj2i93BarUSA7k7xHt33IRqTl35Z132+iADFUB1NOAH4okQqzXAdrXo
         Cojvupti0JKXTKcn83r4RnYxgpsmUDxw1lcGMhesAcG9Knref2xqbo56Epv3zKcAttGD
         Nbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IMLlqNmZgOCin6mFL1FjWfGJBm5QWO4n5mmk9zmM7Rc=;
        fh=d1k9mvT7fX7sPVIHrXpd6Q6uIxPGu960DbqgFBiqHGA=;
        b=PHDVPLpcQpnVf/bldp3U5eAyF+4xyfB2DDYqfyWalVOj1HdTzGqOxOOcZP/yedFw6T
         pXniO9FuMKFd+9ian1cj4jnSwRo5DPQiqqNwBJYOwMLXCGJ8EZ6UuJuo7x9Ezc/rfLQn
         5bNeVBv2Ihn3smw9RATJE6MEC5E5lFhKyTNT8WvsqQ40BXgW8RMuEZm4S5Gj469XeDXW
         LSFWml5Oe3RcpPxubItphRoyI3RyeCfBWiK+vw45YG/c/e+D/btK4u3kz4BTDnQYcu1T
         O57zOfBmWSPnq9rXetjq8BW0FRF/vwJLh29h8v6g1w3gIm0brBxs5U5Y+VYXX+/xMKTO
         KNDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770411381; x=1771016181; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMLlqNmZgOCin6mFL1FjWfGJBm5QWO4n5mmk9zmM7Rc=;
        b=RJ/DHXBUhMeFLw1/tqw+7oXVpirF2KNMIWLeRFj3mvpgd2zquGgs+Uai35C+rMsbXG
         MKtUz9U/My//q2UrK2ugLEB4eWWXt0BEFRymgro397DzrtDRfjFTxkxR/B/Zt41URT8E
         YNov4hfroaRIRgmgUSzKFeZEuMNOEYzM5aEqzLQu5jjevBQH5imLVXkExNyQsWhhYa8i
         zcrGX8OkHhwJy2LkNi9boS/GTJriO9gIZrwt82J/0PrcvL4o0k6qiiMI6oWoz4tV/U5o
         wO7RX2Rj6b9FVcpfumThas6ritCUBiUWvIay+ULAKo7pj8P3eU5g+exbf18zb9IdqkF1
         5Tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770411381; x=1771016181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IMLlqNmZgOCin6mFL1FjWfGJBm5QWO4n5mmk9zmM7Rc=;
        b=EkwoGGBkLzv1iDp+x5emshjmbZnMbcUCyZZE3kIxQeYSDKyIEk1npI9V1DVVAX8Ayv
         LtWnP+u4uy1xYJLz+il8KcUM1kYiIu4oLwnq0ZxHocMFb7dz7aBjx06h/yrLSszVU4IE
         FkV66rxbnGJ/HoW3kjChAGFJu/sBTu4ULAcbMSXgN1I9JIfLqydSUxMmG4Spo7LcO/Tv
         bYQhkFycB1826kmwa3Ww2LgjZw6n1g3Bto83zA2GTQP7wjY8/efRstcMYLyHg12BMo9G
         Xl7730sxiJ1PXpAwr1ox7pVjbfs3F3EdRjHzpyEIloR3zOVHKKeSXGMZZvReC7cb2xi8
         So6w==
X-Forwarded-Encrypted: i=1; AJvYcCUgleshPY/K0yheZqnv8sJAIXjqyKHO7A/H6M3UtkAIRyIQrrIVHp3yd6aWjfa46U0FATY=@vger.kernel.org
X-Gm-Message-State: AOJu0YycaQEUhCYND938dR45eTzOIdGnS/bJT9JhXg1pavZgAtHP/OU3
	1wJIo/bjTv9jU7HHQQQDlvOmuNtiXRxyPGu3WivfqC+KeJZHhjJM2eGp4A8XNT555HAnrdUxQcG
	7veFWVaOmWGiM8jj4dlDZic0R43oGy5TR1IEu+tOH
X-Gm-Gg: AZuq6aIgPP0ZPmelZYCOXzIZseJ2Nm/dHWU4PysVuHwrEVg4GjY5WXJSCNrGPNnVarU
	Lhsooh7phzUIbOujoSZJ1tTPJRsisZ+psUXR6KUzQDdKnbEqEcUbA8T04AXKkXZlwi/8cbUucQH
	rHxe2wsmw//sYBMyrgdNer5Q7DRuaRZ/ZVi+lpTrmXR1k1Chsxvt3o09rDcqAeZK5PPs5taUQCC
	GEaRXTlERBTiLHtVoBnV+u30HKUBQp2aElzVDoV0Efo1ElEHqUzznAxb59lyfP47cgI4z00cRUs
	sgT7sg==
X-Received: by 2002:aa7:c98e:0:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-659a9c16313mr36a12.7.1770411381005; Fri, 06 Feb 2026 12:56:21
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com> <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
 <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com> <aYY9JOMDBPDY48lA@google.com>
In-Reply-To: <aYY9JOMDBPDY48lA@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Feb 2026 12:56:08 -0800
X-Gm-Features: AZwV_Qh1ss6E5RyT4zco_TTGB7j-9U4BzSwbS370avUNTOERPTKJEvVWLeJUHHM
Message-ID: <CALMp9eSRj=aykY7FbnPm1OgSwFSkJ=uVVmwsnGjV-A_-AQjxMQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70512-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: EA7691034D9
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 11:12=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 06, 2026, Jim Mattson wrote:
> > On Fri, Feb 6, 2026 at 10:23=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.=
dev> wrote:
> > >
> > > February 6, 2026 at 10:19 AM, "Sean Christopherson" <seanjc@google.co=
m> wrote:
> > >
> > >
> > > >
> > > > On Thu, Feb 05, 2026, Jim Mattson wrote:
> > > >
> > > > >
> > > > > Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issu=
es, and
> > > > >  add a validity check so that when nested paging is enabled for v=
mcb12, an
> > > > >  invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_I=
NVALID, as
> > > > >  specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT.=
"
> > > > >
> > > > >  Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> > > > >  Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > >  ---
> > > > >  arch/x86/kvm/svm/nested.c | 4 +++-
> > > > >  arch/x86/kvm/svm/svm.h | 3 +++
> > > > >  2 files changed, 6 insertions(+), 1 deletion(-)
> > > > >
> > > > >  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested=
.c
> > > > >  index f72dbd10dcad..1d4ff6408b34 100644
> > > > >  --- a/arch/x86/kvm/svm/nested.c
> > > > >  +++ b/arch/x86/kvm/svm/nested.c
> > > > >  @@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcp=
u)
> > > > >
> > > > >  nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > > > >  nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > > > >  + svm->nested.gpat =3D vmcb12->save.g_pat;
> > > > >
> > > > >  if (!nested_vmcb_check_save(vcpu) ||
> > > > >  - !nested_vmcb_check_controls(vcpu)) {
> > > > >  + !nested_vmcb_check_controls(vcpu) ||
> > > > >  + (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat)))=
 {
> > > > >  vmcb12->control.exit_code =3D SVM_EXIT_ERR;
> > > > >  vmcb12->control.exit_info_1 =3D 0;
> > > > >  vmcb12->control.exit_info_2 =3D 0;
> > > > >  diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > >  index 986d90f2d4ca..42a4bf83b3aa 100644
> > > > >  --- a/arch/x86/kvm/svm/svm.h
> > > > >  +++ b/arch/x86/kvm/svm/svm.h
> > > > >  @@ -208,6 +208,9 @@ struct svm_nested_state {
> > > > >  */
> > > > >  struct vmcb_save_area_cached save;
> > > > >
> > > > >  + /* Cached guest PAT from vmcb12.save.g_pat */
> > > > >  + u64 gpat;
> > > > >
> > > > Shouldn't this go in vmcb_save_area_cached?
> > >
> > > I believe Jim changed it after this discussion on v2: https://lore.ke=
rnel.org/kvm/20260115232154.3021475-4-jmattson@google.com/.
>
> LOL, oh the irony:
>
>   I'm going to cache it on its own to avoid confusion.
>
> > Right. The two issues with putting it in vmcb_save_area_cached were:
> >
> > 1. Checking all of vmcb_save_area_cached requires access to the
> > corresponding control area (or at least the boolean, "NTP enabled.")
>
> Checking the control area seems like the right answer (I went down that p=
ath
> before reading this).
>
> > 2. In the nested state serialization payload, everything else in the
> > vmcb_save_area_cached comes from L1 (host state to be restored at
> > emulated #VMEXIT.)
>
> Hmm, right, but *because* it's ignored, that gives us carte blanche to cl=
obber it.
> More below.
>
> > The first issue was a little messy, but not that distasteful.
>
> I actually find it the opposite of distasteful.  KVM definitely _should_ =
be
> checking the controls, not the vCPU state.  If it weren't for needing to =
get at
> MAXPHYADDR in CPUID, I'd push to drop @vcpu entirely.
>
> > The second issue was really a mess.
>
> I'd rather have the mess contained and document though.  Caching g_pat ou=
tside
> of vmcb_save_area_cached bleeds the mess into all of the relevant nSVM co=
de, and
> doesn't leave any breadcrumbs in the code/comments to explain that it "ne=
eds" to
> be kept separate.
>
> AFAICT, the only "problem" is that g_pat in the serialization payload wil=
l be
> garbage when restoring state from an older KVM.  But that's totally fine,=
 precisely
> because L1's PAT isn't restored from vmcb01 on nested #VMEXIT, it's alway=
s resident
> in vcpu->arch.pat.  So can't we just do this to avoid a spurious -EINVAL?
>
>         /*
>          * Validate host state saved from before VMRUN (see
>          * nested_svm_check_permissions).
>          */
>         __nested_copy_vmcb_save_to_cache(&save_cached, save);
>
>         /*
>          * Stuff gPAT in L1's save state, as older KVM may not have saved=
 L1's
>          * gPAT.  L1's PAT, i.e. hPAT for the vCPU, is *always* tracked i=
n
>          * vcpu->arch.pat, i.e. gPAT is a reflection of vcpu->arch.pat, n=
ot the
>          * other way around.
>          */
>         save_cached.g_pat =3D vcpu->arch.pat;

Your comment is a bit optimistic. Qemu, for instance, hasn't restored
MSRs yet, so vcpu->arch.pat will actually be the current vCPU's PAT
(in the case of snapshot restore, some future PAT). But, in any case,
it should be a valid PAT.

>         if (!(save->cr0 & X86_CR0_PG) ||
>             !(save->cr0 & X86_CR0_PE) ||
>             (save->rflags & X86_EFLAGS_VM) ||
>             !nested_vmcb_check_save(vcpu, &ctl_cached, &save_cached))

Wrong ctl_cached. Those are the vmcb02 controls, but we are checking
the vmcb01 save state.

I think it would be better to add a boolean argument, "check_gpat,"
which will be false at this call site and nested_npt_enabled(vcpu) at
the other call site.

>                 goto out_free;
>
> Oh, and if we do plumb in @ctrl to __nested_vmcb_check_save(), I vote to
> opportunistically drop the useless single-use wrappers (probably in a sta=
ndalone
> patch to plumb in @ctrl).  E.g. (completely untested)
>
> ---
>  arch/x86/kvm/svm/nested.c | 71 ++++++++++++++++++---------------------
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  arch/x86/kvm/svm/svm.h    |  6 ++--
>  3 files changed, 35 insertions(+), 44 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index a7d6fc1382a7..a429947c8966 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -339,8 +339,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcp=
u *vcpu, u64 pa, u32 size)
>             kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
>  }
>
> -static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> -                                        struct vmcb_ctrl_area_cached *co=
ntrol)
> +static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> +                                      struct vmcb_ctrl_area_cached *cont=
rol)
>  {
>         if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
>                 return false;
> @@ -367,8 +367,9 @@ static bool __nested_vmcb_check_controls(struct kvm_v=
cpu *vcpu,
>  }
>
>  /* Common checks that apply to both L1 and L2 state.  */
> -static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> -                                    struct vmcb_save_area_cached *save)
> +static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> +                                  struct vmcb_ctrl_area_cached *ctrl,
> +                                  struct vmcb_save_area_cached *save)
>  {
>         if (CC(!(save->efer & EFER_SVME)))
>                 return false;
> @@ -399,25 +400,13 @@ static bool __nested_vmcb_check_save(struct kvm_vcp=
u *vcpu,
>         if (CC(!kvm_valid_efer(vcpu, save->efer)))
>                 return false;
>
> +       if (CC(ctrl->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
> +              !kvm_pat_valid(save->g_pat))
> +               return false;
> +
>         return true;
>  }
>
> -static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
> -{
> -       struct vcpu_svm *svm =3D to_svm(vcpu);
> -       struct vmcb_save_area_cached *save =3D &svm->nested.save;
> -
> -       return __nested_vmcb_check_save(vcpu, save);
> -}
> -
> -static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> -{
> -       struct vcpu_svm *svm =3D to_svm(vcpu);
> -       struct vmcb_ctrl_area_cached *ctl =3D &svm->nested.ctl;
> -
> -       return __nested_vmcb_check_controls(vcpu, ctl);
> -}
> -
>  /*
>   * If a feature is not advertised to L1, clear the corresponding vmcb12
>   * intercept.
> @@ -504,6 +493,9 @@ static void __nested_copy_vmcb_save_to_cache(struct v=
mcb_save_area_cached *to,
>
>         to->dr6 =3D from->dr6;
>         to->dr7 =3D from->dr7;
> +
> +       to->g_pat =3D from->g_pat;
> +
>  }
>
>  void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> @@ -644,17 +636,14 @@ static void nested_vmcb02_prepare_save(struct vcpu_=
svm *svm, struct vmcb *vmcb12
>                 svm->nested.force_msr_bitmap_recalc =3D true;
>         }
>
> -       if (npt_enabled) {
> -               if (nested_npt_enabled(svm)) {
> -                       if (unlikely(new_vmcb12 ||
> -                                    vmcb_is_dirty(vmcb12, VMCB_NPT))) {
> -                               vmcb02->save.g_pat =3D svm->nested.gpat;
> -                               vmcb_mark_dirty(vmcb02, VMCB_NPT);
> -                       }
> -               } else {
> -                       vmcb02->save.g_pat =3D vcpu->arch.pat;
> +       if (nested_npt_enabled(svm)) {
> +               if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_NPT=
))) {
> +                       vmcb02->save.g_pat =3D svm->nested.save.g_pat;
>                         vmcb_mark_dirty(vmcb02, VMCB_NPT);
>                 }
> +       } else if (npt_enabled) {
> +               vmcb02->save.g_pat =3D vcpu->arch.pat;
> +               vmcb_mark_dirty(vmcb02, VMCB_NPT);
>         }
>
>         if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
> @@ -1028,11 +1017,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>
>         nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>         nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> -       svm->nested.gpat =3D vmcb12->save.g_pat;
>
> -       if (!nested_vmcb_check_save(vcpu) ||
> -           !nested_vmcb_check_controls(vcpu) ||
> -           (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))=
) {
> +       if (!nested_vmcb_check_save(vcpu, &svm->nested.ctl, &svm->nested.=
save) ||
> +           !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
>                 vmcb12->control.exit_code    =3D SVM_EXIT_ERR;
>                 vmcb12->control.exit_info_1  =3D 0;
>                 vmcb12->control.exit_info_2  =3D 0;
> @@ -1766,7 +1753,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vc=
pu,
>                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gpa;
>                 if (nested_npt_enabled(svm)) {
>                         kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_VALID_=
GPAT;
> -                       kvm_state.hdr.svm.gpat =3D svm->nested.gpat;
> +                       kvm_state.hdr.svm.gpat =3D svm->nested.save.g_pat=
;
>                 }
>                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
>                 kvm_state.flags |=3D KVM_STATE_NESTED_GUEST_MODE;
> @@ -1871,7 +1858,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vc=
pu,
>
>         ret =3D -EINVAL;
>         __nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
> -       if (!__nested_vmcb_check_controls(vcpu, &ctl_cached))
> +       if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
>                 goto out_free;
>
>         /*
> @@ -1887,15 +1874,21 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
>          * nested_svm_check_permissions).
>          */
>         __nested_copy_vmcb_save_to_cache(&save_cached, save);
> +
> +       /*
> +        * Stuff gPAT in L1's save state, as older KVM may not have saved=
 L1's
> +        * gPAT.  L1's PAT, i.e. hPAT for the vCPU, is *always* tracked i=
n
> +        * vcpu->arch.pat, i.e. hPAT is a reflection of vcpu->arch.pat, n=
ot the
> +        * other way around.
> +        */
> +       save_cached.g_pat =3D vcpu->arch.pat;
> +
>         if (!(save->cr0 & X86_CR0_PG) ||
>             !(save->cr0 & X86_CR0_PE) ||
>             (save->rflags & X86_EFLAGS_VM) ||
> -           !__nested_vmcb_check_save(vcpu, &save_cached))
> +           !nested_vmcb_check_save(vcpu, &ctl_cached, &save_cached))
>                 goto out_free;
>
> -       /*
> -        * Validate gPAT, if provided.
> -        */
>         if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
>             !kvm_pat_valid(kvm_state->hdr.svm.gpat))
>                 goto out_free;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a6a44deec82b..bf8562a5f655 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2862,7 +2862,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
>                 WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_r=
un);
>                 if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
>                     nested_npt_enabled(svm))
> -                       msr_info->data =3D svm->nested.gpat;
> +                       msr_info->data =3D svm->nested.save.g_pat;
>                 else
>                         msr_info->data =3D vcpu->arch.pat;
>                 break;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a559cd45c8a9..6f07d8e3f06e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -146,6 +146,7 @@ struct vmcb_save_area_cached {
>         u64 cr0;
>         u64 dr7;
>         u64 dr6;
> +       u64 g_pat;
>  };
>
>  struct vmcb_ctrl_area_cached {
> @@ -208,9 +209,6 @@ struct svm_nested_state {
>          */
>         struct vmcb_save_area_cached save;
>
> -       /* Cached guest PAT from vmcb12.save.g_pat */
> -       u64 gpat;
> -
>         bool initialized;
>
>         /*
> @@ -599,7 +597,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm=
 *svm)
>
>  static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
>  {
> -       svm->nested.gpat =3D data;
> +       svm->nested.save.g_pat =3D data;
>         svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, data);
>  }
>
>
> base-commit: 6461c50e232d6f81d5b9604236f7ee3df870e932
> --

