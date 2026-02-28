Return-Path: <kvm+bounces-72255-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IrGFCk6omk71AQAu9opvQ
	(envelope-from <kvm+bounces-72255-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:43:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E11C01BF76C
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 324AD30637C0
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81542638BA;
	Sat, 28 Feb 2026 00:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwGhZ2Sd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298212AD0C;
	Sat, 28 Feb 2026 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772239398; cv=none; b=A3HqkV4K/IXzp70Vgjzq7HlYvvYbX97jTwGkQjpzrwiw2ajf3EOUyUOx1EUa4GXGrVulKiMbMM5iVlZQni8VOSiP9GSP7+a52tx6++TmKl66HM7yQy9HTMg1tE2a7m4+hllHT3RwajaCWHbn+Z67fVRRt6hRxoKQRIkKZeK2wqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772239398; c=relaxed/simple;
	bh=vsMWzFCxiOCbQVDHTJcZgFfJP7228IBOp6FC3sLSBYM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=BoXw2M8Nge6WHYTsgsTDQoQZo5+rzYdZxzpyk/CX3uRNvtjFItngX2ho+9Vpvf+m4l/YeAb288DFaOJ3Tqp/uHYwqP+F3kCio+W67VKCb4iqPqYeoen31J/disdfSIUOPzjQXl8pxglsoQUCRfFNBtFxixubmq8xNnTkYRBieI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwGhZ2Sd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB25C2BC86;
	Sat, 28 Feb 2026 00:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772239397;
	bh=vsMWzFCxiOCbQVDHTJcZgFfJP7228IBOp6FC3sLSBYM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=NwGhZ2SdgAq502VzLVdU+BUPSqb48HHG4zyVNCkwAY+sNzgKFOgJS+xSG1myaj5pE
	 1+JUKOIW1OOQuRspID80JeDG2PIPGru9ltHbBZ1o/OrT0tXIVBlq5TgfkDqC5TrX/r
	 +r9XscdE71gY8cJAnK1AJVaV8PcO8t/Y+0QWveE38DIzQkF078weAmW5cnV9n64R/B
	 Qwzkg8jONc3nDDDs6pT/feds+jxN+AFIEitWm8K0na7Ke0bb818dblDb+4JnNDkKtN
	 /9OyqoB83E5WS+2J1j9OzEaQSmDwWgilMftucxctBgQRwD9SWmGZfCA4aeErNP5UOl
	 vmvwbDA/t9lew==
Date: Fri, 27 Feb 2026 16:43:16 -0800
From: Kees Cook <kees@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
CC: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, daniel@iogearbox.net,
 gustavoars@kernel.org, jgg@ziepe.ca, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_KVM=3A_x86=3A_Fix_C++_user_API_f?=
 =?US-ASCII?Q?or_structures_with_variable_length_arrays?=
User-Agent: K-9 Mail for Android
In-Reply-To: <718cbe24ffb546b97db8af94521da067d7437d70.camel@infradead.org>
References: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org> <da02314c-e6da-4d9e-a2c8-cd3ee096bc0c@embeddedor.com> <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org> <202602261053.78753BF1C@keescook> <718cbe24ffb546b97db8af94521da067d7437d70.camel@infradead.org>
Message-ID: <948BD627-E51D-4959-9745-3AB390F04D0D@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.96 / 15.00];
	SUBJ_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72255-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kees@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E11C01BF76C
X-Rspamd-Action: no action



On February 27, 2026 12:29:11 AM PST, David Woodhouse <dwmw2@infradead=2Eo=
rg> wrote:
>On Thu, 2026-02-26 at 11:02 -0800, Kees Cook wrote:
>>=20
>> > Also put the header fields into a struct_group() to provide (in C) a
>> > separate struct (e=2Eg 'struct kvm_msrs_hdr') without the trailing VL=
A=2E
>>=20
>> Right, my only worry is if C++ would want those header structs too=2E I=
n
>> that case, you'd probably want to use a macro to include them (since no=
t
>> all compilers are supporting transparent struct members yet):
>>=20
>> #define __kvm_msrs_hdr	\
>> 	__u32 nmsrs; /* number of msrs in entries */	\
>> 	__u32 pad
>>=20
>> struct kvm_msrs_hdr {
>> 	__kvm_msrs_hdr;
>> };
>>=20
>> struct kvm_msrs {
>> 	__kvm_msrs_hdr;
>> 	__DECLARE_FLEX_ARRAY(struct kvm_msr_entry, entries);
>> };
>
>Hm, does the struct_group() not also depend on the compiler supporting
>anonymous struct members? Is there a distinction I'm missing?

Sorry, I should have been mor clear: the _tag_ that struct_group creates i=
sn't supported for all C++ compilers (so is commented out for C++) so if a =
C++ project wanted to use the struct by its tag ("struct kvm_msrs_hdr"), yo=
u'd need the construct I wrote above=2E

-Kees

--=20
Kees Cook

