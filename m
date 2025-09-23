Return-Path: <kvm+bounces-58536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C82EB9650D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F246D1884B3D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4A2242D6C;
	Tue, 23 Sep 2025 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="foTog51+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC62B9BA;
	Tue, 23 Sep 2025 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637995; cv=none; b=j/lUuH8dDWbpytsZ+B00twBjOcvQJgull4dvyVGbtuk6TcOFtuHER17oXFv2QVu5q7jrCO29QJ6udAB//qEG8259gbCXMMgdcr7rHpExVTPRdodutDxC3Eb+Sp3prTofGKkp69leB5IjbZLY9XTq/AaQon+EGmpbRKOLGxv48q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637995; c=relaxed/simple;
	bh=6b/C0GA3CDu2NK6qET9/dvnZZBIEkc60GmnPLmmsZ/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPQ5hT4MM4FZwh7udkHkZ8mXUGFAVlYqhuzozfvDLft7ugN6FUqUo6WlzmDgRGWHnzwQzy8XrQZN9qm3kiKKf0wPQzA7gOa6A+fgah+AGOlxXdHBzeWLB5C96w9cyXJ0N4IypH/jwM2aiVzgiCQ3bwlQFzXkr/0v82rMiYEGeFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=foTog51+; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758637993; x=1790173993;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6b/C0GA3CDu2NK6qET9/dvnZZBIEkc60GmnPLmmsZ/k=;
  b=foTog51+jHhAMwMsL9708lqVtURQj2MsqY7H4EaUw7S/zLZJP190IeL3
   lA7Yaa/hak4poGD2u1iU8Cf3TOMe6ncv+s7bmmgS40Q5tVcTg5oko2KGn
   AIMU3kIoLxjJmNy84MFMWdz4Q88aYDbTZeEjA5lkI7T3SW+HXKcT7o4UW
   SaBtRL/ZAHgTRjDBdUY5377ObmpHHinjMm72MbPPkJ5nhTTTQDV4Qodd1
   RBqj4AWajq+jz3GG9yAS+8hofXxeVmHSpbR+3XJ5KG3zYvI6yg3JuNHJo
   NOjoFfvuJYSWa31Imvs/2+JSwCPNaFv047XfkGFs+SBwiiUfsgOFd73Oq
   w==;
X-CSE-ConnectionGUID: EnDDT4IxSRmOJIEwdCtYUQ==
X-CSE-MsgGUID: ikylLlpZTm+yy4EgAqGWPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61033991"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="61033991"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:33:12 -0700
X-CSE-ConnectionGUID: ikDk9zKsTgGsJxMhWPx+NA==
X-CSE-MsgGUID: UYMI0pLUSq2kx+wwo+kXpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="176615386"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:33:07 -0700
Message-ID: <eb2465a7-359c-41b7-9687-984537f75d96@intel.com>
Date: Tue, 23 Sep 2025 22:33:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 21/51] KVM: x86/mmu: WARN on attempt to check
 permissions for Shadow Stack #PF
To: Binbin Wu <binbin.wu@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z
 <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-22-seanjc@google.com>
 <8b91ca86-6301-4645-a9c2-c2de3a16327c@linux.intel.com>
 <b12cac74-5a08-4338-bbab-510860e11a30@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <b12cac74-5a08-4338-bbab-510860e11a30@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/22/2025 3:46 PM, Binbin Wu wrote:
> 
> 
> On 9/22/2025 3:17 PM, Binbin Wu wrote:
>>
>>
>> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
>>> Add PFERR_SS_MASK, a.k.a. Shadow Stack access, and WARN if KVM 
>>> attempts to
>>> check permissions for a Shadow Stack access as KVM hasn't been taught to
>>> understand the magic Writable=0,Dirty=0 combination that is required for
> Typo:
> 
> Writable=0,Dirty=0 -> Writable=0,Dirty=1

With it fixed,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>>> Shadow Stack accesses, and likely will never learn.  There are no 
>>> plans to
>>> support Shadow Stacks with the Shadow MMU, and the emulator rejects all
>>> instructions that affect Shadow Stacks, i.e. it should be impossible for
>>> KVM to observe a #PF due to a shadow stack access.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

