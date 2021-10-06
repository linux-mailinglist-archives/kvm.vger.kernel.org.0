Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7948423AC1
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 11:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbhJFJqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 05:46:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhJFJqi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 05:46:38 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1969ZZ6N026404;
        Wed, 6 Oct 2021 05:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jUaxAu9kW7XFPDuERrOmKryk9MnNZtB5A+0WvKAdASE=;
 b=Y12aTO6ChdIh+mBJkVHvz+mcb5YDviq1ntE+3YOJyqryNWHrZxzS1IpP5eTbykqKx4VF
 1ZjXVp3pzMIsW33bv1iInOgC8GLTbjZjThT6MaIBkn9jCs1/Jp+SJpj7fzBI3CmAGvbE
 Uiy1X/NN+2XzhnXT7nNyvI38egAbxP4HeGXMX2Vn/FHVFFRiyjdXI/h8+oTxaLYmZg5c
 xgY6dbl1rzz0JCuGsnUoyRGliqlVwwQqzUjHhOnFPcNYNAQOnocVND/Rcq2PCkGZxgzR
 4xPtth48yye84PpGj+Tg5YADHzjb/YuqgKRsO0YaAlxB7rR+Mhc87E3IrDg+OY4SCgvp Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh11u1gr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 05:44:45 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1969Zkjt027632;
        Wed, 6 Oct 2021 05:44:45 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bh11u1gqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 05:44:45 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1969giP1009391;
        Wed, 6 Oct 2021 09:44:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2a8ja3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 09:44:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1969ieQm59244862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 09:44:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DE8311C069;
        Wed,  6 Oct 2021 09:44:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0AD711C050;
        Wed,  6 Oct 2021 09:44:39 +0000 (GMT)
Received: from [9.145.176.174] (unknown [9.145.176.174])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 09:44:39 +0000 (GMT)
Message-ID: <3cf309f4-7644-ed41-5c3c-ad6eaac26917@linux.ibm.com>
Date:   Wed, 6 Oct 2021 11:44:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH] s390x: remove myself as reviewer
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211005154114.173511-1-cohuck@redhat.com>
 <a1163106-f9b9-d733-3701-2d0a08acb612@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <a1163106-f9b9-d733-3701-2d0a08acb612@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IB05dB6jTMg2DRrzJIEOfQWjrNMjOpjr
X-Proofpoint-GUID: ZevZbvrCOW5Qip7gtsQzpENtsb3M1Ihv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/21 17:55, Thomas Huth wrote:
> On 05/10/2021 17.41, Cornelia Huck wrote:
>> I don't really have time anymore to spend on s390x reviews
>> here, so don't raise false expectations. There are enough
>> capable people listed already :)
>>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>    MAINTAINERS | 1 -
>>    1 file changed, 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 4fc01a5d54a1..590c0a4fd922 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -87,7 +87,6 @@ S390X
>>    M: Thomas Huth <thuth@redhat.com>
>>    M: Janosch Frank <frankja@linux.ibm.com>
>>    S: Supported
>> -R: Cornelia Huck <cohuck@redhat.com>
>>    R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>    R: David Hildenbrand <david@redhat.com>
>>    L: kvm@vger.kernel.org
> 
> Applied.
> 
> Thank you very much for your contributions, Cornelia!
> 
>    Thomas
> 

Yes, thanks for your reviews!
