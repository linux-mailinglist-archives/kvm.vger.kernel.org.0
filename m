Return-Path: <kvm+bounces-56351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E20FB3C151
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 18:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF276587C21
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B19B341ADA;
	Fri, 29 Aug 2025 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="VKTjE6R0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7810D341AC3;
	Fri, 29 Aug 2025 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756486416; cv=none; b=Oy/sghjQHQo+YxT/4tt4gklhp7bAFmNwmOF5Ege3dUkpPajsVRoC4uzmLjiflqx+l/bTI0xPWAcgB7KhOtQbB7i3nWC+lhBJtGgP8bKVFQWQtXWznMm6Jgjls7gR8J1ZoSCiO2cTWh0Zkr9yQ8mF7cDhZdvKQ5VPdPg24TlTO6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756486416; c=relaxed/simple;
	bh=17bEYwaQx/J/9iD9PRtSOTETZBUyTSFO7JBwMSqfEBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ccx7bT7GYXVPtHMoXBqni681bv3vuP2V4/JP0cp73/sK6p88IxyoUDa62u5QswbMKMwvw/pmxyOubGNNcMibUNlfsmRBcnyRa3ecX0YajTbk6YLsmF7kN9wJLVgRezZ1BlJhwecqt7FDqvR7OZk9njunOuRtZz7jQ8V///fVj+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=VKTjE6R0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TGqwJU2905992
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 29 Aug 2025 09:52:59 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TGqwJU2905992
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756486380;
	bh=dvSn0Sh16oIXikG/5I3YCatVSPov0f88UxISO5rIe9I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VKTjE6R05aNbMGMaeZRWRV4IgelYmrBIPLW6F/PG3q5pmhHV4OfHZhR0awVSV4Dtf
	 lU/AkCNMeKlitOtlMkz4bdOg0rzuBviGQDEzlhZH4J2gxJDr7VOtThfQ0XyJwywnSx
	 9bGlaRthCUP4bMQPh/eGNhP2tgkoOGU/KCnhiqAC1r6w2huXnVdN9x/Vzuqv+nUhHX
	 kS7LbsVYFxoC4IYyrd0uMTBnKu486E3S/ECGCN0JLc2Inl9MMl6m25pyAoq8fLXQhd
	 kN8Sz+JW1tjTd/uPmFzft5S6AVAvrg20tnzI8l+0rmXbpl7EpwIdVmaRAHLHViNBij
	 z0sM/COr6swLA==
Message-ID: <e7dd1510-6ffa-429a-9b07-55ad83d40d7b@zytor.com>
Date: Fri, 29 Aug 2025 09:52:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/21] x86/cea: Export API for per-CPU exception stacks
 for KVM
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org
References: <20250829153149.2871901-1-xin@zytor.com>
 <20250829153149.2871901-6-xin@zytor.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250829153149.2871901-6-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/29/2025 8:31 AM, Xin Li (Intel) wrote:
> Convert the __this_cpu_ist_{top,bottom}_va() macros into proper functions,
> and export __this_cpu_ist_top_va() to allow KVM to retrieve the top of the
> per-CPU exception stack.
> 
> FRED introduced new fields in the host-state area of the VMCS for stack
> levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to
> per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
> fields each time a vCPU is loaded onto a CPU.
> 
> To simplify access to the exception stacks in struct cea_exception_stacks,
> a union is used to create an array alias, enabling array-style indexing of
> the stack entries.

After introducing array-style indexing, we can further simplify the code by
removing ESTACKS_MEMBERS() from struct cea_exception_stacks, as done in the
following patch.  However, including this change in the current patch set
may be distracting, so I plan to submit it separately at a later time.


commit b305b83ab90c77242030727139c9b2e04f4de11e
Author: Xin Li (Intel) <xin@zytor.com>
Date:   Fri Aug 29 12:22:35 2025 -0400

     x86/cea: Simplify cea_exception_stacks by removing ESTACKS_MEMBERS()

     With most accesses to cea_exception_stacks now using array-style indexing,
     the ESTACKS_MEMBERS() macro is no longer necessary in cea_exception_stacks
     and can be removed to streamline the structure and improve code 
readability.

     Remove the CEA_ESTACK_SIZE macro, which redundantly defines 
EXCEPTION_STKSZ.

     Signed-off-by: Xin Li (Intel) <xin@zytor.com>

diff --git a/arch/x86/include/asm/cpu_entry_area.h 
b/arch/x86/include/asm/cpu_entry_area.h
index 58cd71144e5e..509e52fc3a0f 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -52,22 +52,15 @@ struct exception_stacks {

  /* The effective cpu entry area mapping with guard pages. */
  struct cea_exception_stacks {
-	union{
-		struct {
-			ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
-		};
-		struct {
-			char stack_guard[PAGE_SIZE];
-			char stack[EXCEPTION_STKSZ];
-		} event_stacks[N_EXCEPTION_STACKS];
-	};
+	struct {
+		char stack_guard[PAGE_SIZE];
+		char stack[EXCEPTION_STKSZ];
+	} event_stacks[N_EXCEPTION_STACKS];
+	char IST_top_guard[PAGE_SIZE];
  };

-#define CEA_ESTACK_SIZE(st)					\
-	sizeof(((struct cea_exception_stacks *)0)->st## _stack)
-
  #define CEA_ESTACK_OFFS(st)					\
-	offsetof(struct cea_exception_stacks, st## _stack)
+	offsetof(struct cea_exception_stacks, event_stacks[st].stack)

  #define CEA_ESTACK_PAGES					\
  	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 40f51e278171..93b10b264e53 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -70,9 +70,9 @@ struct estack_pages {

  #define EPAGERANGE(st)							\
  	[PFN_DOWN(CEA_ESTACK_OFFS(st)) ...				\
-	 PFN_DOWN(CEA_ESTACK_OFFS(st) + CEA_ESTACK_SIZE(st) - 1)] = {	\
+	 PFN_DOWN(CEA_ESTACK_OFFS(st) + EXCEPTION_STKSZ - 1)] = {	\
  		.offs	= CEA_ESTACK_OFFS(st),				\
-		.size	= CEA_ESTACK_SIZE(st),				\
+		.size	= EXCEPTION_STKSZ,				\
  		.type	= STACK_TYPE_EXCEPTION + st, }

  /*
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 595c2e03ddd5..de0deb8b824c 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -157,7 +157,7 @@ static void __init percpu_setup_debug_store(unsigned 
int cpu)

  #define cea_map_stack(name) do {					\
  	npages = sizeof(estacks->name## _stack) / PAGE_SIZE;		\
-	cea_map_percpu_pages(cea->estacks.name## _stack,		\
+	cea_map_percpu_pages(cea->estacks.event_stacks[name].stack,	\
  			estacks->name## _stack, npages, PAGE_KERNEL);	\
  	} while (0)



