Return-Path: <kvm+bounces-69741-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHefOTDffGmpPAIAu9opvQ
	(envelope-from <kvm+bounces-69741-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:41:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BD2BC95C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 17:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4450A301916E
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95503350A15;
	Fri, 30 Jan 2026 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="FE5fEpYs"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B513191A7;
	Fri, 30 Jan 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769791253; cv=none; b=Wzh+cvIv42JQ4/UmnDZDVUYL0F9MkEWi72qyPJZZDM1fK5lZeywWUiB22Jil/l9PFBI/obGUgPfvyd+shF9wvtPN274G+FH7Fw6k0KRAt09xHhzJDgKFY/YJ0e+5JjkK1X1kWPg7q995OhGpShzPMXd4gRnfZ6B9GHFwRNeUzRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769791253; c=relaxed/simple;
	bh=vpJXD317knBCL/SE4Ub7u6OeUY6pLWubZxsDRe2QciM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sbpzebKGnkE1shITI/yYfp1qUrcwqiE6yUYxc7eDhmiT12DidyQ1FH7E6ahE7ZhrOUVHv4KBvjfRv/VRxjGxgzyednjxbovwRxHm6+OA8L4Gyv8ehI0H40MceYQMIuOd5PMZeJoUGTBl403Rvcqo6WkkLEuQHh00/cr4MrlCicE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=FE5fEpYs; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60UGa0Uu1292331
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 30 Jan 2026 08:36:00 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60UGa0Uu1292331
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1769790962;
	bh=vpJXD317knBCL/SE4Ub7u6OeUY6pLWubZxsDRe2QciM=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=FE5fEpYs1PMDcN61m8J1kS58+tcQ7XY81Pqs69dbYHPuRLaEOjWvVKkvVWINsQR/I
	 UbgdY49ccJlwpNaG+bvlE2QlFRvZBdaUZVlmy+TMp/QenUe2bTP3DUeUk1E6TRSNKj
	 CLieYd77BDxdgYrW5ojqmHwVspMULemQBTlpvpTb2RQNm6DZtC8x4LQQRJ58tWGhhp
	 c2FKqFUhuuSAqOAvKKzKn2Omr0l3+PHwJ1xQPpEklM+KFUyot/YPUKoZQ9uIHzh5zQ
	 n2wXZcfpr/HPymDaY9DC6yfIPo8ZRy+IcCs5L5XX1Bc15CrDpLydkBwpkvYb5AxZ0T
	 wZFex+CmbWDoA==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 06/22] x86/cea: Export __this_cpu_ist_top_va() to KVM
From: Xin Li <xin@zytor.com>
In-Reply-To: <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local>
Date: Fri, 30 Jan 2026 08:35:50 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <78858200-FE67-491E-89C6-5906233C860D@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-7-xin@zytor.com>
 <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local>
To: Borislav Petkov <bp@alien8.de>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69741-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 89BD2BC95C
X-Rspamd-Action: no action



> On Jan 30, 2026, at 5:46=E2=80=AFAM, Borislav Petkov <bp@alien8.de> =
wrote:
>=20
> On Sun, Oct 26, 2025 at 01:18:54PM -0700, Xin Li (Intel) wrote:
>> @@ -36,6 +41,7 @@ noinstr unsigned long __this_cpu_ist_top_va(enum =
exception_stack_ordering stack)
>> {
>> return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
>> }
>> +EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_va, "kvm-intel");
>=20
> Why is this function name still kept with the "__" prefix but it is =
being
> exported at the same time?
>=20
> It looks to me like we're exporting the wrong thing as the "__" kinda =
says it
> is an internal helper.
>=20
> Just drop the prefix and call it something more sensible please. The =
caller
> couldn't care less about "ist_top_va".

Right, the =E2=80=9C__=E2=80=9D prefix no longer makes sense.

What is the right order of rename and refactor?

I think we usually do renames in the first patch and then refactor in a =
following patch.=

