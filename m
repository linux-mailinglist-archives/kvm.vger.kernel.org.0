Return-Path: <kvm+bounces-71297-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNSiDZ9JlmngdQIAu9opvQ
	(envelope-from <kvm+bounces-71297-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:22:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5443315AE65
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 16F103003731
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6985C33ADA7;
	Wed, 18 Feb 2026 23:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jDh6SHln"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEA033A9FE;
	Wed, 18 Feb 2026 23:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456915; cv=none; b=dFAlUyJGiIfYNlnpUhFGlBOxFkGqTXhY5kAUoJDtBYqwWjW9mXX6vrmFh9znGPQTLHonP2tJo+Als0SumKrJmhJ+Bymw3+TMGWx7+3ADDujqXRjo2MqoxWn2rno2n7LL/knSmxmKQXPyCXlm7oYLXEWFCVM4daFg1t3h1cT81C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456915; c=relaxed/simple;
	bh=T/cclOwhKKQs3XRUlicg1FKjJ0GzkG9KvdpnuKBPaGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSKfa9iiZSeDPqY07QhxwXXlfGt9dcVwQuSa3XNgSdqPuuyIAQpjeWw750vpXAe9ZdADansxIyfbqpoI6/+lDQAtbFq7gCvbXNV3Vd28ml0EGyo3LTU2Nl5nxbLGkP78eU51XTetFB5U2C1wFgxHgimnNBYg0TZcAq5J2Et05ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jDh6SHln; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Feb 2026 23:21:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771456912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fKwnUMMgghWDxNQszAx9SQm5fZRDMK/2Wm7yA6ehEOo=;
	b=jDh6SHln/lpOmQCWYeWGIooe6RIqOZ4Xxd2Zxc/aMNSt0+5n8xgY4td/NbJimp5qUcf7JR
	mFEwoqplrC2CHDunBgjvsPy1GZhVzVyjxD/iKqlNimYo2gyPE3bolL+Znk2/eokwL/QmSr
	7QAg6ipDCweY0VSMGX089Uik/1LJZgQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] KVM: nSVM: Move
 vmcb_ctrl_area_cached.bus_lock_rip to svm_nested_state
Message-ID: <awpvwdbikxo6dgeakzenvydp23vbhctf573b4hdsb4ohoi3vou@r3eiw3jh6tdq>
References: <20260218230958.2877682-1-seanjc@google.com>
 <20260218230958.2877682-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218230958.2877682-8-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71297-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 5443315AE65
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 03:09:57PM -0800, Sean Christopherson wrote:
> Move "bus_lock_rip" from "vmcb_ctrl_area_cached" to "svm_nested_state" as
> "last_bus_lock_rip" to more accurately reflect what it tracks, and because
> it is NOT a cached vmcb12 control field.  The misplaced field isn't all
> that apparent in the current code base, as KVM uses "svm->nested.ctl"
> broadly, but the bad placement becomes glaringly obvious if
> "svm->nested.ctl" is captured as a local "vmcb12_ctrl" variable.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

