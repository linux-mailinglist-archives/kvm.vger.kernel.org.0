Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4EF573701
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 15:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiGMNNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 09:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiGMNNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 09:13:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81404E00;
        Wed, 13 Jul 2022 06:13:40 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DCoM8v012518;
        Wed, 13 Jul 2022 13:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9z8gLr/bieeTgO4gt4XwmZNldv244q3vAAD1VoHYSkQ=;
 b=V1SUVACRc8brz/xEmwpXTA468QB6JnPpU0p+/4rOm6jEHzv7BezlwfnOCUYstfEc4AwD
 j1QK8X9vygoV2JueM63HDOKok8lcwlBQa44samvIymx5gcKuogsF1l7mHPbN6F/2qn4P
 T/6hbAwAzv20rLeT4uuFSJ0dWdqeK0T6cOm8lqH36VZWFiwZTCs1JnCi2QRWvEdwsMhT
 1W6aU2Z8zewhLtLBnMM/R2wYLjV7erEen71TSrBFP2wHge86YqURR5lIEtJnn7TZ28jH
 nNc0wAsUWIqDXgX7eQBdodqeWYnzfXe5o699GElmalDykQ4+pK3EMsZ3GkaQNlUfaADJ hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9xdk0ndc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 13:13:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DCoNfn012542;
        Wed, 13 Jul 2022 13:13:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9xdk0ncu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 13:13:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DDAXc7009366;
        Wed, 13 Jul 2022 13:13:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3h71a8w00j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 13:13:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DDDXfe21496206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 13:13:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E2EA4203F;
        Wed, 13 Jul 2022 13:13:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 199B742041;
        Wed, 13 Jul 2022 13:13:33 +0000 (GMT)
Received: from [9.145.184.105] (unknown [9.145.184.105])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 13:13:33 +0000 (GMT)
Message-ID: <fa94d28f-5791-62fb-1099-38547db853aa@linux.ibm.com>
Date:   Wed, 13 Jul 2022 15:13:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v3 3/3] lib: s390x: better smp interrupt
 checks
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
References: <20220713104557.168113-1-imbrenda@linux.ibm.com>
 <20220713104557.168113-4-imbrenda@linux.ibm.com>
 <36962c60-a7db-a5f6-2ecf-c7dcc0152e74@linux.ibm.com>
 <20220713150707.5b5e9825@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220713150707.5b5e9825@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5FiN2OS8B2x7kzL3khALV0ohtE_ap2YE
X-Proofpoint-GUID: aT5Fxhhhj_q3coeiFm6xrsGJ66eOpAcp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_01,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 impostorscore=0 malwarescore=0 mlxlogscore=792
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207130050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 15:07, Claudio Imbrenda wrote:
> On Wed, 13 Jul 2022 14:24:57 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 7/13/22 12:45, Claudio Imbrenda wrote:
>>> Use per-CPU flags and callbacks for Program and Extern interrupts,
>>> instead of global variables.
>>>
>>> This allows for more accurate error handling; a CPU waiting for an
>>> interrupt will not have it "stolen" by a different CPU that was not
>>> supposed to wait for one, and now two CPUs can wait for interrupts at
>>> the same time.
>>>
>>> This will significantly improve error reporting and debugging when
>>> things go wrong.
>>>
>>> Both program interrupts and external interrupts are now CPU-bound, even
>>> though some external interrupts are floating (notably, the SCLP
>>> interrupt). In those cases, the testcases should mask interrupts and/or
>>> expect them appropriately according to need.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    lib/s390x/asm/arch_def.h | 16 ++++++++++-
>>>    lib/s390x/smp.h          |  8 +-----
>>>    lib/s390x/interrupt.c    | 57 +++++++++++++++++++++++++++++-----------
>>>    lib/s390x/smp.c          | 11 ++++++++
>>>    4 files changed, 69 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index b3282367..03578277 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -41,6 +41,17 @@ struct psw {
>>>    	uint64_t	addr;
>>>    };
>>>    
>>> +struct cpu {
>>> +	struct lowcore *lowcore;
>>> +	uint64_t *stack;
>>> +	void (*pgm_cleanup_func)(void);
>>
>> We should change the parameter to include the stack frame for easier
>> manipulation of the pre-exception registers, especially the CRs.
> 
> will do
> 
>>
>>> +	uint16_t addr;
>>> +	uint16_t idx;
>>> +	bool active;
>>> +	bool pgm_int_expected;
>>> +	bool ext_int_expected;
>>> +};
>>
>> And I'd opt for also integrating the io handling function and getting
>> rid of the unset function to make them all look the same.
> 
> I/O is usually floating, though, I don't think it makes sense to have
> it per-cpu

Right, it just bugs me that it's handled so differently.
I'll find a solution for that if my eyes stumble over it too often.

> 
>>
>> Looking at Nico's patches the external handler will follow soon anyway.
> 
> should I add the external handler here?

Discuss that with Nico, I don't have a strong opinion on that

> 
>>
>>
>> I'm not 100% happy with having this struct in this file, what kept you
>> from including smp.h?
> 
> smp.h depends on arch_def.h, which then would depend on smp.h
> 
>>
>>> +struct lowcore *smp_get_lowcore(uint16_t idx)
>>> +{
>>> +	if (THIS_CPU->idx == idx)
>>> +		return &lowcore;
>>> +
>>> +	check_idx(idx);
>>> +	return cpus[idx].lowcore;
>>> +}
>>
>> I'm waiting for the moment where we need locking in the struct cpu.
>>
>>> +
>>>    int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
>>>    {
>>>    	check_idx(idx);
>>> @@ -253,6 +262,7 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
>>>    
>>>    	/* Copy all exception psws. */
>>>    	memcpy(lc, cpus[0].lowcore, 512);
>>> +	lc->this_cpu = &cpus[idx];
>>>    
>>>    	/* Setup stack */
>>>    	cpus[idx].stack = (uint64_t *)alloc_pages(2);
>>> @@ -325,6 +335,7 @@ void smp_setup(void)
>>>    	for (i = 0; i < num; i++) {
>>>    		cpus[i].addr = entry[i].address;
>>>    		cpus[i].active = false;
>>> +		cpus[i].idx = i;
>>>    		/*
>>>    		 * Fill in the boot CPU. If the boot CPU is not at index 0,
>>>    		 * swap it with the one at index 0. This guarantees that the
>>
> 

