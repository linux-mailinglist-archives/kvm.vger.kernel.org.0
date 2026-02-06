Return-Path: <kvm+bounces-70473-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLeIChI2hmlrLAQAu9opvQ
	(envelope-from <kvm+bounces-70473-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:42:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 976AA10224F
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A62C1303C523
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3DA428830;
	Fri,  6 Feb 2026 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f+jU3zqC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C47A428489
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402744; cv=pass; b=XXK9MSCWiM6H0b5ub4nos1uT2uhkfs9gHixzR8vETzawrkJn21vqeLil2DBaDJWhdKSU464ISY1/35AtZs3OUlL1152C2aiwcsJKiGV4ezcxM093UbgcTPOF4sUxJ86sEggrRbB8tO3SHh2e2te7//cNVfWW0R1BAZd98Km02v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402744; c=relaxed/simple;
	bh=Vzw7v7bPDRTIVw0dZ1wnY8pgBBayoVrZVHG2W4iXQtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vc81R25w/sG2Be0qi7Xdbiihk/cSJAoBehJ6PqETXqLqmFsVaRNwdGJOKBMmVcyq3JMHS83Hi2RigyR0Ap2F4CcXXYVzw0DQajJQzBbZiV8K9ega9fJvixd9q95Xm4nLR8a0PEWnqDbPFanPmObauTqyh1n2bC9Khm8l/Sb1nbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f+jU3zqC; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so456a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 10:32:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770402743; cv=none;
        d=google.com; s=arc-20240605;
        b=YcSFk9zvPuSJkzbwM9MKilPUH1Ra1rCl2UEksvKTu+TD+UpcIHk76+yeYeZNBT0VLm
         lP3Bzk0U/MhD+CuO9AgXdtnAyNeegJbJS0uMr1GKmXp9xVzVakFB3v+/up0gn7m36vnu
         CNrEy9fBs0sFz2SvMScO/FCVzThZD1fget0UhzKkDqHzeL+8wnJrTpBxa05/PrjwSLOu
         bbY3pJSuQ8soeLcEOEYqyx+/Pih3UhQOiXAmQzDcNIhL7DmAiaRJxYFZYsiJbZmDSzHw
         zq1vsSI6jCrrK+EwR4bEmgkOh4RaKbt4G/4d2VRzPQSjT1anbCqvYW065UR0Mczpbl4q
         XTpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZGsqnAoPnb6U7VcQ9CuxGhV5U/BoNRyL76jStHctGGg=;
        fh=Q/XvspQObcGZfM1Z0ZMk4dpONTp3bSP2+r2Kp9pObYU=;
        b=Cj52RUQ8QidxVKJ9UnxK3kzdsuzkIH4i7YMi59SRYlkqw60eTnC9eIxxLzcskoj1oe
         CmOSQkwAhnH2X2BAF8qMPmu8pDkQd0p/wiDfINlPUwYSIf0fVcICD626iAqBzw4DmrQk
         VpNSjWHS1tHmfF/ntaWyREmoqNOE3EGh3WqN+PMPzvz3DT8GeA5qch2IiuEaE4z/sbRd
         bg5DI4huVl8CWbY68ikOsQIO2VTizbzM+MtVnaaHbwzvZhJcCAH236WlhUtKZkq9lH3h
         bU16K8E7B1ycsJ18ysimLHPKe/1MbVba9y9OXvfwebydvpB5/XqWmN//K0Mwh3XmdQY1
         COVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770402743; x=1771007543; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGsqnAoPnb6U7VcQ9CuxGhV5U/BoNRyL76jStHctGGg=;
        b=f+jU3zqCfM70VUhS3DTpo5Gp9caRkDCnkegTz3jd+CJbq9JJWAL5p6AMdi5F2NKHVY
         7iHwfEWzhdOWde1UPlQnohtC7Rb++6QbjpsnLN2+9fhvQQexxMagBmt8ZgoSCNY7aKDg
         pXWRbmM8cuMCK1vtCPgbglsMqB3oIeSbbOwzVn0pJ38HcWQL75MVEFDFSXvsgUC23hrT
         +aXmSTESh4cobnUL2EC9XU3S6oOKwnP+LX7L7P/8+2jnXwKdZfslDJoy974+OBlggwyN
         ZPqQa2boY6O8lP4jyCMP50LuiTSGG3z/JLEq4Hkz5au0+WKanzunuYbac7ng7s2xlTLE
         UZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770402743; x=1771007543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZGsqnAoPnb6U7VcQ9CuxGhV5U/BoNRyL76jStHctGGg=;
        b=Sugg3597bTO3U93peaoQql8I4nPUuzz4qJQ96qRN5+vEfNSIFDGRIdq6OaJTIEy75E
         FOn5/+vmIepQL2BlUF+0LibT5jqwaBNKkeB7pk+seZ1L8R511VdUar0LTpZ672PUGNrS
         lj0z2urRSCn9AnQbn99yb3RTp+QQ3XGAoybYwlfFulISwwp0gTWKy+0dWNFxVc9AoeRR
         IW/dsOzWm17C9DzguTGXhgbAVXTAjCx21mLifcqVZw42xLkWaV7OJk/juo0m3SbP93oh
         OHPCwseD7A5lIka0zOL2kWW8rXhRnBLQ00Cp0RAtEZji6jxe8UO7JcIdzsgBCdzR8j30
         TGQg==
X-Forwarded-Encrypted: i=1; AJvYcCXXRlTAKb15m2z9ghnQoMG5HVjHBsI1X1iyLSXwY7YBpeJf1e25fPba89yjGsErEhzbe4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxL/1aQX9Yint//5QSKaQUsn/uMv1V0lozS6wQ5yHePJgL1yf
	noPOQn3W88LVebRSH76Kxdgw5+1DMY+r5hd6g8T8exDVtjTYV7hy8Qi8Nx/g9T4F9dJXV/ITg/X
	keL08bxPK2lWRZ1DCZTi81PUdz4bCes8EWc4mEe8l
X-Gm-Gg: AZuq6aJo67I5UL935+9/5BLsG7o+gFsyCYSVaZnOn2RPAOdGTXJf6PDJ4SCK+xkKBQO
	NrJ/KMd/C6kFtVIjlJaB5veyovEH789v7TbzVK1/0pMHK/T9KgEtXETsFnR5ZeiYJUk+60xIB78
	67wxL9BfBMJdY08IfHpIGxA/KNk0phPiOiXOuUUHIPuN6ZNPF+MqdHOeoafzWbt+Pfbx1hmtadN
	7SWoE0P/DlH/SCIIU4Ekxy5JtdupffPAPnkFFJnHkeFotd/cXrEy/F+BxPTK0Dim+LpjFI=
X-Received: by 2002:a05:6402:20d5:20b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-659a7833c00mr509a12.7.1770402742687; Fri, 06 Feb 2026 10:32:22
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com> <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
In-Reply-To: <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Feb 2026 10:32:08 -0800
X-Gm-Features: AZwV_QgSwjEHCKKLsNVHr66h4_s2X5yMqUGSxhymGkYa-20CddEHZe7K1CxjwBw
Message-ID: <CALMp9eTJAD4Dc88egovSjV-N2YHd8G80ZP-dL5wXFDAC+WR6fA@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70473-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 976AA10224F
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 10:23=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> February 6, 2026 at 10:19 AM, "Sean Christopherson" <seanjc@google.com> w=
rote:
>
>
> >
> > On Thu, Feb 05, 2026, Jim Mattson wrote:
> >
> > >
> > > Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issues, =
and
> > >  add a validity check so that when nested paging is enabled for vmcb1=
2, an
> > >  invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_INVAL=
ID, as
> > >  specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT."
> > >
> > >  Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> > >  Signed-off-by: Jim Mattson <jmattson@google.com>
> > >  ---
> > >  arch/x86/kvm/svm/nested.c | 4 +++-
> > >  arch/x86/kvm/svm/svm.h | 3 +++
> > >  2 files changed, 6 insertions(+), 1 deletion(-)
> > >
> > >  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > >  index f72dbd10dcad..1d4ff6408b34 100644
> > >  --- a/arch/x86/kvm/svm/nested.c
> > >  +++ b/arch/x86/kvm/svm/nested.c
> > >  @@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> > >
> > >  nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > >  nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > >  + svm->nested.gpat =3D vmcb12->save.g_pat;
> > >
> > >  if (!nested_vmcb_check_save(vcpu) ||
> > >  - !nested_vmcb_check_controls(vcpu)) {
> > >  + !nested_vmcb_check_controls(vcpu) ||
> > >  + (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
> > >  vmcb12->control.exit_code =3D SVM_EXIT_ERR;
> > >  vmcb12->control.exit_info_1 =3D 0;
> > >  vmcb12->control.exit_info_2 =3D 0;
> > >  diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > >  index 986d90f2d4ca..42a4bf83b3aa 100644
> > >  --- a/arch/x86/kvm/svm/svm.h
> > >  +++ b/arch/x86/kvm/svm/svm.h
> > >  @@ -208,6 +208,9 @@ struct svm_nested_state {
> > >  */
> > >  struct vmcb_save_area_cached save;
> > >
> > >  + /* Cached guest PAT from vmcb12.save.g_pat */
> > >  + u64 gpat;
> > >
> > Shouldn't this go in vmcb_save_area_cached?
>
> I believe Jim changed it after this discussion on v2: https://lore.kernel=
.org/kvm/20260115232154.3021475-4-jmattson@google.com/.

Right. The two issues with putting it in vmcb_save_area_cached were:

1. Checking all of vmcb_save_area_cached requires access to the
corresponding control area (or at least the boolean, "NTP enabled.")
2. In the nested state serialization payload, everything else in the
vmcb_save_area_cached comes from L1 (host state to be restored at
emulated #VMEXIT.)

The first issue was a little messy, but not that distasteful. The
second issue was really a mess.

