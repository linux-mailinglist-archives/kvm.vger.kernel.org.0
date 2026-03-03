Return-Path: <kvm+bounces-72542-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DGJDWkGp2k7bgAAu9opvQ
	(envelope-from <kvm+bounces-72542-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 17:03:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 223601F32C0
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 17:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0C4173045922
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 16:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BC33A6EED;
	Tue,  3 Mar 2026 16:03:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653E43AE1A7;
	Tue,  3 Mar 2026 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553780; cv=none; b=J4ZqEhuWMX6HFM2c82qOXTZ0p+w9yjL656RKn+DbxOkC6J4coE9gf93XM/N3Gbwe3qYspPGcPCEpb7jGx30EVmPePsMJSNPZ6rp5REsuut14LBY60sjwJBv2VcB1yHyPJVdXZUr8a1YNnFW3/9ERwjY22ny43ljxiv2UC3VChJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553780; c=relaxed/simple;
	bh=nybrefJvY4I/b5tGu5aw4kr9AmUjRGgpr4KA3jcPp2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DbdOx5dwQ5eYG8LYoLyDDMBM2NyQ6Ik1u/d51hv5NSioBnnmyJoKwwGJKp5pj6MrNApb+ao7Xo2KrXNrk36EJrrL5krmmHQ+J/5HNvVEM5jUWDgT1XkQVYcONlTLTNcP1dqZYjNdpS86h05y7DpwrPeQzCYgs/iafSHhHLhRZXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C1FF339;
	Tue,  3 Mar 2026 08:02:52 -0800 (PST)
Received: from [10.57.66.27] (unknown [10.57.66.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67C6E3F694;
	Tue,  3 Mar 2026 08:02:55 -0800 (PST)
Message-ID: <37b79d98-10e5-4beb-b95c-783d41050eae@arm.com>
Date: Tue, 3 Mar 2026 16:02:53 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-7-steven.price@arm.com> <86tsuy8g0u.wl-maz@kernel.org>
 <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com>
 <9d702666-72a8-43e4-8ab3-548d8154a529@arm.com> <86fr6h838s.wl-maz@kernel.org>
 <d87ee902-3b5e-4cf9-8b97-d83f8da02a5a@arm.com> <86ecm17zeb.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86ecm17zeb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 223601F32C0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RSPAMD_EMAILBL_FAIL(0.00)[suzuki.poulose.arm.com:query timed out];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72542-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.988];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 03/03/2026 14:37, Marc Zyngier wrote:
> On Tue, 03 Mar 2026 14:23:08 +0000,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 03/03/2026 13:13, Marc Zyngier wrote:
>>> On Mon, 02 Mar 2026 17:13:41 +0000,
>>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>>
>>>> More importantly, we have to make sure that the "RMI_PSCI_COMPLETE" is
>>>> invoked before both of the following:
>>>>     1. The "source" vCPU is run again
>>>>     2. More importantly the "target" vCPU is run.
>>>
>>> I don't understand why (1) is required. Once the VMM gets the request,
>>
>> The underlying issue is, the RMM doesn't have the VCPU object for the
>> "target" VCPU, to make the book keeping. Also, please note that for  a
>> Realm, PSCI is emulated by the "RMM". Host is obviously notified of the
>> "PSCI" changes via EXIT_PSCI (note, it is not SMCCC exit)
>>   so that it can be in sync with the real state. And does have a say in
>>   CPU_ON. So, before we return to running the "source" CPU,
>> Host must provide the target VCPU object and its consent (via
>> psci_status) to the RMM. This allows the RMM to emulate the PSCI
>> request correctly and also at the same time keep its book keeping
>> in tact (i.e., marking the Target VCPU as runnable or not).
>>
>> When a "source" VCPU exits to the host with a PSCI_EXIT, the RMM
>> marks the source VCPU has a pending PSCI operation, and
>> RMI_PSCI_COMPLETE request ticks that off, making it runnable again.
> 
> Sure. What I don't get is what this has to happen on the source vcpu
> thread. The RMM has absolutely no clue about that, and there should be
> no impediment to letting the target vcpu do it as it starts.

Because, the RMM wants to make that the state is consistent. i.e,
Host cannot lie to the "source" VCPU and RMM (e.g., CPU_ON denied) and
then run the "target" VCPU.

In other words, the response to the CPU_ON must be recorded by the RMM
in the target VCPU state, to make sure the target VCPU state is
consistent with the response.

The only way to fix this would be RMM keeping track of "mpidr" to REC
object mapping (VCPU object), which impacts the scalability. With that
in place, RMM can update the target VCPU state from the return of the
REC_ENTER after a PSCI_EXIT.

That said, will explore the options to address this

Thanks
Suzuki

> 
> Even better, you should be able to do that on the first thread that
> reenters the guest, completely removing any RMM knowledge from the
> PSCI handling in userspace.
> 
> If you can't do that, then please consider fixing the RMM to allow it.
> 
> Thanks,
> 
> 	M.
> 




