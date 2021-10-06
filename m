Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27688424579
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhJFSAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 14:00:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229565AbhJFSAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 14:00:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196HbBS7011936;
        Wed, 6 Oct 2021 13:58:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZxUfO62xDqeqzPRMt/URL0wliv8TA0IjPFK7/jjl8G4=;
 b=XpGk2EkBhZMmd4tX5BvcYrCSnrs10/sUW6jvU6r9MdfvK9ae87M4X1Wy9yOoxKGDSziJ
 eft4wkRsKZBD33bQG8e2ot9f6LizkrtETz7Tr5vF9aH45fKf3KzyvItdZzRYtUU0sbHg
 t7VUcc+KGBA0Uh9JuzR5iqpY1B+9pYFvjZG50LwMX3aB7K/H1spakdPq5ZthRUgRHQSN
 QCKbIp2DsUaSXkUNgZ6sJgfX86K3TqKosVSOGD7JVwnJHmwR+IjztW/9mwtLxDDCF9O3
 bs9GlCzw7k3gCugKsnN9vQwfdMVPtuaz00xm6qNrRl9TcX7yJjzNJCZsQpwQbkZxTuGV jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcscpun6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 13:58:23 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 196HpwMB028807;
        Wed, 6 Oct 2021 13:58:23 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcscpumx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 13:58:23 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196HwI9S019364;
        Wed, 6 Oct 2021 17:58:22 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04wdc.us.ibm.com with ESMTP id 3bef2bresn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 17:58:22 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196HwLg433685882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 17:58:21 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 959CAAE071;
        Wed,  6 Oct 2021 17:58:21 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 441EFAE064;
        Wed,  6 Oct 2021 17:58:20 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com (unknown [9.211.96.29])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 17:58:20 +0000 (GMT)
Subject: Re: [PATCH 2/2] vfio-ccw: step down as maintainer
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20211006160120.217636-1-cohuck@redhat.com>
 <20211006160120.217636-3-cohuck@redhat.com>
 <6649c066e16bced2786306c401f14113b4699d1f.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <a4391757-bbb6-7f70-8dfa-a572024918b2@linux.ibm.com>
Date:   Wed, 6 Oct 2021 13:58:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6649c066e16bced2786306c401f14113b4699d1f.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TeHjC1Bi7yeVS29BLa_Xh0Aeu58g5zD1
X-Proofpoint-GUID: 8xuowOrMnRy7nGL4WnJHUSJ6zhcQ8Cxu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/21 1:56 PM, Eric Farman wrote:
> On Wed, 2021-10-06 at 18:01 +0200, Cornelia Huck wrote:
>> I currently don't have time to act as vfio-ccw maintainer
>> anymore, but I trust that I leave it in capable hands.
>>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> 
> My immense thanks Conny, and with a bittersweet:
> 
> Acked-by: Eric Farman <farman@linux.ibm.com>
> 

+1, thanks Conny!

Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>

>> ---
>>   MAINTAINERS | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0149e1a3e65e..92db89512678 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16374,7 +16374,6 @@ F:	drivers/s390/crypto/vfio_ap_ops.c
>>   F:	drivers/s390/crypto/vfio_ap_private.h
>>   
>>   S390 VFIO-CCW DRIVER
>> -M:	Cornelia Huck <cohuck@redhat.com>
>>   M:	Eric Farman <farman@linux.ibm.com>
>>   M:	Matthew Rosato <mjrosato@linux.ibm.com>
>>   R:	Halil Pasic <pasic@linux.ibm.com>
> 

