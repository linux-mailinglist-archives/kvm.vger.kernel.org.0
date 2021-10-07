Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38A1424ECE
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240568AbhJGINg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:13:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10596 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240683AbhJGINb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:13:31 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19786sTk023512;
        Thu, 7 Oct 2021 04:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wUB73T+zYzrnkbl5Lx/k7P7qiOPwXNst9sf3CL79GHQ=;
 b=mNxqPLQv4g5sv7sWRGTqZNZnfOs7U67YQzPXrXP4SiLCu8h4/bvw5QOtC47ZeWx+qsCl
 iLOh3jSiPGAeWJ2yMDHBGckaFe180YoAJdehhXvuMW6C+nmYnq+4JV8JRht+y4uqJsku
 DetoTJMTDUGuW8Ktcj7TKfD7jnnES76BB4x9rJnzUH8/CK+YzmjC/6KjIGy1NIC/Spdd
 KrFGCfPMVrtKm+Vx6BJmnvn0SL/icC+0sQfuZCuVpITJTj593EwKnwNoCgVIVvZlwEJU
 nsoHf/BPdsOuq7AGs8zT8Kg7OAcXIkOHvD/PMdmVENNI1TXgcU37afN1gfnWORQDgjsL +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhksy2yma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:11:36 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 197876er027927;
        Thu, 7 Oct 2021 04:11:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhksy2ykv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:11:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19787MOu003623;
        Thu, 7 Oct 2021 08:11:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2anh2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:11:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978658s40698334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:06:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FFE811C050;
        Thu,  7 Oct 2021 08:11:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C547111C04A;
        Thu,  7 Oct 2021 08:11:25 +0000 (GMT)
Received: from [9.145.66.140] (unknown [9.145.66.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:11:25 +0000 (GMT)
Message-ID: <32b11bd4-66b6-1020-c1c6-717862a348d0@linux.ibm.com>
Date:   Thu, 7 Oct 2021 10:11:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/2] KVM: s390: remove myself as reviewer
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20211006160120.217636-1-cohuck@redhat.com>
 <20211006160120.217636-2-cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211006160120.217636-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qqJV-Jay_p8hKJwmvIfHz0YeKoXs0Ldo
X-Proofpoint-ORIG-GUID: IE8OHe9wFhNUpMRVe_kG40S3lEEJlwNY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110070054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/21 18:01, Cornelia Huck wrote:
> I currently don't have time anymore to review KVM/s390
> code.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

And for a second time:
Thank you for your work!

> ---
>   MAINTAINERS | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index abdcbcfef73d..0149e1a3e65e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10275,7 +10275,6 @@ KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>   M:	Christian Borntraeger <borntraeger@de.ibm.com>
>   M:	Janosch Frank <frankja@linux.ibm.com>
>   R:	David Hildenbrand <david@redhat.com>
> -R:	Cornelia Huck <cohuck@redhat.com>
>   R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>   L:	kvm@vger.kernel.org
>   S:	Supported
> 

