Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0712367C7BD
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 10:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbjAZJsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 04:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjAZJsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 04:48:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BBC10414;
        Thu, 26 Jan 2023 01:48:50 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q8dOuH003975;
        Thu, 26 Jan 2023 09:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4wNURVLbP2ljBC/00oVWIF8pNkYA7V4Qz19/rKe226o=;
 b=Z3k1JhE/PRJCDQyzjrPPDzNk4NFRDmMu6O5faJ7OFgbEPmaMQIZizpCK18Yi/nOrxROr
 RdirnebS042WcYff7KqEX78WdNdx9h4/qrhwl842xuc47cSjhLYvoMWGDRRqVLeyoA8f
 kfTOaF8mWW1GCnVXr8HuNK6Q/BKHRAme7eBKWBsTbVR6mj6w8wZ4Nu7gyVfCV6NVc8cq
 VrnwSrzbQcpwYr51d/6VpM/lpftukFPYjHffn7Gde6bGMnSx9CSzuPa079X4FtS907Oq
 Afcx+auIv3zAKU0zBkg7nAE8LKGZds2DlvO8angk1dYzXgqlFNEqx/LBBwNUMdXJqNjL Lw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nbktwv9r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 09:48:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30PHUZPq015740;
        Thu, 26 Jan 2023 09:48:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n87afe71n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 09:48:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30Q9mh4h44237230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 09:48:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8F3120043;
        Thu, 26 Jan 2023 09:48:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD66920040;
        Thu, 26 Jan 2023 09:48:43 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Jan 2023 09:48:43 +0000 (GMT)
Message-ID: <73262865-5f3e-d90d-b4c0-32349960c421@linux.ibm.com>
Date:   Thu, 26 Jan 2023 10:48:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230120075406.101436-1-nrb@linux.ibm.com>
 <2ef9a5df-cd05-8f27-f8ee-4c03f4c43d0d@linux.ibm.com>
 <167472247246.63544.9612120960891768862@t14-nrb.local>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1] KVM: s390: disable migration mode when dirty tracking
 is disabled
In-Reply-To: <167472247246.63544.9612120960891768862@t14-nrb.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mtu260DgXwrd3FPsuJr2KgJ0SdRW6023
X-Proofpoint-ORIG-GUID: mtu260DgXwrd3FPsuJr2KgJ0SdRW6023
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_03,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=430 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260091
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/23 09:41, Nico Boehr wrote:
> Quoting Janosch Frank (2023-01-25 14:55:59)
>> On 1/20/23 08:54, Nico Boehr wrote:
>>> Migration mode is a VM attribute which enables tracking of changes in
>>> storage attributes (PGSTE). It assumes dirty tracking is enabled on all
>>> memslots to keep a dirty bitmap of pages with changed storage attributes.
>>>
>>> When enabling migration mode, we currently check that dirty tracking is
>>> enabled for all memslots. However, userspace can disable dirty tracking
>>> without disabling migration mode.
>>>
>>> Since migration mode is pointless with dirty tracking disabled, disable
>>> migration mode whenever userspace disables dirty tracking on any slot.
>>
>> Will userspace be able to handle the sudden -EINVAL rcs on
>> KVM_S390_GET_CMMA_BITS and KVM_S390_SET_CMMA_BITS?
> 
> QEMU has proper error handling on the GET_CMMA_BITS code path and will not
> attempt GET_CMMA_BITS after it disabled dirty tracking. So yes, userspace can
> handle this fine. In addition, as mentioned in the commit, it was never allowed
> to have migration mode without dirty tracking. It was checked when migration
> mode is enabled, just wasn't enforced when dirty tracking went off. The
> alternative would be to refuse disabling dirty tracking when migration mode is
> on; and that would _really_ break userspace.
> 
> Or we just leave migration mode on and check on every emulation/ioctl that a
> dirty bitmap is still there, which would change absolutely nothing about the
> return value of GET_CMMA_BITS.
> 
> Or we allocate the dirty bitmap for storage attributes independent of the dirty
> bitmap for pages, which increases memory usage and makes this patch quite a bit
> more complex, risking that we break more than what is already broken.
> 
> This approach really seems like the sane option to me.

Jup, I'm just trying to consider all possibilities to find the best one 
and that includes asking all the questions.

>>>    
>>> +Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
>>> +dirty tracking is disabled on any memslot, migration mode is automatically
>>> +stopped.
>>
>> Do we also need to add a warning to the CMMA IOCTLs?
> 
> No, it is already documented there:
> 
>> This ioctl can fail with [...] > -EINVAL if KVM_S390_CMMA_PEEK is not set
>> but migration mode was not enabled

That's fine but doesn't include the part where migration mode can 
suddenly be disabled via a memory region change.

If we implicitly change migration mode disablement then we need to 
document that as much as possible to cover all bases.

> 
> [...]
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index e4890e04b210..4785f002cd93 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -5628,28 +5628,43 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>                                   enum kvm_mr_change change)
>>>    {
>>>        gpa_t size;
>>> +     int rc;
>>
>> Not sure why you added rc even though it doesn't need to be used.
> 
> You prefer a line which is 100 chars wide over a new variable? OK fine for me.

I'm not sure how you manage to get over 100 chars, did I miss something?


if (!kvm->arch.migration_mode)
	return 0;

if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
     !(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
	WARN(kvm_s390_vm_stop_migration(kvm),
	     "Migration mode could not be disabled");

return 0;

