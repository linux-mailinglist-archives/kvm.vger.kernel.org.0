Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6131582C1
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 19:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBJSjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 13:39:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727056AbgBJSjF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 13:39:05 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01AIKxoG113834
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 13:39:04 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tn52hxn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 13:39:04 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 10 Feb 2020 18:39:02 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 18:38:59 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01AIcvIU58654770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 18:38:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFFAA52052;
        Mon, 10 Feb 2020 18:38:57 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.7.195])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9A3A45204E;
        Mon, 10 Feb 2020 18:38:54 +0000 (GMT)
Subject: Re: [PATCH 02/35] KVM: s390/interrupt: do not pin adapter interrupt
 pages
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-3-borntraeger@de.ibm.com>
 <2cf62b84-8eb6-18d5-437b-7e86401b9c45@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 10 Feb 2020 19:38:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2cf62b84-8eb6-18d5-437b-7e86401b9c45@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021018-0028-0000-0000-000003D949B4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021018-0029-0000-0000-0000249DB671
Message-Id: <083a3fd0-7b56-e92b-bf15-3383b7f5488b@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_06:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.02.20 13:26, David Hildenbrand wrote:
> On 07.02.20 12:39, Christian Borntraeger wrote:
>> From: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>>
>> The adapter interrupt page containing the indicator bits is currently
>> pinned. That means that a guest with many devices can pin a lot of
>> memory pages in the host. This also complicates the reference tracking
>> which is needed for memory management handling of protected virtual
>> machines.
>> We can reuse the pte notifiers to "cache" the page without pinning it.
>>
>> Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
>> Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
> 
> So, instead of pinning explicitly, look up the page address, cache it,
> and glue its lifetime to the gmap table entry. When that entry is
> changed, invalidate the cached page. On re-access, look up the page
> again and register the gmap notifier for the table entry again.

I think I might want to split this into two parts.
part 1: a naive approach that always does get_user_pages_remote/put_page
part 2: do the complex caching

Ulrich mentioned that this actually could make the map/unmap a no-op as we
have the address and bit already in the irq route. In the end this might be
as fast as todays pinning as we replace a list walk with a page table walk. 
Plus it would simplify the code. Will have a look if that is the case.

> 
> [...]
> 
>>  #define MAX_S390_IO_ADAPTERS ((MAX_ISC + 1) * 8)
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index c06c89d370a7..4bfb2f8fe57c 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -28,6 +28,7 @@
>>  #include <asm/switch_to.h>
>>  #include <asm/nmi.h>
>>  #include <asm/airq.h>
>> +#include <linux/pagemap.h>
>>  #include "kvm-s390.h"
>>  #include "gaccess.h"
>>  #include "trace-s390.h"
>> @@ -2328,8 +2329,8 @@ static int register_io_adapter(struct kvm_device *dev,
>>  		return -ENOMEM;
>>  
>>  	INIT_LIST_HEAD(&adapter->maps);
>> -	init_rwsem(&adapter->maps_lock);
>> -	atomic_set(&adapter->nr_maps, 0);
>> +	spin_lock_init(&adapter->maps_lock);
>> +	adapter->nr_maps = 0;
>>  	adapter->id = adapter_info.id;
>>  	adapter->isc = adapter_info.isc;
>>  	adapter->maskable = adapter_info.maskable;
>> @@ -2375,19 +2376,15 @@ static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
>>  		ret = -EFAULT;
>>  		goto out;
>>  	}
>> -	ret = get_user_pages_fast(map->addr, 1, FOLL_WRITE, &map->page);
>> -	if (ret < 0)
>> -		goto out;
>> -	BUG_ON(ret != 1);
>> -	down_write(&adapter->maps_lock);
>> -	if (atomic_inc_return(&adapter->nr_maps) < MAX_S390_ADAPTER_MAPS) {
>> +	spin_lock(&adapter->maps_lock);
>> +	if (adapter->nr_maps < MAX_S390_ADAPTER_MAPS) {
>> +		adapter->nr_maps++;
>>  		list_add_tail(&map->list, &adapter->maps);
> 
> I do wonder if we should check for duplicates. The unmap path will only
> remove exactly one entry. But maybe this can never happen or is already
> handled on a a higher layer.


This would be a broken userspace, but I also do not see a what would break
in the host if this happens.


> 
>>  }
>> @@ -2430,7 +2426,6 @@ void kvm_s390_destroy_adapters(struct kvm *kvm)
>>  		list_for_each_entry_safe(map, tmp,
>>  					 &kvm->arch.adapters[i]->maps, list) {
>>  			list_del(&map->list);
>> -			put_page(map->page);
>>  			kfree(map);
>>  		}
>>  		kfree(kvm->arch.adapters[i]);
> 
> Between the gmap being removed in kvm_arch_vcpu_destroy() and
> kvm_s390_destroy_adapters(), the entries would no longer properly get
> invalidated. AFAIK, removing/freeing the gmap will not trigger any
> notifiers.
> 
> Not sure if that's an issue (IOW, if we can have some very weird race).
> But I guess we would have similar races already :)

This is only called when all file descriptors are closed and this also closes
all irq routes. So I guess no I/O should be going on any more. 

> 
>> @@ -2690,6 +2685,31 @@ struct kvm_device_ops kvm_flic_ops = {
>>  	.destroy = flic_destroy,
>>  };
>>  
>> +void kvm_s390_adapter_gmap_notifier(struct gmap *gmap, unsigned long start,
>> +				    unsigned long end)
>> +{
>> +	struct kvm *kvm = gmap->private;
>> +	struct s390_map_info *map, *tmp;
>> +	int i;
>> +
>> +	for (i = 0; i < MAX_S390_IO_ADAPTERS; i++) {
>> +		struct s390_io_adapter *adapter = kvm->arch.adapters[i];
>> +
>> +		if (!adapter)
>> +			continue;
> 
> I have to ask very dumb: How is kvm->arch.adapters[] protected?

We only add new ones and this is removed at guest teardown it seems.
[...]

Let me have a look if we can simplify this.

