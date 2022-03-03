Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC264CC2E7
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiCCQf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiCCQfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:35:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B4919D625;
        Thu,  3 Mar 2022 08:35:09 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 223FYL6m029580;
        Thu, 3 Mar 2022 16:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kyNnkeY8Gy4ifF+1VGK3DjLp4TltFaXv9ZWzfG9umSo=;
 b=cE1E8nGhQhmKzHsPjVcspkrhuWUduvYD/5r7KpY2kz22XfCPUDJGshwPt1j+V3gRBSZ3
 to1A0pmJ/xX6lk4DLJldK+rpdnCeCfxinU4GtneaskYXggk7iQ5e57/6tFfYLKEoJeOQ
 tg0UzIU2ScUE/0+tSF7xrveZUtvDWzh8z35I7zqTuRAJjkusxoQresrlR7Yzj5z1GkVV
 T1PlgsawkiYvPsU1O6iyMs8KtvLoa73b+UN4SQoxhE7P+xgB1IRWO5M9x1h0soWJa5sC
 IvO286d87EQQrbJOtmDRWyRUILbWzp/j1fqwYHnhxEzYCgvw2kBj64oqj0pz6As/uMCl Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejxetvk13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:35:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 223Fu7fB016321;
        Thu, 3 Mar 2022 16:35:09 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejxetvjyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:35:08 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 223GIvDw015229;
        Thu, 3 Mar 2022 16:35:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3efbu9gnp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 16:35:06 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 223GZ0FW53805356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Mar 2022 16:35:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EAF0A4053;
        Thu,  3 Mar 2022 16:35:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B2A4A4051;
        Thu,  3 Mar 2022 16:35:00 +0000 (GMT)
Received: from [9.171.88.22] (unknown [9.171.88.22])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Mar 2022 16:35:00 +0000 (GMT)
Message-ID: <e3e768d6-08f5-c38d-b73d-2d9cbdfc38dc@linux.ibm.com>
Date:   Thu, 3 Mar 2022 17:34:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v8 01/17] KVM: s390: pv: leak the topmost page table when
 destroy fails
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
 <20220302181143.188283-2-imbrenda@linux.ibm.com>
 <ff7291c0-e762-9fe9-4181-e62125bf2f59@linux.ibm.com>
 <20220303160547.391db6d9@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220303160547.391db6d9@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CfZ_ZyCS6CQawhAwktE2TGafWefmC7kK
X-Proofpoint-ORIG-GUID: XynVGE12FRI1Fxn1uTot4iONM0wJdaYE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 16:05, Claudio Imbrenda wrote:
> On Thu, 3 Mar 2022 15:40:42 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> On 3/2/22 19:11, Claudio Imbrenda wrote:
>>> Each secure guest must have a unique ASCE (address space control
>>> element); we must avoid that new guests use the same page for their
>>> ASCE, to avoid errors.
>>>
>>> Since the ASCE mostly consists of the address of the topmost page table
>>> (plus some flags), we must not return that memory to the pool unless
>>> the ASCE is no longer in use.
>>>
>>> Only a successful Destroy Secure Configuration UVC will make the ASCE
>>> reusable again.
>>>
>>> If the Destroy Configuration UVC fails, the ASCE cannot be reused for a
>>> secure guest (either for the ASCE or for other memory areas). To avoid
>>> a collision, it must not be used again. This is a permanent error and
>>> the page becomes in practice unusable, so we set it aside and leak it.
>>> On failure we already leak other memory that belongs to the ultravisor
>>> (i.e. the variable and base storage for a guest) and not leaking the
>>> topmost page table was an oversight.
>>>
>>> This error (and thus the leakage) should not happen unless the hardware
>>> is broken or KVM has some unknown serious bug.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Fixes: 29b40f105ec8d55 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
>>> ---
>>>  arch/s390/include/asm/gmap.h |  2 +
>>>  arch/s390/kvm/pv.c           |  9 +++--
>>>  arch/s390/mm/gmap.c          | 71 ++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 79 insertions(+), 3 deletions(-)
>>>   
>> [...]
>>
>>> +/**
>>> + * s390_replace_asce - Try to replace the current ASCE of a gmap with
>>> + * another equivalent one.
>>> + * @gmap the gmap
>>> + *
>>> + * If the allocation of the new top level page table fails, the ASCE is not
>>> + * replaced.
>>> + * In any case, the old ASCE is always removed from the list. Therefore the
>>> + * caller has to make sure to save a pointer to it beforehands, unless an
>>> + * intentional leak is intended.
>>> + */
>>> +int s390_replace_asce(struct gmap *gmap)
>>> +{
>>> +	unsigned long asce;
>>> +	struct page *page;
>>> +	void *table;
>>> +
>>> +	s390_remove_old_asce(gmap);
>>> +
>>> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
>>> +	if (!page)
>>> +		return -ENOMEM;
>>> +	table = page_to_virt(page);
>>> +	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));  
>>
>> Is concurrent modification of *gmap->table possible during the copy?
> 
> that would only be possible if the guest touches memory in such way
> that the table needs to be changed.
> 
> this function is only called when the guest is not running (e.g. during
> reboot), so nobody should touch the table

Is that asserted?
I guess if modifications to the table are block concurrent and entries are only
freed when the vm is destroyed you cannot intentionally do any funny business.
> 
>>
>>> +
>>> +	/*
>>> +	 * The caller has to deal with the old ASCE, but here we make sure
>>> +	 * the new one is properly added to the list of page tables, so that
>>> +	 * it will be freed when the VM is torn down.
>>> +	 */
>>> +	spin_lock(&gmap->guest_table_lock);
>>> +	list_add(&page->lru, &gmap->crst_list);
>>> +	spin_unlock(&gmap->guest_table_lock);
>>> +
>>> +	/* Set new table origin while preserving existing ASCE control bits */
>>> +	asce = (gmap->asce & _ASCE_ORIGIN) | __pa(table);
>>> +	WRITE_ONCE(gmap->asce, asce);
>>> +	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
>>> +	WRITE_ONCE(gmap->table, table);
>>> +
>>> +	return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(s390_replace_asce);  
>>
> 

