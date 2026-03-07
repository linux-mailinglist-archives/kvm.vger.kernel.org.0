Return-Path: <kvm+bounces-73221-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4ChgBReVq2k5egEAu9opvQ
	(envelope-from <kvm+bounces-73221-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 04:01:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 143EF229B73
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 04:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A36163021451
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 03:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C161428A3FA;
	Sat,  7 Mar 2026 03:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="f0ZZFo74"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA418287E;
	Sat,  7 Mar 2026 03:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772852487; cv=none; b=M49xWOvpFWY1ITSTYPsg/MfUNV5/QzBl0ZgowtrcPThUGieuYkTvlyxLJc021eDTKb+jAKGYIKqjKZv8r9PCPUm/haQXy+wO3uLRDy3F4RLRZJOpmTlLBy5q0CGGmKPn6Mz1Xl7pUL6BdGKYzw4tkeoPu1UvNH3yfKTg1TNZib8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772852487; c=relaxed/simple;
	bh=leEmfI7wf5aP5vv1HAijwEvKw4E5sOOWzhu790o1rGQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=K+AMDQIR7OZQDQj5Vn29naBPv9ibnvc6dKVZ7K62FELa0pQpGyprDYgG1MLk5tfFvOtOYYpKBtlwkDYhVmBr3P99POPwY8Z3cGM0AROocO/KyZyvjvQ+WmlAyrbSSR2pzWFCxAojV1DgpVMfOvurZoXAPPSP5ksTyNSMM0Fuiko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=f0ZZFo74; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 62730QQ12586312
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 6 Mar 2026 19:00:26 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 62730QQ12586312
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772852428;
	bh=QBHttWEcOd9CsFf4fWMdGGKljMFFqGLzRplj0cwrQdM=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=f0ZZFo74i3S54L1IYnShFjd5B9VZVuTjc0zTrQDnM2zLAhZb1WVofvbSKi/CMIokE
	 vC4LOw5qEOMsD3w2kpkUsF6k9fMEiUGYOFtJfmiqimqCHK8SE813sHDq/w/tZVwX8K
	 2tE5GN+pohKLtDFhZtfSsPv9EtmHDQaoPGHEG1z76XAPd+1OdTkwgHZ4zbYG0ewCjM
	 wFUiVDLma2To2ZtaXBcIi6N/WyDYbRuw1+s/F0Xy3nLksn1HfQhvreoyCNjmVFxOW7
	 mCpwXaQn4/uouzioWg+goxi7ZNeNCh6TPcxE+/oj+25ZMy8Ai+1Zo5KIcUsYbh+YBS
	 ZZstkd4GZl7XQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v7 16/21] KVM: x86: Advertise support for FRED
From: Xin Li <xin@zytor.com>
In-Reply-To: <aauKQSACQXFYvCCH@google.com>
Date: Fri, 6 Mar 2026 19:00:15 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2FAFAC32-AD3A-4D69-BE78-00A9BC570311@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
 <20250829153149.2871901-17-xin@zytor.com> <aauKQSACQXFYvCCH@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 143EF229B73
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73221-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.938];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action


> On Mar 6, 2026, at 6:15=E2=80=AFPM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
>> Advertise support for FRED to userspace after changes required to =
enable
>> FRED in a KVM guest are in place.
>=20
> Mostly a note to myself, if VMX and SVM land separately, we need to do =
the same
> thing we did for CET and explicitly clear FRED in svm_set_cpu_caps().  =
But ideally
> this would just be the last patch after both VMX and SVM support are =
in place.


This reply is to v7.

Chao, Binbin, and you *all* asked me to make the change:

https://lore.kernel.org/lkml/aRQ3ngRvif%2F0QRTC@intel.com/


Yes, I have done it in v10.

I will post v10 after I clean up and post FRED kvm-unit-tests.




