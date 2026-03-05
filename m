Return-Path: <kvm+bounces-72790-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPElBlAfqWmg2QAAu9opvQ
	(envelope-from <kvm+bounces-72790-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 07:14:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D020B20B486
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 07:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0CA1230630CD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 06:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445142BE051;
	Thu,  5 Mar 2026 06:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="lED43wNG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D9F1D47B4;
	Thu,  5 Mar 2026 06:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772691200; cv=none; b=bf7S/PCg6ZpuQZA1R9OEa/9veoDzUwn7Q4p1gDSG2wgk6kqbeViIE5OHuwlk7LQdi+3r0BMTSELpVDp0g+ayR1DuqRjDvx5MPu/yfgEh4NuADmsZXTVKjmMzRCHerD0vy18AomLAqRQkydFpxlvOl7HTt0aKdLuK3S0cOB9Wb14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772691200; c=relaxed/simple;
	bh=ko7F95C/qNfEuKQ7fgpE6IoqafkSggugoMhxPZdpimc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=f9pqZ/HYN7+tFZp6P0bNx21SZwE5M9lFpTAR5kA3VE+uxJUo+yaChDL4ibg1VRzJvu7tpJrsQKpYML14BPVjgLYCebpjeRNq9T+MrYElNxUMVgwvi1ODWr/JP92edCHuxRghKBkWgs8YZhUVyDW6FHp4nX22v201EpsgPj9bRI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=lED43wNG; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6255uqoE2389035
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 4 Mar 2026 21:56:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6255uqoE2389035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772690215;
	bh=ko7F95C/qNfEuKQ7fgpE6IoqafkSggugoMhxPZdpimc=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=lED43wNG7PaOWoUEpDO8IcogseMsNgNxMXF7oXdhEK9RO4Tg3ummE/XQxc9Vv7SIZ
	 Flk94mMxOoBqcfigznNlwzZ4ysarTWAOQZqqGg4BLIkVmuAFTszwwUqbrauP6/eFba
	 yTQoNx0tyTjxUp1q6qgdYvDKAww1gjHZmNc9D5JMdsEx+PKTXjYp3shZuZ7a+KOmtc
	 C5wfznj0a7EXi09daEf7ZsRsAQL3jyCMzAKgUOjX38n/IQBTOeNFGebmhsaQX4GbgO
	 GYOwHBd4l6lZ23Yq+gSOJWBNNoGa40ebFNO8nM2/znl2YnycTVfBNogGyp2hu3yaHO
	 u/3WycfhKVI2g==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
From: Xin Li <xin@zytor.com>
In-Reply-To: <aajS9HFx5HabmCTq@google.com>
Date: Wed, 4 Mar 2026 21:56:42 -0800
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C5C396E6-0C34-4419-8F7A-F6EE07B2346C@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-9-xin@zytor.com> <aRQf1sQZ9Z3CTB8i@intel.com>
 <aajS9HFx5HabmCTq@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: D020B20B486
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72790-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:dkim,zytor.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:email]
X-Rspamd-Action: no action



> On Mar 4, 2026, at 4:48=E2=80=AFPM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
> On Wed, Nov 12, 2025, Chao Gao wrote:
>> On Sun, Oct 26, 2025 at 01:18:56PM -0700, Xin Li (Intel) wrote:
>>> From: Xin Li <xin3.li@intel.com>
>>>=20
>>> On a userspace MSR filter change, set FRED MSR intercepts.
>>>=20
>>> The eight FRED MSRs, MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
>>> MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
>>> passthrough, because each has a corresponding host and guest field
>>> in VMCS.
>>=20
>> Sean prefers to pass through MSRs only when there is a reason to do =
that rather
>> than just because it is free. My thinking is that RSPs and SSPs are =
per-task
>> and are context-switched frequently, so we need to pass through them. =
But I am
>> not sure if there is a reason for STKLVLS and CONFIG.
>=20
> There are VMCS fields, at which point intercepting and emulating is =
probably
> more work than just letting the guest access directly. :-/
>=20
> Ah, and there needs to be VMCS fields because presumably everything =
needs to be
> switch atomically, e.g. an NMI that arrives shortly after VM-Exit =
presumbably
> consumes STKLVLS and CONFIG.

Yes, first it is a correctness issue and I assumed it=E2=80=99s obvious =
(like we
need a valid IDT/GDT immediately after VM exit).

Anyway, Peter had given a much better write-up and I switched to it.=

