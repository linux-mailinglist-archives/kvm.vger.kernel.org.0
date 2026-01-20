Return-Path: <kvm+bounces-68642-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aI0HHGvXb2mgMQAAu9opvQ
	(envelope-from <kvm+bounces-68642-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:28:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3DE4A610
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 739E5A8258F
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0E243E9F0;
	Tue, 20 Jan 2026 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BhSAZa65"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D08362137
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768933685; cv=pass; b=sS7TC7cD/PwyZ7deiaiG7wk81tsPIFwrx1To+YVDkTCBV2ors56z6OlwruAHUq6yFjTqb1p0tZQf3iE+SuGlo7Q0pPhMQcD2EzeaPnhlXgv0FlS5PWrfDFGhMHxQSgppoKLWW+kUcVU3HHLNEmp0biXstqu1SGPZMauvnebN17A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768933685; c=relaxed/simple;
	bh=GpWozS8C5OmZHND904bKt+eeja6zjkY3nn1lPgCFeaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Wob7D3xYt+GOs2jPRQ/ntm0dPbfpTYLNi1KAupXIC1r0Sm0vMJf8BGtO9yw/z50l19M5CnXCBOsfBeFRB6takd0We6smQNMtXDhmbc9/2kEURtMKu2g8YN+ucwILrI7bX2O3VMi5ZHqe4PRahypL9z4ADfj41IKC8A7wvW9qKvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BhSAZa65; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50299648ae9so29841cf.1
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 10:28:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768933682; cv=none;
        d=google.com; s=arc-20240605;
        b=NxZ6o51v5dlAKuGGjV63XehZoIdlnx9v8NZG/BBYwo+V1eV5/4ZneF8AXYBEMhSRXY
         jnhisreU0XXRK7++NDvJfMMW1T+UYAHZdFKqsBpC2mVeUwccwlXlhqzxS+BInilQXU8j
         fTbQ/IDNnndgUks67PpivrvGqmfWUdJlnyRKBYIbH7wVTknBH12tnU4JLOIU5pyy17Ky
         PiREKndP0Q7Wrjv8kLAhjkfzwKhKUaqzNfWFd/Yn2xMAE5JNdgR9XNpUo0AD57lXVMDx
         +85d9A9dYZmm4AvXCag9TCToWpODKM6TnlrH/hOH/7UXjRgRS37DG1ekKHBPTZBe0QJs
         CkNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NadXD/s8UeMORw4SuUxhkpPm3r9c2x+SuKgvM5eqLy4=;
        fh=FBeeB1uBoD/yCHH3wF6hxvcFCPz/RKGwamxGkPH52Do=;
        b=MmLa/Je/TzoJyBuFXeB3GPzDZ2rA9K35xvR0sYsWmjAdbB8I4CttpSC7IudqVT5+65
         CQdtn2YDy6okB6SE6Rd/n3LrLq6rj4bE8YQs0uJJ6EnrjJ7kJSf0U/HRoDHtnZFWTVfZ
         ZGxzy/5FA8dkbBX4eEBGm79swKvHCRVKcfxgS20tyLpfRyBPAhlhI3kne+078cGM3unx
         ezsR5QD3hg7l2E8li7wFPg7qRYfQmdFhkn9IWzjkdwRhRP1qrAXBbI8EiX2KwR2t+WcR
         HNnMYdmFXKCc/zPhyq4CtI2WT9bkIUN/2I480H/sXHVSCrA7MSv9BYsUl/cvAEaNjKpY
         0pYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768933682; x=1769538482; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NadXD/s8UeMORw4SuUxhkpPm3r9c2x+SuKgvM5eqLy4=;
        b=BhSAZa65bozLCVOzJ8exOC2P6gq2pfPJySKMbY7uIXSRSFJceuAz/FqTno2JJ3Z42t
         UoJB+klz09ha36sgyOu0ZVaQ9a21TeXToA5BrLmVymc2rNxpBNdNrOvQAPzeso2tKsUs
         Jxpt4Tj8PtX0H2tzbMeD5g4WE2lPCyKsJLS1S9QsknpauNjms88XZ003e15dahsmc+fe
         ZHNYK7M+se29h1+U/RHWGTJLSn8njDJ9IEuK/y8mRnxvDbDF+IZDn8pQbP344xP9/QlS
         Oypiw2EhWECjXJGHaq639bayAOEg/L5p25hoak5a4BVF1LG1wtfzcsOtlzyZmUu0xjnH
         4rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768933682; x=1769538482;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NadXD/s8UeMORw4SuUxhkpPm3r9c2x+SuKgvM5eqLy4=;
        b=qfpzdFfNCNNDAA1yHWmRUak+Cj5jCuZiKffnerXYGqYw9q2FsAYX5KaCkS3wjTcDIZ
         Rqk+SG6uqvd/KCc7TpY0eodmIZ53rmK9Wn7UDFbidKjpTd7MhR/d3Qs9to04HxRQf8Eo
         8//mGzhyEhKrVV5QpXgh1g8PTa0N+LoQgDZsvUYxuu3l/SG2anqbAxsbowK9GofWjkn5
         ELWwwzleo4ZNnYwxIc8u4tnlfWsqWhy6pw29ZedKS1s35c4YMUXPRkaixQtm/DdU3Vb3
         la1i6/7rw6sG26s+hmvvvN1zKfjSHb46R3d2q4ZP8n2w6Kux3/ImSYBpDE1+qdz5Fvev
         ulLA==
X-Forwarded-Encrypted: i=1; AJvYcCXViCHLHyS+MNMwKUlQc4sqAZiFGooGe8n4JtPyEllIwxWl/qavCYLq5oEBTVA/uSUDrKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZMnfRYvOfO+w5YjgvNFuzGUUabWpK5JHYCguK1pliNeBYi/cV
	aJpLMpwoPN8rT38vmUBDfaF4GpOHUwSGxk9Zmvip4vuIQ7+HmPOtkiiYpEawNYJj7XoKn97YP7I
	YVDato+YRFirVxpJKDXSs9D3X4VlkxWFJTat4jan3
X-Gm-Gg: AY/fxX4l7iNPl01pcnto538YhOOgBewS2sw4DhDCGjrQ17o/l4ezTsDzjP9oSDygA/b
	EYwMS5gNKtIoYN2sRDG00HwnvdLXvSTXKlYJxHOqmFz9ppD/Eo0Xhak1Tb9shMfl06j19wwsGlP
	JO/x6WTt+Y9wyK+dZOeVXz3N3yc5R8sRRGFDROVxSOtxWOhvWglwyftaFz3spULWh562bJjkG8W
	KbWBBTyaTuksEER+kQSN/sISZxB4AoFujdudbftB6jZHLBORejQKoGhD6yIh9GwKfDFY/o=
X-Received: by 2002:ac8:5f49:0:b0:501:197d:32af with SMTP id
 d75a77b69052e-502e0b52d5dmr838271cf.0.1768933681727; Tue, 20 Jan 2026
 10:28:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com> <20260115232154.3021475-8-jmattson@google.com>
In-Reply-To: <20260115232154.3021475-8-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 20 Jan 2026 10:27:48 -0800
X-Gm-Features: AZwV_QgKGfspk1FCHacV14-un7DfE6wK0TPws2_Q8lW9z3inb3DMywGJ98zVozM
Message-ID: <CALMp9eTUx74tENnQEawfR5jdfkjcoAXb6xfHfJ7geyHP9Qyk0w@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] KVM: x86: nSVM: Handle restore of legacy nested state
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68642-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: DC3DE4A610
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Jan 15, 2026 at 3:22=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> When nested NPT is enabled and KVM_SET_NESTED_STATE is used to restore an
> old checkpoint (without a valid gPAT), the current IA32_PAT value must be
> copied to vmcb02->save.g_pat.
>
> Unfortunately, the current IA32_PAT value may be restored by KVM_SET_MSRS
> after KVM_SET_NESTED_STATE.
>
> Introduce a new boolean, svm->nested.restore_gpat_from_pat. If set,
> svm_vcpu_pre_run() will copy vcpu->arch.pat to vmcb02->save.g_pat and cle=
ar
> the boolean.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 9 ++++++---
>  arch/x86/kvm/svm/svm.c    | 8 ++++++++
>  arch/x86/kvm/svm/svm.h    | 6 ++++++
>  3 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c50fb7172672..61a3e7226cde 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1958,9 +1958,12 @@ static int svm_set_nested_state(struct kvm_vcpu *v=
cpu,
>         if (ret)
>                 goto out_free;
>
> -       if (is_guest_mode(vcpu) && nested_npt_enabled(svm) &&
> -           (kvm_state.hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
> -               svm->vmcb->save.g_pat =3D save_cached.g_pat;
> +       if (is_guest_mode(vcpu) && nested_npt_enabled(svm)) {
> +               svm->nested.restore_gpat_from_pat =3D
> +                       !(kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_=
GPAT);
> +               if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT)
> +                       svm->vmcb->save.g_pat =3D save_cached.g_pat;
> +       }
>
>         svm->nested.force_msr_bitmap_recalc =3D true;
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3f8581adf0c1..5dceab9f4c3f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4217,9 +4217,17 @@ static void svm_cancel_injection(struct kvm_vcpu *=
vcpu)
>
>  static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
>  {
> +       struct vcpu_svm *svm =3D to_svm(vcpu);
> +
>         if (to_kvm_sev_info(vcpu->kvm)->need_init)
>                 return -EINVAL;
>
> +       if (svm->nested.restore_gpat_from_pat) {
> +               svm->vmcb->save.g_pat =3D vcpu->arch.pat;
> +               vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> +               svm->nested.restore_gpat_from_pat =3D false;
> +       }
> +

Something like this is probably needed in svm_get_nested_state() as
well, but without clearing the boolean.

>         return 1;
>  }
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39138378531e..1964ab6e45f4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -219,6 +219,12 @@ struct svm_nested_state {
>          * on its side.
>          */
>         bool force_msr_bitmap_recalc;
> +
> +       /*
> +        * Indicates that vcpu->arch.pat should be copied to
> +        * vmcb02->save.g_pat at the next vcpu_run.
> +        */
> +       bool restore_gpat_from_pat;
>  };
>
>  struct vcpu_sev_es_state {
> --
> 2.52.0.457.g6b5491de43-goog
>

