Return-Path: <kvm+bounces-69639-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAGlK7nke2nBJAIAu9opvQ
	(envelope-from <kvm+bounces-69639-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:52:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 513EDB5888
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D776C303F7CB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6EF36C0BC;
	Thu, 29 Jan 2026 22:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bxXukKfa"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271EC36BCE3;
	Thu, 29 Jan 2026 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769727098; cv=none; b=kaFM/ioKMUQTUeVCKsID8lhwztKZ3LRWtams7iM7PGqVRbTqNM838mQbPtXQBJW8/rsyzhQREHFc3b74VeGr35MMblUY9WR2n2yuK62RVBDJbdjZ8tn+siNr+OcVmymCQVH/AAEfqID/eoYBLdxTUSNFbbmWSHh+pxQ7oEZ33RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769727098; c=relaxed/simple;
	bh=nGDvJD/CKc/+BlfQqsxsUNWAMykt9q15wyKWGTdDR1g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UTcvYPp9wgmLmLbfFwxJb2vX10tE41/5SSSl3fEjHGDGQ5zrRav82fxB9+MQkRLWF+PCqoYezbtK5YyXAMa5dKWnCEj1DJ6EF9Efu2tB+PE/+jxvgxsocz/rajjrBIyOZlU77H+OfXUPGFMoKx031ZgQwpGiVVlKkNXVE8XSDKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bxXukKfa; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60TMp1dr891091
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 29 Jan 2026 14:51:01 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60TMp1dr891091
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1769727063;
	bh=V35m3uJr+qtPItiMY5+oBFo6446F8J07UnVFcXTewF0=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=bxXukKfaep9E5ECw99NAnmWOLFR7SSJvfuslyC6if9quMiO/l55k0wBEqa5f9Lqar
	 p6TivolDQUhRlqTOpL1ZFuL0vWWhT8kivN1V9aGA1drT3VKyiNkfCXZ0SN8vycVAaF
	 AxrJ4wT/nZzmvvOlYXMBlx4GgCIMT/L/VLqOrLJaAFVPrcEEBec4fYVvA107oxpLk5
	 mK/0vmEgcs0toALsKWGMBLFZPptnL093L53D06VGeql5RcpsT/b5tTzJqzK8sfp4wj
	 7XpMt8SOeM79eiVPq8wAuLrYo9/AYbmj3xndsIpDpKYs7LmtX4MR0AsFc0+LA3kHFW
	 BTY3wASYz6PAQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 12/22] KVM: VMX: Virtualize FRED event_data
From: Xin Li <xin@zytor.com>
In-Reply-To: <1EA97017-82D2-4C43-B617-D39C68D7BC6F@zytor.com>
Date: Thu, 29 Jan 2026 14:50:51 -0800
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A7B34157-A5CA-430C-A459-E8E142951ECB@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-13-xin@zytor.com> <aR04V4VVg+p4RsdT@intel.com>
 <60C180BF-AD13-48EF-9BA8-CEACF57965EF@zytor.com>
 <1EA97017-82D2-4C43-B617-D39C68D7BC6F@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
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
	TAGGED_FROM(0.00)[bounces-69639-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:email,zytor.com:dkim,zytor.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 513EDB5888
X-Rspamd-Action: no action



> On Jan 29, 2026, at 9:21=E2=80=AFAM, H. Peter Anvin <hpa@zytor.com> =
wrote:
>=20
>> Just to confirm, you are referring to requeueing an original event
>> via vmx_complete_interrupts(), right?
>>=20
>> Regardless of whether FRED or IDT is in use, the event payload is =
delivered
>> into the appropriate guest state and then invalidated in
>> kvm_deliver_exception_payload():
>>=20
>>       1) CR2 for #PF
>>=20
>>       2) DR6 for #DB
>>=20
>>       3) guest_fpu.xfd_err for #NM (in handle_nm_fault_irqoff())
>>=20
>> We should be able to recover the FRED event data from there.
>>=20
>> Alternatively, we could drop the original event and allow the =
hardware to
>> regenerate it upon resuming the guest.  However, this breaks #DB =
delivery,
>> as debug exceptions sometimes are triggered post-instruction.
>>=20
>>=20
>> Sean, does it make sense to recover the FRED event data from guest =
CPU state?
>=20
> I think some bits in DR6 are "sticky", and so unless the guest has =
explicitly cleared DR6 the event data isn't necessarily derivable from =
DR6. However, the FRED event data for #DB is directly based on the data =
already reported by VTx (for exactly the same reason =E2=80=93 knowing =
what the *currently taken* trap represents.)

Yeah, it's important to keep in mind that DR6 bits are 'sticky'.

Regarding vmx_complete_interrupts(), when a VM migration occurs =
immediately
following a VM exit with a valid original event saved in the VMCS, we =
can
safely assume the guest DR6 state remains consistent with the original =
event
data because there is no chance for guest OS to modify DR6.





