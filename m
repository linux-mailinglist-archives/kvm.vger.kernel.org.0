Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348EE2C8439
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 13:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgK3Mjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 07:39:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725861AbgK3Mjd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 07:39:33 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCVkvL164707;
        Mon, 30 Nov 2020 07:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rl7wqyz//qGY2fm76oe5ukgl+7Y1AHHRnst0NAZkzv0=;
 b=Ch4SWebHpO8mOjaO8yebYzbc4QSYkUYJmwIv2cwX5fOUEvij9Mz1pQnAm3p/zSdBg8UR
 iT5bK1Xa9RopCZdaZxG0eQfXlvWRPm4PyQzY7Ej7D/V0RK2dyrnc6oAYZLAqQBcWbaKv
 NtMR5zD2Ki9CrhdbpnkhohO93aA94khC+Ezu535E2HVAJCMVUyOxxutyZMiEJh45RLbv
 q7tukMZdYDaFXaUxS1cveDcLTKdp3F9AvUerUmiMSUcj9zrncckt7+1xTZVANey5fPxz
 ph0tZqmLlRoWqWyjzG4hi62JlPfmeVnav7WXpH0UIb94K5HeQQd/LaubjqEfSkVxTLra Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3550nvgdyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 07:38:51 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AUCWZBh167307;
        Mon, 30 Nov 2020 07:38:51 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3550nvgdyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 07:38:51 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCW2F7015787;
        Mon, 30 Nov 2020 12:38:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 353dth91m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 12:38:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUCckVY58196390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 12:38:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C751A405C;
        Mon, 30 Nov 2020 12:38:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31383A4054;
        Mon, 30 Nov 2020 12:38:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.29.252])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 12:38:46 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/7] s390x: Add diag318 intercept test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-7-frankja@linux.ibm.com>
 <f1f8ce84-e30a-29c5-8ab6-7294cdc248ce@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <fb9faf97-339c-e235-cb62-d8581adf7b6a@linux.ibm.com>
Date:   Mon, 30 Nov 2020 13:38:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <f1f8ce84-e30a-29c5-8ab6-7294cdc248ce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_03:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/27/20 5:46 PM, Thomas Huth wrote:
> On 27/11/2020 14.06, Janosch Frank wrote:
>> Not much to test except for the privilege and specification
>> exceptions.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/sclp.c  |  2 ++
>>  lib/s390x/sclp.h  |  6 +++++-
>>  s390x/intercept.c | 19 +++++++++++++++++++
>>  3 files changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 68833b5..3966086 100644
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
>> index e18f7e6..4e564dd 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -108,7 +108,8 @@ extern struct sclp_facilities sclp_facilities;
>>  
>>  struct sclp_facilities {
>>  	uint64_t has_sief2 : 1;
>> -	uint64_t : 63;
>> +	uint64_t has_diag318 : 1;
>> +	uint64_t : 62;
>>  };
>>  
>>  typedef struct ReadInfo {
>> @@ -133,6 +134,9 @@ typedef struct ReadInfo {
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
>> index 2e38257..615f0a0 100644
>> --- a/s390x/intercept.c
>> +++ b/s390x/intercept.c
>> @@ -10,6 +10,7 @@
>>   * under the terms of the GNU Library General Public License version 2.
>>   */
>>  #include <libcflat.h>
>> +#include <sclp.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/interrupt.h>
>>  #include <asm/page.h>
>> @@ -154,6 +155,23 @@ static void test_testblock(void)
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
> 
> Maybe remove the empty line above.

Sure

> 
>> +}
>> +
>>  struct {
>>  	const char *name;
>>  	void (*func)(void);
>> @@ -164,6 +182,7 @@ struct {
>>  	{ "stap", test_stap, false },
>>  	{ "stidp", test_stidp, false },
>>  	{ "testblock", test_testblock, false },
>> +	{ "diag318", test_diag318, false },
>>  	{ NULL, NULL, false }
>>  };
>>  
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks!

> 

