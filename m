Return-Path: <kvm+bounces-13017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A77328901AF
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8F5C1C2BE10
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 14:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF03126F3F;
	Thu, 28 Mar 2024 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="oqvZ3Slr"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25E083CB2;
	Thu, 28 Mar 2024 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711635874; cv=none; b=YMJJahB5qgdNim4oLX3q1/zNDKrmxrVPiSSEflU/vXDQjm2ScrmQU5SzEZ0UAf1Lzmi9coGhgBiw/fDFhA46lQeTIjOni1QpcNn1hilc7EKj3amUDJqNghz2kNgpd/idedNLAVc+R0HZdvZZOr9x7e3uU6Xt2W0Sa+m8yGpN48M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711635874; c=relaxed/simple;
	bh=BK5T9ghNxG0GFU69c70sqjesTdNe8K2qsWISPcbW/BI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NJ0rPbgQxZEbHPTESlENXEdD/FWRtp59OobtsE8YiKltpe1G2tHLc/TmFcgvkBL5eJ9lrAHegHnYxBj0SgKsLGGruyioI+zQJrBUvemOc/kI01fNjk5/+QLySotlFg/F+mfvq5btlepeoj7iRNhZq3YGLk86zNFQDkm/dE4afzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=oqvZ3Slr; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.66.160.44] (unknown [108.143.43.187])
	by linux.microsoft.com (Postfix) with ESMTPSA id F15E820E6AC1;
	Thu, 28 Mar 2024 07:24:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F15E820E6AC1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1711635872;
	bh=1l+2SEDIwQkqSvND2rBzNts74gzDdFBM4fPcS3as+CA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oqvZ3Slr8vDh7h6VgMDWNVpWOIqxlXFCFZHQOp45V68Q8+xA6vEFY21zOQ7yJKqRD
	 28qc6wSFHrMymbwBKatxXWfZzjf4TeqeXww66jc+AHRExNGKP0WQs5MAvnUa3y+vkZ
	 kJXKZR1QB+DTCdaqTcoEBu5eJ403qnuAF9ZoR5lg=
Message-ID: <ac4f34a0-036a-48b9-ab56-8257700842fc@linux.microsoft.com>
Date: Thu, 28 Mar 2024 15:24:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 KVM <kvm@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 Joerg Roedel <joro@8bytes.org>, Michael Roth <michael.roth@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
 <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>
 <20240328134109.GAZgVzdfQob43XAIr9@fat_crate.local>
Content-Language: en-CA
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20240328134109.GAZgVzdfQob43XAIr9@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/03/2024 14:41, Borislav Petkov wrote:
> On Thu, Mar 28, 2024 at 12:51:17PM +0100, Jeremi Piotrowski wrote:
>> Shouldn't this line be inside the cpu_has(c, X86_FEATURE_SEV_SNP) check?
> 
> The cc_vendor is not dependent on X86_FEATURE_SEV_SNP.
>

It's not but if you set it before the check it will be set for all AMD systems,
even if they are neither CC hosts nor CC guests.

cc_vendor being unset is handled correctly in cc_platform_has() checks.

>> How about turning this into a more specific check:
>>
>>   if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) &&
> 
> Why?
> 

To leave open the possibility of an SNP hypervisor running nested.

> The check is "am I running as a hypervisor on baremetal".
> 

I thought you wanted to filter out SEV-SNP guests, which also have X86_FEATURE_SEV_SNP
CPUID bit set.

My understanding is that these are the cases:

CPUID(SEV_SNP) | MSR(SEV_SNP)     | what am I
---------------------------------------------
set            | set              | SNP-guest
set            | unset            | SNP-host
unset          | ??               | not SNP

