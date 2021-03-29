Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E2834CE63
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 13:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhC2LAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 07:00:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232758AbhC2LAp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 07:00:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TAZBJn143084
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bjG//lJaiCc3GN8Xb/Ok4FXq7HrvqZTBOSDox1zosK8=;
 b=WRrz5EiM/lV1KKHhBep8RAvrSbJKs0DanwUEUuch9FzrmZlBUGLUQnrS7gfv7sdm99UO
 ppZQMnk4G8N03qPGUvvaL0c6CyKYiPStAFuXlp6lmoa0wJi5KbkVHgLSwbSBPYnxX+YT
 fi7PiB51Q+fcjyFeee0SfudLpG45CJ6U7xPqQkYrm+k4VcXPy3+bci7b03/8tLQFqOTs
 HIRQ9K2nm7Ct9dq7e9RAhbeK0xSIrPj0+b+l+Nr0f8nK1hLXLnTmr78up+IftgYN1Kra
 miVHvPH8wv9TRMfK4XA0voGbT9QgRpMB8juj9QkByVAgb982rqiWhHiUwaivRhNppX/V sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jj5yuvwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:00:44 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TAigHC181117
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:00:44 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jj5yuvw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 07:00:44 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TAqPEm032135;
        Mon, 29 Mar 2021 11:00:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 37huyh9qyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 11:00:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TB0dJu42008854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 11:00:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 985774203F;
        Mon, 29 Mar 2021 11:00:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3983442045;
        Mon, 29 Mar 2021 11:00:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 11:00:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait for
 IRQ and check I/O completion
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
 <8a8430c6-a345-22aa-29ae-5df77b5d3b9c@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <72eb6ac1-8bb8-99c6-24a0-0bb36bd40c69@linux.ibm.com>
Date:   Mon, 29 Mar 2021 13:00:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <8a8430c6-a345-22aa-29ae-5df77b5d3b9c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RotftaE8M6iToVgNntuVi1RXRDf8Iobc
X-Proofpoint-ORIG-GUID: pKaT62MvEc277Y52rqKa8JBbdX9-3Oeg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_05:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103290082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 10:21 AM, Thomas Huth wrote:
> On 25/03/2021 10.39, Pierre Morel wrote:
>> We will may want to check the result of an I/O without waiting
>> for an interrupt.
>> For example because we do not handle interrupt.
>> Let's separate waiting for interrupt and the I/O complretion check.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 13 ++++++++++---
>>   2 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 0058355..5d1e1f0 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -317,6 +317,7 @@ int css_residual_count(unsigned int schid);
>>   void enable_io_isc(uint8_t isc);
>>   int wait_and_check_io_completion(int schid);
>> +int check_io_completion(int schid);
>>   /*
>>    * CHSC definitions
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index f5c4f37..1e5c409 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -487,18 +487,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int 
>> count, unsigned char flags)
>>   }
>>   /* wait_and_check_io_completion:
>> + * @schid: the subchannel ID
>> + */
>> +int wait_and_check_io_completion(int schid)
>> +{
>> +    wait_for_interrupt(PSW_MASK_IO);
>> +    return check_io_completion(schid);
>> +}
>> +
>> +/* check_io_completion:
>>    * @schid: the subchannel ID
>>    *
>>    * Makes the most common check to validate a successful I/O
>>    * completion.
>>    * Only report failures.
>>    */
>> -int wait_and_check_io_completion(int schid)
>> +int check_io_completion(int schid)
>>   {
>>       int ret = 0;
>> -    wait_for_interrupt(PSW_MASK_IO);
>> -
>>       report_prefix_push("check I/O completion");
>>       if (lowcore_ptr->io_int_param != schid) {
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
