Return-Path: <kvm+bounces-70390-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MD+jECZAhWme+gMAu9opvQ
	(envelope-from <kvm+bounces-70390-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:13:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B8222F8E4B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FB6D302B824
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDE22367D1;
	Fri,  6 Feb 2026 01:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZmRfZVF5"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EEF22652D
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770340379; cv=none; b=pYp44K2OvyM+AjTT69wSH4LNv4yUg0bqZcrbe6TJWnF3rqJKb2sb7XaT6J/vnS9RDgGG+c+vwfidasfP+zfJGyokSm9HDqY/VFWn97eTm4ZHp0rkU+q/yqD5lzvJWTdu42tCIEBgm6Top7fTLSVEEHUqJPaiuOqbmjUmI2TpFd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770340379; c=relaxed/simple;
	bh=KrvUykdzoWqc5N96BU+dGTXvtUZcMP99lptlQr+kl3o=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=dIXE2BjeXHJ4W4TGgFO/Bg1RDQIBEsrjmJEmbra16gesqZeJW73xZWMI9V2TNBgAhZnO3Yw4W+7nhpaF6QsVPxXhErA2aD5QmvZtR3ro17wk5hy0FKdp3ug0ThhqTl/p2Y2UxxuQJrG7A1nmopn8E9fr+xSk77iXFRgaih2o6rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZmRfZVF5; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770340367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JPnsENJNlvmMUEplunXnoKZyWAIlu9yV3pp07k9kFr4=;
	b=ZmRfZVF5YLlTB6wYynMGFnQKwEvMoYinvqVkI96oqtz1e58yj5+hl6DoRD1Zq1D/5WRuLP
	7Ds6DkyC4r7fDTYTAWdtYiQXXc1Sv6ONrJq2R8044GhdQt0wDDpfttFwpY9DmkGoC2lBF4
	OUw2RVRCA69cTAQ3asHXqK8koIdZ2e0=
Date: Fri, 06 Feb 2026 01:12:38 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <b92c2a7c7bcdc02d49eb0c0d481f682bf5d10c76@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 01/26] KVM: SVM: Switch svm_copy_lbrs() to a macro
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <aYU87QeMg8_kTM-G@google.com>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
 <20260115011312.3675857-2-yosry.ahmed@linux.dev>
 <aYU87QeMg8_kTM-G@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70390-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B8222F8E4B
X-Rspamd-Action: no action

February 5, 2026 at 4:59 PM, "Sean Christopherson" <seanjc@google.com> wr=
ote:


>=20
>=20On Thu, Jan 15, 2026, Yosry Ahmed wrote:
>=20
>=20>=20
>=20> In preparation for using svm_copy_lbrs() with 'struct vmcb_save_are=
a'
> >  without a containing 'struct vmcb', and later even 'struct
> >  vmcb_save_area_cached', make it a macro. Pull the call to
> >  vmcb_mark_dirty() out to the callers.
> >=20=20
>=20>  Macros are generally not preferred compared to functions, mainly d=
ue to
> >  type-safety. However, in this case it seems like having a simple mac=
ro
> >  copying a few fields is better than copy-pasting the same 5 lines of
> >  code in different places.
> >=20=20
>=20>  On the bright side, pulling vmcb_mark_dirty() calls to the callers=
 makes
> >  it clear that in one case, vmcb_mark_dirty() was being called on VMC=
B12.
> >  It is not architecturally defined for the CPU to clear arbitrary cle=
an
> >  bits, and it is not needed, so drop that one call.
> >=20=20
>=20>  Technically fixes the non-architectural behavior of setting the di=
rty
> >  bit on VMCB12.
> >=20
>=20Stop. Bundling. Things. Together.
>=20
>=20/shakes fist angrily
>=20
>=20I was absolutely not expecting a patch titled "KVM: SVM: Switch svm_c=
opy_lbrs()
> to a macro" to end with a Fixes tag, and I was *really* not expecting i=
t to also
> be Cc'd for stable.
>=20
>=20At a glance, I genuinely can't tell if you added a Fixes to scope the=
 backport,
> or because of the dirty vmcb12 bits thing.
>=20
>=20First fix the dirty behavior (and probably tag it for stable to avoid=
 creating
> an unnecessary backport conflict), then in a separate patch macrofy the=
 helper.
> Yeah, checkpatch will "suggest" that the stable@ patch should have Fixe=
s, but
> for us humans, that's _useful_ information, because it says "hey you, t=
his is a
> dependency for an upcoming fix!". As written, I look at this patch and =
go "huh?".
> (and then I look at the next patch and it all makes sense).

I agree, but fixing the dirty behavior on its own requires open-coding th=
e function, then the following patch would change it to a macro and use i=
t again. I was trying to minimize the noise of moving code back and forth=
..

