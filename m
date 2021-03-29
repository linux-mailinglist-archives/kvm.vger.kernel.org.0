Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1B234CE68
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhC2LCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 07:02:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230432AbhC2LCO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 07:02:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TAZBxS040576
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3SfSptlLB11IYCQhbRl7f4VYa1ppjLkfeIGyfQeWrjM=;
 b=S6Eqk1sQTs80BO4l6dGh6aamqEVI0TgEnBWTHYm0U9y3OTNteb+FJ5zkI3+n5DnhtLr4
 /r8SSKJ6Zy51UWO8aTr28sXrUAqNe5nQBvASfBuBo7Ke1fv4mUaiHSRXiiAtw0jkiWA3
 MHIG9P4/4PBDY4iCGJnPOz9Pca/KzzlL5qFSfyeaMY4ANvjOrIG60007qNOC/a7Wg93/
 gJXfriXskQFKWY60YthbxvBlXXbDfXA+cFI4NrVsvCaTXQXjc3N0I/evAldgZu89ppE4
 5Q1OnE9StdOmA9HwlqLCww/ztRTRF14l1pb7+ibJiiTrcFMDbDGU1MJxmcRFlKMycmKa gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhru42yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:02:14 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TAZFtp040982
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:02:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhru42xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 07:02:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TB1mN4027499;
        Mon, 29 Mar 2021 11:02:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 37hvb8hqgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 11:02:11 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TB1nRs29688112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 11:01:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5B74204F;
        Mon, 29 Mar 2021 11:02:08 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 681444204C;
        Mon, 29 Mar 2021 11:02:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 11:02:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl
 expectations to check I/O completion
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
 <b1ccfed0-5a1c-323d-2176-39513fbde391@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <00d5b396-d61b-7c52-1c29-c65a34f202b6@linux.ibm.com>
Date:   Mon, 29 Mar 2021 13:02:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b1ccfed0-5a1c-323d-2176-39513fbde391@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bZFBp8mthJ9itf3YN5AezVn-HZNCLNJZ
X-Proofpoint-ORIG-GUID: Dblmq1c5rgoc5px5e5f7MC3imuTdbURn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_05:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 10:27 AM, Thomas Huth wrote:
> On 25/03/2021 10.39, Pierre Morel wrote:
>> When checking for an I/O completion may need to check the cause of
>> the interrupt depending on the test case.
>>
>> Let's provide the tests the possibility to check if the last
>> valid IRQ received is for the function expected after executing
>> an instruction or sequence of instructions and if all ctrl flags
>> of the SCSW are set as expected.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  4 ++--
>>   lib/s390x/css_lib.c | 21 ++++++++++++++++-----
>>   s390x/css.c         |  4 ++--
>>   3 files changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 5d1e1f0..1603781 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -316,8 +316,8 @@ void css_irq_io(void);
>>   int css_residual_count(unsigned int schid);
>>   void enable_io_isc(uint8_t isc);
>> -int wait_and_check_io_completion(int schid);
>> -int check_io_completion(int schid);
>> +int wait_and_check_io_completion(int schid, uint32_t ctrl);
>> +int check_io_completion(int schid, uint32_t ctrl);
>>   /*
>>    * CHSC definitions
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 1e5c409..55e70e6 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int 
>> count, unsigned char flags)
>>   /* wait_and_check_io_completion:
>>    * @schid: the subchannel ID
>> + * @ctrl : expected SCSW control flags
>>    */
>> -int wait_and_check_io_completion(int schid)
>> +int wait_and_check_io_completion(int schid, uint32_t ctrl)
>>   {
>>       wait_for_interrupt(PSW_MASK_IO);
>> -    return check_io_completion(schid);
>> +    return check_io_completion(schid, ctrl);
>>   }
>>   /* check_io_completion:
>>    * @schid: the subchannel ID
>> + * @ctrl : expected SCSW control flags
>>    *
>> - * Makes the most common check to validate a successful I/O
>> - * completion.
>> + * If the ctrl parameter is not null check the IRB SCSW ctrl
>> + * against the ctrl parameter.
>> + * Otherwise, makes the most common check to validate a successful
>> + * I/O completion.
>>    * Only report failures.
>>    */
>> -int check_io_completion(int schid)
>> +int check_io_completion(int schid, uint32_t ctrl)
>>   {
>>       int ret = 0;
>> @@ -515,6 +519,13 @@ int check_io_completion(int schid)
>>           goto end;
>>       }
>> +    if (ctrl && (ctrl ^ irb.scsw.ctrl)) {
> 
> With the xor, you can only check for enabled bits ... do we also want to 
> check for disabled bits, or is this always out of scope?
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
