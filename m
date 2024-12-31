Return-Path: <kvm+bounces-34423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C72C9FF049
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 16:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5F4A3A1C83
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 15:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7CB192B85;
	Tue, 31 Dec 2024 15:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="FCFhtfBf"
X-Original-To: kvm@vger.kernel.org
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF20416426
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735659874; cv=none; b=FepcCFa3N/WL53L60DEjb4EWLOdmj9IehrmKqkr5rGJNvf81Mmo4tKkUXdt0QrXOfOywtqKRLrH3nZtZmF7nR2WEXCxRAVqFfz6vdr0qhIHGSxGMop/Fgc8q2GQeObASleGoAVITRGXiRfzfjFJwBcFyVe9mor6YDy64Z9X/yM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735659874; c=relaxed/simple;
	bh=pcso5QigbbAnuT+DuyzSaPqrZyUWD4UHqT822PHDIUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WnF/fxAgCn/AL5qnfh+jhkSkPCTmN5tZmeumc7QlF8xKlNNsQrP39VafujhYZD53CB97BH/PYskI1eRvx0w5f1rt5KF964Z77n/KJo1EKZx0f6LcvBgUx85xb1qW5UMw8v2S7zIGRmOrDIO1vopwfDSKyuK2QujMPqZOuIOiyHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=FCFhtfBf; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 067C2240101
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 16:44:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1735659869; bh=pcso5QigbbAnuT+DuyzSaPqrZyUWD4UHqT822PHDIUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:Content-Type:
	 Content-Transfer-Encoding:From;
	b=FCFhtfBfFE+eYx+KL359vZ2RNQuAvRTS38ocLKWrcB9iQa4s6/CS9+8DT5nwgNNRw
	 yD7qJ+YEP5fqvO/Xvzwf0Yn0g6B9Yp05yXu/tJUjFJsI0Cgy31CF+70HHKgszwWjte
	 2/AC0N5EoCpUNgwfBHaJ9CkXIyFPe8uZBCFqw2Jd1d/0uf+T4+PhYLvu71AWkkjGlT
	 6CgyvdDR9fnRU0B1jxSXnw0cIKRHxhSPqeIXcGK7+gTs42YisWjRGbVi8jxmRuRgaV
	 eXx5HKd88o9YR7GKpbiP/XJsJKadMa0obWdBQSU1aDgv03UdCZ7/K+Gm83YrbzlfNF
	 j9VcYA1qPCxEg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YMy2N2jMJz9rxD;
	Tue, 31 Dec 2024 16:44:28 +0100 (CET)
Message-ID: <bba03a61-9504-40d0-9b2c-115b4f70e8ca@posteo.de>
Date: Tue, 31 Dec 2024 15:44:13 +0000
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
Content-Language: en-US
From: Precific <precification@posteo.de>
In-Reply-To: <20241230182737.154cd33a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 31.12.24 02:27, Alex Williamson wrote:
> On Mon, 30 Dec 2024 21:03:30 +0000
> Precific <precification@posteo.de> wrote:
> 
>> In my case, commenting out (1) the huge_fault callback assignment from
>> f9e54c3a2f5b suffices for GPU initialization in the guest, even if (2)
>> the 'install everything' loop is still removed.
>>
>> I have uploaded host kernel logs with vfio-pci-core debugging enabled
>> (one log with stock sources, one large log with vfio-pci-core's
>> huge_fault handler patched out):
>> https://bugzilla.kernel.org/show_bug.cgi?id=219619#c1
>> I'm not sure if the logs of handled faults say much about what
>> specifically goes wrong here, though.
>>
>> The dmesg portion attached to my mail is of a Linux guest failing to
>> initialize the GPU (BAR 0 size 16GB with 12GB of VRAM).
> 
> Thanks for the logs with debugging enabled.  Would you be able to
> repeat the test with QEMU 9.2?  There's a patch in there that aligns
> the mmaps, which should avoid mixing 1G and 2MB pages for huge faults.
> With this you should only see order 18 mappings for BAR0.
> 
> Also, in a different direction, it would be interesting to run tests
> disabling 1G huge pages and 2MB huge pages independently.  The
> following would disable 1G pages:
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1ab58da9f38a..dd3b748f9d33 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1684,7 +1684,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
>   							     PFN_DEV), false);
>   		break;
>   #endif
> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +#if 0
>   	case PUD_ORDER:
>   		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
>   							     PFN_DEV), false);
> 
> This should disable 2M pages:
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1ab58da9f38a..d7dd359e19bb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1678,7 +1678,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
>   	case 0:
>   		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
>   		break;
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +#if 0
>   	case PMD_ORDER:
>   		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
>   							     PFN_DEV), false);
> 
> And applying both together should be functionally equivalent to
> pre-v6.12.  Thanks,
> 
> Alex
> 

Logs with QEMU 9.1.2 vs. 9.2.0, all huge_page sizes/1G only/2M only: 
https://bugzilla.kernel.org/show_bug.cgi?id=219619#c3

You're right, I was still using QEMU 9.1.2. With 9.2.0, the 
passed-through GPU works fine indeed with both Linux and Windows guests.

The huge_fault calls are aligned nicely with QEMU 9.2.0. Only the lower 
16MB of BAR 0 see repeated calls at 2M/4K page sizes but no misalignment.
The QEMU 9.1.2 'stock' log shows a misalignment with 1G faults (order 
18), e.g., huge_faulting 0x40000 pages at page offset 0 and later 
0x4000. I'm not sure if that is a problem, or if the offsets are simply 
masked off to the correct alignment.
QEMU 9.1.2 also works with 1G pages disabled. Perhaps coincidentally, 
the offsets are aligned properly for order 9 (0x200 'page offset' 
increments) from what I've seen.

Thanks,
Precific

