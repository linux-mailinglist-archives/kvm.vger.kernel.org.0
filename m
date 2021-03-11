Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B15336FC2
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 11:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhCKKUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 05:20:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232167AbhCKKUo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 05:20:44 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BA41gi139766
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3GIboboKavxO6PTysyeldLNLATQw46jb5rVu0wPEhuw=;
 b=ATaNJMj5AkbMr0xukAhK3p/waiiLTsIxgV+E/9es0+CmnvUwhHI1QoRaDMNxkGT1CB8k
 HI64uBcjBsK+UnNUKDryIgLvTkDylaTKHy4vf6yGjXHLXnPLDa4xFWSri3ZkG7jPVNBd
 4OkUmuUB0aBzrsqBC51os8QGVhCMq1mYB4EBZKm6Zl/CxelRGSTIOcxeDRZgK3ghWJxQ
 r/S0GFGMHA0wbOVHYHi0OhZcxuM4MrD9c9W/NkmQwb73Qlgw3BHRJcd4xkw8x66bD/6m
 OUvV3KkPemHOHHljZwgMc/AwPu2dd61BKFrKQpCsheUAoC4ndZVbzHfOO4ZGkOrMKes+ qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774kxhjne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:20:43 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12BA4bqw141086
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:20:43 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774kxhjms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 05:20:43 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12BACNRO009945;
        Thu, 11 Mar 2021 10:20:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3768n60ydu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:20:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12BAKbeU39256552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 10:20:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FFF211C052;
        Thu, 11 Mar 2021 10:20:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51CE211C04A;
        Thu, 11 Mar 2021 10:20:37 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 10:20:37 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 4/6] s390x: css: implementing Set
 CHannel Monitor
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
 <1615294277-7332-5-git-send-email-pmorel@linux.ibm.com>
 <20210309175644.2cf7d11d.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <98f6268b-f549-fe34-bd91-5b2f65aac718@linux.ibm.com>
Date:   Thu, 11 Mar 2021 11:20:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309175644.2cf7d11d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_04:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/9/21 5:56 PM, Cornelia Huck wrote:
> On Tue,  9 Mar 2021 13:51:15 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We implement the call of the Set CHannel Monitor instruction,
>> starting the monitoring of the all Channel Sub System, and
>> initializing channel subsystem monitoring.
>>
>> Initial tests report the presence of the extended measurement block
>> feature, and verify the error reporting of the hypervisor for SCHM.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 16 ++++++++++++++--
>>   lib/s390x/css_lib.c |  4 ++--
>>   s390x/css.c         | 35 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 51 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 3c50fa8..7158423 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -309,6 +309,7 @@ struct chsc_scsc {
>>   	uint8_t reserved[9];
>>   	struct chsc_header res;
>>   	uint32_t res_fmt;
>> +#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
>>   	uint64_t general_char[255];
>>   	uint64_t chsc_char[254];
>>   };
>> @@ -356,8 +357,19 @@ static inline int _chsc(void *p)
>>   bool chsc(void *p, uint16_t code, uint16_t len);
>>   
>>   #include <bitops.h>
>> -#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
>> -#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
>> +#define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
>> +#define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> 
> I think the renaming belongs in patch 1?

grr, yes obviously :)

thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
