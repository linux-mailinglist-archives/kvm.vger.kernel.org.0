Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F8C6BC954
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 09:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCPIkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 04:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjCPIkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 04:40:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492497FD79;
        Thu, 16 Mar 2023 01:39:56 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32G76bri032424;
        Thu, 16 Mar 2023 08:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=GCU6TUnK15IcuCFHYnVPNn2CewBAXWOeqEbnXgPQbfg=;
 b=otOevIWGc0FvLkF3lpiJKY9J66epKrsRJJO6hnQGgUYODnq3+x9UDXHRF+FyZGoTMEHh
 UJqylDPUFj5ehfK0+lMM7NZMMqZ9IhJv6b410Qbxjg+V2RSV6NnrS2OZ908dm+TfQbtk
 86iQ4Le50rZmpYUr/DbRbybJs1SbRM1NVoCXGvc55hv5NcYhD+gZfkioWH4PObXkgTki
 vck7lGA7U0PNpuielGwGKLi25jpHnlfVVJLcz2xwjaxgAaHz44zlAaDs5SIPKQ0qU83T
 Hoz5VEBnKKilSedYxJO85e18t1RAHQTBZAdUQuz3y8irA593Yry+JeJULh10MfEKHlQN JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbt9q7rcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 08:39:55 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32G80BBD012000;
        Thu, 16 Mar 2023 08:39:54 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbt9q7rcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 08:39:54 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32G1tMvn022536;
        Thu, 16 Mar 2023 08:39:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pbsvb0ct1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 08:39:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32G8dnfE20644404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 08:39:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D3EF20043;
        Thu, 16 Mar 2023 08:39:49 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30C972004B;
        Thu, 16 Mar 2023 08:39:49 +0000 (GMT)
Received: from osiris (unknown [9.152.212.244])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 16 Mar 2023 08:39:49 +0000 (GMT)
Date:   Thu, 16 Mar 2023 09:39:48 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH] s390/vfio_ap: fix memory leak in vfio_ap device driver
Message-ID: <ZBLV1P2AkWdHht2r@osiris>
References: <20230315153932.165031-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315153932.165031-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XrhXcpnZQ2fq8KMbe_lu2BiGIgtuFslS
X-Proofpoint-GUID: s8aSbcDvwJP2mxehLt_GVtSthiXCyGpG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_06,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 11:39:32AM -0400, Tony Krowiak wrote:
> The device release callback function invoked to release the matrix device
> uses the dev_get_drvdata(device *dev) function to retrieve the
> pointer to the vfio_matrix_dev object in order to free its storage. The
> problem is, this object is not stored as drvdata with the device; since the
> kfree function will accept a NULL pointer, the memory for the
> vfio_matrix_dev object is never freed.
> 
> Since the device being released is contained within the vfio_matrix_dev
> object, the container_of macro will be used to retrieve its pointer.
> 
> Fixes: 1fde573413b5 ("s390: vfio-ap: base implementation of VFIO AP device driver")
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
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

Could you keep this code more readable, including adding the missing
blank line after the declaration, please? Something like:

static void vfio_ap_matrix_dev_release(struct device *dev)
{
	struct ap_matrix_dev *matrix_dev;

	matrix_dev = container_of(dev, struct ap_matrix_dev, device);
	kfree(matrix_dev);
}

Thanks!
