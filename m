Return-Path: <kvm+bounces-72846-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJlUA/O4qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72846-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:10:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3745215E6D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C08523012530
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1F03E1219;
	Thu,  5 Mar 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="aM7XMe3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEF2215075;
	Thu,  5 Mar 2026 17:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730605; cv=none; b=dhMHDiplVXLQpbXOwO5o2QN2KS6Vb+hY20HeY4RnA4JzwzAj5E5AxOszxUTeZO74hWi8juxSLT8NZx4NK5Zp/YvRI7sCyWavA8Dh/UFG+oOmghnTaZLc6c68dHwBLyCC9asg7z9GnzBImLK5AMWN2BSyao4iRGpG+pAUy4q9u/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730605; c=relaxed/simple;
	bh=RfT0f7vWA2mrexhTtUJsQeiXxCqLubDPU4wLv5jwW1M=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=joOnADr4SIH/BjDiMB3IMGP4u8pXxRQIjXZggHxO5yJtYiDmQBvJosFCoktghCHJN7BTXudeuNIKjSO0l2Jpm53KzH2pLDiJi3mVAELwQCEJ4zST3lER0+jPjz/LkpZFksgNgejk1KjgkShOGlEptLoPElM9aqHd9G0NMkFUDR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=aM7XMe3Y; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 625H9J2E3494905
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 5 Mar 2026 09:09:19 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 625H9J2E3494905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772730560;
	bh=+1y5MvbjQL4jaYiB+MHx6KKMMG1bQpE5wCYGmarD9Uw=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=aM7XMe3Y1sDknDpx0TJimpHX98NwEYNxWVd4j87Ona8HCjHxe7L1Y4b6XVAX38GG8
	 dzFjxQGPCM+CAU9lUIfO+46rErEm9n62AdC5z6Sy0c+eLgSlI7tUzMcRTF9wylya58
	 xeMtJ5iDNklEFF+iYkqP4qsc0gUWS9qVLvAbjYGoGtVCgMHVVwIeOuGgH3PCUuYXvh
	 vdyXB75RCZ9CxLEEJvVq5UWV9aWA7Nu7tc29yBrjvArTZcI7MI9Rhp9QVTnu5P/zs8
	 gcWZua364pcUWcFdjvl5f/K9NEWyinOsouZquUlXAEa8Td449AmNuKgE/7WqmO/YOh
	 0mdE1R0cqFDxA==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v9 15/22] KVM: x86: Mark CR4.FRED as not reserved
From: Xin Li <xin@zytor.com>
In-Reply-To: <aamisPkG1JZ2UDdQ@google.com>
Date: Thu, 5 Mar 2026 09:09:08 -0800
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B07CDF1A-1FD2-4EC5-BEB3-3D906A880153@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-16-xin@zytor.com> <aR1xNLrhqEWu+rmE@intel.com>
 <aajVJlU2Zg4Djqqz@google.com>
 <263F364B-D516-40B3-B065-A5369BFB1A7F@zytor.com>
 <aamisPkG1JZ2UDdQ@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: A3745215E6D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72846-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,zytor.com:dkim,zytor.com:mid]
X-Rspamd-Action: no action


>> I planned to send out these new kvm unit tests (not just FRED tests) =
after
>> KVM FRED patch series gets merged.
>=20
> Definitely send them before.  Even if no one outside of Intel can run =
them (I
> forget when FRED hardware is coming), people like me can at least see =
what you're
> testing, which makes it more likely that we'll spot bugs.  E.g. in =
this case, the
> lack of negative tests for CR4.FRED is a big red flag.

No excuse, sadly mk_cr_64() completely escaped my notice.

And I didn=E2=80=99t even think about adding a CR4 test for FRED.

And as you expected, the happy path doesn=E2=80=99t expose it at all.


