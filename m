Return-Path: <kvm+bounces-72256-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ICE5FwY7omk71AQAu9opvQ
	(envelope-from <kvm+bounces-72256-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:47:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 071AE1BF7B9
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0FC003059AB8
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A908D2472A5;
	Sat, 28 Feb 2026 00:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEJbrnTS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF70B24B45
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772239606; cv=none; b=hCr9wM6HEkE+MCxvAxHsRu4VGjZ2I7Om1Y1AjnvOFV7fG1AkXadWzPpx9jKFtVGqUw3WVvrybjLnk6gOYKZjxnLCXlNoISjJD3LEJitKqrVvvXaWH62IeU/qnqgjHWvwgWyX5y+kMpsSoqox16Z/txqw+wqjvyhfjyLaflEprJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772239606; c=relaxed/simple;
	bh=QRvC1jZ8oS8U7LcAW8SYx0fY3Tvg5kmOfu9Odf4nRNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EusR2qOLx9icrI+KmL+AvaW5UMCdZj0kAUXiIorK3NgodNDRNLoMnqYS37ha0X86g1YzgwpzFYutMaIjhxHNsllC1Rv6FTyi5d3NW6sA7l+CcXuDlX3Rh/ZVfzB9ezdysAWAjsrKOSLdrs1Q/UAXr9ae6oa1gz397YIdSSnMrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEJbrnTS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B065C116C6
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772239606;
	bh=QRvC1jZ8oS8U7LcAW8SYx0fY3Tvg5kmOfu9Odf4nRNo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MEJbrnTSsxVBQMK0wIr9GMjBARrf4CQEPqOqUksuSiyEqFM+7JvwQwSzDWUnb7uZ+
	 5eUMU1tqFqf58snIk2r6vYRE3ZqyFW4d3jzRU9O5W+ncfNH5CTekusDIp/xDzO4UcL
	 Cy0mAOdJ0SuCdCnSrfoV0YYrDZstbCGAH91Wf5J1nIfddfVbKNPH1V+Nray4fcH91V
	 D5qbh5QnEwSiClylcOIE49tRGH9N44sT5SvrLc21MCq09xpTy7GsTKQX1Y8P5uwLM4
	 HF/26v7NdM5F2DQ5ccUb6MFeL7/xy5MIhq/atnOvpK/yfvdY6vicpbMWZE+Yghl8T8
	 GjaTeAuD5s+fA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65c0d2f5fe1so5392896a12.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:46:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUq+pG/hW+2mP0mlgrKTHg4UKjAN3Hs6s94Y3zIQxGgX+Vczp0TnlgBs3ktnqVuNeMnS90=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJhl4BOtlicHQXWP/8tiaGc2tM8NW5YRN1JNW7R/xg/rndGt0I
	8pEmSOwye8rjuEbOua/BdQU4cR81zxSfBcth+hsyW117nbguQn4whyTVzh84hVauvCWB6dvOWwA
	guZVY2j/qHUfkl/grH51wmAW6WFpHAtY=
X-Received: by 2002:a17:906:6a27:b0:b88:68b6:e578 with SMTP id
 a640c23a62f3a-b93763bfb31mr359879166b.25.1772239605447; Fri, 27 Feb 2026
 16:46:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
 <20260209195142.2554532-2-yosry.ahmed@linux.dev> <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
 <aaCO62eQiZX5pvSk@google.com> <CAO9r8zOcBbgtNzy6FizPe8Xm8W=jg3CR8pmdByfszfEM3rqzsA@mail.gmail.com>
 <aaI51_1_bR4zRTXY@google.com>
In-Reply-To: <aaI51_1_bR4zRTXY@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 16:46:33 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPvQ1+_HGNuRZJuOTQ_YJHgMB=52-68rHFXKF8mWy6CNw@mail.gmail.com>
X-Gm-Features: AaiRm53nCUap8U36P5oZ1TByvqsfEJ3Xmhur7Scckz7btZlaFClDOeUUzH_VoPs
Message-ID: <CAO9r8zPvQ1+_HGNuRZJuOTQ_YJHgMB=52-68rHFXKF8mWy6CNw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: Triple fault L1 on unintercepted
 EFER.SVME clear by L2
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72256-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 071AE1BF7B9
X-Rspamd-Action: no action

> > What if we key off vcpu->wants_to_run?
>
> That crossed my mind too.
>
> > It's less protection against false positives from things like
> > kvm_vcpu_reset() if it didn't leave nested before clearing EFER, but
> > more protection against the #VMEXIT case you mentioned. Also should be
> > much lower on the fugliness scale imo.
>
> Yeah, I had pretty much the exact same thought process and assessment.  I suggested
> the WRMSR approach because I'm not sure how I feel about using wants_to_run for
> functional behavior.  But after realizing that hooking WRMSR won't handle RSM,
> I'm solidly against my WRMSR idea.
>
> Honestly, I'm leaning slightly towards dropping this patch entirely since it's
> not a bug fix.  But I'm definitely not completely against it either.  So what if
> we throw it in, but plan on reverting if there are any more problems (that aren't
> obviously due to goofs elsewhere in KVM).

I am okay with that.

>
> Is this what you were thinking?

Yeah, exactly.

>
> ---
>  arch/x86/kvm/svm/svm.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1b31b033d79b..3e48e9c1c955 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -216,6 +216,19 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>
>         if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>                 if (!(efer & EFER_SVME)) {
> +                       /*
> +                        * Architecturally, clearing EFER.SVME while a guest is
> +                        * running yields undefined behavior, i.e. KVM can do
> +                        * literally anything.  Force the vCPU back into L1 as
> +                        * that is the safest option for KVM, but synthesize a
> +                        * triple fault (for L1!) so that KVM at least doesn't
> +                        * run random L2 code in the context of L1.  Do so if
> +                        * and only if the vCPU is actively running, e.g. to
> +                        * avoid positives if userspace is stuffing state.
> +                        */
> +                       if (is_guest_mode(vcpu) && vcpu->wants_to_run)
> +                               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
>                         svm_leave_nested(vcpu);
>                         /* #GP intercept is still needed for vmware backdoor */
>                         if (!enable_vmware_backdoor)
>
> base-commit: 95deaec3557dced322e2540bfa426e60e5373d46
> --

