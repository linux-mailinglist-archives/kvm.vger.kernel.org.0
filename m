Return-Path: <kvm+bounces-72433-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DBXKc8ZpmmeKQAAu9opvQ
	(envelope-from <kvm+bounces-72433-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:14:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A80681E66CF
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 509293036CBC
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23B1282F03;
	Mon,  2 Mar 2026 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zo0fGQsV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DBE282F25
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492156; cv=pass; b=ihKuTD97TVrColv1sQvAhJ56QDdZmDLqcLxbPmlr5wqdPLZr1wTqmiOwHm1KJbG14x9MuESonoRookDJHZvs6f84Ec5x8lNMi1JwWNjgOnoI5iuMftEd6Xf+RIm/Pvxmpb/nU4+wofLlNoARRJxsFqQKwhaCHIdgDKQMXBqs4kI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492156; c=relaxed/simple;
	bh=8nNqdud5udPHYp3CoSJwdc2P5YuqUHChv7OZtdNxaDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SsauFtKhJaIuZQXBAZ8NWR6yZ3JILrLFIzRlng6fRu4MlcFlbKH9BYaf/A6FbsgGwDYWWANcVy5Gva+SHbY03RlaV6en4DeBWoXJki2JOP0RxiLHzw9ht6YhqSR0/bwpaRZQQIlTkEOLGReGJmXW//nU595rnMtFOE7ifbRf3xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zo0fGQsV; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so1894a12.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 14:55:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772492153; cv=none;
        d=google.com; s=arc-20240605;
        b=NF1itvaES8HYjnKTCl2rwcfNpRbbUGiLWPPfrNVQvWysWB2dRLNYV04k2RaeVJoGz5
         720iL+Qv/EW666ki39Nk15bO/TV1qcCmTjtwnZVJsg/fAQd7BQz6Zi6kYlQoiMVopOCJ
         8DnAEnmBL8bKfVhPww1ryvjpbSiBeV+Ns2g7WT2uI0Rs+t1lDTkUsXv8P/2enc7exCyA
         wwVLzxpwTT8YmmEGIQS+lJRkuaw9R4dKOoKGe4bFtll2xoEHx6cp0CY0gJ6z3ySlLR10
         9mQMLexl3CkVoEFXZCOxmBAU0q7Cs3zLzvVnkTd24CCHtQ4US+AVLRNrKeuIUI8e2aBx
         1K/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ukqx2BScAEyB0MH0CEKa+JYA6GhlE0+o5CWWTQzpuQc=;
        fh=Cv2/cDKvwlBMHU3Oi+gcqeWCromnWGGr5wCYNR2lsCw=;
        b=fvKvPLixOc4Kj1uwjZgjkHRHsBgsujEh1+BJNPppOcH5lxiyPqKTGi8QYXIiTThIPt
         ITVqChhR+eu3ldndpWrmq3cjSZ0ibLXpa8TVZb+k8jvlg+nIdYw9qZo63BsSBxQQTyNC
         ZOLcPdRkiaPnPDNSGjsefntk6oK5sUPhBGJtOEN1FJ6vZXVFhY2v75K8sEOAvDl+1W1Y
         6c2s8vXskoVn03j6ZWe9OCMDAgKIjkTNDTfg+qLjMHX0g9vaFHlnpqS09nJTNPRM87J+
         7nLOSaJe88gDWlscZCa8vaNrcq4JOD7ZVVt+4hsFpfnUtqT44j5wD8sOeGRLU6wLjTAS
         916g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772492153; x=1773096953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ukqx2BScAEyB0MH0CEKa+JYA6GhlE0+o5CWWTQzpuQc=;
        b=Zo0fGQsV9CPEzD33z9DHTQVhkzrVJT2OUvW5TkbCA0OnVvtUB4dLNh0pf4DXzS0Hra
         khq1fUwHckhDO0gpZXHmzPmRxVpt9/Fp4DWbRcm0ZlK0D1kpyKIfBOQ2vDNsSsGpHBSA
         jTRfJdUZnsDKu12dXOe0MINxS7XUdG/x3MOGhBy9k8zhWYToBiIcByZGrM4N46De1u1D
         X+T3X+ZOQa5lddT7bhXAM9x7sU3N7h0PHsraSwivoA2TaO0YVeXq/djl+t/AdtiqMXJO
         Y9oeHcUKPiX4+pB2iJ6sZCPdGkAlzE1poCstCoxBuzX4FtRGliSxEGtShy7N03n1jsrh
         oSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772492153; x=1773096953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ukqx2BScAEyB0MH0CEKa+JYA6GhlE0+o5CWWTQzpuQc=;
        b=kW+NOGj7ULPPK/LgnriV/oDVLt+mZNLdkpNVRO99P3fAcQB7/Vv5eanm8D9fmLqOid
         nqSVEW7fdH6uZja9jksE2BF/EqM0m+6adnXhQUddm7XLgwXjvgAdpAMjqYxyR61mm8oH
         mnswO01CsJalROU8LScRYdPG8uy+6v/iwwj0IO75R0BhrQG9EadHXZNcdBlQEw5KBzBv
         XmGjS9XoGwfpcZnTalql02aHswcOWRUm6nSQ5B8Rop6IHwQ8aFMzift96Ev8GmC/qmvN
         Wu4dIgafIaLddfEmx1FcqgdkgykcNtCeDliidHwpklEEqWoa6HYtFtms0cX3FqHN24jN
         5C7A==
X-Forwarded-Encrypted: i=1; AJvYcCXOSaF9zMpjSLVck6f1UCs/w3lw6Iv+fwITcEGPTJusEfK3h6/N/aeo2u4EICDFufaoltE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEoyEFTiv/KrZGdcRF1l5nZCdoRXnTPRjM4FJ4hJDU8+jziy0n
	pxkpN7npjBvQcS4V0vAD6ZoyapC5lTWwINyTso+1DRWIRlKBNHJRVh2/FBuldoSOwh1rjZ/8Ubc
	Ba3yXnBc7cG8drrLNxOSzjnjExFANgG2lXi7JtUWp
X-Gm-Gg: ATEYQzwJZMev3ZbGQ2yjgyhzJDEtWVr/aT/VtzgAo3YVvVQqfgxlS08rfEhBoZsJdaM
	ehZoE/4CWL/nz42kQ0oS5i1s6iiihlQZCXggINp3O1WjzojRu6FwIjCVLm7kl6uIXsSJ6Ajy7u/
	eSYMctDI6MD8mbblFv4IC25AF+CsgsRpXRgB6/XNNvXRqrEoX6cq0qBmh7SCaFtMaX6apx1osCd
	QR8zVJkokrm0nEeUsCXcwF9krXWPtiGO45eEIl8BiX/c3Ut/MQo+oLkOpKJg8gxiQ+voXBdAznT
	DUz1caE=
X-Received: by 2002:a05:6402:309a:b0:65a:2e1f:e7cd with SMTP id
 4fb4d7f45d1cf-66010ee40dcmr255185a12.13.1772492152762; Mon, 02 Mar 2026
 14:55:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210234613.1383279-1-jmattson@google.com> <aaYTOXlgX-cnkvoy@google.com>
In-Reply-To: <aaYTOXlgX-cnkvoy@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 2 Mar 2026 14:55:39 -0800
X-Gm-Features: AaiRm52SIc-M2IQqcX7NEkNWAPVQ3pai6dlN8oU_iZFkvWk21MsbTiDrGt7hIhw
Message-ID: <CALMp9eSDN49LvwXk=5Ve7G4OO=M2vV4op_Fdo0TsKRm2T-DwgA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Ignore cpuid faulting in SMM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jamie Liu <jamieliu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A80681E66CF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72433-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 2:46=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:


> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -3583,10 +3583,10 @@ static int em_cpuid(struct x86_emulate_ctxt *ct=
xt)
> >       u64 msr =3D 0;
> >
> >       ctxt->ops->get_msr(ctxt, MSR_MISC_FEATURES_ENABLES, &msr);
> > -     if (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT &&
> > -         ctxt->ops->cpl(ctxt)) {
> > +     if (!ctxt->ops->is_smm(ctxt) &&
> > +         (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT &&
> > +          ctxt->ops->cpl(ctxt)))
>
> I assume you intended the parentheses to wrap the bitwise-AND.  I'll fixu=
p to
> this when applying.
>
>         if (!ctxt->ops->is_smm(ctxt) &&
>             (msr & MSR_MISC_FEATURES_ENABLES_CPUID_FAULT) &&
>             ctxt->ops->cpl(ctxt))

Yes, thanks. /facepalm

