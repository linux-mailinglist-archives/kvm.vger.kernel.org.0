Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB449397247
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 13:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhFAL1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 07:27:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62258 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhFAL1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 07:27:42 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151B2teK116967;
        Tue, 1 Jun 2021 07:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g3SnxyIN5/jUzx1WFoWZHmL+DiWvwkp/44ekH6M3gZc=;
 b=T9pAgf3NCa1H8nANmbXs5SCl7v0fCIy6b5AJlhgeHEMt/I7YgoyaTYxkuswMJ4tXe0PL
 XkTLc20kqvZ7zlhGeqNABAGqi1BXdb40A9ezcV2wxXA97uW2bWRvI8NxulmVwEMmTxcN
 6JHTrZdDri1CdFeR/NZs9eihghkJ+PfvEj6mva0SkklLnxzRfSVBgwFSZr9ktvxeC4kg
 kSxKI/35xg6nPRzVPNAjYEzJkIDGsLwhzcZIfoOeNLoLfsm1sW6+Nq/2NcncSRR1NOJz
 nQpEsPKiTaESapN2tnRL3V4dnsYIqWpEg3JCDaYeSv0mBIryTj2+5xEfC2F0JPn0gtW0 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38whnn40t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 07:25:58 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 151B2waM117341;
        Tue, 1 Jun 2021 07:25:58 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38whnn40t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 07:25:58 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 151BH5sd032294;
        Tue, 1 Jun 2021 11:25:57 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 38ud89c3vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 11:25:57 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 151BPuG637683558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Jun 2021 11:25:56 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFCDF124054;
        Tue,  1 Jun 2021 11:25:55 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88D5E124055;
        Tue,  1 Jun 2021 11:25:55 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com (unknown [9.85.178.155])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  1 Jun 2021 11:25:55 +0000 (GMT)
Subject: Re: [PATCH v16 06/14] s390/vfio-ap: refresh guest's APCB by filtering
 APQNs assigned to mdev
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <20210510164423.346858-7-akrowiak@linux.ibm.com>
 <20210524181548.4dbe52bc.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <25ddf7f5-3d70-7e9d-14b1-76f753e64d00@linux.ibm.com>
Date:   Tue, 1 Jun 2021 07:25:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524181548.4dbe52bc.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OkgP8otBoMFt2Lvf0N75nG-NCjXsSUyg
X-Proofpoint-GUID: v1Xa7Uq9UVn1hDyeFfUGrfA8bZeOjRZK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_06:2021-05-31,2021-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/21 12:15 PM, Halil Pasic wrote:
> On Mon, 10 May 2021 12:44:15 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> @@ -1601,8 +1676,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>>   	mutex_lock(&matrix_dev->lock);
>>   	q = dev_get_drvdata(&apdev->device);
>>   
>> -	if (q->matrix_mdev)
>> +	if (q->matrix_mdev) {
>>   		vfio_ap_mdev_unlink_queue_fr_mdev(q);
>> +		vfio_ap_mdev_refresh_apcb(q->matrix_mdev);
>> +	}
>>   
>>   	vfio_ap_mdev_reset_queue(q, 1);
>>   	dev_set_drvdata(&apdev->device, NULL);
> At this point we don't know if !!kvm_busy or kvm_busy AFAICT. If
> !!kvm_busy, then we may end up changing a shadow_apcb while an other
> thread is in the middle of committing it to the SD satellite. That
> would be no good.

No, that would not be a good thing, we should check for
that.

>
> Regards,
> Halil

