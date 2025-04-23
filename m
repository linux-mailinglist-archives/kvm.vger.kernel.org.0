Return-Path: <kvm+bounces-43938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDBBA98C61
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 934E23AC328
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 14:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53EDA27D796;
	Wed, 23 Apr 2025 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codelabs.ch header.i=@codelabs.ch header.b="lw/sCYqe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FDE27CCFB;
	Wed, 23 Apr 2025 14:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.202.192.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745417078; cv=none; b=gKiTv75XoPXtzP4MMi426sUR38OoLo8ncBncoE7vnx3tTN7ORQwT0Km76a0kZzuU4A67l6xejsRDtLPcfnT4PF7VKDhNITIwE/Z+rysFXsvFs4yfYnq4hrHyNxPj5kUsA8dCetkamEds6R4WjoXtvI5mpA2MoFVBenMXcO12Nrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745417078; c=relaxed/simple;
	bh=a/SoXK+6W5wY5lmg5HNoQX+sNEBHwFD8y1bLRPr9Slc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gVJn2LBAvkze4QRp9ZW848mYiAgP2MpVrRZR7qTrBdDmmu95hswk1dJqQEbumpOPGjQDB1zM5aPEbykI6ii5C4GN0/afOZrM78UUsxwan+qvqQdlWzDydYiqqkriIDzhzW+v70U7LCYCOM59Fludr1cSjqilkQIXAbltFGLiXSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codelabs.ch; spf=pass smtp.mailfrom=codelabs.ch; dkim=pass (2048-bit key) header.d=codelabs.ch header.i=@codelabs.ch header.b=lw/sCYqe; arc=none smtp.client-ip=109.202.192.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codelabs.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codelabs.ch
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 1DBFC5A0002;
	Wed, 23 Apr 2025 15:54:24 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id 3nseL02xfwX2; Wed, 23 Apr 2025 15:54:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codelabs.ch;
	s=default; t=1745416463;
	bh=a/SoXK+6W5wY5lmg5HNoQX+sNEBHwFD8y1bLRPr9Slc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lw/sCYqeIg4KUIZd6TRdkfbUk1EWmlFLo8jdUTBjvfvB2sZ7afoskzfcNkLNhCG6x
	 Eq+7q3NPUg6yHx/LbnrX6f4woRyRl7R59WSBNEJtg/S3aBt1adB5fpMmQm2riPq8YP
	 zaA/JP1ZyI9Wf73t3jQaxsEDEcZUdN1YjatH5CUvMhWE8D+nn2J2ozPWjAO5mNmI8/
	 xjd174O5t+kzQ+jz9sRfB5unOi4xyrSCNvumBOji/iDJbWtj0FZIavlhZchcOVXVm7
	 qliNHLxqQK5pqlV/xbNO0izrR1ugvSS4EsxJP7zeLdkL5IedH8986ExKhGHuFugN8G
	 4CZSwr2Xze+rQ==
Received: from [IPV6:2a02:168:860f::19d8] (unknown [IPv6:2a02:168:860f::19d8])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 011665A0001;
	Wed, 23 Apr 2025 15:54:23 +0200 (CEST)
Message-ID: <994de1c0-04c2-485b-bab0-909e293d1cf8@codelabs.ch>
Date: Wed, 23 Apr 2025 15:54:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
To: Jon Kohler <jon@nutanix.com>
Cc: Alexander Grest <Alexander.Grest@microsoft.com>,
 Nicolas Saenz Julienne <nsaenz@amazon.es>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhao Liu <zhao1.liu@intel.com>, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
 pbonzini@redhat.com
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Language: en-US
From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Autocrypt: addr=ken@codelabs.ch; keydata=
 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 aRk=
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/13/25 21:36, Jon Kohler wrote:

[snip]

> The semantics for EPT violation qualifications also change when MBEC
> is enabled, with bit 5 reflecting supervisor/kernel mode execute
> permissions and bit 6 reflecting user mode execute permissions.
> This ultimately serves to expose this feature to the L1 hypervisor,
> which consumes MBEC and informs the L2 partitions not to use the
> software MBEC by removing bit 14 in 0x40000004 EAX [4].

Should this say bit 13 of 0x40000004.EAX? According to the referenced 
docs [4]:

Bit 13: "Recommend using INT for MBEC system calls."

Bit 14: "Recommend a nested hypervisor using the enlightened VMCS 
interface. Also indicates that additional nested enlightenments may be 
available (see leaf 0x4000000A)."

Regards,
Adrian

