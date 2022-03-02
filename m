Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29694CAECE
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbiCBTgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241187AbiCBTga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:36:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5F1D7609;
        Wed,  2 Mar 2022 11:35:45 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222Irmp7026821;
        Wed, 2 Mar 2022 19:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=blan+SPzIEDfVdnoSCJ46KsAmD8wUKsCageNaSmz/Tw=;
 b=OEtnOzswNbdcNkVTSP4s88G+F9tmcsFWQIUXW7itZWqqN5CMfbJOJ6nhshrKcVRIrOW9
 iJsfDBwI3LCWXlZ6kSIeM3n0t91GBzbplrcigGNNqoYBxHdVh1lQuF7OsrOi9DbDXgO5
 jf2XtW6MI17Jc04ypFpK5HQ+qxDfbDh0Sz6bRrGlWL4U/I2lDCHeuUUY0q7MbbcfLUWG
 nR4y0t58OSE7rILiocm3O3amrMbmU2bLSE7aEuzh71cLiAwZp+jbVpNb3GS3HAcDegJH
 3ExTDvW6sC+PTBmBQpui7PzLWoXAeQY/eCdiERN7rIcqHSh13p02mGDTbZL/BlS5bqRy tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eje8vrrnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 19:35:42 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222JKjDa012777;
        Wed, 2 Mar 2022 19:35:42 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eje8vrrnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 19:35:42 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222JH7xf029028;
        Wed, 2 Mar 2022 19:35:41 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 3ej75rkame-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 19:35:41 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222JZarl49545526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 19:35:36 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A00B5124058;
        Wed,  2 Mar 2022 19:35:36 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA3A124053;
        Wed,  2 Mar 2022 19:35:35 +0000 (GMT)
Received: from [9.65.246.177] (unknown [9.65.246.177])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Mar 2022 19:35:35 +0000 (GMT)
Message-ID: <2b1f788b-5197-f5e8-52cf-58995d758ef7@linux.ibm.com>
Date:   Wed, 2 Mar 2022 14:35:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 07/18] s390/vfio-ap: refresh guest's APCB by filtering
 APQNs assigned to mdev
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-8-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220215005040.52697-8-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _RcO7d0u0cYt1yB1km8JWf_40HqjAlSu
X-Proofpoint-ORIG-GUID: QsjWVeOSp9uItcKEUmYZCf2q8ECZ-Eg3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 19:50, Tony Krowiak wrote:
> Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
> that do not reference an AP queue device bound to the vfio_ap device
> driver. The mdev's APQNs will be filtered according to the following rules:
> 
> * The APID of each adapter and the APQI of each domain that is not in the
> host's AP configuration is filtered out.
> 
> * The APID of each adapter comprising an APQN that does not reference a
> queue device bound to the vfio_ap device driver is filtered. The APQNs
> are derived from the Cartesian product of the APID of each adapter and
> APQI of each domain assigned to the mdev.
> 
> The control domains that are not assigned to the host's AP configuration
> will also be filtered before assigning them to the guest's APCB.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 96 ++++++++++++++++++++++++++++++-
>   1 file changed, 93 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4b676a55f203..b67b2f0faeea 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -317,6 +317,63 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>   }
>   
> +static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
> +		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
> +}
> +
> +/*
> + * vfio_ap_mdev_filter_matrix - copy the mdev's AP configuration to the KVM
> + *				guest's APCB then filter the APIDs that do not
> + *				comprise at least one APQN that references a
> + *				queue device bound to the vfio_ap device driver.
> + *
> + * @matrix_mdev: the mdev whose AP configuration is to be filtered.
> + */
> +static void vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
> +				       struct ap_matrix_mdev *matrix_mdev)
> +{
> +	int ret;
> +	unsigned long apid, apqi, apqn;
> +
> +	ret = ap_qci(&matrix_dev->info);
> +	if (ret)
> +		return;
> +
> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);

Do you need to call vfio_ap_matrix_init here? It seems to me like this would
only be necesarry if apxa could be dynamically added or removed. Here is a
copy of vfio_ap_matrix_init, for reference:

static void vfio_ap_matrix_init(struct ap_config_info *info,
				struct ap_matrix *matrix)
{
	matrix->apm_max = info->apxa ? info->Na : 63;
	matrix->aqm_max = info->apxa ? info->Nd : 15;
	matrix->adm_max = info->apxa ? info->Nd : 15;
}

It seems like this should be figured out once and stored when the
ap_matrix_mdev struct is first created. Unless I'm wrong, and the status of
apxa can change dynamically, in which case the maximums would need to be
updated somewhere.

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
