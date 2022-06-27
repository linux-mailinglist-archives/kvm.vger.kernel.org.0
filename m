Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276AD55C8E8
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiF0LJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 07:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiF0LJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 07:09:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EE464DF;
        Mon, 27 Jun 2022 04:09:51 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RB1JJS027189;
        Mon, 27 Jun 2022 11:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1EUUqAPrNG9SEdkyTHKYD567vWXRfPDsqtSt5rx6Ckk=;
 b=HS/8/wDnmPt7nBW+0M/hG3HkcvP4jCOOYBEJaRs08hFclDYg6HzdWYkuahHmUs3DV/KB
 +qYUPjqzVxh0JhXvcuTDbfvcP5FTM1di0RKgM2OHmQZc8WAz2NePMTW/Vj3gHp/Ykuts
 g6L49O8pXHBmH+Q++Us9qOmQecNX13zRpvcZQGcWLdDbW2/yO49zHSM716dwbivUAciz
 /DuSAAkt4PEPsV656NudcypV6vETxOC7twOX9wCOvHr+r6nhPdK+DQGbyowdoIlmuwxb
 Phxn4eqvvR11fwK29DSGwugAOLIJrUDF2A03LE0/GwI5idN8pkzRQBOE2te+WrWI9auE AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gybaf87gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 11:09:50 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RB2KQV030308;
        Mon, 27 Jun 2022 11:09:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gybaf87fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 11:09:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RB5pDv012377;
        Mon, 27 Jun 2022 11:09:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gwt09257q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 11:09:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RB9iDD13500924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 11:09:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C54BBA4059;
        Mon, 27 Jun 2022 11:09:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 810DDA4053;
        Mon, 27 Jun 2022 11:09:44 +0000 (GMT)
Received: from [9.145.155.49] (unknown [9.145.155.49])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jun 2022 11:09:44 +0000 (GMT)
Message-ID: <30263d61-dd16-5c49-f1c1-e298ce8cf60b@linux.ibm.com>
Date:   Mon, 27 Jun 2022 13:09:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib: s390x: better smp interrupt
 checks
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
References: <20220624144518.66573-1-imbrenda@linux.ibm.com>
 <20220624144518.66573-4-imbrenda@linux.ibm.com>
 <19169d83-ad31-da70-b3bb-bd7ba43e6484@linux.ibm.com>
 <20220627125314.599cc580@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220627125314.599cc580@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0s4XtYoyk0mXKnQ0bRl_fyWIJMXg3bRU
X-Proofpoint-ORIG-GUID: 4NTwz0skxQO3foXS_J5pGST_uT4BDPSW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/22 12:53, Claudio Imbrenda wrote:
> On Mon, 27 Jun 2022 11:28:18 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 6/24/22 16:45, Claudio Imbrenda wrote:
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
>>> Both program interrupts and extern interrupts are now CPU-bound, even
>>> though some extern interrupts are floating (notably, the SCLP
>>> interrupt). In those cases, the testcases should mask interrupts and/or
>>> expect them appropriately according to need.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    lib/s390x/asm/arch_def.h | 17 +++++++++++-
>>>    lib/s390x/smp.h          |  8 +-----
>>>    lib/s390x/interrupt.c    | 57 +++++++++++++++++++++++++++++-----------
>>>    lib/s390x/smp.c          | 11 ++++++++
>>>    4 files changed, 70 insertions(+), 23 deletions(-)
>> [...]
>>>    
>>> +struct lowcore *smp_get_lowcore(uint16_t idx)
>>> +{
>>> +	if (THIS_CPU->idx == idx)
>>> +		return &lowcore;
>>> +
>>> +	check_idx(idx);
>>> +	return cpus[idx].lowcore;
>>> +}
>>
>> This function is unused.
> 
> not currently, but it's useful to have in lib
> 
> should I split this into a separate patch?
> 
>>
>>> +
>>>    int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
>>>    {
>>>    	check_idx(idx);
>>> @@ -253,6 +262,7 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
>>>    
>>>    	/* Copy all exception psws. */
>>>    	memcpy(lc, cpus[0].lowcore, 512);
>>> +	lc->this_cpu = cpus + idx;
>>
>> Why not:
>> lc->this_cpu = &cpus[idx];
> 
> it's equivalent, do you have a reason for changing it?

It's more explicit.

> 
>>
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

