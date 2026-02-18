Return-Path: <kvm+bounces-71302-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AOzLIflQlmkodwIAu9opvQ
	(envelope-from <kvm+bounces-71302-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:53:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E8E15B088
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:53:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 020A7300B445
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE2730CD85;
	Wed, 18 Feb 2026 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="PgUUqgvO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7672DEA62;
	Wed, 18 Feb 2026 23:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771458800; cv=none; b=gzNtoLPUDPp6haRqeBNqT4qpSu+JP8lgpgFBEV7TE/YlSGIsbUJKaoE2pJLhvAy711sxpg3cJFVVRXA08AaZnxdJtuOZOoKaJXkEGe+m5MVa0b+QmJ7R/mNjaRhWJrFAte6kxBpvx2k50ttCW0ewiDUYHkkOMfpCIuEg2P46cFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771458800; c=relaxed/simple;
	bh=ud6jjHkpXOUroYYoHpbbrgqTadOtji00RvwIixGXf/Q=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=JeB2wgL+SMpmdk/FnSzSsImSY9tmKsjHEDcShjl5skiV99N3YK4/kde3Um4HjYEreemoIkq5vfZ6dp7EmEU3ANFrQbGhkI35VwbFNGC8cv3kiWzE9qh78WsJg1QHjY1EsRJKaFmPtKYsi5UnxIedwSQGdnYkYyhPLJ1VvvrBFtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=PgUUqgvO; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61INastk2596160
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Feb 2026 15:36:55 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61INastk2596160
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1771457815;
	bh=ud6jjHkpXOUroYYoHpbbrgqTadOtji00RvwIixGXf/Q=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=PgUUqgvOFZlif81k2hIvBmtYJBzWZ5kYIVHUMsJf2gEHl4gVutCow+eQo9TdLZGy0
	 Q28R8L2Nd+0oJVYqTwfEck5wxEy9s/IlWtW6tGkIc1u8eeHg4tZkDbmk7nW2RGVZ5I
	 UGWz7mjAYb4IDILOZrQEZQp4RKcejpczDsRMZbE+409bz1bSa9RhGwaWVJvIYF8sev
	 bIy8b37Y78oq4RND5Lc4T7JVKgd1b8mnoJt15hOBocPwGLxyCz2DvS4ESg1x9CyUl/
	 wuk2hUqP5Z+RzOl5C+9UB0dH51yfw2mwq5zxC1YLRG1jm7OCTR7vA9ufW7Cq9CA7K5
	 QNJLti+LuNxZA==
Date: Wed, 18 Feb 2026 15:36:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Xin Li <xin@zytor.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_09/16=5D_x86/msr=3A_Use_t?=
 =?US-ASCII?Q?he_alternatives_mechanism_for_WRMSR?=
User-Agent: K-9 Mail for Android
In-Reply-To: <e05a65a7-bf8e-420b-8a36-2d76e56b43b0@intel.com>
References: <20260218082133.400602-1-jgross@suse.com> <20260218082133.400602-10-jgross@suse.com> <aZYoUE7CmrLg3SVe@google.com> <e05a65a7-bf8e-420b-8a36-2d76e56b43b0@intel.com>
Message-ID: <7F627940-578D-4EDF-9812-41DDF3275B4F@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	SUBJ_EXCESS_QP(1.20)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,lists.linux.dev,zytor.com,redhat.com,alien8.de,linux.intel.com,gmail.com,google.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71302-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hpa@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,lkml];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 19E8E15B088
X-Rspamd-Action: no action

On February 18, 2026 1:37:42 PM PST, Dave Hansen <dave=2Ehansen@intel=2Ecom=
> wrote:
>On 2/18/26 13:00, Sean Christopherson wrote:
>> On Wed, Feb 18, 2026, Juergen Gross wrote:
>>> When available use one of the non-serializing WRMSR variants (WRMSRNS
>>> with or without an immediate operand specifying the MSR register) in
>>> __wrmsrq()=2E
>> Silently using a non-serializing version (or not) seems dangerous (not =
for KVM,
>> but for the kernel at-large), unless the rule is going to be that MSR w=
rites need
>> to be treated as non-serializing by default=2E
>
>Yeah, there's no way we can do this in general=2E It'll work for 99% of
>the MSRs on 99% of the systems for a long time=2E Then the one new system
>with WRMSRNS is going to have one hell of a heisenbug that'll take years
>off some poor schmuck's life=2E
>
>We should really encourage *new* code to use wrmsrns() when it can at
>least for annotation that it doesn't need serialization=2E But I don't
>think we should do anything to old, working code=2E

Correct=2E We need to do this on a user by user basis=2E

