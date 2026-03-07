Return-Path: <kvm+bounces-73211-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GXzA3CGq2n/dgEAu9opvQ
	(envelope-from <kvm+bounces-73211-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:59:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CCB2298C3
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BA403043022
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D6030AD00;
	Sat,  7 Mar 2026 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZEXnUpct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C6922538F
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 01:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772848722; cv=none; b=Mkecy/JpC5H57MxyBAVKmNI551Jhy65T9qqCILiroEf9yqr8TqfgB+OZhoNRHN10fAjvMWEUsx/e3lXfo3IFi+0mn0zjZo+D69F9lwGp44naX7bkkh0E3aZa3QIDJw7WsVGelKGAlKgwAO3XTUW03tuAhxQ6iz0vwoYp7zwA3Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772848722; c=relaxed/simple;
	bh=/3p7xZEybQEyoIPj8z7QKfOrsJvz2O+7OeYPPTzJFrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pl70fkF7zDie9NSl7Us+L3Bu7cdZfWTxMVvvY9dPD35yEiWCWMK0ORYUghR8KEX9JV+jnolH3JwBLZokWeR3Yo3ILpht0nh9wdKHbxU4zZS2jccZy+uo4IUHu28OSJ56OnlseNASfbLFrcf8Da31o/CneEQJ/ir84nl/1l5J92c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZEXnUpct; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-829ad8a2896so1433085b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 17:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772848720; x=1773453520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FJcj4qTONIol7UXFe/O3JWnAgsBTo4u6T1CUvhonsps=;
        b=ZEXnUpctj81/Eb6CcDNggf1IC9CR60l+3rxoyUeg4fEi8Vn5ixWTk0atoziTj8m8/T
         ZnA8ZCrIEMXWG02sI1BskLww8WxmeUvzTLcZ+QW4fyTeAf7+TslZVWXwojoKhC5e7EJL
         rBO6/YG3ZHFgCUmmZbwY6wXWk25R3MXO9gwE8Dqv3hrkidAYmIwcYRCpwXPqbJyLl6nK
         GcRhnskuzlKHWSMNTThSen9UQQmiVQC9GNeLAYLPZsI54lnYA82YjsXFM5eMUIspTN7p
         xiEhLt4BA9raKkisvHfSLiQa8JXJtx6KPrinoJGDwXWVfYl42sfJ3wO/7sQ+D2Aib9H7
         mMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772848720; x=1773453520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FJcj4qTONIol7UXFe/O3JWnAgsBTo4u6T1CUvhonsps=;
        b=HDILOyGvWehXbDS1JoO3Dxy645jMGSvg07pi5oKS1+PfnkMCh3eNwGBDydkfgkiVwE
         XbjVWGVU4y4dCbvKCm22yi9Mw7AE+Pzr9QNmu9ZzimUaQMCeWwtTYRM1uuWBuOZSXs8i
         YwA55QvJpRCAuPaJb8GbjuoCjiuhaF7dBK/fHgor+g+5cRe/FZ+wpkXy8VagvZ+yB8rW
         HSCzg5uGtF5L0I+g7udeysJ+CPXgplBjmlgawNeAMRiTfBX0fDfFZlOzgqZOuAkSz+gb
         2zxccf8uaiWT2sLvu1ROaheRXeNyOlujEmwpCO6VsYZaNqwn5IXLJNz7AyIRX0rAIVCE
         4Kbw==
X-Forwarded-Encrypted: i=1; AJvYcCXE6knhkLPBjF03Tcu/S4Besn57Dn4CVNqVyCLTjW275KWejfxlYMOX7ToCeTpA6kcqNJc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9vcPHUD1LZWk6gTtKoUQx+PyMAVtT30OPreeTSYYRQ+trqwCZ
	GKVCE/LQR6JuKuZ5ur2g/rnkmugjRgJZbsl920ZBX9ijSU9hsOCVrogTYZL6pnzo6LihDmqQewI
	U5WFXfw==
X-Received: from pfcf9.prod.google.com ([2002:a05:6a00:2389:b0:824:b871:c7cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1827:b0:829:6f37:158a
 with SMTP id d2e1a72fcca58-829a2e3f823mr4056095b3a.18.1772848719917; Fri, 06
 Mar 2026 17:58:39 -0800 (PST)
Date: Fri, 6 Mar 2026 17:58:38 -0800
In-Reply-To: <20260129063653.3553076-2-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com> <20260129063653.3553076-2-shivansh.dhiman@amd.com>
Message-ID: <aauGTverUvkEJnPd@google.com>
Subject: Re: [PATCH 1/7] KVM: SVM: Initialize FRED VMCB fields
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 79CCB2298C3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73211-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.925];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> 
> The upcoming AMD FRED (Flexible Return and Event Delivery) feature
> introduces several new fields to the VMCB save area. These fields include
> FRED-specific stack pointers (fred_rsp[0-3], fred_ssp[1-3]), stack level
> tracking (fred_stklvls), and configuration (fred_config).
> 
> Ensure that a vCPU starts with a clean and valid FRED state on
> capable hardware. Also update the size of save areas of VMCB.

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f4ccb3e66635..5cec971a1f5a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1110,6 +1110,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>  	save->idtr.base = 0;
>  	save->idtr.limit = 0xffff;
>  
> +	save->fred_rsp0 = 0;
> +	save->fred_rsp1 = 0;
> +	save->fred_rsp2 = 0;
> +	save->fred_rsp3 = 0;
> +	save->fred_stklvls = 0;
> +	save->fred_ssp1 = 0;
> +	save->fred_ssp2 = 0;
> +	save->fred_ssp3 = 0;
> +	save->fred_config = 0;

Is this architecturally correct?  I.e. are all the FRED MSRs zeroed on INIT?

