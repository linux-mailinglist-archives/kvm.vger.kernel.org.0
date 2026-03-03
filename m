Return-Path: <kvm+bounces-72612-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKD4CURYp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72612-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:53:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3271F7C70
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6A0293043759
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76F33976A4;
	Tue,  3 Mar 2026 21:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O52qNDDS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9EB3932C2
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772574780; cv=pass; b=q2icJltBpRpbEE6vzam08FoMDbxEUQmTaBReD1Prewb0FHMKD8WggY3ksopr6EbRZf8GV7QmwoBoJUE3gL8zvxFybZlRoVnDu7qe6jwWdT/IEuDjdl0FkVvqUW6oV8gCu2kU/pXWxIzd9ICtz23Abwz+10VyRQet0dX9RM/Eyx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772574780; c=relaxed/simple;
	bh=u3e9SQJpAsw5lImE1cVHKN7Bl3efjDV3UbD1bchqZSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t8hKQ85DOoDYLkEfl6WuVJ3kp3LWRTCpp8Tfd9PoyC1X6J7Caef2AiLd0Ngo6hoj3N4GquoHzcuk0LGeUfFbEHRVsoq+dYN75gwtjaUjnk8SftrmhkHCT5gsxhAMOVPO0BHW3rThLxhY+lAEEqxi3g+CucVrVroCeYXXzwGf04w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O52qNDDS; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-89a15b9a556so4742886d6.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:52:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772574778; cv=none;
        d=google.com; s=arc-20240605;
        b=L17xbE6vyVtXJpKF3C2NdSVJy5E2Bp4ZugumwZt6aVis5O0dTYJ9LJcqIvN1R0TKDW
         B9I1vXbYf5d4iKAX/b4ooDa+RuiGVV/G6ikYSF/w+DTIQKnQGT+qaSphBgwF40NuFq2Q
         b8MvUVU9Tt1PzFUxHFSHhFUwvIMdSKbCsTHFP0w7gMY6XepDmyakLtHMtS0yXXfQ+moc
         n8iRpM9GDmIseqN04Od6qKABZPdcQ/21PJRxzGUj+aRu7wdbg3Xk2K2ifquQ7pe2CHOP
         gCnl7SRpPFUfM0MPRZz07UjAEQc73eQPxpUgNBhT2d8u26vP9jQIvCYpb0aMmDR9/DKI
         rnfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mfkCLf6FTQYP1SekI1qev+QPnQ+89b0+lNxfWq8dUoU=;
        fh=7ntR+tLuuLr6c8ggBxw6L0JFFbPjqcsb8qY13iyMY8A=;
        b=beSXgZzq1vlVcgO7CcQET/2zSq5qrlDNUzyANPElXoPT0sNvLKHg1olKwC63bmeWSj
         JG6QCrD0sUmDgQlwnoZw1R8nhNkYqkBKZuPu+TO2uZJCwX0dmjEhfQLaXe3rmHIuZkm8
         xOcveMRM4DxxagSGi0Y/B4EJK4WZzjHJnMl9e2RIrDZwe73z3Uhu7DINYL0HJP3Rqn2u
         9tnnqeKO0FjjB10+Dcndr5nAEJGP1WgIxm/06qin3h0O9AkvW5JZw3RShHpPoRKG9LqY
         Z8lxflu03xiiNYtvr01HRFTc8svyMkmRwQE26Cwa1Xt1KXQfPQZ693DUl8meZv+ZFdMK
         haBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772574778; x=1773179578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfkCLf6FTQYP1SekI1qev+QPnQ+89b0+lNxfWq8dUoU=;
        b=O52qNDDSbReuQr/jOLfA3Nppb0di+NEIPCzrIcoZCywW9oTEWHb4EMjLiTd+vAiohS
         1mkEKimvq/IHLZsF7k9kJchzvNS2CrzYi4GE3AwSptf++tqCBj/X0XE0fkayPFCnGDoY
         GevIVKB86N9y3QDFQSuob09F//lPqHZh1PJyEh7cWE+0o08UZxMD5iZ1sPk/iV25lizL
         YPcNKqlbNxUEEPclSB/uog62W+CpaoCoP1baqBI+N8K9CJCqONLyLwQxbE2L0V6PJEsN
         DF8ZMNNFVk0xxpW5pLfmBKu6S1UBsOfQgG3eFaEXTx2jQ1RNfth/izi0Fcv0VIPM5SBU
         vwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772574778; x=1773179578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mfkCLf6FTQYP1SekI1qev+QPnQ+89b0+lNxfWq8dUoU=;
        b=dNlAA/F4ceuUp9TgQsDBvest3W+d2ljEYxjh6ZeFj08h8kINfOsRCjkdqsCxlgsNBB
         ou7BW6TEnizHmltcqdQvSa2eVcVgbus9M5yUqT78HZdttXPa3I4MC7L/pxBo1DR+1Cz+
         H+R0w6vcIVugvrixRAo27e8ETZr2xaYm/rIWfNp82iejw26EfT0Ydrc+hEyPg501s8Aq
         4YfbCeScIkoIDQZ3nICQzS1FunsWBhP1UqeHjkB3Ez+UeLHvjjQnQm5ovXp7ZQSRU3kw
         OFYzazt/dq41AAj4ljV2izOLTKk9iFzk+BG8e33WauWp5ey8LkewsI3mTp1LWUey+tbK
         5PBw==
X-Forwarded-Encrypted: i=1; AJvYcCUtBHbfUKxMTY6Ylni6Bj01DAHir+aqzL3LmrUf+kAqUbHJ1jM3x3hxJmkLDoEA3FY17nM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqCCvhb8gyNg0/E9d+a/nNGjlDizDX0oJ0yQ86UYNqBOaHdhz9
	MtVA6mrKqsXH3cpkabh87PYA0WBLSzPD+sedRdraaYslQ/7B3YQeMUFSrOCnD+EF60WQY1Szn3Y
	GQiJZA+GnQSjUCKmuNnEWO9Gi+R9b/EZuL/3etSQj
X-Gm-Gg: ATEYQzz/LDu/Wc2989T/DHxPp2p50qKFvLqP5LyEfIR1m46o8ykNaDsES5p41Y3HNf7
	SNu4oXuQYPDnT8YjZC0QFiz2wGfqNfSwArivSMzYkUbB+wH0Jyw8a5pqISwJkYLKX5+3A2xHj0r
	Xiorw09lkKrxGB9c7mBqPqfH6ItdmP1cClmFMEBNwUP/5wpYGZCVGHFbToCqixRruJ0dVnVi0nn
	rkZmBgLqm7ewZoau52kZYXF/771AglaYBrL4pbOuaEQBz7fgDb9b3+Q881t+5ospmasFrUYN9h/
	BcRdwTE6LG3d5n+9hW7VuNX0RGdjhdMDiUcVpBdSxQ==
X-Received: by 2002:a05:6214:1948:b0:89a:181e:4470 with SMTP id
 6a1803df08f44-89a181e459cmr4013966d6.9.1772574777872; Tue, 03 Mar 2026
 13:52:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
 <aaXXs4ubgmxf_E1O@google.com> <aaYanA9WBSZWjQ8Y@google.com>
In-Reply-To: <aaYanA9WBSZWjQ8Y@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Tue, 3 Mar 2026 16:52:46 -0500
X-Gm-Features: AaiRm52dab4c2dcfOeaTNxxo3ceGZpzK2gmZusHRSEGAvf6YGNEuM0fxBa4MYeg
Message-ID: <CAE6NW_YoEv=CWHr6e7esyLku3w-15d14DGZ18SM8E+k8-LY_fQ@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AF3271F7C70
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
	TAGGED_FROM(0.00)[bounces-72612-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 6:17=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > > On Fri, Feb 27, 2026 at 7:33=E2=80=AFPM Kevin Cheng <chengkev@google.=
com> wrote:
> > > >
> > > > The APM lists the following behaviors
> > > >   - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructi=
ons
> > > >     can be used when the EFER.SVME is set to 1; otherwise, these
> > > >     instructions generate a #UD exception.
> > > >   - If VMMCALL instruction is not intercepted, the instruction rais=
es a
> > > >     #UD exception.
> > > >
> > > > The patches in this series fix current SVM bugs that do not adhere =
to
> > > > the APM listed behaviors.
> > > >
> > > > v3 -> v4:
> > > >   - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=3D0 and SVM=
 Lock
> > > >     and DEV are not available" as per Sean
> > > >   - Added back STGI and CLGI intercept clearing in init_vmcb to mai=
ntain
> > > >     previous behavior on intel guests. Previously intel guests alwa=
ys
> > > >     had STGI and CLGI intercepts cleared if vgif was enabled. In V3=
,
> > > >     because the clearing of the intercepts was moved from init_vmcb=
() to
> > > >     the !guest_cpuid_is_intel_compatible() case in
> > > >     svm_recalc_instruction_intercepts(), the CLGI intercept would b=
e
> > > >     indefinitely set on intel guests. I added back the clearing to
> > > >     init_vmcb() to retain intel guest behavior before this patch.
> > >
> > > I am a bit confused by this. v4 kept initializing the intercepts as
> > > cleared for all guests, but we still set the CLGI/STGI intercepts for
> > > Intel-compatible guests in svm_recalc_instruction_intercepts() patch
> > > 3. So what difference did this make?
> > >
> > > Also taking a step back, I am not really sure what's the right thing
> > > to do for Intel-compatible guests here. It also seems like even if we
> > > set the intercept, svm_set_gif() will clear the STGI intercept, even
> > > on Intel-compatible guests.
> > >
> > > Maybe we should leave that can of worms alone, go back to removing
> > > initializing the CLGI/STGI intercepts in init_vmcb(), and in
> > > svm_recalc_instruction_intercepts() set/clear these intercepts based
> > > on EFER.SVME alone, irrespective of Intel-compatibility?
> >
> > Ya, guest_cpuid_is_intel_compatible() should only be applied to VMLOAD/=
VMSAVE.
> > KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to inject #UD.=
  I.e. KVM
> > is handling (the absoutely absurd) case that FMS reports an Intel CPU, =
but the
> > guest enables and uses SVM.
> >
> >       /*
> >        * Intercept VMLOAD if the vCPU model is Intel in order to emulat=
e that
> >        * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that ex=
posing
> >        * SVM on Intel is bonkers and extremely unlikely to work).
> >        */
> >       if (guest_cpuid_is_intel_compatible(vcpu))
> >               guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> >
> > Sorry for not catching this in previous versions.
>
> Because I got all kinds of confused trying to recall what was different b=
etween
> v3 and v4, I went ahead and spliced them together.
>
> Does the below look right?  If so, I'll formally post just patches 1 and =
3 as v5.
> I'll take 2 and 4 directly from here; I want to switch the ordering anywa=
ys so
> that the vgif movement immediately precedes the Recalc "instructions" pat=
ch.
>
>         /*
>          * Intercept instructions that #UD if EFER.SVME=3D0, as SVME must=
 be set
>          * even when running the guest, i.e. hardware will only ever see
>          * EFER.SVME=3D1.
>          *
>          * No need to toggle any of the vgif/vls/etc. enable bits here, a=
s they
>          * are set when the VMCB is initialized and never cleared (if the
>          * relevant intercepts are set, the enablements are meaningless a=
nyway).
>          */
>         if (!(vcpu->arch.efer & EFER_SVME)) {
>                 svm_set_intercept(svm, INTERCEPT_VMLOAD);
>                 svm_set_intercept(svm, INTERCEPT_VMSAVE);
>                 svm_set_intercept(svm, INTERCEPT_CLGI);
>                 svm_set_intercept(svm, INTERCEPT_STGI);
>         } else {
>                 /*
>                  * If hardware supports Virtual VMLOAD VMSAVE then enable=
 it
>                  * in VMCB and clear intercepts to avoid #VMEXIT.
>                  */
>                 if (guest_cpuid_is_intel_compatible(vcpu)) {
>                         svm_set_intercept(svm, INTERCEPT_VMLOAD);
>                         svm_set_intercept(svm, INTERCEPT_VMSAVE);
>                 } else if (vls) {
>                         svm_clr_intercept(svm, INTERCEPT_VMLOAD);
>                         svm_clr_intercept(svm, INTERCEPT_VMSAVE);
>                 }
>
>                 /*
>                  * Process pending events when clearing STGI/CLGI interce=
pts if
>                  * there's at least one pending event that is masked by G=
IF, so
>                  * that KVM re-evaluates if the intercept needs to be set=
 again
>                  * to track when GIF is re-enabled (e.g. for NMI injectio=
n).
>                  */
>                 if (vgif) {
>                         svm_clr_intercept(svm, INTERCEPT_CLGI);
>                         svm_clr_intercept(svm, INTERCEPT_STGI);
>
>                         if (svm_has_pending_gif_event(svm))
>                                 kvm_make_request(KVM_REQ_EVENT, &svm->vcp=
u);
>                 }
>         }
>
> where init_vmcb() is (like v3):
>
>         if (vnmi)
>                 svm->vmcb->control.int_ctl |=3D V_NMI_ENABLE_MASK;
>
>         if (vgif)
>                 svm->vmcb->control.int_ctl |=3D V_GIF_ENABLE_MASK;
>
>         if (vls)
>                 svm->vmcb->control.virt_ext |=3D VIRTUAL_VMLOAD_VMSAVE_EN=
ABLE_MASK;

Yup this looks correct to me.

