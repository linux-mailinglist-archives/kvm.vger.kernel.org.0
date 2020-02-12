Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D061015A906
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgBLMXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:23:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726146AbgBLMXB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 07:23:01 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CCKLwA023048
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 07:22:59 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1u1mgj9s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 07:22:59 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 12 Feb 2020 12:22:57 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Feb 2020 12:22:55 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01CCMr0846661906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Feb 2020 12:22:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86C494C058;
        Wed, 12 Feb 2020 12:22:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D7034C04A;
        Wed, 12 Feb 2020 12:22:53 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.71])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Feb 2020 12:22:53 +0000 (GMT)
Subject: Re: [PATCH v2 RFC] KVM: s390/interrupt: do not pin adapter interrupt
 pages
To:     David Hildenbrand <david@redhat.com>
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com,
        akpm@linux-foundation.org, cohuck@redhat.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
References: <567B980B-BDA5-4EF3-A96E-1542D11F2BD4@redhat.com>
 <20200211092341.3965-1-borntraeger@de.ibm.com>
 <01d1c188-38fb-e405-83d7-6184adccba5a@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 12 Feb 2020 13:22:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <01d1c188-38fb-e405-83d7-6184adccba5a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20021212-0016-0000-0000-000002E620AF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021212-0017-0000-0000-000033491BDB
Message-Id: <b72359a7-fb4b-6862-33e2-5cba9d48ab56@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_06:2020-02-11,2020-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=577 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002120100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.02.20 13:16, David Hildenbrand wrote:
> 
>> +	/*
>> +	 * We resolve the gpa to hva when setting the IRQ routing. If userspace
>> +	 * decides to mess with the memslots it better also updates the irq
>> +	 * routing. Otherwise we will write to the wrong userspace address.
>> +	 */
> 
> I guess this is just as old handling, where a page was pinned. But
> slightly better :) So the pages are definitely part of guest memory.
> 
> Fun stuff: If (a nasty) guest (in current code) zappes this page using
> balloon inflation and the page is re-accessed (e.g., by the guest or by
> the host), a new page will be faulted in, and there will be an
> inconsistency between what the guest/user space sees and what this code
> sees. Going via the user space address looks cleaner.
> 
> Now, with postcopy live migration, we will also zap all guest memory
> before starting the guest, I do wonder if that produces a similar
> inconsistency ... usually, when pages are pinned in the kernel, we
> inhibit the balloon and implicitly also postcopy.
> 
> If so, this actually fixes an issue. But might depend on the order
> things are initialized in user space. Or I am messing up things :)

Yes, the current code has some corner cases where a guest can shoot himself
in the foot. This variant could actually be safer. 
> 
> [...]
> 
>>  static int kvm_s390_adapter_unmap(struct kvm *kvm, unsigned int id, __u64 addr)
>>  {
>> -	struct s390_io_adapter *adapter = get_io_adapter(kvm, id);
>> -	struct s390_map_info *map, *tmp;
>> -	int found = 0;
>> -
>> -	if (!adapter || !addr)
>> -		return -EINVAL;
>> -
>> -	down_write(&adapter->maps_lock);
>> -	list_for_each_entry_safe(map, tmp, &adapter->maps, list) {
>> -		if (map->guest_addr == addr) {
>> -			found = 1;
>> -			atomic_dec(&adapter->nr_maps);
>> -			list_del(&map->list);
>> -			put_page(map->page);
>> -			kfree(map);
>> -			break;
>> -		}
>> -	}
>> -	up_write(&adapter->maps_lock);
>> -
>> -	return found ? 0 : -EINVAL;
>> +	return 0;
> 
> Can we get rid of this function?

And do a return in the handler? maybe yes. Will have a look.
> 
>>  }
> 
>> +static struct page *get_map_page(struct kvm *kvm,
>> +				 struct s390_io_adapter *adapter,
>> +				 u64 uaddr)
>>  {
>> -	struct s390_map_info *map;
>> +	struct page *page;
>> +	int ret;
>>  
>>  	if (!adapter)
>>  		return NULL;
>> -
>> -	list_for_each_entry(map, &adapter->maps, list) {
>> -		if (map->guest_addr == addr)
>> -			return map;
>> -	}
>> -	return NULL;
>> +	page = NULL;
> 
> struct page *page = NULL;
> 
>> +	if (!uaddr)
>> +		return NULL;
>> +	down_read(&kvm->mm->mmap_sem);
>> +	ret = get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
>> +				    &page, NULL, NULL);
>> +	if (ret < 1)
>> +		page = NULL;
> 
> Is that really necessary? According to the doc, pinned pages are stored
> to the array.  ret < 1 means "no pages" were pinned, so nothing should
> be stored.

Probably. Will have a look.

