Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE51168C01E
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 15:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBFObQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 09:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjBFObL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 09:31:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB3624491;
        Mon,  6 Feb 2023 06:31:03 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316Dqedn027262;
        Mon, 6 Feb 2023 14:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fY1uFqFpFeohv8ToeVZeQn7Oria/689OcqL8tnKdK1A=;
 b=B3b9Rf0n6oWvgqu1iZn2sR4r97MleYzgLftVFCvpSEpzFB1a2B1QYEVCDy3GqRCb4pix
 w2T/QN+HHRPcQmiiC8kgaJhzEvwSiqJ+x8bJk9NAVADgW70eJO/w4R5H+mUvIw2xxERF
 3qiXSrDfsWIwd5HcCiRqkne+kojt11ZZhsqS261Gx+fEsoYUNhY5JDOuhlzqbSQktvUp
 btgUS+ZjhJJMgbE74auL2FmAkrItKkVD5U8oNIjcfWfR6/679cK07zWFJOOCYwF6bakw
 4f7v6P1V3FDHBodpZSqkiNM2T1CaHgRkh5lZ3/goLlhZpMgbMj0mhok9N+do1Z2wqdQA Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk2tbhdg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:30:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316ENZEC010631;
        Mon, 6 Feb 2023 14:30:59 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk2tbhdfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:30:59 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316C2CtB027478;
        Mon, 6 Feb 2023 14:30:57 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3nhf07k4n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 14:30:57 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316EUuEO4784646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 14:30:56 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5388958059;
        Mon,  6 Feb 2023 14:30:56 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 348BB5805B;
        Mon,  6 Feb 2023 14:30:53 +0000 (GMT)
Received: from [9.65.214.209] (unknown [9.65.214.209])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 14:30:53 +0000 (GMT)
Message-ID: <1bd635d4-3868-6c6e-48a7-9888a1f4770f@linux.ibm.com>
Date:   Mon, 6 Feb 2023 09:30:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 2/2] vfio: no need to pass kvm pointer during device
 open
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        yi.l.liu@intel.com, jgg@nvidia.com
Cc:     cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        seanjc@google.com, kevin.tian@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230203215027.151988-1-mjrosato@linux.ibm.com>
 <20230203215027.151988-3-mjrosato@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230203215027.151988-3-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cceqdypcy3GETAIAz_M-K1133zr11Dl-
X-Proofpoint-GUID: 7oQNyG3Yl5Xiw6XZRpT67G57WPdtqU7d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060121
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 2/3/23 4:50 PM, Matthew Rosato wrote:
> Nothing uses this value during vfio_device_open anymore so it's safe
> to remove it.
>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/vfio/group.c     | 2 +-
>   drivers/vfio/vfio.h      | 3 +--
>   drivers/vfio/vfio_main.c | 7 +++----
>   3 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 98621ac082f0..0e9036e2b9c4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -187,7 +187,7 @@ static int vfio_device_group_open(struct vfio_device *device)
>   	if (device->open_count == 0)
>   		vfio_device_group_get_kvm_safe(device);
>   
> -	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
> +	ret = vfio_device_open(device, device->group->iommufd);
>   
>   	if (device->open_count == 0)
>   		vfio_device_put_kvm(device);
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 24d6cd285945..4f39ab549a80 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,8 +18,7 @@ struct vfio_container;
>   
>   void vfio_device_put_registration(struct vfio_device *device);
>   bool vfio_device_try_get_registration(struct vfio_device *device);
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm);
> +int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd);
>   void vfio_device_close(struct vfio_device *device,
>   		       struct iommufd_ctx *iommufd);
>   
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 28c47cd6a6b5..3a597e799918 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -397,7 +397,7 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>   }
>   
>   static int vfio_device_first_open(struct vfio_device *device,
> -				  struct iommufd_ctx *iommufd, struct kvm *kvm)
> +				  struct iommufd_ctx *iommufd)
>   {
>   	int ret;
>   
> @@ -444,8 +444,7 @@ static void vfio_device_last_close(struct vfio_device *device,
>   	module_put(device->dev->driver->owner);
>   }
>   
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm)
> +int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
>   {
>   	int ret = 0;
>   
> @@ -453,7 +452,7 @@ int vfio_device_open(struct vfio_device *device,
>   
>   	device->open_count++;
>   	if (device->open_count == 1) {
> -		ret = vfio_device_first_open(device, iommufd, kvm);
> +		ret = vfio_device_first_open(device, iommufd);
>   		if (ret)
>   			device->open_count--;
>   	}
