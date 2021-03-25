Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24533496B6
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhCYQWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:22:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhCYQWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:22:02 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PG4nJp136220
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xxBd/hEmMfEkTD7FnQP30SMG0ZVutARh5b/gJRuVDJ4=;
 b=E4AgPbzkk4XqlI6vfikmK6z34lGhyTF5IUCNJb+Dy2H10jWcz73bOYY3Eizbrh0JBl9i
 Z0ZqOOnjSYv8PD0Otkp4yT6cBgVIt+H+tqJnHAZWf0mgIFtOb8q6dU5abLLsf9M3hGuo
 ZJbXJTTh/sEXDV7XcCSkfdRtEu3YTu9PVxsadAoqv7VbSKyz77agulUj4joAr2/43769
 7Y9wxWyLN1jg46bXbtDyDCQVClYC5cnVOpTJZTFuRbdhObuIpQlfBiKuGLub1D4MxB0l
 IK3emZ08n1TVQ8YhhVU7MAn322znjv0ZDyVb0ce6xnLMX2NCYcLFdMnb3PcRaZYdqefv bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gpm5e9pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:22:02 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG4mhw135612
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:22:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gpm5e9ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:22:02 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PGIIee010069;
        Thu, 25 Mar 2021 16:21:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 37d9a6jw4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:21:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PGLccU33685906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:21:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE19E11C04A;
        Thu, 25 Mar 2021 16:21:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 927E511C04C;
        Thu, 25 Mar 2021 16:21:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:21:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests
 on no device
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
 <20210325162134.3f2f3f9e@ibm-vm>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ab5c40d0-a35f-53e9-74d5-9463d98f5bcd@linux.ibm.com>
Date:   Thu, 25 Mar 2021 17:21:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325162134.3f2f3f9e@ibm-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 4:21 PM, Claudio Imbrenda wrote:
> On Thu, 25 Mar 2021 10:39:02 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We will lhave to test if a device is present for every tests
>> in the future.
>> Let's provide a macro to check if the device is present and
>> to skip the tests if it is not.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 27 +++++++++++----------------
>>   1 file changed, 11 insertions(+), 16 deletions(-)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index c340c53..16723f6 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -27,6 +27,13 @@ static int test_device_sid;
>>   static struct senseid *senseid;
>>   struct ccw1 *ccw;
>>   
>> +#define NODEV_SKIP(dev) do {
>> 	\
>> +				if (!(dev)) {
>> 	\
>> +					report_skip("No
>> device");	\
>> +					return;
>> 		\
>> +				}
>> 	\
>> +			} while (0)
> 
> I wonder if you can add for example which device is not present (might
> help with debugging)

potentially any CSS device would be OK for most of the tests.
For simplicity we use virtio-net-ccw because it does not require any 
argument for allowing us to sense it.

When we need a more specific device I will add information.

> 
> in any case:
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
