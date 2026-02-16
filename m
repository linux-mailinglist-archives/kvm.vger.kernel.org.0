Return-Path: <kvm+bounces-71124-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIDKEjwqk2kI2AEAu9opvQ
	(envelope-from <kvm+bounces-71124-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 15:31:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E0694144B25
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 15:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 295CD303275D
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 14:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793DF31196A;
	Mon, 16 Feb 2026 14:27:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46120284B25;
	Mon, 16 Feb 2026 14:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252031; cv=none; b=I2e6zdYMzOxjW5S7rlHFrh4aOGibaDP33kBUtS6s4msw8eegg09G0jbnzUAvYmLwsJIUCd33zkuvahQquz0NCmJLvsCaZn2Ziqry79kZOzCtc6ITAi5l1blhdoADJkIHu9rqqkAnII5K8i0K85CTN2a+1AdVL+Kmke1uFHGkWEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252031; c=relaxed/simple;
	bh=7PmC3eevop4sZCyCWXJdsSOZoiGFXkDyNHciwOPaBAQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=b4hVhtjkUUbB8MdQfLIsJxWBzYO9fi2BtsfOpyty3oIX2reRd0zpMcoCBFiIEUxMFbtcNnWU1HfL3fQvH/woqJ+E70ChcIIkOCvNUbfWcnjCJkm5s01lk7f/HkJlsHFV7xyp0PjnZU+knoj5AN7yPV9hN1eX6PYYksmqQamsFyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61A841570;
	Mon, 16 Feb 2026 06:27:02 -0800 (PST)
Received: from [10.57.56.155] (unknown [10.57.56.155])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC51A3F6A8;
	Mon, 16 Feb 2026 06:27:04 -0800 (PST)
Message-ID: <9140efaa-dc54-4a1b-8936-3ef876ca9121@arm.com>
Date: Mon, 16 Feb 2026 14:27:02 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
From: Steven Price <steven.price@arm.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <aY4Sf4lMlWd9LyTo@p14s> <55fc4877-666c-4d5f-a167-5692f7cfbd0b@arm.com>
Content-Language: en-GB
In-Reply-To: <55fc4877-666c-4d5f-a167-5692f7cfbd0b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[steven.price@arm.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71124-lists,kvm=lfdr.de];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:url,arm.com:mid]
X-Rspamd-Queue-Id: E0694144B25
X-Rspamd-Action: no action

On 16/02/2026 12:33, Steven Price wrote:
> On 12/02/2026 17:48, Mathieu Poirier wrote:
>> Hi Steven,
>>
>> On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
>>> This series adds support for running protected VMs using KVM under the
>>> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
>>> following feedback from Marc.
>>>
>>> The main change is that rather than providing a multiplex CAP and
>>> expecting the VMM to drive the different stages of realm construction,
>>> there's now just a minimal interface and KVM performs the necessary
>>> operations when needed.
>>>
>>> This series is lightly tested and is meant as a demonstration of the new
>>> uAPI. There are a number of (known) rough corners in the implementation
>>> that I haven't dealt with properly.
>>>
>>> In particular please note that this series is still targetting RMM v1.0.
>>> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
>>> that there are a number of blockers for merging with RMM v1.0 and so I
>>> expect to rework this series to support RMM v2.0 before it is merged.
>>> That will necessarily involve reworking the implementation.
>>>
>>> Specifically I'm expecting improvements in:
>>>
>>>  * GIC handling - passing state in registers, and allowing the host to
>>>    fully emulate the GIC by allowing trap bits to be set.
>>>
>>>  * PMU handling - again providing flexibility to the host's emulation.
>>>
>>>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
>>>    RMM v2.0 provide the option for the host to change the granule size.
>>>    The intention is that Linux would simply set the granule size equal
>>>    to its page size which will significantly simplify the management of
>>>    granules.
>>>
>>>  * Some performance improvement from the use of range-based map/unmap
>>>    RMI calls.
>>>
>>> This series is based on v6.19-rc1. It is also available as a git
>>> repository:
>>>
>>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
>>>
>>> Work in progress changes for kvmtool are available from the git
>>> repository below:
>>>
>>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10
>>
>> The first thing to note is that branch cca/v10 does not compile due to function
>> realm_configure_parameters() not being called anywhere.  Marking the function as
>> [[maybe_unused]] solved the problem on my side.
> 
> This is in the kvmtool code - and yes I agree "work in progress" is a
> bit generous for the current state of that code, "horrid ugly hacks to
> get things working" is probably more accurate ;)
> 
> The issue here is that the two things that realm_configure_parameters()
> set up (hash algorithm and RPV) are currently unsupported with the Linux
> changes, but will need to be reintroduced in the future. So the contents
> of the functions which set this up (using the old uAPI) are just #if 0'd
> out.
> 
> Depending on the compile flags the code will compile with a warning, but
> using __attribute__((unused)) would at least make this clear. I'd want
> to avoid the "[[maybe_unused]]" as it's not used elsewhere in the code
> base and limits compatibility.
> 
>> Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
>> worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
>> from lkvm, mounting the initrd fails.  Looking into this issue further, I see
>> that from a Realm kernel's perspective, the content of the initrd is either
>> encrypted or has been trampled on.  
> 
> I can reproduce that, a quick fix is to change INITRD_ALIGN:
> 
> #define INITRD_ALIGN	SZ_64K
> 
> But the code was meant to be able to deal with an unaligned initrd -
> I'll see if I can figure out what's going wrong.

Looks like a simple bug in kvm_arm_realm_populate_ram() - it wasn't
updating the source address when it had to align the start of the
region. Simple fix below:

---8<---
diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
--- a/arm/aarch64/realm.c
+++ b/arm/aarch64/realm.c
@@ -104,7 +104,7 @@ void kvm_arm_realm_populate_ram(struct kvm *kvm,
unsigned long start,

        new_region->start = ALIGN_DOWN(start, SZ_64K);
        new_region->file_end = ALIGN(start + size, SZ_64K);
-       new_region->source = source;
+       new_region->source = source - (start - new_region->start);

        list_add_tail(&new_region->list, &realm_ram_regions);
 }
---8<---

Thanks for the pointer, and I'll try to remember to include initrd
testing in future.

Steve


