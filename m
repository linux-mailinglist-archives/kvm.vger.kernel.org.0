Return-Path: <kvm+bounces-50198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B59AE25D7
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 00:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33C9E1C2130E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CEA4241116;
	Fri, 20 Jun 2025 22:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QYAqO6y6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0BA210FB;
	Fri, 20 Jun 2025 22:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750459999; cv=none; b=UDrAgdmgxieV/GphvxLZn48rxJE13NiJzbUGqT8hyJEgbiq4YlWh0QBDdL8msKY2B/jQNOkeXqaPxb3Xb7pDbColoIUlyhxTD09jyX9oSv87CWSGLWHAFXdwQHT1VtTxCm9bbYbD5iFYROcLZswxt4ILWSiDYi59aIlSiMnOMHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750459999; c=relaxed/simple;
	bh=qfpCzB4wclc404l7tLJPX7+oneYlSYtlNEt/tGrUK3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q6D1RFgrdMe7OEwYk/C0CPgtr7y6khJ5gT4GhYh/ZkYVI4qnM5gwo47Mw7H23JHSYAPFcftyVhLuqFHVPSrteJxvaW70xTWhquYCS+gevbfKkuuqpbLTe+bhH10E50FZkDeyxra0Zd0Q3BLaVLISPy9v+9n5hhj5+N7xq+MKzy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QYAqO6y6; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [IPV6:2601:646:8081:9482:8e69:eb66:369f:ca04] ([IPv6:2601:646:8081:9482:8e69:eb66:369f:ca04])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55KMpi3J2670267
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 20 Jun 2025 15:51:44 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55KMpi3J2670267
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750459906;
	bh=dHs5e5KPRTLFRZrGk/aD2kqq/TN2P0Xy+dRkjImcTFE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QYAqO6y6FGlEpC2XyzCDh3BoPOBHGwVPtkK5zpOUU7N+eppGdBi7v/I5Lxhdu8C4v
	 RC+FM7W/vF/DaeY4RJvr4SW2D84Gj2X7BgiVqP5PLU3rk4mBFEMmMVOfWUL1NAE4nk
	 8HAd7qiejrsoP/0Gd73iRKMD9aZyVVNmvMlzztWl4wBD5JyCp5TBvAJNvigy65wghe
	 Kf3pA4Ua2Mh+PStAxCtK2AEUfCT1j9cvB9sWLL7F341iJhl2iyTT9UPpyYFP/6dNvW
	 rbBjZCMjhdqiBOTUQYRpupwqGFVBJtHQzLYPHQ9DpvzpGND4grxSQ8LwPsstBoxyr+
	 iBY+X4ocXC0BA==
Message-ID: <7acedeba-9c90-403c-8985-0247981bf2b5@zytor.com>
Date: Fri, 20 Jun 2025 15:51:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
To: Sohil Mehta <sohil.mehta@intel.com>, Xin Li <xin@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
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
Content-Language: en-US
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <39987c98-1f63-4a47-b15e-8c78f632da4e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025-06-19 15:57, Sohil Mehta wrote:
> On 6/19/2025 3:45 PM, Xin Li wrote:
>> On 6/19/2025 3:15 PM, Sohil Mehta wrote:
>>>
>>> I want to say that the event data for IRQ has to be zero until the
>>> architecture changes — Similar to the /* Reserved, must be 0 */ comment
>>> in asm_fred_entry_from_kvm().
>>>
>>
>> FRED spec says:
>>
>> For any other event, the event data are not currently defined and will
>> be zero until they are.
>>
>> So "Event data not defined for IRQ thus 0."
> 
> I am fine with this. Not *defined* removes the ambiguity.
> 

So I was thinking about this, and wonder: how expensive is it to get the 
event data exit information out of VMX? If it is not very expensive, it 
would arguably be a good thing to future-proof by fetching that 
information, even if it is currently always zero.

	-hpa


