Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9E6562037
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 18:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbiF3QYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 12:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiF3QYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 12:24:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131763152A;
        Thu, 30 Jun 2022 09:24:14 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UFrHBn016677;
        Thu, 30 Jun 2022 16:24:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=VsXVub7i69OlSmt75b8fF6Rqo68g9H4j1XIDXGV7yoU=;
 b=JN/6JAfGGaa4KrUM1TuAJWE26nr9KGqWfuuhTdmKa5zXfi0hIMUUed+sba9QSNDqP8Hc
 3YJPMaBlHEGDRbn8MMRJdRBv0v2eFFNYIfT6G1LXmnCAyMP5zEGkOSVh8wRZ5dxzhJ2V
 xYSksb5jKjaCP0x6kWiZHBsnZbS4gQegki7+8JyOJ5n85NCxKKkGfDEjn0Xx5doAs9Zv
 ivppMSpvv/r0E2rNaFJrvLqUwEQydhArEKcHqIW4rIEjSeqPQ3kf/tehYMwRdIA0IVQ7
 hzZQn+iu4ByGyTBgxTXar1B6XmRWYfzP9JNbfEN3lle2Pi3ru1Q5uA2/s41Evz1ywHUE ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ev590u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 16:24:05 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UFrv7a018774;
        Thu, 30 Jun 2022 16:24:05 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1ev590tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 16:24:05 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UGMCmg030961;
        Thu, 30 Jun 2022 16:24:04 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 3gwt0b36dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 16:24:04 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UGO2UL27525502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 16:24:02 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7426BE051;
        Thu, 30 Jun 2022 16:24:02 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8791CBE04F;
        Thu, 30 Jun 2022 16:24:01 +0000 (GMT)
Received: from [9.160.92.179] (unknown [9.160.92.179])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jun 2022 16:24:01 +0000 (GMT)
Message-ID: <17a7c3f9-4566-899e-ed29-4e4c0d25ad7f@linux.ibm.com>
Date:   Thu, 30 Jun 2022 12:24:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH 08/13] vfio/mdev: remove mtype_get_parent_dev
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
References: <20220628051435.695540-1-hch@lst.de>
 <20220628051435.695540-9-hch@lst.de>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220628051435.695540-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ySV7g_ZkRnY77ocr37erDuKsnPOV1GRq
X-Proofpoint-ORIG-GUID: cuwRpwHpbp7COLTm-QA_wxCYQf8N7Ocq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/22 01:14, Christoph Hellwig wrote:
> Just open code the dereferences in the only user.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>   drivers/s390/cio/vfio_ccw_ops.c |  3 +--
>   drivers/vfio/mdev/mdev_core.c   | 10 ----------
>   include/linux/mdev.h            |  2 --
>   3 files changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 25b8d42a522ac..43d53736dfe3c 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -88,8 +88,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	struct vfio_ccw_private *private =
> -		dev_get_drvdata(mtype_get_parent_dev(mtype));
> +	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
>   
>   	return sprintf(buf, "%d\n", atomic_read(&private->avail));
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
