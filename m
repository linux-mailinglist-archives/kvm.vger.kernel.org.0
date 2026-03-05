Return-Path: <kvm+bounces-72927-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBD2AELJqWkAFAEAu9opvQ
	(envelope-from <kvm+bounces-72927-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:19:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A684216EC0
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A7BA9302B23E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 18:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8633E8C5C;
	Thu,  5 Mar 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Hb8f9C6V"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C17D366078;
	Thu,  5 Mar 2026 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772734772; cv=none; b=nxoMywkqECt8TregZpgmujQMMPbMrg/rs2uVfTvS2R3lxS0rfl1hoGd83fNVu7f2wCDt5TXg+8dKtdxtBWcxDTvWb2z+vEbnpWMo/3XWE4BbxhCSpjpusklnd80/cUZV/Fum6px2/WZM04EjLHY1fYYt3+V/kNyF66hHuxTqIdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772734772; c=relaxed/simple;
	bh=4Tc/KAY0GBDAe9mAqjvKIM20YswWBDTUfMNyQxN460A=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=uNjeTbGxyqCYxTZb+S1Wf5sqftCsVEnH2jV9LPADx+Ivb2gSsSRqfzDmRXD2qBWNeCNXPOh/fPIlz56XFqKD3fshbk2MQmNa3QhQeNYrln+s7bvlzN+xmbLIoxT7Emx2AccucvdswYWq/NCh/R6JUXcvsfP/ONygVRrWZq0G41o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Hb8f9C6V; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 625Hl8vd3560389
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 5 Mar 2026 09:47:08 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 625Hl8vd3560389
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772732829;
	bh=CjTCnaKYWUbRJ1sgAvN35vorMdc+lmIlICQF5lNVu68=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=Hb8f9C6VdtZ+JuFRr/E/XJ8g+T8xD8ogv5ZAC7Cx0ZwoAyvSJRwBzTgW6FT/GdoU8
	 1LZFVQ6gEpD/jiGjfVJyzgrb09epiEGLNA/wQh/flrircnIxp1NQaUrHW9mp4LTOic
	 kKVgx8lyZMg5fjR+tJHgCqEh6ZwnxNQSbBdaMeVsfEpJB6aPjiJwiN/lL3NUuOX/BC
	 ql5Ki54WqYIrbRh6JEPJXdVhQvFsT12iDI70pNhceppAk2pnUNAALo6cPaDbWLn99z
	 qy6/ryv7dxsz6Mi0DF/Fr6/Goj/QE5pBEZJF0zyF7+uFIxdfiIaRBs51eTC+L083kn
	 w/1zy1Wq6z0SQ==
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
In-Reply-To: <B07CDF1A-1FD2-4EC5-BEB3-3D906A880153@zytor.com>
Date: Thu, 5 Mar 2026 09:46:58 -0800
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <237876C4-5253-4059-ABBC-3FB4EB5C2ABC@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-16-xin@zytor.com> <aR1xNLrhqEWu+rmE@intel.com>
 <aajVJlU2Zg4Djqqz@google.com>
 <263F364B-D516-40B3-B065-A5369BFB1A7F@zytor.com>
 <aamisPkG1JZ2UDdQ@google.com>
 <B07CDF1A-1FD2-4EC5-BEB3-3D906A880153@zytor.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 9A684216EC0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72927-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action



> On Mar 5, 2026, at 9:09=E2=80=AFAM, Xin Li <xin@zytor.com> wrote:
>=20
>=20
>>> I planned to send out these new kvm unit tests (not just FRED tests) =
after
>>> KVM FRED patch series gets merged.
>>=20
>> Definitely send them before.  Even if no one outside of Intel can run =
them (I
>> forget when FRED hardware is coming), people like me can at least see =
what you're
>> testing, which makes it more likely that we'll spot bugs.  E.g. in =
this case, the
>> lack of negative tests for CR4.FRED is a big red flag.
>=20
> No excuse, sadly mk_cr_64() completely escaped my notice.

BTW, mk_cr_64() looks a bad name to me, it=E2=80=99s more like =
mk_cr_32().

>=20
> And I didn=E2=80=99t even think about adding a CR4 test for FRED.
>=20
> And as you expected, the happy path doesn=E2=80=99t expose it at all.
>=20
>=20
>=20


