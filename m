Return-Path: <kvm+bounces-61319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02601C165BF
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 19:01:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16DA51C27562
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 17:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AC634C81D;
	Tue, 28 Oct 2025 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VzS1I4Kb"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130A328312D;
	Tue, 28 Oct 2025 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761674293; cv=none; b=Io+zMQ0Ubm0LCqgT7wDYJbUMSrR/l1TxrL70BR88zZ7MmQ1s4PUc0ubnkoRJIKY9zfSyM3lvdvawg8EbtZL3ID2oTI8+8pSDi1Tj8n8rVzVi2qbLzWjPhVWwPQiJv5roqHiIc5pBjeYLTo8eLRyDcf/Tge2p3nWZ5g2azuXtRNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761674293; c=relaxed/simple;
	bh=fHKqiltz1Cq1uiOIbEYdxh6vD4rRubjRjedYpprGup0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDFWiDbRrYVCaI1t/nCpzPMhUhA6Auh+N5gpi9nrb6ZHEDMPhUZrtHlle3k49Q1tAqyvPFR+otfnmSiy0PKDcBCcehx+eOPT471YhLty1PWYanDaXbacZrWk4o8HXVmkJ4FnnQ4rXtA4A0eVdoQuit9usYwhhatqP+q7BXCPkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VzS1I4Kb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [192.168.0.88] (192-184-212-33.fiber.dynamic.sonic.net [192.184.212.33])
	by linux.microsoft.com (Postfix) with ESMTPSA id EF97D200FE7F;
	Tue, 28 Oct 2025 10:58:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EF97D200FE7F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1761674291;
	bh=IgDXEgBAiyExFrgbpmErAYWR0vpfRl5Nl7LUsM3L9TY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VzS1I4KbKnt++XQ2TnL5ndRFshdY4iQpgaH8qKmuGsCJ+IZLrzlBOZRtpAER3/Jaz
	 wABcVkmx2e5KLjLobSJQHpRZ0x7SZrT85mhFvf1xlX+sFhIxZXCq6oPwQFL8NdjrF1
	 J/RcY9Jf0GmcRncWTK1WQoA1W4dKxcVGZkGSmClM=
Message-ID: <54d1b449-9a99-a6db-7655-ded82b883894@linux.microsoft.com>
Date: Tue, 28 Oct 2025 10:58:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [RFC] Making vma_to_pfn() public (due to vm_pgoff change)
Content-Language: en-US
To: Alex Williamson <alex@shazbot.org>
Cc: alex.williamson@redhat.com, joe@perches.com, kvm@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>
References: <a9b8a3ee-b35b-5c45-5042-2466607abcd0@linux.microsoft.com>
 <20251027201711.65e82a4f@shazbot.org>
From: Mukesh R <mrathor@linux.microsoft.com>
In-Reply-To: <20251027201711.65e82a4f@shazbot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/25 19:17, Alex Williamson wrote:
> On Mon, 27 Oct 2025 14:21:56 -0700
> Mukesh R <mrathor@linux.microsoft.com> wrote:
> 
>> Hi Alex,
>>
>> This regards vfio passthru support on hyperv running linux as dom0 aka
>> root. At a high level, cloud hypervisor uses vfio for set up as usual,
>> then maps the mmio ranges via the hyperv linux driver ioctls.
>>
>> Over a year ago, when working on this I had used vm_pgoff to get the pfn
>> for the mmio, that was 5.15 and early 6.x kernels. Now that I am porting
>> to 6.18 for upstreaming, I noticed:
>>
>> commit aac6db75a9fc
>> Author: Alex Williamson <alex.williamson@redhat.com>
>>     vfio/pci: Use unmap_mapping_range()
>>
>> changed the behavior and vm_pgoff is no longer holding the pfn. In light
>> of that, I wondered if the following minor change, making vma_to_pfn() 
>> public (after renaming it), would be acceptable to you.
> 
> How do you know the device is using vfio_pci_core_mmap() with these
> semantics for vm_pgoff versus something like nvgrace_gpu_mmap() that
> uses vm_pgoff more like you're expecting?  vma_to_pfn() is specific to

The gpu mmap will not come thru this ioctl path into the hyperv driver.

> uses vm_pgoff more like you're expecting?  vma_to_pfn() is specific to
> the vfio-pci-core semantics, it's not portable to expose for other use
> cases.  Thanks,

Ok. Will think of alternate way, just thought would check before going 
that route. 

Thanks,
-Mukesh

> 
> Alex


