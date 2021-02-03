Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082A930D724
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhBCKNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:13:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49582 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233215AbhBCKNF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 05:13:05 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 113A4Ssn122462;
        Wed, 3 Feb 2021 05:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xWc47iOguMgDfpv50HL1FcnODwddF2HRcLlxDqloC08=;
 b=S5jfI4fJ1RDlaOFMpZfshLGmCDcfO1OEH03HUMuEP2/OfU0pqulzwQ7JAqmea0m3FNed
 oSvmuTCPacTqXwIIwl3z7EIQKWSwbObnj2+eUU4xWeOOX9uSDyBRqFJb0nhJyM4gXTk1
 OaT8H9ohhTl/8Lv4n7ZmwdxJ4sRMk26+8teyZgE2t+Z9KuVCZuHctMC2+5g77X9pJ7vd
 o+g7Gnun3G4/fSsWF2tVq/szpa9SfVOUkng0kjGqXvam4DM6tMWTAy+Pi4A7sOkp2DJ7
 Vo7du2ekAVxHev6INzxIsb2mx5Kw4bUUlFLqnKB26vcSBOOk+EEfHcFNwbYYxwZ0kp4O Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fsjr8pua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:12:23 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 113A51tm126682;
        Wed, 3 Feb 2021 05:12:23 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fsjr8pta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 05:12:23 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113ABtpx032104;
        Wed, 3 Feb 2021 10:12:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 36cxqh9yfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 10:12:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113AC9EO11206990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 10:12:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37441A4066;
        Wed,  3 Feb 2021 10:12:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8D5FA4065;
        Wed,  3 Feb 2021 10:12:17 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.177.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 10:12:17 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 1/5] s390x: css: Store CSS
 Characteristics
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
 <74ad7962-9217-5110-4089-9b83d519cfc1@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <93bea05c-2ee9-4452-c452-0d2bbb1f302f@linux.ibm.com>
Date:   Wed, 3 Feb 2021 11:12:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <74ad7962-9217-5110-4089-9b83d519cfc1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_04:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/21 6:25 PM, Thomas Huth wrote:
> On 29/01/2021 15.34, Pierre Morel wrote:
>> CSS characteristics exposes the features of the Channel SubSystem.
>> Let's use Store Channel Subsystem Characteristics to retrieve
>> the features of the CSS.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 57 +++++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/css_lib.c | 50 ++++++++++++++++++++++++++++++++++++++-
>>   s390x/css.c         | 12 ++++++++++
>>   3 files changed, 118 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 3e57445..bc0530d 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -288,4 +288,61 @@ int css_residual_count(unsigned int schid);
>>   void enable_io_isc(uint8_t isc);
>>   int wait_and_check_io_completion(int schid);
>> +/*
>> + * CHSC definitions
>> + */
>> +struct chsc_header {
>> +    u16 len;
>> +    u16 code;
>> +};
>> +
>> +/* Store Channel Subsystem Characteristics */
>> +struct chsc_scsc {
>> +    struct chsc_header req;
>> +    u32 reserved1;
>> +    u32 reserved2;
>> +    u32 reserved3;
>> +    struct chsc_header res;
>> +    u32 format;
>> +    u64 general_char[255];
>> +    u64 chsc_char[254];
>> +};
>> +extern struct chsc_scsc *chsc_scsc;
>> +
>> +#define CSS_GENERAL_FEAT_BITLEN    (255 * 64)
>> +#define CSS_CHSC_FEAT_BITLEN    (254 * 64)
>> +
>> +int get_chsc_scsc(void);
>> +
>> +static inline int _chsc(void *p)
>> +{
>> +    int cc;
>> +
>> +    asm volatile(
>> +        "    .insn   rre,0xb25f0000,%2,0\n"
>> +        "    ipm     %0\n"
>> +        "    srl     %0,28\n"
>> +        : "=d" (cc), "=m" (p)
>> +        : "d" (p), "m" (p)
>> +        : "cc");
>> +
>> +    return cc;
>> +}
>> +
>> +#define CHSC_SCSC    0x0010
>> +#define CHSC_SCSC_LEN    0x0010
>> +
>> +static inline int chsc(void *p, uint16_t code, uint16_t len)
>> +{
>> +    struct chsc_header *h = p;
>> +
>> +    h->code = code;
>> +    h->len = len;
>> +    return _chsc(p);
>> +}
>> +
>> +#include <bitops.h>
>> +#define css_general_feature(bit) test_bit_inv(bit, 
>> chsc_scsc->general_char)
>> +#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
>> +
>>   #endif
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 3c24480..fe05021 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -15,11 +15,59 @@
>>   #include <asm/arch_def.h>
>>   #include <asm/time.h>
>>   #include <asm/arch_def.h>
>> -
>> +#include <alloc_page.h>
>>   #include <malloc_io.h>
>>   #include <css.h>
>>   static struct schib schib;
>> +struct chsc_scsc *chsc_scsc;
>> +
>> +int get_chsc_scsc(void)
>> +{
>> +    int i, n;
>> +    int ret = 0;
>> +    char buffer[510];
>> +    char *p;
>> +
>> +    report_prefix_push("Channel Subsystem Call");
>> +
>> +    if (chsc_scsc) {
>> +        report_info("chsc_scsc already initialized");
>> +        goto end;
>> +    }
>> +
>> +    chsc_scsc = alloc_pages(0);
>> +    report_info("scsc_scsc at: %016lx", (u64)chsc_scsc);
>> +    if (!chsc_scsc) {
>> +        ret = -1;
>> +        report(0, "could not allocate chsc_scsc page!");
>> +        goto end;
>> +    }
>> +
>> +    ret = chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN);
>> +    if (ret) {
>> +        report(0, "chsc: CC %d", ret);
>> +        goto end;
>> +    }
>> +
>> +    for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++)
>> +        if (css_general_feature(i)) {
>> +            n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
>> +            p += n;
>> +        }
>> +    report_info("General features: %s", buffer);
>> +
>> +    for (i = 0, p = buffer, ret = 0; i < CSS_CHSC_FEAT_BITLEN; i++)
>> +        if (css_chsc_feature(i)) {
>> +            n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
>> +            p += n;
>> +        }
> 
> Please use curly braces for the for-loops here, too. Rationale: Kernel 
> coding style:
> 
> "Also, use braces when a loop contains more than a single simple statement"

OK, is better to read.

Thanks,
Pierre


> 
>   Thanks,
>    Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen
