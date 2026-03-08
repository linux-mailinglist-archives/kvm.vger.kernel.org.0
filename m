Return-Path: <kvm+bounces-73240-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIWYMJRyrWlq3AEAu9opvQ
	(envelope-from <kvm+bounces-73240-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 13:59:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C69323050F
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 13:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C8AE83019F1A
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 12:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A549937AA77;
	Sun,  8 Mar 2026 12:58:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15B635F17A;
	Sun,  8 Mar 2026 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772974727; cv=none; b=iDjmNdnuZHFd2wO1LsJUWB9fTxzwBm8aHbFBNDldC9A57xGkM4XvFxblLs+PL3FgdJv6E0E4sZCFO7jIgF0GwMXn+X8IODfB3HgDGgBzxvSu0GDsN5axR2/06t3T+b2N4xlWGO/6MkXMOPUm/TPGgz/loozg4ypEBFhgNVvcoXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772974727; c=relaxed/simple;
	bh=lx9Bb7FLIZfntRr7EkiP7vvmaf9bUOQvG4dmDlCZGYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oOpCRZwgIx40n92TqyTPNHahDLQ7CR9gWr9oeS//KsSvcM2r2Dv0z9LUVlIn/UtPs6f5Ce3vmqk1Fkczx2YafCAak4hFU2V1TvjMOqFnGLr8hXUzzU26L6i2k14AReC36Njqv25G/PepTs2MLcU4rLOcYPDB1H31PwVEuG8LzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A59131570;
	Sun,  8 Mar 2026 05:58:37 -0700 (PDT)
Received: from [10.163.174.99] (unknown [10.163.174.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 772833F7BD;
	Sun,  8 Mar 2026 05:58:42 -0700 (PDT)
Message-ID: <abc4ed51-2129-4bed-a156-e0e9ec4e81c4@arm.com>
Date: Sun, 8 Mar 2026 18:28:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
 <aasZ5NNo7q9MRgzD@google.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aasZ5NNo7q9MRgzD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C69323050F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73240-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	NEURAL_SPAM(0.00)[0.074];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anshuman.khandual@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 06/03/26 11:46 PM, Sean Christopherson wrote:
> On Fri, Mar 06, 2026, Anshuman Khandual wrote:
>> Change both [g|h]va_t as u64 to be consistent with other address types.
> 
> That's hilariously, blatantly wrong.

Sorry did not understand how this is wrong. Both guest and host
virtual address types should be be contained in u64 rather than
'unsigned long'. Did I miss something else here.

