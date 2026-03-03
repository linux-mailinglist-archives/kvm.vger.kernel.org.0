Return-Path: <kvm+bounces-72446-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cI6bELskpmlrLAAAu9opvQ
	(envelope-from <kvm+bounces-72446-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:00:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DB1D51E6E55
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:00:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 50470301EF3E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B991A9F9B;
	Tue,  3 Mar 2026 00:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nttgjt/7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5552225782A
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496051; cv=none; b=U9y/cfuLaPx6scFlaK41DJ/O0AVxWdu9Tv5Np9gsr0atd+jLnpeWridw/ezLY35PiIyAdqWD/vktMiXuToS9kjv6cYmsTmqOk/2giRUhXtOV7edwMZ8U8rIBfMuuoAuVLWAB2/ZWwB6fT+FAf1UGdd3ld8cAx6jDuvwcPXcFd8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496051; c=relaxed/simple;
	bh=8gutTDMbmAenwHt802DdfYXUh9ZUon2s2k6aFeOwWUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OGrMcYinbrHQjCPWJpLsHrcH8kEsOlPz07ZjZ2ckpvA5QXBbFwy9GCvr4XI2pvtc8kwbz+MuZPDSFTV/vvINaqLpdViq9tUAa32nldVkiwmiLOI+rDl0VwlGc6iRVczlGPJBqnI9amsoVS5jA6XCmJHaueNNeiPqt8AGfBnqftk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nttgjt/7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E3FC2BC9E
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496051;
	bh=8gutTDMbmAenwHt802DdfYXUh9ZUon2s2k6aFeOwWUA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nttgjt/74EdUVYMBmuvX8HNXKDMKW5Urp4Nqgvcpx/4vokgbl5jvtGTGUIOL4/p0a
	 zrR4LAiG8d+0GF1kwpMvDBdKnkDJEdgLUIje/8jgGOIezj7a2m5LOB5VUf+18VsUsw
	 xIHV+kqIctiJanzdsYOISqRPWLnMCvCzlt3ttwWecIqO84PQl55MYUhTEwKY/lbWHF
	 KGWnwAZP4yBr84GvKzEYT1EV5yNuOXGFiSpm+y+XzD4PXMWMjrKjkyX9z5YicXn9um
	 ijIRHFfhridCpT6pSybdcUBZkrsrgTYm7cc+d12qWcK1RnxZyQ1b8/yBUFQROFNH5g
	 meKdxWrAdObWw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b904e1cd038so676358066b.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:00:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXHmp9i0d8oeITKo6uePofezriVKka12Wuz06lpbsPHLz6SKIDddWkI1mrBOhz7cZaWOYM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI/sYz6reJNsVcQMR/z9nE/q4JBD2r0l4IDVsLPh0Au6Jh7AI6
	QId6JMrSDxdihNsMvCvEdCYX05p6IhLZIOL0f9MggjbThrHa8Vsp8B+B6f81VXdl7370lUM87aw
	xb4q7drMvtFquTLBt8gWZu/35OJNUnLc=
X-Received: by 2002:a17:907:60d6:b0:b8f:e46f:8079 with SMTP id
 a640c23a62f3a-b93763ab9bcmr911776166b.22.1772496049922; Mon, 02 Mar 2026
 16:00:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-21-yosry@kernel.org>
In-Reply-To: <20260224223405.3270433-21-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 16:00:38 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP1udHX3kNQX+VP2kHXtBhxUrJRrD+mOYG-OsBHWj-xyQ@mail.gmail.com>
X-Gm-Features: AaiRm52gxKMf8IrxCa4fvtCp9j1xhO24gObIeU54LAS2psAUkSqNABFhU0O_LwM
Message-ID: <CAO9r8zP1udHX3kNQX+VP2kHXtBhxUrJRrD+mOYG-OsBHWj-xyQ@mail.gmail.com>
Subject: Re: [PATCH v6 20/31] KVM: nSVM: Add missing consistency check for
 hCR0.PG and NP_ENABLE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DB1D51E6E55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72446-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 752dd9eb98a84..6fffb6ae6b88b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -342,7 +342,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
>  }
>
>  static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> -                                      struct vmcb_ctrl_area_cached *control)
> +                                      struct vmcb_ctrl_area_cached *control,
> +                                      unsigned long l1_cr0)
>  {
>         if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
>                 return false;
> @@ -353,6 +354,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>         if (control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
>                 if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
>                         return false;
> +               if (CC(!(l1_cr0 & X86_CR0_PG)))
> +                       return false;

This is already checked by nested_svm_check_permissions() -> is_paging().

>         }
>
>         if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
> @@ -952,7 +955,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>         enter_guest_mode(vcpu);
>
>         if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
> -           !nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
> +           !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
> +                                       svm->vmcb01.ptr->save.cr0))
>                 return -EINVAL;
>
>         if (nested_npt_enabled(svm))
> @@ -1888,7 +1892,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>
>         ret = -EINVAL;
>         __nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
> -       if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
> +       /* 'save' contains L1 state saved from before VMRUN */
> +       if (!nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))

..and this is checked slightly below.

I will drop this patch.

>                 goto out_free;
>
>         /*
> --
> 2.53.0.414.gf7e9f6c205-goog
>
>

