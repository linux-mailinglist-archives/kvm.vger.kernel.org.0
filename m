Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87646165ED5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgBTNbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:31:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726959AbgBTNbi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:31:38 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KDUKv4072403
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 08:31:38 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8uc1a2c4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 08:31:37 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 20 Feb 2020 13:31:36 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 13:31:33 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KDVVdV65798334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 13:31:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B445611C052;
        Thu, 20 Feb 2020 13:31:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BDF711C04A;
        Thu, 20 Feb 2020 13:31:31 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.146.44])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 13:31:31 +0000 (GMT)
Subject: Re: [PATCH v2 02/42] KVM: s390/interrupt: do not pin adapter
 interrupt pages
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
 <20200214222658.12946-3-borntraeger@de.ibm.com>
 <073d3666-480e-5ba5-a46b-4cbd615f4174@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 20 Feb 2020 14:31:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <073d3666-480e-5ba5-a46b-4cbd615f4174@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022013-0028-0000-0000-000003DCC4FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022013-0029-0000-0000-000024A1D4FE
Message-Id: <45954200-ccfe-cfac-200d-d1b903d9fc39@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_04:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=2 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.02.20 10:43, David Hildenbrand wrote:
> On 14.02.20 23:26, Christian Borntraeger wrote:
>> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>>
>> The adapter interrupt page containing the indicator bits is currently
>> pinned. That means that a guest with many devices can pin a lot of
>> memory pages in the host. This also complicates the reference tracking
>> which is needed for memory management handling of protected virtual
>> machines. It might also have some strange side effects for madvise
>> MADV_DONTNEED and other things.
>>
>> We can simply try to get the userspace page set the bits and free the
>> page. By storing the userspace address in the irq routing entry instead
>> of the guest address we can actually avoid many lookups and list walks
>> so that this variant is very likely not slower.
>>
>> If userspace messes around with the memory slots the worst thing that
>> can happen is that we write to some other memory within that process.
>> As we get the the page with FOLL_WRITE this can also not be used to
>> write to shared read-only pages.
>>
>> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>> [borntraeger@de.ibm.com: patch simplification]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  Documentation/virt/kvm/devices/s390_flic.rst |  11 +-
>>  arch/s390/include/asm/kvm_host.h             |   3 -
>>  arch/s390/kvm/interrupt.c                    | 170 ++++++-------------
>>  3 files changed, 53 insertions(+), 131 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/devices/s390_flic.rst b/Documentation/virt/kvm/devices/s390_flic.rst
>> index 954190da7d04..ea96559ba501 100644
>> --- a/Documentation/virt/kvm/devices/s390_flic.rst
>> +++ b/Documentation/virt/kvm/devices/s390_flic.rst
>> @@ -108,16 +108,9 @@ Groups:
>>        mask or unmask the adapter, as specified in mask
>>  
>>      KVM_S390_IO_ADAPTER_MAP
>> -      perform a gmap translation for the guest address provided in addr,
>> -      pin a userspace page for the translated address and add it to the
>> -      list of mappings
>> -
>> -      .. note:: A new mapping will be created unconditionally; therefore,
>> -	        the calling code should avoid making duplicate mappings.
>> -
>> +      This is now a no-op. The mapping is purely done by the irq route.
>>      KVM_S390_IO_ADAPTER_UNMAP
>> -      release a userspace page for the translated address specified in addr
>> -      from the list of mappings
>> +      This is now a no-op. The mapping is purely done by the irq route.
>>  
> 
> The interface should have accepted a hva from the very start and not
> guest addresses ...

right, but that is history. 

> 
> [...]

>> +	/*
>> +	 * We resolve the gpa to hva when setting the IRQ routing. the set_irq
>> +	 * code uses get_user_pages_remote to do the actual write.
> 
> nit: "get_user_pages_remote()"

ack.

> 
>> +	 */
>>  	case KVM_S390_IO_ADAPTER_MAP:
>> -		ret = kvm_s390_adapter_map(dev->kvm, req.id, req.addr);
>> -		break;
>>  	case KVM_S390_IO_ADAPTER_UNMAP:
>> -		ret = kvm_s390_adapter_unmap(dev->kvm, req.id, req.addr);
>> -		break;
>> +		return 0;
>>  	default:
>>  		ret = -EINVAL;
>>  	}
>> @@ -2699,19 +2622,21 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>>  	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>>  }
>>  
>> -static struct s390_map_info *get_map_info(struct s390_io_adapter *adapter,
>> -					  u64 addr)
>> +static struct page *get_map_page(struct kvm *kvm,
>> +				 struct s390_io_adapter *adapter,
>> +				 u64 uaddr)
>>  {
>> -	struct s390_map_info *map;
>> +	struct page *page = NULL;
>>  
>>  	if (!adapter)
>>  		return NULL;
> 
> AFAIKs, this check is not necessary.

Right otherwise we would crash earlier.


> 
>> -
>> -	list_for_each_entry(map, &adapter->maps, list) {
>> -		if (map->guest_addr == addr)
>> -			return map;
>> -	}
>> -	return NULL;
>> +	if (!uaddr)
>> +		return NULL;
> 
> I do wonder if that check is necessary. I don't think so but might be
> missing something.

Nothing should break when we remove this check. get_user_pages_remote will
also return NULL (as newer kernels usually forbid mapping things at 0).

Will remove. 

[...]

>> @@ -2818,23 +2746,27 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>  			  struct kvm_kernel_irq_routing_entry *e,
>>  			  const struct kvm_irq_routing_entry *ue)
>>  {
>> -	int ret;
>> +	u64 uaddr;
>>  
>>  	switch (ue->type) {
>> +	/* we store the userspace addresses instead of the guest addresses */
>>  	case KVM_IRQ_ROUTING_S390_ADAPTER:
>>  		e->set = set_adapter_int;
>> -		e->adapter.summary_addr = ue->u.adapter.summary_addr;
>> -		e->adapter.ind_addr = ue->u.adapter.ind_addr;
>> +		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr);
>> +		if (uaddr == -EFAULT)
>> +			return -EFAULT;
>> +		e->adapter.summary_addr = uaddr;
>> +		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.ind_addr);
>> +		if (uaddr == -EFAULT)
>> +			return -EFAULT;
> 
> AFAIK, leaving e->adapter.summary_addr set is not an issue.
> 
> Interesting, in kvm_s390_adapter_map(), we didn't synchronize again slot
> updates when doing the gmap_translate(), which looks wrong to me ...
> 
> It seems to be the same thing here. I do wonder if it is safe to do a
> gmap_translate() here, looks like this can race with
> kvm_arch_commit_memory_region().
> 
> I would have assumed we need e.g., the slots_lock while doing the
> gmap_translate() - or a srcu_read_lock(&vcpu->kvm->srcu) or similar ...

gmap_translate does this via the gmap and it holds the mm sem. gmap_unmap_segment
takes the same lock. So I think we are ok here.
 
> 
> Apart from that, looks good to me.
> 

