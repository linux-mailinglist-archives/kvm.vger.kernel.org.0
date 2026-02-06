Return-Path: <kvm+bounces-70428-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGg/EJe2hWmOFgQAu9opvQ
	(envelope-from <kvm+bounces-70428-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:38:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BE0FC20C
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 541FE3085633
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 09:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B8135E55F;
	Fri,  6 Feb 2026 09:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="IKqXmmjA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CE43314DC;
	Fri,  6 Feb 2026 09:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770370505; cv=none; b=aSsgnogusYAv0srRiutv1ZhI69IhoZ4TpCffcFsSVUVl8K/XgyaECOZJSrrdKITY9D6uMlhtQCh3cVgPvNr3bXPWlnUerEqWX/KPFiPueiadVk4BBEjpNg2GPCNHDXHWor/C+sKMSj0lrLJpLz4Y0AWBPr7b90X2tzcLMdJ/Jeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770370505; c=relaxed/simple;
	bh=cTd4ZcRIlxzAR7VAX7hdLuWtn7wYj+0QoCosPgg79yE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=laSPQWyuYmMGUqTtEvjaBc0BLBttVNCuQUztoTpAn1PnLUGe7+B5kMuYM1d8qTX0HxPDix6GXkQth8UAIlVkuOi1BTV5c07M15VZ2BCcEf+dPY4JqMXq2PrfFu8CsbY/PwfjqQJ687s6l7LFb7vL8jZ1j/winR0GeJOhMEO3P4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=IKqXmmjA; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6169YIgE1015697
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 6 Feb 2026 01:34:18 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6169YIgE1015697
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770370459;
	bh=cTd4ZcRIlxzAR7VAX7hdLuWtn7wYj+0QoCosPgg79yE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=IKqXmmjAMFG9/XVjgvtNEWFsJYNvkYftVJIn1wZIGSt4NzA1svVe+g+kSBoZpAjmK
	 G9cB8fKytvfsi6OfFWTlWBthT1Cr2JP69/AhuraT/+8P1tPBw0BxafQV5CBYwphPwQ
	 gvXS471u7UZF3TB02RxSF9sdIFxnnou3YiLWm8GCDrMmC6TFyKp3eBQt6DvVZNWdVG
	 WHwZVd0HefV63Kay4yf9Xx5RggT71ILdpwe4FH3fqXHBMuct/8EuDcm2FPCKk27PzV
	 dfe1x0EaeqnCsOCFQRNliK87Uaak9HKH9XygM3YRBnFStLawJkTq5Yju+e9ODYX7Y/
	 tnvc22LqTfT8Q==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
From: Xin Li <xin@zytor.com>
In-Reply-To: <37d4fd07-02e4-4492-b5e0-3618208b5e5c@amd.com>
Date: Fri, 6 Feb 2026 01:34:08 -0800
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, bp@alien8.de, thomas.lendacky@amd.com,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, tglx@kernel.org,
        mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
        jon.grimm@amd.com, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <286D4C7E-EB26-4BBD-8E8A-F638E201983A@zytor.com>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <202602051859.vGTf24Nk-lkp@intel.com>
 <37d4fd07-02e4-4492-b5e0-3618208b5e5c@amd.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70428-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,zytor.com:mid,zytor.com:dkim,amd.com:email]
X-Rspamd-Queue-Id: B9BE0FC20C
X-Rspamd-Action: no action



> On Feb 5, 2026, at 7:31=E2=80=AFPM, Nikunj A. Dadhania =
<nikunj@amd.com> wrote:
>=20
> if (user_mode(regs))
> return user_exc_vmm_communication(regs, error_code);
> else
> return kernel_exc_vmm_communication(regs, error_code);

Please rewrite this piece of code, like how X86_TRAP_DB is handled =
today.

Should kernel #VC be handled at a higher level RSP? You can check FRED =
#DB settings.=

