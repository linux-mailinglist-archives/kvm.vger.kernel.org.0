Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA22DD422
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgLQP0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:26:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgLQP0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:26:47 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHF2uVr119109;
        Thu, 17 Dec 2020 10:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yVFl+4hPFdRSl+Vahq3syhYEC4XDZ/otbaWnDelq7N0=;
 b=fqyZsvu90QEsBf6tvDVmo7X1OpddIu+aK3B9pUsJR58asfpbFPbYCObL/pyyS0yu6eVT
 KphWvGQHv98rYmyOtxsxnDHZQOfxS3+bXuK9B8o2A3pL78xJshpM/1niV/jmiSDVzE0f
 sGn4eMRLpaDjBWjxiHSUsmpswQKrFyY6H8MDEHdZP1Bg7jtO/XKVhbSf+JVU+rAMK1dk
 JWGDszVCOCSf7UYInRc5qFS0BXa1lSAqW+kzjCos5QB9luBiqON1FKGfNIO8kpNj88j+
 b3jOBmiSYuMR4QrzLevR2vbqF2Yyqj63MB1XMaEYBi7Q3WuGvlCa28AFp5ZW7WKoaI10 Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g9949gyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:26:07 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHFAJNF172592;
        Thu, 17 Dec 2020 10:26:05 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35g9949gx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:26:05 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHF7Sbr015438;
        Thu, 17 Dec 2020 15:26:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng85g9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:26:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHFQ0JB25100558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 15:26:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02B3D4204F;
        Thu, 17 Dec 2020 15:26:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 945D24204C;
        Thu, 17 Dec 2020 15:25:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.181.71])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 15:25:59 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 7/8] s390x: Add diag318 intercept test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-8-frankja@linux.ibm.com>
 <20201217155826.33c7bef1@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <96ce6e78-0c91-2093-5e2b-3d9e9f906ccb@linux.ibm.com>
Date:   Thu, 17 Dec 2020 16:25:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217155826.33c7bef1@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/20 3:58 PM, Claudio Imbrenda wrote:
> On Fri, 11 Dec 2020 05:00:38 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Not much to test except for the privilege and specification
>> exceptions.
> 
> This patch looks fine. But I wonder what is it doing in this series?
> The series is about SIE testing, and this seems to be an unrelated
> improvement in an existing testcase?

I didn't want to split my patches up in multiple series and this depends
on the sclp changes.

> 
> anyway, looks good to me
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks

> 
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  lib/s390x/sclp.c  |  2 ++
>>  lib/s390x/sclp.h  |  6 +++++-
>>  s390x/intercept.c | 19 +++++++++++++++++++
>>  3 files changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index cf6ea7c..0001993 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -138,6 +138,8 @@ void sclp_facilities_setup(void)
>>  
>>  	assert(read_info);
>>  
>> +	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
>> +
>>  	cpu = (void *)read_info + read_info->offset_cpu;
>>  	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>>  		if (cpu->address == cpu0_addr) {
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index 6c86037..58f8e54 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -105,7 +105,8 @@ extern struct sclp_facilities sclp_facilities;
>>  
>>  struct sclp_facilities {
>>  	uint64_t has_sief2 : 1;
>> -	uint64_t : 63;
>> +	uint64_t has_diag318 : 1;
>> +	uint64_t : 62;
>>  };
>>  
>>  typedef struct ReadInfo {
>> @@ -130,6 +131,9 @@ typedef struct ReadInfo {
>>      uint16_t highest_cpu;
>>      uint8_t  _reserved5[124 - 122];     /* 122-123 */
>>      uint32_t hmfai;
>> +    uint8_t reserved7[134 - 128];
>> +    uint8_t byte_134_diag318 : 1;
>> +    uint8_t : 7;
>>      struct CPUEntry entries[0];
>>  } __attribute__((packed)) ReadInfo;
>>  
>> diff --git a/s390x/intercept.c b/s390x/intercept.c
>> index cde2f5f..86e57e1 100644
>> --- a/s390x/intercept.c
>> +++ b/s390x/intercept.c
>> @@ -8,6 +8,7 @@
>>   *  Thomas Huth <thuth@redhat.com>
>>   */
>>  #include <libcflat.h>
>> +#include <sclp.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/interrupt.h>
>>  #include <asm/page.h>
>> @@ -152,6 +153,23 @@ static void test_testblock(void)
>>  	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>>  }
>>  
>> +static void test_diag318(void)
>> +{
>> +	expect_pgm_int();
>> +	enter_pstate();
>> +	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +
>> +	if (!sclp_facilities.has_diag318)
>> +		expect_pgm_int();
>> +
>> +	asm volatile("diag %0,0,0x318\n" : : "d" (0x42));
>> +
>> +	if (!sclp_facilities.has_diag318)
>> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +
>> +}
>> +
>>  struct {
>>  	const char *name;
>>  	void (*func)(void);
>> @@ -162,6 +180,7 @@ struct {
>>  	{ "stap", test_stap, false },
>>  	{ "stidp", test_stidp, false },
>>  	{ "testblock", test_testblock, false },
>> +	{ "diag318", test_diag318, false },
>>  	{ NULL, NULL, false }
>>  };
>>  
> 

