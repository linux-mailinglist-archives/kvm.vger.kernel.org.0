Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16F2702D6
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 19:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIRREF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 13:04:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726273AbgIRREE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 13:04:04 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IH0lp8171942;
        Fri, 18 Sep 2020 13:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aYfAfNsZADDse3HgNhHndOnu4LfuAkhcLvK463qpQgg=;
 b=UvqlHwHdTUhAO2SJP6YobnmQFiORdouvjHj+TAHYotYNofN8/JW8StFG2FyuROAKwp1N
 JEB/sWkprInwcyjA2CR5aEwPQfzcXRK89SKm6e6t7fL0bZray7ShShkrV0UspwAL0Rza
 8K1sGjb+o4OGedbTNUn1Ws/x6CNLVzpJS401fpcdVi6Z0Cl0bzXC4Jrzh2/+7TXwGbDx
 PPBgW6PcBB7Re0q2YYEMiA1dGvxfGH95qoAuOz6qBk1FvuHUT3VpJdEfroCl+BBA9WA8
 K+GPe+FU2V4DyNPqIhET2hLNHhmPd9bk/mCPHGHVlIrlIOW8Z3u8UKDFtMJ83lH65atG RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33myrn25h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:04:02 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08IH0lvg171936;
        Fri, 18 Sep 2020 13:04:02 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33myrn25gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 13:04:01 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IGvnXt005489;
        Fri, 18 Sep 2020 17:04:01 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 33k6q1dg8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 17:04:01 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IH3wUx45875474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 17:03:58 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B0B6A047;
        Fri, 18 Sep 2020 17:03:58 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6BBA6A057;
        Fri, 18 Sep 2020 17:03:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.128.188])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 17:03:56 +0000 (GMT)
Subject: Re: [PATCH v10 06/16] s390/vfio-ap: introduce shadow APCB
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-7-akrowiak@linux.ibm.com>
 <20200917162242.1941772a.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <49b0dd56-0c5b-9096-91d1-aacb5ec886d1@linux.ibm.com>
Date:   Fri, 18 Sep 2020 13:03:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200917162242.1941772a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_15:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/17/20 10:22 AM, Cornelia Huck wrote:
> On Fri, 21 Aug 2020 15:56:06 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The APCB is a field within the CRYCB that provides the AP configuration
>> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
>> maintain it for the lifespan of the guest.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 32 ++++++++++++++++++++++-----
>>   drivers/s390/crypto/vfio_ap_private.h |  2 ++
>>   2 files changed, 29 insertions(+), 5 deletions(-)
> (...)
>
>> @@ -1202,13 +1223,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>   	if (ret)
>>   		return NOTIFY_DONE;
>>   
>> -	/* If there is no CRYCB pointer, then we can't copy the masks */
>> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>>   		return NOTIFY_DONE;
>>   
>> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
>> -				  matrix_mdev->matrix.aqm,
>> -				  matrix_mdev->matrix.adm);
>> +	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
>> +	       sizeof(matrix_mdev->shadow_apcb));
>> +	vfio_ap_mdev_commit_crycb(matrix_mdev);
> We are sure that the shadow APCB always matches up as we are the only
> ones manipulating the APCB in the CRYCB, right?

Yes

>
>>   
>>   	return NOTIFY_OK;
>>   }

