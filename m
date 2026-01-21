Return-Path: <kvm+bounces-68816-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KhFJMlVcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68816-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:40:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 421FD5EF44
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1C8538880DB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03611449ECD;
	Wed, 21 Jan 2026 22:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ZZAnYRBe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4851E1A3D;
	Wed, 21 Jan 2026 22:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769035133; cv=none; b=XinDZ9rKMQb50CGOF4G5DRHbLOhc81fzVZRROkykEkjE2nNZD1oyUPdU9/2D9bwHlWYX8Csp9g7C4Blr+DN4rx10qVNtvO3lgpuSi1xVI6ziPgOybbhfCbksytzXN/H4SLi2pMSZrSaSKESnYo2X5QPN/ZTIRzwVIJOF6F1ozb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769035133; c=relaxed/simple;
	bh=DBsMI6rQ3ky0FVEwlZKgEb03zQLONH02QtF/0wjjicQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=a9DYvZqP9QCGQxwUXw4gAO72R8BY+Pe1ZLE2bgNg6UDJgwh2i6sY4WR1eqPBqreXLwyuMa4emMacH4Ai/hvGZ/dQM/i9zreOoweAH1fKdmV3cII/KniHvKm7tfXuLcC8X2Dj+725Z7D/glzl+Z9j2zEVmSB3FrWlwGolaFaWSqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ZZAnYRBe; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60LMcAuK2447958
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 21 Jan 2026 14:38:11 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60LMcAuK2447958
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1769035092;
	bh=DBsMI6rQ3ky0FVEwlZKgEb03zQLONH02QtF/0wjjicQ=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=ZZAnYRBeYqmKDTLQ7+Lc18LXNWTj8oDUJG6oHU3oY1QH/LQDoEmWo+l3f2zABwuNf
	 vHogq2EGMURgNAb89mPtNHVDPKrjjlaD5zG60U+AeHoCcckebwwtRUaF8mKfdvrIVe
	 TNPRJwO+9yMGP8wXT038+8yPy3EyuvxQfJ1y7b0wKpL+s9PfyTgIhkgfpRxNYlRSsc
	 O8kM/qw7N4h4nUwBq/mm6ikwklpT5RzNQemi4FB+FYP/YaorDdDPZHP1oebRpmUCFG
	 mMButhQwgcjvAzhjc46NShR4+v6vzcUmklC109PiFORDGFm2ZQ2PjhYgPWnwqQd2oq
	 9cqOT0uha3peQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 11/22] KVM: x86: Add a helper to detect if FRED is
 enabled for a vCPU
From: Xin Li <xin@zytor.com>
In-Reply-To: <aXE2BPCKvcIiQbqU@google.com>
Date: Wed, 21 Jan 2026 14:38:00 -0800
Cc: Binbin Wu <binbin.wu@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CD8A1085-1450-480C-B6F9-F0DF5BD9B95F@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-12-xin@zytor.com>
 <9a628729-1b4f-4982-a3e6-b9269c91b3c2@linux.intel.com>
 <BEB86711-AE1D-4438-8278-229275493134@zytor.com>
 <aXE2BPCKvcIiQbqU@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2025122301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68816-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[zytor.com,none];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,zytor.com:mid,zytor.com:dkim,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 421FD5EF44
X-Rspamd-Action: no action


> On Jan 21, 2026, at 12:24=E2=80=AFPM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
> Subject: [PATCH 13/28] KVM: x86: Add a helper to detect if FRED is =
enabled for
> a vCPU
>=20
> Add is_fred_enabled() to detect if FRED is enabled on a vCPU.

Yeah, you won ;)

>=20
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>



