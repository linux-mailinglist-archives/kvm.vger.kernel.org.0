Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B257046DAAD
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 19:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbhLHSID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 13:08:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232619AbhLHSIC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 13:08:02 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8HrN1F009069;
        Wed, 8 Dec 2021 18:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lcsH5uBVVZ7wWcQqhdR9FrF4NMNzd0QUAXCBwgL+e+4=;
 b=ofD5GIq5Yvj1g7T3Jo0Ork/ZFHc9YtkBQmj2YHuycdL0lV4/RogYGFBE74vkZGj8Yrn3
 bJm4K6EBkm4bXrvKbA4glI5sletZqomaFPinw4lAvPqDEQil/zHFM7hFLEdKKW8YFTtr
 r6CixBySJN9qcdXXjRGeHmXYEc+aMv6QLjBs//T6JINdQrc1MpT5/XoYWDrbkFHWJMu+
 4H9C9DZLa1NiXpdU9GP2KabQcVA8I9nks67gH8spMvtB1d0ewdpvVYziY8OglcqnJeBg
 rdQwrDtGENqwmT+4NDEyQX09O+cKcpza/6o9mFsLmNSqSw9bDPaed7H54liE9dNWXcc1 mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cu1gjr6as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:04:30 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8Ht2Xp012428;
        Wed, 8 Dec 2021 18:04:29 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cu1gjr6ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:04:29 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8I1uUr030500;
        Wed, 8 Dec 2021 18:04:29 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3cqyybtr57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:04:28 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8I4R9E21038002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 18:04:27 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6D36B206B;
        Wed,  8 Dec 2021 18:04:26 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D10DEB205F;
        Wed,  8 Dec 2021 18:04:21 +0000 (GMT)
Received: from [9.211.152.43] (unknown [9.211.152.43])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 18:04:21 +0000 (GMT)
Message-ID: <e54bd244-06eb-6217-8511-4867df085ff5@linux.ibm.com>
Date:   Wed, 8 Dec 2021 13:04:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-24-mjrosato@linux.ibm.com>
 <fc3c836ccb697a7e7123ab70015bd2a40b7cb5d4.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <fc3c836ccb697a7e7123ab70015bd2a40b7cb5d4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2BcVULNEX31Tx4Wn_41d_L4khGm7Lz1t
X-Proofpoint-ORIG-GUID: nuAJZYHxFSAYTbfaOZNPzm1XLLKoCcvE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 5:30 AM, Niklas Schnelle wrote:
> On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
>> Add a routine that will perform a shadow operation between a guest
>> and host IOAT.  A subsequent patch will invoke this in response to
>> an 04 RPCIT instruction intercept.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h |   1 +
>>   arch/s390/include/asm/pci_dma.h |   1 +
>>   arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h             |   4 +-
>>   4 files changed, 196 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
>> index 254275399f21..97e3a369135d 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -30,6 +30,7 @@ struct kvm_zdev_ioat {
>>   struct kvm_zdev {
>>   	struct zpci_dev *zdev;
>>   	struct kvm *kvm;
>> +	u64 rpcit_count;
>>   	struct kvm_zdev_ioat ioat;
>>   	struct zpci_fib fib;
>>   };
>> diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
>> index e1d3c1d3fc8a..0ca15e5db3d9 100644
>> --- a/arch/s390/include/asm/pci_dma.h
>> +++ b/arch/s390/include/asm/pci_dma.h
>> @@ -52,6 +52,7 @@ enum zpci_ioat_dtype {
>>   #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
>>   #define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
>>   #define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
>> +#define ZPCI_TABLE_ENTRIES_PER_PAGE	(ZPCI_TABLE_ENTRIES / ZPCI_TABLE_PAGES)
>>   
>>   #define ZPCI_TABLE_BITS			11
>>   #define ZPCI_PT_BITS			8
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index a1c0c0881332..858c5ecdc8b9 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -123,6 +123,195 @@ int kvm_s390_pci_aen_init(u8 nisc)
>>   	return rc;
>>   }
>>   
>> +static int dma_shadow_cpu_trans(struct kvm_vcpu *vcpu, unsigned long *entry,
>> +				unsigned long *gentry)
>> +{
>> +	unsigned long idx;
>> +	struct page *page;
>> +	void *gaddr = NULL;
>> +	kvm_pfn_t pfn;
>> +	gpa_t addr;
>> +	int rc = 0;
>> +
>> +	if (pt_entry_isvalid(*gentry)) {
>> +		/* pin and validate */
>> +		addr = *gentry & ZPCI_PTE_ADDR_MASK;
>> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
>> +		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
>> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>> +		if (is_error_page(page))
>> +			return -EIO;
>> +		gaddr = page_to_virt(page) + (addr & ~PAGE_MASK);
> 
> Hmm, this looks like a virtual vs physical address mixup to me that is
> currently not a problem because kernel virtual addresses are equal to
> their physical address. Here page_to_virt(page) gives us a virtual
> address but the entries in the I/O translation table have to be
> physical (aka absolute) addresses.
> 
> With my commit "s390/pci: use physical addresses in DMA tables"
> currently in the s390 feature branch this is also reflected in the
> argument types taken by set_pt_pfaa() below so gaddr should have type
> phys_addr_t not void *. That should also remove the need for the cast
> to unsigned long for the duplicate check.

Right...  Like the other comment re: virtual vs physical address I will 
take a look and fix for v2.
