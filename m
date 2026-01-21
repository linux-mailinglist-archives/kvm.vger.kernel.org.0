Return-Path: <kvm+bounces-68762-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YO+tJTEhcWl8eQAAu9opvQ
	(envelope-from <kvm+bounces-68762-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:55:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 005F75B9EB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 483C46B03B1
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2E93D649F;
	Wed, 21 Jan 2026 18:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XzQLThmW"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05E934FF46;
	Wed, 21 Jan 2026 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020438; cv=none; b=U/ZlaUXmDo2ChuJKVp5A7A61NHq6eMNwE71Vy23l33N0/JoyjsReWtbV3uHCYAXjXxD/dPLdUbsIYEPhXjaeH2h+KvNwl/9s6JqsJTSIyh7rzNrrLmipnwVlNC5xEJzr1KDXZdUYjYKK3N2oB4JRqBQhTiU3uCa7VunFsst3aQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020438; c=relaxed/simple;
	bh=xkNYN7e0QmiNzmhzcBWIpm1m2P2e6DqjnhUwrcVxa+8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VUXKuNfhrm5LugE4OF+hF5GNHnOpLvmtZyqjYQxQw/HFw5icbTmBKt5ev2ZGj0AELn3VVFHkN+H6PLT+RjNnJg4ZcgMTEUe/KhriDNpnCNo6bvqXT119b+Ev11K8uRAxoK1fBwxAQfw0P/xQUfQWBQVXX68/r+JFaFzM1PGHvh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=XzQLThmW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([192.19.161.250])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60LIEVWX2101891
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 21 Jan 2026 10:14:31 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60LIEVWX2101891
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1769019274;
	bh=CNH/RQzTK8bkWoozF3TvyVay/h/F4umaV83zyChhLd8=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=XzQLThmWVwIspu95DeyZng8lVtSALOEuSvFkmsY1Fb+8wpg6XNCxn3523fJ8u5b0N
	 RSuIcbTNfLRL4iIkYgR2iboRnwhxPz/oXYYKO1VqyWSmOoi/u6A/4rjlwPoD5MlK02
	 vLEWXnsgMnfIMPnm8dKVJyyFrPRQ6j3lYBEI2UPqAm/EEa5dBVMgcbuZb58cJoTP+P
	 4buZ3Q+bgc2yPD7rYFtjiY4g/uVOYmwvOdp21Dg9MYpEXUaGznSUogWhl6NJCKTQZg
	 aIGJmZu1TD5t6DvgjyJ1EgXIvtYx4Q+JXCYq6yZF7SNBrWwbbVzQrmnZHYnJEonbTf
	 k3swtR7jWVUCg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
From: Xin Li <xin@zytor.com>
In-Reply-To: <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
Date: Wed, 21 Jan 2026 10:14:15 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F630202-905B-43D7-9DBF-6E4551BAF082@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
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
	DMARC_POLICY_ALLOW(0.00)[zytor.com,none];
	TAGGED_FROM(0.00)[bounces-68762-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[zytor.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCPT_COUNT_TWELVE(0.00)[19];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 005F75B9EB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



> On Jan 20, 2026, at 10:44=E2=80=AFPM, Binbin Wu =
<binbin.wu@linux.intel.com> wrote:
>=20
>> +#ifdef CONFIG_X86_64
>=20
> Nit:
>=20
> Is this needed?
>=20
> FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, =
this
> path is not reachable.
> There should be no compilation issue without #ifdef CONFIG_X86_64 / =
#endif.
>=20
> There are several similar patterns in this patch, using  #ifdef =
CONFIG_X86_64 /=20
> #endif or not seems not consistent. E.g. __vmx_vcpu_reset() and =
init_vmcs()
> doesn't check the config, but here does.


I tried removing all such #ifdef, and it turned out that I had to keep =
this
per the last round of build checks.

Anyway, I will do another build check on x86_32.


