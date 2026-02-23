Return-Path: <kvm+bounces-71503-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAuTIviEnGm7IwQAu9opvQ
	(envelope-from <kvm+bounces-71503-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:48:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8445A17A1FD
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 47D4F301B847
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2456C3176F8;
	Mon, 23 Feb 2026 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="scXJbOsY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536442BEC43;
	Mon, 23 Feb 2026 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771865319; cv=none; b=rO55GQirPeJnKQ2rHngJWjvPafaP965To3+Avivq4uiAsBnJRnTw1+n4FGHixthG/s59ibDJcbgXi2Nx+5Q1F21Efw7/VGqSEJtvX9EbJgHyJqIrUtgqbPr2/duhFW//mBosxV7Fo39zENoXRcuAIY4iWXGOBI2QEh1FbqOQ7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771865319; c=relaxed/simple;
	bh=6e/dCuwFS/KO2V9XtgtDFUvem2WrYoIE73w6qqh+aNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XACrYPiGTXJAGRa7DyIyBVkc4xVQ2uHeXmaR9MXyL3kv1v6YDpugbbyIrNjEkQAY/Ok8cjHMsdZsD6l++7QdygIbX+Us64xz42pKt+SWiIUToC8h7pmqQemtcBUN3wkLOYPD2mqn9cfhutaJOYfZNIZYeHFw1I9n4TPm7/rX2sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=scXJbOsY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9917DC116C6;
	Mon, 23 Feb 2026 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771865318;
	bh=6e/dCuwFS/KO2V9XtgtDFUvem2WrYoIE73w6qqh+aNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=scXJbOsYbS05alfja+Tr3VQrZVNY1gODD1J5RECvr3/Z4j4T8PdRmy3cn4aD8fgul
	 9Eann52bUWG//xmfHa4Gp+2Nm1DTowi24LcJIkBxV8U7jCTr2ib0q8XlaS4bSWW7vL
	 t44lb6sIPqO/IUNFXAhbpgYQa7KlTj8h/oa+dA7cH1mArzhc2iAznvtTZ5Va2Fg2vm
	 u5pqUcCL2coC5jnAzQmtBtGC+jCrePt9cz+JNmNy3pdUR8gWVeoJCijC0vuJUhi8D7
	 ORi29hp23Z+81s+278UaNDEeQr7XDFfNH3ekEU3Ywxir77IS78wYi88HgJBCbz0CSH
	 1Awnqg6h1e+vQ==
Date: Mon, 23 Feb 2026 09:48:35 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
Message-ID: <aZyE4zvPtujZ4-6X@tycho.pizza>
References: <20260223162900.772669-1-tycho@kernel.org>
 <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZyCEBo07EHw2Prk@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71503-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:url,tycho.pizza:mid]
X-Rspamd-Queue-Id: 8445A17A1FD
X-Rspamd-Action: no action

Hi Sean,

On Mon, Feb 23, 2026 at 08:36:32AM -0800, Sean Christopherson wrote:
> On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> > index 86ad1c7d068f..c7fda9fc324b 100644
> > --- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> > +++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> > @@ -213,13 +213,48 @@ static void test_sev_smoke(void *guest, uint32_t type, uint64_t policy)
> >  	}
> >  }
> >  
> > +static bool sev_es_allowed(void)
> > +{
> > +	struct kvm_sev_launch_start launch_start = {
> > +		.policy = SEV_POLICY_ES,
> > +	};
> > +	struct kvm_vcpu *vcpu;
> > +	struct kvm_vm *vm;
> > +	int firmware_error, ret;
> > +	bool supported = true;
> > +
> > +	if (!kvm_cpu_has(X86_FEATURE_SEV_ES))
> > +		return false;
> > +
> > +	if (!kvm_cpu_has(X86_FEATURE_SEV_SNP))
> > +		return true;
> > +
> > +	/*
> > +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> > +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> > +	 * check the underlying firmware error for this case.
> > +	 */
> > +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> > +					 &vcpu);
> 
> If there's a legimate reason why an SEV-ES VM can't be created, then that needs
> to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
> of ASIDs due to CipherTextHiding or something?

Newer firmware that fixes CVE-2025-48514 won't allow SEV-ES VMs to be
started with SNP enabled, there is a footnote (2) about it here:

https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html

Probably should have included this in the patch, sorry.

> Throwing a noodle to see if it sticks is not an option.

Sure, we could do some firmware version test to see if it's fixed
instead? Or do this same test in the kernel and export that as an
ioctl?

Thanks,

Tycho

