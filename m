Return-Path: <kvm+bounces-38515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8501A3AD0F
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB92D1896342
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C6B1F5E6;
	Wed, 19 Feb 2025 00:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="fC4c5vRw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE71BDCF;
	Wed, 19 Feb 2025 00:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739924825; cv=none; b=R3TfwWhTFgJhHfe9haVHw2UoXRxP5NmwFiDL5dO7RXYI8ESFoU9vy1UJvevxMBhSC6oGtzVm5oG3Hxg7/e7Vlne+PsfW4LX3NM8Vjw/0xRhWF+GVjVxscKxXs47V65XZZi0K+tIQXT5NbL+GVMp9xchjuEt1ew1szm6qgi7tq2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739924825; c=relaxed/simple;
	bh=bu9B3w7ogDjvm/Aq+eb+I8femRfra/YxQw8dUg/GhB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=atoZ6LohlSNfqhL+uAk2+JnuBQMk6JFRTuLXy4hxw+neIJlDLFQp1hb99MUPhkX1B8/1/O812yE8MsZsLWmm1xqarAe4uAXdpUoqSdaRgcDbfAgdHXNBx4uTB6KXCM+3i4YLwNSqdiE7r3jXxE2hzrj5T5L7kLFIOWwR7C5YdFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=fC4c5vRw; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 51J0QMBB1533636
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 18 Feb 2025 16:26:22 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 51J0QMBB1533636
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1739924784;
	bh=ZJKYirQZOdjFMEZ1AF3a0IRVlz2yfnnyk4d7gFkVeqk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fC4c5vRweYSjEsoha5Hvpig51p6fVKXjAj+6yqjI25Y2zx5L/hoBuBwqGuJK7EgO6
	 4Th0SYoYBIHPDPQFojnmKVXWeHe/rfD4tvCxzpJ6MOCZUfIMm4/b49+O6YkPE6/zGG
	 psovzAwoVd8+uup4fJMKdlyxGDzCd18Entp60CND+mwbS4erwocfZdkv0gINS8UWfO
	 O2g1vpVMAed2P3k4KuG9N238MkkhoWQFfBldQB9pD6ohsb4wFP6Ix7ihHVfIVcgwxb
	 zgxwYpc1RCdiCsjhZgypcMXKxE6sBFM7XxeaTHbDByxoc+tvhlgg0gzCZ4kPYe+ZUR
	 c8VM0f1qAp2/g==
Message-ID: <22d4574b-7e2d-4cd8-91bd-f5208e82369e@zytor.com>
Date: Tue, 18 Feb 2025 16:26:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/27] Enable FRED with KVM VMX
To: seanjc@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/2024 10:00 PM, Xin Li (Intel) wrote:
> This patch set enables the Intel flexible return and event delivery
> (FRED) architecture with KVM VMX to allow guests to utilize FRED.
> 
> The FRED architecture defines simple new transitions that change
> privilege level (ring transitions). The FRED architecture was
> designed with the following goals:
> 
> 1) Improve overall performance and response time by replacing event
>     delivery through the interrupt descriptor table (IDT event
>     delivery) and event return by the IRET instruction with lower
>     latency transitions.
> 
> 2) Improve software robustness by ensuring that event delivery
>     establishes the full supervisor context and that event return
>     establishes the full user context.
> 
> The new transitions defined by the FRED architecture are FRED event
> delivery and, for returning from events, two FRED return instructions.
> FRED event delivery can effect a transition from ring 3 to ring 0, but
> it is used also to deliver events incident to ring 0. One FRED
> instruction (ERETU) effects a return from ring 0 to ring 3, while the
> other (ERETS) returns while remaining in ring 0. Collectively, FRED
> event delivery and the FRED return instructions are FRED transitions.
> 
> Intel VMX architecture is extended to run FRED guests, and the major
> changes are:
> 
> 1) New VMCS fields for FRED context management, which includes two new
> event data VMCS fields, eight new guest FRED context VMCS fields and
> eight new host FRED context VMCS fields.
> 
> 2) VMX nested-exception support for proper virtualization of stack
> levels introduced with FRED architecture.
> 
> Search for the latest FRED spec in most search engines with this search
> pattern:
> 
>    site:intel.com FRED (flexible return and event delivery) specification
> 
> The first 20 patches add FRED support to VMX, and the rest 7 patches
> add FRED support to nested VMX.
> 
> 
> Following is the link to the v2 of this patch set:
> https://lore.kernel.org/kvm/20240207172646.3981-1-xin3.li@intel.com/
> 
> Sean Christopherson (3):
>    KVM: x86: Use a dedicated flow for queueing re-injected exceptions
>    KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
>    KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
> 
> Xin Li (21):
>    KVM: VMX: Add support for the secondary VM exit controls
>    KVM: VMX: Initialize FRED VM entry/exit controls in vmcs_config
>    KVM: VMX: Disable FRED if FRED consistency checks fail
>    KVM: VMX: Initialize VMCS FRED fields
>    KVM: x86: Use KVM-governed feature framework to track "FRED enabled"
>    KVM: VMX: Set FRED MSR interception
>    KVM: VMX: Save/restore guest FRED RSP0
>    KVM: VMX: Add support for FRED context save/restore
>    KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
>    KVM: VMX: Virtualize FRED event_data
>    KVM: VMX: Virtualize FRED nested exception tracking
>    KVM: x86: Mark CR4.FRED as not reserved when guest can use FRED
>    KVM: VMX: Dump FRED context in dump_vmcs()
>    KVM: x86: Allow FRED/LKGS to be advertised to guests
>    KVM: x86: Allow WRMSRNS to be advertised to guests
>    KVM: VMX: Invoke vmx_set_cpu_caps() before nested setup
>    KVM: nVMX: Add support for the secondary VM exit controls
>    KVM: nVMX: Add a prerequisite to SHADOW_FIELD_R[OW] macros
>    KVM: nVMX: Add FRED VMCS fields
>    KVM: nVMX: Add VMCS FRED states checking
>    KVM: nVMX: Allow VMX FRED controls
> 
> Xin Li (Intel) (3):
>    x86/cea: Export per CPU variable cea_exception_stacks
>    KVM: VMX: Do not use MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
>    KVM: nVMX: Add a prerequisite to existence of VMCS fields

Hi Sean,

While I'm waiting for the CET patches for native Linux and KVM to be
upstreamed, do you think if it's worth it for you to take the cleanup
and some of the preparation patches first?

Top of my mind are:
     KVM: x86: Use a dedicated flow for queueing re-injected exceptions
     KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
     KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
     KVM: nVMX: Add a prerequisite to existence of VMCS fields
     KVM: nVMX: Add a prerequisite to SHADOW_FIELD_R[OW] macros

Then specially, the nested exception tracking patch seems a good one as
Chao Gao suggested to decouple the nested tracking from FRED:
     KVM: VMX: Virtualize nested exception tracking

Lastly the patches to add support for the secondary VM exit controls 
might go in early as well:
     KVM: VMX: Add support for the secondary VM exit controls
     KVM: nVMX: Add support for the secondary VM exit controls

But if you don't like the idea please just let me know.

Thanks!
     Xin

