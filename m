Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCFE52BDEB
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 17:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiERPAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbiERPAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:00:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9031A0AFE;
        Wed, 18 May 2022 08:00:39 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IEgr6V017549;
        Wed, 18 May 2022 15:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xW1COiFlwf0PL00R4GkXtkJN3M/L1hWKr4zjOB9Yp9M=;
 b=pPZD/yxVLcy5VnDo5Jgh0tk0ovOcQbNqZ4LsoKnycLW3vfseSiMBUPwbrdCh3XYkBa3S
 DgyFVqTWd5g0nrN7qw+VokS94G2YSTFqMANSmq4yIjq1wEGkkD8sZLyluuqf7Ue2Xuqe
 kl/D3aV8yyOWgd3vWln/+e2hE53zPIedtzRhfg2lEgfHFpFKZh2LY1i0XqGLs4ob+dA/
 O1lZb3Q649ODOCRETCAXcpb58oExMIG07klJQSGFLiRy+BUse1iyqnDV0953MQyCAFpS
 PMU+PZ2Aw5ieGsVXdW+8SymNrZTZJVCbzoUDPNxTcZf19HekuYV1phtJXQKnAnxjtPnf Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g52t70e0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 15:00:21 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24IEhUDl019538;
        Wed, 18 May 2022 15:00:19 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g52t70dwk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 15:00:19 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IEbXS0011511;
        Wed, 18 May 2022 14:37:53 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3g2429w3t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 14:37:53 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24IEbrW721561800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 14:37:53 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 172B3124058;
        Wed, 18 May 2022 14:37:53 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D0B0124052;
        Wed, 18 May 2022 14:37:49 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 14:37:49 +0000 (GMT)
Message-ID: <2e51b388-48d0-4689-07f4-65f607dbce59@linux.ibm.com>
Date:   Wed, 18 May 2022 10:37:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     jgg@nvidia.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
In-Reply-To: <20220517180851.166538-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XQrM_ApcMDR7ZDvn9Jz1fR-tTzTwQMqx
X-Proofpoint-ORIG-GUID: OXJa_RJ2BtWJbsJAxvOQSjAKl28F0lCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_05,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180087
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 2:08 PM, Matthew Rosato wrote:
> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

...

> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfcff7764403..c5d421eda275 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -10,6 +10,7 @@
>    * Author: Tom Lyon, pugs@cisco.com
>    */
>   
> +#include "linux/kvm_host.h"
>   #include <linux/cdev.h>
>   #include <linux/compat.h>
>   #include <linux/device.h>
> @@ -1083,6 +1084,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   
>   	mutex_lock(&device->dev_set->lock);
>   	device->open_count++;
> +	down_write(&device->group->group_rwsem);
> +	if (device->open_count == 1 && device->group->kvm) {
> +		device->kvm = device->group->kvm;
> +		kvm_get_kvm(device->kvm);

Did some more compile testing, since vfio has no hard kvm dependency, 
kvm_get_kvm and kvm_put_kvm are an issue if KVM is a module while vfio 
is built-in...
