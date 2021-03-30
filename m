Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F7234E81F
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 14:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhC3M6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 08:58:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232033AbhC3M6n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 08:58:43 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UCXRAR133262
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=izhdEdIPGxWJNaAMgj3q0oGbBN6KmAUtKbIUSpaRd5E=;
 b=qlsCqcjRLNSWMYOE3l1tLuJ1UDS7nJkLxMUMhD7nAKp8BNfSTB6scXSHL/dU9tmepTaC
 kFQAL2EiFFl7PfzCkexgY3lVZIBNFaaqbVCVOpRr1UVuQWztYllohlTPQUQMm8uvcSS7
 hpxtDVdIndQTr5nE4KY1BGF+2YJm7N5583wA4yn/OcVBlx4BIO9vFHi6segsk4Acq92r
 S7oi85ajktV3NyFy2juFLO2yD8N1sI9cdys0xrRQFtDh8Yq/VdiWVkNEf2Yjyc3QcBf2
 LOx4adSe3LC32BHQWtJhO61xZKFOoV+IAmW/a3SC6cRpsDUPfV0dB+F5yhWh/u+QQMh9 Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37juxcdq9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:58:42 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UCv74a039244
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:58:42 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37juxcdq8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 08:58:42 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12UCwM5N012340;
        Tue, 30 Mar 2021 12:58:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37huyhaqxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 12:58:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12UCwbdk32637270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 12:58:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4983BAE059;
        Tue, 30 Mar 2021 12:58:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3E14AE055;
        Tue, 30 Mar 2021 12:58:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Mar 2021 12:58:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests
 on no device
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
 <5caf129d-08e9-0efa-5110-9330ac856eff@redhat.com>
 <ce270f66-3d17-92d3-81d2-59fd9e0bd87f@linux.ibm.com>
 <20210330135250.00372e8e.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <04d4a8e5-3cc0-153b-5527-4ed9a936cb9e@linux.ibm.com>
Date:   Tue, 30 Mar 2021 14:58:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210330135250.00372e8e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0t7UcdLMMDPFeyR4FZf7dUvbEw1G5Xx6
X-Proofpoint-ORIG-GUID: imzw-0QiouOuHUQc7WD7mZsUC7YmTjRd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/30/21 1:52 PM, Cornelia Huck wrote:
> On Mon, 29 Mar 2021 14:50:22 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 3/29/21 10:19 AM, Thomas Huth wrote:
>>> On 25/03/2021 10.39, Pierre Morel wrote:
>>>> We will lhave to test if a device is present for every tests
>>>> in the future.
>>>> Let's provide a macro to check if the device is present and
>>>> to skip the tests if it is not.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    s390x/css.c | 27 +++++++++++----------------
>>>>    1 file changed, 11 insertions(+), 16 deletions(-)
> 
>>> I wonder whether it would be easier to simply skip all tests in main()
>>> if the test device is not available, instead of checking it again and
>>> again and again...?
>>>
>>>    Thomas
>>>    
>>
>> I will silently skip the remaining tests when the enumeration fails or
>> do you want that we see other information?
>> It seems obvious enough that finding no device we do not continue testing.
> 
> Logging that the device enumeration failed should be enough info.
> 

OK then I do so.
Thanks
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
