Return-Path: <kvm+bounces-69907-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEIsFMYKgWkCDwMAu9opvQ
	(envelope-from <kvm+bounces-69907-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:36:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D69D1245
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 21:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 49748300BC9E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 20:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46E5A21FF5F;
	Mon,  2 Feb 2026 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z1n/yRr9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA8027F75F
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 20:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770064553; cv=pass; b=PhumTfssAt3XyBzuGTJ0jdBahSSmrqBpIo5UF/ZKxU8OIRfZHCx7Ds4oy9QZKH4Dxmt2ZuhbHOZ/TyEqcECULK3rCoIajzab4vBO5wG7yzQT7Sdqjrm0j5rSN/4V3G+u7uNNqIMKFQFVESWZ6TdgF7yd/KQPk1DFGM+76feizjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770064553; c=relaxed/simple;
	bh=tyQib1ceuChbfkwzIJdjciwjxIFvP+Qw5nCmw62hwHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PE/4xB0KXBond6AcbtutlaHmdkaWSg2ZZufVKJEsTvwtARvxOaNstTA2HC4QTGqaP/NzIPV2ZJP8X0AJyCavjpZuXB/hhCUCga8y8OZKiQXEnPh2puKumD5IcqGmkiZcZrYfVWoAt10KqP7GmBMAG50FqtUjE7sqQ2gK8FkbAI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z1n/yRr9; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so324a12.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 12:35:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770064549; cv=none;
        d=google.com; s=arc-20240605;
        b=N2+Xr369w7evNkhETgB9GJccY6+ITZQRma5vQfp0g45wth5a6fcI/VwGL2zV1IgUu/
         Venaz/cFcN2rCdv6nqNFvyhl2+zRb40HO0OqEsXpsajUWeOzAxzXk9UUsJbvMgnpvn2A
         bCeCnO88jnnLTBZGNhIkK1Odf51g1Yv9Xa9NvARlJ2ISPupun6ZenmZwZFa4V9TuFcX9
         vd7GinvTA8VFSyKbjkZeEjg0+AuJ9SDUFmLzlJObGZN7L1OmQVz+FtboyGVcWm1WuRfS
         LwYeI/vNsndY7TOtdlo8QF2apEk2RFVli3ac7ADA90KhrEKcOKDs72m6TPvYT5JYuyJw
         fveQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TimSe4Elag2lScoYOa5FjhZsLF0DWUzAectjzq7ujCo=;
        fh=IKtg+pl2Kj9E3LftmlTteBjYfWf1TwYI3cXMr1+7w5c=;
        b=IWWVNLc1cW5s2emhpzId9+iZQo2sv/7eBHBUa0N0Ba6KYKtwx3FyQ51HZNCbgTB0c1
         KuK3ya54nxgxazqZSmHzjgzFWPlTs8tnTFkd0DNe6qnwU8B7+jb/Zyeey7YoU8I07w0n
         olNP6/XafEMuGmeLaUggSA13/iyB5jthbktxTsUw+rTI0ADmwcGpAoiPe129XZ5z/BbP
         iaedOjpAtOeAFeMqvYdqR24N9Y0RSqVDP17I9SPe2UwcdUr/jBll1BnMkEjiSBVMi79u
         oXTpYjw1RROb4fX5wQk92Ux8T0we9G90PsbEne5kNi5bGo6b6gGj/Jxsj/Sy0nf2nUao
         +5PA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770064549; x=1770669349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TimSe4Elag2lScoYOa5FjhZsLF0DWUzAectjzq7ujCo=;
        b=Z1n/yRr9f5uzvsccoW+TWbHLUfmDT3XeyUUG2yuyyR1StvGWeE9aJwQd/Gjoa3IEZV
         px2oy6exQlZ1lS+HwOz00bJMXLwD67RcLfpou6XSKtfKjqrm500C7OC+bhJ1CfaeAzqO
         EiEvBLEUlFlf6XOGphzlQMZoUUUQbjZEPyHAqdsFKpFXdi3Kel+EPxqnWU4jORpoRdoh
         kgcBQ2OjwGUey1Ra5hK4Bwwz4u7hirPJlBz/eV+puOF9YITZkGmCtJkJ0JcrYG34H1T6
         vtYhjAXbXPJTnRg8mbmL/p/4jKkAKP/nbF1u08MMrShhSyRqg6eEzcaNS1qJ3sjx982p
         mb2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770064549; x=1770669349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TimSe4Elag2lScoYOa5FjhZsLF0DWUzAectjzq7ujCo=;
        b=m40+S3pcmOpQYcB9bFrn4zzwXZOqP5e/EG+QhlEJqFeYR755g4dVfYfS7ZTKMe1PHi
         ow/pybQ3bbISE3SpIYzI6xFsXTa5NyTBo+DXZGL+Rf0HTC4/PXRXzz1VSjbmsVPInEre
         +wzR27H/e+PYK/4Aj2vHPuVUm0NGRjIo6+ANIf0PbjhQkq38dSpy5THYaHOCjvmmlCLs
         EeVEDuqM/ZaWADgn8UO5/yn92LBzhSmgt9C/+XxrrlDglV1ciiRMAjy3fb4fVPYrPVUc
         rH9/fQB4TL17OCtPmvlY8shzbNYb78VOjjmXEwsOpMaWhtD8pOAB0wmoo3NNAkkzCszS
         ieVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/8dz/FcbuRhDH/wtyFWBZK/YUF3LRk4I8fRzHA3yPE8DG+V4Mr4NsvyvrEczVxpjJfGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLQlg2L+mfnQcAV1xp4ydbiU3aKWHCamKSCwxvA4sC6GfTOg47
	7pdmH28rboWQMMwZUIJQYBkdr9jZ6pmmmr++kKUnRBSzo/0SXgAiWA48/SEBw0URehQq6Hbt2Y5
	3/FkKq/N+n1yxkhWrM7K4W1Y69CJyklPyjzwEXH3G
X-Gm-Gg: AZuq6aIwUQDBMulvgY2wGSAEc+8f0t29auSogLiJ91tjfSrphgKb8XBqEsscW+5xjRU
	a8a+yr/3OzQlnrvqzHLj6ZxBkdYSDVN+D+/Xs0A+E42qCsAOeQH1/fNHupNZUFHfgbueabhARqi
	wJYUW6Yg4zpXsnNSBqoMuTdQm0qKe500sE9V5zzF28pDP1Era+Cw4QQ+1KKmK7reygn/q/Sd5q1
	Kv2oSZ0mUn3V64m0+HlJ5+cWETTidD8vQG1pQWctV0VMBA+Z+gh93lzveNS+Nwb1sqsTMU=
X-Received: by 2002:aa7:d50b:0:b0:658:eee:f21a with SMTP id
 4fb4d7f45d1cf-659346035a9mr7853a12.10.1770064548804; Mon, 02 Feb 2026
 12:35:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com> <20260115232154.3021475-3-jmattson@google.com>
 <e3j5qgrdjad7ura7kodfzcagynvrkxv227ddg3jfjknzewvyay@h5pb67muiycd>
In-Reply-To: <e3j5qgrdjad7ura7kodfzcagynvrkxv227ddg3jfjknzewvyay@h5pb67muiycd>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 2 Feb 2026 12:35:37 -0800
X-Gm-Features: AZwV_QiDOXtc8m_XNuNL5oH2Ivi2xScAYY6eNR1dbMaYxG9uGGtsX74otJesncA
Message-ID: <CALMp9eSUg=iu69S7jqW_Pt9d88yUbmr-+xk2hW1zXPFzaCM0FA@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] KVM: x86: nSVM: Cache g_pat in vmcb_save_area_cached
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69907-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 73D69D1245
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 5:28=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Thu, Jan 15, 2026 at 03:21:41PM -0800, Jim Mattson wrote:
> > To avoid TOCTTOU issues, all fields in the vmcb12 save area that are
> > subject to validation must be copied to svm->nested.save prior to
> > validation, since vmcb12 is writable by the guest. Add g_pat to this se=
t in
> > preparation for validting it.
> >
> > Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
>
> g_pat is not currently used from VMCB12, so this patch isn't technically
> fixing an issue, right? I suspect this only applies to patch 3.

The fact that VMCB12.g_pat isn't used *is* the issue. This patch is
part of the fix. To make the fix easier to review, it's broken into
several pieces.

> Anyway, I think it's probably best to squash this into patch 3. Also
> maybe CC stable?

I will squash it in the next version.

> > Signed-off-by: Jim Mattson <jmattson@google.com>
>
> If you decide to keep this as an individual patch, feel free to add:
>
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
>
> > ---
> >  arch/x86/kvm/svm/nested.c | 2 ++
> >  arch/x86/kvm/svm/svm.h    | 1 +
> >  2 files changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index f295a41ec659..07a57a43fc3b 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -506,6 +506,8 @@ static void __nested_copy_vmcb_save_to_cache(struct=
 vmcb_save_area_cached *to,
> >
> >       to->dr6 =3D from->dr6;
> >       to->dr7 =3D from->dr7;
> > +
> > +     to->g_pat =3D from->g_pat;
> >  }
> >
> >  void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 7d28a739865f..39138378531e 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -145,6 +145,7 @@ struct vmcb_save_area_cached {
> >       u64 cr0;
> >       u64 dr7;
> >       u64 dr6;
> > +     u64 g_pat;
> >  };
> >
> >  struct vmcb_ctrl_area_cached {
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

