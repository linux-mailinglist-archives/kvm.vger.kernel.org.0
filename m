Return-Path: <kvm+bounces-68634-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNnMCfjGb2myMQAAu9opvQ
	(envelope-from <kvm+bounces-68634-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:18:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A678D494F7
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5F1914EE056
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 17:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665DE33C1AA;
	Tue, 20 Jan 2026 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="S1CjESig"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D8032C33D;
	Tue, 20 Jan 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931969; cv=none; b=r+1Vbcd+cSl4tZW6E055w9vgApIGo+DH8JuW4RqxTP2EsHeU/G0Oe0p3s1hTmj1t8zJTSkW4bdv7h3okv6TseQVgT6PnLFR1v1GKPTKPmF9KJQ3DFKqLby1r+VeGojgfYHmNpoqk/9V4syl143UIqhd+mueDHX2ToUSUviNlT9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931969; c=relaxed/simple;
	bh=Z3vMuRF1OK9ofc9Kb9lrW4c+DbGca3aIeiMZIbiiwB8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=deZw919Ll3anQWl7Oi8sDQ58ikBg6iUPBV+keC6P22rvB1+y8HyyhrLrDmtS9MSSm5hwANB2cWr+s49BK9ewYTnvpe3uAhdp/DQ9SPrmDG0aUkI4TnmCMGntHNrTsc3qvL0g2B/BP5/qCcLuzEHTfwGsUGwaiChzMHr0ftaKHo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=S1CjESig; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60KHwoOO3814042
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 20 Jan 2026 09:58:50 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60KHwoOO3814042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768931932;
	bh=Z3vMuRF1OK9ofc9Kb9lrW4c+DbGca3aIeiMZIbiiwB8=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=S1CjESige/1NJ92fjRB1BdUzyGmaPSBcDiQ61RBukHJMHpOSPytI5qiVOrl2ARZxZ
	 /W4/Fi00bS58Txm7txN/6dAgAvinCYdXrr7+Zgq6NcnKBQWmVljSZ230ku5PExdJjt
	 7CqFj+xX1L8UQ8JUscC39Fcf7Oz1ZfDU/3tFsIjTgEz69qNuoGMwpmUEa7jLNi9YvF
	 rqE2rOBpTq+CO4GMmk+z3YUXFcFlEjPvAPYyeGt8lquFwAWQY4743ucA/F+EUaP3JM
	 nh0NF9vicVZVfyFBTdNM2sAgNRS7MnPsvYHFGKQAQGliYKwmEEaH16lji8CeDmolqh
	 3ykHgAekmf+Iw==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
From: Xin Li <xin@zytor.com>
In-Reply-To: <04d96812-f74a-4f43-9ea4-c4f2723251c5@linux.intel.com>
Date: Tue, 20 Jan 2026 09:58:40 -0800
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6C0D514-BCE0-4ADD-9110-3FC7A2E813F8@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com> <aRQ3ngRvif/0QRTC@intel.com>
 <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com> <aW83vbC2KB6CZDvl@intel.com>
 <C3F658E2-BB0D-4461-8412-F4BC5BCB2298@zytor.com>
 <04d96812-f74a-4f43-9ea4-c4f2723251c5@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2025122301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68634-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[zytor.com,none];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,zytor.com:mid,zytor.com:dkim]
X-Rspamd-Queue-Id: A678D494F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

>>>=20
>>> In this case, we need to clear FRED for AMD.
>>>=20
>>> The concern is that before AMD's FRED KVM support is implemented, =
FRED will be
>>> exposed to userspace on AMD FRED-capable hardware. This may cause =
issues.
>>=20
>> Hmm, I think it=E2=80=99s Qemu does that.
>>=20
>> We have 2 filters, one in Qemu and one in KVM, only both are set a =
feature is enabled.
>>=20
>> What I have missed?
>=20
> If a newer QEMU (with AMD's FRED support patch) + an older KVM =
(without AMD's
> FRED support, but KVM advertises it), it may cause issues.
>=20
> I guess it's no safety issue for host though, AMD should also require =
some
> control bit(s) to be set to allow guests to use the feature.
>=20
> I agree with Chao that it should be cleared for AMD before AMD's FRED =
KVM
> support is implemented.


Damn, I somehow thought the host won=E2=80=99t report FRED on AMD...=

