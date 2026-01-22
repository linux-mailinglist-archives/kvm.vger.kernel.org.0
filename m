Return-Path: <kvm+bounces-68917-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QD/0DhhicmnfjQAAu9opvQ
	(envelope-from <kvm+bounces-68917-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:44:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4D36B964
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E66E230DFC3C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD5137F0E2;
	Thu, 22 Jan 2026 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ViCW05cA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0702D366DDF;
	Thu, 22 Jan 2026 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100877; cv=none; b=bHFyFG1mrv07ya6LlVJirSGkl0uu8rVEpvOpjNe3DdFrYj8y70NdT5izapD3RyOTOJ5XqkVDLCN1yIsgZq3qtN1IPOy5s8etk2fV34xzTq4wkmbx9Sl9ZFVYJzh0SjFeFJ7QBXcyFsC8ckOLeI8lhJIfnmnp4F0cCAUpelcMXjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100877; c=relaxed/simple;
	bh=M3xQnllR1Ou9undvhQ8Lxwhil7zlh1PTX5k6L28WWfs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LOruyuS2QlLH4IkBNeBupEH4DiKdiS3/X05Z1zgdH+keg5JIw5CY7tQOeZGfeOQHxNtHq/9krdGERpnkSzEsi7BhFHChlbB4fk00h2dmL2APXM9iv/qyYts3bkTqWwe6C2hnwLh3uR7cxCuCYY510FMuFkhSW9q9jpRBtz6QJ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ViCW05cA; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60MGr3NU3486370
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 22 Jan 2026 08:53:04 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60MGr3NU3486370
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1769100785;
	bh=d5l/s+oZlqvzBGKky4VUOo8YFrSIzPgbmEUSpVddry8=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=ViCW05cAFAJFM47EFktir5lN2aGYn7wzcMhPG0YmDK89KJDN63eUhDw4JAKCHFLn4
	 laUeSvqiMYjZhbReMyrQAkx5V70edpxiqkgoGkHl/HO206fbux8/HlUv/xL5dQJTtL
	 itW0wQ6qHXOfo3IYGF2ovjePf4iqkzX/jTOxoT2REkF7hqvTn36PUYu/DlNQXzEG4F
	 +stuNwTZ2EAuceTNWjPs7TZco/3KUmsteLTRtmULGlZ4zuyvo+ZxDA40nGgF46MZS8
	 GR4yryvx+NyHdbuz1eVrdUif0d2zmIuEn4wa1VVgtszgiruyXD1TLLHD4HmogOHCk3
	 CMQhHX6JCyZtw==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 19/22] KVM: nVMX: Handle FRED VMCS fields in nested VMX
 context
From: Xin Li <xin@zytor.com>
In-Reply-To: <aXAhf+ueMAOkiZrf@intel.com>
Date: Thu, 22 Jan 2026 08:52:53 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <88469A8C-CC32-449B-8255-239CAAD6DB91@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-20-xin@zytor.com> <aS6H/vIdKA/rLOxu@intel.com>
 <3F71014C-5692-4180-BC6B-CCD7D2A827BB@zytor.com> <aXAhf+ueMAOkiZrf@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2025122301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68917-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:mid,zytor.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB4D36B964
X-Rspamd-Action: no action


>>>> + nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, =
msr_bitmap_l0,
>>>> +  MSR_IA32_FRED_RSP0, MSR_TYPE_RW);
>>>=20
>>> Why is only this specific MSR handled? What about other FRED MSRs?
>>=20
>> Peter just gave a good explanation:
>>=20
>> =
https://lore.kernel.org/lkml/f0768546-a767-4d74-956e-b40128272a09@zytor.co=
m/
>=20
> Do you need to set up vmcs02's MSR bitmap for other FRED MSRs?
>=20
> Other FRED MSRs are passed through to L1 guests in patch 8. Is there =
any
> concern about passing through them to L2 guests?
>=20

Hmm, this caught me.  Yes, I need to do the same to other FRED MSRs.





