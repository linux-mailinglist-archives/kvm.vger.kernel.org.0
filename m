Return-Path: <kvm+bounces-68852-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIbTEE2wcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68852-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:06:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B64D961E5C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 901AB7A27FA
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812B9466B64;
	Thu, 22 Jan 2026 05:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KRB9YOT3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F3430F922
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 05:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769058167; cv=pass; b=QCxNGsRTu1CS4VUic6KLvzn7AwozmAiDlQK0apIFHuSnXgjfemqjdgHoyCy5remymZXIJ4aTUO8EUJl8ouUm66SY0i+zNB7M+/QGzU/EGXQ4FsvrnO5RjLsC7bhKYPiHPGkX7sq/a7PrlCB/cio5gLuIrF9xDAPbw9OGqd6g2GY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769058167; c=relaxed/simple;
	bh=xhTJ5YJxd3F2EkOs3zUBW6XUiXj9iwWWphUi1TzMtmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jHI7DnezugkucpdNIXGOaQ1QOE8ogoYZOSkfMyT94wD0gLKlHDyysLEx4eCebh2BEVq2ayInssybuT+vRKsH+b9IIe/dALkGokkq376cx0mBPD8DUsxWPsjDKVKPOKB8WdslrovFPSq6QbHCjWHvYkHDNESmnqfmfCy6D1arNhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KRB9YOT3; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48039fdc8aeso2723245e9.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 21:02:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769058164; cv=none;
        d=google.com; s=arc-20240605;
        b=GCzQ62aVnIt6hTFAzD5vZxsqHLnktlhxlf7/VOnHB1ajnHw95JXObOICHPnx/qEj6z
         pYqb/Wqm5YrGBbd9xt7RnpfHjUoEbN/EKO4XCeJ71kQBi2Wr4E5IbPRDI9IaqENYGOjP
         /AexhNNNe1hfZvW4FJUNvZlZ546+F8twWixXsUKQ5+PWlGitwW2E8chw5z5FpM2wKTlL
         OULYSKWDLfcPsItjt2kuLtgFoSyJyunx+/Nu1xOldLbwIiVRLmBqpmx0Rin831eyK5lZ
         RMarUC165NeCEtMG+p4RznhSKuu7H9siEEN3PL4/ddvUhJfnH02YT4RVq6OuckoJ7trs
         gLVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d2XCn5c7u76aHt8pz+uJdX8mlqVxlO1XAilJ/HOB5LU=;
        fh=rsjAR+XK8TLmPsgCmp0GBf02pfG6Njs74aN0syuD284=;
        b=V357PcPLYYlTm/lxSSg3LkOCz70mBe09R8cJ9SNoGulNdbI4mU6vTDNUGC2Fv92Bk0
         NXh0lBhaTlW6mOKs98ZfMgpvZBSsuH2USgfgStIPkmKy2xVy2hH+v57xtIvl+hH6Womp
         tRzW4B51iyY/3nfdBekpbkxgnhNCYs5gCzNetdybXaT31fpa+JWr0doo4ljZIsJTBLgw
         /lpCE9b1umRiqu96KiFNlCs7gLneLfYELzob7ie2znG6+z5rECNnqft5y6Yky6sTV9UP
         gvC/9jKBElauuI4gQSloR2cJmtL4tR1P0sBh0neQrl1aK+487HJuT5Uux9YydvWb0VAn
         uUDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769058164; x=1769662964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2XCn5c7u76aHt8pz+uJdX8mlqVxlO1XAilJ/HOB5LU=;
        b=KRB9YOT3NiOIn0zxA4cjJ6K3vZtNKG731flV9ZIf1VvYHJWtQUuDldY7tc7KLbf4wR
         0JsaR2lpQxoM85tdTj2vmABnmnqmztL24IFDgaJp7f5K+tUzdsU+g7hPSx/dkpJOgZot
         9TzyZPyzaTxVHOKOi9+TYvO3kgtz/uMibfJDSykmQ+nyPcKZORZs7ftlpKI8GYwtvCKx
         ugs7nUXk66VNWVIJMOnpO1WfvRB8ZPvafizXBzmNXUtWNK9wQd9zLScr5/QDF1tMEcQp
         K8evqUL4vcdwkOY3G4KdQlL96dUvbbnO8MFEtRu1WXFO4Jx5IiTE3ivHWudo8b8Fs0iD
         P/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769058164; x=1769662964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d2XCn5c7u76aHt8pz+uJdX8mlqVxlO1XAilJ/HOB5LU=;
        b=YtHG+VERxYpUFGXubtRjFtXb3a/l3x13uQXg9eCaRfP90URsb08NffZTZi9CG5otCL
         wWI0rm9E60ebqe3xisLY4N26mK33GcBQT13b01UswFCl+dENZzZLdSjwEZWJOhKczW7Q
         3a82xjKipGWJ9L8vAnwjrxsSKYSIVz4iz+ldLA0PgwPBwAlddtKfMmKEoXh8haYtNQv/
         K8yKETrYGmBquJw/LqY6CHNELh9QKNSGoGUEgdUvcxTIncNxHRdlU2xWKMo16ajQQ/RJ
         iLPqCgzyv9eS0exEs4cTc60WcTeATlB+91gwvqAdPVJaUCYGmiU6JNrOp+xSy3vYo4zt
         ZIBg==
X-Forwarded-Encrypted: i=1; AJvYcCWgGyQqvkTjJh80KOhel6PxY7FbIH+gkRNRznYBppzRftGJzssWJso25unkgLYywCKWsVA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx68MV4r3PprJXpbujDjQEHMHT6IMugF3019BW2yDc8JQDiYfeu
	iqq9Eb1DMfMLbhiibtqqxg3VjbwUqsf+NqTjt+b4zQyqD75Jn05pZnJoODTcHfUvxUDnRdc5+6f
	SQr7hYXzstHpPw9+3Uwb8VK+nqUajFkwQb2vtxITz
X-Gm-Gg: AZuq6aJ4Wzolw26KAKjtXX9ZRUJf9Tnd2pEM7ZtGDZK13bdypyibG43uBtn8RhXovGa
	dCyWE77ZHLm5hnalU43ZCEFl6gZcjVPnZI82A94f/urN7mfKNOr7rHBrytTnJktj7+zk6DN4OKs
	q9LHKNpTcv2P9SWqg/XgkDbKRZalB8nhf0GDjJIB1yXjnEJE49W5G15MFOcHrgNnGjaS3QdKE3t
	+cbO5fneNPoDBGz2thXheAbPFJtY5rUjH2LlbWmzyRnoryU6LzhmN2Q+gjI2QTb9BAlSaZyDWKq
	fRtpif1TSiiAyqVdb6SGCw77GPYdYMj+IcdQvw4f
X-Received: by 2002:a05:600c:1c11:b0:477:b48d:ba7a with SMTP id
 5b1f17b1804b1-4803e7f1b57mr123835775e9.32.1769058163763; Wed, 21 Jan 2026
 21:02:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com> <20260112174535.3132800-3-chengkev@google.com>
 <23l6bxew3cbnsgl6zagqz6qqtkb7mwfeqcl4opp2ulk3cu5fmq@hqfnuptmaiti>
In-Reply-To: <23l6bxew3cbnsgl6zagqz6qqtkb7mwfeqcl4opp2ulk3cu5fmq@hqfnuptmaiti>
From: Kevin Cheng <chengkev@google.com>
Date: Thu, 22 Jan 2026 00:02:32 -0500
X-Gm-Features: AZwV_QhKnIiePOT-bPKLSdN12Dm2aVayZOS_W4eXCPZhudXQtGb7h_qrjZ6EJqc
Message-ID: <CAE6NW_bjcj5mto_pt_tNt3Fysirw7_aG_+c69u-+bZwwWVPgGA@mail.gmail.com>
Subject: Re: [PATCH V2 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and
 SVM Lock and DEV are not available
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68852-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,mail.gmail.com:mid,linux.dev:email]
X-Rspamd-Queue-Id: B64D961E5C
X-Rspamd-Action: no action

On Mon, Jan 12, 2026 at 3:50=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Mon, Jan 12, 2026 at 05:45:32PM +0000, Kevin Cheng wrote:
> > The AMD APM states that STGI causes a #UD if SVM is not enabled and
> > neither SVM Lock nor the device exclusion vector (DEV) are supported.
>
> Might be useful to also mention the following part "Support for DEV is
> part of the SKINIT architecture".
>
> > Fix the STGI exit handler by injecting #UD when these conditions are
> > met.
> >
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 6373a25d85479..557c84a060fc6 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2271,8 +2271,18 @@ static int stgi_interception(struct kvm_vcpu *vc=
pu)
> >  {
> >       int ret;
> >
> > -     if (nested_svm_check_permissions(vcpu))
> > +     if ((!(vcpu->arch.efer & EFER_SVME) &&
> > +          !guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) &&
> > +          !guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT)) ||
> > +         !is_paging(vcpu)) {
> > +             kvm_queue_exception(vcpu, UD_VECTOR);
> > +             return 1;
> > +     }
> > +
> > +     if (to_svm(vcpu)->vmcb->save.cpl) {
> > +             kvm_inject_gp(vcpu, 0);
> >               return 1;
> > +     }
>
> Not a big fan of open-coding nested_svm_check_permissions() here. The
> checks could get out of sync.
>
> How about refactoring nested_svm_check_permissions() like so:
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f295a41ec659..7f53c54b9d39 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1520,9 +1520,10 @@ int nested_svm_exit_handled(struct vcpu_svm *svm)
>         return vmexit;
>  }
>
> -int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
> +static int __nested_svm_check_permissions(struct kvm_vcpu *vcpu,
> +                                         bool insn_allowed)
>  {
> -       if (!(vcpu->arch.efer & EFER_SVME) || !is_paging(vcpu)) {
> +       if (!insn_allowed || !is_paging(vcpu)) {
>                 kvm_queue_exception(vcpu, UD_VECTOR);
>                 return 1;
>         }
> @@ -1535,6 +1536,11 @@ int nested_svm_check_permissions(struct kvm_vcpu *=
vcpu)
>         return 0;
>  }
>
> +int nested_svm_check_permissions(struct kvm_vcpu *vcpu)
> +{
> +       return __nested_svm_check_permissions(vcpu, vcpu->arch.efer & EFE=
R_SVME);
> +}
> +
>  static bool nested_svm_is_exception_vmexit(struct kvm_vcpu *vcpu, u8 vec=
tor,
>                                            u32 error_code)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7041498a8091..6340c4ce323c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2333,9 +2333,19 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
>
>  static int stgi_interception(struct kvm_vcpu *vcpu)
>  {
> +       bool insn_allowed;
>         int ret;
>
> -       if (nested_svm_check_permissions(vcpu))
> +       /*
> +        * According to the APM, STGI is allowed even with SVM disabled i=
f SVM
> +        * Lock or device exclusion vector (DEV) are supported. DEV is pa=
rt of
> +        * the SKINIT architecture.
> +        */
> +       insn_allowed =3D (vcpu->arch.efer & EFER_SVME) ||
> +               guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) ||
> +               guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT);
> +
> +       if (__nested_svm_check_permissions(vcpu, insn_allowed))
>                 return 1;
>
>         ret =3D kvm_skip_emulated_instruction(vcpu);
>
> ---
>
> We may also want to rename nested_svm_check_permissions() to
> nested_svm_insn_check_permissions() or something. Sean, WDYT?

I just sent out v3 without the rename for now. Sean, if you prefer
nested_svm_insn_check_permissions over nested_svm_check_permissions
let me know and I can change along with any final revisions.

