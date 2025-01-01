Return-Path: <kvm+bounces-34427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBCF9FF2BE
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 04:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA2E6161BEC
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 03:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22111372;
	Wed,  1 Jan 2025 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="bD0KdGps"
X-Original-To: kvm@vger.kernel.org
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2F383
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 03:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735701017; cv=none; b=KN02Rd3VgCcW74gZ18+b9ZbVJNkwPF6/A+OZmYu8znlOUTik+gAVKXi4xfGrnBUlL+cj2vj3NOIZ2wsL3tVHb4cQvwCDdt2AZ0i8amcgqVfWjWpjb3bDTGRpmC0WhzzfF+9fC1BhErFd6qc4Cx8WHkIRIsdZpeVkqGjj+1Kaexw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735701017; c=relaxed/simple;
	bh=iCQaz3kqb1/F5CrgaMemtQHzFCU9H2hYKKe/8iXkCgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSzEX6gNK6ebOoeo6zP1za/NxaihgrazpbsHkHOdXkGbJRWsJgHYgiwyULK02rOZGMQBirEVc6bGIb513T8wg7xDFHj3OxLk70JV9eB1U2pgYHiZNBu+erLJfpClV3VYEVL4tpqIN+ps2E0Xo4WvY2ENWrzu1JjXd7VDJ3XxS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=bD0KdGps; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id CD32A240028
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 04:10:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1735701007; bh=iCQaz3kqb1/F5CrgaMemtQHzFCU9H2hYKKe/8iXkCgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:Content-Type:
	 Content-Transfer-Encoding:From;
	b=bD0KdGpsDQF/I3AylRz2hieRGIiQo/OBmu67JtprIhIiPzTizAh0irgdUd6uUX6jv
	 N46yavUqYJw9szxE1WAJDQwJNsOvh+f+xMn1HkvzR0cdLAYvMAglfJxYvOLGQeDcFr
	 10VWu92+0Rir77/MYW5tq30+brBt9xCqV5T8eKO9OvxrpyyhARam9sNxDM18uaTLFo
	 UPySJVOg6nyOCyK9Y2z3qdAmXmJQW8ffWeo/8uXJpCz4Rh66J1x7o6OaYylvnEDOcy
	 S5I8netzD9PAr2p8SU4CYTEu0n8VftoNURLiJ3GiTdVICc0lrU1MNO7qxWsUxtWbZh
	 AI65qV4YCzHKQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YNFFW08lBz9rxF;
	Wed,  1 Jan 2025 04:10:07 +0100 (CET)
Message-ID: <d8355707-7b81-49ef-930e-1bf7e5159f35@posteo.de>
Date: Wed,  1 Jan 2025 03:10:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [bugzilla-daemon@kernel.org: [Bug 219619] New: vfio-pci: screen
 graphics artifacts after 6.12 kernel upgrade]
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Peter Xu <peterx@redhat.com>,
 Athul Krishna <athul.krishna.kr@protonmail.com>,
 Bjorn Helgaas <helgaas@kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20241222223604.GA3735586@bhelgaas>
 <Hb6kvXlGizYbogNWGJcvhY3LsKeRwROtpRluHKsGqRcmZl68J35nP60YdzW1KSoPl5RO_dCxuL5x9mM13jPBbU414DEZE_0rUwDNvzuzyb8=@protonmail.com>
 <Z2mW2k8GfP7S0c5M@x1n> <16ea1922-c9ce-4d73-b9b6-8365ca3fcf32@posteo.de>
 <20241230182737.154cd33a.alex.williamson@redhat.com>
 <bba03a61-9504-40d0-9b2c-115b4f70e8ca@posteo.de>
 <20241231090733.5cc5504a.alex.williamson@redhat.com>
Content-Language: en-US
From: Precific <precification@posteo.de>
In-Reply-To: <20241231090733.5cc5504a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31.12.24 17:07, Alex Williamson wrote:
>  
> Thank you so much for your testing, this is immensely helpful!  This
> all suggests to me we're dealing with an alignment issue for 1GB pages.
> We're getting 2MB alignment on the mmap by default, so that's working
> everywhere.  QEMU 9.2 provides us with proper 1GB alignment, but it
> seems we need to filter alignment more strictly when that's not present.
> Please give this a try with QEMU 9.1.x and an otherwise stock v6.12.x:
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1ab58da9f38a..bdfdc8ee4c2b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1661,7 +1661,8 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
>   	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
>   	vm_fault_t ret = VM_FAULT_SIGBUS;
>   
> -	if (order && (vmf->address & ((PAGE_SIZE << order) - 1) ||
> +	if (order && (pgoff & ((1 << order) - 1) ||
> +		      vmf->address & ((PAGE_SIZE << order) - 1) ||
>   		      vmf->address + (PAGE_SIZE << order) > vma->vm_end)) {
>   		ret = VM_FAULT_FALLBACK;
>   		goto out;
> 
> 
> Thanks,
> Alex
> 

Thank you, that does the trick. In my tests with your patch, the 
order=18 huge_faults from QEMU 9.1.2 all fall back to order=9 (in one 
case, even with pgoff=0, likely from the vmf->address check), while 
those from QEMU 9.2.0 succeed as before.
My Windows VM also is happy with the patched kernel 6.12.4 and QEMU 
9.1.2 so far.
For completeness' sake, here are the host logs with the patch applied, 
booting a Linux guest: https://bugzilla.kernel.org/show_bug.cgi?id=219619#c4

Thanks and Best wishes for the new year,
Precific

