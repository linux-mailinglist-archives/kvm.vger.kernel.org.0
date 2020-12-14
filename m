Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E746D2DA436
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 00:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgLNXhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 18:37:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgLNXhy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 18:37:54 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BENW5mi097437;
        Mon, 14 Dec 2020 18:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=83PhmHXQK3GmlVP6IBkwIiEPFyrpXVbAGOgJ0k9Roc0=;
 b=ELsG8Vs/wTDb07n55bHQo6LZCPz5YVYJPHPee8SItaO4i01dYRlTVdWtdS3/puuLaYA/
 2UxOIHxfni3d65nmgTHnlWNpy3PkGquIN5qxA8t+HsaMCEx8QbTpCPxaxpcnZZ89mm8m
 KgdhpgHF5Fuzm7s9B7sT+PvvnLsWQkgW0r/7cyccWZ3NmVBiQWvPGO7iytV71pVO4mP/
 3UmjUdQKNEpbkH0dPbTVJ2ij84tn9OA2nzhuJy4a7wa0Ch1EYVA4Z4PpQzyeMyFnLF8M
 I32AqvUg+yyfB5u7EiT1N/0D/Bt/sH7ndzINhJ169Y7J9J7Dmw4OStt9pDOsJY6gMm2i 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35eg1datpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 18:37:13 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BENX3w0101612;
        Mon, 14 Dec 2020 18:37:13 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35eg1datp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 18:37:13 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BENMEMQ003451;
        Mon, 14 Dec 2020 23:37:12 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 35cng8ufqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 23:37:12 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BENb9oQ35980018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 23:37:10 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFF93AE060;
        Mon, 14 Dec 2020 23:37:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20DE9AE05F;
        Mon, 14 Dec 2020 23:37:09 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 23:37:09 +0000 (GMT)
Subject: Re: [PATCH v12 05/17] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-6-akrowiak@linux.ibm.com>
 <20201126150828.78776e62.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <eac90113-4c68-a42f-cbfa-41e6b2780380@linux.ibm.com>
Date:   Mon, 14 Dec 2020 18:37:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201126150828.78776e62.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_12:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140153
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/26/20 9:08 AM, Halil Pasic wrote:
> On Tue, 24 Nov 2020 16:40:04 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> @@ -1155,6 +1243,11 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   			     matrix_mdev->matrix.apm_max + 1) {
>>   		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>>   				     matrix_mdev->matrix.aqm_max + 1) {
>> +			q = vfio_ap_mdev_get_queue(matrix_mdev,
>> +						   AP_MKQID(apid, apqi));
>> +			if (!q)
>> +				continue;
>> +
>>   			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
>>   			/*
>>   			 * Regardless whether a queue turns out to be busy, or
>> @@ -1164,9 +1257,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>>   			if (ret)
>>   				rc = ret;
>>   
>> -			q = vfio_ap_get_queue(matrix_mdev, AP_MKQID(apid, apqi);
>> -			if (q)
>> -				vfio_ap_free_aqic_resources(q);
>> +			vfio_ap_free_aqic_resources(q);
>>   		}
>>   	}
> During the review of v11 we discussed this. Introducing this the one
> way around, just to change it in the next patch, which should deal
> with something different makes no sense to me.

This is handled by the vfio_ap_mdev_reset_queue() function in the
next version.

>
> BTW I've provided a ton of feedback for '[PATCH v11 03/14]
> s390/vfio-ap: manage link between queue struct and matrix mdev', but I
> can't find your response to that. Some of the things resurface here, and
> I don't feel like repeating myself. Can you provide me an answer to
> the v11 version?

I can.


