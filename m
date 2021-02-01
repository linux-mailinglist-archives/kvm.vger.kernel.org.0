Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8995330ADCF
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhBAR2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:28:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230127AbhBAR2H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 12:28:07 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111HNpnK131149;
        Mon, 1 Feb 2021 12:27:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F3NMKpux4561ymqoip4Qw2/x23g4rYcK1L2WR60eGEE=;
 b=V+9DfrrJ67QgP6f3vtEkstqLJFZDViZEwpldvFLo2D9Yeqb6GhZGWrmUcb1FhUPKZxNg
 qPx6PRxAXIN0BDCd+UmS61EWPUnxV8BMiZ4rFhcA3vkhhKJj54/dyIeyj1CivCj9UCAz
 9UlL+g6CU8EsAm7ZzNRWxir4luGErboWUx6BLnFb9R4FDZrFnkydoI3+YvRszegohXI9
 iiBI22fvhAnaaFBeYy8Jxwg1byYRHvseBV9CKiHRj1zko3CTAGHcMifUcedTI9FXkZkW
 PTliMfx4DqIFKDQYKIr8YSWsVmL1A7a6nDd2n3V+wd1KW/r1AXGS89pjN6RZrsgDC2pK mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36ep0h8267-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:27:25 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111HNoQv131125;
        Mon, 1 Feb 2021 12:27:24 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36ep0h825u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:27:24 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111HE0LG031611;
        Mon, 1 Feb 2021 17:27:23 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 36cy38g799-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 17:27:23 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111HRLqL43516406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 17:27:22 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0217112061;
        Mon,  1 Feb 2021 17:27:21 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1428112064;
        Mon,  1 Feb 2021 17:27:17 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.84.157])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 17:27:17 +0000 (GMT)
Subject: Re: [PATCH 5/9] vfio-pci/zdev: remove unused vdev argument
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Cc:     liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, aik@ozlabs.ru
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-6-mgurtovoy@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <ffb61cac-f3ab-a96c-30c6-09ef08907f4b@linux.ibm.com>
Date:   Mon, 1 Feb 2021 12:27:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201162828.5938-6-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_06:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/21 11:28 AM, Max Gurtovoy wrote:
> Zdev static functions does not use vdev argument. Remove it.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

Huh.  I must have dropped the use of vdev somewhere during review 
versions.  Thanks!

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

@Alex/@Connie This one is just a cleanup and could also go separately 
from this set if it makes sense.

> ---
>   drivers/vfio/pci/vfio_pci_zdev.c | 20 ++++++++------------
>   1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 7b20b34b1034..175096fcd902 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -24,8 +24,7 @@
>   /*
>    * Add the Base PCI Function information to the device info region.
>    */
> -static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
> -			 struct vfio_info_cap *caps)
> +static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_base cap = {
>   		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_BASE,
> @@ -45,8 +44,7 @@ static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
>   /*
>    * Add the Base PCI Function Group information to the device info region.
>    */
> -static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
> -			  struct vfio_info_cap *caps)
> +static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_group cap = {
>   		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_GROUP,
> @@ -66,8 +64,7 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
>   /*
>    * Add the device utility string to the device info region.
>    */
> -static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
> -			 struct vfio_info_cap *caps)
> +static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_util *cap;
>   	int cap_size = sizeof(*cap) + CLP_UTIL_STR_LEN;
> @@ -90,8 +87,7 @@ static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
>   /*
>    * Add the function path string to the device info region.
>    */
> -static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
> -			 struct vfio_info_cap *caps)
> +static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_pfip *cap;
>   	int cap_size = sizeof(*cap) + CLP_PFIP_NR_SEGMENTS;
> @@ -123,21 +119,21 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
>   	if (!zdev)
>   		return -ENODEV;
>   
> -	ret = zpci_base_cap(zdev, vdev, caps);
> +	ret = zpci_base_cap(zdev, caps);
>   	if (ret)
>   		return ret;
>   
> -	ret = zpci_group_cap(zdev, vdev, caps);
> +	ret = zpci_group_cap(zdev, caps);
>   	if (ret)
>   		return ret;
>   
>   	if (zdev->util_str_avail) {
> -		ret = zpci_util_cap(zdev, vdev, caps);
> +		ret = zpci_util_cap(zdev, caps);
>   		if (ret)
>   			return ret;
>   	}
>   
> -	ret = zpci_pfip_cap(zdev, vdev, caps);
> +	ret = zpci_pfip_cap(zdev, caps);
>   
>   	return ret;
>   }
> 

