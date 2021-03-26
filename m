Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC1E34A39B
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCZJEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:04:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhCZJEe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:04:34 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q93jvE118178
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tHry9HjuIC2zhhNAGoC0MjxE4IJYKqk/SEvQtqhsbH8=;
 b=gS2msh6MN7WHqGio7RUly+9RUPl1Vw/jlfIaVqsAI1M6SioKqeLzQ9OmeXtcDzTtwYds
 sjPUvpA0KD72K8RKiFUNA00Ghc8lYtnL0ZwYvB4grSIVbBj9h99TnTAm0VQkY7CxwR8Z
 6KpRVBkDyQjwr4noP5rYaaoyZZlfUoGeEbWhSF0ig4rw7QQM88mcxTvTuuT87dZa9Y7u
 K8tywlyHFBouPglY/hQmuQMgIA7u1aH6mUoYP1YiLp4q6QlHh9s3Ny5t9aOcFBBVD7H+
 ph+Sft1G8TfmJzyrPLvqbK/ZMUKvQn3R0coqw5rIGZ7uoXxDjy15Cq0tp0DDnjiaoCjG pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37hcgpr7nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:04:33 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12Q94XmH122996
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 05:04:33 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37hcgpr7mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 05:04:33 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8vaQc027052;
        Fri, 26 Mar 2021 09:04:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 37h15188ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 09:04:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12Q949MZ21561718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 09:04:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C87EA409F;
        Fri, 26 Mar 2021 09:04:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B7E3A406F;
        Fri, 26 Mar 2021 09:04:27 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.63.51])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 09:04:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests
 on no device
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
 <5c0f996a-65ae-88b8-3374-a926db37e9d5@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a786c533-ad93-a758-555b-796284d44b14@linux.ibm.com>
Date:   Fri, 26 Mar 2021 10:04:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <5c0f996a-65ae-88b8-3374-a926db37e9d5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f8P2sRTPGtayMxm8ZgJS2DY6sBb1Rjtl
X-Proofpoint-GUID: 5L6YuGb9wWwIPp0rtw0eAjxFqnssQ_IU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_02:2021-03-26,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/21 9:41 AM, Janosch Frank wrote:
> On 3/25/21 10:39 AM, Pierre Morel wrote:
>> We will lhave to test if a device is present for every tests
> 
> s/lhave/have/

yes

> 
>> in the future.
>> Let's provide a macro to check if the device is present and
>> to skip the tests if it is not.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks

> 
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
>> +#define NODEV_SKIP(dev) do {						\
> 
> s/device/schid/ ?
> I have no strong opinions either way so choose what you like best.

can do it.

> 
> Also, since you use report(0, "") so often, maybe you want to introduce
> report_fail() into the library in the future? The x86 vmx tests also use
> report(0, "") a lot so you're not completely alone.
> 
> Could you please move the "do {" one line down so we start with a zero
> indent?

OK


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
