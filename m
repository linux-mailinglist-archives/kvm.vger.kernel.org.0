Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B5964326D
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbiLET0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiLET0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:26:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46081090;
        Mon,  5 Dec 2022 11:22:23 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5IS0X1024590;
        Mon, 5 Dec 2022 19:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=UZ5nvpN1M9p6Et3XhUD+K4KDFkUCzVljhOxDMIr8/lc=;
 b=MkFmVhBtpVwnwFq4MTcql150cK/98VWB0lVE7DKK2oRxzHyVB3UL40O8GyjFJwgeUR1a
 eOp8lDcez+l+XS8RlS/vdufYY5f+b50ufl0UcpAkVCPSy+tNtUXUkKhWwjPfnLAXuBi9
 /k65ZVz9LGf24zQCqGKuR6NFVBSPD6FDS0ToRopWOPedOUVnjVSaT4az/oKSSWTC0ooY
 efWw9rO/rvgcUJOT0udsVXJNiMgDP+kWiQ7iXKZsUmX0WyX7VGzaXj97H/7tWwwQrboc
 gXgidAhaYe8sEgDkbnx975RoCa/TDE2kWOORFm952vXvsh2nkNel5Hp6ZDK7TKLz8aZO fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g7cx5ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 19:22:14 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B5IL8Qo014520;
        Mon, 5 Dec 2022 19:22:13 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g7cx5sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 19:22:13 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B5IwtdH014635;
        Mon, 5 Dec 2022 19:22:11 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3m9pd9g7wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 19:22:11 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B5JKt0I656026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Dec 2022 19:20:55 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 667BF58058;
        Mon,  5 Dec 2022 19:20:55 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B23958052;
        Mon,  5 Dec 2022 19:20:54 +0000 (GMT)
Received: from [9.77.142.238] (unknown [9.77.142.238])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Dec 2022 19:20:54 +0000 (GMT)
Message-ID: <9fe1e000-e3ff-bf42-28f7-169fb57dc1ce@linux.ibm.com>
Date:   Mon, 5 Dec 2022 14:20:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] vfio/ap/ccw/samples: Fix device_register() unwind path
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <166999942139.645727.12439756512449846442.stgit@omen>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <166999942139.645727.12439756512449846442.stgit@omen>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bYj3kUn4fi2KlH4QcqQZ6G05zgdBoAOG
X-Proofpoint-ORIG-GUID: tMmok1Vbva9jRFShzrzI5QPc1gqm7BPq
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999
 clxscore=1011 impostorscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212050158
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 12/2/22 11:46 AM, Alex Williamson wrote:
> We always need to call put_device() if device_register() fails.
> All vfio drivers calling device_register() include a similar unwind
> stack via gotos, therefore split device_unregister() into its
> device_del() and put_device() components in the unwind path, and
> add a goto target to handle only the put_device() requirement.
>
> Reported-by: Ruan Jinjie <ruanjinjie@huawei.com>
> Link: https://lore.kernel.org/all/20221118032827.3725190-1-ruanjinjie@huawei.com
> Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
> Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
> Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
> Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
> Fixes: 36360658eb5a ("s390: vfio_ap: link the vfio_ap devices to the vfio_ap bus subsystem")
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> I didn't intend to usurp Ruan's patch, but since the inline version is
> collecting reviews, formally post it and include additional fixes tags
> for vfio-ccw and vfio-ap.
>
>   drivers/s390/cio/vfio_ccw_drv.c   |    3 ++-
>   drivers/s390/crypto/vfio_ap_drv.c |    2 +-
>   samples/vfio-mdev/mbochs.c        |    7 ++++---
>   samples/vfio-mdev/mdpy.c          |    7 ++++---
>   samples/vfio-mdev/mtty.c          |    7 ++++---
>   5 files changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index c2a65808605a..54aba7cceb33 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -199,8 +199,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
>   	return 0;
>   
>   out_unreg:
> -	device_unregister(&parent->dev);
> +	device_del(&parent->dev);
>   out_free:
> +	put_device(&parent->dev);
>   	dev_set_drvdata(&sch->dev, NULL);
>   	return ret;
>   }
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index f43cfeabd2cc..997b524bdd2b 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -122,7 +122,7 @@ static int vfio_ap_matrix_dev_create(void)
>   	return 0;
>   
>   matrix_drv_err:
> -	device_unregister(&matrix_dev->device);
> +	device_del(&matrix_dev->device);
>   matrix_reg_err:
>   	put_device(&matrix_dev->device);
>   matrix_alloc_err:
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 8b5a3a778a25..e54eb752e1ba 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1430,7 +1430,7 @@ static int __init mbochs_dev_init(void)
>   
>   	ret = device_register(&mbochs_dev);
>   	if (ret)
> -		goto err_class;
> +		goto err_put;
>   
>   	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
>   				   mbochs_mdev_types,
> @@ -1441,8 +1441,9 @@ static int __init mbochs_dev_init(void)
>   	return 0;
>   
>   err_device:
> -	device_unregister(&mbochs_dev);
> -err_class:
> +	device_del(&mbochs_dev);
> +err_put:
> +	put_device(&mbochs_dev);
>   	class_destroy(mbochs_class);
>   err_driver:
>   	mdev_unregister_driver(&mbochs_driver);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 721fb06c6413..e8400fdab71d 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -717,7 +717,7 @@ static int __init mdpy_dev_init(void)
>   
>   	ret = device_register(&mdpy_dev);
>   	if (ret)
> -		goto err_class;
> +		goto err_put;
>   
>   	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
>   				   mdpy_mdev_types,
> @@ -728,8 +728,9 @@ static int __init mdpy_dev_init(void)
>   	return 0;
>   
>   err_device:
> -	device_unregister(&mdpy_dev);
> -err_class:
> +	device_del(&mdpy_dev);
> +err_put:
> +	put_device(&mdpy_dev);
>   	class_destroy(mdpy_class);
>   err_driver:
>   	mdev_unregister_driver(&mdpy_driver);
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 3c2a421b9b69..e887de672c52 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1330,7 +1330,7 @@ static int __init mtty_dev_init(void)
>   
>   	ret = device_register(&mtty_dev.dev);
>   	if (ret)
> -		goto err_class;
> +		goto err_put;
>   
>   	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
>   				   &mtty_driver, mtty_mdev_types,
> @@ -1340,8 +1340,9 @@ static int __init mtty_dev_init(void)
>   	return 0;
>   
>   err_device:
> -	device_unregister(&mtty_dev.dev);
> -err_class:
> +	device_del(&mtty_dev.dev);
> +err_put:
> +	put_device(&mtty_dev.dev);
>   	class_destroy(mtty_dev.vd_class);
>   err_driver:
>   	mdev_unregister_driver(&mtty_driver);
>
>
