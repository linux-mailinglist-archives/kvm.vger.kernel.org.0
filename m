Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D29C2DD444
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgLQPek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:34:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbgLQPej (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:34:39 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHFWkKO040349;
        Thu, 17 Dec 2020 10:33:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vHlNjyXMMQvTCuD9VFc8TD1VEhb2PMJmQrpPlRgS62M=;
 b=MvqmG13DFpv2bExOuLfEn9O1hK8unAyyoUELxWrcwqh3aZlQyCl0q7F8eZ2AbRh9Nifx
 VCEPwA7sefNIf0YJF/btDoFFm7E18WQExTyMt7HPLj/Nf/8+GdptYIXImFuCKum/049D
 jyfGIBdJmVnElSLw39VR7ZPcDIK6AwmtwVaLk8TeendNt2r6XD4mDwZzDRDZElPDnMIl
 Ve5mkgdrrjvStI76Sct62S0GooDjdCZ6/lQkeOhIxf9d67T/VhhLOsTyFZEQWFR6SdlR
 O0N2nyZpx786U00fuxphbdRFATAafl/235cArnGi94ryx701Vc2k9/ANTQGeEazoxIRc Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g9k117jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:33:58 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHFXIEd043551;
        Thu, 17 Dec 2020 10:33:58 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g9k117h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:33:58 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHFR7A6024150;
        Thu, 17 Dec 2020 15:33:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8g55g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:33:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHFVMll25297280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 15:31:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9F4342045;
        Thu, 17 Dec 2020 15:31:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6791B42049;
        Thu, 17 Dec 2020 15:31:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 15:31:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     david@redhat.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-8-frankja@linux.ibm.com>
 <4f689585-ae2e-4632-9055-f2332d9f7751@redhat.com>
 <44d6ac32-f7ac-6b33-ea9e-e037f936a181@de.ibm.com>
 <24e9883c-22d5-de4f-0001-d271855d7ea3@redhat.com>
 <23af5bca-dd2c-43bd-b2b4-6c7e2031517f@linux.ibm.com>
Message-ID: <b4bd9043-bf90-fe88-f237-b4f9948ba94e@linux.ibm.com>
Date:   Thu, 17 Dec 2020 16:31:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <23af5bca-dd2c-43bd-b2b4-6c7e2031517f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_10:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 3:31 PM, Janosch Frank wrote:
> On 12/17/20 11:34 AM, Thomas Huth wrote:
>> On 17/12/2020 10.59, Christian Borntraeger wrote:
>>>
>>>
>>> On 17.12.20 10:53, Thomas Huth wrote:
>>>> On 11/12/2020 11.00, Janosch Frank wrote:
>>>>> Not much to test except for the privilege and specification
>>>>> exceptions.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>>> ---
>>>>>  lib/s390x/sclp.c  |  2 ++
>>>>>  lib/s390x/sclp.h  |  6 +++++-
>>>>>  s390x/intercept.c | 19 +++++++++++++++++++
>>>>>  3 files changed, 26 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>>>> index cf6ea7c..0001993 100644
>>>>> --- a/lib/s390x/sclp.c
>>>>> +++ b/lib/s390x/sclp.c
>>>>> @@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
>>>>>  
>>>>>  	assert(read_info);
>>>>>  
>>>>> +	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
>>>>> +
>>>>>  	cpu = (void *)read_info + read_info->offset_cpu;
>>>>>  	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>>>>>  		if (cpu->address == cpu0_addr) {
>>>>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>>>>> index 6c86037..58f8e54 100644
>>>>> --- a/lib/s390x/sclp.h
>>>>> +++ b/lib/s390x/sclp.h
>>>>> @@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
>>>>>  
>>>>>  struct sclp_facilities {
>>>>>  	uint64_t has_sief2 : 1;
>>>>> -	uint64_t : 63;
>>>>> +	uint64_t has_diag318 : 1;
>>>>> +	uint64_t : 62;
>>>>>  };
>>>>>  
>>>>>  typedef struct ReadInfo {
>>>>> @@ -130,6 +131,9 @@ typedef struct ReadInfo {
>>>>>      uint16_t highest_cpu;
>>>>>      uint8_t  _reserved5[124 - 122];     /* 122-123 */
>>>>>      uint32_t hmfai;
>>>>> +    uint8_t reserved7[134 - 128];
>>>>> +    uint8_t byte_134_diag318 : 1;
>>>>> +    uint8_t : 7;
>>>>>      struct CPUEntry entries[0];
>>>>
>>>> ... the entries[] array can be moved around here without any further ado?
>>>> Looks confusing to me. Should there be a CPUEntry array here at all, or only
>>>> in ReadCpuInfo?
>>>
>>> there is offset_cpu for the cpu entries at the beginning of the structure.
>>
>> Ah, thanks, right, this was used earlier in the patch series, now I
>> remember. But I think the "struct CPUEntry entries[0]" here is rather
>> confusing, since there is no guarantee that the entries are really at this
>> location ... I think this line should rather be replaced by a comment saying
>> that offset_cpu should be used instead.
> 
> Sure, as long as it's clear that there's something at the end, I'm fine
> with it.

I would add that to the "fix style issues" patch or into an own patch.
Any preferences?

-       struct CPUEntry entries[0];
+       /*
+        * The cpu entries follow, they start at the offset specified
+        * in offset_cpu.
+        */




> 
>>
>>  Thomas
>>
> 

