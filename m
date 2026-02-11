Return-Path: <kvm+bounces-70848-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QCqxOVSJjGmHqgAAu9opvQ
	(envelope-from <kvm+bounces-70848-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:51:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DF8124F3D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8615301C8A2
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AE33161BD;
	Wed, 11 Feb 2026 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AbEVoJr3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FA028B3E7
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817864; cv=none; b=ddFHYLR4MDLOJSFfZiJJHKGzXxNZdhLt+RzcTejGL8sNijmsgy7NV8qAnnRQ7apGB2MHNSdj/Iuswqv30MsiquKum/fr37V/CX2DAtIxxOKOC54XpqypDwzLtzrOawKNgJ9zfU/JRIZf94tk1C73Z2MBX1/3CdX0uSReib5+blo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817864; c=relaxed/simple;
	bh=9INrHUmwFywTGvbap0c3DEfTJO34ic60JVJc/xXUDLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PKrzV+8h6+S0Q+0fGqgoZzqBd7d79bIksftOHNJaC8ikUUxAsTOTbKQoOFl2EEduGegUnjF6xVlwK5WuAdVZd5/hX2t2UTfPE+uy32pKet0YYvFcEitH9EmXb++QcVo0mk96Hp8XnOmfz+zDSq7dKQt7kO1l2igZJvz4EcyvFCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AbEVoJr3; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f3fb8c8caso14284617b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 05:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770817863; x=1771422663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c32JYHbBWshajyptgX79a7MBzw3VfpoWrQuDdYKV4eM=;
        b=AbEVoJr3k/8fQ9AdIXvExQRlF6iUs8j0xraCgDYp/47haoJWCctsXGyOnpTkfesw25
         bHrlqYxnq9IYsPYsBtcSr6A8AgmT++kPJeSMjg7mv/+QTRkuRrDtFxbLUp2FLwQeLAJp
         5zmhmDIFTR7BG9aP38+5OK4Op03NCJgBHcXHLpGQaGo32HADuUUJw6qvxkJj3DoGKUfk
         tu/Oly+qqV4torLXsHMhn3KhIusqO/JBANYn9PZP3dJ4ys/B+ZXnier+RuXYOAZmPeBn
         16i4G22V6rO43YELhi5iqRQpTee1s9+Ce1VjftaYe1KLQQRByw0t8aO9po4d9WTEnHFD
         lAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770817863; x=1771422663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c32JYHbBWshajyptgX79a7MBzw3VfpoWrQuDdYKV4eM=;
        b=cxLVJcfbyuRptn36ImHyKWdFAbZzMQD9MX2swhBFgsaf2Jrf6Y5LoLoEyTJcfe67FK
         7seyUCTGuVPP5yQeVIW9ks0XA3nBo8Rt4K26osK3kKASRhhcPdoX4cxDjYJska+cG49X
         aU857pziasRjCxHZd3MTM+m29f6poBbzxiIEJbpv3CEMgEuC2uHgo2wnvt/BWR1VUHWK
         unK2oIpwlalAJTuxC6igMhmZfzeCrhBRkeVJAhioG95bG414xg+pzWysfiwAi8wQTEx4
         xk36XRMZFMmUrWFETSp/V3mkHLFzh4qWz4D8Mh5JypBhoK39ydWE9J/Um5vzNzRBmJau
         IiAw==
X-Forwarded-Encrypted: i=1; AJvYcCVhQP2ZBQeRU10TzPTzMS0AVOTiU1g4Kb1l/glxkxCaGI1a2kCW8rZ0E/iVGNYqaqixX5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjSTdgOccE2wuwGx2GYvM0Yab7CByOn6MSptbG7Wv+KZVKcohu
	Q2nEEuTZMhgi5HOohrkoZh8Hn34K5ogAw0HtnFZAdFxRN3lTGY9cO4rDjNxT4Xr4iEhFwnkeJ9l
	OQ9jW8g==
X-Received: from pfbfj4.prod.google.com ([2002:a05:6a00:3a04:b0:824:a3b4:6d0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ae01:b0:81e:591c:e7b8
 with SMTP id d2e1a72fcca58-8249ae8dfcfmr2079095b3a.17.1770817862722; Wed, 11
 Feb 2026 05:51:02 -0800 (PST)
Date: Wed, 11 Feb 2026 05:50:59 -0800
In-Reply-To: <20260210210911.1118316-1-jamieliu@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210210911.1118316-1-jamieliu@google.com>
Message-ID: <aYyJQ92032DNvqSd@google.com>
Subject: Re: [PATCH] KVM: x86: Virtualize AMD CPUID faulting
From: Sean Christopherson <seanjc@google.com>
To: Jamie Liu <jamieliu@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-70848-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 49DF8124F3D
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Jamie Liu wrote:
> CPUID faulting via MSR_MISC_FEATURES_ENABLES_CPUID_FAULT is only used on
> Intel CPUs. The mechanism virtualized by this change is used on AMD
> CPUs. See arch/x86/kernel/cpu/amd.c:bsp_init_amd(),
> arch/x86/kernel/process.c:set_cpuid_faulting().

Please rewrite this to state what is being changed, e.g. how KVM is virtualizing
the feature, and most importantly why it is "safe" to do so.  Specifically, this
needs to call out that CPUID_USER_DIS is documented in the APM as an architectural
MSR, which for me at least, is mandatory for virtualizing/emulating any of the
MSR_K7_HWCR.

The fact that Intel uses some other mechanism is irrelevant, and the kernel source
code is not authoritative for things like this.

