Return-Path: <kvm+bounces-71863-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QL4RGLM5n2m5ZQQAu9opvQ
	(envelope-from <kvm+bounces-71863-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:04:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAF419BFC1
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5135D317931D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F8F2E3397;
	Wed, 25 Feb 2026 18:01:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D010D2BFC7B;
	Wed, 25 Feb 2026 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042469; cv=none; b=JnTNHT3zY7PiNuuat/wE/iiqGxdEF5+zUk0RV1tRXF89ZncrEuoryixUdlvzT63oEp4j2R45B8BvtvLc3jtKpvhnEhVB5pfXcC7zF1jeOZKlvoNr0533ZoXY2XtIauDfZQJZI9J2Fl9MSz/AkJ/mGZWkrUiX153aBRN+WPASaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042469; c=relaxed/simple;
	bh=TFbc+GUeADGuSdjbQmqIPxN+gMoOKkRGcSTStzMjyJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUSFoLSr1YVP/kvSO+traA1Cf2sDE2fQ/nhNLFY3BnVflZynY7PkCpr9bgMe3AdWbI15PYZhgtGXj0KJACKElgXNyV9lMLA0vEcSDve1mz8ivQJkoo2vMAEvd2u+81/DfnejiKn6O4AuBORPBvEGdR9vE+cFk5i2SiPmJr8Tx7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFFA015A1;
	Wed, 25 Feb 2026 10:01:00 -0800 (PST)
Received: from [10.57.58.107] (unknown [10.57.58.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 162483F62B;
	Wed, 25 Feb 2026 10:00:57 -0800 (PST)
Message-ID: <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
Date: Wed, 25 Feb 2026 18:00:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
To: dan.j.williams@intel.com, Alexey Kardashevskiy <aik@amd.com>,
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
 Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Tony Luck <tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Denis Efremov <efremov@linux.com>, Geliang Tang <geliang@kernel.org>,
 Piotr Gregor <piotrgregor@rsyncme.org>, "Michael S. Tsirkin"
 <mst@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71863-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[robin.murphy@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_GT_50(0.00)[57];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,arm.com:mid,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0CAF419BFC1
X-Rspamd-Action: no action

On 2026-02-25 4:30 pm, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
>> SWIOTLB is enforced when encrypted guest memory is detected
>> in pci_swiotlb_detect() which is required for legacy devices.
>>
>> Skip SWIOTLB for TDISP devices.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   include/linux/swiotlb.h | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
>> index 3dae0f592063..119c25d639a7 100644
>> --- a/include/linux/swiotlb.h
>> +++ b/include/linux/swiotlb.h
>> @@ -173,6 +173,15 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
>>   {
>>   	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
>>   
>> +	/*
>> +	 * CC_ATTR_GUEST_MEM_ENCRYPT enforces SWIOTLB_FORCE in
>> +	 * swiotlb_init_remap() to allow legacy devices access arbitrary
>> +	 * VM encrypted memory.
>> +	 * Skip it for TDISP devices capable of DMA-ing the encrypted memory.
>> +	 */
>> +	if (device_cc_accepted(dev))
>> +		return false;
> 
> I worry this further muddies the meaning of the swiotlb force option.
> What if you want to force swiotlb operation on accepted devices?

For that we'd need a whole other private SWIOTLB plus the logic to 
decide which one to use in the first place. And if you really wanted an 
option to forcibly expose all DMA through shared memory regardless of 
TDISP and friends, that would logically want to be a higher-level CoCo 
option rather than belonging to SWIOTLB itself ;)

Thanks,
Robin.

> For example:
> 
> @@ -173,7 +176,13 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
>   {
>          struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
>   
> -       return mem && mem->force_bounce;
> +       if (!mem)
> +               return false;
> +       if (mem->force_bounce)
> +               return true;
> +       if (mem->bounce_unaccepted && !device_cc_accepted(dev))
> +               return true;
> +       return false;
>   }
>   
>   void swiotlb_init(bool addressing_limited, unsigned int flags);


