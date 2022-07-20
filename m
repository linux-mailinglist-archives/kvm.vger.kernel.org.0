Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0923E57BF55
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 22:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiGTUrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 16:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGTUr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 16:47:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFDD51A30;
        Wed, 20 Jul 2022 13:47:27 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KKkrD5008773;
        Wed, 20 Jul 2022 20:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=PXCc9V5i424eVXq6XuYSFn2k2F4T0ZQCulJ+y2jDyXw=;
 b=K3MKcKXlHSGKORzu/7GxTBIim80IVq4Mt6fOC4pthwc072WsE5ZmgJvztImrOs30wof8
 yMOV6feNcKzhdv911y+P+fqO63+zfasaUeFYIoCc/mL4aMaGj+MpOcRf73NDTHlvn57D
 OuHHGnVRfqLwF8f0ROvLkpks03jVAbxcHD7AIFrtpFG/3kB+fUvW+XNeWnde449WC+09
 i8x+VX8NOJIa71GcXvpryvEdMP/W+eqKrjJU3jX7BUOJdjGlLkmXk6662PONCPymvdNk
 tTymQqtuCcarTVOdGYMg3yfnltxN7VJzm7ip8xsvJnFuD7O/iry3IAgskV2lOI3c0SWE Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3herp7rn8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 20:47:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26KKkvkF009114;
        Wed, 20 Jul 2022 20:47:20 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3herp7rn82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 20:47:19 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26KKLUWD027125;
        Wed, 20 Jul 2022 20:47:19 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3hbmy9tnm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jul 2022 20:47:18 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26KKlHnt61735226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 20:47:17 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A903AAE060;
        Wed, 20 Jul 2022 20:47:17 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F40A1AE05C;
        Wed, 20 Jul 2022 20:47:14 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.146.30])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jul 2022 20:47:14 +0000 (GMT)
Message-ID: <65746aea193d4a814f895eca4b00b72cf29ac8f9.camel@linux.ibm.com>
Subject: Re: [PATCH 05/14] vfio/mdev: simplify mdev_type handling
From:   Eric Farman <farman@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Date:   Wed, 20 Jul 2022 16:47:13 -0400
In-Reply-To: <20220709045450.609884-6-hch@lst.de>
References: <20220709045450.609884-1-hch@lst.de>
         <20220709045450.609884-6-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LeTFFDCayeIQQckPjK9m0Nz8qL7MjNzM
X-Proofpoint-GUID: Cu7dwAIP90sG6U9bqXnn85oF_odgVOTP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-07-09 at 06:54 +0200, Christoph Hellwig wrote:
> Instead of abusing struct attribute_group to control initialization
> of
> struct mdev_type, just define the actual attributes in the
> mdev_driver,
> allocate the mdev_type structures in the caller and pass them to
> mdev_register_parent.
> 
> This allows the caller to use container_of to get at the containing
> structure and thus significantly simplify the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---

...snip...

> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index b71ffc5594870..80b2d546a3d98 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -90,35 +90,21 @@ static struct kobj_type mdev_type_ktype = {
>  	.release = mdev_type_release,
>  };
>  
> -static struct mdev_type *add_mdev_supported_type(struct mdev_parent
> *parent,
> -						 unsigned int
> type_group_id)
> +static int mdev_type_add(struct mdev_parent *parent, struct
> mdev_type *type)
>  {
> -	struct mdev_type *type;
> -	struct attribute_group *group =
> -		parent->mdev_driver-
> >supported_type_groups[type_group_id];
>  	int ret;
>  
> -	if (!group->name) {
> -		pr_err("%s: Type name empty!\n", __func__);
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	type = kzalloc(sizeof(*type), GFP_KERNEL);
> -	if (!type)
> -		return ERR_PTR(-ENOMEM);
> -

Since mdev_type is embedded in the parent and the alloc is removed,
shouldn't the kfree(type) in mdev_type_release() also be removed? (This
appears to be at least one of the causes of my system crashes.)

...snip.
..

