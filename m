Return-Path: <kvm+bounces-68924-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uI5XGxdmcmmrjwAAu9opvQ
	(envelope-from <kvm+bounces-68924-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:01:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D25A36BE07
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 99B7F30078CE
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1F133D6F6;
	Thu, 22 Jan 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="BZ6uwuH5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562553624DD;
	Thu, 22 Jan 2026 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769104881; cv=none; b=VZd6w/1+3QDHlgRxCg2IA7Xn3UMN4yzCIc8oEp0bAGe9I6OY1KL6xKWtquCQnWissuUf2bbCLYNyPHS92TS89Kxwy5RsuWzKjZxKeWvigyKgOTGQIYfZHppxj2YJeq4yqKfvemvYu7MRauwId2IZXKHVYRVPn8Sot4xLd7iXc8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769104881; c=relaxed/simple;
	bh=bHqoE0YcdoZpbvR6YrAEbo499n+yiKtZFm2WglH44L8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=gnpvt5BPsBoDirZynwggwDf79fj0ajOqVIR028BKXcDImlFA3mtKLsSXV1lCfhABY10MkfrhKBGM5wVTRP5wVLcNvrX4tz2s7qNdGGR/C4HtMedYTrx+cmfqoT/YoHbuFtiNoNvEF4FATrST6ooFR56egddLZ/xnmITyT0b15Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=BZ6uwuH5; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60MHvs0Y3527047
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 22 Jan 2026 09:57:55 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60MHvs0Y3527047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1769104676;
	bh=seLKPBdrljPR4UDaZaQOYumoRFOXXF/nQYSI9x8QdZI=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=BZ6uwuH5/US/mhnsa3WtQSYZ8DyxW7YBCQKKzFIiNyr7JQh+nb30nOtWnOYbU7mWG
	 eGdoR2/YNiXtDfZVFue2AQ+vzfZ8sF0Eazspc//rfF7SujmaIzGNe4T2zC7nMQz7lM
	 Z9DGT3pO3ip60eae1ZhijQ/IxvFtQ0oT1WBw10hy0k8zGuj7hIQ+ahRyQDop84IFmE
	 +TbUcuCQF76pxbugu1dYw3FglenbuZrn6xqwO8IJlEjSaYhYzOaVVCDAWF/bGTfUWh
	 sg0uvRc1MVKPmHN6FIYBLPlEw6kRcbh+KonWsNbyFXXYhB44CkJEQMwg1OK7WcVMGN
	 I+wSZIGH6wasQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 02/22] KVM: VMX: Initialize VM entry/exit FRED controls
 in vmcs_config
From: Xin Li <xin@zytor.com>
In-Reply-To: <81bb8149-45c7-472a-a240-46d43bd33b5d@linux.intel.com>
Date: Thu, 22 Jan 2026 09:57:44 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4FCC46DA-37E6-4C0A-ABDF-D1278502732C@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-3-xin@zytor.com>
 <81bb8149-45c7-472a-a240-46d43bd33b5d@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2025122301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68924-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,zytor.com:mid,zytor.com:dkim,intel.com:email]
X-Rspamd-Queue-Id: D25A36BE07
X-Rspamd-Action: no action



> On Jan 20, 2026, at 1:24=E2=80=AFAM, Binbin Wu =
<binbin.wu@linux.intel.com> wrote:
>=20
>>=20
>> Setup VM entry/exit FRED controls in the global vmcs_config for =
proper
>> FRED VMCS fields management:
>>  1) load guest FRED state upon VM entry.
>>  2) save guest FRED state during VM exit.
>>  3) load host FRED state during VM exit.
>>=20
>=20
> Nit:
> I think it's worth noting that IA32_FRED_RSP0 and IA32_FRED_SSP0 are =
treated
> differently. The change log might need more context on which MSRs are
> atomically switched in order to describe that though.

I deliberately omitted this point, as I felt that mentioning special =
cases
would be a distraction within a patch intended for the common framework.

In the overall patch series, this particular patch is like initially =
claiming
FRED simplifies virtualization state management, only to introduce =
complexities
in subsequent patches.=

