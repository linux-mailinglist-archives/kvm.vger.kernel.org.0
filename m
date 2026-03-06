Return-Path: <kvm+bounces-73093-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHk2CVL9qmkIZQEAu9opvQ
	(envelope-from <kvm+bounces-73093-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:14:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 349EC224A21
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8C509301DD23
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BBC43ECBD7;
	Fri,  6 Mar 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sq+5jRK8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDDB36C0D3
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772813412; cv=none; b=AK+EHU8T92gyizpxL//Hw+8gZqJLDl7wQZm5/5E3ScQoYcD9Y0hYGO7apx8HhNwzJLarLBs3juegQPSPenADNg31qi3/e+iePgCEpffPOevRmGGu37oN2LMvhX0xzCmkkVml5HHo31Ktlv1R7gVlq/qdQqxVQfl4Q/7JogL7D5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772813412; c=relaxed/simple;
	bh=oOELcoSbFl8CBKYr8HWUn6/h9/htHYOBEH2AH3gxG/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dAiLWptRgVbbGJ/6nJP3CIgJJhqNr5m4qjHNLdfdg3sbTbw2m5YW7rLwnu+1e0v7NTCQslHqc00pz7+raS4HCh4K3n3FmcPS70M6Fbf0IkB1WLGF9Cw3EFCR1ad6+IQ0K7wSs8oN1yWX3gB5oR/e/BREUy3SDSH0PUAh6OvaA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sq+5jRK8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039D1C2BCB0
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772813412;
	bh=oOELcoSbFl8CBKYr8HWUn6/h9/htHYOBEH2AH3gxG/o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Sq+5jRK8mg4JZ9Sf5JSrT/kx9Fcq2DUNg6wmhfcYuTzMrrc4BL9wBQJXZRdHQMDZk
	 YBW5ciPA55hUoyIyQZIvTnegg8Jl7ZX2Q7MwU+0r5GUgaa/0DPG4NpinVFnsgzVT3W
	 NZtMFHkX3tLO0dhGhAm/2/NUsroAMrBVBDeBqjLeUe7Fs5gI4cgB4HX4Zt/QgNT4n+
	 WIhTQnnMNuFR1PNoNGkW0MWYMiST6o9ywVC6RUkXJ/4uNlFMIjQqWq5YeSaWZBKKB0
	 nHeiSuAtcvTY4QDbIX0hIji0YKava6uiCbVCEGq3oZJwlUcMANTrQGCvgJlyRrAp8L
	 8s/cdOxyDks7g==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9382e59c0eso508914766b.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 08:10:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXTrp4PUBvfI8ij8p0/P0vUygAnJShTSHcEKAzFDqRYrFnLyMKgHHxGVVrHI3h8sTb5EfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz3LNA9LpHeshwy1msi0+PlIgK5pZOBKg27PS+UZywnb8H5lfr
	Onyep1T4eMBH8PszdXHmPOQqCnO4LTuEZ+HWcf6ssgerbCqAfOe0x2E5Qabo2cGtWyKtzK9pLta
	5jd0JUKzFt7jHWIpJzBTcLs6JKG92TLc=
X-Received: by 2002:a17:907:3f1d:b0:b93:8643:156a with SMTP id
 a640c23a62f3a-b942dba9d1amr172955666b.16.1772813410747; Fri, 06 Mar 2026
 08:10:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
 <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
 <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com> <aaowUfyt7tu8g5fr@google.com>
In-Reply-To: <aaowUfyt7tu8g5fr@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 08:09:59 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP0qkjkEMYMc=sW+k+f+HGQMzh0H_Y0u3BeqqcraGYWcA@mail.gmail.com>
X-Gm-Features: AaiRm52aqgdskZNyepF2l6ML3QJyOaV7R_wYwd8fPlkOfw8s9fZnJ04aHx8NSqo
Message-ID: <CAO9r8zP0qkjkEMYMc=sW+k+f+HGQMzh0H_Y0u3BeqqcraGYWcA@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 349EC224A21
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73093-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.956];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index b191c6cab57d..78a542c6ddf1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1105,10 +1105,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>
>         vmcb12_gpa = svm->vmcb->save.rax;
>         err = nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
> -       if (err == -EFAULT) {
> -               kvm_inject_gp(vcpu, 0);
> -               return 1;
> -       }
> +       if (err == -EFAULT)
> +               return kvm_handle_memory_failure(vcpu, X86EMUL_UNHANDLEABLE, NULL);

Why not call kvm_prepare_emulation_failure_exit() directly? Is the
premise that kvm_handle_memory_failure() might evolve to do more
things for emulation failures that are specifically caused by memory
failures, other than potentially injecting an exception?

