Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD87034E806
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 14:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhC3MzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 08:55:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhC3Myg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 08:54:36 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UCa8qN144193
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aVSkNDLA61lEY2CCD0OLmK0kdMOgGHo+MtdoAvML1lY=;
 b=Pw9RaY48xYF9J3oxo5TWgNU7+mN5LzaJ69pnEID3ehOGdGqfJp2rh7DbBYEsyPCSoBvw
 RdLpO+FsBnX/uYKDpGSRSj3YidMytArmBaDfIBv54wL32pt1ZJ6tIwiQqS15VE/E5ZxV
 beMPHFY5itMcPxNissJapHps49W0jFn4D9BjMcndo4WQIIyRZnXGzuoIuXxK4CV0em2L
 tUO/AoGY3jAgdQd97NvwdYHOsObGEGvtJO3c4UjbtFIYVtuXLjFyvInne9ZwF9SujeC8
 UP5Y5QVeQSBYMyN06p5Zr4nKGsjddhPe/DtX9mOi1xBWa1FD+AdW5VT0KBttaPrhicIt bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhnmfkdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:54:35 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UChh8o194183
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:54:35 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhnmfkd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 08:54:35 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12UCrLi8001672;
        Tue, 30 Mar 2021 12:54:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 37hvb89emr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 12:54:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12UCsANk35717542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 12:54:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFACDAE053;
        Tue, 30 Mar 2021 12:54:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A09D0AE045;
        Tue, 30 Mar 2021 12:54:29 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Mar 2021 12:54:29 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl
 expectations to check I/O completion
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
 <20210330141016.66dff372.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <1e63616f-19d9-170b-75dc-4784184fb99a@linux.ibm.com>
Date:   Tue, 30 Mar 2021 14:54:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330141016.66dff372.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LvtiO-w0fM1fvZweS5UnHtscxOTZw2FX
X-Proofpoint-ORIG-GUID: P-2_c5Z6X7G8i2qFQTcmPPweidNKMeaw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/30/21 2:10 PM, Cornelia Huck wrote:
> On Thu, 25 Mar 2021 10:39:04 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> When checking for an I/O completion may need to check the cause of
>> the interrupt depending on the test case.
> 
> "When we check for the completion of an I/O, we may need to check..." ?
> 

yes, thanks

>>
>> Let's provide the tests the possibility to check if the last
>> valid IRQ received is for the function expected after executing
> 
> "Let's make it possible for the tests to check whether the last valid
> IRB received indicates the expected functions..." ?


better too :)

> 
>> an instruction or sequence of instructions and if all ctrl flags
>> of the SCSW are set as expected.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  4 ++--
>>   lib/s390x/css_lib.c | 21 ++++++++++++++++-----
>>   s390x/css.c         |  4 ++--
>>   3 files changed, 20 insertions(+), 9 deletions(-)
>>
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 1e5c409..55e70e6 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>>   
>>   /* wait_and_check_io_completion:
>>    * @schid: the subchannel ID
>> + * @ctrl : expected SCSW control flags
>>    */
>> -int wait_and_check_io_completion(int schid)
>> +int wait_and_check_io_completion(int schid, uint32_t ctrl)
>>   {
>>   	wait_for_interrupt(PSW_MASK_IO);
>> -	return check_io_completion(schid);
>> +	return check_io_completion(schid, ctrl);
>>   }
>>   
>>   /* check_io_completion:
>>    * @schid: the subchannel ID
>> + * @ctrl : expected SCSW control flags
>>    *
>> - * Makes the most common check to validate a successful I/O
>> - * completion.
>> + * If the ctrl parameter is not null check the IRB SCSW ctrl
>> + * against the ctrl parameter.
>> + * Otherwise, makes the most common check to validate a successful
>> + * I/O completion.
> 
> What about:
> 
> "Perform some standard checks to validate a successful I/O completion.
> If the ctrl parameter is not zero, additionally verify that the
> specified bits are indicated in the IRB SCSW ctrl flags."

Yes, looks better, thanks

> 
>>    * Only report failures.
>>    */
>> -int check_io_completion(int schid)
>> +int check_io_completion(int schid, uint32_t ctrl)
>>   {
>>   	int ret = 0;
>>   
> 
> With Thomas' suggested change,
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
