Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3143B447F85
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhKHMiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:38:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239535AbhKHMim (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:38:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8B0T6k032708
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5bnOeWmT29a43iTYgDQ+Ns1/KFLJmZ5tHnBCmxIot8g=;
 b=k8/0jTD7CUbVYWOhjavRjdvGjJ2G9/uVBzQ5Kv55CDIosdi3bQHD8U/Shmkl1eYNfCkQ
 D5Qh6mI1heDub1PYdHA+9+MYWIIuzMCUDvEMDKQ8UZ6A3tdQSm66MQrXLDG/JoT/vJ9S
 Kxw50gPuo3dSRhnR1VVh1ISOzqT+q3zFtcMay6F9A0dW/NBW7Lw1jdKLkMb4tz991ZHd
 fVpNTJhpoaeGy1D0JMJL/gJ+erTvGC0BDiiwzrtFrYZgIvrfTGEFVYsPVgCG9gly2rYj
 X5RdDNsA0IsAanfFRt6VVingCPvzy78FYfWORzhx0RRvW4dTxyfCVOi5NszHl4fbGBDA sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66u16pp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:35:57 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8AuM8p008188
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:35:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66u16pne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:35:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CLj5j000846;
        Mon, 8 Nov 2021 12:35:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hb9wxp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:35:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CZquI197208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:35:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C9B742052;
        Mon,  8 Nov 2021 12:35:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8699842042;
        Mon,  8 Nov 2021 12:35:50 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:35:50 +0000 (GMT)
Message-ID: <1abcdea2-c9d1-c4e0-6f53-c806e80403a9@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:36:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 4/7] s390x: css: registering IRQ
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-5-git-send-email-pmorel@linux.ibm.com>
 <8aee772e-cb44-4d3d-16bd-186b90257407@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <8aee772e-cb44-4d3d-16bd-186b90257407@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MarS54v6bZ9e0Y6d2GAiaPAnshwZK1Qe
X-Proofpoint-ORIG-GUID: ZjcDswrxuFFIiiV_a6bcJ-r5Kz66Y5m8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 09:01, Thomas Huth wrote:
> On 27/08/2021 12.17, Pierre Morel wrote:
>> Registering IRQ for the CSS level.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 21 +++++++++++++++++++++
>>   lib/s390x/css_lib.c | 27 +++++++++++++++++++++++++--
>>   2 files changed, 46 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 2005f4d7..0422f2e7 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -402,4 +402,25 @@ struct measurement_block_format1 {
>>       uint32_t irq_prio_delay_time;
>>   };
>> +#include <asm/arch_def.h>
>> +static inline void disable_io_irq(void)
>> +{
>> +    uint64_t mask;
>> +
>> +    mask = extract_psw_mask();
>> +    mask &= ~PSW_MASK_IO;
>> +    load_psw_mask(mask);
>> +}
>> +
>> +static inline void enable_io_irq(void)
>> +{
>> +    uint64_t mask;
>> +
>> +    mask = extract_psw_mask();
>> +    mask |= PSW_MASK_IO;
>> +    load_psw_mask(mask);
>> +}
>> +
>> +int register_css_irq_func(void (*f)(void));
>> +int unregister_css_irq_func(void (*f)(void));
>>   #endif
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 484f9c41..a89fc93c 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -350,8 +350,29 @@ bool css_disable_mb(int schid)
>>       return retry_count > 0;
>>   }
>> -static struct irb irb;
>> +static void (*css_irq_func)(void);
>> +
>> +int register_css_irq_func(void (*f)(void))
>> +{
>> +    if (css_irq_func)
>> +        return -1;
>> +    css_irq_func = f;
>> +    assert(register_io_int_func(css_irq_io) == 0);
> 
> It's unlikely that we ever disable assert() in the k-u-t, but anyway, 
> I'd prefer not to put function calls within assert() statements, just in 
> case. So could you please replace this with:
> 
>      rc = register_io_int_func(css_irq_io);
>      assert(rc == 0);
>  > ?

OK

> 
>> +    enable_io_isc(0x80 >> IO_SCH_ISC);
>> +    return 0;
>> +}
>> +int unregister_css_irq_func(void (*f)(void))
>> +{
>> +    if (css_irq_func != f)
>> +        return -1;
>> +    enable_io_isc(0);
>> +    unregister_io_int_func(css_irq_io);
>> +    css_irq_func = NULL;
>> +    return 0;
>> +}
>> +
>> +static struct irb irb;
>>   void css_irq_io(void)
>>   {
>>       int ret = 0;
>> @@ -386,7 +407,9 @@ void css_irq_io(void)
>>           report(0, "tsch reporting sch %08x as not operational", sid);
>>           break;
>>       case 0:
>> -        /* Stay humble on success */
>> +        /* Call upper level IRQ routine */
>> +        if (css_irq_func)
>> +            css_irq_func();
>>           break;
>>       }
>>   pop:
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
