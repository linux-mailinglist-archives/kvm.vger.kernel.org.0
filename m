Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970ED356905
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350501AbhDGKHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:07:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234931AbhDGKH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:07:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137A3v4r089812
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j91v8fOPa/2XmiVsFusY2X82VN0F55LJYv7gnlUMl2Q=;
 b=cC8qoB1cPjNJUTeI/lZCo34UyA9pXjjtBwnNfKeCP+ewXzm5bcURzHCXwzzBJXs/m/Qi
 EGkSb7mDiX90omrOyPCpIrKPSR36fVeblhij4h8Se/aBWgr1pOTpMC0QghVlHtWdP55z
 s3nXZEtYV3FeMjihCYzUIMPYMrlPvCZEbJ3pFSr0fR+bsQ5/sPKYNPwWEfj5dCo3u2s0
 e2KjPdCu3FngEsZLtB0VKdEpGFiOt7DAwwIdWIntAvLvVUAJ89pjkvILV+JE2b8Q1Cog
 KXLB8tUhinoaSFlTcQ0RjOQvjaoaucDXDAGrYAUldIxiPs1RlPmwdTyxqmcMcR/Bo/fx eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvmqcpf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:07:18 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137A49ER092059
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:07:18 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvmqcpej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 06:07:18 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137A2wJZ006397;
        Wed, 7 Apr 2021 10:07:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37rvbqgktj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:07:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137A7DN135062146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 10:07:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB270AE053;
        Wed,  7 Apr 2021 10:07:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67944AE051;
        Wed,  7 Apr 2021 10:07:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Apr 2021 10:07:13 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 12/16] s390x: css: Check ORB reserved
 bits
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
 <1617694853-6881-13-git-send-email-pmorel@linux.ibm.com>
 <20210406175136.1d7d7fa2.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <19cc4cdc-027b-9c72-b4fe-fa8fc2dcbbf0@linux.ibm.com>
Date:   Wed, 7 Apr 2021 12:07:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406175136.1d7d7fa2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hu7VbJxRePNWllud7wLBoZCA8cxcD94y
X-Proofpoint-ORIG-GUID: GI_TRQw7On_AZudgctiIEaKz3fUE3qCc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-06,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/21 5:51 PM, Cornelia Huck wrote:
> On Tue,  6 Apr 2021 09:40:49 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Several bits of the ORB are reserved and must be zero.
>> Their use will trigger a operand exception.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 56adc16..26f5da6 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -209,6 +209,26 @@ static void ssch_orb_midaw(void)
>>   	orb->ctrl = tmp;
>>   }
>>   
>> +static void ssch_orb_ctrl(void)
>> +{
>> +	uint32_t tmp = orb->ctrl;
>> +	char buffer[80];
>> +	int i;
>> +
>> +	/* Check the reserved bits of the ORB CTRL field */
>> +	for (i = 26; i <= 30; i++) {
> 
> This looks very magic; can we get some defines?

OK, I can use something like ORB_FIRST_RESERVED_BIT - ORB_LAST_RESERVED_BIT


> 
>> +		orb->ctrl |= (0x01 << (31 - i));
>> +		snprintf(buffer, 80, " %d", i);
>> +		report_prefix_push(buffer);
>> +		expect_pgm_int();
>> +		ssch(test_device_sid, orb);
>> +		check_pgm_int_code(PGM_INT_CODE_OPERAND);
>> +		report_prefix_pop();
>> +
>> +		orb->ctrl = tmp;
>> +	}
>> +}
>> +
>>   static struct tests ssh_tests[] = {
>>   	{ "privilege", ssch_privilege },
>>   	{ "orb cpa zero", ssch_orb_cpa_zero },
>> @@ -217,6 +237,7 @@ static struct tests ssh_tests[] = {
>>   	{ "CCW access", ssch_ccw_access },
>>   	{ "CCW in DMA31", ssch_ccw_dma31 },
>>   	{ "ORB MIDAW unsupported", ssch_orb_midaw },
>> +	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
>>   	{ NULL, NULL }
>>   };
>>   
> 

-- 
Pierre Morel
IBM Lab Boeblingen
