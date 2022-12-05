Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE56642991
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 14:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiLENkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 08:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLENkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 08:40:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F1CD2F2;
        Mon,  5 Dec 2022 05:40:10 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5DOfS0031381;
        Mon, 5 Dec 2022 13:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5VWO3RY6Hy7tOEJFafX/5QXIEDhkqxX0hUduwOyPF+o=;
 b=X7+TN4liMjRc4us7bNUbn7HQ5WZDQkPkx1c7Z4Pmb0StSp9sloabV4ygo1GCljDDWvmu
 jOmAmJbVF0c+kCzMDS7pSx5cpQ0CkI5xESOPq+zGID654ASAw0W5nzdKaMlbFdU2T2HG
 qn3MW682mqBIVNFxJUH8hYZ8Kf7z7D+M1HkpJwRG3fnbS3NIW6ddo4Ws26n4F2vvAF58
 GKz0iwYsGjE+hKJ454cJUzc/qhVdkJuvbd5h5rwdjLPoTymlGtomWXWS2axvmy71xlF6
 +phrpeRqiBZLoItDl+RYjDy4P1BsmKH2rQTeOHzJCGKZTcKFEUXqH7kzZly6TvjnZ08g 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8gd1caev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:39:56 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B4NBAGa014087;
        Mon, 5 Dec 2022 13:39:55 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8gd1caek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:39:55 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B5DZbNh020703;
        Mon, 5 Dec 2022 13:39:54 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma05wdc.us.ibm.com with ESMTP id 3m7x39wrjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 13:39:54 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B5DdrOd65798598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Dec 2022 13:39:54 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C7D95805C;
        Mon,  5 Dec 2022 13:39:53 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B97145805D;
        Mon,  5 Dec 2022 13:39:52 +0000 (GMT)
Received: from [9.60.75.234] (unknown [9.60.75.234])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Dec 2022 13:39:52 +0000 (GMT)
Message-ID: <86aa8ae3-060a-6b73-99ce-c8706f1ce723@linux.ibm.com>
Date:   Mon, 5 Dec 2022 08:39:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] vfio/ap/ccw/samples: Fix device_register() unwind path
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <166999942139.645727.12439756512449846442.stgit@omen>
Content-Language: en-US
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
In-Reply-To: <166999942139.645727.12439756512449846442.stgit@omen>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tL39Vy4-TnWHPqBICWuKSdz-_tJVkGQE
X-Proofpoint-ORIG-GUID: FjXj0edfjGKMUY-WbWAXYQ6ve3raRSIk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212050110
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



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
> ...
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

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>


