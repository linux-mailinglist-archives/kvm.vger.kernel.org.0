Return-Path: <kvm+bounces-73222-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLzkI+WZq2nYegEAu9opvQ
	(envelope-from <kvm+bounces-73222-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 04:22:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19242229D43
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 04:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29C6F3028367
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 03:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776CF309DC4;
	Sat,  7 Mar 2026 03:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WwmfJOVX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5C11E7C23;
	Sat,  7 Mar 2026 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772853715; cv=none; b=MT4Qd7Lf2BmBdwx52pPimkZhGkUOpZMB5svvCPHp7L3E7LAAQ74DtKK7gZNxlDIi2l/LNnhuWKZ9x0JX4g+HaPUiwg9kNfMSV7IgJmgN5MIOFnX1Wg31ftPw3Sy3QLQ/4xGPaCMe+M7s3OrWce/fmUIv/mzJ69IDZX+yj4kZO8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772853715; c=relaxed/simple;
	bh=UuKtYQLEpbZzXF4D203RAUfvz14kMMGl6TPKP4QK4eA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lFfTZbbFkSjNKX0m1aOA0m5VDK/GP61/ZYzKsmP1n0oZ5mH4K5vzSRNDmq2tBWpDcRuznBoIVKXFNl7Kv/Q+G9qCmG1TNq/QBlv+CwC0CY3DiCZGCJYjJUVnMwj/24aixBT4gfDlVrdKtKANqZvYwbjWrxabBpjM9U6UJKXIaQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WwmfJOVX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 62735SVf2594941
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 6 Mar 2026 19:05:28 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 62735SVf2594941
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772852729;
	bh=Lg/cqXkxdh6j/9Vx7MayeK1i/ddSevoVsnuXd/tRki0=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=WwmfJOVXBs7PcVo13W3mUkrnrMY3knNv49gmfvuKuu3h+4GTZrIqjTjySTUWjhqBk
	 3Ux2WInQ2riniuOpqEOnI5L/79IqMJd9rqhjSryUDIrn6HuWRLQhqm4+z/dgdpxZiV
	 5FxvzK8Mezwc2y7vg2I19qDEBgluB0RDMj9NPdQqh9oYSPSZnsUXrC6S2FnGCR27Q3
	 71bIdKHir94r9zRq1qPEPFJgp4epnt1OpS/qT/Ah33wRQSRarsA7uXwqJ9fonIiDI1
	 VJp8gQxYHpW5wqX5vmrzeD8+Q2MDCCC18ylRgTPXhj+NC6vYUVC9LIodm89X+FFjuJ
	 86OWLdG6OQRmg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v9 13/22] KVM: VMX: Virtualize FRED nested exception
 tracking
From: Xin Li <xin@zytor.com>
In-Reply-To: <aauIT-6fK5Jl2Ig6@google.com>
Date: Fri, 6 Mar 2026 19:05:18 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6F155DA-70F1-4DC3-8317-ED40ABCA05E5@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-14-xin@zytor.com> <aauIT-6fK5Jl2Ig6@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 19242229D43
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73222-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.915];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:dkim,zytor.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action



> On Mar 6, 2026, at 6:07=E2=80=AFPM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
>> @@ -2231,7 +2232,8 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, =
unsigned nr);
>> void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 =
error_code);
>> void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, =
unsigned long payload);
>> void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
>> -    bool has_error_code, u32 error_code, u64 event_data);
>> +    bool has_error_code, u32 error_code, bool nested,
>=20
> I think we should pick a different name, as both VMX and SVM declare =
"nested" as
> a global boolean.  I.e. this creates some nasty variable shadowing.
>=20
> Maybe is_nested?

is_nested looks good to me.

I thought about is_nested_exp, however the function names already =
contain
=E2=80=9Cexception=E2=80=9D, no point to duplicate it.=

