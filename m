Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE2C53BE56
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbiFBTFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238396AbiFBTFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:05:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31FE1179;
        Thu,  2 Jun 2022 12:04:59 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252H6JSk015034;
        Thu, 2 Jun 2022 19:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DukZOSDWRVxHTmZ8S12svqlnqdU+zUS7/m0tvzHawqo=;
 b=q5EsPytjwYo4883MFAxSh3c+mVCJjIoGvcSudxpwxg0GorxcKf1JJuIGM+wdoOlo6ZEI
 K8j6i2Hhaw+FVIPqFN4Gr7pHB/7GPkcKp+MisSJfRKwLnJf9EmXJ4C6n0NaU5eyD8xG0
 8zSrYo/LSC8NpxujQUqPdny3YlOt276qurEqG79fWtbHl7EWI+oGxtzU5U7M8+KLn0LK
 zzKqFsNnmArTGpbjWWbLMU/dCJp8/hSQedV3t64zfJayILHwpcGxFp9xTs8vuPiZOKOf
 1PHWgmuLR//jFcUJIPhgocv0O4+xnWbedkwNInPKwwBJLcpxUMpmxz7KPoCZ5N6+7vgK Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevu4qx1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:04:55 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252Iw4dU014113;
        Thu, 2 Jun 2022 19:04:55 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevu4qx15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:04:55 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252IowNh028904;
        Thu, 2 Jun 2022 19:04:54 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3gd1adbd7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 19:04:54 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252J4qM613697758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 19:04:53 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF66A78064;
        Thu,  2 Jun 2022 19:04:52 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D2417805C;
        Thu,  2 Jun 2022 19:04:52 +0000 (GMT)
Received: from [9.211.104.178] (unknown [9.211.104.178])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 19:04:51 +0000 (GMT)
Message-ID: <fccbb76c-41e4-da39-b758-3b091f3bbb1a@linux.ibm.com>
Date:   Thu, 2 Jun 2022 15:04:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 08/18] vfio/ccw: Check that private pointer is not NULL
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-9-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-9-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e--y6Qw8-tbBU5Kcnefai4EfUAGkW9lm
X-Proofpoint-GUID: yx8jq245CzxYBIehsb6UO7X1ak0ZqsIy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=993 adultscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020081
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/22 1:19 PM, Eric Farman wrote:
> The subchannel->dev->drvdata pointer is set in vfio_ccw_sch_probe()
> and cleared in vfio_ccw_sch_remove(). In a purely defensive move,
> let's check that the resultant pointer exists before operating on it
> any way, since some lifecycle changes are forthcoming.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++++
>   drivers/s390/cio/vfio_ccw_ops.c |  3 +++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 3784eb4cda85..f8226db26e54 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -41,6 +41,9 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
>   	DECLARE_COMPLETION_ONSTACK(completion);
>   	int iretry, ret = 0;
>   
> +	if (!private)
> +		return 0;
> +
>   	spin_lock_irq(sch->lock);
>   	if (!sch->schib.pmcw.ena)
>   		goto out_unlock;
> @@ -132,6 +135,9 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
>   
> +	if (WARN_ON(!private))
> +		return;
> +

I wonder, why a warning here vs quietly ignoring in all the other cases? 
(maybe add a small comment)

Also, kind of wondering what serialization is protecting the state of 
private (e.g. is it possible that you got a nonzero pointer from 
dev_get_drvdata but now it's been freed by a remove)


>   	inc_irq_stat(IRQIO_CIO);
>   	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
>   }
> @@ -260,6 +266,9 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
>   
> +	if (!private)
> +		return;
> +
>   	vfio_ccw_sch_quiesce(sch);
>   	mdev_unregister_device(&sch->dev);
>   
> @@ -293,6 +302,9 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
>   	unsigned long flags;
>   	int rc = -EAGAIN;
>   
> +	if (!private)
> +		return 0;
> +
>   	spin_lock_irqsave(sch->lock, flags);
>   	if (!device_is_registered(&sch->dev))
>   		goto out_unlock;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 497e1b7ffd61..9e5c184eab89 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -152,6 +152,9 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
>   
> +	if (!private)
> +		return;
> +
>   	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
>   			   private->sch->schid.cssid,
>   			   private->sch->schid.ssid,

