Return-Path: <kvm+bounces-72798-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qD8zMNIyqWnM2wAAu9opvQ
	(envelope-from <kvm+bounces-72798-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:37:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 298F620CC97
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBC5430429B8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 07:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B78D3264E5;
	Thu,  5 Mar 2026 07:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WWHC4Tcr"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D10F3148A8;
	Thu,  5 Mar 2026 07:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772696259; cv=none; b=SpAMz+b2ap5YGYmE8tKuQ3xOX83NIxbulJ2Ht/yRq8djrPA7Cqn+/D7z2XBBvDWL4K/MGci6pirqnJ7pMcGvO2H0PD6Et2HSk6DqaBiLjx8s6mwGKyuYVvgC1eQrkWN9WA/jSMx6KmmkCMrLCQJkh8oDcmHirzEnUbMwIvslVmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772696259; c=relaxed/simple;
	bh=yKdPZRHtC4vsnb6bfrw9K3eHXDoGHRCqWFCpHzKSIoM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HuYoCJoWpcYHJCzvz8+DsVRT27+qO5vdJklVmS243QMos8gWzhcfyp+f9NeUaOcA06sXO5W2abgD4WZEZ6Z4BVbMjZdQ+UZH26fgI5UTxx5TZHUu78QhCw0VoZuZ0PDsZmtGejPZvkirHMCTufENNXer/yFbXcJ2QguAUImwJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WWHC4Tcr; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6257L65c2523977
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 4 Mar 2026 23:21:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6257L65c2523977
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772695268;
	bh=Ua9Xhs42ev8puz1YiP2KsxyYlLZtoIPUgEQtRJtAWIM=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=WWHC4Tcr1cMd274trpbLCcb+bVPiUOCGeKYVJjfFda1kozsNg3eAExZH9/jpYyEA8
	 P2Pfn2sJZWKjfadLwO9lEQlFDiJexUiRBCFCkNfnibB/fMc9ijqmNgTB1wqN95bS2/
	 mVmwqaicE7Go2xQqJ+ob++wQCP3q+JYq3oor72hp/+0+lWZB9beGfDFU+omQjn6tou
	 g0KweOXsvIqEeUuMSSBsMe6qIPLlFj072xtdmliqTfBeFQ6c3pM87yX3fFMY2d5Cpc
	 frfGxVdoPQInVHMKcoJXFScrgVw6v3txndBA2Vg1kvVOMWT4T8kwT9+FBH8uflnLm4
	 FdRacRp0kVVow==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v9 15/22] KVM: x86: Mark CR4.FRED as not reserved
From: Xin Li <xin@zytor.com>
In-Reply-To: <aajVJlU2Zg4Djqqz@google.com>
Date: Wed, 4 Mar 2026 23:20:56 -0800
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <263F364B-D516-40B3-B065-A5369BFB1A7F@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-16-xin@zytor.com> <aR1xNLrhqEWu+rmE@intel.com>
 <aajVJlU2Zg4Djqqz@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 298F620CC97
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72798-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:dkim,zytor.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action


>> 2. mk_cr_64() drops the high 32 bits of the new CR4 value. So, =
CR4.FRED is always
>>   dropped. This may need an update.
>=20
> Ugh, I didn't realize FRED broke into bits 63:32.  Yeah, that needs to =
be updated,
> and _that_ one is unique to the emulator.
>=20
> Unless Chao and I can't read code and are missing magic, KVM's =
virtualization of
> FRED is quite lacking.
>=20
> More importantly, I don't see *any* tests.  At a bare minimum, KVM's =
msrs_test
> needs to be updated too get coverage for userspace vs. guest accesses, =
save/restore
> needs to be covered (maybe nothing additional required?), and there =
need to be
> negative tests for things like leaving 64-bit mode with FRED=3D1.  We =
can probably
> get enough confidence in the "happy" paths just by running VMs, but =
even then I
> would ideally like to see tests for edge cases that are relatively =
rare when just
> running a VM.
>=20
> I'm straight up not going to look at new versions if there aren't =
tests.  Like
> CET before it, both Intel and AMD are pushing FRED and want to get it =
merged,
> yet no one is providing tests.  That's not going to fly this time, as =
I don't
> have the bandwidth to help write the number of testcases FRED =
warrants.


I must admit the issues Chao raised were a clear oversight on my part.


I wrote some basic functionality unit tests in kernel selftests, which =
were included in v1 and v2.

Later I started to create FRED tests in kvm-unit-tests and extended one =
nested test case to CET:

https://lore.kernel.org/kvm/aJ9DB12YVJEyDORD@intel.com/

I planned to send out these new kvm unit tests (not just FRED tests) =
after KVM FRED patch series gets merged.










