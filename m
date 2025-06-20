Return-Path: <kvm+bounces-50239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64A13AE2676
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB2C55A0484
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654C62475C3;
	Fri, 20 Jun 2025 23:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DOv8lFdE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFD9241676;
	Fri, 20 Jun 2025 23:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461775; cv=none; b=vFK7HgixUvwCU66vccN2+YQdjOc4g0hJDQQWepFXECXJzQ3rUlMoqrcZ9o7BWcS3kJSPXQaHfwTxOYrg67uP1V59wPq8qOysHljZtRylFAxiK7+a9Izxj7NTIFYs86ukm14/1okEhBLmfYqgUYPQJ1u5bOrGEUY0hnSrBciPito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461775; c=relaxed/simple;
	bh=2jaVYD+t6InVcVg2bje4Rfzz2VXV7ZItheYO/UDcAQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zpw3pO5Vp9XRppth9M8na5lyjdCYJClVxKegiWl4ESXa5PN0bZ0KWTSD6Dg/nWzJ//krjYldTJQ43/eNbTF7zUIx9bETdgA9VBAalub/UX2EKqL6Vm5nPPJeLFKOdvqszF/l5iAUPgXepqSGRSQF2PBQe5BrnZ/TISbkfSJXLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DOv8lFdE; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [IPV6:2601:646:8081:9482:8e69:eb66:369f:ca04] ([IPv6:2601:646:8081:9482:8e69:eb66:369f:ca04])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55KNMHP32678734
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 20 Jun 2025 16:22:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55KNMHP32678734
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750461739;
	bh=Bwvs4LdK4yiSst8Y6xUmdgkiTVl+DzPbS+vbPnH+Nac=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DOv8lFdEADhqHc2isr7NooqRuwUIAHzC5HnXKiQ4/LX6i1Fa14ohkvHba3xzjain4
	 6VTXg9VZMs3JfT/vq06+6fy1r1SQamBwolaHApY/+3YUg/zPVi3OqRdGMugWTEHT/9
	 R/wloIBzPuqxn8DBa5rsR5SMpngbYQw4+EqD43yRhBFVyO0hCmQJx82WBKilMwRpjR
	 p7f0yY2pMIr5R9SX9PNJwhB6zR6BkcKzdkHViqwS3wZtx7ktKCe6QCIXQoXOPyWD1b
	 7zazjnOVu9av19a3ApIREOGC3qSFxFm6mVbXWTJ5vC9EqaRFN1E/3FcQCavKP0mwJ2
	 MzZiMFfuX2GoQ==
Message-ID: <1713a225-44e0-4018-bf5f-64ffd7746167@zytor.com>
Date: Fri, 20 Jun 2025 16:22:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>, Xin Li <xin@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com>
 <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
 <3281866f-2593-464d-a77e-5893b5e7014f@intel.com>
 <36374100-0587-47f1-9319-6333f6dfe4db@zytor.com>
 <39987c98-1f63-4a47-b15e-8c78f632da4e@intel.com>
 <7acedeba-9c90-403c-8985-0247981bf2b5@zytor.com>
 <aFXsPVIKi6wFUB6x@google.com>
Content-Language: en-US
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <aFXsPVIKi6wFUB6x@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-06-20 16:18, Sean Christopherson wrote:
>>
>> So I was thinking about this, and wonder: how expensive is it to get the
>> event data exit information out of VMX? If it is not very expensive, it
>> would arguably be a good thing to future-proof by fetching that information,
>> even if it is currently always zero.
> 
> It's trivially easy to do in KVM, and the cost of the VMREAD should be less than
> 20 cycles.  So quite cheap in the grand scheme.  If VMREAD is more costly than
> that, then we have bigger problems :-)
> 

LOL. Since it is up to you, Paulo, etc. to decide how to do the 
tradeoffs formaintainability, debuggability and performance in KVM I am 
guessing this is a vote in favor? (You can always take it out if it is a 
performance problem, until such time that the kernel itself starts 
consuming this information for reasons currently unknown.)

	-hpa


