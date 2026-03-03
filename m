Return-Path: <kvm+bounces-72506-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMQgB9qTpmnxRAAAu9opvQ
	(envelope-from <kvm+bounces-72506-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 08:55:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3EA1EA6BC
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 08:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 828EC30BC959
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 07:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB543845BF;
	Tue,  3 Mar 2026 07:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="6HBzGmeq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C31369204;
	Tue,  3 Mar 2026 07:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524175; cv=none; b=umLUE4/4QNRag+K1bnG9i+dF9aqXWyNK9cdoA27Iu0hoqXXrT7cHPHqvEFMQWbFhuW5zt+UYFt5YGX9oe1z+zCb4VR/1ErZKPXT6mOcBGBtRGwQgPKBwC6sTXm4FhutIxOS0hNSyGoQej/mDYrbAfws9MElHMkdzIL2NafW58Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524175; c=relaxed/simple;
	bh=IhbTdrB8XDplxMj7CfD3HgnaY9muWcde9nefe/qZE4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SrPbWh/91n+pDS9cbD5rTH7NEeTD/0HsL2oBQziCkeG4hG/VP0ff+z4OQ1ACTZV3sl5xHDxhcCETWS84t62m6FtK1zsySXUzgWs5BJDqHT4wjn7ahhKz4Fz7rFe+u1K9SvwPyEXuF9PnnTNyUw4yJZnC63anSsdx87kzvKtDoQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=6HBzGmeq; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1772524168; bh=IhbTdrB8XDplxMj7CfD3HgnaY9muWcde9nefe/qZE4M=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=6HBzGmeqxjTzgXrkKsk3R5jdVfDkH08kjhSVF2DufxQeGViVEWGVX8pKS2KcunL6N
	 6eq8ms5Ny4V5mcS18DPXBlP3Zvh579tRT7UnyRQ0LgPKc4gGAjSxM/ajge/+ZL6bMt
	 pTaJO1mgXZemHu/1pEOmAsFaZlMFUrXlaHjW4KCYFcO9Jj3mAteIKu7w96cbIBtVe7
	 OqGOxmUkFzAFvLjmt+vylwXW4Y/XJuWPWF6qnVEG9VedNc8yAIBKuqzIH97RIcwXDF
	 y/du6LtK7g1ii2djxEs2S/JqYAad0haVmXb7rg9FGc+Ux5kr1o/wFtLJYXwq3U0tgS
	 GOdJ6OICtiAIA==
Message-ID: <33736850-1bad-493c-9f54-e699316e58b3@thorondor.fr>
Date: Tue, 3 Mar 2026 08:49:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 1/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260302143626.289792-1-thomas.courrege@thorondor.fr>
 <20260302143626.289792-2-thomas.courrege@thorondor.fr>
 <45f3b7ec-6796-43a1-90c0-baf2d9b7e383@amd.com>
Content-Language: en-US
From: Thomas Courrege <thomas.courrege@thorondor.fr>
In-Reply-To: <45f3b7ec-6796-43a1-90c0-baf2d9b7e383@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C3EA1EA6BC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72506-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[thorondor.fr:dkim,thorondor.fr:email,thorondor.fr:mid]
X-Rspamd-Action: no action



On 02-03-2026 16:08, Tom Lendacky wrote:
> On 3/2/26 08:36, Thomas Courrege wrote:
>> Add support for retrieving the SEV-SNP attestation report via the
>> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
>> ioctl for SNP guests.
>>
>> Signed-off-by: Thomas Courrege <thomas.courrege@thorondor.fr>
> You're missing my Reviewed-by: from the v6 series. Unless there were
> some changes that need re-reviewing?
>
> Thanks,
> Tom

I wasn't sure i could just include it
There isn't any real change, but the old patch didn't apply after the
merge window

I'll gladly add it if there is a new patch without changes

Thanks,
Thomas

