Return-Path: <kvm+bounces-61006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC30C0578F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 64C315008A8
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 10:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A1A30E0E9;
	Fri, 24 Oct 2025 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TtWTR0/g"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1524729A;
	Fri, 24 Oct 2025 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761300219; cv=none; b=A55Tb5QCoGk6DUCWqchVlLe+Gbozu3KKWR5AGLQSRDuQKjV8iloNNtKbTV2kcJ1Clf0N090c91qdvJUve4ydW8MxLZV8NW0cGhS+Gad5jlOuB8Iq61wLLOGDJulT+tzD/0zfu1GhiUUXGJfQxQ9mVyjxOFn8WG6VCS/Ap1h36r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761300219; c=relaxed/simple;
	bh=bWFy3RfLl5gkL1nl2EiI/96beBie205E3ojhHV5cdkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEyLHfj7255IWl5AvZwIAlq1nLLx3y7H/myYWFSV1YLre4Q8/eMhz16+4ra1+Ml4UgSnOEi5rS4zJO43CLx3IzKfTiDQqwZdVqsaOwSKXpDVwc5QWW39evPCqvR0iQq/jnMdBixdLzR644H1hDW0tw2rirYrRp4dj370cVcbUyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TtWTR0/g; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761300206; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n+A2uFbKQefkDojLPPcK70ocgcvIwvNmJfoecA4EhpE=;
	b=TtWTR0/gomv86HpWrvXd6AXug+ACswu6NxbFi6pQB+ssw6+lfOd+NrANz7uB5pcA62aGDT8U3/kIG9/tan2S1W9+qoLDlBucbfVq72jvuirGumypVVj9O7LIFCTck7KIg89IlJJ5rIgDIimMSxUbO8WNHLo7z+N/rBbD7RaeWKQ=
Received: from 30.246.161.241(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqu2Tm1_1761300202 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 18:03:24 +0800
Message-ID: <134e43f7-583c-48c1-8ccc-dddc18700d3b@linux.alibaba.com>
Date: Fri, 24 Oct 2025 18:03:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
To: Ira Weiny <ira.weiny@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
 "ankita@nvidia.com" <ankita@nvidia.com>,
 "aniketa@nvidia.com" <aniketa@nvidia.com>, "Sethi, Vikram"
 <vsethi@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "mochs@nvidia.com" <mochs@nvidia.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
 "alex@shazbot.org" <alex@shazbot.org>
Cc: "cjia@nvidia.com" <cjia@nvidia.com>,
 "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
 "targupta@nvidia.com" <targupta@nvidia.com>,
 "zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com"
 <dnigam@nvidia.com>, "kjaju@nvidia.com" <kjaju@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Smita.KoralahalliChannabasappa@amd.com"
 <Smita.KoralahalliChannabasappa@amd.com>,
 "u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
 <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/22 23:03, Ira Weiny 写道:
> Shuai Xue wrote:
>>
>>
>> 在 2025/10/22 01:19, Luck, Tony 写道:
>>>>>       pfn = PHYS_PFN(physical_addr);
>>>>> -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
>>>>
>>>> Tony,
>>>>
>>>> I'm not an SGX expert but does this break SGX by removing
>>>> arch_is_platform_page()?
>>>>
>>>> See:
>>>>
>>>> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
>>>> Cc: Tony Luck <tony.luck@intel.com>
>>>>
>>> Ira,
>>>
>>> I think this deletion makes the GHES code always call memory_failure()
>>> instead of bailing out here on "bad" page frame numbers.
>>>
>>> That centralizes the checks for different types of memory into
>>> memory_failure().
>>>
>>> -Tony
>>
>> Hi, Tony, Ankit and Ira,
>>
>> Finally, we're seeing other use cases that need to handle errors for
>> non-struct page PFNs :)
>>
>> IMHO, non-struct page PFNs are common in production environments.
>> Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memory
>> managed by a separate VMEM allocator.
> 
> Can you elaborate on this more?

We reserve a significant portion of DRAM memory at boot time using
kernel command line parameters. This reserved memory is then managed by
our internal VMEM allocator, which handles memory allocation and
deallocation for virtual machines.

To minimize memory overhead, we intentionally avoid creating struct
pages for this reserved memory region. Instead, we've implemented the
following approach:

- Our VMEM allocator directly manages the physical memory without the
   overhead of struct page metadata.
- Error Handling: We register custom RAS operations (ras_ops) with the
   memory failure infrastructure. When poisoned memory is accessed within
   this region, our registered handler: Tags the affected memory area as
   poisoned Isolates the memory to prevent further access Terminates any
   tasks that were using the poisoned memory

This approach allows us to handle memory errors effectively while
maintaining minimal memory overhead for large reserved regions. It's
similar in concept to how device memory (like NVIDIA Grace GPU memory
mentioned earlier) needs error handling without struct page backing.

Thanks.
Shuai

