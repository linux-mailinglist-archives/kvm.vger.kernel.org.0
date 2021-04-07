Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5E2356A17
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhDGKmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:42:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234267AbhDGKmx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:42:53 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137AY5bS077554
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6TTVgbpZDrEuT3EwlftuKGhlf0PLnMDWNGM88q29GYU=;
 b=fZ6YyVvS56+6vz+0aesknSCVO/O7rmV77V5weXYjBZKYgtDIT/L2BcYlfFLYV1tahpdW
 zfUDZsM0SEx/uyAsqNEHAvLMzZNfSYnNbDU17KeensXiG50Ijpz0V2qB4ZKteTiMVfdh
 qg5hIIXWcEwgHR/6gCOb9iwkbavPy5P1VEL2oTXg2oLBUfpfrBITpUiuKXnRmYJajPZQ
 wN2OnPKVG7dP20wcCpnwAgH+b6De2oxyFtS9yhB1B10jmTPv4uzaxmvzFOclm+GeF/iP
 LcHqrNpjnp6Ozj+UmaEh8QTYbKeiVWSjM8gWMCIalPDpgWch9WpZSvvFHFX9gASrFAaG Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvm05wu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:42:43 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137AY9l3077999
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:42:43 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37rvm05wt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 06:42:43 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137AbElE014834;
        Wed, 7 Apr 2021 10:42:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 37rvbw0b4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:42:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137AgHI735062204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 10:42:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E724BAE056;
        Wed,  7 Apr 2021 10:42:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6C1EAE057;
        Wed,  7 Apr 2021 10:42:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Apr 2021 10:42:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 13/16] s390x: css: checking for CSS
 extensions
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
 <1617694853-6881-14-git-send-email-pmorel@linux.ibm.com>
 <20210406175024.44fe7473.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7e9424ed-8048-57a2-d746-230b576c2e3f@linux.ibm.com>
Date:   Wed, 7 Apr 2021 12:42:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406175024.44fe7473.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E4kAiQzQ6BUhI8l544ooP0pd2Q3yfF3P
X-Proofpoint-ORIG-GUID: M5qom5UzZBLpWs9AuM5FPzGqYJO_sQGi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-06,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/21 5:50 PM, Cornelia Huck wrote:
> On Tue,  6 Apr 2021 09:40:50 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We verify that these extensions are not install before running simple
> 
> s/not install/installed/ ?
> 
> Testing extensions that are not installed does not make that much sense
> :)
> 
>> tests.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h |  2 ++
>>   s390x/css.c     | 31 +++++++++++++++++++++++++++++++
>>   2 files changed, 33 insertions(+)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index d824e34..08b2974 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -338,7 +338,9 @@ struct chsc_scsc {
>>   	uint8_t reserved[9];
>>   	struct chsc_header res;
>>   	uint32_t res_fmt;
>> +#define CSSC_ORB_EXTENSIONS		0
>>   #define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
>> +#define CSSC_FC_EXTENSIONS		88
>>   	uint64_t general_char[255];
>>   	uint64_t chsc_char[254];
>>   };
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 26f5da6..f8c6688 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -229,6 +229,35 @@ static void ssch_orb_ctrl(void)
>>   	}
>>   }
>>   
>> +static void ssch_orb_extension(void)
>> +{
>> +	if (!css_test_general_feature(CSSC_ORB_EXTENSIONS)) {
>> +		report_skip("ORB extensions not installed");
>> +		return;
>> +	}
>> +	/* Place holder for checking ORB extensions */
>> +	report_info("ORB extensions installed but not tested");
>> +}
>> +
>> +static void ssch_orb_fcx(void)
>> +{
>> +	uint32_t tmp = orb->ctrl;
>> +
>> +	if (!css_test_general_feature(CSSC_FC_EXTENSIONS)) {
>> +		report_skip("Fibre-channel extensions not installed");
>> +		return;
>> +	}
>> +
>> +	report_prefix_push("Channel-Program Type Control");
>> +	orb->ctrl |= ORB_CTRL_CPTC;
>> +	expect_pgm_int();
>> +	ssch(test_device_sid, orb);
>> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
>> +	report_prefix_pop();
> 
> I don't quite understand what you're testing here; shouldn't the device
> accept a transport-mode orb if fcx is installed? The problem would be
> if the program consists of ccws instead, so it's more a malformed block
> handling test?

Yes, OK, non sense.
I let fall this test.

-- 
Pierre Morel
IBM Lab Boeblingen
