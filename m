Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E256BBAD0
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 18:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCORZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCORZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 13:25:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB46525E1F;
        Wed, 15 Mar 2023 10:25:39 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FHC6U9017486;
        Wed, 15 Mar 2023 17:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=bqXdSA4gmJf83mPxDDULhIgnmTET1iw6/02WOGu6qBk=;
 b=iYgTYmWYFUCqgGqR4xzaxqoSesru94n3yvzojsBf02d5vkbAImwbCKFAFVgGPq2SFcVT
 Zc10UOpuwIeaONJICEeABNYaHFLFHXJ5dvRSTN7Z0dtIQgSeHbKPtJPnXkGU3DX1g8xX
 6NmZhb1v+G0SS+dMhDv6faYQFs/ginCaVMr6+l9s+3rBEFm65G0PrUD6Owgp3WJkIriL
 vE+Y7BfqOtRxtQ/O63bmqq5RFJfoVB40Lm2Qlcn7JMxAdzAvdLpELz0i7YdRakYqXeXS
 9w5u1bHFLPQq45vOqUTMboJu8hfB0q+UdLiDVDf3P0EQDXlnIMXX85WO13yUe1+A0uSs Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbj740am9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 17:25:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FHCJ5r018632;
        Wed, 15 Mar 2023 17:25:38 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbj740akm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 17:25:38 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FH6dqF031172;
        Wed, 15 Mar 2023 17:25:37 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3pb29r4f0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 17:25:37 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FHPahK31457994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 17:25:36 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2A7E5805C;
        Wed, 15 Mar 2023 17:25:35 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5206958058;
        Wed, 15 Mar 2023 17:25:35 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 17:25:35 +0000 (GMT)
MIME-Version: 1.0
Date:   Wed, 15 Mar 2023 18:25:34 +0100
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH] s390/vfio_ap: fix memory leak in vfio_ap device driver
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20230315153932.165031-1-akrowiak@linux.ibm.com>
References: <20230315153932.165031-1-akrowiak@linux.ibm.com>
Message-ID: <b9be5d298de3ca70f8fa86a1b58cb4f2@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6h2Pzb7nBv1MTOxSFrtCzJgv--NFTbbH
X-Proofpoint-ORIG-GUID: VJZLKbXykvzvXzQu4UE-4DiBcxp-8qdV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150142
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-15 16:39, Tony Krowiak wrote:
> The device release callback function invoked to release the matrix 
> device
> uses the dev_get_drvdata(device *dev) function to retrieve the
> pointer to the vfio_matrix_dev object in order to free its storage. The
> problem is, this object is not stored as drvdata with the device; since 
> the
> kfree function will accept a NULL pointer, the memory for the
> vfio_matrix_dev object is never freed.
> 
> Since the device being released is contained within the vfio_matrix_dev
> object, the container_of macro will be used to retrieve its pointer.
> 
> Fixes: 1fde573413b5 ("s390: vfio-ap: base implementation of VFIO AP
> device driver")
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c
> b/drivers/s390/crypto/vfio_ap_drv.c
> index 997b524bdd2b..15e9de9f4574 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -54,8 +54,9 @@ static struct ap_driver vfio_ap_drv = {
> 
>  static void vfio_ap_matrix_dev_release(struct device *dev)
>  {
> -	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
> -
> +	struct ap_matrix_dev *matrix_dev = container_of(dev,
> +							struct ap_matrix_dev,
> +							device);
>  	kfree(matrix_dev);
>  }

I needed some indirections to follow what exactly happens here and how 
you
fix it, but finally I got it.
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
