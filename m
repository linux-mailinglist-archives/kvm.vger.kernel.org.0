Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCB13F011C
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhHRJ6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:58:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233439AbhHRJ6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:58:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I9WqdY188087;
        Wed, 18 Aug 2021 05:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SsHBtASAdv4MIKtDhpNNBLkNGVMO0kD5807ncWUrXMc=;
 b=Tat9xi6w5BkrOceQwW/fc+vCoBoI4EsIWDieRfM+9gLGyzkiUMvRlQvK/AEsQhOXtZRZ
 GzzqBrZcuBsS04Ecw50nnfA7lZ9mZglNFi4+Gy0vVlPnEf6ArUEDPV3Uo+vVvWNmcfVW
 L2Cn5s/MBXHYaJ3hZLPyfYgICNQtHt5xrOMKAx0BDqPQhTaG9LWP+YreRnCRcdNbtrrI
 RybEcciyHN+YDYSQnBchcMTUdD34spZK/BMKhbDW3/g7MVLSIfSoifgKUAvXzUzgXUT6
 1l8BGkPJaSZ1Tzem9ukJw/ti2z1Xl+HdiaXXQNwspyQ7+U3Jg1Uaqp5IIzMvxwTWD+qh ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1ye2y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:57:54 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17I9XmxU193901;
        Wed, 18 Aug 2021 05:57:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1ye2xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 05:57:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17I9v2ga013414;
        Wed, 18 Aug 2021 09:57:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8ebgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:57:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17I9sKHx25887210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 09:54:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DB0DA4068;
        Wed, 18 Aug 2021 09:57:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 042E2A4062;
        Wed, 18 Aug 2021 09:57:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.181])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 09:57:49 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 8/8] lib: s390x: uv: Add rc 0x100 query
 error handling
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-9-frankja@linux.ibm.com>
 <182d9128-89a4-7ae0-1e2b-ba1df17cc706@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <94a1f3ea-3a5c-989c-5362-c7a7a1d65b49@linux.ibm.com>
Date:   Wed, 18 Aug 2021 11:57:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <182d9128-89a4-7ae0-1e2b-ba1df17cc706@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Csup6iKOLsEV7gjJ5FWHxrs-S-tpdVTs
X-Proofpoint-GUID: JA8nNIm3TXvXga9IDvb3jneiradZcSu1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 11:30 AM, Thomas Huth wrote:
> On 13/08/2021 09.36, Janosch Frank wrote:
>> Let's not get bitten by an extension of the query struct and handle
>> the rc 0x100 error properly which does indicate that the UV has more
>> data for us.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/uv.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
>> index fd9de944..c5c69c47 100644
>> --- a/lib/s390x/uv.c
>> +++ b/lib/s390x/uv.c
>> @@ -49,6 +49,8 @@ int uv_setup(void)
>>   	if (!test_facility(158))
>>   		return 0;
>>   
>> -	assert(!uv_call(0, (u64)&uvcb_qui));
>> +	uv_call(0, (u64)&uvcb_qui);
>> +
>> +	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
> 
> Don't you want to continue to check the return code of the uv_call() function?
> 
>   Thomas
> 

The rc==0x100 case is a cc==1 and the rc==1 is a cc==0 so I had to
delete the check.

Those smaller patches are already upstream btw.
