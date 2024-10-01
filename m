Return-Path: <kvm+bounces-27787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5ED98C4D1
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 19:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BE9BB24134
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 17:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EC11CC16D;
	Tue,  1 Oct 2024 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TST/sOe1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399C715E97;
	Tue,  1 Oct 2024 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727805144; cv=none; b=TEbNyVs9/OyANVKf+cAogP1N1vL2eeQzR21xLfPtBcJRggzNaukklVH0Sp0GPgVZzWK3E34Qb8AvRSXnsaERBNFyVQAco6VARJWmEPKxJqRQNYab0Ej+e2GKu0B3TwsW4b0GiAP0K8OCzE7JI5Og5aZTJ5gyKPCO5gBZiZQOKiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727805144; c=relaxed/simple;
	bh=E/3fGNUQcLORvx8K8F33lG493tdBqd3VfuxRHO04oDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nipf1x+ude3eLbI86WHrrWw9lgIp1Nybhhru2VCScuRpSX5eER4Vb1yY9qLBX5Upy5ZaU/8JtcxDHrpUb6yUb5vwsZ0uWHKhM9OHW8Na604f/TSRmWwOeZoruEmHWIwn7dsWlcIi/pPErkcRi8F6Sj8JRZz2btXu4mUSOaAbJck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TST/sOe1; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.205] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 491HpWFV3921677
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 1 Oct 2024 10:51:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 491HpWFV3921677
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727805096;
	bh=ZS2VMyYlLJZJy2LdH3tUSS5EeCn1/KctRlF0grWzg9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TST/sOe1en6bYGqJ0ofmbhaOyik+Cw5k+AESQgkmRTYYoUb5aW+4hYADgivwI8S+q
	 oeowugrgwR8uVgCMofB5f/mbIUNYgy7vrP1o/1ukVVGZ0RPhfspYUGKPhvl38TAYWa
	 M6s6p8qQ/J/FqntpqIGsvbYn32Vfsd0aVy7zjD6h2oJbRtOusYgYWnGCQ0pJQCtkv2
	 LQULRMLSv/pvlfpzN6QtiQgtZzlBTLQrUWTMcjpCdA7dTya4oiUkUf4QNsq+qq3M/A
	 5Cejib9G94caY49Cx2CF7VDmvfitm6Skb+fFU/ggjqXd60cgDbs2hEWerYaQLRHMf7
	 gogrxZOgHIG6Q==
Message-ID: <a2b43c7d-659a-46c2-8428-e02e0cd649b6@zytor.com>
Date: Tue, 1 Oct 2024 10:51:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/27] x86/cea: Export per CPU variable
 cea_exception_stacks
To: Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-7-xin@zytor.com>
 <93b3d510-f21b-4f89-ae53-0fa50f03a42d@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <93b3d510-f21b-4f89-ae53-0fa50f03a42d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/2024 9:12 AM, Dave Hansen wrote:
> On 9/30/24 22:00, Xin Li (Intel) wrote:
>> The per CPU variable cea_exception_stacks contains per CPU stacks for
>> NMI, #DB and #DF, which is referenced in KVM to set host FRED RSP[123]
>> each time a vCPU is loaded onto a CPU, thus it needs to be exported.
> 
> Nit: It's not obvious how 'cea_exception_stacks' get used in this
> series.  It's never referenced explicitly.
> 
> I did figure it out by looking for 'RSP[123]' references, but a much
> better changelog would be something like:
> 
> 	The per CPU array 'cea_exception_stacks' points to per CPU
> 	stacks for NMI, #DB and #DF. It is normally referenced via the
> 	#define: __this_cpu_ist_top_va().
> 
> 	FRED introduced new fields in the host-state area of the VMCS
> 	for stack levels 1->3 (HOST_IA32_FRED_RSP[123]). KVM must
> 	populate these each time a vCPU is loaded onto a CPU.
> 

Yeah, this is way clearer.

> See how that explicitly gives the reader greppable strings for
> "__this_cpu_ist_top_va" and "HOST_IA32_FRED_RSP"?  That makes it much
> easier to figure out what is going on.

Nice for a maintainer in 20 years :)

> 
> I was also momentarily confused about why these loads need to be done on
> _every_ vCPU load.  I think it's because the host state can change as
> the vCPU moves around to different physical CPUs and
> __this_cpu_ist_top_va() can and will change.  But it's a detail that I
> think deserves to be explained in the changelog.  There is also this
> note in vmx_vcpu_load_vmcs():

Makes sense to me.

> 
>>                  /*
>>                   * Linux uses per-cpu TSS and GDT, so set these when switching
>>                   * processors.  See 22.2.4.
>>                   */
> 
> which makes me think that it might not be bad to pull *all* of the
> per-cpu VMCS field population code out into a helper since the reasoning
> of why these need to be repopulated is identical.
> 
> Also, what's the purpose of clearing GUEST_IA32_FRED_RSP[123] at
> init_vmcs() time?  I would have thought that those values wouldn't
> matter until the VMCS gets loaded at vmx_vcpu_load_vmcs() when they are
> overwritten anyway.  Or, I could be just totally misunderstanding how
> KVM consumes the VMCS. :)

I don't see any misunderstanding.  However we just do what the SDM
claims, even it seems that it's not a must *logically*.

FRED spec says:
The RESET state of each of the new MSRs is zero. INIT does not change
the value of the new MSRs

Thanks!
     Xin


