Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D56BD0EF
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjCPNgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 09:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCPNgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 09:36:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4500C89F31;
        Thu, 16 Mar 2023 06:35:57 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GD5al9021234;
        Thu, 16 Mar 2023 13:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cFCy7+czhdeqmxtnGMI0ww6ksJYdj1svGXXnkjCaQpc=;
 b=LV2vMsOsapASlEdcrCo7vdyYSbFOd4VdFg8nMdkcrRGMTtO663EdYqZM9aW9wr6Mv834
 IOqf+MyKwBUX2dxil1Vhxtu37CFsQpTmxsyLb8mEQqf0hnAY4WVi/2IpbFPf9yCazJ2w
 L1zwpXDwW8XyjivNFrY0r9rnNtfznpQV9e25cf8S+/o0JYec4aIVOZ2WZ8K5/evQBtJQ
 8yTOD7lJR1SujYKbFtSHLyjWKhGedHz6EHUOIAlC/+Y9gxh+45fq2Osmb4gSg+Z6XVFn
 KUu3I4HNfjACawak5oIZhx1g+UObaxDdApkMOYJu4iyyxhtDCdKXXgNCiCxvoLn2on/Y gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbsv4evj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 13:35:55 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GDDshG005486;
        Thu, 16 Mar 2023 13:35:53 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbsv4evhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 13:35:53 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32GDUmRD026780;
        Thu, 16 Mar 2023 13:35:52 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3pbs9yuk0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 13:35:52 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32GDZpGr29098308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 13:35:51 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E6275805F;
        Thu, 16 Mar 2023 13:35:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E0D558051;
        Thu, 16 Mar 2023 13:35:50 +0000 (GMT)
Received: from [9.65.241.229] (unknown [9.65.241.229])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Mar 2023 13:35:50 +0000 (GMT)
Message-ID: <1e3fc059-09ac-100e-6a37-9b7f459cfb99@linux.ibm.com>
Date:   Thu, 16 Mar 2023 09:35:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] s390/vfio_ap: fix memory leak in vfio_ap device driver
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com
References: <20230315153932.165031-1-akrowiak@linux.ibm.com>
 <ZBLV1P2AkWdHht2r@osiris>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ZBLV1P2AkWdHht2r@osiris>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XMnyB3a_lDxDNxAzU4yybmwA9NLkYLS7
X-Proofpoint-ORIG-GUID: beCzohS0q9kd_Xl6fa_EvuRRAOMThVd8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_09,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/16/23 4:39 AM, Heiko Carstens wrote:
> On Wed, Mar 15, 2023 at 11:39:32AM -0400, Tony Krowiak wrote:
>> The device release callback function invoked to release the matrix device
>> uses the dev_get_drvdata(device *dev) function to retrieve the
>> pointer to the vfio_matrix_dev object in order to free its storage. The
>> problem is, this object is not stored as drvdata with the device; since the
>> kfree function will accept a NULL pointer, the memory for the
>> vfio_matrix_dev object is never freed.
>>
>> Since the device being released is contained within the vfio_matrix_dev
>> object, the container_of macro will be used to retrieve its pointer.
>>
>> Fixes: 1fde573413b5 ("s390: vfio-ap: base implementation of VFIO AP device driver")
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_drv.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>> index 997b524bdd2b..15e9de9f4574 100644
>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>> @@ -54,8 +54,9 @@ static struct ap_driver vfio_ap_drv = {
>>   
>>   static void vfio_ap_matrix_dev_release(struct device *dev)
>>   {
>> -	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
>> -
>> +	struct ap_matrix_dev *matrix_dev = container_of(dev,
>> +							struct ap_matrix_dev,
>> +							device);
>>   	kfree(matrix_dev);
> Could you keep this code more readable, including adding the missing
> blank line after the declaration, please? Something like:
>
> static void vfio_ap_matrix_dev_release(struct device *dev)
> {
> 	struct ap_matrix_dev *matrix_dev;
>
> 	matrix_dev = container_of(dev, struct ap_matrix_dev, device);
> 	kfree(matrix_dev);
> }
>
> Thanks!


Will do.


