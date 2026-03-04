Return-Path: <kvm+bounces-72664-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCWdGC/vp2mWlwAAu9opvQ
	(envelope-from <kvm+bounces-72664-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:37:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC471FCB3B
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 19E6B300ADBA
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 08:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257BA3932C2;
	Wed,  4 Mar 2026 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dyKitd1q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORVptZ4B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD9F391833
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 08:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772613402; cv=none; b=f748Nz94QIeyDk+b1wrFa6FM3V+QATfC3Ig/fjruSPHpsdAeZf5xwrrFqUqAes6LmXMJemZHQvzWl4IHNcSuhtQXJ4FQxGHi4SU6wax6vG10aAmkghShvmi2zfCsHChvrNxgsyyIRIsgnrUqLkRQQyRc3bahoxdsO31755BKp3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772613402; c=relaxed/simple;
	bh=QSBcGmDsWK/NH6et+dG1iPnSDXX0/3NVX+QCWh2smAo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gZGPZsVh5+JOgOjq3u0wcLfUpqi3+a5uYR+DW8gkJUdckwOVVL6Rm/Ml2VRijoAX0di4xrNvPAG7z+xfqfqC0EnJSBHMJMTRKBI3TkNo+tflAf1t/UvyD2GFssmhNxyZ9Xvk12RvKZFfDSiUzMq2V3kkxpwf/N6PZffdPDeYvL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dyKitd1q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORVptZ4B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772613400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uwX6iKeeaH2J9b02p03XpBrgDxfB3A6QtMrwxI6mtEQ=;
	b=dyKitd1qf3RQVzbYI4G9xl7OUvwEg+608EdMypBlSPZzn7om326VcVSoO/MEjcCm6b3HKR
	VfCO50ye0VAohcy8DDI6yol/t/ZAOBeqAjaeBRgLmrKZSrS43oquvvX2sV5ollg5ZHUZot
	Ry+PFWlgUTSkONRiU04iM2tW1HSVh70=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-yNARu9C-OZi9PqoxwyGFwA-1; Wed, 04 Mar 2026 03:36:36 -0500
X-MC-Unique: yNARu9C-OZi9PqoxwyGFwA-1
X-Mimecast-MFC-AGG-ID: yNARu9C-OZi9PqoxwyGFwA_1772613395
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48069a43217so62692385e9.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 00:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772613395; x=1773218195; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uwX6iKeeaH2J9b02p03XpBrgDxfB3A6QtMrwxI6mtEQ=;
        b=ORVptZ4Bum/UPCcdvcLiHFa2u53+HXxmYPr8zzN590Ru/8BXW2qTP2CZJWLpv0kyDm
         8hz58nqLKBjpEoJ0jwcCR3E4haiLv3kjh7RYB+17fixklIGdKXhfnaTqzFZqsgI+C2QB
         XWjo2bRueMrDngPvB2oWQ3sA/ZYEWwc3mTK9b15jzQuvqvRHTOE2uZuaQpkshOf+t+MC
         0/5NdInbaRkEhAwX2t7TvVVGLozP2QZX5j3evcUeA3stO3R3wj8f0jhtUyR2mMngaIXD
         vj4LkZzrKdf41rUp3v09Nl6YvxCZcaw977sufB8Mj33mJEZpulKWirskJRe9lmnK7N2Q
         uxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772613395; x=1773218195;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uwX6iKeeaH2J9b02p03XpBrgDxfB3A6QtMrwxI6mtEQ=;
        b=OcdSiALYTCUyCgWX++tUyhGv9fc9Vn0y0iRFmRq1d34qzIbKDHIz8yV+vGxT5sNx2F
         EsjLjSiOQCBI7jsE+JN31UOlqZOFSys09Dx/Hb/D+31TX2KFfgQwE4v+HexVNCtFAgIr
         hzjM1x8nrwIdOCFTQdnhb8J5rsRtoC2a0Zsdl1FzTC7n3BVuJr3Mhsry/N7tYQy5tsCB
         PCdgIMTcJLsZmGH+/vsIoCOOTUomgfqjREdSPfnlvLf2QOWSFU2EWuMzOOTUnP7ti0x+
         nV50drK6S4yMAWR3JpOfjUc4T5hRCuDkGmsOgkxOBpK4oItWl9FeXmVgWO5j+XFgCHYy
         z2RA==
X-Gm-Message-State: AOJu0YzZs5Z2aywkKT8/wl+mh0bgcgeiXC02gsicgI1bK5JauPQK+Xbn
	WotSdDndpT9Utkn0QFXoSvIUWxlU78EtrQv1wSTYZ1/mLZaFHEj2TeL08AQe3CmZMSUl91g40qH
	r7ClSKY2z+Yqz0Wu2sm576gOcNoUbMcSb0vDe7NF2oEZLbfJToAKJwA==
X-Gm-Gg: ATEYQzxfa8jxxSlWaHsJDxKUUlV5UnDyUW6SqiTltuXTUam68bY6qplCmtj4z9D1Dr/
	44M+978SCaEewlEoSYV0k7+5PYxIhW/zaThxvfwdClEM9YDnY8GWyp4Xs9bHk+7if4rzkAChFgS
	in4N0B+zVf0qX9Ma+iO0/uu2VcTM6zUkqEPhbZJcOYlFrtVquFD3mHnffFr8APwutsPiFkWXwdG
	RkXlE1X30F+S46RhYTdGbByKVnZisxmp3OS6HK3iXrky8CObR96CP+gJT6XeN6xCM4wBPnoHXca
	IP8vLmJ2/HC3qFdMWpNZqykx4VYChf0paj2bv1KE7TMLzoMmsT53HRu1YYTwG6i//gn6ZIsCV9R
	qv3vB3ypaE699svt4FQ==
X-Received: by 2002:a05:600c:a15:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-48519881d19mr19104885e9.23.1772613395380;
        Wed, 04 Mar 2026 00:36:35 -0800 (PST)
X-Received: by 2002:a05:600c:a15:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-48519881d19mr19104545e9.23.1772613394929;
        Wed, 04 Mar 2026 00:36:34 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485187caf9fsm40447835e9.7.2026.03.04.00.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 00:36:34 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Cheng
 <chengkev@google.com>
Subject: Re: [PATCH v5 2/2] KVM: nSVM: Always intercept VMMCALL when L2 is
 active
In-Reply-To: <20260304002223.1105129-3-seanjc@google.com>
References: <20260304002223.1105129-1-seanjc@google.com>
 <20260304002223.1105129-3-seanjc@google.com>
Date: Wed, 04 Mar 2026 09:36:33 +0100
Message-ID: <878qc8f0tq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 5BC471FCB3B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72664-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[vkuznets@redhat.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> Always intercept VMMCALL now that KVM properly synthesizes a #UD as
> appropriate, i.e. when L1 doesn't want to intercept VMMCALL, to avoid
> putting L2 into an infinite #UD loop if KVM_X86_QUIRK_FIX_HYPERCALL_INSN
> is enabled.
>
> By letting L2 execute VMMCALL natively and thus #UD, for all intents and
> purposes KVM morphs the VMMCALL intercept into a #UD intercept (KVM always
> intercepts #UD).  When the hypercall quirk is enabled, KVM "emulates"
> VMMCALL in response to the #UD by trying to fixup the opcode to the "right"
> vendor, then restarts the guest, without skipping the VMMCALL.  As a
> result, the guest sees an endless stream of #UDs since it's already
> executing the correct vendor hypercall instruction, i.e. the emulator
> doesn't anticipate that the #UD could be due to lack of interception, as
> opposed to a truly undefined opcode.
>
> Fixes: 0d945bd93511 ("KVM: SVM: Don't allow nested guest to VMMCALL into host")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/hyperv.h | 4 ----
>  arch/x86/kvm/svm/nested.c | 7 -------
>  2 files changed, 11 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index 9af03970d40c..f70d076911a6 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -51,10 +51,6 @@ static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else /* CONFIG_KVM_HYPERV */
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
> -static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> -{
> -	return false;
> -}
>  static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
>  {
>  	return false;
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 750bf93c5341..2ac28d2c34ca 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -156,13 +156,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  			vmcb_clr_intercept(c, INTERCEPT_VINTR);
>  	}
>  
> -	/*
> -	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
> -	 * flush feature is enabled.
> -	 */
> -	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
> -		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
> -
>  	for (i = 0; i < MAX_INTERCEPT; i++)
>  		c->intercepts[i] |= g->intercepts[i];

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


