Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA4B5525AA
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 22:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344766AbiFTUQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 16:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344803AbiFTUPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 16:15:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3352B6
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 13:13:18 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KIg64V039535;
        Mon, 20 Jun 2022 20:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BD4huyKYPxPOJ6LD5asBnx++ZpW2c5qqQ8ODxGtRzQI=;
 b=YZ+dnZVqBHQI1Hv1rOx9O10LqOsXoSxFdud5NF69mzAxtWAdrXfBatRRJupGTnbHWbWz
 RabN245jWdwCN92B/Hyz0blEb6AcZ4W+kj0CFI/wKegXzzqxqPfJb13xYJrZKz0PZQnS
 I5iCzRru39NDVAqyEdhZZZfzjf0fONmlkc3vXZByMW7NoTOx+eQKqdVjS89Xn8J4OAJ/
 NZ1sqaiWfO4YvRCMfDBqh1qL3zNG5qildJxEn/6Yx2w7Mu6qHPLINix38k9Bl/nJw7rM
 HZ8+b2dOEVwqgd0DgWKN/474goqwSlqjLGidMhesW6mrP+BNklhMGRX6PcMx1NBe1WCH Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gtxdasx9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 20:13:15 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KJtF3X035126;
        Mon, 20 Jun 2022 20:13:14 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gtxdasx97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 20:13:14 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KK5tQo007211;
        Mon, 20 Jun 2022 20:13:14 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3gt008u75p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 20:13:13 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KKDCoD31523226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 20:13:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE0607805E;
        Mon, 20 Jun 2022 20:13:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F3877805C;
        Mon, 20 Jun 2022 20:13:12 +0000 (GMT)
Received: from [9.211.143.38] (unknown [9.211.143.38])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 20:13:12 +0000 (GMT)
Message-ID: <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
Date:   Mon, 20 Jun 2022 16:13:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, kvm@vger.kernel.org, jgg@nvidia.com
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220620085459.200015-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9XSekRfqZ9v7MjzViS_Y8oGuYhfZjXBE
X-Proofpoint-GUID: 7jYCYRpFJQVNYnAwQ8XarsWNLkCiHWVR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 4:54 AM, Yi Liu wrote:
> No need to protect open_count with group_rwsem
> 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> 
> cc: Matthew Rosato <mjrosato@linux.ibm.com>
> cc: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Seems pretty harmless as-is, but you are correct group_rwsem can be 
dropped earlier; we do not protect the count with group_rwsem elsewhere 
(see vfio_device_fops_release as a comparison, where we already drop 
group_rwsem before open_count--)

FWIW, this change now also drops group_rswem before setting device->kvm 
= NULL, but that's also OK (again, just like vfio_device_fops_release) 
-- While the setting of device->kvm before open_device is technically 
done while holding the group_rwsem, this is done to protect the group 
kvm value we are copying from, and we should not be relying on that to 
protect the contents of device->kvm; instead we assume this value will 
not change until after the device is closed and while under the 
dev_set->lock.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/vfio/vfio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..44c3bf8023ac 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1146,10 +1146,10 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   	if (device->open_count == 1 && device->ops->close_device)
>   		device->ops->close_device(device);
>   err_undo_count:
> +	up_read(&device->group->group_rwsem);
>   	device->open_count--;
>   	if (device->open_count == 0 && device->kvm)
>   		device->kvm = NULL;
> -	up_read(&device->group->group_rwsem);
>   	mutex_unlock(&device->dev_set->lock);
>   	module_put(device->dev->driver->owner);
>   err_unassign_container:

