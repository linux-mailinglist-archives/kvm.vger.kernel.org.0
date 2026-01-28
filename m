Return-Path: <kvm+bounces-69427-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCkvJqqYemms8QEAu9opvQ
	(envelope-from <kvm+bounces-69427-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:15:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15656A9DFB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2FD1D301AB8A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9421230100E;
	Wed, 28 Jan 2026 23:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d2CrUX6V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5A1FDE31
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642146; cv=pass; b=uW3Qf5jvS791MmlIGlRIS3roPlhoNWWKt6oCyBXMTya4xet+cfZmiZfz0cRyjp8Ok4S2dmJGOF0/AOu53/n4LUY5UqDjyhJx1f/R23GKE6VYKkgdDbIYiVTs4R7K0xb6b9nBMs48E9QCrVp0uPSo1cxW51ROK3+MSFUIUVLxU0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642146; c=relaxed/simple;
	bh=ZYI0xJ5IKeGQqnBiny+IcAJ7n7oQE+Gamflukyi8HLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgXHzIwQsGKt5o2MLBaMEbToMrAmZ2N1DHfCqMglWHnnDfkKtQVAKdFrP2x3g0dC97WBTBTfyLYXL/HdV4XXnxPhX7zh/OarAhKcfFg1lX4+fJUM27CPw1zLBJavLSkz5p9mc/rPF+a+K+sfpCsAB49inlm2SZt7dIHmHLwhfz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d2CrUX6V; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5033b0b6eabso84211cf.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:15:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769642144; cv=none;
        d=google.com; s=arc-20240605;
        b=POC1gL9fEd+v3PA48x9XlCNhLboEWAaPhiFQny+a4aQ/pWIIDhTe+k9CaopuVa449t
         I/gVO0PZJEfJrwbzd6/4YkJrAxwwzTfXhllE3AmyVuWnaTCaschaTat+t2tHZftikEzD
         4qIGUWLTUEp3s/kl8LM00fYVBzMkukpbwSqrmqhaO0iLnlEjbaRKTXHTWktdIdTRBP7G
         iAgC4vNQnGeWs0txj+TeJa3ZSUZOTalvjHactqm+YKb4pCcRkGd2c5wodDhdP2ex0Jlr
         CNuMFRCuvIoIuFvnSote1Q6Qsopsza60oms5dpNRr3vPZnMaHrXKG1NmCD2zDmUXEZa7
         urvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AAzak+OWzMGyfskA4IhCjosRR4lqrco5IqHqWSta8lA=;
        fh=sL+zcdSRt1JUpsuwLRXL5Itcj2vlUc0TJc6ma95KvVk=;
        b=O3ogLta+FVNMK/QkTTOc+j+4qO7Ct1qNSEMl1oYRhxxi5NuY5pcr+JPS6jiNAoQaEV
         heDP+65Ye7tUWaORQrzxiOdPxUEg3ucilBr8lqClb075zT6sxDCrRVeJ733Jf9yTkBEO
         r5jrVmBIiknmEdVF5p8CAtMvVz8aYIJeJls0QGVWfo1Xs4saMB7wKlal0g5KwAf58lFj
         pf7PFOA9Awcc7wgwLcI74FinhrrFonHdQ7IzvKYuCDOeFec3ZB6jNiiQpxgCZe6K434x
         yF+uhhPdG7Dii+4ArzVQ1nsBBsP9kOzGhqT1DKyo5XhlNpzQIfo30bo2F/Zs9QMr4eOW
         NEFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769642144; x=1770246944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAzak+OWzMGyfskA4IhCjosRR4lqrco5IqHqWSta8lA=;
        b=d2CrUX6VDUz74fFgfm7E7ur5U1mmlQbmzF6g/jnEgVRB7eDHmWQUritDnzc1CTHFS4
         hTXyEHfdhQTiO1gz+RLsOJNUhadvF7JFSg17NILINxcCJUi+kzQIetRMTzv2KYGsHvUt
         l0h2BFyv6UoXBIim5RYNWCkolMya1cosa7efDN22d08W8K8mw6skqKtZJT29jlBGjCoZ
         L2HqqYWxzVo6ncYPvnqCOlkte8c5KPP5ji8s/8r481V8N7B3D0EGD4L212KEMh1WgZFM
         tQc15Hf2A3CxFx1tHCBnS1HtDNH2N1CP5paguTaonfNOyA+FiOJTy7PouIP/dhFmwZ71
         SRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769642144; x=1770246944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AAzak+OWzMGyfskA4IhCjosRR4lqrco5IqHqWSta8lA=;
        b=bYFUtsW8TRrVrvtTUlJ+XrlR7e328pD41mcSte3FUg+zB7SfO9YuH8ozLhCRg+YlM+
         FKY3CXEXHhYA5hHrLK+ls5ZcQc5MyOYaDEot+XKnS4HUYs4Sr8PznWjy3v8w4QftmkPl
         qjPaylYMPGA7EUFYZxjM/Yo1E50RyYu1FHVbeNcLxLQkUeJ2jkKH+krGmlDQs6AKWpRW
         ij9S+rrTjZ4IlfetwXR59KmIaCB2TcDW2R7plgmxV4bAcATOU7VO4bByao44iprruJa8
         ifKJZ0xM0IC82D+BL/S/sqxMOQ3E9R7gROA/ttU9cfxIt+yuGKlWBFdAtCeysLasC+5m
         K7pg==
X-Gm-Message-State: AOJu0YyNhGI6cktdq0xytxHxeJY8xJrqL0rj4xom+Corq6LR8Ix4mzTK
	K2GUulPpQDm/ogt6G/Uftpr2RcKmIVRjGYQfqCJs1mDUmi9RkrnUwmHx1whSHvJtxnMO9uxWerd
	zPdc/Py4g7OLyu9rhc1LEi2Nx8eNHDueAwDD2h8qu
X-Gm-Gg: AZuq6aKOxG192Eh4I0xPydEsebNXoqN1/0b7x/aqMbGOHo4H4yn3WQWVwf4WNOR4m3o
	WrRbc5ylMgmvg2hXBWfH6QzH3e7FgwGNjQAE1sVBdGyQybk8wbZO+cBNvfX0jcRuemzdD38MFx6
	v1zK3zPSK35JkGG1+zsPjfYXI2UmrKY7Ow6hyG8daX9U+o1BUpZ+x0FXTrHwe1sQYrElfiDtneq
	Z0vK6qgHJLarcNOvrTfuBq0QeAbNjsn/0GsgiwzZYT8Ia8TSVKnxiyAnKd/wbeZ7OMjROQ=
X-Received: by 2002:ac8:7fcd:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-503b6705a55mr4017341cf.12.1769642144177; Wed, 28 Jan 2026
 15:15:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
In-Reply-To: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 28 Jan 2026 15:15:31 -0800
X-Gm-Features: AZwV_Qg45zvx_0C6hGZv4x9gE8dUcgPgRJTTTA2P7qM1iPJg1Y5NbvjdSsmwN-Q
Message-ID: <CALMp9eRPNGwTKTv9VQ6O5U=KsNz73iF14+=QZvqHx4JbQKCLfQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69427-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 15656A9DFB
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 5:26=E2=80=AFAM Alejandro Vallejo
<alejandro.garciavallejo@amd.com> wrote:
>
> Enable exposing DecodeAssists to guests. Performs a copyout of
> the insn_len and insn_bytes fields of the VMCB when the vCPU has
> the feature enabled.
>
> Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
> ---
> I wrote a little smoke test for kvm-unit-tests too. I'll send it shortly =
in
> reply to this email.
> ---
>  arch/x86/kvm/cpuid.c      | 1 +
>  arch/x86/kvm/svm/nested.c | 6 ++++++
>  arch/x86/kvm/svm/svm.c    | 3 +++
>  3 files changed, 10 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 88a5426674a10..da9a63c8289e5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1181,6 +1181,7 @@ void kvm_set_cpu_caps(void)
>                 VENDOR_F(FLUSHBYASID),
>                 VENDOR_F(NRIPS),
>                 VENDOR_F(TSCRATEMSR),
> +               VENDOR_F(DECODEASSISTS),
>                 VENDOR_F(V_VMSAVE_VMLOAD),
>                 VENDOR_F(LBRV),
>                 VENDOR_F(PAUSEFILTER),
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ba0f11c68372b..dc8a8e67a22c2 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1128,6 +1128,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>                 vmcb12->save.ssp        =3D vmcb02->save.ssp;
>         }
>
> +       if (guest_cpu_cap_has(vcpu, X86_FEATURE_DECODEASSISTS)) {
> +               memcpy(vmcb12->control.insn_bytes, vmcb02->control.insn_b=
ytes,
> +                      ARRAY_SIZE(vmcb12->control.insn_bytes));
> +               vmcb12->control.insn_len =3D vmcb02->control.insn_len;
> +       }

This only works if the #VMEXIT is being forwarded from vmcb02. This
does not work if the #VMEXIT is synthesized by L0 (e.g. via
nested_svm_inject_npf_exit() or nested_svm_inject_exception_vmexit()
for #PF).

>         vmcb12->control.int_state         =3D vmcb02->control.int_state;
>         vmcb12->control.exit_code         =3D vmcb02->control.exit_code;
>         vmcb12->control.exit_code_hi      =3D vmcb02->control.exit_code_h=
i;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 24d59ccfa40d9..8cf6d7904030e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void)
>                 if (nrips)
>                         kvm_cpu_cap_set(X86_FEATURE_NRIPS);
>
> +               if (boot_cpu_has(X86_FEATURE_DECODEASSISTS))
> +                       kvm_cpu_cap_set(X86_FEATURE_DECODEASSISTS);
> +
>                 if (npt_enabled)
>                         kvm_cpu_cap_set(X86_FEATURE_NPT);
>
>
> base-commit: 0499add8efd72456514c6218c062911ccc922a99

DECODEASSISTS consists of more than instruction bytes and instruction
length. There is also EXITINFO1 for MOV CRx, MOV DRx, INTn, and
INVLPG. Since L2 typically gets dibs on a #VMEXIT (in
nested_svm_intercept()), these typically fall into the "forwarded
#VMEXIT" category. However, these instructions can also be emulated,
in which case the vmcb12 intercepts are checked and a #VMEXIT may be
synthesized. In that case, svm_check_intercept() needs to populate
EXITINFO1 appropriately.

