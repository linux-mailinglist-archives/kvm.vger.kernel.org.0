Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E724B605ED0
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiJTL1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiJTL1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:27:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DE117C54B
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 04:27:31 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KBEmFY025527
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y6CysXKYbhWjulQVl1HqO36OJim3Ekyh24AqOyImG74=;
 b=RZtfZSlFUtqw6os5OJ0waawnidH6oU//uLGMhYGQZjLSun6LLvXXmpgwZP9Mdve/pyyK
 26m1/XZIqZqdTnxv47m7gtksXXmlUguig+jFA8g9f4sxiaMWCOoqnaRZXP+Orve8mfMN
 j+Mwr3fmavo7XKXl3Ndhi1OXbSq098siAcVw23HJK65/F9xnJTR7qBC9OIVJ6BeaQmnT
 FfrAzPfUxWQnJ3N6qi6DQjCFaK7MOU8UgfyGmbuyHTqWrEsXpJj18jKckVl6A3jYpLoZ
 gpQCcDiPyStKvNccVgHVidmZTe5MLV1piLsJiMgkLCM8yNtacpWOuA01sdCNPVDsCMKx Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb59rr9vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:27:29 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KBElDb025494
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:27:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb59rr9ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:27:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KBLULW027111;
        Thu, 20 Oct 2022 11:27:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98u6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 11:27:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KBRNHK2556424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 11:27:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43FB942042;
        Thu, 20 Oct 2022 11:27:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA4A342041;
        Thu, 20 Oct 2022 11:27:22 +0000 (GMT)
Received: from [9.171.57.143] (unknown [9.171.57.143])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 11:27:22 +0000 (GMT)
Message-ID: <23a68320-a5f1-8fc6-38cd-112ccaded844@linux.ibm.com>
Date:   Thu, 20 Oct 2022 13:27:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v2 5/7] lib: s390x: Use a new asce for each
 PV guest
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
References: <20221020090009.2189-1-frankja@linux.ibm.com>
 <20221020090009.2189-6-frankja@linux.ibm.com>
 <20221020112551.1034d160@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221020112551.1034d160@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wOJR1DZo9jXvqVbbZ2NMuZXYmQilva3S
X-Proofpoint-ORIG-GUID: 1wv2bzkeOl_F5W0y9Fm0MmdY36bFj0-C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 11:25, Claudio Imbrenda wrote:
> On Thu, 20 Oct 2022 09:00:07 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Every PV guest needs its own ASCE so let's copy the topmost table
>> designated by CR1 to create a new ASCE for the PV guest. Before and
>> after SIE we now need to switch ASCEs to and from the PV guest / test
>> ASCE. The SIE assembly function does that automatically.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm-offsets.c |  2 ++
>>   lib/s390x/sie.c         |  2 ++
>>   lib/s390x/sie.h         |  2 ++
>>   lib/s390x/uv.c          | 24 +++++++++++++++++++++++-
>>   lib/s390x/uv.h          |  5 ++---
>>   s390x/cpu.S             |  6 ++++++
>>   6 files changed, 37 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>> index fbea3278..f612f327 100644
>> --- a/lib/s390x/asm-offsets.c
>> +++ b/lib/s390x/asm-offsets.c
>> @@ -75,9 +75,11 @@ int main(void)
>>   	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
>>   	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
>>   	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
>> +	OFFSET(SIE_SAVEAREA_HOST_ASCE, vm_save_area, host.asce);
>>   	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
>>   	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
>>   	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
>> +	OFFSET(SIE_SAVEAREA_GUEST_ASCE, vm_save_area, guest.asce);
>>   	OFFSET(STACK_FRAME_INT_BACKCHAIN, stack_frame_int, back_chain);
>>   	OFFSET(STACK_FRAME_INT_FPC, stack_frame_int, fpc);
>>   	OFFSET(STACK_FRAME_INT_FPRS, stack_frame_int, fprs);
>> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
>> index 3fee3def..6efad965 100644
>> --- a/lib/s390x/sie.c
>> +++ b/lib/s390x/sie.c
>> @@ -85,6 +85,8 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
>>   
>>   	/* Guest memory chunks are always 1MB */
>>   	assert(!(guest_mem_len & ~HPAGE_MASK));
>> +	/* For non-PV guests we re-use the host's ASCE for ease of use */
>> +	vm->save_area.guest.asce = stctg(1);
>>   	/* Currently MSO/MSL is the easiest option */
>>   	vm->sblk->mso = (uint64_t)guest_mem;
>>   	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) & HPAGE_MASK);
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index 320c4218..3e3605c9 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -205,12 +205,14 @@ union {
>>   struct vm_uv {
>>   	uint64_t vm_handle;
>>   	uint64_t vcpu_handle;
>> +	uint64_t asce;
>>   	void *conf_base_stor;
>>   	void *conf_var_stor;
>>   	void *cpu_stor;
>>   };
>>   
>>   struct vm_save_regs {
>> +	uint64_t asce;
>>   	uint64_t grs[16];
>>   	uint64_t fprs[16];
>>   	uint32_t fpc;
>> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
>> index 3b4cafa9..0b6eb843 100644
>> --- a/lib/s390x/uv.c
>> +++ b/lib/s390x/uv.c
>> @@ -90,6 +90,25 @@ void uv_init(void)
>>   	initialized = true;
>>   }
>>   
>> +/*
>> + * Create a new ASCE for the UV config because they can't be shared
>> + * for security reasons. We just simply copy the top most table into a
>> + * fresh set of allocated pages and use those pages as the asce.
>> + */
>> +static uint64_t create_asce(void)
>> +{
>> +	void *pgd_new, *pgd_old;
>> +	uint64_t asce = stctg(1);
>> +
>> +	pgd_new = memalign_pages_flags(PAGE_SIZE, PAGE_SIZE * 4, 0);
> 
> here you can use memalign_pages, since you are not using the flags

Sure

> 
>> +	pgd_old = (void *)(asce & PAGE_MASK);
>> +
>> +	memcpy(pgd_new, pgd_old, PAGE_SIZE * 4);
>> +
>> +	asce = __pa(pgd_new) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH | ASCE_P;
> 
> why not taking the flags from the old ASCE? what if we choose to use a
> different type of table?
> 
> something like this:
> 
> asce = _pa(pgd_new) | ASCE_P | (asce & ~PAGE_MASK);

I should at least preserve DT and TL but I'd opt to not copy over the 
other bits. If someone wants to do funky ASCE stuff they now have the 
possibility to simply change vm->save_area.guest.asce


