Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECEC34D06A
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 14:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhC2Mu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 08:50:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45988 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231520AbhC2Mu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 08:50:28 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TCXTED057529
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=o9YkwLGDtKpj99AbLyQjndegOkXlSVbDrFrOKtgrYAI=;
 b=aOHzcj3D92srfywkL8896MZ7mVaBhxV8IOWub8g+neI9X06Yp6Zj+OxFMX0L7aMMRfbw
 olH61z+LXY8oo3yziLIJ1yFXwswWvw8MMPgIXQHpZQe3IZ1UDhhg1kkn1Kzo5gNFrHA+
 kGqAX8POtovmrVN0raE0LMlYlCkB3xeoEoqhaqV+hpZ4pjJK8LvxhS787lFRd6luMLYD
 EDY5/UnReDzzjRVFiNhnuGOtLrXmpccKrkv0kVjEbw6tL/ycO6qjxi8nhBAZ68PofpLw
 rGo4b6peGx2qGfmsKZVcxKORlAvM1g5dEDtnJIhgfNEvE4xT4I5qM+xyMJlZqRUMnXyn oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpmeaeyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:50:27 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TCXadq058001
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:50:27 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpmeaexw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 08:50:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TCge0q031217;
        Mon, 29 Mar 2021 12:50:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37huyh9tfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:50:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TCo4JH23134670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 12:50:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A9542047;
        Mon, 29 Mar 2021 12:50:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EDDC4203F;
        Mon, 29 Mar 2021 12:50:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 12:50:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests
 on no device
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
 <5caf129d-08e9-0efa-5110-9330ac856eff@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ce270f66-3d17-92d3-81d2-59fd9e0bd87f@linux.ibm.com>
Date:   Mon, 29 Mar 2021 14:50:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <5caf129d-08e9-0efa-5110-9330ac856eff@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c3LJprFkA-uG2dNh-0HPZgFfGvKL5yDr
X-Proofpoint-ORIG-GUID: YBg_PuScx--ZsIGSInMThZ1StmEJUZpP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_08:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 10:19 AM, Thomas Huth wrote:
> On 25/03/2021 10.39, Pierre Morel wrote:
>> We will lhave to test if a device is present for every tests
>> in the future.
>> Let's provide a macro to check if the device is present and
>> to skip the tests if it is not.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 27 +++++++++++----------------
>>   1 file changed, 11 insertions(+), 16 deletions(-)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index c340c53..16723f6 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -27,6 +27,13 @@ static int test_device_sid;
>>   static struct senseid *senseid;
>>   struct ccw1 *ccw;
>> +#define NODEV_SKIP(dev) do {                        \
>> +                if (!(dev)) {                \
>> +                    report_skip("No device");    \
>> +                    return;                \
>> +                }                    \
>> +            } while (0)
>> +
>>   static void test_enumerate(void)
>>   {
>>       test_device_sid = css_enumerate();
>> @@ -41,10 +48,7 @@ static void test_enable(void)
>>   {
>>       int cc;
>> -    if (!test_device_sid) {
>> -        report_skip("No device");
>> -        return;
>> -    }
>> +    NODEV_SKIP(test_device_sid);
>>       cc = css_enable(test_device_sid, IO_SCH_ISC);
>> @@ -62,10 +66,7 @@ static void test_sense(void)
>>       int ret;
>>       int len;
>> -    if (!test_device_sid) {
>> -        report_skip("No device");
>> -        return;
>> -    }
>> +    NODEV_SKIP(test_device_sid);
>>       ret = css_enable(test_device_sid, IO_SCH_ISC);
>>       if (ret) {
>> @@ -218,10 +219,7 @@ static void test_schm_fmt0(void)
>>       struct measurement_block_format0 *mb0;
>>       int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
>> -    if (!test_device_sid) {
>> -        report_skip("No device");
>> -        return;
>> -    }
>> +    NODEV_SKIP(test_device_sid);
>>       /* Allocate zeroed Measurement block */
>>       mb0 = alloc_io_mem(shared_mb_size, 0);
>> @@ -289,10 +287,7 @@ static void test_schm_fmt1(void)
>>   {
>>       struct measurement_block_format1 *mb1;
>> -    if (!test_device_sid) {
>> -        report_skip("No device");
>> -        return;
>> -    }
>> +    NODEV_SKIP(test_device_sid);
>>       if (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
>>           report_skip("Extended measurement block not available");
>>
> 
> I wonder whether it would be easier to simply skip all tests in main() 
> if the test device is not available, instead of checking it again and 
> again and again...?
> 
>   Thomas
> 

I will silently skip the remaining tests when the enumeration fails or 
do you want that we see other information?
It seems obvious enough that finding no device we do not continue testing.

-- 
Pierre Morel
IBM Lab Boeblingen
