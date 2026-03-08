Return-Path: <kvm+bounces-73242-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qA3GC1V7rWmw3QEAu9opvQ
	(envelope-from <kvm+bounces-73242-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 14:36:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABE3C2306EB
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 14:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96A60301570D
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 13:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3B538550B;
	Sun,  8 Mar 2026 13:36:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014E217A2F6;
	Sun,  8 Mar 2026 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772976969; cv=none; b=oVxH8sqqDj9CsdY5ekNb4DHq5ElcLlrFNIytPVHj1RxNnm772jGXXm29iJqWnEXdfE9fwLn01Kx1ZByxFRWqguCeaikLEKQJE7u6WYvPOaD0nMNAwbJRCtPMTzvSj9yUE/TyYKESgFTPQYrQteIReK0Iaw/yesBcqJF6hKX9g8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772976969; c=relaxed/simple;
	bh=3lFOlLrQgsrVvPDaRIq9XVA9VRdlnEhw7AtlBfqzLSQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ap0nyIr+SgmRb87SSvffi+eXqi2MxTep6UIK0lnKY9J7o03i0KayhA1Nachz4posUdITH4gWvkt+xeivYi6R0TdbOV5jOSMHshwhmQ4CWE8JB0gTLShJHz4tDxRis0lxkp1mTqEgluB1L7dKgv2cc5UmUsL9WyWUkYi7y6PBkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C02A51570;
	Sun,  8 Mar 2026 06:35:59 -0700 (PDT)
Received: from [10.163.174.99] (unknown [10.163.174.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C8393F7BE;
	Sun,  8 Mar 2026 06:36:03 -0700 (PDT)
Message-ID: <ebbb0ebd-9556-4c8f-b557-6990902ccbc5@arm.com>
Date: Sun, 8 Mar 2026 19:05:59 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
 <aasZ5NNo7q9MRgzD@google.com> <abc4ed51-2129-4bed-a156-e0e9ec4e81c4@arm.com>
Content-Language: en-US
In-Reply-To: <abc4ed51-2129-4bed-a156-e0e9ec4e81c4@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABE3C2306EB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73242-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	NEURAL_SPAM(0.00)[0.055];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anshuman.khandual@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,arm.com:mid]
X-Rspamd-Action: no action



On 08/03/26 6:28 PM, Anshuman Khandual wrote:
> On 06/03/26 11:46 PM, Sean Christopherson wrote:
>> On Fri, Mar 06, 2026, Anshuman Khandual wrote:
>>> Change both [g|h]va_t as u64 to be consistent with other address types.
>>
>> That's hilariously, blatantly wrong.
> 
> Sorry did not understand how this is wrong. Both guest and host
> virtual address types should be be contained in u64 rather than
> 'unsigned long'. Did I miss something else here.

Is this about 32 bit systems where unsigned long would have matched
a 32 bit pointer size where as u64 will not ? But would not the u64
still contain 32 bit pointer without any issues.


