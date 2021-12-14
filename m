Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA48A473FF9
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhLNJ50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:57:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32458 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232764AbhLNJ5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:57:25 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7HltK008516;
        Tue, 14 Dec 2021 09:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ptMG/+iF++qtfZVKvPKhaGnQF8mAAl7kysQqptqO2xQ=;
 b=Bidueq5cnDlJpXjFbzyd7le5qdJwv9jffoFkj/D9w+s8vgw9Z5cfY/xD/jdlfAuddFuV
 NpQVpwTTy6HwxEn98UnschEo2WxM9U2dvyHcqf5CrT+KD1PYsMMXbsr/2zY6moYkkT57
 7UyJ9E0EIuC1dMrskCAriU8DzeZHfWiqh0I2YrZyk376npt5YOI+DugX/CB8PsltAXpP
 hH2Zfr7fGQpyqGgyQ4xKY9BwCqX4OYezZAZVcWVyaFSIHlEJncivvipgcZL7EDWGt0bZ
 ksJIbkZgWbI7KscEIFv95ja4jaRcPttA+qhfnBrx5h0dN8IzxYAjemdjAtyZqJbxuKz/ bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9ra6vpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:57:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE9MuEC015750;
        Tue, 14 Dec 2021 09:57:23 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9ra6vp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:57:23 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE9mJUq025803;
        Tue, 14 Dec 2021 09:57:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3cvkm8uu9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:57:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE9vITU20840916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:57:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AB1AA406E;
        Tue, 14 Dec 2021 09:57:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50F86A4057;
        Tue, 14 Dec 2021 09:57:17 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:57:17 +0000 (GMT)
Message-ID: <b54b2ee9-3d7f-11b7-9aa4-e5dafd01a086@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:58:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 30/32] vfio-pci/zdev: add DTSM to clp group capability
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-31-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-31-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GwKbw-vrVJ1OLfM1MttgAloBiH33BXRB
X-Proofpoint-ORIG-GUID: ho9C9przF5WF5l2wvdQEciSwTwTmp8qE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_05,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> The DTSM, or designation type supported mask, indicates what IOAT formats
> are available to the guest.  For an interpreted device, userspace will not
> know what format(s) the IOAT assist supports, so pass it via the
> capability chain.  Since the value belongs to the Query PCI Function Group
> clp, let's extend the existing capability with a new version.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/vfio/pci/vfio_pci_zdev.c | 9 ++++++---
>   include/uapi/linux/vfio_zdev.h   | 3 +++
>   2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 85be77492a6d..342b59ed36c9 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -45,19 +45,22 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   {
>   	struct vfio_device_info_cap_zpci_group cap = {
>   		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_GROUP,
> -		.header.version = 1,
> +		.header.version = 2,
>   		.dasm = zdev->dma_mask,
>   		.msi_addr = zdev->msi_addr,
>   		.flags = VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH,
>   		.mui = zdev->fmb_update,
>   		.noi = zdev->max_msi,
>   		.maxstbl = ZPCI_MAX_WRITE_SIZE,

This, maxstbl, is not part of the patch but shouldn't we consider it too?
The maxstbl is fixed for intercepted VFIO because the kernel is handling 
the STBL instruction in behalf of the guest.
Here the guest will use STBL directly.

I think we should report the right maxstbl value.

> -		.version = zdev->version
> +		.version = zdev->version,
> +		.dtsm = 0
>   	};
>   
>   	/* Some values are different for interpreted devices */
> -	if (zdev->kzdev && zdev->kzdev->interp)
> +	if (zdev->kzdev && zdev->kzdev->interp) {
>   		cap.maxstbl = zdev->maxstbl;
> +		cap.dtsm = kvm_s390_pci_get_dtsm(zdev);
> +	}
>   
>   	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>   }
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index 1a5229b7bb18..b4c2ba8e71f0 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -47,6 +47,9 @@ struct vfio_device_info_cap_zpci_group {
>   	__u16 noi;		/* Maximum number of MSIs */
>   	__u16 maxstbl;		/* Maximum Store Block Length */
>   	__u8 version;		/* Supported PCI Version */
> +	/* End of version 1 */
> +	__u8 dtsm;		/* Supported IOAT Designations */
> +	/* End of version 2 */
>   };
>   
>   /**
> 

-- 
Pierre Morel
IBM Lab Boeblingen
