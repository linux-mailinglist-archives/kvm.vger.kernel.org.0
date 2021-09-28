Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCFF41ADBC
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 13:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhI1LXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 07:23:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231202AbhI1LXC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 07:23:02 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAF6wx025223;
        Tue, 28 Sep 2021 07:21:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9TPbY8k07HdbQPZWh5HB+Ln8AmlEfqI1A6ByVNGIhJ8=;
 b=ZsvGrIWBmhugThk+ScfypeivMMDI4b97vCFuNsr+zhOG3BcG99UgJs5avHPx51qmgBch
 2VLrsPKeoHhhhmEF+o/83dk9QUq3VWDblWGUzPe4MYNTc0fWyoO4JMOuNA0alsRXGGIP
 DTKSp6W3clmhSg6JKhFhKaRITTgs1jDKeuVCx699ClQ9vFNVvTVNxceQlNVfea/RqEt+
 oz1cAlJ3PKYfr1U5ZDyOobRZywgmcEYR8pVu5HkI9DDBwFDY8iUIYbARfGW8fbIM2OEq
 dO6FrDKSCawRenxEQkwBS/eiI2Qz9S3zGjW907uhjoSHoptyA584wYbvG1cDRdmQ9jcp mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbxq7cfep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:21:23 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18SAkdkl028831;
        Tue, 28 Sep 2021 07:21:23 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbxq7cfe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:21:22 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SBDQgd005414;
        Tue, 28 Sep 2021 11:21:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b9u1juq84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 11:21:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SBLFHG43319736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:21:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FA594C09C;
        Tue, 28 Sep 2021 11:21:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 296A64C09B;
        Tue, 28 Sep 2021 11:21:15 +0000 (GMT)
Received: from [9.145.12.195] (unknown [9.145.12.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Sep 2021 11:21:15 +0000 (GMT)
Message-ID: <11d1b08d-6605-97f7-84f3-49f20f8cc0c2@linux.ibm.com>
Date:   Tue, 28 Sep 2021 13:21:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, linux-s390@vger.kernel.org, seiden@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-4-frankja@linux.ibm.com>
 <8035a911-4a76-50ed-cb07-edce48abdb9c@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x: uv-host: Fence a destroy cpu
 test on z15
In-Reply-To: <8035a911-4a76-50ed-cb07-edce48abdb9c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SIMoU2SHbW8CuL1YnEIsIhmUpBK9SOP3
X-Proofpoint-GUID: j8DDkCZWJTS1bvkkURBjgLzT8GQ1i8bs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/27/21 17:26, Thomas Huth wrote:
> On 22/09/2021 09.18, Janosch Frank wrote:
>> Firmware will not give us the expected return code on z15 so let's
>> fence it for the z15 machine generation.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>>    s390x/uv-host.c          | 11 +++++++----
>>    2 files changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index aa80d840..c8d2722a 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -219,6 +219,20 @@ static inline unsigned short stap(void)
>>    	return cpu_address;
>>    }
>>    
>> +#define MACHINE_Z15A	0x8561
>> +#define MACHINE_Z15B	0x8562
>> +
>> +static inline uint16_t get_machine_id(void)
>> +{
>> +	uint64_t cpuid;
>> +
>> +	asm volatile("stidp %0" : "=Q" (cpuid));
>> +	cpuid = cpuid >> 16;
>> +	cpuid &= 0xffff;
>> +
>> +	return cpuid;
>> +}
>> +
>>    static inline int tprot(unsigned long addr)
>>    {
>>    	int cc;
>> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
>> index 66a11160..5e351120 100644
>> --- a/s390x/uv-host.c
>> +++ b/s390x/uv-host.c
>> @@ -111,6 +111,7 @@ static void test_config_destroy(void)
>>    static void test_cpu_destroy(void)
>>    {
>>    	int rc;
>> +	uint16_t machineid = get_machine_id();
>>    	struct uv_cb_nodata uvcb = {
>>    		.header.len = sizeof(uvcb),
>>    		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
>> @@ -125,10 +126,12 @@ static void test_cpu_destroy(void)
>>    	       "hdr invalid length");
>>    	uvcb.header.len += 8;
>>    
>> -	uvcb.handle += 1;
>> -	rc = uv_call(0, (uint64_t)&uvcb);
>> -	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
>> -	uvcb.handle -= 1;
>> +	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
>> +		uvcb.handle += 1;
>> +		rc = uv_call(0, (uint64_t)&uvcb);
>> +		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
>> +		uvcb.handle -= 1;
>> +	}
> 
> So this is a bug in the firmware? Any chance that it will still get fixed
> for the z15? If so, would it make sense to turn this into a report_xfail()
> instead?
> 
>    Thomas
> 

No, a xfail will not help here.

