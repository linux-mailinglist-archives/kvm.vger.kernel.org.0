Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D250474F39
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfGYNYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 09:24:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfGYNYI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jul 2019 09:24:08 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PDM8H8112696;
        Thu, 25 Jul 2019 09:24:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tybqbcse8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 09:24:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6PDMLav113681;
        Thu, 25 Jul 2019 09:24:07 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tybqbcsdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 09:24:07 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6PDJTAj023197;
        Thu, 25 Jul 2019 13:24:06 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 2tx61n6sg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 13:24:06 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6PDO1Vd53346578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 13:24:01 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AB0B6E05B;
        Thu, 25 Jul 2019 13:24:01 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD536E052;
        Thu, 25 Jul 2019 13:24:00 +0000 (GMT)
Received: from [9.56.58.37] (unknown [9.56.58.37])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 25 Jul 2019 13:24:00 +0000 (GMT)
Subject: Re: [PATCH 1/1] MAINTAINERS: vfio-ccw: Remove myself as the
 maintainer
To:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1564003585.git.alifm@linux.ibm.com>
 <19aee1ab0e5bcc01053b515117a66426a9332086.1564003585.git.alifm@linux.ibm.com>
 <20190725093335.09c96c0d.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Message-ID: <42b67a01-1194-7f4b-5c13-ad86454590f7@linux.ibm.com>
Date:   Thu, 25 Jul 2019 09:24:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190725093335.09c96c0d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/25/2019 03:33 AM, Cornelia Huck wrote:
> On Wed, 24 Jul 2019 17:32:03 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> I will not be able to continue with my maintainership responsibilities
>> going forward, so remove myself as the maintainer.
> 
> ::sadface::
> 
> Thank you for all of your good work!

It was a pleasure working with everyone :)

Thanks for all your help.

Thanks
Farhan

> 
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   MAINTAINERS | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0e90487..dd07a23 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -13696,7 +13696,6 @@ F:	drivers/pci/hotplug/s390_pci_hpc.c
>>   
>>   S390 VFIO-CCW DRIVER
>>   M:	Cornelia Huck <cohuck@redhat.com>
>> -M:	Farhan Ali <alifm@linux.ibm.com>
>>   M:	Eric Farman <farman@linux.ibm.com>
>>   R:	Halil Pasic <pasic@linux.ibm.com>
>>   L:	linux-s390@vger.kernel.org
> 
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> 
> Heiko/Vasily/Christian: can you take this one directly through the s390
> tree?
> 
> 
