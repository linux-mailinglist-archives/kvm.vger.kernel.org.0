Return-Path: <kvm+bounces-71414-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cC3wCP6ZmGkTKAMAu9opvQ
	(envelope-from <kvm+bounces-71414-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:29:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 761F4169B34
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:29:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4367305C8C5
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844DB357A49;
	Fri, 20 Feb 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="V14mXAto"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C718B353ECA;
	Fri, 20 Feb 2026 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771608560; cv=none; b=M8PuT67MKhvge5jsraG5Ri92GWJeukXHyqHMDihb1toixUNlJPR1t5M234VEhWNaAWLd4DrkXEkSWck7LMD+cerOOOgrYx+m5/iT4a4LufNyS8bz4GCFcj8rOSibD1EPRrrxAuWVTPD+5JdMka/feU9ZFJERs+im4TpFnuCTR18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771608560; c=relaxed/simple;
	bh=9Cyby1P7/giVIIERMRfZ7Dh2BAfpxfst6Jgj546evcU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kcuT0wyId1YbKQw1Sut15kKLB3p4QqwP2DM9IbpHatQDacA0ec2Hj5tqrJI993TGSDiDEsK3fgFe1lz12SqJXeksQUSGwZhKSRTeLnclyMqepyxp87G29HpJgWn3b3V8F9LbnFdlgAUO41xU3UVoYSHhXqWh+ee99dNYBov5GsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=V14mXAto; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61KHCZiE2496145
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 20 Feb 2026 09:12:36 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61KHCZiE2496145
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1771607557;
	bh=z/HgO+bmDFlpHZlNXeji0TYgAT5VYkUBW8MaAeZESUQ=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=V14mXAtohX7ceGG36AKl4JvXUYSVb39PVaPFLBuYjPss/LXzYN4cTlCQZ1780OKkH
	 +uqnqUH5X55kvRhY9FZtdgMyRyOsa5UdrWbyB/DqjsFTA0fCRG5TwDCtj6XqPygzWj
	 5hpN0j5r3ce9XFxS7gtX5Ypyu9LdhIHVzk8rzvgt/596YcXOD6e2vjdAJhcXsaHJas
	 txyfwnAyquwdP0FNhM3G7uZSYQI9rQu6s+ZZn4oY1VpT1iPneK+4x1TGJqludhL4Fq
	 AMuoZbEGMWkyBtke8LNdys60MVT+FmnaOHG0xhzxn+sd+PJWoCIy9RGn71h15Nw53N
	 Fmxi6+8XgCoVQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v3 09/16] x86/msr: Use the alternatives mechanism for
 WRMSR
From: Xin Li <xin@zytor.com>
In-Reply-To: <d622a318-f7f8-4cff-b540-38d159ca87f4@suse.com>
Date: Fri, 20 Feb 2026 09:12:16 -0800
Cc: Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, llvm@lists.linux.dev,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <437EC937-24B7-4E69-B369-F9FAFC46F1B1@zytor.com>
References: <20260218082133.400602-1-jgross@suse.com>
 <20260218082133.400602-10-jgross@suse.com> <aZYoUE7CmrLg3SVe@google.com>
 <e05a65a7-bf8e-420b-8a36-2d76e56b43b0@intel.com>
 <d622a318-f7f8-4cff-b540-38d159ca87f4@suse.com>
To: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71414-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,google.com,vger.kernel.org,kernel.org,lists.linux.dev,zytor.com,redhat.com,alien8.de,linux.intel.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[zytor.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm,lkml];
	APPLE_MAILER_COMMON(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,zytor.com:mid,zytor.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: 761F4169B34
X-Rspamd-Action: no action


> On Feb 18, 2026, at 10:44=E2=80=AFPM, J=C3=BCrgen Gro=C3=9F =
<jgross@suse.com> wrote:
>=20
> On 18.02.26 22:37, Dave Hansen wrote:
>> On 2/18/26 13:00, Sean Christopherson wrote:
>>> On Wed, Feb 18, 2026, Juergen Gross wrote:
>>>> When available use one of the non-serializing WRMSR variants =
(WRMSRNS
>>>> with or without an immediate operand specifying the MSR register) =
in
>>>> __wrmsrq().
>>> Silently using a non-serializing version (or not) seems dangerous =
(not for KVM,
>>> but for the kernel at-large), unless the rule is going to be that =
MSR writes need
>>> to be treated as non-serializing by default.
>> Yeah, there's no way we can do this in general. It'll work for 99% of
>> the MSRs on 99% of the systems for a long time. Then the one new =
system
>> with WRMSRNS is going to have one hell of a heisenbug that'll take =
years
>> off some poor schmuck's life.
>=20
> I _really_ thought this was discussed upfront by Xin before he sent =
out his
> first version of the series.

I actually reached out to the Intel architects about this before I =
started
coding. Turns out, if the CPU supports WRMSRNS, you can use it across =
the
board.  The hardware is smart enough to perform a serialized write =
whenever
a non-serialized one isn't proper, so there=E2=80=99s no risk.


