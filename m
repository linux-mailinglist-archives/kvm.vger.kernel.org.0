Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479744E3F94
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiCVNck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiCVNch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:32:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B239A2DD5E;
        Tue, 22 Mar 2022 06:31:07 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MBXLeE018278;
        Tue, 22 Mar 2022 13:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HpA+lBmDwGJzna4wzGRAGzKQulBYXqZmgl9iArsAFEc=;
 b=lJaWQAiiK3lzj51BoGP6QnFpOiHEL+f+njm+UWQ0UeDofLAuT3pxX+DojE0DSxjiZL6U
 /OegKzfgbuleIKFFI1Ts7DmO8na2O2r4mxx1ftuTwpE1D9OtrSZHVNnae1Q7T5TCe3SJ
 X8BXxZ7dWgDGTXy/ZfUjRQvl2tNbhhkV0V63BgGZtTqrUuqBDClIFtcJeTPl0wUms4lR
 KWw6F8M9khdFJLrIHtrBgSGW+ISnyOQaWUYgRZfpHJUmUhXql0GgZJQKzZqpvA3J9D9a
 DWFHG7tq10JsR5Irb3JEgmW+DD8f3AIBuRm1TEJtdZcpg/1Im0VK5qJuRUy/aDjIPV4L tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautpnf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:31:03 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MDFVj5027042;
        Tue, 22 Mar 2022 13:31:03 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyautpnew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:31:03 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MDHXcl007307;
        Tue, 22 Mar 2022 13:31:02 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3ew6t9hbh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:31:02 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MDV0MJ20709874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 13:31:00 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27FDB6E062;
        Tue, 22 Mar 2022 13:31:00 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3B3F6E060;
        Tue, 22 Mar 2022 13:30:58 +0000 (GMT)
Received: from [9.65.234.56] (unknown [9.65.234.56])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 13:30:58 +0000 (GMT)
Message-ID: <0f9ab763-9596-c157-8f1e-e65088bf3aab@linux.ibm.com>
Date:   Tue, 22 Mar 2022 09:30:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 13/18] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-14-akrowiak@linux.ibm.com>
 <37e98e6e-35a7-a77a-b057-e19b307c631a@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <37e98e6e-35a7-a77a-b057-e19b307c631a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ld6WgwifEOk6QCcEriFpJGHb8n3IZHSk
X-Proofpoint-ORIG-GUID: KDkUGfMlekwWBt1i2Hg0TIl3E6zSU8Lp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/22/22 09:13, Jason J. Herne wrote:
> On 2/14/22 19:50, Tony Krowiak wrote:
> ...
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index e9f7ec6fc6a5..63dfb9b89581 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -617,10 +617,32 @@ static int 
>> vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>>       return 0;
>>   }
>>   +/**
>> + * vfio_ap_mdev_validate_masks - verify that the APQNs assigned to 
>> the mdev are
>> + *                 not reserved for the default zcrypt driver and
>> + *                 are not assigned to another mdev.
>> + *
>> + * @matrix_mdev: the mdev to which the APQNs being validated are 
>> assigned.
>> + *
>> + * Return: One of the following values:
>> + * o the error returned from the 
>> ap_apqn_in_matrix_owned_by_def_drv() function,
>> + *   most likely -EBUSY indicating the ap_perms_mutex lock is 
>> already held.
>> + * o EADDRNOTAVAIL if an APQN assigned to @matrix_mdev is reserved 
>> for the
>> + *           zcrypt default driver.
>> + * o EADDRINUSE if an APQN assigned to @matrix_mdev is assigned to 
>> another mdev
>> + * o A zero indicating validation succeeded.
>> + */
>>   static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev 
>> *matrix_mdev)
>>   {
>> -    if (ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
>> -                           matrix_mdev->matrix.aqm))
>> +    int ret;
>> +
>> +    ret = ap_apqn_in_matrix_owned_by_def_drv(matrix_mdev->matrix.apm,
>> +                         matrix_mdev->matrix.aqm);
>> +
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    if (ret == 1)
>>           return -EADDRNOTAVAIL;
>
> I took a look at ap_apqn_in_matrix_owned_by_def_drv(). It appears that 
> this function
> can only ever return 0 or 1. This patch is changed to watch for a 
> negative return
> value from ap_apqn_in_matrix_owned_by_def_drv(). Am I missing something?

That's odd, careless error, I'll fix it.

>
>

